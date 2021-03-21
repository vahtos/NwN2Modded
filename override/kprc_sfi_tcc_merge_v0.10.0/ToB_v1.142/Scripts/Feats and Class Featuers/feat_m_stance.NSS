//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 6/5/2009							//
//	Title: feat_m_stance					//
//	Description: Allows the player to learn	//
//	any stance within the prereqs.  Can be	//
//	taken up to three times.				//
//////////////////////////////////////////////

#include "bot9s_include"
#include "bot9s_inc_constants"

void EnforceData()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	if (GetIsObjectValid(oToB))
	{
		int nManeuverLevel = GetHitDice(oPC);
		SetLocalInt(oToB, "MartialStance1", nManeuverLevel);
	}
	else DelayCommand(0.1f, EnforceData());
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	if (GetLocalInt(oToB, "MartialStance1") == 0)
	{
		EnforceData();
	}

	if (!GetHasFeat(FEAT_MARTIAL_ADEPT, oPC))
	{
		WrapperFeatAdd(oPC, FEAT_MARTIAL_ADEPT, FALSE);
	}

	if (!GetHasFeat(FEAT_STUDENT_OF_THE_SUBLIME_WAY, oPC))
	{
		WrapperFeatAdd(oPC, FEAT_STUDENT_OF_THE_SUBLIME_WAY, FALSE);
	}
}