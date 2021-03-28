//////////////////////////////////////////
//	Author: Drammel						//
//	Date: 4/2/2009						//
//	Title: gui_charge					//
//	Description: Allows the PC to make	//
//	a charge attack after running to the//
//	target.								//
//////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 211);
	
	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}
	
	//ActionAttack is not used because we can only make a single attack on a charge.
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nRoll = StrikeAttackRoll(oWeapon, oTarget, 2);

	StrikeAttackSound(oWeapon, oTarget, nRoll, 0.3f);
	DelayCommand(0.1f, BasicAttackAnimation(oWeapon, nRoll)); 
	DelayCommand(0.4f, StrikeWeaponDamage(oWeapon, nRoll, oTarget));
}