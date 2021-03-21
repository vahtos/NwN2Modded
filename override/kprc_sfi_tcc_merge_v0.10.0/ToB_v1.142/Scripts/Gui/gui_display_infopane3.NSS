//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 2/3/2009									//
//	Title: gui_display_infopane3					//
//	Description: Displays a maneuver's description	//
//	on the infopane sidebar for the Primer.			//
//////////////////////////////////////////////////////

#include "bot9s_inc_2da"

void main(string sData)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	string sTexture = tob_Get2daString("maneuvers", "ICON", StringToInt(sData));
	int nTitle = tob_Get2daInt("maneuvers", "StrRef", StringToInt(sData));
	int nText = tob_Get2daInt("maneuvers", "Description", StringToInt(sData));

	SetGUITexture(oPC, "SCREEN_TOB_PRIMER", "INFOPANE_IMAGE", sTexture + ".tga");
	SetGUIObjectText(oPC, "SCREEN_TOB_PRIMER", "INFOPANE_TITLE", nTitle, "");
	SetGUIObjectText(oPC, "SCREEN_TOB_PRIMER", "INFOPANE_TEXT", nText, "");
}