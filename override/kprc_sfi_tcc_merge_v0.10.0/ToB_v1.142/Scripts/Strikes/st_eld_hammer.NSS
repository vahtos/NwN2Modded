//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 9/19/2009								//
//	Title: st_eld_hammer						//
//	Description: As part of this maneuver, you  //
//  make a single melee attack. This attack 	//
//  deals an extra 6d6 points of damage and 	//
//  automatically overcomes damage reduction and//
//	hardness.									//
//////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 151);

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
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget, d6(6), TRUE));
	ExpendManeuver(151, "STR");
}