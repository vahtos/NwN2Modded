//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 1/16/2009							//
//	Title: gui_quickstrike					//
//	Description: Opens the Quickstrike menu	//
//	from the Martial Adept bar.				//
//////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_index"
#include "bot9s_cr_recovery"
//#include "bot9s_inc_misc" -Was causing a runtime error that shut down the toolset, possibly due to data corruption.

void RecoverAllManeuvers(string sScreen, object oPC, string sClass)
{
	object oToB = GetItemPossessedBy(oPC, "tob");

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

void main(string sData)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");

	if (GetLocalInt(oToB, "DisableQuickstrike") == 1)
	{
		return; // Bug prevention with Adaptive Style.
	}

	string sClass = GetStringRight(sData, 3);
	string sScreen;
	
	if (sClass != "___")
	{
		sScreen = "SCREEN_QUICK_STRIKE" + sClass;
	}
	else sScreen = "SCREEN_QUICK_STRIKE";

	string sXml;
	
	if (sClass == "_CR")
	{
		sXml = "quickstrike_cr.xml";
	}
	else if (sClass == "_SA")
	{
		sXml = "quickstrike_sa.xml";
	}
	else if (sClass == "_SS")
	{
		sXml = "quickstrike_ss.xml";
	}
	else if (sClass == "_WB")
	{
		sXml = "quickstrike_wb.xml";
	}
	else sXml = "quickstrike.xml";

	if (GetIsObjectValid(oToB))
	{
		SetLocalInt(oToB, "BlueBoxF1" + sClass, 211); // Charge Action.

		if (GetLocalInt(oToB, "SBTToggleIsSet") == 0)
		{
			int nSBT; // Beginning of support loop for Shadow Blade Technique.

			nSBT = 1;

			while (nSBT < 21)
			{
				if (GetLocalInt(oToB, "BlueBoxSTR" + IntToString(nSBT) + sClass) == 132)
				{
					string sSBTBox = GetSwiftFeat(sClass);
					SetLocalInt(oToB, sSBTBox, 225);
					SetLocalInt(oToB, "SBTToggleIsSet", 1);
					break;
				}
				nSBT++;
			}
		}

		if (GetLocalInt(oToB, "SCToggleIsSet") == 0)
		{
			int nSC; // Beginning of support loop for Salamander Charge.

			nSC = 1;

			while (nSC < 21)
			{
				if (GetLocalInt(oToB, "BlueBoxSTR" + IntToString(nSC) + sClass) == 22)
				{
					string sSCBox = GetSwiftFeat(sClass);
					SetLocalInt(oToB, sSCBox, 226);
					SetLocalInt(oToB, "SCToggleIsSet", 1);
					break;
				}
				nSC++;
			}
		}

		if (GetLocalInt(oToB, "GDSToggleIsSet") == 0)
		{
			int nGDS; // Beginning of support loop for Greater Divine Surge.

			nGDS = 1;

			while (nGDS < 21)
			{
				if (GetLocalInt(oToB, "BlueBoxSTR" + IntToString(nGDS) + sClass) == 37)
				{
					string sGDSBox = GetSwiftFeat(sClass);
					SetLocalInt(oToB, sGDSBox, 227);
					SetLocalInt(oToB, "GDSToggleIsSet", 1);
					break;
				}
				nGDS++;
			}
		}

		if (GetLocalInt(oToB, "IsQStrikeActive" + sClass) == 0)
		{
			SetLocalInt(oToB, "IsQStrikeActive" + sClass, 1);
			DisplayGuiScreen(oPC, sScreen, FALSE, sXml);

			if (sScreen == "SCREEN_QUICK_STRIKE_CR")
			{
				if (!GetIsInCombat(oPC))
				{
					DisableAll();
				}
				else
				{
					int nLimit = GetLocalInt(oToB, "CrLimit");
					string RRFlag;
					int i;
	
					i = 1;
	
					while (i <= nLimit)
					{
						RRFlag = GetLocalString(oToB, "RandomRecoveryFlag" + IntToString(i));
						SetGUIObjectDisabled(oPC, sScreen, RRFlag, TRUE);
						i++;
					}
				}
			}
			else if (GetLocalInt(oToB, "Encounter") == 0)
			{
				RecoverAllManeuvers(sScreen, oPC, sClass);
			}
		}
		else
		{
			SetLocalInt(oToB, "IsQStrikeActive" + sClass, 0);
			CloseGUIScreen(oPC, sScreen);
		}
	}
	else SendMessageToPC(oPC, "<color=red>You must activate the training feat for your class before you can open the Quickstrike Menu.</color>");
}