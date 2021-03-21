//////////////////////////////////////////////////////////////////////////
//	Author: Drammel														//
//	Date: 2/27/2009														//
//	Title: bot9s_weapon													//
//	Description: GenerateAttackEffect is an adaptation of the script by //
//  the same name from Kaedrin's cmi_ginc_wpns script. As such, credit  //
//  for this excellent piece of work is his. The changes here are to    //
//  make it run with the Tome of Battle's scripts.  All scripts here    //
//  determine the damage a player generates.                            //
//////////////////////////////////////////////////////////////////////////

/*	Note to self: Many of the feat constants in MotB and SoZ aren't listed 
	in nwscript and therefore are not listed in the toolset.  Be sure to 
	check the manuals and feat.2da for any modifiers to these scripts.  These 
	feats must be listed as their number from feat.2da rather than as a 
	constant.

	12/22/2009: Switched from the system of linked effects to one of totaled 
	structs, which are then used to calculate damage in a single linked effect
	with each damage type.  While it won't entirely eliminate the issue of 
	Damage Reduction being applied to each source of damage, it does eliminate 
	the large amount of damage lost that was reduced.  The actual damage effect
	is now produced in BaseStrikeDamage in bot9s_inc_maneuvers.
	
	Special thanks to Psionic-Entity for bringing the matter to my attention and
	his thoughts on the subject.*/

#include "tob_x2_inc_itemprop"
#include "bot9s_inc_2da"
#include "bot9s_inc_constants"
#include "bot9s_inc_variables"
#include "bot9s_include"
#include "bot9s_attack"
#include "bot9s_inc_feats"

struct main_damage
{
	int nSlash;
	int nBlunt;
	int nPierce;
	int nAcid;
	int nCold;
	int nElec;
	int nFire;
	int nSonic;
	int nDivine;
	int nMagic;
	int nPosit;
	int nNegat;
};

// Prototypes

// The main weapon damage calculation function.
// -nMisc: Adds a damage bonus to the weapon's base damage type.
// -bIgnoreResistances: When set to true the damage of this effect will ignore
// the targeted enemey's resistances to damage.
// -nMult: Number to multiply total damage by.  Defaults to one.
struct main_damage GenerateAttackEffect(object oPC, object oWeapon, object oTarget, int nMisc = 0, int bIgnoreResistances = FALSE, int nMult = 1);

// Calculates effects from item properties.
struct main_damage GenerateItemProperties(object oPC, object oWeapon, object oTarget, int bIgnoreResistances = FALSE, int nMult = 1);

// Calculates Sneak Attack Damage
struct main_damage SneakAttack(object oWeapon, object oPC, object oFoe, int bIgnoreResistances = FALSE);

// Applies instant critical hit damage to calculations.
struct main_damage StrikeCriticalEffect(object oPC, object oWeapon, object oTarget, int bIgnoreResistances = FALSE, int nMult = 1);

// Simulates the effects of Invisible Blade's Bleeding Wound.
// Only meant for use in conjunction with SneakAttack.
effect IBBleedingWound();

// Debuffs the Target's AC for one round.
effect MissileVolley(object oPC, object oWeapon);


// Functions

// The main weapon damage calculation function.
// -nMisc: Adds a damage bonus to the weapon's base damage type.
// -bIgnoreResistances: When set to true the damage of this effect will ignore
// the targeted enemey's resistances to damage.
// -nMult: Number to multiply total damage by.  Defaults to one.
struct main_damage GenerateAttackEffect(object oPC, object oWeapon, object oTarget, int nMisc = 0, int bIgnoreResistances = FALSE, int nMult = 1)
{
	struct main_damage main;
	int nSlash, nBlunt, nPierce, nAcid, nCold, nElec, nFire, nSonic, nDivine, nMagic, nPosit, nNegat;

	object oToB = GetItemPossessedBy(oPC, "tob");
	object oLeftHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND); //Creature type ignored here because this is only included for weapon size mods which claws do not influence.
	int nBaseItemType = GetBaseItemType(oWeapon); 
	int nIsRanged = GetWeaponRanged(oWeapon);
	int nBasedice = tob_Get2daInt("baseitems", "DieToRoll", nBaseItemType);
	int nDiceNum = tob_Get2daInt("baseitems", "NumDice", nBaseItemType);
	int nBaseDamage = GetDamageByDice(nBasedice, nDiceNum);
	int nWeaponType = GetWeaponType(oWeapon);	
	int nStrMod = GetAbilityModifier(ABILITY_STRENGTH, oPC);
	int nIntMod = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);

/*	Drammel's Note: Split up GenerateAttackEffect into GenerateAttackEffect
	and GenerateItemProperties to better simulate critical hit rules. Only
	enchantment bonuses have been left in this function.

	8/11/2009: Adjusting for monster damage.  Since the creature slot weapons
	use a special monster damage itemproptery for base damage they're being
	added here.*/

	// Apply Feat damage.

	if ((GetHasFeat(1957, oPC)) && (nIntMod > nStrMod))//Combat Insight
	{
		if (!nIsRanged)
		{
			if (!GetIsObjectValid(oLeftHand))
			{
				//Two-Handed
				nStrMod = nStrMod + (((nIntMod - nStrMod)*3)/2);
			}
			else
			{
				//One-Handed
				nStrMod = nStrMod + (nIntMod - nStrMod);
			}	
		}			
	}

	if ((nIsRanged == TRUE) && (GetHasFeat(FEAT_POINT_BLANK_SHOT, oPC)))
	{
		float fDist = GetDistanceToObject(oTarget);
		
		if (fDist <= FeetToMeters(15.0f) + GetGirth(oPC))
		{
			nStrMod += 1;
		}
	}

	if ((GetHasFeat(2141, oPC)) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))) //Swashbuckler's Insightful Strike
	{
		object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
		
		if ((GetArmorRank(oArmor) == ARMOR_RANK_LIGHT) || (GetArmorRank(oArmor) == ARMOR_RANK_NONE))
		{
			if (GetIsLightWeapon(oWeapon, oPC))
			{
				nStrMod += nIntMod;
			}
		}
	}

	if (GetIsFavoredEnemy(oPC, oTarget)) // Favored Enemy
	{
		int nLevel = GetLevelByClass(CLASS_TYPE_RANGER, oPC);
		
		if (nLevel > 29)
		{
			nStrMod += 7;
		}
		else if (nLevel > 24)
		{
			nStrMod += 6;
		}
		else if (nLevel > 19)
		{
			nStrMod += 5;
		}
		else if (nLevel > 14)
		{
			nStrMod += 4;
		}
		else if (nLevel > 9)
		{
			nStrMod += 3;
		}
		else if (nLevel > 4)
		{
			nStrMod += 2;
		}
		else nStrMod += 1;

		if (GetIsImpFavoredEnemy(oPC, oTarget)) // Improved Favored Enemy
		{
			nStrMod += 3;
		}

		if (GetHasFeat(FEAT_EPIC_BANE_OF_ENEMIES, oPC))
		{
			nStrMod += GetDamageByDice(6, 2);
		}
	}

	if (GetActionMode(oPC, ACTION_MODE_POWER_ATTACK))
	{
		if (GetHasFeat(FEAT_ENHANCED_POWER_ATTACK))
		{
			if ((GetIsFavoredEnemyPA(oPC, oTarget)) && (!GetIsObjectValid(oLeftHand)))
			{
				nStrMod += 15;
			}
			else if (GetIsFavoredEnemyPA(oPC, oTarget))
			{
				nStrMod += 10;
			}
			else nStrMod += 5;
		}
		else if (GetHasFeat(FEAT_SUPREME_POWER_ATTACK))
		{
			if ((GetIsFavoredEnemyPA(oPC, oTarget)) && (!GetIsObjectValid(oLeftHand)))
			{
				nStrMod += 18;
			}
			else if (GetIsFavoredEnemyPA(oPC, oTarget))
			{
				nStrMod += 12;
			}
			else nStrMod += 6;
		}
		else if ((GetIsFavoredEnemyPA(oPC, oTarget)) && (!GetIsObjectValid(oLeftHand)))
		{
			nStrMod += 9;
		}
		else if (GetIsFavoredEnemyPA(oPC, oTarget))
		{
			nStrMod += 6;
		}
		else nStrMod += 3;
	}
	else if (GetActionMode(oPC, ACTION_MODE_IMPROVED_POWER_ATTACK))
	{
		if (GetHasFeat(FEAT_ENHANCED_POWER_ATTACK))
		{
			if ((GetIsFavoredEnemyPA(oPC, oTarget)) && (!GetIsObjectValid(oLeftHand)))
			{
				nStrMod += 30;
			}
			else if (GetIsFavoredEnemyPA(oPC, oTarget))
			{
				nStrMod += 20;
			}
			else nStrMod += 10;
		}
		else if (GetHasFeat(FEAT_SUPREME_POWER_ATTACK))
		{
			if ((GetIsFavoredEnemyPA(oPC, oTarget)) && (!GetIsObjectValid(oLeftHand)))
			{
				nStrMod += 36;
			}
			else if (GetIsFavoredEnemyPA(oPC, oTarget))
			{
				nStrMod += 24;
			}
			else nStrMod += 12;
		}
		else if ((GetIsFavoredEnemyPA(oPC, oTarget)) && (!GetIsObjectValid(oLeftHand)))
		{
			nStrMod += 18;
		}
		else if (GetIsFavoredEnemyPA(oPC, oTarget))
		{
			nStrMod += 12;
		}
		else nStrMod += 6;
	}

	if (GetHasFeat(FEAT_EPIC_PROWESS, oPC))
	{
		nStrMod += 1;
	}

	// Wpn Spec, Epic Wpn Spec
	if (GetIsObjectValid(oWeapon))
	{
		int iWeapon = GetBaseItemType(oWeapon);
		int nWSFeat = tob_Get2daInt("baseitems", "FEATWpnSpec", iWeapon);
		int nEWSFeat = tob_Get2daInt("baseitems", "FEATEpicWpnSpec", iWeapon);

		if (GetHasFeat(nEWSFeat, oPC))
		{
			nStrMod += 6; //Operating under the asumption that Epic and normal Weapon Spec stack.
		}
		else if (GetHasFeat(nWSFeat, oPC))
		{
			nStrMod += 2;
		}
	}
	else if (GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_UNARMED, oPC))
	{
		nStrMod += 6;
	}
	else if (GetHasFeat(FEAT_WEAPON_SPECIALIZATION_UNARMED_STRIKE, oPC))
	{
		nStrMod += 2;
	}

	if ((GetHasFeat(FEAT_TW_CIRCLE_OF_BLADES)) && (IsFlankValid(oPC, oTarget)))
	{
		nStrMod += 2;
	}

	// Swordsage's Insightful Strike
	if (GetLevelByClass(CLASS_TYPE_SWORDSAGE, oPC) > 3)
	{// The order of the logic is different here than in Blade Meditation.  It is assumed that as a class 
	 // feature, the Swordsage most likely has one of the feats, making the type of Strike check a better eliminator.
		if (GetLocalInt(oToB, "DesertWindStrike") == 1)
		{
			if (GetHasFeat(FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_DW, oPC) || GetHasFeat(FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_DW2, oPC))
			{
				int nWis = GetAbilityModifier(ABILITY_WISDOM);
				nStrMod += nWis;
			}
		}
		else if (GetLocalInt(oToB, "DiamondMindStrike") == 1)
		{
			if (GetHasFeat(FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_DM, oPC) || GetHasFeat(FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_DM2, oPC))
			{
				int nWis = GetAbilityModifier(ABILITY_WISDOM);
				nStrMod += nWis;
			}
		}
		else if (GetLocalInt(oToB, "SettingSunStrike") == 1)
		{
			if (GetHasFeat(FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_SS, oPC) || GetHasFeat(FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_SS2, oPC))
			{
				int nWis = GetAbilityModifier(ABILITY_WISDOM);
				nStrMod += nWis;
			}
		}
		else if (GetLocalInt(oToB, "ShadowHandStrike") == 1)
		{
			if (GetHasFeat(FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_SH, oPC) || GetHasFeat(FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_SH2, oPC))
			{
				int nWis = GetAbilityModifier(ABILITY_WISDOM);
				nStrMod += nWis;
			}
		}
		else if (GetLocalInt(oToB, "StoneDragonStrike") == 1)
		{
			if (GetHasFeat(FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_SD, oPC) || GetHasFeat(FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_SD2, oPC))
			{
				int nWis = GetAbilityModifier(ABILITY_WISDOM);
				nStrMod += nWis;
			}
		}
		else if (GetLocalInt(oToB, "TigerClawStrike") == 1)
		{
			if (GetHasFeat(FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_TC, oPC) || GetHasFeat(FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_TC2, oPC))
			{
				int nWis = GetAbilityModifier(ABILITY_WISDOM);
				nStrMod += nWis;
			}
		}
	}

	if ((GetHasFeat(FEAT_BLADE_MEDITATION_DW, oPC)) && (GetLocalInt(oToB, "DesertWindStrike") == 1))
	{
		nStrMod += 1;
	}

	if ((GetHasFeat(FEAT_BLADE_MEDITATION_DS, oPC)) && (GetLocalInt(oToB, "DevotedSpiritStrike") == 1))
	{
		nStrMod += 1;
	}

	if ((GetHasFeat(FEAT_BLADE_MEDITATION_DM, oPC)) && (GetLocalInt(oToB, "DiamondMindStrike") == 1))
	{
		nStrMod += 1;
	}

	if ((GetHasFeat(FEAT_BLADE_MEDITATION_IH, oPC)) && (GetLocalInt(oToB, "IronHeartStrike") == 1))
	{
		nStrMod += 1;
	}

	if ((GetHasFeat(FEAT_BLADE_MEDITATION_SS, oPC)) && (GetLocalInt(oToB, "SettingSunStrike") == 1))
	{
		nStrMod += 1;
	}

	if ((GetHasFeat(FEAT_BLADE_MEDITATION_SH, oPC)) && (GetLocalInt(oToB, "ShadowHandStrike") == 1))
	{
		nStrMod += 1;
	}

	if ((GetHasFeat(FEAT_BLADE_MEDITATION_SD, oPC)) && (GetLocalInt(oToB, "StoneDragonStrike") == 1))
	{
		nStrMod += 1;
	}

	if ((GetHasFeat(FEAT_BLADE_MEDITATION_TC, oPC)) && (GetLocalInt(oToB, "TigerClawStrike") == 1))
	{
		nStrMod += 1;
	}

	if ((GetHasFeat(FEAT_BLADE_MEDITATION_WR, oPC)) && (GetLocalInt(oToB, "WhiteRavenStrike") == 1))
	{
		nStrMod += 1;
	}

	nStrMod += nBaseDamage;
	nStrMod += nMisc;

	if (GetHasFeat(FEAT_PRECISE_STRIKE, oPC))
	{
		if (!GetIsObjectValid(oLeftHand) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)))
		{
			//Nothing in the left hand
			if (nWeaponType == WEAPON_TYPE_PIERCING || nWeaponType == WEAPON_TYPE_PIERCING_AND_SLASHING)
			{
				//Valid Precise Strike weapon
				if (GetLevelByClass(CLASS_TYPE_DUELIST, oPC) > 9)
				{
					nPierce += GetDamageByDice(6, 2);
				}
				else nPierce += GetDamageByDice(6, 1);
			}
		}	
	}

	// Apply weapon modifiying damage.

	if (nWeaponType == WEAPON_TYPE_SLASHING || nWeaponType == WEAPON_TYPE_PIERCING_AND_SLASHING)
	{
		nSlash += nStrMod;
	}
	else if (nWeaponType == WEAPON_TYPE_PIERCING)
	{
		nPierce += nStrMod;
	}
	else nBlunt += nStrMod;

	// Apply effect damage.

	effect eEffect = GetFirstEffect(oPC);

	while (GetIsEffectValid(eEffect))
	{
		int nType = GetEffectType(eEffect);

		if (nType == EFFECT_TYPE_DAMAGE_INCREASE)
		{
			int nDamage = GetDamageByDamageBonus(GetEffectInteger(eEffect, 0)); //DamageBonus
			
			switch (GetEffectInteger(eEffect, 1))  //DamageType
			{
				case DAMAGE_TYPE_ACID:			nAcid += nDamage; 	break;		
				case DAMAGE_TYPE_BLUDGEONING:	nBlunt += nDamage;	break;		
				case DAMAGE_TYPE_COLD:			nCold += nDamage;	break;		
				case DAMAGE_TYPE_DIVINE:		nDivine += nDamage;	break;				
				case DAMAGE_TYPE_ELECTRICAL:	nElec += nDamage;	break;					
				case DAMAGE_TYPE_FIRE:			nFire += nDamage;	break;		
				case DAMAGE_TYPE_MAGICAL:		nMagic += nDamage;	break;		
				case DAMAGE_TYPE_NEGATIVE:		nNegat += nDamage;	break;			
				case DAMAGE_TYPE_PIERCING:		nPierce += nDamage;	break;		
				case DAMAGE_TYPE_POSITIVE:		nPosit += nDamage;	break;		
				case DAMAGE_TYPE_SLASHING:		nSlash += nDamage;	break;		
				case DAMAGE_TYPE_SONIC:			nSonic += nDamage;	break;					
			}											
		}
		else if (nType == EFFECT_TYPE_DAMAGE_DECREASE)
		{
			int nDamage = GetDamageByDamageBonus(GetEffectInteger(eEffect, 0)); //DamageBonus
			
			switch (GetEffectInteger(eEffect, 1))  //DamageType
			{
				case DAMAGE_TYPE_ACID:			nAcid -= nDamage; 	break;		
				case DAMAGE_TYPE_BLUDGEONING:	nBlunt -= nDamage;	break;		
				case DAMAGE_TYPE_COLD:			nCold -= nDamage;	break;		
				case DAMAGE_TYPE_DIVINE:		nDivine -= nDamage;	break;				
				case DAMAGE_TYPE_ELECTRICAL:	nElec -= nDamage;	break;					
				case DAMAGE_TYPE_FIRE:			nFire -= nDamage;	break;		
				case DAMAGE_TYPE_MAGICAL:		nMagic -= nDamage;	break;		
				case DAMAGE_TYPE_NEGATIVE:		nNegat -= nDamage;	break;			
				case DAMAGE_TYPE_PIERCING:		nPierce -= nDamage;	break;		
				case DAMAGE_TYPE_POSITIVE:		nPosit -= nDamage;	break;		
				case DAMAGE_TYPE_SLASHING:		nSlash -= nDamage;	break;		
				case DAMAGE_TYPE_SONIC:			nSonic -= nDamage;	break;					
			}											
		}
		eEffect = GetNextEffect(oPC);
	}

	int nEnhance = 0;
	int nProp;

	itemproperty iProp;

	iProp = GetFirstItemProperty(oWeapon);

	while (GetIsItemPropertyValid(iProp))
	{
		nProp = GetItemPropertyType(iProp);

		if (nProp == ITEM_PROPERTY_ENHANCEMENT_BONUS)
		{
		  	int nItemEnhance = GetItemPropertyCostTableValue(iProp); //Enhance bonus
			if (nItemEnhance > nEnhance)
				nEnhance = nItemEnhance;
		}
		else if (nProp == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP)
		{	
			int nGoodEvil = GetAlignmentGoodEvil(oTarget);
			int nLawChaos = GetAlignmentLawChaos(oTarget);

			if ((GetItemPropertySubType(iProp) == nGoodEvil) || (GetItemPropertySubType(iProp) == nLawChaos))
			{
				int nDamage = GetDamageByIPConstDamageBonus(GetItemPropertyCostTableValue(iProp));	
				nEnhance += nDamage;
			}
		}
		else if (nProp == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP)
		{
			int nTargetRace = GetRacialType(oTarget);

			if (GetItemPropertySubType(iProp) == nTargetRace)
			{
				int nDamage = GetDamageByIPConstDamageBonus(GetItemPropertyCostTableValue(iProp));
				nEnhance += nDamage;
			}
		}
		else if (nProp == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT)
		{
			int nAlignment = GetAlignment(oTarget);

			if (GetItemPropertySubType(iProp) == nAlignment)
			{
				int nDamage = GetDamageByIPConstDamageBonus(GetItemPropertyCostTableValue(iProp));
				nEnhance += nDamage;
			}
		}
		else if (nProp == ITEM_PROPERTY_MONSTER_DAMAGE)
		{
			int nMonster = GetItemPropertyCostTableValue(iProp);

			switch (nMonster) // Monsters should get no Aura of Chaos, so it's okay to do it this way.
			{
				case IP_CONST_MONSTERDAMAGE_1d2:	nEnhance += d2(1);	break;
				case IP_CONST_MONSTERDAMAGE_1d3:	nEnhance += d3(1);	break;
				case IP_CONST_MONSTERDAMAGE_1d4:	nEnhance += d4(1);	break;
				case IP_CONST_MONSTERDAMAGE_1d6:	nEnhance += d6(1);	break;
				case IP_CONST_MONSTERDAMAGE_1d8:	nEnhance += d8(1);	break;
				case IP_CONST_MONSTERDAMAGE_1d10:	nEnhance += d10(1);	break;
				case IP_CONST_MONSTERDAMAGE_1d12:	nEnhance += d12(1);	break;
				case IP_CONST_MONSTERDAMAGE_1d20:	nEnhance += d20(1);	break;
				case IP_CONST_MONSTERDAMAGE_2d4:	nEnhance += d4(2);	break;
				case IP_CONST_MONSTERDAMAGE_2d6:	nEnhance += d6(2);	break;
				case IP_CONST_MONSTERDAMAGE_2d8:	nEnhance += d8(2);	break;
				case IP_CONST_MONSTERDAMAGE_2d10:	nEnhance += d10(2);	break;
				case IP_CONST_MONSTERDAMAGE_2d12:	nEnhance += d12(2);	break;
				case IP_CONST_MONSTERDAMAGE_2d20:	nEnhance += d20(2);	break;
				case IP_CONST_MONSTERDAMAGE_3d4:	nEnhance += d4(3);	break;
				case IP_CONST_MONSTERDAMAGE_3d6:	nEnhance += d6(3);	break;
				case IP_CONST_MONSTERDAMAGE_3d8:	nEnhance += d8(3);	break;
				case IP_CONST_MONSTERDAMAGE_3d10:	nEnhance += d10(3);	break;
				case IP_CONST_MONSTERDAMAGE_3d12:	nEnhance += d12(3);	break;
				case IP_CONST_MONSTERDAMAGE_3d20:	nEnhance += d20(3);	break;
				case IP_CONST_MONSTERDAMAGE_4d4:	nEnhance += d4(4);	break;
				case IP_CONST_MONSTERDAMAGE_4d6:	nEnhance += d6(4);	break;
				case IP_CONST_MONSTERDAMAGE_4d8:	nEnhance += d8(4);	break;
				case IP_CONST_MONSTERDAMAGE_4d10:	nEnhance += d10(4);	break;
				case IP_CONST_MONSTERDAMAGE_4d12:	nEnhance += d12(4);	break;
				case IP_CONST_MONSTERDAMAGE_4d20:	nEnhance += d20(4);	break;
				case IP_CONST_MONSTERDAMAGE_5d4:	nEnhance += d4(5);	break;
				case IP_CONST_MONSTERDAMAGE_5d6:	nEnhance += d6(5);	break;
				case IP_CONST_MONSTERDAMAGE_5d8:	nEnhance += d8(5);	break;
				case IP_CONST_MONSTERDAMAGE_5d10:	nEnhance += d10(5);	break;
				case IP_CONST_MONSTERDAMAGE_5d12:	nEnhance += d12(5);	break;
				case IP_CONST_MONSTERDAMAGE_5d20:	nEnhance += d20(5);	break;
				case IP_CONST_MONSTERDAMAGE_6d6:	nEnhance += d6(6);	break;
				case IP_CONST_MONSTERDAMAGE_6d8:	nEnhance += d8(6);	break;
				case IP_CONST_MONSTERDAMAGE_6d10:	nEnhance += d10(6);	break;
				case IP_CONST_MONSTERDAMAGE_6d12:	nEnhance += d12(6);	break;
				case IP_CONST_MONSTERDAMAGE_6d20:	nEnhance += d20(6);	break;
				case IP_CONST_MONSTERDAMAGE_7d6:	nEnhance += d6(7);	break;
				case IP_CONST_MONSTERDAMAGE_7d8:	nEnhance += d8(7);	break;
				case IP_CONST_MONSTERDAMAGE_7d10:	nEnhance += d10(7);	break;
				case IP_CONST_MONSTERDAMAGE_7d12:	nEnhance += d12(7);	break;
				case IP_CONST_MONSTERDAMAGE_7d20:	nEnhance += d20(7);	break;
				case IP_CONST_MONSTERDAMAGE_8d6:	nEnhance += d6(8);	break;
				case IP_CONST_MONSTERDAMAGE_8d8:	nEnhance += d8(8);	break;
				case IP_CONST_MONSTERDAMAGE_8d10:	nEnhance += d10(8);	break;
				case IP_CONST_MONSTERDAMAGE_8d12:	nEnhance += d12(8);	break;
				case IP_CONST_MONSTERDAMAGE_8d20:	nEnhance += d20(8);	break;
				case IP_CONST_MONSTERDAMAGE_9d6:	nEnhance += d6(9);	break;
				case IP_CONST_MONSTERDAMAGE_9d8:	nEnhance += d8(9);	break;
				case IP_CONST_MONSTERDAMAGE_9d10:	nEnhance += d10(9);	break;
				case IP_CONST_MONSTERDAMAGE_9d12:	nEnhance += d12(9);	break;
				case IP_CONST_MONSTERDAMAGE_9d20:	nEnhance += d20(9);	break;
				case IP_CONST_MONSTERDAMAGE_10d6:	nEnhance += d6(10);	break;
				case IP_CONST_MONSTERDAMAGE_10d8:	nEnhance += d8(10);	break;
				case IP_CONST_MONSTERDAMAGE_10d10:	nEnhance += d10(10);break;
				case IP_CONST_MONSTERDAMAGE_10d12:	nEnhance += d12(10);break;
				case IP_CONST_MONSTERDAMAGE_10d20:	nEnhance += d20(10);break; //I never want to fight the thing that does this!
			}
		}
		else if (nProp == ITEM_PROPERTY_DECREASED_DAMAGE || nProp == ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER)
		{
			int nPenalty = GetItemPropertyCostTableValue(iProp);

			if (nPenalty < nEnhance)
			{
				nEnhance -= nPenalty;
			}
		}	
		iProp = GetNextItemProperty(oWeapon);
	}

	if (nWeaponType == WEAPON_TYPE_SLASHING || nWeaponType == WEAPON_TYPE_PIERCING_AND_SLASHING)
	{
		nSlash += nEnhance;
	}
	else if (nWeaponType == WEAPON_TYPE_PIERCING)
	{
		nPierce += nEnhance;
	}
	else nBlunt += nEnhance;

	if (nIsRanged == TRUE)  // Gets bonuses from ammo as well as the bow, if it was called by the last set of routines.
	{
		int nBaseType = GetBaseItemType(oWeapon);
		int nEnhance = 0;

		object oAmmo;
		if (nBaseType == BASE_ITEM_LIGHTCROSSBOW || nBaseType == BASE_ITEM_HEAVYCROSSBOW)
			oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS);
		if (nBaseType == BASE_ITEM_LONGBOW || nBaseType == BASE_ITEM_SHORTBOW)
			oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS);
		if (nBaseType == BASE_ITEM_SLING)
			oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS);						

		itemproperty iProp = GetFirstItemProperty(oAmmo);

		while (GetIsItemPropertyValid(iProp))
		{
			if (GetItemPropertyType(iProp) == ITEM_PROPERTY_ENHANCEMENT_BONUS)
			{
			  	int nItemEnhance = GetItemPropertyCostTableValue(iProp); //Enhance bonus
				if (nItemEnhance > nEnhance)
					nEnhance = nItemEnhance;
			}			
			iProp = GetNextItemProperty(oAmmo);
		}

		if (nWeaponType == WEAPON_TYPE_SLASHING || nWeaponType == WEAPON_TYPE_PIERCING_AND_SLASHING)
		{	
			nSlash += nEnhance;
		}
		else if (nWeaponType == WEAPON_TYPE_PIERCING)
		{
			nPierce += nEnhance;
		}
		else nBlunt += nEnhance;
	}

	nSlash *= nMult;
	nBlunt *= nMult;
	nPierce *= nMult;
	nAcid *= nMult;
	nCold *= nMult;
	nElec *= nMult;
	nFire *= nMult;
	nSonic*= nMult;
	nDivine *= nMult;
	nMagic *= nMult;
	nPosit *= nMult;
	nNegat *= nMult;

	// Convert all damage to fire damage if we're using the maneuver Burning Brand.
	if (GetLocalInt(oPC, "BurningBrand") == 1)
	{
		if (nPierce > 0)
		{
			nFire += nPierce;
			nPierce = 0;
		}

		if (nBlunt > 0)
		{
			nFire += nBlunt;
			nBlunt = 0;
		}

		if (nSlash > 0)
		{
			nFire += nSlash;
			nSlash = 0;
		}

		if (nAcid > 0)
		{
			nFire += nAcid;
			nAcid = 0;
		}

		if (nCold > 0)
		{
			nFire += nCold;
			nCold = 0;
		}

		if (nSonic > 0)
		{
			nFire += nSonic;
			nSonic = 0;
		}

		if (nDivine > 0)
		{
			nFire += nDivine;
			nDivine = 0;
		}

		if (nElec > 0)
		{
			nFire += nElec;
			nElec = 0;
		}

		if (nMagic > 0)
		{
			nFire += nMagic;
			nMagic = 0;
		}

		if (nPosit > 0)
		{
			nFire += nPosit;
			nPosit = 0;
		}

		if (nNegat > 0)
		{
			nFire += nNegat;
			nNegat = 0;
		}
	}

	//Time to build a mega damage event.

	if (!GetIsObjectValid(oWeapon))
	{
		// Calling this function stores data to be used for calculating the struct.
		effect eDmg = SnapKickDamage(); // Fortunately, Snap Kick will get apporpiate unarmed damage and runs a check for Superior Unarmed Strike.
		int nSnapDamage = GetLocalInt(oPC, "SnapKickStoredDam");
		int nSnapType = GetLocalInt(oPC, "SnapKickType");

		if (nSnapType == DAMAGE_TYPE_BLUDGEONING)
		{
			nBlunt += nSnapDamage;
		}
		else nMagic += nSnapDamage;
	}

	if (nBlunt > 0)
	{
		if ((GetLevelByClass(CLASS_TYPE_MONK, oPC) > 15) && (!GetIsObjectValid(oWeapon)))
		{
			nMagic += nBlunt;
			nBlunt = 0;
		}
	}

	int nStrikeTotal = GetLocalInt(oPC, "bot9s_StrikeTotal");
	int nStrike = nSlash + nBlunt + nPierce + nAcid + nCold + nElec + nFire + nSonic + nDivine + nMagic + nPosit + nNegat;

	// Used in certain strikes.  The variable must be cleared out in the strike script or the damage will continue to pile.
	SetLocalInt(oPC, "bot9s_StrikeTotal", nStrikeTotal + nStrike);

	main.nPierce = nPierce;
	main.nAcid = nAcid;
	main.nSlash = nSlash;
	main.nBlunt = nBlunt;
	main.nCold = nCold;
	main.nElec = nElec;			
	main.nFire = nFire;
	main.nSonic = nSonic;
	main.nDivine = nDivine;
	main.nMagic = nMagic;			
	main.nPosit = nPosit;
	main.nNegat = nNegat;

	return main;	
}

// Calculates effects from item properties.
struct main_damage GenerateItemProperties(object oPC, object oWeapon, object oTarget, int bIgnoreResistances = FALSE, int nMult = 1)
{
	struct main_damage main;
	int nSlash, nBlunt, nPierce, nAcid, nCold, nElec, nFire, nSonic, nDivine, nMagic, nPosit, nNegat;

	int nBaseItemType = GetBaseItemType(oWeapon); 
	int nIsRanged = GetWeaponRanged(oWeapon);
	int nProp;
		
	itemproperty iProp;

	iProp = GetFirstItemProperty(oWeapon);

	while (GetIsItemPropertyValid(iProp))
	{
		nProp = GetItemPropertyType(iProp);

		if (nProp == ITEM_PROPERTY_DAMAGE_BONUS)
		{	
			int nDamage = GetDamageByIPConstDamageBonus(GetItemPropertyCostTableValue(iProp));
			
			switch (GetItemPropertySubType(iProp))  //DamageType
			{
				case IP_CONST_DAMAGETYPE_ACID:			nAcid += nDamage;	break;				
				case IP_CONST_DAMAGETYPE_BLUDGEONING:	nBlunt += nDamage;	break;				
				case IP_CONST_DAMAGETYPE_COLD:			nCold += nDamage;	break;		
				case IP_CONST_DAMAGETYPE_DIVINE:		nDivine += nDamage;	break;						
				case IP_CONST_DAMAGETYPE_ELECTRICAL:	nElec += nDamage;	break;				
				case IP_CONST_DAMAGETYPE_FIRE:			nFire += nDamage;	break;				
				case IP_CONST_DAMAGETYPE_MAGICAL:		nMagic += nDamage;	break;			
				case IP_CONST_DAMAGETYPE_NEGATIVE:		nNegat += nDamage;	break;			
				case IP_CONST_DAMAGETYPE_PHYSICAL:		nSlash += nDamage;	break;		
				case IP_CONST_DAMAGETYPE_PIERCING:		nPierce += nDamage;	break;					
				case IP_CONST_DAMAGETYPE_POSITIVE:		nPosit += nDamage;	break;					
				case IP_CONST_DAMAGETYPE_SLASHING:		nSlash += nDamage;	break;				
				case IP_CONST_DAMAGETYPE_SONIC:			nSonic += nDamage;	break;																														
			}
		}
		else if (nProp == ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP)
		{	
			int nGoodEvil = GetAlignmentGoodEvil(oTarget);
			int nLawChaos = GetAlignmentLawChaos(oTarget);

			if ((GetItemPropertySubType(iProp) == nGoodEvil) || (GetItemPropertySubType(iProp) == nLawChaos))
			{
				int nDamage = GetDamageByIPConstDamageBonus(GetItemPropertyCostTableValue(iProp));	
				nMagic += nDamage;
			}
		}
		else if (nProp == ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP)
		{
			int nTargetRace = GetRacialType(oTarget);

			if (GetItemPropertySubType(iProp) == nTargetRace)
			{
				int nDamage = GetDamageByIPConstDamageBonus(GetItemPropertyCostTableValue(iProp));
				nMagic += nDamage;
			}
		}
		else if (nProp == ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT)
		{
			int nAlignment = GetAlignment(oTarget);

			if (GetItemPropertySubType(iProp) == nAlignment)
			{
				int nDamage = GetDamageByIPConstDamageBonus(GetItemPropertyCostTableValue(iProp));
				nMagic += nDamage;
			}
		}		
		iProp = GetNextItemProperty(oWeapon);
	}

	if (nIsRanged == TRUE)  // Gets bonuses from ammo as well as the bow, if it was called by the last set of routines.
	{
		int nBaseType = GetBaseItemType(oWeapon);

		object oAmmo;
		if (nBaseType == BASE_ITEM_LIGHTCROSSBOW || nBaseType == BASE_ITEM_HEAVYCROSSBOW)
			oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS);
		if (nBaseType == BASE_ITEM_LONGBOW || nBaseType == BASE_ITEM_SHORTBOW)
			oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS);
		if (nBaseType == BASE_ITEM_SLING)
			oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS);						

		itemproperty iProp = GetFirstItemProperty(oAmmo);

		while (GetIsItemPropertyValid(iProp))
		{
			nProp = GetItemPropertyType(iProp);

			if (nProp == ITEM_PROPERTY_DAMAGE_BONUS)
			{
			  	GetItemPropertyCostTableValue(iProp); //IP_CONST_DAMAGEBONUS
				GetItemPropertySubType(iProp); //IP_CONST_DAMAGETYPE

				int nDamage = GetDamageByIPConstDamageBonus(GetItemPropertyCostTableValue(iProp));

				switch (GetItemPropertySubType(iProp))  //DamageType
				{
					case IP_CONST_DAMAGETYPE_ACID:			nAcid += nDamage;	break;				
					case IP_CONST_DAMAGETYPE_BLUDGEONING:	nBlunt += nDamage;	break;			
					case IP_CONST_DAMAGETYPE_COLD:			nCold += nDamage;	break;				
					case IP_CONST_DAMAGETYPE_DIVINE:		nDivine += nDamage;	break;						
					case IP_CONST_DAMAGETYPE_ELECTRICAL:	nElec += nDamage;	break;		
					case IP_CONST_DAMAGETYPE_FIRE:			nFire += nDamage;	break;						
					case IP_CONST_DAMAGETYPE_MAGICAL:		nMagic += nDamage;	break;			
					case IP_CONST_DAMAGETYPE_NEGATIVE:		nNegat += nDamage;	break;			
					case IP_CONST_DAMAGETYPE_PHYSICAL:		nSlash += nDamage;	break;		
					case IP_CONST_DAMAGETYPE_PIERCING:		nPierce += nDamage;	break;			
					case IP_CONST_DAMAGETYPE_POSITIVE:		nPosit += nDamage;	break;		
					case IP_CONST_DAMAGETYPE_SLASHING:		nSlash += nDamage;	break;		
					case IP_CONST_DAMAGETYPE_SONIC:			nSonic += nDamage;	break;																														
				}
			}
			else if (nProp == ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP)
			{	
				int nGoodEvil = GetAlignmentGoodEvil(oTarget);
				int nLawChaos = GetAlignmentLawChaos(oTarget);

				if ((GetItemPropertySubType(iProp) == nGoodEvil) || (GetItemPropertySubType(iProp) == nLawChaos))
				{
					int nDamage = GetDamageByIPConstDamageBonus(GetItemPropertyCostTableValue(iProp));	
					nMagic += nDamage;
				}
			}
			else if (nProp == ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP)
			{
				int nTargetRace = GetRacialType(oTarget);

				if (GetItemPropertySubType(iProp) == nTargetRace)
				{
					int nDamage = GetDamageByIPConstDamageBonus(GetItemPropertyCostTableValue(iProp));
					nMagic += nDamage;
				}
			}
			else if (nProp == ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT)
			{
				int nAlignment = GetAlignment(oTarget);

				if (GetItemPropertySubType(iProp) == nAlignment)
				{
					int nDamage = GetDamageByIPConstDamageBonus(GetItemPropertyCostTableValue(iProp));
					nMagic += nDamage;
				}
			}					
			iProp = GetNextItemProperty(oAmmo);
		}
	}

	if (!GetIsObjectValid(oWeapon)) // love for monks
	{
		object oArms = GetItemInSlot(INVENTORY_SLOT_ARMS);
		itemproperty iArm = GetFirstItemProperty(oArms);

		while (GetIsItemPropertyValid(iArm))
		{
			nProp = GetItemPropertyType(iArm);

			if (nProp == ITEM_PROPERTY_DAMAGE_BONUS)
			{	
				int nDamage = GetDamageByIPConstDamageBonus(GetItemPropertyCostTableValue(iArm));

				switch (GetItemPropertySubType(iArm))  //DamageType
				{
					case IP_CONST_DAMAGETYPE_ACID:			nAcid += nDamage;	break;				
					case IP_CONST_DAMAGETYPE_BLUDGEONING:	nBlunt += nDamage;	break;				
					case IP_CONST_DAMAGETYPE_COLD:			nCold += nDamage;	break;		
					case IP_CONST_DAMAGETYPE_DIVINE:		nDivine += nDamage;	break;						
					case IP_CONST_DAMAGETYPE_ELECTRICAL:	nElec += nDamage;	break;				
					case IP_CONST_DAMAGETYPE_FIRE:			nFire += nDamage;	break;				
					case IP_CONST_DAMAGETYPE_MAGICAL:		nMagic += nDamage;	break;			
					case IP_CONST_DAMAGETYPE_NEGATIVE:		nNegat += nDamage;	break;			
					case IP_CONST_DAMAGETYPE_PHYSICAL:		nSlash += nDamage;	break;		
					case IP_CONST_DAMAGETYPE_PIERCING:		nPierce += nDamage;	break;					
					case IP_CONST_DAMAGETYPE_POSITIVE:		nPosit += nDamage;	break;					
					case IP_CONST_DAMAGETYPE_SLASHING:		nSlash += nDamage;	break;				
					case IP_CONST_DAMAGETYPE_SONIC:			nSonic += nDamage;	break;																														
				}	
			}
			else if (nProp == ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP)
			{	
				int nGoodEvil = GetAlignmentGoodEvil(oTarget);
				int nLawChaos = GetAlignmentLawChaos(oTarget);

				if ((GetItemPropertySubType(iArm) == nGoodEvil) || (GetItemPropertySubType(iArm) == nLawChaos))
				{
					int nDamage = GetDamageByIPConstDamageBonus(GetItemPropertyCostTableValue(iArm));	
					nMagic += nDamage;
				}
			}
			else if (nProp == ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP)
			{
				int nTargetRace = GetRacialType(oTarget);

				if (GetItemPropertySubType(iProp) == nTargetRace)
				{
					int nDamage = GetDamageByIPConstDamageBonus(GetItemPropertyCostTableValue(iArm));
					nMagic += nDamage;
				}
			}
			else if (nProp == ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT)
			{
				int nAlignment = GetAlignment(oTarget);

				if (GetItemPropertySubType(iArm) == nAlignment)
				{
					int nDamage = GetDamageByIPConstDamageBonus(GetItemPropertyCostTableValue(iArm));
					nMagic += nDamage;
				}
			}		
			iArm = GetNextItemProperty(oArms);
		}
	}

	nSlash *= nMult;
	nBlunt *= nMult;
	nPierce *= nMult;
	nAcid *= nMult;
	nCold *= nMult;
	nElec *= nMult;
	nFire *= nMult;
	nSonic*= nMult;
	nDivine *= nMult;
	nMagic *= nMult;
	nPosit *= nMult;
	nNegat *= nMult;

	// Convert all damage to fire damage if we're using the maneuver Burning Brand.
	if (GetLocalInt(oPC, "BurningBrand") == 1)
	{
		if (nPierce > 0)
		{
			nFire += nPierce;
			nPierce = 0;
		}

		if (nBlunt > 0)
		{
			nFire += nBlunt;
			nBlunt = 0;
		}

		if (nSlash > 0)
		{
			nFire += nSlash;
			nSlash = 0;
		}

		if (nAcid > 0)
		{
			nFire += nAcid;
			nAcid = 0;
		}

		if (nCold > 0)
		{
			nFire += nCold;
			nCold = 0;
		}

		if (nSonic > 0)
		{
			nFire += nSonic;
			nSonic = 0;
		}

		if (nDivine > 0)
		{
			nFire += nDivine;
			nDivine = 0;
		}

		if (nElec > 0)
		{
			nFire += nElec;
			nElec = 0;
		}

		if (nMagic > 0)
		{
			nFire += nMagic;
			nMagic = 0;
		}

		if (nPosit > 0)
		{
			nFire += nPosit;
			nPosit = 0;
		}

		if (nNegat > 0)
		{
			nFire += nNegat;
			nNegat = 0;
		}
	}

	//Time to build a mega damage event.

	if (!GetIsObjectValid(oWeapon))
	{
		// Calling this function stores data to be used for calculating the struct.
		effect eDmg = SnapKickDamage(); // Fortunately, Snap Kick will get apporpiate unarmed damage and runs a check for Superior Unarmed Strike.
		int nSnapDamage = GetLocalInt(oPC, "SnapKickStoredDam");
		int nSnapType = GetLocalInt(oPC, "SnapKickType");

		if (nSnapType == DAMAGE_TYPE_BLUDGEONING)
		{
			nBlunt += nSnapDamage;
		}
		else nMagic += nSnapDamage;
	}

	if (nBlunt > 0)
	{
		if ((GetLevelByClass(CLASS_TYPE_MONK, oPC) > 15) && (!GetIsObjectValid(oWeapon)))
		{
			nMagic += nBlunt;
			nBlunt = 0;
		}
	}

	int nStrikeTotal = GetLocalInt(oPC, "bot9s_StrikeTotal");
	int nStrike = nSlash + nBlunt + nPierce + nAcid + nCold + nElec + nFire + nSonic + nDivine + nMagic + nPosit + nNegat;

	// Used in certain strikes.  The variable must be cleared out in the strike script or the damage will continue to pile.
	SetLocalInt(oPC, "bot9s_StrikeTotal", nStrikeTotal + nStrike);

	main.nPierce = nPierce;
	main.nAcid = nAcid;
	main.nSlash = nSlash;
	main.nBlunt = nBlunt;
	main.nCold = nCold;
	main.nElec = nElec;			
	main.nFire = nFire;
	main.nSonic = nSonic;
	main.nDivine = nDivine;
	main.nMagic = nMagic;			
	main.nPosit = nPosit;
	main.nNegat = nNegat;

	return main;
}

// Calculates Sneak Attack Damage
struct main_damage SneakAttack(object oWeapon, object oPC, object oFoe, int bIgnoreResistances = FALSE)
{
	struct main_damage main;
	int nSneakAttack, nSlash, nBlunt, nPierce, nAcid, nCold, nElec, nFire, nSonic, nDivine, nMagic, nPosit, nNegat;

	object oToB = GetItemPossessedBy(oPC, "tob");
	int nBaseItemType = GetBaseItemType(oWeapon);
	int nWeaponType = GetWeaponType(oWeapon);
	int nDice = GetSneakAttackDice(oPC);
	
	nSneakAttack = GetDamageByDice(6, nDice);
	
	// Get immuntiy and exceptions to immunity.	
	if (GetIsImmune(oFoe, IMMUNITY_TYPE_SNEAK_ATTACK) || GetIsImmune(oFoe, IMMUNITY_TYPE_CRITICAL_HIT))
	{
		int nSub = GetSubRace(oFoe);

		if (GetHasFeat(2128, oPC)) // Epic Precision
		{
			nSneakAttack = nSneakAttack / 2;
		}
		else if ((nSub == RACIAL_SUBTYPE_UNDEAD) && (GetHasFeat(2129, oPC))) // Death's Ruin
		{
			nSneakAttack = nSneakAttack / 2;
		}
		else if ((nSub == RACIAL_SUBTYPE_ELEMENTAL) && (GetHasFeat(2130, oPC))) // Elemental's Ruin
		{
			nSneakAttack = nSneakAttack / 2;
		}
		else if ((nSub == RACIAL_SUBTYPE_PLANT) && (GetHasFeat(2131, oPC))) // Nature's Ruin
		{
			nSneakAttack = nSneakAttack / 2;
		}
		else if ((GetIsSpirit(oFoe)) && (GetHasFeat(2132, oPC))) // Spirit's Ruin
		{
			nSneakAttack = nSneakAttack / 2;
		}
		else if ((nSub == RACIAL_SUBTYPE_CONSTRUCT) && (GetHasFeat(2133, oPC))) // Builder's Ruin
		{
			nSneakAttack = nSneakAttack / 2;
		}
		else nSneakAttack = 0;
	}

	if (nSneakAttack > 0)
	{
		SetLocalInt(oPC, "SneakHasHit", 1);
		DelayCommand(0.5f, SetLocalInt(oPC, "SneakHasHit", 0));

		if (GetLocalInt(oPC, "BurningBrand") == 1)
		{
			nFire += nSneakAttack;
		}
		else if (nWeaponType == WEAPON_TYPE_SLASHING || nWeaponType == WEAPON_TYPE_PIERCING_AND_SLASHING)
		{
			nSlash += nSneakAttack;
		}
		else if (nWeaponType == WEAPON_TYPE_PIERCING)
		{
			nPierce += nSneakAttack;
		}
		else nBlunt += nSneakAttack;
	}

	//Time to build a mega damage event.

	if (nBlunt > 0)
	{
		if ((GetLevelByClass(CLASS_TYPE_MONK, oPC) > 15) && (!GetIsObjectValid(oWeapon)))
		{
			nMagic += nBlunt;
			nBlunt = 0;
		}
	}

	int nStrikeTotal = GetLocalInt(oPC, "bot9s_StrikeTotal");
	int nStrike = nSlash + nBlunt + nPierce + nAcid + nCold + nElec + nFire + nSonic + nDivine + nMagic + nPosit + nNegat;

	// Used in certain strikes.  The variable must be cleared out in the strike script or the damage will continue to pile.
	SetLocalInt(oPC, "bot9s_StrikeTotal", nStrikeTotal + nStrike);

	main.nPierce = nPierce;
	main.nAcid = nAcid;
	main.nSlash = nSlash;
	main.nBlunt = nBlunt;
	main.nCold = nCold;
	main.nElec = nElec;			
	main.nFire = nFire;
	main.nSonic = nSonic;
	main.nDivine = nDivine;
	main.nMagic = nMagic;			
	main.nPosit = nPosit;
	main.nNegat = nNegat;

	return main;
}

// Applies instant critical hit damage to calculations.
struct main_damage StrikeCriticalEffect(object oPC, object oWeapon, object oTarget, int bIgnoreResistances = FALSE, int nMult = 1)
{
	struct main_damage main;
	int nDamage, nSlash, nBlunt, nPierce, nAcid, nCold, nElec, nFire, nSonic, nDivine, nMagic, nPosit, nNegat;

	object oToB = GetItemPossessedBy(oPC, "tob");
	int nWeapon = GetWeaponType(oWeapon);
	int nBaseWeapon = GetBaseItemType(oWeapon);
	int nCritMult = GetCriticalMultiplier(oWeapon);
	int nOCFeat = tob_Get2daInt("baseitems", "FEATOverWhCrit", nBaseWeapon);

	itemproperty iProp = GetFirstItemProperty(oWeapon);
		
	while (GetIsItemPropertyValid(iProp))
	{
		if (GetItemPropertyType(iProp) == ITEM_PROPERTY_MASSIVE_CRITICALS)
		{	
			int nMassive = GetDamageByIPConstDamageBonus(GetItemPropertyCostTableValue(iProp));
			
			switch (nWeapon)  //DamageType
			{		
				case WEAPON_TYPE_PIERCING_AND_SLASHING:		nPierce += nMassive;	break;					
				case WEAPON_TYPE_PIERCING:					nPierce += nMassive;	break;					
				case WEAPON_TYPE_SLASHING:					nSlash += nMassive;		break;				
				default: 									nBlunt += nMassive;		break;																														
			}
		}
		iProp=GetNextItemProperty(oWeapon);
	}
	
	if ((GetHasFeat(nOCFeat, oPC)) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))) // Overwhelming Critical
	{
		if (nCritMult == 2)
		{
			nDamage += GetDamageByDice(6, 1);
		}
		else if (nCritMult == 3)
		{
			nDamage += GetDamageByDice(6, 2);
		}
		else if (nCritMult == 4)
		{
			nDamage += GetDamageByDice(6, 3);
		}
		else if (nCritMult > 4)
		{
			nDamage += GetDamageByDice(6, 4);
		}
	}
	
	if (nWeapon == WEAPON_TYPE_PIERCING_AND_SLASHING || nWeapon == WEAPON_TYPE_PIERCING)
	{
		nPierce += nDamage;
	}
	else if (nWeapon == WEAPON_TYPE_SLASHING)
	{
		nSlash += nDamage;
	}
	else nBlunt += nDamage;
	
	if ((GetHasFeat(FEAT_EPIC_THUNDERING_RAGE, oPC)) && (GetIsRaging(oPC)))
	{
		if (nCritMult == 2)
		{
			nSonic += GetDamageByDice(8, 1);
		}
		else if (nCritMult == 3)
		{
			nSonic += GetDamageByDice(8, 2);
		}
		else if (nCritMult == 4)
		{
			nSonic += GetDamageByDice(8, 3);
		}
		else if (nCritMult > 4)
		{
			nSonic += GetDamageByDice(8, 4);
		}
	}

	nPierce *= nMult;
	nSlash *= nMult;
	nBlunt *= nMult;
	nSonic *= nMult;

	//Time to build a mega damage event.

	if (nBlunt > 0)
	{
		if ((GetLevelByClass(CLASS_TYPE_MONK, oPC) > 15) && (!GetIsObjectValid(oWeapon)))
		{
			nMagic += nBlunt;
			nBlunt = 0;
		}
	}

	int nStrikeTotal = GetLocalInt(oPC, "bot9s_StrikeTotal");
	int nStrike = nSlash + nBlunt + nPierce + nAcid + nCold + nElec + nFire + nSonic + nDivine + nMagic + nPosit + nNegat;

	// Used in certain strikes.  The variable must be cleared out in the strike script or the damage will continue to pile.
	SetLocalInt(oPC, "bot9s_StrikeTotal", nStrikeTotal + nStrike);

	main.nPierce = nPierce;
	main.nAcid = nAcid;
	main.nSlash = nSlash;
	main.nBlunt = nBlunt;
	main.nCold = nCold;
	main.nElec = nElec;			
	main.nFire = nFire;
	main.nSonic = nSonic;
	main.nDivine = nDivine;
	main.nMagic = nMagic;			
	main.nPosit = nPosit;
	main.nNegat = nNegat;

	return main;
}

// Temporary Effects.  Each Needs to be applied seperately to get the proper durations.

// Simulates the effects of Invisible Blade's Bleeding Wound.
// Only meant for use in conjunction with SneakAttack.
effect IBBleedingWound()
{
	object oPC = OBJECT_SELF;
	effect eBlW;
	
	if (GetHasFeat(2054, oPC)) //Bleeding Wound 3
	{
		eBlW = EffectDamageOverTime(6, 6.0f, DAMAGE_TYPE_MAGICAL, TRUE);
	}
	else if (GetHasFeat(2053, oPC)) //Bleeding Wound 2
	{
		eBlW = EffectDamageOverTime(4, 6.0f, DAMAGE_TYPE_MAGICAL, TRUE);
	}
	else if (GetHasFeat(2052, oPC)) //Bleeding Wound
	{
		eBlW = EffectDamageOverTime(2, 6.0f, DAMAGE_TYPE_MAGICAL, TRUE);
	}
	return eBlW;
}

// Debuffs the Target's AC for one round.
effect MissileVolley(object oPC, object oWeapon)
{
	effect eVolley = EffectACDecrease(1, AC_DODGE_BONUS, DAMAGE_TYPE_SLASHING);
	return eVolley;
}