///////////////////////////////////////////////
// Author: Drammel							 //
// Date: 1/7/2009						  	 //
// Title: gui_launch_bot9s					 //
// Description: Launch the Martial Adept Menu//
///////////////////////////////////////////////

//#include "bot9s_inc_misc" //This file still seems to be causing trouble.  It may be that it hooks into too many other scripts.
#include "bot9s_inc_constants"

void RecoverAllManeuvers(string sScreen)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");
	string sClass = GetStringRight(sScreen, 3);

	if (sClass == "_CR")
	{
		SetLocalInt(oToB, "EncounterR1", 0);
		return;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR1" + sClass) > 0) // The extra checks improve preformance.
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_ONE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR2" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TWO", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR3" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_THREE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR4" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FOUR", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR5" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FIVE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR6" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SIX", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR7" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SEVEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR8" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_EIGHT", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR9" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_NINE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR10" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR11" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_ELEVEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR12" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TWELVE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR13" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_THIRTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR14" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FOURTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR15" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FIFTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR16" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SIXTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR17" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SEVENTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR18" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_EIGHTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR19" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_NINETEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR20" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TWENTY", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB1" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_ONE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB2" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_TWO", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB3" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_THREE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB4" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_FOUR", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB5" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_FIVE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB6" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_SIX", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB7" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_SEVEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB8" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_EIGHT", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB9" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_NINE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB10" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_TEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC1" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_ONE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC2" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_TWO", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC3" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_THREE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC4" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_FOUR", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC5" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_FIVE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC6" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_SIX", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC7" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_SEVEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC8" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_EIGHT", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC9" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_NINE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC10" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_TEN", FALSE);
	}
}

int CheckRedCrusader(object oPC, object oToB)
{
	int nReadiedTotal = GetLocalInt(oToB, "ReadiedTotal_CR");
	int n, nRed, nReturn;
	string sRed;

	n = 1;
	nRed = 0;

	while (n < 18)
	{
		sRed = "RedBox" + IntToString(n) + "_CR";

		if (GetLocalInt(oToB, sRed) == 1)
		{
			nRed += 1;
		}

		if (nRed == nReadiedTotal)
		{
			nReturn = TRUE;
			break;
		}

		n++;
	}

	return nReturn;
}

void main(string sClass)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");
	string sScreenKnown;
	string sScreenReadied;

	if (sClass == "___")
	{
		sScreenKnown = "SCREEN_MANEUVERS_KNOWN";
	}
	else  sScreenKnown = "SCREEN_MANEUVERS_KNOWN" + sClass;

	if (sClass == "___")
	{
		sScreenReadied = "SCREEN_MANEUVERS_READIED";
	}
	else sScreenReadied = "SCREEN_MANEUVERS_READIED" + sClass;

	string sKnown;
	string sReadied;

	if (sClass == "_CR")
	{
		sKnown = "maneuvers_known_cr.xml";
	}
	else if (sClass == "_SA")
	{
		sKnown = "maneuvers_known_sa.xml";
	}
	else if (sClass == "_SS")
	{
		sKnown = "maneuvers_known_ss.xml";
	}
	else if (sClass == "_WB")
	{
		sKnown = "maneuvers_known_wb.xml";
	}
	else sKnown = "maneuvers_known.xml";
	
	if (sClass == "_CR")
	{
		sReadied = "maneuvers_readied_cr.xml";
	}
	else if (sClass == "_SA")
	{
		sReadied = "maneuvers_readied_sa.xml";
	}
	else if (sClass == "_SS")
	{
		sReadied = "maneuvers_readied_ss.xml";
	}
	else if (sClass == "_WB")
	{
		sReadied = "maneuvers_readied_wb.xml";
	}
	else sReadied = "maneuvers_readied.xml";

	int nAdaptive = GetLocalInt(oToB, "AdaptiveStyle");

	if ((GetIsObjectValid(oToB)) && (GetLocalInt(oToB, "Encounter") != 0) && (GetHasFeat(FEAT_ADAPTIVE_STYLE, oPC)) && (nAdaptive == 0) && (GetLocalInt(oToB, "Is9SMenuActive" + sClass) == 0))
	{
		SetLocalString(oToB, "AS_Class", sClass);
		SetLocalString(oToB, "AS_Known", sKnown);
		SetLocalString(oToB, "AS_Readied", sReadied);
		SetLocalString(oToB, "AS_ScreenKnown", sScreenKnown);
		SetLocalString(oToB, "AS_ScreenReadied", sScreenReadied);

		if (sClass == "_CR")
		{
			SetLocalInt(oToB, "AS_HaltCrCycle", 1); // Red Light on the Crusader's recovery method.
			SetLocalInt(oToB, "RedCrusader", 1);
			SetLocalInt(oToB, "EncounterR1", 0);
		}

		ActionUseFeat(FEAT_ADAPTIVE_STYLE, oPC);
	}
	else if ((sClass == "_CR") && (CheckRedCrusader(oPC, oToB)) && (GetLocalInt(oToB, "Is9SMenuActive" + sClass) == 1) && (nAdaptive == 1))
	{
		SetLocalInt(oToB, "Is9SMenuActive" + sClass, 0);
		SetLocalInt(oToB, "RedCrusader", 0);
		SetLocalInt(oToB, "CR_ForcedClose", 0);
		CloseGUIScreen(oPC, sScreenKnown);
		CloseGUIScreen(oPC, sScreenReadied);
		SetLocalInt(oToB, "CrusaderActive", 0);
		SetLocalInt(oPC, "CrusaderActive", 0);
		SetLocalInt(oToB, "AdaptiveStyle", 0);
		SetLocalInt(oToB, "DisableQuickstrike", 0);
		SetLocalInt(oToB, "AS_HaltCrCycle", 0); // Green Light on the Crusader's recovery method.
		DelayCommand(0.1f, ExecuteScript("cr_recovery", oPC));
	}
	else if ((sClass != "_CR") && (GetLocalInt(oToB, "Is9SMenuActive" + sClass) == 1) && (nAdaptive == 1))
	{
		SetLocalInt(oToB, "Is9SMenuActive" + sClass, 0);	
		CloseGUIScreen(oPC, sScreenKnown);
		CloseGUIScreen(oPC, sScreenReadied);
		SetLocalInt(oToB, "AdaptiveStyle", 0);
		SetLocalInt(oToB, "DisableQuickstrike", 0);

		string sScreen;

		if (sClass == "___")
		{
			sScreen = "SCREEN_QUICK_STRIKE";
		}
		else sScreen = "SCREEN_QUICK_STRIKE" + sClass;

		RecoverAllManeuvers(sScreen);
	}
	else if ((GetLocalInt(oToB, "Is9SMenuActive_CR") == 1) && (GetLocalInt(oToB, "Encounter") != 0) && (!CheckRedCrusader(oPC, oToB)))
	{
		int nReadiedTotal = GetLocalInt(oToB, "ReadiedTotal_CR");

		SendMessageToPC(oPC, "<color=red>You must ready a total of " + IntToString(nReadiedTotal) + " maneuvers before you can close the menu.</color>");
	}
	else if (GetIsObjectValid(oToB) && (GetLocalInt(oToB, "Encounter") != 0))
	{
		SendMessageToPC(oPC, "<color=red>You cannot change maneuvers while in combat.</color>");
	}
	else if (GetIsObjectValid(oToB))
	{
		if (GetLocalInt(oToB, "Is9SMenuActive" + sClass) == 0)
		{
			SetLocalInt(oToB, "Is9SMenuActive" + sClass, 1);
			DisplayGuiScreen(oPC, sScreenReadied, FALSE, sReadied);
			DisplayGuiScreen(oPC, sScreenKnown, FALSE, sKnown);

			if (sClass == "_CR")
			{
				SetLocalInt(oToB, "RedCrusader", 1);
			}
		}
		else if ((sClass == "_CR") && (!CheckRedCrusader(oPC, oToB)))
		{
			int nReadiedTotal = GetLocalInt(oToB, "ReadiedTotal_CR");

			SendMessageToPC(oPC, "<color=red>You must ready a total of " + IntToString(nReadiedTotal) + " maneuvers before you can close the menu.</color>");
		}
		else
		{
			CloseGUIScreen(oPC, sScreenReadied);
			CloseGUIScreen(oPC, sScreenKnown);
			SetLocalInt(oToB, "Is9SMenuActive" + sClass, 0);

			if (sClass == "_CR")
			{
				SetLocalInt(oToB, "RedCrusader", 0);
				SetLocalInt(oToB, "CR_ForcedClose", 0);
			}
		}
	}
	else SendMessageToPC(oPC, "<color=red>You must activate the training feat for your class before you can open the Martial Adept Menu.</color>");
}