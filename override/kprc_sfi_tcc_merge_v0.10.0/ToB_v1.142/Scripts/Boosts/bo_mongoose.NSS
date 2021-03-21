//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 9/20/2009								//
//	Title: bo_mongoose							//
//	Description:  You make a flurry of deadly   //
//  attacks. After initiating this boost, you   //
//  can make one additional attack with each    //
//  weapon you wield (to a maximum of two extra //
//  attacks if you wield two or more weapons).  //
//  These extra attacks are made at your highest//
//  attack bonus for each of your respective    //
//  weapons. All of these attacks must be       //
//  directed against the same opponent.			//
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

		BasicAttackAnimation(oWeapon, nHit, TRUE);
		StrikeAttackSound(oWeapon, oFoe, nHit, 0.2f); 
		DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oFoe));

		if (GetIsObjectValid(oOffHand))
		{
			int nHit1 = StrikeAttackRoll(oOffHand, oFoe);

			StrikeAttackSound(oOffHand, oFoe, nHit, 0.3f); 
			DelayCommand(0.4f, StrikeWeaponDamage(oOffHand, nHit, oFoe));
		}

		if (GetLocalInt(oToB, "TimeStandsActive") == 1) // Allowed accoring to "The Sage".
		{
			int nHit3 = StrikeAttackRoll(oWeapon, oFoe);

			BasicAttackAnimation(oWeapon, nHit3, TRUE);
			StrikeAttackSound(oWeapon, oFoe, nHit3, 0.4f); 
			DelayCommand(0.5f, StrikeWeaponDamage(oWeapon, nHit, oFoe));
	
			if (GetIsObjectValid(oOffHand))
			{
				int nHit4 = StrikeAttackRoll(oOffHand, oFoe);
	
				StrikeAttackSound(oOffHand, oFoe, nHit4, 0.5f); 
				DelayCommand(0.6f, StrikeWeaponDamage(oOffHand, nHit4, oFoe));
			}
		}

		RunSwiftAction(167, "B");
		ExpendManeuver(167, "B");
	}
	else SendMessageToPC(oPC, "<color=red>You were unable to initiate Dancing Mongoose.</color>");
}