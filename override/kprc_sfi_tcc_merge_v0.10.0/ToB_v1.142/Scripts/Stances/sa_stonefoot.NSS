//////////////////////////////////////////
//  Author: Drammel						//
//  Date: 6/19/2009						//
//  Title: sa_stonefoot					//
//  Description: Grants +2 AC as long as//
//	the player doesn't move.			//
//////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void StonefootStance()
{
	object oPC = OBJECT_SELF;

	if (ValidateStance(163))
	{
		location lStonefoot = GetLocalLocation(oPC, "StonefootStance");
		location lPC = GetLocation(oPC);
		float fDist = GetDistanceBetweenLocations(lPC, lStonefoot);

		if (fDist <= FeetToMeters(5.0f))
		{
			effect eAC = EffectACIncrease(2);
			eAC = ExtraordinaryEffect(eAC);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, 6.0f);
			DelayCommand(6.0f, StonefootStance());
		}
		else
		{
			DeleteLocalLocation(oPC, "StonefootStance");

			object oToB = GetItemPossessedBy(oPC, "tob");

			if (GetLocalInt(oToB, "Stance") == 163)
			{
				SetLocalInt(oToB, "Stance", 0);
				SendMessageToPC(oPC, "<color=red>You have moved more than five feet from where you initiated Stonefoot Stance.  Stonefoot Stance has ended.</color>");
			}
			else if (GetLocalInt(oToB, "Stance2") == 163)
			{
				SetLocalInt(oToB, "Stance2", 0);
				SendMessageToPC(oPC, "<color=red>You have moved more than five feet from where you initiated Stonefoot Stance.  Stonefoot Stance has ended.</color>");
			}
		}
	}
	else DeleteLocalLocation(oPC, "StonefootStance");
}

void main()
{
	object oPC = OBJECT_SELF;

	SetLocalLocation(oPC, "StonefootStance", GetLocation(oPC));
	StonefootStance();
}