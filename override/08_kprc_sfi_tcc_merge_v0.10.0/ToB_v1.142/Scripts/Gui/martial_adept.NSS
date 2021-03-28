///////////////////////////////////////////////////////
//	Author: Drammel                                  //
//	Date: 2/28/2010                                  //
//	Name: martial_adept formerly launch_martial_menu //
//	Description: Governs the martial adept menus and //
//  events that happen OnRest and OnLevelup.         //
///////////////////////////////////////////////////////

#include "bot9s_inc_constants"

void main()
{
	object oPC = OBJECT_SELF;
	object oMartialAdept = GetControlledCharacter(oPC); //Checking to prevent our companions' screens from popping on resting.
	object oToB = GetItemPossessedBy(oPC, "tob");

	int nCrusader = GetLevelByClass(CLASS_TYPE_CRUSADER, oPC);
	int nSaint = GetLevelByClass(CLASS_TYPE_SAINT, oPC);
	int nSwordsage = GetLevelByClass(CLASS_TYPE_SWORDSAGE, oPC);
	int nWarblade = GetLevelByClass(CLASS_TYPE_WARBLADE, oPC);
	int nRest = GetLastRestEventType();
	
	if ((oPC == oMartialAdept) && (nCrusader > 0) && (GetLocalInt(oToB, "Unfettered") == 0))
	{
		DisplayGuiScreen(oPC, "SCREEN_MARTIAL_MENU_CR", FALSE, "martial_menu_cr.xml");
	}
	
	if ((nCrusader > 2) && (nRest == REST_EVENTTYPE_REST_FINISHED))
	{
		SetLocalInt(oToB, "ZealousSurgeUse", 1);
	}

	if ((oPC == oMartialAdept) && (nSaint > 0) && (GetLocalInt(oToB, "SublimeWay") == 0))
	{
		DisplayGuiScreen(oPC, "SCREEN_MARTIAL_MENU_SA", FALSE, "martial_menu_sa.xml");
	}

	if ((oPC == oMartialAdept) && (nSwordsage > 0) && (GetLocalInt(oToB, "DesertWind") == 0))
	{
		DisplayGuiScreen(oPC, "SCREEN_MARTIAL_MENU_SS", FALSE, "martial_menu_ss.xml");
	}

	if ((nSwordsage > 19) && (nRest == REST_EVENTTYPE_REST_FINISHED))
	{
		SetLocalInt(oToB, "DualBoost", 3);
	}

	if ((oPC == oMartialAdept) && (nWarblade > 0) && (GetLocalInt(oToB, "SupernalClarity") == 0))
	{
		DisplayGuiScreen(oPC, "SCREEN_MARTIAL_MENU_WB", FALSE, "martial_menu_wb.xml");
	}

	if ((oPC == oMartialAdept) && (GetHasFeat(FEAT_MARTIAL_STUDY, oPC)) && (GetLocalInt(oToB, "UmbralAwn") == 0))
	{
		DisplayGuiScreen(oPC, "SCREEN_MARTIAL_MENU", FALSE, "martial_menu.xml");
	}

	if (oPC == oMartialAdept)
	{
		DisplayGuiScreen(oPC, "SCREEN_SWIFT_ACTION", FALSE, "swift_action.xml");
	}

	if (nRest == REST_EVENTTYPE_REST_FINISHED)
	{
		SetLocalInt(oToB, "Encounter", 0);

		if (GetHasFeat(FEAT_SUDDEN_RECOVERY, oPC))
		{
			SetLocalInt(oToB, "SuddenRecovery", 0);
		}
	}

	if ((GetHasFeat(FEAT_DW_ADEPT, oPC)) && (GetIsObjectValid(oToB)) && (GetLocalInt(oToB, "Encounter") == 0))
	{
		string sPhoenix = GetFirstName(oPC) + "sa_phoenix";
		object oPhoenix = GetObjectByTag(sPhoenix);

		if (GetIsObjectValid(oPhoenix))
		{
			SetLocalInt(oToB, "RisingPhoenix", 0);
		}
	}
/*  Moved to i_tob_aq
	if (GetLocalInt(oPC, "bot9s_PreloadPending") == 0)
	{
		DoPreLoad();
	}

	DelayCommand(6.0f, CheckBattleStatusLoop());// Needs to be delayed because when the feat fires after resting the engine doesn't detect effects immeadiately.
	//	RunPCPositionPerRound(); //Depriciated
	//	RunPCPositionPerSecond();
	//	RunIsEncounterActive();
	//	RunScreenStatus(); Depriciated like crazy.  The newer, better version of this function is now gui_wendersnaven.*/

	//Used for debugging purposes.
	//DisplayGuiScreen(oPC, "SCREEN_WENDERSNAVEN", FALSE, "wendersnaven.xml");
}