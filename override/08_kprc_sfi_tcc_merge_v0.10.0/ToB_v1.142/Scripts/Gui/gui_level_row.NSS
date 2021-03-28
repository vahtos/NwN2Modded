//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 4/10/2009							//
//	Title: gui_level_row					//
//	Description: Adds Maneuvers to the		//
//	Maneuvers Readied Screen based on the 	//
//	level and row of the calling listbox.	//
//////////////////////////////////////////////

#include "bot9s_inc_index"

void main(string sRow, string sData)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	int nLevel = StringToInt(GetStringLeft(sData, 1));
	string sClass = GetStringRight(sData, 3);
	int nRed = GetRedNumber(sClass);

	if (nRed == 0)
	{
		return;
	}

	AddLevelRow(oPC, nLevel, (StringToInt(sRow) + 1), nRed, sClass);
}