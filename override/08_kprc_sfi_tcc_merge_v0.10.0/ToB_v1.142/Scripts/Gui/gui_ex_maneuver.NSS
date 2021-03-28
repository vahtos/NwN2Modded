//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 6/16/2009							//
//	Title: gui_ex_maneuver					//
//	Description: Displays the information	//
//	about a maneuver in the examine window.	//
//////////////////////////////////////////////

#include "bot9s_inc_2da"

void main(string sScreen, string sData, string sClass)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");
	string sNumber = IntToString(StringToInt(sData) + 1); // The adjusted number that we're actually after.

	if (GetStringLeft(sScreen, 2) == "MK") // Maneuvers Known
	{
		string sRow;

		if (GetSubString(sScreen, 2, 1) == "0")
		{
			string sBlue = "BlueBoxSTA" + sNumber + GetStringRight(sScreen, 3);
			sRow = IntToString(GetLocalInt(oToB, sBlue));
		}
		else
		{
			string sFind = "Level" + GetSubString(sScreen, 2, 1) + "Row" + sNumber + GetStringRight(sScreen, 3);
			sRow = IntToString(GetLocalInt(oToB, sFind));
		}

		int nTitle = tob_Get2daInt("maneuvers", "StrRef", StringToInt(sRow));
		int nText = tob_Get2daInt("maneuvers", "Description", StringToInt(sRow));

		DisplayGuiScreen(oPC, "SCREEN_TOB_EXAMINE", FALSE, "tob_examine.xml");
		SetGUIObjectText(oPC, "SCREEN_TOB_EXAMINE", "txtSpellName", nTitle, "");
		SetGUIObjectText(oPC, "SCREEN_TOB_EXAMINE", "txtSpellDescription", nText, "");
	}
	else if (GetStringLeft(sScreen, 2) == "MR") // Maneuvers Readied
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

		int nTitle = tob_Get2daInt("maneuvers", "StrRef", StringToInt(sRow));
		int nText = tob_Get2daInt("maneuvers", "Description", StringToInt(sRow));

		DisplayGuiScreen(oPC, "SCREEN_TOB_EXAMINE", FALSE, "tob_examine.xml");
		SetGUIObjectText(oPC, "SCREEN_TOB_EXAMINE", "txtSpellName", nTitle, "");
		SetGUIObjectText(oPC, "SCREEN_TOB_EXAMINE", "txtSpellDescription", nText, "");
	}
	else
	{
		string sBlue = "BlueBox" + sData; //sData should be a standard type string, and a number-class pairing.
		string sRow = IntToString(GetLocalInt(oToB, sBlue));
		int nTitle = tob_Get2daInt("maneuvers", "StrRef", StringToInt(sRow));
		int nText = tob_Get2daInt("maneuvers", "Description", StringToInt(sRow));

		DisplayGuiScreen(oPC, "SCREEN_TOB_EXAMINE", FALSE, "tob_examine.xml");
		SetGUIObjectText(oPC, "SCREEN_TOB_EXAMINE", "txtSpellName", nTitle, "");
		SetGUIObjectText(oPC, "SCREEN_TOB_EXAMINE", "txtSpellDescription", nText, "");
	}
}