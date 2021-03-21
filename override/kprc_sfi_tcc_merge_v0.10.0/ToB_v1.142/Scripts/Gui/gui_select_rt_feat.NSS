//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 6/12/2009								//
//	Title: gui_select_rt_feat					//
//	Description: Adds a feat for the PC to learn//
//	in place of an older one.  Does not actually//
//	retrain the feat yet.  This script preps it.//
//////////////////////////////////////////////////

#include "bot9s_inc_retrain"

void main(string sData)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");

	if (GetLocalInt(oToB, "FeatRetrainPhase") == 0)
	{
		int nSwitch = GetLocalInt(oToB, "SSInsightSwitch");

		if (nSwitch > 0)
		{
			int nDiscipline = StringToInt(sData);
	
			SetLocalInt(oToB, "SSWeaponFocus", nDiscipline);
			DisplaySSInsightfulStrike(oPC, oToB);
	
			string sPict;
			string sTitle;
	
			switch (nDiscipline)
			{
				case 1: sPict = "desertwind";	sTitle = "Desert Wind";		break;
				case 3: sPict = "diamondmind";	sTitle = "Diamond Mind";	break;
				case 5: sPict = "settingsun";	sTitle = "Setting Sun";		break;
				case 6: sPict = "greenhand";	sTitle = "Shadow Hand";		break;
				case 7: sPict = "stonedragon";	sTitle = "Stone Dragon";	break;
				case 8: sPict = "tigerclaw";	sTitle = "Tiger Claw";		break;
				default:sPict = "b_empty.tga";	sTitle = "";				break;
			}
	
			string sIcon = "RETRAIN_IMAGE=" + sPict + ".tga";
			string sName = "RETRAIN_TEXT=" + sTitle;
			string sVari = "7=" + IntToString(nDiscipline);

			SetGUIObjectDisabled(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "CHOICE_NEXT", FALSE);
			SetGUIObjectText(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "POINT_POOL_TEXT", -1, "0");
			AddListBoxRow(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "ADDED_RETRAIN_LIST", "RETRAINPANE_PROTO" + IntToString(nDiscipline), sName, sIcon, sVari, "");
			SetLocalInt(oToB, "SSInsightSwitch", 0);
		}
	}
	else
	{
		int nPool = GetLocalInt(oToB, "AvialableToRetrain");
		int nData = StringToInt(sData);

		if ((nPool > 0) && (GetLocalInt(oToB, "RetrainLoopCheck") == 0))
		{
			if (GetLocalInt(oToB, "PendingFeat1") > 0)
			{
				SetLocalInt(oToB, "PendingFeat2", nData);
			}
			else SetLocalInt(oToB, "PendingFeat1", nData);

			SetLocalInt(oToB, "RetrainLoopCheck", 1);
			SetLocalInt(oToB, "AvialableToRetrain", nPool - 1);
			SetGUIObjectText(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "POINT_POOL_TEXT", -1, IntToString(nPool - 1));
			DisplayAddedFeats(oPC, oToB);
			ClearListBox(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "AVAILABLE_RETRAIN_LIST");
			GetAllAvailableFeats(oPC, oToB, 1, 25);
		}
	}
}