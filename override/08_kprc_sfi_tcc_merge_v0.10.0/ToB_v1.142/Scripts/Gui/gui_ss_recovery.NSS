//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 6/4//2009							//
//	Title: gui_ss_recovery					//
//	Description: Activates the Swordsage's	//
//	recovery method.						//
//////////////////////////////////////////////

#include "bot9s_inc_constants"

void SetStrike(int nRow, object oToB)
{
	int i;

	i = 0;

	SetLocalInt(oToB, "Strike0", 1);

	while (GetLocalInt(oToB, "Strike" + IntToString(i)) > 0)
	{
		i++;

		if (GetLocalInt(oToB, "Strike" + IntToString(i)) == 0)
		{
			SetLocalInt(oToB, "Strike" + IntToString(i), nRow);
			SetLocalInt(oToB, "HighStrike", i);
			break;
		}
	}
}

void main()
{	
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");

	SetStrike(221, oToB);
	ActionUseFeat(FEAT_STUDENT_OF_THE_SUBLIME_WAY, oPC);
}