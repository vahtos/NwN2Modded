//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 8/28/2009								//
//	Title: st_sd_fury							//
//	Description: As part of this maneuver, you  //
//  make a single melee attack. If your attack  //
//  hits the undead, a plant or a construct, you//
//  deal an extra 4d6 points of damage.  Against//
//  other targets, you gain no special benefit  //
//  from this maneuver.							//
//////////////////////////////////////////////////

#include "bot9s_attack"
#include "bot9s_inc_maneuvers"
#include "bot9s_inc_variables"
#include "bot9s_include"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 161);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "StoneDragonStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "StoneDragonStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);

	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	BasicAttackAnimation(oWeapon, nHit);
	ExpendManeuver(161, "STR");

	if ((GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD) || (GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT) || (GetSubRace(oTarget) == RACIAL_SUBTYPE_PLANT))
	{
		DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget, d6(4)));
	}
	else DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));
}