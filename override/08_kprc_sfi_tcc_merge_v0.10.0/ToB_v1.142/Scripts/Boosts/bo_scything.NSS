//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 10/17/2009								//
//	Title: bo_scything						 	    //
//	Description:  You make a melee attack against an//
//  enemy you are currently attacking.  If this     //
//  attack hits you immediately make a free attack  //
//  at your highest attack bonus against a different//
//  enemy that you threaten.  You must be actively  //
//  engaged in an attack action to initiate this    //
//  maneuver.										//
//////////////////////////////////////////////////////

#include "bot9s_inc_fx"
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
		int nHit = StrikeAttackRoll(oWeapon, oFoe);

		StrikeTrailEffect(oWeapon, nHit, 2.0f);
		WrapperPlayCustomAnimation(oPC, "*whirlwind", 0); 
		StrikeAttackSound(oWeapon, oFoe, nHit, 0.2f); 
		DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oFoe));

		location lPC = GetLocation(oPC);
		object oFoe2;

		oFoe2 = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);

		while (GetIsObjectValid(oFoe2))
		{
			if ((oFoe != oFoe2) && (GetIsReactionTypeHostile(oFoe2, oPC)))
			{
				break;
			}
			else oFoe2 = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);
		}
	
		float fDistance = GetDistanceBetween(oPC, oFoe2);
	
		if (GetDistanceBetween(oPC, oFoe2) > fRange)
		{
			oFoe2 = OBJECT_INVALID;
		}
	
		if (GetIsObjectValid(oFoe2) && (nHit > 0))
		{
			int nHit2 = StrikeAttackRoll(oWeapon, oFoe2);

			StrikeAttackSound(oWeapon, oFoe2, nHit2, 0.3f);
			DelayCommand(0.4f, StrikeWeaponDamage(oWeapon, nHit2, oFoe2));
		}

		RunSwiftAction(91, "B");
		ExpendManeuver(91, "B");
	}
	else SendMessageToPC(oPC, "<color=red>You were unable to initiate Scything Blade.</color>");
}