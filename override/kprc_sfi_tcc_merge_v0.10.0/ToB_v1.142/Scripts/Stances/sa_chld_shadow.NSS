//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 6/20/2009	Happy Birthday Josh!	//
//	Title: sa_chld_shadow					//
//	Description: Stance; Applies a minus 4	//
//	penalty to attack rolls to an creature	//
//	that is not targeting the initiator of	//
//	this stance.							//
//////////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void ChildofShadow()
{
	if (ValidateStance(119))
	{
		object oPC = OBJECT_SELF;
		location lPC = GetLocation(oPC);
		location lLast = GetLocalLocation(oPC, "ChildofShadow");

		if (GetDistanceBetweenLocations(lPC, lLast) >= FeetToMeters(10.0f))
		{
			effect eShadow = EffectConcealment(20);
			eShadow = SupernaturalEffect(eShadow);

			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShadow, oPC, 6.0f);
		}
		
		DelayCommand(6.0f, ChildofShadow());
	}
}

void RunCoSLocation()
{
	object oPC = OBJECT_SELF;

	if (ValidateStance(119) == TRUE)
	{
		SetLocalLocation(oPC, "ChildofShadow", GetLocation(oPC));
		DelayCommand(6.0f, RunCoSLocation());
	}
	else DeleteLocalLocation(oPC, "ChildofShadow");
}

void main()
{
	object oPC = OBJECT_SELF;

	SetLocalLocation(oPC, "ChildofShadow", GetLocation(oPC));
	DelayCommand(5.8f, ChildofShadow());
	RunCoSLocation();
}