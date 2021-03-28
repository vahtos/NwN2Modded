//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 4/10/2009								//
//	Title: gui_black_box						//
//	Description: Records the number and	class of//
//	a button activated in one of the Quickstrike//
//	menus.										//
//////////////////////////////////////////////////

void main(string sData)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");

	SetLocalString(oToB, "BlackBox", sData);
}