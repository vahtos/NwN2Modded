//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 10/6/2009								//
//	Title: st_ghost_blade						//
//	Description: You attempt a Concentration 	//
//	check as part of this maneuver, using the 	//
//	target creature’s AC as the DC of the check.//
//	You then make a single melee attack against //
//	your target. The attack is also part of this//
//	maneuver. If your Concentration check		//
//	succeeds, the target is flat-footed against	//
//	your attack, and you deal an extra 1d6		//
//	points of damage. If your check fails, your //
//	attack is made with a –2 penalty and deals  //
//	normal damage.								//
//////////////////////////////////////////////////

#include "bot9s_combat_overrides"
#include "bot9s_inc_maneuvers"
#include "bot9s_inc_constants"

void GhostBlade(object oTarget, object oWeapon, int nHit)
{
	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	BasicAttackAnimation(oWeapon, nHit, FALSE, FALSE); 
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 127);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "ShadowHandStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "ShadowHandStrike", 0));
	
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);

	if (nHit > 0)
	{
		OverrideAttackRollAC(oTarget, 2);
		DelayCommand(1.5f, RemoveAttackRollOverride(oTarget, 1));

		effect eGhostBlade = EffectVisualEffect(VFX_TOB_GHOSTBLADE);

		DelayCommand(1.0f, GhostBlade(oTarget, oWeapon, nHit));
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGhostBlade, oPC, 3.0f);
		ExpendManeuver(127, "STR");
	}
}