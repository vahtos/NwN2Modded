//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 7/14/2009								//
//	Name: gui_tob_switch						//
//	Description: Turns the martial adept menus  //
//  on and off when the player switches between //
//  characters.									//
//////////////////////////////////////////////////

#include "bot9s_inc_constants"

void CloseScreens(object oPC, int bPC)
{
	object oMartialAdept = GetControlledCharacter(oPC);
	object oParty, oToB;
	int nCrusader, nSaint, nSwordsage, nWarblade;

	oParty = GetFirstFactionMember(oPC, FALSE);

	while (GetIsObjectValid(oParty))
	{
		oToB = GetItemPossessedBy(oParty, "tob");
		nCrusader = GetLevelByClass(CLASS_TYPE_CRUSADER, oPC);
		nSaint = GetLevelByClass(CLASS_TYPE_SAINT, oPC);
		nSwordsage = GetLevelByClass(CLASS_TYPE_SWORDSAGE, oPC);
		nWarblade = GetLevelByClass(CLASS_TYPE_WARBLADE, oPC);


		CloseGUIScreen(oParty, "SCREEN_MARTIAL_MENU_CR");
		CloseGUIScreen(oParty, "SCREEN_QUICK_STRIKE_CR");
		SetLocalInt(oToB, "IsQStrikeActive_CR", 0);

		CloseGUIScreen(oParty, "SCREEN_MARTIAL_MENU_SA");
		CloseGUIScreen(oParty, "SCREEN_QUICK_STRIKE_SA");
		SetLocalInt(oToB, "IsQStrikeActive_SA", 0);

		CloseGUIScreen(oParty, "SCREEN_MARTIAL_MENU_SS");
		CloseGUIScreen(oParty, "SCREEN_QUICK_STRIKE_SS");
		SetLocalInt(oToB, "IsQStrikeActive_SS", 0);

		CloseGUIScreen(oParty, "SCREEN_MARTIAL_MENU_WB");
		CloseGUIScreen(oParty, "SCREEN_QUICK_STRIKE_WB");
		SetLocalInt(oToB, "IsQStrikeActive_WB", 0);

		CloseGUIScreen(oParty, "SCREEN_MARTIAL_MENU");
		CloseGUIScreen(oParty, "SCREEN_QUICK_STRIKE");
		SetLocalInt(oToB, "IsQStrikeActive___", 0);

	
		CloseGUIScreen(oParty, "SCREEN_SWIFT_ACTION");

		oParty = GetNextFactionMember(oPC);
	}
}

void OpenScreens(object oPC)
{
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nCrusader = GetLevelByClass(CLASS_TYPE_CRUSADER, oPC);
	int nSaint = GetLevelByClass(CLASS_TYPE_SAINT, oPC);
	int nSwordsage = GetLevelByClass(CLASS_TYPE_SWORDSAGE, oPC);
	int nWarblade = GetLevelByClass(CLASS_TYPE_WARBLADE, oPC);

	if ((nCrusader > 0) && (GetLocalInt(oToB, "Unfettered") == 0))
	{
		DisplayGuiScreen(oPC, "SCREEN_MARTIAL_MENU_CR", FALSE, "martial_menu_cr.xml");
	}

	if ((nSaint > 0) && (GetLocalInt(oToB, "SublimeWay") == 0))
	{
		DisplayGuiScreen(oPC, "SCREEN_MARTIAL_MENU_SA", FALSE, "martial_menu_sa.xml");
	}

	if ((nSwordsage > 0) && (GetLocalInt(oToB, "DesertWind") == 0))
	{
		DisplayGuiScreen(oPC, "SCREEN_MARTIAL_MENU_SS", FALSE, "martial_menu_ss.xml");
	}

	if ((nWarblade > 0) && (GetLocalInt(oToB, "SupernalClarity") == 0))
	{
		DisplayGuiScreen(oPC, "SCREEN_MARTIAL_MENU_WB", FALSE, "martial_menu_wb.xml");
	}

	if ((GetHasFeat(FEAT_MARTIAL_STUDY, oPC)) && (GetLocalInt(oToB, "UmbralAwn") == 0))
	{
		DisplayGuiScreen(oPC, "SCREEN_MARTIAL_MENU", FALSE, "martial_menu.xml");
	}

	if (GetHasFeat(FEAT_MARTIAL_ADEPT, oPC))
	{
		DisplayGuiScreen(oPC, "SCREEN_SWIFT_ACTION", FALSE, "swift_action.xml");
	}
}

void SwitchCharacters()
{
	object oPC = OBJECT_SELF;  //Despite who the player controls OBJECT_SELF is the person that opened the GUI.
	object oMartialAdept = GetControlledCharacter(oPC);

	CloseScreens(oPC, FALSE);
	DelayCommand(0.05f, OpenScreens(oMartialAdept));
}

void main()
{
	DelayCommand(0.05f, SwitchCharacters());
}