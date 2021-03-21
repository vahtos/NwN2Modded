//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 9/10/2009									//
//	Title: ct_lightning_rec							//
//	Description: If one of your melee attacks       //
//  misses, you can initiate this maneuver to reroll//
//  that attack roll with a +2 bonus.  Most of this //
//  function's work is handled in StrikeAttackRoll. //
//////////////////////////////////////////////////////

#include "bot9s_combat_overrides"
#include "bot9s_inc_maneuvers"

void LightningRecovery()
{
	object oPC = OBJECT_SELF;

	if (ValidateCounter(86))
	{
		if (GetLocalInt(oPC, "bot9s_overridestate") > 0)
		{
			//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
			//2 = Combat round is pending and the command has already been sent, do nothing.
		}
		else ManageCombatOverrides(TRUE);

		DelayCommand(6.0f, LightningRecovery());
	}
	else ProtectedClearCombatOverrides(oPC);
}


void main()
{
	object oPC = OBJECT_SELF;

	SetLocalInt(oPC, "LightningRecovery", 1);
	ExpendManeuver(86, "C");
	LightningRecovery();
}