///////////////////////////////////////////////////////
//	Author: Drammel									 //
//	Date: 10/17/2009								 //
//	Title: st_finishing							   	 //
//	Description: As part of this maneuver, you make a//
//  melee attack against a creature. This attack     //
//  deals an extra 4d6 points of damage. If the      //
//  target’s current hit points are less than its    //
//  full normal hit points, the attack instead deals //
//  an extra 6d6 points of damage. If its hit points //
//  are equal to or less than one-half its full      //
//  normal hit points, the attack instead deals an   //
//  extra 14d6 points of damage.					 //
///////////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 82);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "IronHeartStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "IronHeartStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);
	int nMax = GetMaxHitPoints(oTarget);
	int nHalf = nMax / 2;
	int nHp = GetCurrentHitPoints(oTarget);

	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	BasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));
	ExpendManeuver(82, "STR");

	if (nHp <= nHalf)
	{
		DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget, d6(14)));
	}
	else if (nHp < nMax)
	{
		DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget, d6(6)));
	}
	else DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget, d6(4)));
}