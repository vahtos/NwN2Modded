//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 6/9/2009									//
//	Title: gui_open_rt								//
//	Description: Closes the maneuver selection		//
//	screen, opens the feat retraining screen and	//
//	runs the setup files for it.					//
//////////////////////////////////////////////////////

#include "bot9s_inc_retrain"
#include "bot9s_inc_constants"
#include "bot9s_inc_levelup"

void CheckForPhaseOne(object oPC, object oToB)
{
	if (GetLocalInt(oToB, "FeatRetrainPhase") == 1)
	{
		SetLocalInt(oToB, "RetrainLoopCheck", 1);
		ClearListBox(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "RETRAIN_FEATS_LIST");
		ClearListBox(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "ADDED_RETRAIN_LIST");
		ClearListBox(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "AVAILABLE_RETRAIN_LIST");
		SetGUITexture(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "INFOPANE_IMAGE", "b_empty.tga");
		SetGUIObjectText(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "INFOPANE_TITLE", -1, "");
		SetGUIObjectText(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "INFOPANE_TEXT", -1, "");

		int nRetrain;

		if (GetHitDice(oPC) == 1)
		{
			nRetrain += 1;

			if ((GetRacialType(oPC) == RACIAL_TYPE_HUMAN) || (GetSubRace(oPC) == RACIAL_SUBTYPE_STRONGHEART_HALF))
			{
				nRetrain += 1;
			}
		}
		else nRetrain = 1;

		int nAvailable = GetLocalInt(oToB, "AvialableToRetrain");
		SetGUIObjectDisabled(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "CHOICE_FINISH", FALSE);
		SetGUIObjectText(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "POINT_POOL_TEXT", -1, IntToString(nAvailable));
		SetGUIObjectText(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "RETRAIN_POOL_TEXT", -1, IntToString(nRetrain));
		SetLocalInt(oToB, "FeatRetrainAmount", nRetrain);
		DelayCommand(0.1f, GetAllAvailableFeats(oPC, oToB, 1, 25));
		AddAllKnownFeats(oPC, oToB, 1, 50);
	}
	else DelayCommand(0.1f, CheckForPhaseOne(oPC, oToB)); // Do it until the menu can offically be opened.
}
		
void main()
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nSSWF = GetLocalInt(oToB, "SSWeaponFocus");

	SetPause(FALSE);

	CloseGUIScreen(oPC, "SCREEN_LEVELUP_MANEUVERS");

	if ((GetLevelByClass(CLASS_TYPE_SWORDSAGE, oPC) == 1) && (nSSWF == 0)) //Swordsage's Insightful Strike: Weapon Focus selection.
	{
		DisplayGuiScreen(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", TRUE, "retrain_feats.xml");
		SetGUIObjectDisabled(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "CHOICE_FINISH", TRUE);
		SetGUIObjectText(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "INFOPANE_TITLE", -1, "");
		SetGUIObjectText(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "INFOPANE_TEXT", -1, "");
		SetGUIObjectDisabled(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "CHOICE_NEXT", TRUE);
		SetGUIObjectText(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "INFOPANE_TEXT", 280688, "");
		SetGUIObjectText(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "POINT_POOL_TEXT", -1, "1");
		SetLocalInt(oToB, "SSWeaponFocus", 0); //Does the job of the cancel button without removing the data for future use.
		SetLocalInt(oToB, "SSInsightSwitch", 1);
		DisplaySSInsightfulStrike(oPC, oToB);
	}
	else if (GetHitDice(oPC) == 1) // First level only until I can get some better checks for feat retraining.
	{
		DisplayGuiScreen(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", TRUE, "retrain_feats.xml");
		SetGUIObjectDisabled(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "CHOICE_FINISH", TRUE);
		SetGUIObjectText(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "INFOPANE_TITLE", -1, "");
		SetGUIObjectText(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "INFOPANE_TEXT", -1, "");
		SetLocalInt(oToB, "FeatRetrainPhase", 1);
		SetGUIObjectDisabled(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "CHOICE_NEXT", TRUE);
	}
	else
	{
		ExecuteScript("gui_finalize_lvlup", oPC);
		return;
	}

	CheckForPhaseOne(oPC, oToB);
}