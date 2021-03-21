//////////////////////////////////////////////
//  Author: Drammel							//
//  Date: 10/29/2009						//
//  Title: sa_str_of_stone					//
//  Description: While you are in this      //
//  stance, you focus your efforts on       //
//  preventing any devastating attacks from //
//  penetrating your defenses. You are      //
//  immune to critical hits while you are in//
//  this stance.  This stance immediately   //
//  ends if you move more than 5 feet for   //
//  any reason.                             //
//////////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void StrengthOfStone()
{
	object oPC = OBJECT_SELF;

	if (ValidateStance(164))
	{
		location lStrStone = GetLocalLocation(oPC, "StrengthOfStone");
		location lPC = GetLocation(oPC);
		float fDist = GetDistanceBetweenLocations(lPC, lStrStone);

		if (fDist <= FeetToMeters(5.0f))
		{
			effect eStrStone = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
			eStrStone = ExtraordinaryEffect(eStrStone);

			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStrStone, oPC, 6.0f);
			DelayCommand(6.0f, StrengthOfStone());
		}
		else
		{
			DeleteLocalLocation(oPC, "StrengthOfStone");

			object oToB = GetItemPossessedBy(oPC, "tob");

			if (GetLocalInt(oToB, "Stance") == 164)
			{
				SetLocalInt(oToB, "Stance", 0);
				SendMessageToPC(oPC, "<color=red>You have moved more than five feet from where you initiated Strength of Stone.  Strength of Stone has ended.</color>");
			}
			else if (GetLocalInt(oToB, "Stance2") == 164)
			{
				SetLocalInt(oToB, "Stance2", 0);
				SendMessageToPC(oPC, "<color=red>You have moved more than five feet from where you initiated Strength of Stone.  Strength of Stone has ended.</color>");
			}
		}
	}
	else DeleteLocalLocation(oPC, "StrengthOfStone");
}

void main()
{
	object oPC = OBJECT_SELF;

	SetLocalLocation(oPC, "StrengthOfStone", GetLocation(oPC));
	StrengthOfStone();
}