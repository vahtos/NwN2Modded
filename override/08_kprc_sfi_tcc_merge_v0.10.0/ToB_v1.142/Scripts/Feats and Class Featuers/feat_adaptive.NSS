///////////////////////////////////////////////////////////
//	Author: Drammel										 //
//	Date: 5/22/2009										 //
//	Name: feat_adaptive									 //
//	Description: Allows the PC to open the martial adept //
//	menu and change maneuvers during combat as a full 	 //
//	round action.										 //
///////////////////////////////////////////////////////////

#include "bot9s_cr_recovery"
#include "bot9s_include"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	SetLocalInt(oToB, "AdaptiveStyle", 1);
	SetLocalInt(oToB, "DisableQuickstrike", 1);

	string sClass = GetLocalString(oToB, "AS_Class");
	string sScreen;

	if (sClass != "___")
	{
		sScreen = "SCREEN_QUICK_STRIKE" + sClass;
	}
	else sScreen = "SCREEN_QUICK_STRIKE";

	string sKnown = GetLocalString(oToB, "AS_Known");
	string sReadied = GetLocalString(oToB, "AS_Readied");
	string sScreenKnown = GetLocalString(oToB, "AS_ScreenKnown");
	string sScreenReadied = GetLocalString(oToB, "AS_ScreenReadied");

	if (sClass == "_CR")
	{
		ClearRecoveryFlags();
	}

	// Close Quickstrike
	SetLocalInt(oToB, "IsQStrikeActive" + sClass, 0);
	CloseGUIScreen(oPC, sScreen);

	if (GetLocalInt(oToB, "Is9SMenuActive" + sClass) == 1)
	{
		SetLocalInt(oToB, "Is9SMenuActive" + sClass, 0);	
		CloseGUIScreen(oPC, sScreenKnown);
		CloseGUIScreen(oPC, sScreenReadied);
	}

	// Open the martial Adept menus.
	SetLocalInt(oToB, "Is9SMenuActive" + sClass, 1);
	DisplayGuiScreen(oPC, sScreenKnown, FALSE, sKnown);
	DisplayGuiScreen(oPC, sScreenReadied, FALSE, sReadied);
	WrapperPlayCustomAnimation(oPC, "mspirit", 0);
}