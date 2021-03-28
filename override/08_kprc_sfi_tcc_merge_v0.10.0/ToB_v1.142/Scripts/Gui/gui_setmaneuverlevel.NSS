//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 4/7/2009							//
//	Title: gui_setmaneuverlevel				//
//	Description: Sets the level of maneuver	//
//	displayed in Maneuvers Known.			//
//////////////////////////////////////////////

void main(string sData)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	string sLevel = GetStringLeft(sData, 1);
	string sClass = GetStringRight(sData, 3);
	string sScreen;
	
	if (sClass == "___")
	{
		sScreen = "SCREEN_MANEUVERS_KNOWN";
	}
	else sScreen = "SCREEN_MANEUVERS_KNOWN" + sClass;

	string sStanceListBox = "STANCE_LIST";
	string sListBoxL1 = "LEVEL1_LIST";
	string sListBoxL2 = "LEVEL2_LIST";
	string sListBoxL3 = "LEVEL3_LIST";
	string sListBoxL4 = "LEVEL4_LIST";
	string sListBoxL5 = "LEVEL5_LIST";
	string sListBoxL6 = "LEVEL6_LIST";
	string sListBoxL7 = "LEVEL7_LIST";
	string sListBoxL8 = "LEVEL8_LIST";
	string sListBoxL9 = "LEVEL9_LIST";
	
	if (sLevel == "0")
	{
		SetGUIObjectHidden(oPC, sScreen, sStanceListBox, FALSE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL1, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL2, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL3, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL4, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL5, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL6, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL7, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL8, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL9, TRUE);
	}
	else if (sLevel == "1")
	{
		SetGUIObjectHidden(oPC, sScreen, sStanceListBox, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL1, FALSE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL2, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL3, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL4, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL5, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL6, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL7, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL8, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL9, TRUE);
	}
	else if (sLevel == "2")
	{
		SetGUIObjectHidden(oPC, sScreen, sStanceListBox, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL1, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL2, FALSE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL3, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL4, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL5, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL6, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL7, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL8, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL9, TRUE);
	}
	else if (sLevel == "3")
	{
		SetGUIObjectHidden(oPC, sScreen, sStanceListBox, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL1, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL2, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL3, FALSE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL4, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL5, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL6, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL7, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL8, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL9, TRUE);
	}
	else if (sLevel == "4")
	{
		SetGUIObjectHidden(oPC, sScreen, sStanceListBox, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL1, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL2, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL3, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL4, FALSE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL5, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL6, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL7, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL8, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL9, TRUE);
	}
	else if (sLevel == "5")
	{
		SetGUIObjectHidden(oPC, sScreen, sStanceListBox, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL1, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL2, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL3, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL4, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL5, FALSE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL6, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL7, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL8, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL9, TRUE);
	}
	else if (sLevel == "6")
	{
		SetGUIObjectHidden(oPC, sScreen, sStanceListBox, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL1, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL2, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL3, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL4, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL5, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL6, FALSE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL7, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL8, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL9, TRUE);
	}
	else if (sLevel == "7")
	{
		SetGUIObjectHidden(oPC, sScreen, sStanceListBox, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL1, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL2, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL3, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL4, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL5, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL6, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL7, FALSE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL8, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL9, TRUE);
	}
	else if (sLevel == "8")
	{
		SetGUIObjectHidden(oPC, sScreen, sStanceListBox, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL1, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL2, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL3, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL4, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL5, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL6, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL7, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL8, FALSE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL9, TRUE);
	}
	else if (sLevel == "9")
	{
		SetGUIObjectHidden(oPC, sScreen, sStanceListBox, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL1, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL2, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL3, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL4, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL5, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL6, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL7, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL8, TRUE);
		SetGUIObjectHidden(oPC, sScreen, sListBoxL9, FALSE);
	}
}