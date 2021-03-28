//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 6/9/2009									//
//	Title: gui_display_infopane2					//
//	Description: Displays a feat's description		//
//	on the infopane sidebar.						//
//////////////////////////////////////////////////////

void main(string sData)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");
	string sTexture = Get2DAString("feat", "ICON", StringToInt(sData));
	int nTitle = StringToInt(Get2DAString("feat", "FEAT", StringToInt(sData)));
	int nText = StringToInt(Get2DAString("feat", "DESCRIPTION", StringToInt(sData)));

	if  (GetLocalInt(oToB, "FeatRetrainPhase") == 0)
	{
		SetGUITexture(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "INFOPANE_IMAGE", "b_empty.tga");
		SetGUIObjectText(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "INFOPANE_TITLE", -1, "Discipline Focus: Weapon Focus");
		SetGUIObjectText(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "INFOPANE_TEXT", 280688, "");
	}
	else
	{
		SetGUITexture(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "INFOPANE_IMAGE", sTexture + ".tga");
		SetGUIObjectText(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "INFOPANE_TITLE", nTitle, "");
		SetGUIObjectText(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "INFOPANE_TEXT", nText, "");
	}
}
	