//////////////////////////////////////////////////////////////////
//	Author: Drammel												//
//	Date: Halloween 2009										//
//	Title: st_5_shadow	  										//
//	Description: As part of this maneuver, you make a single    //
//  melee attack. If you hit, you deal normal melee damage plus //
//  an extra 15d6 points of damage, and a shadow spreads out    //
//  from your enemy's heart, freezing the blood in his veins. A //
//  d20 is rolled to determine toward which point of his body   //
//  the freezing shadow spreads. This effect functions even if  //
//  your opponent is not humanoid; once you have struck your    //
//  foe's heart, the shadow produces the same effects even in a //
//  creature with a different anatomy.  Result of 1–7: Spreads  //
//  out to legs. Ability damage: 2d6 Dex. Special effect: Speed //
//  is reduced to 0 feet.  Result of 8–14: Spreads out to arms. //
//  Ability damage: 2d6 Str. Special effect: -6 penalty on      //
//  attack rolls and Concentration checks.  Result of 15–20:    //
//  Struck in the heart. Ability damage: 2d6 Dex, 2d6 Str.      //
//  Special effect: 2d6 points of Constitution damage.  A foe   //
//  struck by this attack must make a successful Fortitude save //
//  (DC 19 + your Wis modifier) to resist its effects. On a     //
//  successful save, the target ignores any special effect from //
//  the attack and takes half the indicated ability damage (but //
//  still takes normal melee damage as well as the extra 15d6   //
//  points of damage). Each of the special effects lasts for 1d6//
//  rounds.                                                     //
//////////////////////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"
#include "tob_i0_spells"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 126);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "ShadowHandStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "ShadowHandStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);
	
	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	BasicAttackAnimation(oWeapon, nHit); 
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget, d6(15)));
	ExpendManeuver(126, "STR");

	int nNonLiving; // Ruling that these immunities block the special effects as well for the maneuver.

	if ((GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT) || (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD))
	{
		nNonLiving = 1;
	}
	else nNonLiving = 0;

	if ((nHit > 0) && (nNonLiving == 0) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_ABILITY_DECREASE)))
	{
		int nd20 = d20(1);
		int nWisdom = GetAbilityModifier(ABILITY_WISDOM, oPC);
		int nDC = GetManeuverDC(nWisdom, 0, 19);
		int nFort = MySavingThrow(SAVING_THROW_FORT, oTarget, nDC);

		if (nFort == 0)
		{
			int nDuration = d6(1);

			if (nd20 <= 7)
			{
				SendMessageToPC(oPC, "<color=chocolate>Five-Shadow Creeping Ice Enervation Strike strikes " + GetName(oTarget) + "'s legs!</color>");
				int nNumber;
	
				if (nHit == 2) // According the the Rules Compendium this does get multiplied.
				{
					nNumber = d6(4);
				}
				else nNumber = d6(2);
	
				effect eVis = EffectVisualEffect(VFX_TOB_5_SHADOW_LEGS);
				effect eSpecial = EffectMovementSpeedDecrease(99);
				eSpecial = SupernaturalEffect(eSpecial);
				effect eLegs = EffectAbilityDecrease(ABILITY_DEXTERITY, nNumber);
				eLegs = SupernaturalEffect(eLegs);
				eLegs = SetEffectSpellId(eLegs, -1);
	
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 2.0f);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpecial, oTarget, RoundsToSeconds(nDuration));
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLegs, oTarget);
				DelayCommand(0.4f, DropDead(oTarget, ABILITY_DEXTERITY));
			}
			else if ((nd20 > 7) && (nd20 < 15))
			{
				SendMessageToPC(oPC, "<color=chocolate>Five-Shadow Creeping Ice Enervation Strike strikes " + GetName(oTarget) + "'s arms!</color>");
				int nNumber;
	
				if (nHit == 2)
				{
					nNumber = d6(4);
				}
				else nNumber = d6(2);
	
				effect eVis = EffectVisualEffect(VFX_TOB_5_SHADOW_ARMS);
				effect eAttack = EffectAttackDecrease(6);
				effect eConcentration = EffectSkillDecrease(SKILL_CONCENTRATION, 6);
				effect eSpecial = EffectLinkEffects(eAttack, eConcentration);
				eSpecial = SupernaturalEffect(eSpecial);
				effect eArms = EffectAbilityDecrease(ABILITY_STRENGTH, nNumber);
				eArms = SupernaturalEffect(eArms);
				eArms = SetEffectSpellId(eArms, -1);
	
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 2.0f);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpecial, oTarget, RoundsToSeconds(nDuration));
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, eArms, oTarget);
				DelayCommand(0.4f, DropDead(oTarget, ABILITY_STRENGTH));
			}
			else
			{
				SendMessageToPC(oPC, "<color=chocolate>Five-Shadow Creeping Ice Enervation Strike strikes " + GetName(oTarget) + "'s heart!</color>");
				int nNumber, nNumber2;
	
				if (nHit == 2)
				{
					nNumber = d6(4);
					nNumber2 = d6(4);
				}
				else 
				{
					nNumber = d6(2);
					nNumber2 = d6(2);
				}
	
				effect eVis = EffectVisualEffect(VFX_TOB_5_SHADOW_HEART);
				effect eSpecial = EffectAbilityDecrease(ABILITY_CONSTITUTION, d6(2));
				eSpecial = SupernaturalEffect(eSpecial);
				effect eLegs = EffectAbilityDecrease(ABILITY_DEXTERITY, nNumber);
				effect eArms = EffectAbilityDecrease(ABILITY_STRENGTH, nNumber2);
				effect eHeart = EffectLinkEffects(eArms, eLegs);
				eHeart = SupernaturalEffect(eHeart);
				eHeart = SetEffectSpellId(eHeart, -1);
	
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 2.0f);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpecial, oTarget, RoundsToSeconds(nDuration));
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, eHeart, oTarget);
				DelayCommand(0.4f, DropDead(oTarget, ABILITY_DEXTERITY));
				DelayCommand(0.4f, DropDead(oTarget, ABILITY_STRENGTH));
			}
		}
		else if (GetHasFeat(6818, oTarget)) // Mettle
		{
			return;
		}
		else
		{
			if (nd20 <= 7)
			{
				SendMessageToPC(oPC, "<color=chocolate>Five-Shadow Creeping Ice Enervation Strike strikes " + GetName(oTarget) + "'s legs!</color>");
				int nNumber;
	
				if (nHit == 2) // According the the Rules Compendium this does get multiplied.
				{
					nNumber = d6(2);
				}
				else nNumber = d6(1);
	
				effect eVis = EffectVisualEffect(VFX_TOB_5_SHADOW_LEGS);
				effect eLegs = EffectAbilityDecrease(ABILITY_DEXTERITY, nNumber);
				eLegs = SupernaturalEffect(eLegs);
				eLegs = SetEffectSpellId(eLegs, -1);
	
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 2.0f);
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLegs, oTarget);
				DelayCommand(0.4f, DropDead(oTarget, ABILITY_DEXTERITY));
			}
			else if ((nd20 > 7) && (nd20 < 15))
			{
				SendMessageToPC(oPC, "<color=chocolate>Five-Shadow Creeping Ice Enervation Strike strikes " + GetName(oTarget) + "'s arms!</color>");
				int nNumber;
	
				if (nHit == 2)
				{
					nNumber = d6(2);
				}
				else nNumber = d6(1);
	
				effect eVis = EffectVisualEffect(VFX_TOB_5_SHADOW_ARMS);
				effect eArms = EffectAbilityDecrease(ABILITY_STRENGTH, nNumber);
				eArms = SupernaturalEffect(eArms);
				eArms = SetEffectSpellId(eArms, -1);
	
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 2.0f);
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, eArms, oTarget);
				DelayCommand(0.4f, DropDead(oTarget, ABILITY_STRENGTH));
			}
			else
			{
				SendMessageToPC(oPC, "<color=chocolate>Five-Shadow Creeping Ice Enervation Strike strikes " + GetName(oTarget) + "'s heart!</color>");
				int nNumber, nNumber2;
	
				if (nHit == 2)
				{
					nNumber = d6(2);
					nNumber2 = d6(2);
				}
				else 
				{
					nNumber = d6(1);
					nNumber2 = d6(1);
				}
	
				effect eVis = EffectVisualEffect(VFX_TOB_5_SHADOW_HEART);
				effect eLegs = EffectAbilityDecrease(ABILITY_DEXTERITY, nNumber);
				effect eArms = EffectAbilityDecrease(ABILITY_STRENGTH, nNumber2);
				effect eHeart = EffectLinkEffects(eArms, eLegs);
				eHeart = SupernaturalEffect(eHeart);
				eHeart = SetEffectSpellId(eHeart, -1);
	
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 2.0f);
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, eHeart, oTarget);
				DelayCommand(0.4f, DropDead(oTarget, ABILITY_DEXTERITY));
				DelayCommand(0.4f, DropDead(oTarget, ABILITY_STRENGTH));
			}
		}
	}
}