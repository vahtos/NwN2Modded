//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 10/15/2009							//
//	Name: gui_salamander						//
//	Description: Dispels the ongoing effects of //
//  the maneuver Salamander Charge.             //
//////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");

	if (GetLocalInt(oToB, "Swift") == 0)
	{
		DeleteLocalInt(oPC, "SalamanderActive");
		DeleteLocalInt(oPC, "SalamanderTimer");
		SetLocalInt(oPC, "End_Salamander", 1);
		RunSwiftAction(226, "STR");

		int nNumber = GetLocalInt(oPC, "SalamanderTopNumber");
		int s;

		s = 1;

		while (s <= nNumber)
		{
			DeleteLocalLocation(oPC, "SalamanderLoc" + IntToString(s));
			s++;
		}

		effect eTest;

		eTest = GetFirstEffect(oPC);

		while (GetIsEffectValid(eTest))
		{
			if (GetEffectSpellId(eTest) == 6554)
			{
				RemoveEffect(oPC, eTest);
				break;
			}
			eTest = GetNextEffect(oPC);
		}
	}
}