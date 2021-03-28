//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 6/12/2009								//
//	Title: gui_unlearn_rt_feat					//
//	Description: Removes a feat that the PC has //
//	selected to retrain into from the added feat//
//	window.										//
//////////////////////////////////////////////////

#include "bot9s_inc_retrain"

void main(string sData)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");

	if (GetLocalInt(oToB, "FeatRetrainPhase") == 0)
	{
		SetGUIObjectDisabled(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "CHOICE_NEXT", TRUE);
		ClearListBox(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "ADDED_RETRAIN_LIST");
		SetGUIObjectText(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "POINT_POOL_TEXT", -1, "1");
		SetLocalInt(oToB, "SSInsightSwitch", 1);
		SetLocalInt(oToB, "SSWeaponFocus", 0);
		DisplaySSInsightfulStrike(oPC, oToB);
	}
	else if (GetLocalInt(oToB, "RetrainLoopCheck") == 0)
	{
		int nPool = GetLocalInt(oToB, "AvialableToRetrain");
		int nData = StringToInt(sData);
		int nPending1 = GetLocalInt(oToB, "PendingFeat1");
		int nPending2 = GetLocalInt(oToB, "PendingFeat2");

		if (nPending1 == nData)
		{
			SetLocalInt(oToB, "PendingFeat1", 0);
		}
		else SetLocalInt(oToB, "PendingFeat2", 0);

		SetLocalInt(oToB, "RetrainLoopCheck", 1);
		SetLocalInt(oToB, "AvialableToRetrain", nPool + 1);
		SetGUIObjectText(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "POINT_POOL_TEXT", -1, IntToString(nPool + 1));
		ClearListBox(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "AVAILABLE_RETRAIN_LIST");
		GetAllAvailableFeats(oPC, oToB, 1, 25);
		DisplayAddedFeats(oPC, oToB);
	}
}