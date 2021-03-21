//////////////////////////////////////////////////////////
//	Author: Drammel										//
//	Date: 3/1/2009										//
//	Title: bot9s_attack									//
//	Description: This file simulates attack				//
//	rolls for strike maneuvers and similar spellike		//
//	abilites that require a "to hit" roll.				//
//	It is used in conjunction with bot9s_weapon	to		//
//	simulate a full maneuver.							//
//	GetMaxAB is adapted from Mithdradates's script on	//
//	the Helpful Scripts thread in the NWN2 forums.		//
//	Many thanks to him for creating it.					//
//////////////////////////////////////////////////////////

#include "bot9s_inc_2da"
#include "bot9s_include"
#include "bot9s_inc_constants"
#include "bot9s_inc_variables"
#include "tob_i0_spells"
#include "tob_x2_inc_itemprop"

// Prototypes

//Function to get the AB of the object oCreature
int GetMaxAB(object oCreature, object oWeapon, object oTarget);

// Returns the low end of the critical range for the weapon the caller of the
// function has equipped.
int GetCriticalRange(object oWeapon);

// Returns any bonuses to critical confirmation rolls.
int GetCriticalConfirmMod(object oWeapon);

// Returns the critical multiplier of oWeapon.
int GetCriticalMultiplier(object oWeapon);

// Returns oTarget's attack modifier for a Touch attack.
// -bRanged: TRUE for a ranged touch, FALSE for melee.
int GetTouchAB(object oTarget, int bRanged = FALSE);

// Determines if oPC is currently suffering from a miss chance effect.
// If they are this function also makes the miss chance roll and stores the
// result on oPC under the int index name "bot9s_misschance_int".
int HasMissChance(object oPC);

// Determines the results of oPC's concealment roll against oFoe.
// 0 = Miss, 1 = Hit.
int ConcealmentRoll(object oPC, object oFoe);

// Determines if an attack roll based on the input values is a hit, miss or
// critical hit.  0 = Miss, 1 = Hit, 2 = Critical Hit.
int GetHit(object oWeapon, object oFoe, int nFoeAC, int nd20, int nD20, int nAB, int nCritRange, int nCritConfirmBonus, object oPC = OBJECT_SELF);

// Functions
	
//Function to get the AB of the object oCreature
int GetMaxAB(object oCreature, object oWeapon, object oTarget)
{
	object oToB = GetItemPossessedBy(oCreature, "tob");
	object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);
	object oOffHand;

	if ((oLeft == OBJECT_INVALID) && (!GetIsPlayableRacialType(oCreature)))
	{
		oOffHand = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCreature);
	}
	else oOffHand = oLeft;

	int iAB = GetBaseAttackBonus(oCreature);
	int iAttackDecrease = 0;
	int nWeapon = GetBaseItemType(oWeapon);
	int nWFFeat = tob_Get2daInt("baseitems", "FEATWpnFocus", nWeapon);
	int nGWFFeat = tob_Get2daInt("baseitems", "FEATGrtrWpnFocus", nWeapon);
	int nEWFFeat = tob_Get2daInt("baseitems", "FEATEpicWpnFocus", nWeapon);
	int nWoCFeat = tob_Get2daInt("baseitems", "FEATWpnOfChoice", nWeapon);

	// Flanking Bonuses

	if (IsFlankValid(oCreature, oTarget) == TRUE)
	{
		iAB += 2;
		
		if (GetHasFeat(FEAT_TW_SUPERIOR_FLANK, oCreature) == TRUE)
		{
			iAB += 2;
		}
		
		if (GetHasFeat(2142, oCreature) == TRUE) // Improved Flanking
		{
			iAB +=2;
		}
	}
	
	// Add ability modifier
	if (GetWeaponRanged(oWeapon))
	{
		if (GetHasFeat(FEAT_ZEN_ARCHERY, oCreature, TRUE) && GetAbilityModifier(ABILITY_WISDOM, oCreature) > GetAbilityModifier(ABILITY_DEXTERITY, oCreature))
		{	
			iAB = iAB + GetAbilityModifier(ABILITY_WISDOM, oCreature);
		}
		else iAB = iAB + GetAbilityModifier(ABILITY_DEXTERITY, oCreature);
		
		if ((GetDistanceToObject(oTarget) < FeetToMeters(15.0f)) && (GetHasFeat(FEAT_POINT_BLANK_SHOT, oCreature) == FALSE))
		{
			iAttackDecrease += 4;
		}
	}
	else 
	{
		if (GetHasFeat(FEAT_WEAPON_FINESSE, oCreature, TRUE) && GetAbilityModifier(ABILITY_DEXTERITY,oCreature) > GetAbilityModifier(ABILITY_STRENGTH, oCreature) && (GetWeaponSize(oCreature)<=WEAPON_SIZE_SMALL || nWeapon == BASE_ITEM_RAPIER || nWeapon == BASE_ITEM_RAPIER_R))
		{
			iAB = iAB + GetAbilityModifier(ABILITY_DEXTERITY,oCreature);
		}
		else iAB=iAB+GetAbilityModifier(ABILITY_STRENGTH, oCreature);
	}
	
	// Add weapon size and dual wielding effects
	if (GetIsObjectValid(oOffHand) && GetWeaponSize(oCreature) > GetCreatureSize(oCreature) || GetWeaponSize(oCreature) > GetCreatureSize(oCreature)+1) iAB=iAB-2;
	if (GetIsObjectValid(oOffHand) && GetBaseItemType(oOffHand)!= BASE_ITEM_SMALLSHIELD && GetBaseItemType(oOffHand)!= BASE_ITEM_LARGESHIELD)
	{
		if (GetBaseItemType(oOffHand) == BASE_ITEM_TOWERSHIELD) iAB=iAB-2;

		if (oWeapon == oOffHand)// Checking for the Offhand weapon.
		{
			if (GetHasFeat(FEAT_EPIC_PERFECT_TWO_WEAPON_FIGHTING, oCreature, TRUE) || GetHasFeat(FEAT_COMBATSTYLE_RANGER_DUAL_WIELD_PERFECT_TWO_WEAPON_FIGHTING, oCreature, TRUE))
			{
				iAB=iAB-0;
			}
			else if (GetLocalInt(oToB, "Strike") == 185) // Wolf Fang Strike
			{
				iAB=iAB-2;
			}
			else if (GetHasFeat(FEAT_TWO_WEAPON_FIGHTING, oCreature, TRUE) || GetHasFeat(FEAT_COMBATSTYLE_RANGER_DUAL_WIELD_TWO_WEAPON_FIGHTING, oCreature, TRUE)) 
			{
				if (GetWeaponSize(oOffHand) < GetCreatureSize(oCreature)) iAB=iAB-2;
				else iAB=iAB-4;
			}
			else 
			{
				if (GetWeaponSize(oOffHand) < GetCreatureSize(oCreature)) iAB=iAB-8;
			 	else iAB=iAB-10;
			}
		}
		else // Checking for the Onhand weapon.
		{
			if (GetHasFeat(FEAT_EPIC_PERFECT_TWO_WEAPON_FIGHTING, oCreature, TRUE) || GetHasFeat(FEAT_COMBATSTYLE_RANGER_DUAL_WIELD_PERFECT_TWO_WEAPON_FIGHTING, oCreature, TRUE))
			{
				iAB=iAB-0;
			}
			else if (GetLocalInt(oToB, "Strike") == 185) // Wolf Fang Strike
			{
				iAB=iAB-2;
			}
			else if (GetHasFeat(FEAT_TWO_WEAPON_FIGHTING, oCreature, TRUE) || GetHasFeat(FEAT_COMBATSTYLE_RANGER_DUAL_WIELD_TWO_WEAPON_FIGHTING, oCreature, TRUE)) 
			{
				if (GetWeaponSize(oOffHand) < GetCreatureSize(oCreature)) iAB=iAB-2;
				else iAB=iAB-4;
			}
			else 
			{
				if (GetWeaponSize(oOffHand) < GetCreatureSize(oCreature)) iAB=iAB-4;
			 	else iAB=iAB-6;
			}
		}
	}
	
	// Weapon feat effects

	if (nWeapon == BASE_ITEM_LONGBOW)
	{	
		if (GetHasFeat(FEAT_WEAPON_FOCUS_LONGBOW, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(FEAT_GREATER_WEAPON_FOCUS_LONGBOW, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_LONGBOW, oCreature, TRUE)) iAB=iAB+2;
		if (GetHasFeat(FEAT_PRESTIGE_ENCHANT_ARROW_5, oCreature, TRUE)) iAB=iAB+5;
		else if (GetHasFeat(FEAT_PRESTIGE_ENCHANT_ARROW_4, oCreature, TRUE)) iAB=iAB+4;
		else if (GetHasFeat(FEAT_PRESTIGE_ENCHANT_ARROW_3, oCreature, TRUE)) iAB=iAB+3;
		else if (GetHasFeat(FEAT_PRESTIGE_ENCHANT_ARROW_2, oCreature, TRUE)) iAB=iAB+2;
		else if (GetHasFeat(FEAT_PRESTIGE_ENCHANT_ARROW_1, oCreature, TRUE)) iAB=iAB+1;		
	}
	else if (nWeapon == BASE_ITEM_SHORTBOW)
	{	
		if (GetHasFeat(FEAT_WEAPON_FOCUS_SHORTBOW, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(FEAT_GREATER_WEAPON_FOCUS_SHORTBOW, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_SHORTBOW, oCreature, TRUE)) iAB=iAB+2;	
		if (GetHasFeat(FEAT_PRESTIGE_ENCHANT_ARROW_5, oCreature, TRUE)) iAB=iAB+5;
		else if (GetHasFeat(FEAT_PRESTIGE_ENCHANT_ARROW_4, oCreature, TRUE)) iAB=iAB+4;
		else if (GetHasFeat(FEAT_PRESTIGE_ENCHANT_ARROW_3, oCreature, TRUE)) iAB=iAB+3;
		else if (GetHasFeat(FEAT_PRESTIGE_ENCHANT_ARROW_2, oCreature, TRUE)) iAB=iAB+2;
		else if (GetHasFeat(FEAT_PRESTIGE_ENCHANT_ARROW_1, oCreature, TRUE)) iAB=iAB+1;
	}
	else if (nWeapon == BASE_ITEM_SHURIKEN)
	{	
		if (GetHasFeat(FEAT_WEAPON_FOCUS_SHURIKEN, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(FEAT_GREATER_WEAPON_FOCUS_SHURIKEN, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_SHURIKEN, oCreature, TRUE)) iAB=iAB+2;
		if (GetHasFeat(FEAT_GOOD_AIM, oCreature, TRUE)) iAB=iAB+1;	
	}
	else if (nWeapon == BASE_ITEM_SLING)
	{	
		if (GetHasFeat(FEAT_WEAPON_FOCUS_SLING, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(FEAT_GREATER_WEAPON_FOCUS_SLING, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_SLING, oCreature, TRUE)) iAB=iAB+2;	
		if (GetHasFeat(FEAT_GOOD_AIM, oCreature, TRUE)) iAB=iAB+1;
	}
	else if (nWeapon == BASE_ITEM_THROWINGAXE)
	{	
		if (GetHasFeat(FEAT_WEAPON_FOCUS_THROWING_AXE, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(FEAT_GREATER_WEAPON_FOCUS_THROWINGAXE, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_THROWINGAXE, oCreature, TRUE)) iAB=iAB+2;	
		if (GetHasFeat(FEAT_GOOD_AIM, oCreature, TRUE)) iAB=iAB+1;
	}
	else if (GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature)))
	{
		if (GetHasFeat(nWFFeat, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(nGWFFeat, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(nEWFFeat, oCreature, TRUE)) iAB=iAB+2;
		if (GetHasFeat(nWoCFeat, oCreature, TRUE) && GetHasFeat(FEAT_SUPERIOR_WEAPON_FOCUS, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(nWoCFeat, oCreature, TRUE) && GetHasFeat(FEAT_EPIC_SUPERIOR_WEAPON_FOCUS, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(nWoCFeat, oCreature, TRUE) && GetHasFeat(FEAT_EPIC_SUPERIOR_WEAPON_FOCUS, oCreature, TRUE) && (GetLevelByClass(CLASS_TYPE_WEAPON_MASTER) > 15)) iAB=iAB+1;
		if (GetHasFeat(nWoCFeat, oCreature, TRUE) && GetHasFeat(FEAT_EPIC_SUPERIOR_WEAPON_FOCUS, oCreature, TRUE) && (GetLevelByClass(CLASS_TYPE_WEAPON_MASTER) > 18)) iAB=iAB+1;
	}
	else if (GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCreature))||GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oCreature))||GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oCreature)))
	{
		if (GetHasFeat(FEAT_WEAPON_FOCUS_CREATURE, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(FEAT_GREATER_WEAPON_FOCUS_CREATURE, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_CREATURE, oCreature, TRUE)) iAB=iAB+2;
	
		oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oCreature);
			
		if (GetIsObjectValid(oWeapon)==FALSE) oWeapon=GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oCreature);
		if (GetIsObjectValid(oWeapon)==FALSE) oWeapon=GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oCreature);	
	}
	else
	{
		if (GetHasFeat(FEAT_WEAPON_FOCUS_UNARMED_STRIKE, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(FEAT_GREATER_WEAPON_FOCUS_UNARMED, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_UNARMED, oCreature, TRUE)) iAB=iAB+2;	
	}

	
	if ((GetIsFavoredEnemy(oCreature, oTarget)) && (GetHasFeat(FEAT_EPIC_BANE_OF_ENEMIES, oCreature)))
	{
		iAB += 2;
	}
	
	if (GetHasFeat(FEAT_EPIC_PROWESS, oCreature))
	{
		iAB += 1;
	}
	
	if ((GetHasFeat(2103, oCreature)) && (nWeapon != OBJECT_TYPE_INVALID)) // Sarced Fist Code of Conduct
	{
		iAttackDecrease += 8;
	}
	
	// Mode Effects
	
	if (GetActionMode(oCreature, ACTION_MODE_POWER_ATTACK))
	{
		 iAttackDecrease += 3;
	}
	else if (GetActionMode(oCreature, ACTION_MODE_IMPROVED_POWER_ATTACK))
	{
		iAttackDecrease += 6;
	}
	
	if (GetActionMode(oCreature, ACTION_MODE_COMBAT_EXPERTISE))
	{
		 iAttackDecrease += 3;
	}
	else if (GetActionMode(oCreature, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE))
	{
		iAttackDecrease += 6;
	}
	
	if (GetActionMode(oCreature, ACTION_MODE_FLURRY_OF_BLOWS))
	{
		if ((GetLevelByClass(CLASS_TYPE_MONK)) + (GetLevelByClass(CLASS_TYPE_SACREDFIST)) < 5)
		{
			iAttackDecrease += 2;
		}
		else if ((GetLevelByClass(CLASS_TYPE_MONK)) + (GetLevelByClass(CLASS_TYPE_SACREDFIST)) < 10)
		{
			iAttackDecrease += 1;
		}
	}	

	if (GetActionMode(oCreature, ACTION_MODE_RAPID_SHOT))
	{
		if (GetHasFeat(FEAT_IMPROVED_RAPID_SHOT))
		{
			iAttackDecrease += 0;
		}
		else iAttackDecrease += 2;
	}
	
	if (GetLocalInt(oToB, "SnapKick") == 1)
	{
		iAttackDecrease += 2;
	}

	// Misc Effects and Enchantment
	
	int iWeaponEnhancement = 0;
	itemproperty ipAB = GetFirstItemProperty(oWeapon);
	
	while (GetIsItemPropertyValid(ipAB))
	{
		if (GetItemPropertyType(ipAB) == ITEM_PROPERTY_ENHANCEMENT_BONUS || GetItemPropertyType(ipAB) == ITEM_PROPERTY_ATTACK_BONUS)
		{
			iWeaponEnhancement = iWeaponEnhancement + GetItemPropertyCostTableValue(ipAB);
		}
		else if (GetItemPropertyType(ipAB) == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP || GetItemPropertyType(ipAB) == ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP)
		{
			int nGoodEvil = GetAlignmentGoodEvil(oTarget);
			int nLawChaos = GetAlignmentLawChaos(oTarget);
			
			if ((GetItemPropertySubType(ipAB) == nGoodEvil) || (GetItemPropertySubType(ipAB) == nLawChaos))
			{
				iWeaponEnhancement = iWeaponEnhancement + GetItemPropertyCostTableValue(ipAB);
			}
		}
		else if (GetItemPropertyType(ipAB) == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP || GetItemPropertyType(ipAB) == ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP)
		{
			int nTargetRace = GetRacialType(oTarget);
			
			if (GetItemPropertySubType(ipAB) == nTargetRace)
			{
				iWeaponEnhancement = iWeaponEnhancement + GetItemPropertyCostTableValue(ipAB);
			}
		}
		else if (GetItemPropertyType(ipAB) == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT || GetItemPropertyType(ipAB) == ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT)
		{
			int nAlignment = GetAlignment(oTarget);
			
			if (GetItemPropertySubType(ipAB) == nAlignment)
			{
				iWeaponEnhancement = iWeaponEnhancement + GetItemPropertyCostTableValue(ipAB);
			}
		}
		else if (GetItemPropertyType(ipAB) == ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER || GetItemPropertyType(ipAB) == ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER)
		{
			iAttackDecrease = iAttackDecrease + GetItemPropertyCostTableValue(ipAB);
		}	
		ipAB=GetNextItemProperty(oWeapon);
	}
	
	if (!GetIsObjectValid(oWeapon)) // love for monks
	{
		object oArms = GetItemInSlot(INVENTORY_SLOT_ARMS);
		itemproperty iArm = GetFirstItemProperty(oArms);
		
		while (GetIsItemPropertyValid(iArm))
		{
			if (GetItemPropertyType(iArm) == ITEM_PROPERTY_ATTACK_BONUS)
			{
				iWeaponEnhancement = iWeaponEnhancement + GetItemPropertyCostTableValue(iArm);
			}
			else if (GetItemPropertyType(iArm) == ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER)
			{
				iAttackDecrease = iAttackDecrease + GetItemPropertyCostTableValue(iArm);
			}
			iArm = GetNextItemProperty(oArms);
		}
	}
	
	effect eAB = GetFirstEffect(oCreature);
	while (GetIsEffectValid(eAB))
	{
		if (GetEffectType(eAB) == EFFECT_TYPE_ATTACK_INCREASE)
		{
			iWeaponEnhancement = iWeaponEnhancement + GetEffectInteger(eAB, 0);
		}
		else if (GetEffectType(eAB) == EFFECT_TYPE_ATTACK_DECREASE)
		{
			iAttackDecrease = iAttackDecrease + GetEffectInteger(eAB, 0);
		}	
		eAB = GetNextEffect(oCreature);
	}

	iAB = iAB + iWeaponEnhancement - iAttackDecrease;
	return iAB;
}

// Returns the low end of the critical range for the weapon the caller of the
// function has equipped.
int GetCriticalRange(object oWeapon)
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nWeapon = GetBaseItemType(oWeapon);
	int nBaseRange = tob_Get2daInt("baseitems", "CritThreat", nWeapon);
	int nImprCrit = tob_Get2daInt("baseitems", "FEATImprCrit", nWeapon);
	int nNoStack = 0;
	int nSubtract, nRange;

	// Base crit range of the weapon.	
	if (nBaseRange == 1)
	{
		nSubtract += 0;
	}
	else if (nBaseRange == 2)
	{
		nSubtract += 1;
	}
	else if (nBaseRange == 3)
	{
		nSubtract += 2;
	}
	
	// Ki Critical feat for Weapon Masters.
	if (GetHasFeat(FEAT_KI_CRITICAL))
	{
		int nWoC = tob_Get2daInt("baseitems", "FEATWpnOfChoice", nWeapon);

		if (GetHasFeat(nWoC))
		{
			nSubtract += 2;
		}
	}
	
	// Properties that don't stack together.
	
	if (GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_KEEN) && (nNoStack == 0))
	{
		if (nBaseRange == 1)
		{
			nSubtract += 1;
			nNoStack = 1;
		}
		else if (nBaseRange == 2)
		{
			nSubtract += 2;
			nNoStack = 1;
		}
		else if (nBaseRange == 3)
		{
			nSubtract += 3;
			nNoStack = 1;
		}
	}
	
	if ((GetHasFeat(nImprCrit)) && (nNoStack == 0))
	{
		if (nBaseRange == 1)
		{
			nSubtract += 1;
			nNoStack = 1;
		}
		else if (nBaseRange == 2)
		{
			nSubtract += 2;
			nNoStack = 1;
		}
		else if (nBaseRange == 3)
		{
			nSubtract += 3;
			nNoStack = 1;
		}
	}
	

	if ((GetHasSpellEffect(SPELL_KEEN_EDGE) || GetHasSpellEffect(SPELL_WEAPON_OF_IMPACT)))
	{
		if (nNoStack == 0)
		{
			if (nBaseRange == 1)
			{
				nSubtract += 1;
				nNoStack = 1;
			}
			else if (nBaseRange == 2)
			{
				nSubtract += 2;
				nNoStack = 1;
			}
			else if (nBaseRange == 3)
			{
				nSubtract += 3;
				nNoStack = 1;
			}
		}
	}
	
	nRange = 20 - nSubtract;
	return nRange;
}

// Returns any bonuses to critical confirmation rolls.
int GetCriticalConfirmMod(object oWeapon)
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nWeapon = GetBaseItemType(oWeapon);
	int nConfirm = 0;
	int nPowerCrit = tob_Get2daInt("baseitems", "FEATPowerCrit", nWeapon);
	
	if (GetHasFeat(nPowerCrit))
	{
		nConfirm += 4;
	}
	
	if (GetHasFeat(FEAT_BATTLE_ARDOR))
	{
		int nMyInt = GetAbilityModifier(ABILITY_INTELLIGENCE);

		if (nMyInt < 1)
		{
			nConfirm += 0;
		}
		else nConfirm += nMyInt;
	}	
	return nConfirm;
}

// Returns the critical multiplier of oWeapon.
int GetCriticalMultiplier(object oWeapon)
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nWeapon = GetBaseItemType(oWeapon);
	int nCritMult = tob_Get2daInt("baseitems", "CritHitMult", nWeapon);

	if (GetHasFeat(FEAT_INCREASE_MULTIPLIER))
	{
		nCritMult += 1;
	}
	return nCritMult;
}

// Returns oTarget's attack modifier for a Touch attack.
// -bRanged: TRUE for a ranged touch, FALSE for melee.
int GetTouchAB(object oTarget, int bRanged = FALSE)
{
	int nBAB = GetTRUEBaseAttackBonus(oTarget);
	int nAbilityMod;
	int nBonus;

	if (bRanged == FALSE)
	{
		nAbilityMod = GetAbilityModifier(ABILITY_STRENGTH, oTarget);
		
		if (GetHasFeat(2107, oTarget)) //FEAT_WEAPON_FOCUS_MELEE_TOUCH_ATTACK
		{
			nBonus += 1;
		}
	}
	else if (bRanged == TRUE)
	{
		nAbilityMod = GetAbilityModifier(ABILITY_DEXTERITY, oTarget);

		if (GetHasFeat(2108, oTarget)) //FEAT_WEAPON_FOCUS_RANGED_TOUCH_ATTACK
		{
			nBonus += 1;
		}
	}

	effect eAB = GetFirstEffect(oTarget);

	while (GetIsEffectValid(eAB))
	{
		if (GetEffectType(eAB) == EFFECT_TYPE_ATTACK_INCREASE)
		{
			int nEffectBonus = GetEffectInteger(eAB, 0);
			nBonus += nEffectBonus;
		}
		else if (GetEffectType(eAB) == EFFECT_TYPE_ATTACK_DECREASE)
		{
			int nEffectBonus = GetEffectInteger(eAB, 0);
			nBonus -= nEffectBonus;
		}
		
		eAB = GetNextEffect(oTarget);
	}

	int nTotal = nBAB + nAbilityMod + nBonus;
	return nTotal;
}

// Determines if oPC is currently suffering from a miss chance effect.
// If they are this function also makes the miss chance roll and stores the
// result on oPC under the int index name "bot9s_misschance_int".
int HasMissChance(object oPC)
{
	effect eMiss;
	int nReturn;

	nReturn = FALSE;
	eMiss = GetFirstEffect(oPC);

	while (GetIsEffectValid(eMiss))
	{
		if (GetEffectType(eMiss) == EFFECT_TYPE_BLINDNESS)
		{
			if (GetHasFeat(FEAT_BLIND_FIGHT, oPC))
			{
				int nd100 = d100(1);
				int nD100 = d100(1);

				if ((nd100 < 50) && (nD100 < 50))
				{
					SetLocalInt(oPC, "bot9s_misschance_int", 1);
					nReturn = TRUE;
					break;
				}
				else SetLocalInt(oPC, "bot9s_misschance_int", 0);
			}
			else if (d100(1) < 50)
			{
				SetLocalInt(oPC, "bot9s_misschance_int", 1);
				nReturn = TRUE;
				break;
			}
			else SetLocalInt(oPC, "bot9s_misschance_int", 0);
		}
		else if (GetEffectType(eMiss) == EFFECT_TYPE_MISS_CHANCE)
		{
			int nChance = GetEffectInteger(eMiss, 0);

			if (d100(1) < nChance)
			{
				SetLocalInt(oPC, "bot9s_misschance_int", 1);
				nReturn = TRUE;
				break;
			}
			else SetLocalInt(oPC, "bot9s_misschance_int", 0);
		}

		eMiss = GetNextEffect(oPC);
	}

	return nReturn;			
}

// Determines the results of oPC's concealment roll against oFoe.
// 0 = Miss, 1 = Hit.
int ConcealmentRoll(object oPC, object oFoe)
{
	int bAttackerHasTrueSight = GetHasEffect(EFFECT_TYPE_TRUESEEING, oPC);
	int bAttackerCanSeeInvisble = GetHasEffect(EFFECT_TYPE_SEEINVISIBLE, oPC);
	int bAttackerUltraVision = GetHasEffect(EFFECT_TYPE_ULTRAVISION, oPC);
	effect eConcealment;
	int nHit, nConcealment;

	nHit = 1;
	eConcealment = GetFirstEffect(oFoe);

	while (GetIsEffectValid(eConcealment))
	{
		nConcealment = GetEffectType(eConcealment);

		if ((nConcealment == EFFECT_TYPE_SANCTUARY) && !bAttackerHasTrueSight)
		{
			int nSanctuary = GetEffectInteger(eConcealment, 0);
			int nWill = MySavingThrow(SAVING_THROW_WILL, oPC, nSanctuary);

			if (nWill == 0)
			{
				nHit = 0;
				break;
			}
		}
		else if (nConcealment == EFFECT_TYPE_ETHEREAL)
		{
			SetLocalInt(oPC, "AttackRollConcealed", 100);
			nHit = 0;
			break;
		}
		else if (nConcealment == EFFECT_TYPE_CONCEALMENT_NEGATED)
		{
			nHit = 1;
			break;
		}
		else if (((nConcealment == EFFECT_TYPE_INVISIBILITY) || (nConcealment == EFFECT_TYPE_GREATERINVISIBILITY)) && !bAttackerHasTrueSight && !bAttackerCanSeeInvisble)
		{
			if (GetHasFeat(FEAT_BLIND_FIGHT, oPC))
			{
				int nd100 = d100(1);
				int nD100 = d100(1);

				if ((nd100 < 50) && (nD100 < 50))
				{
					SetLocalInt(oPC, "AttackRollConcealed", 50);
					nHit = 0;
					break;
				}
			}
			else if (d100(1) < 50)
			{
				SetLocalInt(oPC, "AttackRollConcealed", 50);
				nHit = 0;
				break;
			}
		}
		else if ((nConcealment == EFFECT_TYPE_DARKNESS) && !bAttackerHasTrueSight && !bAttackerUltraVision)
		{
			if (GetHasFeat(FEAT_BLIND_FIGHT, oPC))
			{
				int nd100 = d100(1);
				int nD100 = d100(1);

				if ((nd100 < 50) && (nD100 < 50))
				{
					SetLocalInt(oPC, "AttackRollConcealed", 50);
					nHit = 0;
					break;
				}
			}
			else if (d100(1) < 50)
			{
				SetLocalInt(oPC, "AttackRollConcealed", 50);
				nHit = 0;
				break;
			}
		}
		else if ((nConcealment == EFFECT_TYPE_CONCEALMENT) && !bAttackerHasTrueSight)
		{
			int nd100 = d100(1);
			int nConcealed = GetEffectInteger(eConcealment, 0);
	
			if ((GetHasFeat(FEAT_EPIC_SELF_CONCEALMENT_50, oFoe)) && (nConcealed < 50))
			{
				if (nd100 < 50)
				{
					SetLocalInt(oPC, "AttackRollConcealed", 50);
					nHit = 0;
					break;
				}
			}
			else if ((GetHasFeat(FEAT_EPIC_SELF_CONCEALMENT_40, oFoe)) && (nConcealed < 40))
			{
				if (nd100 < 40)
				{
					SetLocalInt(oPC, "AttackRollConcealed", 40);
					nHit = 0;
					break;
				}
			}
			else if ((GetHasFeat(FEAT_EPIC_SELF_CONCEALMENT_30, oFoe)) && (nConcealed < 30))
			{
				if (nd100 < 30)
				{
					SetLocalInt(oPC, "AttackRollConcealed", 30);
					nHit = 0;
					break;
				}
			}
			else if ((GetHasFeat(FEAT_EPIC_SELF_CONCEALMENT_20, oFoe)) && (nConcealed < 20))
			{
				if (nd100 < 20)
				{
					SetLocalInt(oPC, "AttackRollConcealed", 20);
					nHit = 0;
					break;
				}
			}
			else if ((GetHasFeat(FEAT_EPIC_SELF_CONCEALMENT_10, oFoe)) && (nConcealed < 10))
			{
				if (nd100 < 10)
				{
					SetLocalInt(oPC, "AttackRollConcealed", 10);
					nHit = 0;
					break;
				}
			}
			else if (nd100 < nConcealed)
			{
				SetLocalInt(oPC, "AttackRollConcealed", nConcealed);
				nHit = 0;
				break;
			}
			else break;
		}
		eConcealment = GetNextEffect(oFoe);
	}

	return nHit;
}

// Determines if an attack roll based on the input values is a hit, miss or
// critical hit.  0 = Miss, 1 = Hit, 2 = Critical Hit.
int GetHit(object oWeapon, object oFoe, int nFoeAC, int nd20, int nD20, int nAB, int nCritRange, int nCritConfirmBonus, object oPC = OBJECT_SELF)
{
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nHit, nConcealed, nMiss;

	nConcealed = 1; //Yes, things got a little confused, bear with me.
	nMiss = 0;

	if (HasMissChance(oPC))
	{
		nMiss = GetLocalInt(oPC, "bot9s_misschance_int");
		DeleteLocalInt(oPC, "bot9s_misschance_int");
	}

	if (IsTargetConcealed(oFoe, oPC))
	{
		nConcealed = ConcealmentRoll(oPC, oFoe);
	}

	if (GetLocalInt(oPC, "OverrideHit") == 1)
	{
		nHit = GetLocalInt(oPC, "HitOverrideNum");
	}
	else if (nD20 == 1)
	{
		nHit = 0;
	}
	else if ((nD20 == 20) && (nd20 == 1))
	{
		nHit = 1;
	}
	else if ((nD20 == 20) && ((nd20 + nAB + nCritConfirmBonus) < nFoeAC))
	{
		nHit = 1;
	}
	else if ((nD20 == 20) && ((nd20 + nAB + nCritConfirmBonus) >= nFoeAC) && (GetIsImmune(oFoe, IMMUNITY_TYPE_CRITICAL_HIT)))
	{
		nHit = 1;
	}
	else if ((nD20 == 20) && ((nd20 + nAB + nCritConfirmBonus) >= nFoeAC))
	{
		nHit = 2;
	}
	else if ((nD20 >= nCritRange) && (nd20 == 1) && (nConcealed == 1) && (nMiss == 0))
	{
		nHit = 1;
	}
	else if ((nD20 >= nCritRange) && ((nD20 + nAB) >= nFoeAC) && ((nd20 + nAB + nCritConfirmBonus) >= nFoeAC) && (GetIsImmune(oFoe, IMMUNITY_TYPE_CRITICAL_HIT)) && (nConcealed == 1) && (nMiss == 0))
	{
		nHit = 1;
	}
	else if ((nD20 >= nCritRange) && ((nD20 + nAB) >= nFoeAC) && ((nd20 + nAB + nCritConfirmBonus) >= nFoeAC) && (nConcealed == 1) && (nMiss == 0))
	{
		nHit = 2;
	}
	else if ((nD20 >= nCritRange) && ((nD20 + nAB) >= nFoeAC) && ((nd20 + nAB + nCritConfirmBonus) < nFoeAC) && (nConcealed == 1) && (nMiss == 0))
	{
		nHit = 1;
	}
	else if ((nD20 < nCritRange) && ((nD20 + nAB) >= nFoeAC)  && (nConcealed == 1) && (nMiss == 0))
	{
		nHit = 1;
	}
	else nHit = 0;

	// Lightning Recovery
	if ((GetLocalInt(oPC, "LightningRecovery") == 1) && (nHit == 0) && (GetLocalInt(oPC, "OverrideHit") == 0))
	{
		int nL20 = d20();
		int nl20 = d20();

		nD20 = nL20;
		nd20 = nl20;
		nAB += 2;

		SetLocalInt(oPC, "LightningRecovery", 2);
		SetLocalInt(oToB, "AttackRollResult", nD20 + nAB);

		if (nD20 == 1)
		{
			nHit = 0;
		}
		else if ((nD20 == 20) && (nd20 == 1))
		{
			nHit = 1;
		}
		else if ((nD20 == 20) && ((nd20 + nAB + nCritConfirmBonus) < nFoeAC))
		{
			nHit = 1;
		}
		else if ((nD20 == 20) && ((nd20 + nAB + nCritConfirmBonus) >= nFoeAC) && (GetIsImmune(oFoe, IMMUNITY_TYPE_CRITICAL_HIT)))
		{
			nHit = 1;
		}
		else if ((nD20 == 20) && ((nd20 + nAB + nCritConfirmBonus) >= nFoeAC))
		{
			nHit = 2;
		}
		else if ((nD20 >= nCritRange) && (nd20 == 1) && (nConcealed == 1) && (nMiss == 0))
		{
			nHit = 1;
		}
		else if ((nD20 >= nCritRange) && ((nD20 + nAB) >= nFoeAC) && ((nd20 + nAB + nCritConfirmBonus) >= nFoeAC) && (GetIsImmune(oFoe, IMMUNITY_TYPE_CRITICAL_HIT)) && (nConcealed == 1) && (nMiss == 0))
		{
			nHit = 1;
		}
		else if ((nD20 >= nCritRange) && ((nD20 + nAB) >= nFoeAC) && ((nd20 + nAB + nCritConfirmBonus) >= nFoeAC) && (nConcealed == 1) && (nMiss == 0))
		{
			nHit = 2;
		}
		else if ((nD20 >= nCritRange) && ((nD20 + nAB) >= nFoeAC) && ((nd20 + nAB + nCritConfirmBonus) < nFoeAC)  && (nConcealed == 1) && (nMiss == 0))
		{
			nHit = 1;
		}
		else if ((nD20 < nCritRange) && ((nD20 + nAB) >= nFoeAC)  && (nConcealed == 1) && (nMiss == 0))
		{
			nHit = 1;
		}
		else nHit = 0;
	}

	return nHit;
}