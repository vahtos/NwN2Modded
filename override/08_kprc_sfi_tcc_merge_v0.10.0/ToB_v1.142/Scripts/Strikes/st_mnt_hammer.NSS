//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 7/31/2009								//
//	Title: st_mnt_hammer						//
//	Description: As part of this maneuver, you  //
//  make a single melee attack. This attack 	//
//  deals an extra 2d6 points of damage and 	//
//  automatically overcomes damage reduction and//
//	hardness.									//
//////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 156);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "StoneDragonStrike", 1);
	DelayCommand(RoundsToSeconds(1), SetLocalInt(oToB, "StoneDragonStrike", 0));
	
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);

	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	BasicAttackAnimation(oWeapon, nHit); 
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget, d6(2), TRUE));
	ExpendManeuver(156, "STR");
}