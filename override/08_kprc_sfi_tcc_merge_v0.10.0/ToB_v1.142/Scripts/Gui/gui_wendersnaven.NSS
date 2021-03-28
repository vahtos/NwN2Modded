//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 12/18/2009							//
//	Name: gui_wendersnaven						//
//	Description: Whenever the Martial Adpet 	//
//  menus are opened this script is run to check//
//  for conditions in which they should be      //
//  closed again.  Primarily this will be when  //
//  combat has been initiated or when switching //
//  between characters.                         //
//////////////////////////////////////////////////

#include "bot9s_inc_misc"

void RunForcedClosed(object oMartialAdept)
{
	object oPC = OBJECT_SELF;
	object oCheck = GetControlledCharacter(oPC);

	if (oCheck == oMartialAdept)
	{
		object oToB = GetItemPossessedBy(oPC, "tob");
		int nAdaptive = GetLocalInt(oToB, "AdaptiveStyle");

		SetLocalInt(oToB, "Is9SMenuActive_CR", 1);
		SetLocalInt(oToB, "RedCrusader", 1);
		SetLocalInt(oToB, "CR_ForcedClose", 0);
		DisplayGuiScreen(oCheck, "SCREEN_MANEUVERS_READIED_CR", FALSE, "maneuvers_readied_cr.xml");
		DisplayGuiScreen(oCheck, "SCREEN_MANEUVERS_KNOWN_CR", FALSE, "maneuvers_known_cr.xml");

		if (nAdaptive == 1)
		{
			SetLocalInt(oToB, "AS_HaltCrCycle", 1); // Red Light on the Crusader's recovery method.
			SetLocalInt(oToB, "RedCrusader", 1);
			SetLocalInt(oToB, "EncounterR1", 0);
		}
	}
	else DelayCommand(0.1f, RunForcedClosed(oMartialAdept));
}

void RunScreenCheck(object oMartialAdept, string sClass)
{
	object oPC = OBJECT_SELF;
	object oCheck = GetControlledCharacter(oPC);
	object oToB = GetItemPossessedBy(oMartialAdept, "tob");
	int nAdaptive = GetLocalInt(oToB, "AdaptiveStyle");
	int nOnOff = GetLocalInt(oToB, "Is9SMenuActive" + sClass);
	int nCloseValid;

	nCloseValid = 0;

	if ((sClass == "_CR") && (nOnOff == 1) && (oCheck == oMartialAdept) && (GetIsInCombat(oMartialAdept)) && (nAdaptive == 1))
	{
		nCloseValid = 0;
		SetLocalInt(oToB, "AS_HaltCrCycle", 1); // Red Light on the Crusader's recovery method.
		SetLocalInt(oToB, "RedCrusader", 1);
		SetLocalInt(oToB, "EncounterR1", 0);
	}
	else if ((sClass == "_CR") && (nOnOff == 1) && (oCheck == oMartialAdept) && (GetIsInCombat(oMartialAdept)) && (!CheckRedCrusader(oMartialAdept, oToB)))
	{
		nCloseValid = 0;
	}
	else if ((sClass == "_CR") && (nOnOff == 1) && (oCheck != oMartialAdept))
	{
		nCloseValid = 1;
		SetLocalInt(oToB, "CR_ForcedClose", 1);
		SetLocalInt(oToB, "DisableQuickstrike", 0);
		RunForcedClosed(oMartialAdept);
	}
	else if (!GetIsObjectValid(oToB))
	{
		nCloseValid = 1;
	}
	else if (nOnOff == 1)
	{
		if (oCheck != oMartialAdept)
		{
			nCloseValid = 1;
		}
		else if ((GetIsInCombat(oMartialAdept)) && (nAdaptive == 0))
		{
			nCloseValid = 1;
		}
	}
	else nCloseValid = 0;

	if (nCloseValid == 1)
	{
		if (sClass == "_CR")
		{
			SetLocalInt(oToB, "RedCrusader", 0);

			if (nAdaptive == 1) // Sometimes it will happen.
			{
				SetLocalInt(oToB, "CrusaderActive", 0);
				SetLocalInt(oMartialAdept, "CrusaderActive", 0);
				SetLocalInt(oToB, "AdaptiveStyle", 0);
				SetLocalInt(oToB, "DisableQuickstrike", 0);
				SetLocalInt(oToB, "AS_HaltCrCycle", 0); // Green Light on the Crusader's recovery method.
				DelayCommand(0.1f, ExecuteScript("cr_recovery", oPC));
			}
		}

		if (sClass == "___")
		{
			SetLocalInt(oToB, "Is9SMenuActive___", 0);
			CloseGUIScreen(oCheck, "SCREEN_MANEUVERS_KNOWN");
			CloseGUIScreen(oCheck, "SCREEN_MANEUVERS_READIED");
		}
		else
		{
			SetLocalInt(oToB, "Is9SMenuActive" +sClass, 0);
			CloseGUIScreen(oCheck, "SCREEN_MANEUVERS_KNOWN" + sClass);
			CloseGUIScreen(oCheck, "SCREEN_MANEUVERS_READIED" + sClass);
		}
	}
	else DelayCommand(0.1f, RunScreenCheck(oMartialAdept, sClass));
}

void main(string sClass)
{	
	object oPC = OBJECT_SELF;
	object oMartialAdept = GetControlledCharacter(oPC);

	RunScreenCheck(oMartialAdept, sClass);
}