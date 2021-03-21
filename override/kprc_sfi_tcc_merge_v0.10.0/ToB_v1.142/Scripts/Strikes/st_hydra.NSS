//////////////////////////////////////////////////////////////////
//	Author: Drammel												//
//	Date: 10/17/2009											//
//	Title: st_hydra												//
//	Description: As part of this maneuver, make a single melee  //
//  attack. If this attack hits, your target takes normal damage//
//  and cannot make a full attack on its next turn. Otherwise,  //
//  it can act normally.          						        //
//////////////////////////////////////////////////////////////////

#include "bot9s_inc_feats"
#include "bot9s_inc_maneuvers"

void HydraSlayingStrike(object oTarget, effect eVis, effect eDazing)
{
	int nAction = GetCurrentAction(oTarget);

	if (nAction == ACTION_ATTACKOBJECT)
	{
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 6.0f);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDazing, oTarget, 6.0f);
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 106);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "SettingSunStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "SettingSunStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);

	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	BasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));
	ExpendManeuver(106, "STR");

	if (nHit > 0)
	{
		int nAction = GetCurrentAction(oTarget);
		effect eVis = EffectVisualEffect(VFX_DUR_STUN);
		effect eDazing = EffectDazed();
		eDazing = ExtraordinaryEffect(eDazing);

		if (nAction == ACTION_ATTACKOBJECT)// The important distinction of this maneuver is that it only stops a full attack action, not spell casting or movement.
		{
			DelayCommand(0.3f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 6.0f));
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDazing, oTarget, 6.0f);
		}

		DelayCommand(6.0f, HydraSlayingStrike(oTarget, eVis, eDazing)); //Due to the wording of the maneuver I'm assuming this maneuver ends the target's current attack action and the one for the next round.

		if (GetLocalInt(oToB, "FallingSun") == 1) //Falling Sun Feat Support
		{
			effect eFallingSun = FallingSunAttack(oTarget);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFallingSun, oTarget, 6.0f);
		}
	}
}