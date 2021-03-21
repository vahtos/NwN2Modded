/////////////////////////////////////////////////////////
//	Author: Drammel									   //
//	Date: 5/15/2009									   //
//	Name: clf_zsurge								   //
//	Description: Allows the player to reroll a single  //
//	failed saving throw once per day while this ability//
//	is active.  This script toggles the reroll on and  //
//	off.  The real work for this ability is done in    //
//	tob_i0_spells, under the function MySavingThrow.   //
/////////////////////////////////////////////////////////

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nUse = GetLocalInt(oToB, "ZealousSurgeUse");

	if (nUse == 1)
	{
		int nMode = GetLocalInt(oToB, "ZealousSurge");

		if (nMode == 0)
		{
			SetLocalInt(oToB, "ZealousSurge", 1);
			FloatingTextStringOnCreature("<color=cyan>*Zealous Surge Mode Enabled*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
		}
		else
		{
			SetLocalInt(oToB, "ZealousSurge", 0);
			FloatingTextStringOnCreature("<color=cyan>*Zealous Surge Mode Disabled*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
		}
	}
	else SendMessageToPC(oPC, "<color=red>You have already used Zealous Surge today.</color>");
}