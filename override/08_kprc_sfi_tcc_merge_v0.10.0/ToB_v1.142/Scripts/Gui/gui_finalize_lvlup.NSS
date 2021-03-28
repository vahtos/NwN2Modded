//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 6/3/2009									//
//	Title: gui_finalize_lvlup						//
//	Description: Creates maneuvers based on the 	//
//	"AddedManeuvers" variables in oToB.				//
//	Also preps the martial adept screens and indexes//
//	to add the new maneuvers.						//
//////////////////////////////////////////////////////

#include "bot9s_inc_2da"
#include "bot9s_inc_constants"
#include "bot9s_include"

int CreateManeuver(object oPC, object oToB, int nMartialAdept, string sName, int nMax, int i, int nFinish)
{
	object oManeuver;
	string sItem, sData;
	int nManeuver, nRetrain, nLevel, nType, nMovement, nLocation, nSupressAoO, nStrRef, nDescription;
	float fRange;

	while (i <= nFinish)
	{
		sData = GetLocalString(oToB, "AddedManeuver" + IntToString(i));// AddedManeuver is the index number.
		sItem = tob_Get2daString("maneuvers", "Script", i);
		nManeuver = StringToInt(sData);
		nRetrain = GetLocalInt(oToB, "RetrainManeuver");

		if (sItem == (tob_Get2daString("maneuvers", "Script", nRetrain)))
		{
			DestroyObject(GetObjectByTag(sName + sItem));
		}

		if (nManeuver > 0)
		{
			oManeuver = CreateItemOnObject("maneuver", oToB, 1, sName + sItem, FALSE);
			nStrRef = tob_Get2daInt("maneuvers", "StrRef", nManeuver);
			nDescription = tob_Get2daInt("maneuvers", "Description", nManeuver);
			nType = tob_Get2daInt("maneuvers", "Type", nManeuver);
			nMovement = tob_Get2daInt("maneuvers", "Movement", nManeuver);
			nLocation = tob_Get2daInt("maneuvers", "Location", nManeuver);
			nSupressAoO = tob_Get2daInt("maneuvers", "SupressAoO", nManeuver);
			fRange = tob_Get2daFloat("maneuvers", "Range", nManeuver);

			SetFirstName(oManeuver, GetStringByStrRef(nStrRef));
			SetDescription(oManeuver, GetStringByStrRef(nDescription));

			if (tob_Get2daInt("maneuvers", "IsStance", nManeuver) == 1)
			{
				nLevel = 0;
			}
			else nLevel = tob_Get2daInt("maneuvers", "Level", nManeuver);
			
			SetLocalInt(oManeuver, "2da", nManeuver);
			SetLocalInt(oManeuver, "Level", nLevel);
			SetLocalInt(oManeuver, "Class", nMartialAdept);
			SetLocalInt(oManeuver, "Type", nType);

			if (nMovement > 0)
			{
				SetLocalInt(oManeuver, "Movement", nMovement);
			}

			if (nLocation > 0)
			{
				SetLocalInt(oManeuver, "Location", nLocation);
			}

			if (nSupressAoO > 0)
			{
				SetLocalInt(oManeuver, "SupressAoO", nSupressAoO);
			}

			if (fRange > 0.0f)
			{
				SetLocalFloat(oManeuver, "Range", fRange);
			}
		}

		DeleteLocalString(oToB, "AddedManeuver" + IntToString(i));
		i++;
	}

	return i;
}

void CreateManeuverLoop(object oPC, object oToB, int nMartialAdept, string sName, int nMax, int nStart, int nFinish)
{
	int i = CreateManeuver(oPC, oToB, nMartialAdept, sName, nMax, nStart, nFinish);

	if (i < nMax) // The 2da hasn't been entirely run through yet, so we're picking up where we left off to avoid TMI.
	{
		if (nFinish + 50 > nMax)
		{
			nFinish = nMax;
		}
		else nFinish = nFinish + 50;

		DelayCommand(0.01f, CreateManeuverLoop(oPC, oToB, nMartialAdept, sName, nMax, i, nFinish));
	}
	else SetLocalInt(oToB, "ManeuversCreated", 1);
}

void main()
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nClass = GetLocalInt(oToB, "LevelupClass");
	int nLevel = GetLocalInt(oToB, "LevelupGate" + IntToString(nClass));
	int nMartialAdept;

	SetLocalInt(oToB, "HaltRetrainFeats", 1); // Kill any of the remaining retrain feat loops.

	if (nClass == 255) // Martial Study/Stance rules.
	{
		int nCrusader = GetLevelByClass(CLASS_TYPE_CRUSADER, oPC);
		int nSaint = GetLevelByClass(CLASS_TYPE_SAINT, oPC);
		int nSwordsage = GetLevelByClass(CLASS_TYPE_SWORDSAGE, oPC);
		int nWarblade = GetLevelByClass(CLASS_TYPE_WARBLADE, oPC);

		if (nCrusader > nSaint || nCrusader > nSwordsage || nCrusader > nWarblade)
		{
			nMartialAdept = CLASS_TYPE_CRUSADER;
		}
		else if (nSaint > nCrusader || nSaint > nSwordsage || nSaint > nWarblade)
		{
			nMartialAdept = CLASS_TYPE_SAINT;
		}
		else if (nSwordsage > nCrusader || nSwordsage > nSaint || nSwordsage > nWarblade)
		{
			nMartialAdept = CLASS_TYPE_SWORDSAGE;
		}
		else if (nWarblade > nCrusader || nWarblade > nSaint || nWarblade > nSwordsage)
		{
			nMartialAdept = CLASS_TYPE_WARBLADE;
		}
		else if (nCrusader > 0 || nSaint > 0 || nSwordsage > 0 || nWarblade > 0)
		{
			if (nCrusader == nSaint || nCrusader == nSwordsage || nCrusader == nWarblade)
			{
				nMartialAdept = CLASS_TYPE_CRUSADER; // Fyi, purely an alphabetical preferance.
			}
			else if (nSaint == nSwordsage || nSaint == nWarblade)
			{
				nMartialAdept = CLASS_TYPE_SAINT;
			}
			else if (nSwordsage == nWarblade)
			{
				nMartialAdept = CLASS_TYPE_SWORDSAGE;
			}
			else nMartialAdept = CLASS_TYPE_WARBLADE;
		}
		else nMartialAdept = 255; // CLASS_TYPE_INVALID
	}
	else nMartialAdept = GetLocalInt(oToB, "LevelupClass");

	SetLocalInt(oToB, "LevelupGate" + IntToString(nClass), nLevel + 1);

	string sMyName = GetFirstName(oPC);
	int nMax = GetNum2DARows("maneuvers");

	CreateManeuverLoop(oPC, oToB, nMartialAdept, sMyName, nMax, 0, 50);

	string sClass;

	if (nClass == CLASS_TYPE_CRUSADER)
	{
		sClass = "CR";
	}
	else if (nClass == CLASS_TYPE_SAINT)
	{
		sClass = "SA";
	}
	else if (nClass == CLASS_TYPE_SWORDSAGE)
	{
		sClass = "SS";
	}
	else if (nClass == CLASS_TYPE_WARBLADE)
	{
		sClass = "WB";
	}
	else sClass = "";

	string sReadiedTotal = "ReadiedTotal" + "_" + sClass;
	int nReadiedTotal = GetLocalInt(oToB, sReadiedTotal);

	if (nClass == CLASS_TYPE_CRUSADER) //Manevers readied total per level for each class.
	{
		switch (nLevel)
		{
			case 1:	SetLocalInt(oToB, sReadiedTotal, nReadiedTotal + 5);	break;
			case 10:SetLocalInt(oToB, sReadiedTotal, nReadiedTotal + 1);	break;
			case 20:SetLocalInt(oToB, sReadiedTotal, nReadiedTotal + 1);	break;
			case 30:SetLocalInt(oToB, sReadiedTotal, nReadiedTotal + 1);	break;
		}
	}
	else if (nClass == CLASS_TYPE_SAINT)
	{
		//To be continued...
	}
	else if (nClass == CLASS_TYPE_SWORDSAGE)
	{
		switch (nLevel)
		{
			case 1:	SetLocalInt(oToB, sReadiedTotal, nReadiedTotal + 4);	break;
			case 3:	SetLocalInt(oToB, sReadiedTotal, nReadiedTotal + 1);	break;
			case 5:	SetLocalInt(oToB, sReadiedTotal, nReadiedTotal + 1);	break;
			case 8:	SetLocalInt(oToB, sReadiedTotal, nReadiedTotal + 1);	break;
			case 10:SetLocalInt(oToB, sReadiedTotal, nReadiedTotal + 1);	break;
			case 13:SetLocalInt(oToB, sReadiedTotal, nReadiedTotal + 1);	break;
			case 15:SetLocalInt(oToB, sReadiedTotal, nReadiedTotal + 1);	break;
			case 18:SetLocalInt(oToB, sReadiedTotal, nReadiedTotal + 1);	break;
			case 20:SetLocalInt(oToB, sReadiedTotal, nReadiedTotal + 1);	break;
			case 23:SetLocalInt(oToB, sReadiedTotal, nReadiedTotal + 1);	break;
			case 25:SetLocalInt(oToB, sReadiedTotal, nReadiedTotal + 1);	break;
			case 28:SetLocalInt(oToB, sReadiedTotal, nReadiedTotal + 1);	break;
			case 30:SetLocalInt(oToB, sReadiedTotal, nReadiedTotal + 1);	break;
		}
	}
	else if (nClass == CLASS_TYPE_WARBLADE)
	{
		switch (nLevel)
		{
			case 1:	SetLocalInt(oToB, sReadiedTotal, nReadiedTotal + 3);	break;
			case 4:	SetLocalInt(oToB, sReadiedTotal, nReadiedTotal + 1);	break;
			case 10:SetLocalInt(oToB, sReadiedTotal, nReadiedTotal + 1);	break;
			case 15:SetLocalInt(oToB, sReadiedTotal, nReadiedTotal + 1);	break;
			case 20:SetLocalInt(oToB, sReadiedTotal, nReadiedTotal + 1);	break;
			case 25:SetLocalInt(oToB, sReadiedTotal, nReadiedTotal + 1);	break;
			case 30:SetLocalInt(oToB, sReadiedTotal, nReadiedTotal + 1);	break;
		}
	}
	else SetLocalInt(oToB, sReadiedTotal, nReadiedTotal + 1);// Martial Study and Stance.

	if (sClass == "")
	{
		if (GetLocalInt(oToB, "MStudy1Pending") == 1)
		{
			SetLocalInt(oToB, "MStudy1Used", 1);
		}
		else if (GetLocalInt(oToB, "MStudy2Pending") == 1)
		{
			SetLocalInt(oToB, "MStudy2Used", 1);
		}
		else if (GetLocalInt(oToB, "MStudy3Pending") == 1)
		{
			SetLocalInt(oToB, "MStudy3Used", 1);
		}
		else if (GetLocalInt(oToB, "MStance1Pending") == 1)
		{
			SetLocalInt(oToB, "MStance1Used", 1);
		}
		else if (GetLocalInt(oToB, "MStance2Pending") == 1)
		{
			SetLocalInt(oToB, "MStance2Used", 1);
		}
		else if (GetLocalInt(oToB, "MStance3Pending") == 1)
		{
			SetLocalInt(oToB, "MStance3Used", 1);
		}
	}

	AssignCommand(oPC, ClearBoxes(sClass)); // AssignCommand is used just in case the while loops start to pile up.
	AssignCommand(oPC, ClearManeuversReadied(sClass));
	AssignCommand(oPC, ClearManeuversKnown(sClass));

	int nRetrain1 = GetLocalInt(oToB, "FeatRetrain1");
	int nRetrain2 = GetLocalInt(oToB, "FeatRetrain2");
	int nPending1 = GetLocalInt(oToB, "PendingFeat1");
	int nPending2 = GetLocalInt(oToB, "PendingFeat2");

	if (nRetrain1 > 0)
	{
		FeatRemove(oPC, nRetrain1);
	}

	if (nRetrain2 > 0)
	{
		FeatRemove(oPC, nRetrain2);
	}

	// Tome of Battle specific issues. Prerequisite checks have already been made.
	if ((GetHitDice(oPC) == 1)	&& ((nPending1 == 6832 || nPending1 == 6833 || nPending1 == 6834 || nPending1 == 6835
	|| nPending1 == 6838 || nPending1 == 6839 || nPending1 == 6832 || nPending1 == 6840
	|| nPending1 == 6843 || nPending1 == 6844 || nPending1 == 6845 || nPending1 == 6847
	|| nPending1 == 6850)))
	{
		DelayCommand(0.1f, WrapperFeatAdd(oPC, nPending1, FALSE, TRUE));
	}
	else if (nPending1 > 0)
	{
		DelayCommand(0.1f, WrapperFeatAdd(oPC, nPending1, TRUE, TRUE));
	}

	if ((GetHitDice(oPC) == 1)	&& ((nPending2 == 6832 || nPending2 == 6833 || nPending2 == 6834 || nPending2 == 6835
	|| nPending2 == 6838 || nPending2 == 6839 || nPending2 == 6832 || nPending2 == 6840
	|| nPending2 == 6843 || nPending2 == 6844 || nPending2 == 6845 || nPending2 == 6847
	|| nPending2 == 6850)))
	{
		DelayCommand(0.1f, WrapperFeatAdd(oPC, nPending2, FALSE, TRUE));
	}
	else if (nPending2 > 0)
	{
		DelayCommand(0.2f, WrapperFeatAdd(oPC, nPending2, TRUE, TRUE));
	}

	DelayCommand(0.05, ExecuteScript("gui_tob_cancel_levelup", oPC));
}