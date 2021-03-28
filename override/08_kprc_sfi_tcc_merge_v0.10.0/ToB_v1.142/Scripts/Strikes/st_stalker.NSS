//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 10/6/2009							//
//	Title: st_stalker						//
//	Description: When you initiate this     //
//  maneuver, if your target can neither see//
//  nor hear you, your attack deals an extra//
//  6d6 damage.  If your target is aware of //
//  the impending attack this strike only   //
//  deals an extra 2d6 of damage.           //
//////////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 138);

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
	ExpendManeuver(138, "STR");

	if (nHit > 0)
	{
		if (!GetObjectSeen(oPC, oTarget) && !GetObjectHeard(oPC, oTarget))
		{
			DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget, d6(6)));
		}
		else DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget, d6(2)));
	}
	else DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));
}