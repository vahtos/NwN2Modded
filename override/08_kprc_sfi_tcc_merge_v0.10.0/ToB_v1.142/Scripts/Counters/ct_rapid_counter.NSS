//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 9/15/2009								//
//	Title: ct_rapid_counter						//
//	Description: This maneuver allows you to    //
//  make a free attack against a reckless enemy.//
//  When a foe provokes an attack of opportunity//
//  from you, you initiate this maneuver. As    //
//  part of this maneuver, you make an immediate//
//  melee attack against the foe that provoked  //
//  the attack of opportunity. This attack does //
//  not replace the normal attack of opportunity//
//  you receive.								//
//////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void RCAttack(object oTarget)
{
	object oPC = OBJECT_SELF;
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);

	FloatingTextStringOnCreature("<color=cyan>*Rapid Counter!*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
	BasicAttackAnimation(oWeapon, nHit, TRUE);
	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));
}

void RapidCounter(object oPC, object oToB)
{
	if (ValidateCounter(70))
	{
		object oTarget = GetLastDamager(oPC);
		location lOld = GetLocalLocation(oPC, "RapidCounter_loc");
		location lTarget = GetLocation(oTarget);
		float fDist = GetDistanceBetween(oPC, oTarget) - GetGirth(oTarget);
		float fRange = GetMeleeRange(oTarget);
		float fOld = GetDistanceBetweenLocations(lTarget, lOld);
		int nProvoke;

		nProvoke = 0;

		if ((fOld <= fRange) && (fDist > fRange))
		{
			nProvoke = 1;
		}
		else if ((GetCurrentAction(oPC) == ACTION_CASTSPELL) && (fDist <= fRange) && (GetLocalInt(oPC, "bot9s_maneuver_running") < 1))
		{
			nProvoke = 1;
		}
		else if ((GetCurrentAction(oPC) == ACTION_TAUNT) && (fDist <= fRange))
		{
			nProvoke = 1;
		}

		if (nProvoke == 1)
		{
			RCAttack(oTarget);
			RunSwiftAction(70, "C");
		}
		else DelayCommand(1.0f, RapidCounter(oPC, oToB));
	}
	else
	{
		DeleteLocalLocation(oPC, "RapidCounter_loc");
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	location lPC = GetLocation(oPC);

	ExpendManeuver(70, "C");
	SetLocalLocation(oPC, "RapidCounter_loc", lPC);
	RapidCounter(oPC, oToB);
}