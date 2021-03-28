//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 6/16/2009								//
//	Title: gui_tob_tooltip						//
//	Description: Sets the correct data at		//
//	index local:9 for the tooltip xml function. //
//////////////////////////////////////////////////

#include "bot9s_inc_2da"

void main(string sDest, string sData, string sClass)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");

	//The xml tooltip function is a little lazy and will not update correctly without this.
	CloseGUIScreen(oPC, "SCREEN_TOOLTIP_2");

	if (sDest == "MR") // Maneuvers Readied
	{
		int nOffset; // Determines how many places the nRed substring offsets the other substrings.

		string sInfo = GetLocalString(oToB, "Readied" + sData + sClass);

		if (GetSubString(sInfo, 2, 1) == "_")
		{
			nOffset = 0;
		}
		else nOffset = 1;

		int nDigits; // Number of Digits in the 2da index substring.

		if (GetSubString(sInfo, 6 + nOffset, 1) == "_")
		{
			nDigits = 1;
		}
		else if (GetSubString(sInfo, 7 + nOffset, 1) == "_")
		{
			nDigits = 2;
		}
		else nDigits = 3;

		string sRow = GetSubString(sInfo, 5 + nOffset, nDigits);
	//	string sClass = GetSubString(sData, 2 + nOffset, 3);
		string sScreen;

		if (sClass == "___")
		{
			sScreen = "SCREEN_MANEUVERS_READIED";
		}
		else sScreen = "SCREEN_MANEUVERS_READIED" + sClass;

		string sTitle = GetStringByStrRef(tob_Get2daInt("maneuvers", "StrRef", StringToInt(sRow)));

		SetLocalGUIVariable(oPC, sScreen, 9, sTitle);
	}
	else
	{
		string sBlue = "BlueBox" + sData; //sData should be a standard type string, and a number-class pairing.
		string sRow = IntToString(GetLocalInt(oToB, sBlue));
		string sClass = GetStringRight(sData, 3);
		string sScreen;

		if (sClass == "___")
		{
			sScreen = "SCREEN_QUICK_STRIKE";
		}
		else sScreen = "SCREEN_QUICK_STRIKE" + sClass;

		string sTitle = GetStringByStrRef(tob_Get2daInt("maneuvers", "StrRef", StringToInt(sRow)));

		SetLocalGUIVariable(oPC, sScreen, 9, sTitle);
	}
}