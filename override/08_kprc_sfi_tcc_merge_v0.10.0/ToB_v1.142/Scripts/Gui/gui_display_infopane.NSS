//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 6/1/2009									//
//	Title: gui_display_infopane						//
//	Description: Displays a maneuver's description	//
//	on the infopane sidebar.						//
//////////////////////////////////////////////////////

#include "bot9s_inc_2da"

void main(string sData)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	string sTexture = tob_Get2daString("maneuvers", "ICON", StringToInt(sData));
	int nTitle = tob_Get2daInt("maneuvers", "StrRef", StringToInt(sData));
	int nText = tob_Get2daInt("maneuvers", "Description", StringToInt(sData));

	SetGUITexture(oPC, "SCREEN_LEVELUP_MANEUVERS", "INFOPANE_IMAGE", sTexture + ".tga");
	SetGUIObjectText(oPC, "SCREEN_LEVELUP_MANEUVERS", "INFOPANE_TITLE", nTitle, "");
	SetGUIObjectText(oPC, "SCREEN_LEVELUP_MANEUVERS", "INFOPANE_TEXT", nText, "");
}