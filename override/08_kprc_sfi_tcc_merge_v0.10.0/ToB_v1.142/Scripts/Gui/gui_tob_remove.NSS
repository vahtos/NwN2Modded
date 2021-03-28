//////////////////////////////////////////
//	Author: Drammel						//
//	Date: 4/6/2009						//
//	Title: gui_tob_remove				//
//	Description: Removes a maneuver from//
//	the Readied Maneuvers screen.		//
//////////////////////////////////////////

#include "bot9s_inc_index"

void ClearBoxes(string sClass, object oToB)
{
	int i;

	i = 1;

	while (i < 18) //RedBoxes
	{
		SetLocalInt(oToB, "RedBox" + IntToString(i) + sClass, 0);
		i++;
	}

	i = 1;

	while (i < 11) //GreenBoxes
	{
		SetLocalInt(oToB, "GreenBoxB" + IntToString(i) + sClass, 0);
		i++;
	}

	i = 1;

	while (i < 11)
	{
		SetLocalInt(oToB, "GreenBoxC" + IntToString(i) + sClass, 0);
		i++;
	}

	i = 1;

	while (i < 21)
	{
		SetLocalInt(oToB, "GreenBoxSTR" + IntToString(i) + sClass, 0);
		i++;
	}

	i = 1;

	while (i < 11) //BlueBoxes
	{
		SetLocalInt(oToB, "BlueBoxB" + IntToString(i) + sClass, 0);
		i++;
	}

	i = 1;

	while (i < 11)
	{
		SetLocalInt(oToB, "BlueBoxC" + IntToString(i) + sClass, 0);
		i++;
	}

	i = 1;

	while (i < 21)
	{
		SetLocalInt(oToB, "BlueBoxSTR" + IntToString(i) + sClass, 0);
		i++;
	}
}

void main(string sClass, string sRed)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");
	string sScreen;

	if (sClass == "___")
	{
		sScreen = "SCREEN_MANEUVERS_READIED";
	}
	else sScreen = "SCREEN_MANEUVERS_READIED" + sClass;

	string sBox = "READIED_" + sRed;

	if (GetLocalInt(oToB, "RedBox" + sRed + sClass) == 0) //Sanity checks.
	{
		int i;
		string sRedBox;
		string sEmpty;

		i = 1;

		while (i < 18)
		{
			sRedBox = "READIED_" + IntToString(i);

			if (GetLocalInt(oToB, "RedBox" + IntToString(i) + sClass) == 0)
			{
				ClearListBox(oPC, sScreen, sRedBox);
				SetGUIObjectDisabled(oPC, sScreen, sRedBox, TRUE);
				DeleteLocalString(oToB, "Readied" + IntToString(i) + sClass);
				DeleteLocalInt(oToB, "ReadiedRow" + IntToString(i) + sClass);
				DeleteLocalInt(oToB, "Readied" + IntToString(i) + sClass + "Disabled");
			}
			i++;
		}
		DelayCommand(0.1f, ClearBoxes(sClass, oToB));
	}
	else
	{
		ClearListBox(oPC, sScreen, sBox);
		SetGUIObjectDisabled(oPC, sScreen, sBox, TRUE);
		RemoveManeuver(StringToInt(sRed), sClass);
		DeleteLocalString(oToB, "Readied" + sRed + sClass);
		DeleteLocalInt(oToB, "ReadiedRow" + sRed + sClass);
		DeleteLocalInt(oToB, "Readied" + sRed + sClass + "Disabled");
	}
}