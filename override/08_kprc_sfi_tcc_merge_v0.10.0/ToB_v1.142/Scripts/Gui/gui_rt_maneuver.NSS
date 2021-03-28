//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 6/4/2009								//
//	Title: gui_rt_maneuver						//
//	Description: Allows the player to retrain an//
//	old maneuver.								//
//////////////////////////////////////////////////

#include "bot9s_inc_levelup"

void main(string sData)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nManeuver = StringToInt(sData);
	int nLevel = GetLocalInt(oToB, "CurrentLevelupLevel");
	int nClass = GetLocalInt(oToB, "LevelupClass");
	int nLearn = GetLocalInt(oToB, "LevelupLearn");
	int nTotal = GetLocalInt(oToB, "LevelupTotal");
	int nLevelCap = GetLocalInt(oToB, "LevelupCap");
	int nInitLevel = GetInitiatorLevelup(oPC, nClass, nLevelCap);
	int nDiscipline = tob_Get2daInt("maneuvers", "Discipline", nManeuver);

	ClearListBox(oPC, "SCREEN_LEVELUP_MANEUVERS", "RETRAIN_MANEUVER_LIST");
	ClearListBox(oPC, "SCREEN_LEVELUP_MANEUVERS", "AVAILABLE_MANEUVER_LIST");

	if (nManeuver == 0)
	{
		return;
	}

	SetLocalInt(oToB, "RetrainManeuver", nManeuver); // Never more than one of these.
	SetLocalInt(oToB, "LevelupRetrain", 0);
	SetLocalInt(oToB, "LevelupLearn", nLearn + 1); // Top number we can learn this level.
	SetLocalInt(oToB, "LevelupTotal", nTotal + 1); // Current number of maneuvers left to learn.

	int nNew = GetLocalInt(oToB, "LevelupTotal");

	SetGUIObjectText(oPC, "SCREEN_LEVELUP_MANEUVERS", "POINT_POOL_TEXT", -1, IntToString(nNew));
	SetGUIObjectText(oPC, "SCREEN_LEVELUP_MANEUVERS", "RETRAIN_POOL_TEXT", -1, "0");

	SetGUIObjectDisabled(oPC, "SCREEN_LEVELUP_MANEUVERS", "CHOICE_NEXT", TRUE);
	GenerateKnownManeuvers(oPC, oToB);
	PredictDisciplineStatus(nDiscipline, FALSE);
	DisplayManeuversByClass(oPC, oToB, 1, 50, nLevel, nClass, nInitLevel);
}