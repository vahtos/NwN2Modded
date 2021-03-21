//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 2/3/2010							//
//	Name: gui_open_primer					//
//	Description: Opens the Primer from the  //
//  Maneuvers Known Screen.					//
//////////////////////////////////////////////

void main()
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");

	if (GetIsObjectValid(oToB) && (GetLocalInt(oToB, "Encounter") == 0))
	{
		DisplayGuiScreen(oPC, "SCREEN_TOB_PRIMER", TRUE, "tob_primer.xml");
	}
}