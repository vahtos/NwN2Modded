//////////////////////////////////////////////////////////
//	Author: Drammel										//
//	Date: 10/7/2009										//
//	Title: st_wolf_climbs								//
//	Description: You can use this maneuver only against //
//  an opponent of a size category larger than yours. As//
//  part of this maneuver, you enter your target’s      //
//  square without provoking an attack of opportunity.  //
//  You can then attack your target as part of this     //
//  maneuver. Your attack deals an extra 5d6 points of  //
//  damage. You remain within your opponent’s space     //
//  after you complete this maneuver. You gain cover    //
//  against all attacks as long as you remain in his    //
//  space, including those made by the target. If the   //
//  target moves, it leaves you behind but provokes an  //
//  attack of opportunity from you for leaving your     //
//  space.                                              //
//////////////////////////////////////////////////////////

#include "bot9s_inc_feats"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void Climb(location lTarget)
{
	object oPC = OBJECT_SELF;

	ClearStrikes();
	JumpToLocation(lTarget);
}

void WolfClimbsMountain(object oTarget, location lTarget, float fTarget)
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	if (GetIsObjectValid(oTarget))
	{
		float fDist = GetDistanceBetween(oTarget, oPC);

		if ((fDist <= fTarget) && (GetLocalInt(oToB, "WolfClimbsCheck") == 0))
		{
			location lFoe = GetLocation(oTarget);
			effect eAC = EffectACIncrease(4);
			eAC = ExtraordinaryEffect(eAC);

			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, 1.0f);
			DelayCommand(1.0f, WolfClimbsMountain(oTarget, lFoe, fTarget));
		}
		else // Double check to make sure that we can turn collision back on and not get stuck.
		{
			location lPC = GetLocation(oPC);
			float fPC = GetGirth(oPC);
			object oCheck;
			int nCheck;

			oCheck = GetFirstObjectInShape(SHAPE_SPHERE, fPC, lPC);
			nCheck = 1;

			while (GetIsObjectValid(oCheck))
			{
				if (GetIsObjectValid(oCheck) && (oCheck != oPC)) //Checking for any creature that isn't me in my personal bubble.
				{
					nCheck = 0;
					break;
				}

				oCheck = GetNextObjectInShape(SHAPE_SPHERE, fPC, lPC);
			}

			if (nCheck == 1) //Green Light
			{
				SetCollision(oPC, TRUE);
				DeleteLocalInt(oToB, "WolfClimbsCheck");
			}
			else //Red Light
			{
				SetLocalInt(oToB, "WolfClimbsCheck", 1);
				DelayCommand(1.0f, WolfClimbsMountain(oTarget, lTarget, fTarget));
			}
		}
	}
	else // Same as above only for after the target is dead.
	{
		location lPC = GetLocation(oPC);
		float fPC = GetGirth(oPC);
		object oCheck;
		int nCheck;

		oCheck = GetFirstObjectInShape(SHAPE_SPHERE, fPC, lPC);
		nCheck = 1;

		while (GetIsObjectValid(oCheck))
		{
			if (GetIsObjectValid(oCheck) && (oCheck != oPC)) //Checking for any creature that isn't me in my personal bubble.
			{
				nCheck = 0;
				break;
			}

			oCheck = GetNextObjectInShape(SHAPE_SPHERE, fPC, lPC);
		}

		if (nCheck == 1) //Green Light
		{
			SetCollision(oPC, TRUE);
			DeleteLocalInt(oToB, "WolfClimbsCheck");
		}
		else //Red Light
		{
			SetLocalInt(oToB, "WolfClimbsCheck", 1);
			DelayCommand(1.0f, WolfClimbsMountain(oTarget, lTarget, fTarget));
		}
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 184);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "TigerClawStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "TigerClawStrike", 0));

	int nMySize = GetCreatureSize(oPC);
	int nFoeSize = GetCreatureSize(oTarget);

	if (nMySize > nFoeSize)
	{
		SendMessageToPC(oPC, "<color=red>This maneuver can only be initiated against a target at least one size category larger than you are.</color>");
		return;
	}

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);
	location lTarget = GetLocation(oTarget);
	float fTarget = GetGirth(oTarget) + 0.01f;

	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	BasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget, d6(5)));
	ExpendManeuver(184, "STR");

	if (nHit > 0)
	{
		if (GetHasFeat(FEAT_TIGER_BLOODED, oPC))
		{
			DelayCommand(0.3f, TigerBlooded(oPC, oWeapon, oTarget));
		}
	}

	DelayCommand(1.35f, ClearAllActions());
	DelayCommand(1.35f, SetCollision(oPC, FALSE));
	DelayCommand(1.4f, Climb(lTarget)); //Enough time for the animation to finish in most cases.
	DelayCommand(1.5f, WolfClimbsMountain(oTarget, lTarget, fTarget));
}