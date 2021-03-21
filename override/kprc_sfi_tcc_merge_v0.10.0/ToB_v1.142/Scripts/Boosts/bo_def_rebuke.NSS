//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 8/27/2009								//
//	Title: bo_def_rebuke						//
//	Description:  If an opponent  				//
//  attacks anyone other than you in melee for  //
//  the duration of the maneuver, that attack   //
//  provokes an attack of opportunity from you. //
//  Enemies you strike become aware of the 		//
//  consequences of the maneuver.				//
//////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oFoe = IntToObject(GetLocalInt(oToB, "Target"));
	
	if (GetLocalInt(oToB, "Swift") == 0)	
	{
		object oFriend = GetAttackTarget(oFoe);

		if ((oFriend != oPC) && (oFriend != OBJECT_INVALID))
		{
			object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

			int nHit = StrikeAttackRoll(oWeapon, oFoe);
	
			StrikeAttackSound(oWeapon, oFoe, nHit, 0.2f);
			BasicAttackAnimation(oWeapon, nHit); 
			DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oFoe));
			AssignCommand(oFoe, ClearAllActions(TRUE));
			AssignCommand(oFoe, ActionAttack(oPC));
		}
		
		RunSwiftAction(35, "B");
		ExpendManeuver(35, "B");
	}
}