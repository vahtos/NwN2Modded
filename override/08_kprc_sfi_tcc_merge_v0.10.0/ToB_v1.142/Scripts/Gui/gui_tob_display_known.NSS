//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 6/1/2009								//
//	Title: gui_display_known					//
//	Description: Displays maneuvers availible	//
//	for the PC to learn.						//
//////////////////////////////////////////////////

#include "bot9s_inc_levelup"

void main(string sLevel)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nLevel = StringToInt(sLevel);
	int nClass = GetLocalInt(oToB, "LevelupClass");
	int nLevelCap = GetLocalInt(oToB, "LevelupCap");
	int nInitLevel = GetInitiatorLevelup(oPC, nClass, nLevelCap);

	ClearListBox(oPC, "SCREEN_LEVELUP_MANEUVERS", "AVAILABLE_MANEUVER_LIST");
	DisplayManeuversByClass(oPC, oToB, 1, 50, nLevel, nClass, nInitLevel);
	SetLocalInt(oToB, "CurrentLevelupLevel", nLevel);

	if (GetLocalInt(oToB, "CurrentLevelupLevel") == 0)
	{
		int nStance = GetLocalInt(oToB, "LevelupStance");
		SetGUIObjectText(oPC, "SCREEN_LEVELUP_MANEUVERS", "POINT_POOL_TEXT", -1, IntToString(nStance));
	}
	else
	{
		int nTotal = GetLocalInt(oToB, "LevelupTotal");
		SetGUIObjectText(oPC, "SCREEN_LEVELUP_MANEUVERS", "POINT_POOL_TEXT", -1, IntToString(nTotal));
	}
}