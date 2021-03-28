//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 10/29/2009							//
//	Title: bo_rage_mongoose						//
//	Description:  You make a flurry of deadly   //
//  attacks. After initiating this boost, you   //
//  can make two additional attacks with each   //
//  weapon you wield (to a maximum of four extra//
//  attacks if you wield two or more weapons).  //
//  These extra attacks are made at your highest//
//  attack bonus for each of your respective    //
//  weapons.                                    //
//////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oFoe = GetAttemptedAttackTarget();
	int nAppearance = GetAppearanceType(oFoe); //Index number of the target in appearance.2da
	float fHitDist = tob_Get2daFloat("appearance", "HITDIST", nAppearance);
	float fRange = GetMeleeRange(oPC) + fHitDist;
	float fDist = GetDistanceBetween(oPC, oFoe) - GetGirth(oFoe);
	
	if (GetIsObjectValid(oFoe) && (GetLocalInt(oToB, "Swift") == 0)	&& (fDist <= fRange))
	{
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		object oOffHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
		int nHit = StrikeAttackRoll(oWeapon, oFoe);
		int nHit2 = StrikeAttackRoll(oWeapon, oFoe);

		BasicAttackAnimation(oWeapon, nHit, TRUE);
		StrikeAttackSound(oWeapon, oFoe, nHit, 0.2f); 
		DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oFoe));
		DelayCommand(0.5f, StrikeWeaponDamage(oWeapon, nHit2, oFoe));

		if (GetIsObjectValid(oOffHand))
		{
			int nHit1 = StrikeAttackRoll(oOffHand, oFoe);
			int nHit3 = StrikeAttackRoll(oWeapon, oFoe);

			StrikeAttackSound(oOffHand, oFoe, nHit, 0.3f); 
			DelayCommand(0.4f, StrikeWeaponDamage(oOffHand, nHit, oFoe));
			DelayCommand(0.6f, StrikeWeaponDamage(oOffHand, nHit3, oFoe));
		}

		if (GetLocalInt(oToB, "TimeStandsActive") == 1) // Allowed accoring to "The Sage".
		{
			int nHit5 = StrikeAttackRoll(oWeapon, oFoe);
			int nHit6 = StrikeAttackRoll(oWeapon, oFoe);

			BasicAttackAnimation(oWeapon, nHit5, TRUE);
			StrikeAttackSound(oWeapon, oFoe, nHit5, 0.6f); 
			DelayCommand(0.7f, StrikeWeaponDamage(oWeapon, nHit5, oFoe));
			DelayCommand(0.7f, StrikeWeaponDamage(oWeapon, nHit6, oFoe));
	
			if (GetIsObjectValid(oOffHand))
			{
				int nHit7 = StrikeAttackRoll(oOffHand, oFoe);
				int nHit8 = StrikeAttackRoll(oOffHand, oFoe);
	
				StrikeAttackSound(oOffHand, oFoe, nHit7, 0.7f); 
				DelayCommand(0.8f, StrikeWeaponDamage(oOffHand, nHit7, oFoe));
				DelayCommand(0.8f, StrikeWeaponDamage(oOffHand, nHit7, oFoe));
			}
		}

		RunSwiftAction(180, "B");
		ExpendManeuver(180, "B");
	}
	else SendMessageToPC(oPC, "<color=red>You were unable to initiate Raging Mongoose.</color>");
}