//////////////////////////////////////////
//  Author: Drammel						//
//  Date: 6/26/2009						//
//  Title: sa_mspirit					//
//  Description: With each successful	//
//	attack the player heals the weakest //
//	memeber of the party within 30ft.	//
//////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_combat_overrides"

void MartialSpirit()
{
	object oPC = OBJECT_SELF;

	if (ValidateStance(44))
	{
		if (GetLocalInt(oPC, "bot9s_overridestate") > 0)
		{
			//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
			//2 = Combat round is pending and the command has already been sent, do nothing.
		}
		else ManageCombatOverrides(TRUE);

		DelayCommand(6.0f, MartialSpirit());
	}
	else ProtectedClearCombatOverrides(oPC);
}

void main()
{
	MartialSpirit();
}