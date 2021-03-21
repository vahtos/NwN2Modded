//////////////////////////////////////////////////////////////////
//	Author: Drammel												//
//	Date: 10/1/2009												//
//	Title: st_desert_temp										//
//	Description: As part of this maneuver, you move up to your  //
//  speed. Each time you exit a square adjacent to an enemy, you//
//  can first make a single melee attack against that foe. You  //
//  cannot attack a single enemy more than once with this       //
//  maneuver. Your movement provokes attacks of opportunity, as //
//  normal.  Most of this function's work is handled in         //
//  bot9s_inc_misc.                                             //
//////////////////////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"

void CleanUp(object oPC, object oToB)
{
	DeleteLocalObject(oToB, "DesertTempestFoe1");
	DeleteLocalObject(oToB, "DesertTempestFoe2");
	DeleteLocalObject(oToB, "DesertTempestFoe3");
	DeleteLocalObject(oToB, "DesertTempestFoe4");
	DeleteLocalObject(oToB, "DesertTempestFoe5");
	DeleteLocalObject(oToB, "DesertTempestFoe6");
	DeleteLocalObject(oToB, "DesertTempestFoe7");
	DeleteLocalObject(oToB, "DesertTempestFoe8");
	DeleteLocalObject(oToB, "DesertTempestFoe9");
	DeleteLocalObject(oToB, "DesertTempestFoe10");
}
	
void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 5);

	DeleteLocalInt(oPC, "DesertTempestActive");
	DelayCommand(0.1f, CleanUp(oPC, oToB));

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DesertWindStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DesertWindStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);

	if (GetLocalInt(oTarget, "DesertTempestHit") == 0)
	{
		StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
		DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));
	}

	BasicAttackAnimation(oWeapon, nHit);
	ExpendManeuver(5, "STR");
}