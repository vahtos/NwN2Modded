//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 7/30/2009								//
//	Name: gui_shadowbt							//
//	Description: Toggles if the player wishes to//
//	use the high or low roll for Shadow Blade	//
//	Technique.									//
//////////////////////////////////////////////////

void main()
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nSBT = GetLocalInt(oToB, "SBTRollPref");

	if (nSBT == 0)
	{
		SetLocalInt(oToB, "SBTRollPref", 1);
		FloatingTextStringOnCreature("<color=cyan>Shadow Blade Technique Mode: High Roll</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
	}
	else
	{
		SetLocalInt(oToB, "SBTRollPref", 0);
		FloatingTextStringOnCreature("<color=cyan>Shadow Blade Technique Mode: Low Roll</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
	}
}