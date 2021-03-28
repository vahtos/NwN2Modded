///////////////////////////////////////////////////////////
//	Author: Drammel										 //
//	Date: 5/13/2009										 //
//	Name: clf_furious_ctrsA								 //
//	Description: Controls wether or not the PC accepts	 //
//	healing	to their Delayed damage pool.				 //
///////////////////////////////////////////////////////////

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nFurious = GetLocalInt(oToB, "FuriousCounterstrike");

	if (nFurious == 0)
	{
		SetLocalInt(oToB, "FuriousCounterstrike", 1);
		FloatingTextStringOnCreature("<color=cyan>*Delayed Damage Pool Healing Disabled.*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, FOG_COLOR_BLUE_DARK);
	}
	else
	{
		SetLocalInt(oToB, "FuriousCounterstrike", 0);
		FloatingTextStringOnCreature("<color=cyan>*Delayed Damage Pool Healing Enabled.*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, FOG_COLOR_BLUE_DARK);
	}
}