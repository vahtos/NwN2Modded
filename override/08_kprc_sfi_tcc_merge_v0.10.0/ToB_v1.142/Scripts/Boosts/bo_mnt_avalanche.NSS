//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 9/19/2009								//
//	Title: bo_mnt_avalanche						//
//	Description: As part of this maneuver, you  //
//  move at double your speed and trample your  //
//  opponents. You can enter the space of any   //
//  creature of your size category or smaller.  //
//  If you enter and occupy all of the space    //
//  occupied by such a creature, it takes damage//
//  equal to 2d6 + 1-1/2 times your Str bonus   //
//  (if any). You can deal trampling damage to a//
//  creature only once per round, no matter how //
//  many times you move into or through its     //
//  space. When you move into the space a       //
//  creature occupies to trample, it can attempt//
//  an attack of opportunity against you and it //
//  can attempt a Reflex save (DC 15 + your Str //
//  modifier) to avoid half of your damage.     //
//////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_include"
#include "tob_i0_spells"

void DelayedJump(object oPC, object oToB, object oTarget)
{
	location lPC = GetLocation(oPC);
	float fGirth = GetGirth(oTarget) + 0.01f;
	location lPop = CalcSafeLocation(oPC, lPC, fGirth, FALSE, TRUE);

	JumpToLocation(lPop);
	DeleteLocalLocation(oPC, "MountainAvalanche_loc");
	DeleteLocalObject(oToB, "MountainAvalanche");
}

void MountainAvalanche(object oPC, object oToB)
{
	location lPC = GetLocation(oPC);
	location lLast = GetLocalLocation(oPC, "MountainAvalanche_loc");

	if (lPC != lLast)
	{
		SetLocalLocation(oPC, "MountainAvalanche_loc", lPC);

		if (GetCollision(oPC) == TRUE)
		{
			SetCollision(oPC, FALSE);
		}

		int nStr;

		if (GetAbilityModifier(ABILITY_STRENGTH, oPC) < 1)
		{
			nStr = 1;
		}
		else nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);

		int nGiant; // Because I can.

		if ((GetLocalInt(oToB, "Stance") == 152) || (GetLocalInt(oToB, "Stance2") == 152))
		{
			nGiant = 1;
		}
		else nGiant = 0;

		int nMod = FloatToInt(1.5f * IntToFloat(nStr));
		int nDC = GetManeuverDC(nStr, 0, 15);
		int nMySize = GetCreatureSize(oPC) + nGiant;
		float fRange = GetGirth(oPC);
		object oTarget;
		int nFoeSize, nDamage;
		effect eDamage;

		oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);

		while (GetIsObjectValid(oTarget))
		{
			nFoeSize = GetCreatureSize(oTarget);

			if ((GetIsReactionTypeHostile(oTarget, oPC)) && (nMySize >= nFoeSize) && (GetLocalInt(oTarget, "MountainAvalanched") == 0))
			{
				nDamage = Bot9sReflexAdjustedDamage(d6(2) + nMod, oTarget, nDC);
				eDamage = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);

				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
				SetLocalInt(oTarget, "MountainAvalanched", 1);
				SetLocalObject(oToB, "MountainAvalanche", oTarget);
				AssignCommand(oTarget, DelayCommand(6.0f, DeleteLocalInt(oTarget, "MountainAvalanched")));
			}
			else if (nMySize < nFoeSize)
			{
				ClearStrikes();
				ClearAllActions();
				SetCollision(oPC, TRUE);
				DelayCommand(0.1f, DelayedJump(oPC, oToB, oTarget)); //JumpTo functions place themselves at the start of the queue.
				return;
			}

			oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);
		}

		DelayCommand(1.0f, MountainAvalanche(oPC, oToB));
	}
	else
	{
		object oTarget = GetLocalObject(oToB, "MountainAvalanche");

		ClearStrikes();
		ClearAllActions();
		SetCollision(oPC, TRUE);
		DelayCommand(0.1f, DelayedJump(oPC, oToB, oTarget));
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	float fx = GetManeuverX(oToB, 155);
	float fy = GetManeuverY(oToB, 155);
	float fz = GetManeuverZ(oToB, 155);
	vector vTarget = Vector(fx, fy, fz);
	location lTarget = Location(GetArea(oPC), vTarget, GetFacing(oPC));
	
	if (GetLocalInt(oToB, "Swift") == 0)	
	{
		if (GetCollision(oPC) == TRUE)
		{
			SetCollision(oPC, FALSE);
		}

		effect eSpeed = EffectMovementSpeedIncrease(99);
		effect eSize = EffectSetScale(1.5f);
		effect eAvalanche = EffectLinkEffects(eSpeed, eSize);
		eAvalanche = ExtraordinaryEffect(eAvalanche);

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAvalanche, oPC, 6.0f);
		ClearAllActions();
		ClearStrikes();
		ActionMoveToLocation(lTarget, TRUE);
		RunSwiftAction(155, "B");
		ExpendManeuver(155, "B");
		MountainAvalanche(oPC, oToB);
	}
}