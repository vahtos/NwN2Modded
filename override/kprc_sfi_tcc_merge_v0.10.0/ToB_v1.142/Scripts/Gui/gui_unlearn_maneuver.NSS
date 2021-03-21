//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 6/2/2009								//
//	Title: gui_unlearn_maneuver					//
//	Description: Removes a maneuver from the	//
//	list of maneuvers the PC chooses to learn at//
//	levelup.									//
//////////////////////////////////////////////////

#include "bot9s_inc_2da"
#include "bot9s_inc_levelup"

void main(string sData)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nManeuver = StringToInt(sData);
	int nLevel = GetLocalInt(oToB, "CurrentLevelupLevel");
	int nClass = GetLocalInt(oToB, "LevelupClass");
	int nLevelCap = GetLocalInt(oToB, "LevelupCap");
	int nInitLevel = GetInitiatorLevelup(oPC, nClass, nLevelCap);
	int nDiscipline = tob_Get2daInt("maneuvers", "Discipline", nManeuver);

	ClearListBox(oPC, "SCREEN_LEVELUP_MANEUVERS", "AVAILABLE_MANEUVER_LIST");
	ClearListBox(oPC, "SCREEN_LEVELUP_MANEUVERS", "ADDED_MANEUVER_LIST");
	DeleteLocalString(oToB, "AddedManeuver" + sData);
	PredictDisciplineStatus(nDiscipline, FALSE);
	DisplayAddedManeuvers(oPC, oToB);
	DisplayManeuversByClass(oPC, oToB, 1, 50, nLevel, nClass, nInitLevel);
}