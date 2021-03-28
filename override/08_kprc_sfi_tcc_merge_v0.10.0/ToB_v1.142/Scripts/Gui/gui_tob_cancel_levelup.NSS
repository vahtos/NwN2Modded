//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 6/1/2009								//
//	Title: gui_tob_cancel_levelup				//
//	Description: Cancels the levelup screens for//
//	the martial adept screens.					//
//////////////////////////////////////////////////

#include "bot9s_inc_levelup"

void Phase1(object oToB)
{
	DeleteLocalInt(oToB, "HaltRetrainFeats");
	DeleteLocalInt(oToB, "RetrainLoopCheck");
	DeleteLocalInt(oToB, "CurrentLevelupLevel");
	DeleteLocalInt(oToB, "LevelupClass");
	DeleteLocalInt(oToB, "LevelupStance");
	DeleteLocalInt(oToB, "LevelupStanceLearn");
	DeleteLocalInt(oToB, "LevelupRetrain");
	DeleteLocalInt(oToB, "LevelupLearn");
	DeleteLocalInt(oToB, "LevelupTotal");
	DeleteLocalInt(oToB, "RetrainManeuver");
	DeleteLocalInt(oToB, "FeatRetrainPhase");
	DeleteLocalInt(oToB, "FeatRetrainAmount");
	DeleteLocalInt(oToB, "AvialableToRetrain");
	DeleteLocalInt(oToB, "FeatRetrain1");
	DeleteLocalInt(oToB, "FeatRetrain2");
	DeleteLocalInt(oToB, "PendingFeat1");
	DeleteLocalInt(oToB, "PendingFeat2");
	DeleteLocalInt(oToB, "SSInsightSwitch");
	DeleteLocalInt(oToB, "MStudy1Pending");
	DeleteLocalInt(oToB, "MStudy2Pending");
	DeleteLocalInt(oToB, "MStudy3Pending");
	DeleteLocalInt(oToB, "MStance1Pending");
	DeleteLocalInt(oToB, "MStance2Pending");
	DeleteLocalInt(oToB, "MStance3Pending");
}

void Phase2(object oToB)
{
	if (GetLocalInt(oToB, "ManeuversCreated") == 1)
	{
		int nMax = GetNum2DARows("maneuvers");
		int i;
	
		i = 1;
	
		while (i < nMax)
		{
			DeleteLocalString(oToB, "AddedManeuver" + IntToString(i));
			i++;
		}

		DeleteLocalInt(oToB, "ManeuversCreated");
		DetermineDisciplineStatus();
	}
	else DelayCommand(0.1f, Phase2(oToB));
}

void main()
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");

	SetPause(FALSE);

	AssignCommand(oPC, Phase1(oToB));
	AssignCommand(oPC, Phase2(oToB));
	
	SetGUITexture(oPC, "SCREEN_LEVELUP_MANEUVERS", "INFOPANE_IMAGE", "b_empty.tga");
	SetGUIObjectText(oPC, "SCREEN_LEVELUP_MANEUVERS", "INFOPANE_TITLE", -1, "");
	SetGUIObjectText(oPC, "SCREEN_LEVELUP_MANEUVERS", "INFOPANE_TEXT", -1, "");
	SetGUIObjectText(oPC, "SCREEN_LEVELUP_MANEUVERS", "RETRAIN_POOL_TEXT", -1, "0");
	SetGUITexture(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "INFOPANE_IMAGE", "b_empty.tga");
	SetGUIObjectText(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "INFOPANE_TITLE", -1, "");
	SetGUIObjectText(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "INFOPANE_TEXT", -1, "");
	SetGUIObjectText(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "RETRAIN_POOL_TEXT", -1, "0");
	SetGUIObjectDisabled(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "CHOICE_NEXT", FALSE);
	SetGUIObjectDisabled(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "CHOICE_FINISH", FALSE);
	ClearListBox(oPC, "SCREEN_LEVELUP_MANEUVERS", "ADDED_MANEUVER_LIST");
	ClearListBox(oPC, "SCREEN_LEVELUP_MANEUVERS", "AVAILABLE_MANEUVER_LIST");
	ClearListBox(oPC, "SCREEN_LEVELUP_MANEUVERS", "RETRAIN_MANEUVER_LIST");
	ClearListBox(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "RETRAIN_FEATS_LIST");
	ClearListBox(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "ADDED_RETRAIN_LIST");
	ClearListBox(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "AVAILABLE_RETRAIN_LIST");
	CloseGUIScreen(oPC, "SCREEN_LEVELUP_MANEUVERS");
	CloseGUIScreen(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS");
}