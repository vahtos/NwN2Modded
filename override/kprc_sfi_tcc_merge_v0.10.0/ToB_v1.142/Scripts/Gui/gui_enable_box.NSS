//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 1/31/2009							//
//	Title: gui_enable_box					//
//	Description: Removes disabled status to	//
//	specific listboxes to prevent duplicate	//
//	instances of maneuvers in the Maneuvers	//
//	Readied Screen.							//
//////////////////////////////////////////////

void main(string sClass, string sBox)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");
	string sIdent = GetLocalString(oToB, "Readied" + sBox + sClass);
	int nOffset; //Finds the number of digits

/*	if (GetSubString(sIdent, 2, 1) == "_")
	{
		nOffset = 0;
	}
	else nOffset = 1;*/

	string sLevel = GetStringLeft(sIdent, 1);
	string sRow = GetStringRight(sIdent, 1);
//	string sClass = GetSubString(sIdent, 2 + nOffset, 3);
	string sScreen;
	
	if (sClass == "___")
	{
		sScreen = "SCREEN_MANEUVERS_KNOWN";
	}
	else sScreen = "SCREEN_MANEUVERS_KNOWN" + sClass;

	SetGUIObjectDisabled(oPC, sScreen, "LEVEL" + sLevel + "_LISTBOX_ITEM" + sRow, FALSE);
	DeleteLocalInt(oToB, "Known" + sClass + sLevel + "Row" + sRow + "Disabled");
}