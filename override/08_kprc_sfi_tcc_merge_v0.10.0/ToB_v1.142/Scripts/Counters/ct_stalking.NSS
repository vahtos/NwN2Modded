//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 9/18/2009							//
//	Title: ct_stalking						//
//	Description: When an opponent adjacent  //
//  to you moves, you can initiate this     //
//  maneuver to immediately move adjacent to//
//  her as soon as she stops moving, as long//
//  as the distance you cover is less than  //
//  or equal to your speed. This movement   //
//  does not provoke attacks of opportunity.//
//////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void StalkingShadow(object oPC, object oToB)
{
	object oTarget = GetLocalObject(oToB, "StalkingShadow");

	if ((ValidateCounter(112)) && GetIsObjectValid(oTarget))
	{
		location lTarget = GetLocation(oTarget);
		location lLast = GetLocalLocation(oPC, "Stalking_loc");

		if (lLast != lTarget)
		{
			if ((GetDistanceBetweenLocations(lLast, lTarget) >= FeetToMeters(5.0f)) && (LineOfEffect(oPC, lLast, TRUE)))
			{
				ClearStrikes();
				ClearAllActions();
				JumpToLocation(lLast);
				FloatingTextStringOnCreature("<color=cyan>*Stalking Shadow!*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
				RunSwiftAction(112, "C");
			}
			else DelayCommand(1.0f, StalkingShadow(oPC, oToB));
		}
		else DelayCommand(1.0f, StalkingShadow(oPC, oToB));
	}
	else DeleteLocalLocation(oPC, "Stalking_loc");
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = IntToObject(GetLocalInt(oToB, "Target"));
	
	if (NotMyFoe(oPC, oTarget))
	{
		SendMessageToPC(oPC, "<color=red>You cannot target yourself or your allies with this maneuver.</color>");
		return;
	}

	if (GetDistanceBetween(oPC, oTarget) - GetGirth(oTarget) <= FeetToMeters(8.0f))
	{
		SetLocalObject(oToB, "StalkingShadow", oTarget);
		SetLocalLocation(oPC, "Stalking_loc", GetLocation(oTarget));
		ExpendManeuver(112, "C");
		StalkingShadow(oPC, oToB);
	}
	else SendMessageToPC(oPC, "<color=red>You must choose a target adjacent to you.</color>");
}