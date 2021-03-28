//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 6/1/2009								//
//	Title: gui_select_maneuver					//
//	Description: Adds a maneuver for the PC to	//
//	gain when they level.  Does not actually add//
//	the maneuver, but prepares it for selection.//
//////////////////////////////////////////////////

#include "bot9s_inc_2da"
#include "bot9s_inc_levelup"

void main(string sData)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nManeuver = StringToInt(sData);
	int nKnown = GetLocalInt(oToB, "KnownManeuverTotal");
	int nLevel = GetLocalInt(oToB, "CurrentLevelupLevel");
	int nClass = GetLocalInt(oToB, "LevelupClass");
	int nTotal = GetLocalInt(oToB, "LevelupTotal");
	int nStance = GetLocalInt(oToB, "LevelupStance");
	int nLevelCap = GetLocalInt(oToB, "LevelupCap");
	int nInitLevel = GetInitiatorLevelup(oPC, nClass, nLevelCap);
	int nDiscipline = tob_Get2daInt("maneuvers", "Discipline", nManeuver);
	int nIsStance = tob_Get2daInt("maneuvers", "IsStance", nManeuver);
	int nNumber;
	
	if (GetLocalInt(oToB, "CurrentLevelupLevel") == 0)
	{
		nNumber = nStance;
	}
	else nNumber = nTotal;

	if (nNumber > 0)
	{
		ClearListBox(oPC, "SCREEN_LEVELUP_MANEUVERS", "AVAILABLE_MANEUVER_LIST");
		ClearListBox(oPC, "SCREEN_LEVELUP_MANEUVERS", "ADDED_MANEUVER_LIST");
		SetLocalString(oToB, "AddedManeuver" + sData, sData);
		PredictDisciplineStatus(nDiscipline, TRUE);
		DisplayAddedManeuvers(oPC, oToB);
		DisplayManeuversByClass(oPC, oToB, 1, 50, nLevel, nClass, nInitLevel);
	}
}