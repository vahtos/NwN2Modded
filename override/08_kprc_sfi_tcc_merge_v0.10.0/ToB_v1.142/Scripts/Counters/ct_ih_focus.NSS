/////////////////////////////////////////////////////////
//	Author: Drammel									   //
//	Date: 9/18/2009									   //
//	Name: ct_ih_focus								   //
//	Description: As an immediate action, you can reroll//
//  a saving throw you have just made. You must accept //
//  the result of this second roll, even if the new    //
//  result is lower than your initial roll.The real    //
//  work for this ability is done in nw_i0_spells,     //
//  under the function MySavingThrow.                  //
/////////////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void IronHeartFocus()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	if (ValidateCounter(84, oPC))
	{
		int nIHFocus = GetLocalInt(oToB, "IronHeartFocus");

		if (nIHFocus == 1)
		{
			FloatingTextStringOnCreature("<color=cyan>*Iron Hear Focus!*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
			SetLocalInt(oToB, "IronHeartFocus", 0);
			RunSwiftAction(84, "C");
		}
		else DelayCommand(1.0f, IronHeartFocus());
	}
}

void main()
{
	ExpendManeuver(84, "C");
	IronHeartFocus();
}