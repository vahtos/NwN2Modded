//////////////////////////////////////////////////////////////////
//	Author: Drammel												//
//	Date: 9/14/2009												//
//	Title: st_daunting											//
//	Description: As part of this maneuver, you make a melee     //
//  attack against an opponent you threaten. If this attack     //
//  hits, your foe must make a Will save with a DC equal to the //
//  damage you deal or become shaken for 1 minute.				//
//////////////////////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_fx"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"
#include "tob_i0_spells"

effect EffectShaken()
{
	effect eShaken;
	effect eAttack = EffectAttackDecrease(2);
	effect eSaves = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
	effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
	eShaken = EffectLinkEffects(eAttack, eSaves);
	eShaken = EffectLinkEffects(eShaken, eSkill);
	eShaken = ExtraordinaryEffect(eShaken);

	return eShaken;
}

void DauntingStrike(object oTarget)
{
	object oPC = OBJECT_SELF;
	int nDC = GetLocalInt(oPC, "bot9s_StrikeTotal");
	int nWill = MySavingThrow(SAVING_THROW_WILL, oTarget, nDC);

	if (nWill == 0)
	{
		effect eDaunting = EffectShaken();

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaunting, oTarget, 6.0f);
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 34);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oPC, "bot9s_StrikeTotal", 0);
	SetLocalInt(oToB, "DevotedSpiritStrike", 1);
	DelayCommand(5.0f, SetLocalInt(oPC, "bot9s_StrikeTotal", 0));
	DelayCommand(6.0f, SetLocalInt(oToB, "DevotedSpiritStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);

	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	WrapperPlayCustomAnimation(oPC, "*powerattack", 0);
	StrikeTrailEffect(oWeapon, nHit, 1.0f);
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));
	ExpendManeuver(34, "STR");

	if (nHit > 0)
	{	// Delayed so that the old damage total can be cleared properly before the new total.
		DelayCommand(0.4f, DauntingStrike(oTarget));
	}
}