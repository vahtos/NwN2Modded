//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 6/9/2009								//
//	Title: gui_rt_feat							//
//	Description: Allows the player to retrain an//
//	old feat.									//
//////////////////////////////////////////////////

#include "bot9s_inc_retrain"

void main(string sData)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nFeat = StringToInt(sData);
	int nLevel = GetLocalInt(oToB, "CurrentLevelupLevel");
	int nClass = GetLocalInt(oToB, "LevelupClass");

	int nRetrain = GetLocalInt(oToB, "FeatRetrainAmount");
	int nAvailable = GetLocalInt(oToB, "AvialableToRetrain");

	if (GetLocalInt(oToB, "RetrainLoopCheck") == 0)
	{
		SetLocalInt(oToB, "RetrainLoopCheck", 1);
		SetGUIObjectText(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "RETRAIN_POOL_TEXT", -1, IntToString(nRetrain - 1));
		SetGUIObjectText(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "POINT_POOL_TEXT", -1, IntToString(nAvailable + 1));
		SetLocalInt(oToB, "FeatRetrainAmount", (nRetrain - 1));
		SetLocalInt(oToB, "AvialableToRetrain", nAvailable + 1);
	
		if (GetLocalInt(oToB, "FeatRetrain1") > 0)
		{
			SetLocalInt(oToB, "FeatRetrain2", nFeat);
		}
		else SetLocalInt(oToB, "FeatRetrain1", nFeat);
	
		if (GetLocalInt(oToB, "FeatRetrainAmount") == 0)
		{
			ClearListBox(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "RETRAIN_FEATS_LIST");
			ClearListBox(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "AVAILABLE_RETRAIN_LIST");
			GetAllAvailableFeats(oPC, oToB, 1, 25);
		}
		else
		{
			ClearListBox(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "RETRAIN_FEATS_LIST");
			ClearListBox(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "AVAILABLE_RETRAIN_LIST");
			AddAllKnownFeats(oPC, oToB, 1, 50);
			GetAllAvailableFeats(oPC, oToB, 1, 25);
		}
	}
}