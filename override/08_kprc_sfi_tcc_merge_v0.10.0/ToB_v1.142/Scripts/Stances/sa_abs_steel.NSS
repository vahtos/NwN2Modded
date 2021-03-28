//////////////////////////////////////////////////////
//  Author: Drammel									//
//  Date: 8/25/2009									//
//  Title: sa_abs_steel								//
//  Description: While you are in this stance, you  //
//  gain a +10-foot enhancement bonus to your speed.//
//  If you move at least 10 feet during your turn,  //
//  you gain a +2 dodge bonus to AC until the       //
//  beginning of your next turn.					//
//////////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void AbsoluteSteel()
{
	object oPC = OBJECT_SELF;

	if (ValidateStance(76))
	{
		// Given that average speed is equal to one round = 30ft, this is roughly a 10ft per round increase.
		effect eSpeed = EffectMovementSpeedIncrease(33);
		eSpeed = ExtraordinaryEffect(eSpeed);
		location lAbsSteel = GetLocalLocation(oPC, "AbsoluteSteel");
		location lPC = GetLocation(oPC);
		float fDist = GetDistanceBetweenLocations(lPC, lAbsSteel);

		if (fDist >= FeetToMeters(10.0f))
		{
			effect eAC = EffectACIncrease(2);
			eAC = ExtraordinaryEffect(eAC);

			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, 6.0f);
		}

		SetLocalLocation(oPC, "AbsoluteSteel", lPC);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpeed, oPC, 6.0f);
		DelayCommand(6.0f, AbsoluteSteel());
	}
	else DeleteLocalLocation(oPC, "AbsoluteSteel");
}


void main()
{
	object oPC = OBJECT_SELF;

	SetLocalLocation(oPC, "AbsoluteSteel", GetLocation(oPC));
	AbsoluteSteel();
}