//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 5/31/2009							//
//	Title: bot9s_inc_levelup				//
//	Description: Levelup functions for the	//
//	Book of the Nine Swords classes.		//
//////////////////////////////////////////////

#include "bot9s_inc_2da"
#include "bot9s_inc_constants"

// Prototypes

// Returns the maximum Maneuver level the PC can learn.
// -nLevelCap: The maximum martial adept level that we're allowed to check for.
int GetInitiatorLevelup(object oPC, int nClass, int nLevelCap = 0);

// Displays maneuvers that are chosen by the PC to gain on levelup.
void DisplayAddedManeuvers(object oPC, object oToB);

// Determines how many maneuvers a player should have without actually creating
// the items for them.  Used to determine which maneuvers a player can access.
// 1 = Initiate, 2 = Novice, 3 = Adept, 4 = Veteran, 5 or more = Master.
// -nDiscipline: Which discpline to add or subtract from.
// -bAddSubtract: Add or subtract from the total number of maneuvers of 
// nDiscipline.  Use TRUE to add and FALSE to subtract.
void PredictDisciplineStatus(int nDiscipline, int bAddSubtract);

// Sets the PC's level of mastery based upon how many maneuvers of a certain
// discipline they have learned.  Used for determining prerequisites.
// 1 = Initiate, 2 = Novice, 3 = Adept, 4 = Veteran, 5 or more = Master.
void DetermineDisciplineStatus();

// Used to only open the levelup xmls when all of the screen's data has been loaded.
void EnforceDataOpening(object oPC, object oToB);

// Creates a list of the PC's Known Maneuvers.
void GenerateKnownManeuvers(object oPC, object oToB);

// Runs data needed by the Levelup screen before it opens.
// -nClass: Class constant of the class that is leveling.
// -nLearn: Number of maneuvers available to learn this level.
// -nRetrain: Number of maneuvers available to be retrained this level, typically
// at 4th and every even numbered level thereafter.
// -nStance: Number of stances available to learn this level.
// -nLevelcap: Level of the class that is being leveled.  Implemented to avoid
// abuse of the levelup system when a character is autoleveled or similar.
void LoadLevelup(object oPC, object oToB, int nClass, int nLearn, int nRetrain, int nStance, int nLevelCap);

// Adds a Listbox to the maneuver selection screen.
// -nManeuver: Current number of the maneuver's listboxe, added to the maneuver selection screen.
void AddManeuver(object oPC, int nManeuver);

// Filters which maneuvers can be displayed and adds them.  Returns the value of the last maneuver checked.
// -nLevel: Initiator level of the maneuvers to display.
// -nClass: Determines which maneuvers are availible to this class.
// -nInitLevel: Maximum initiator level allowed to generate maneuvers for.
int GenerateManeuvers(object oPC, object oToB, int nLevel, int nClass, int n, int nFinish, int nInitLevel);

// Displays the maneuvers the PC can learn for the class they are leveling in.
// All stances are under level 0.
// -nLevel: Initiator level of the maneuvers to display.
// -nClass: Determines which maneuvers are availible to this class.
// -nInitLevel: Maximum initiator level allowed to generate maneuvers for.
void DisplayManeuversByClass(object oPC, object oToB, int nStart, int nFinish, int nLevel, int nClass, int nInitLevel);

// !EXPERIMENTAL!
// Finds the Tome of Battle object on the player and curses it (and its contents) if it isn't already.
// This has been implemented to deal with reports of the releveling proceddures failing in Mask of the Betrayer.
object GetTomeOfBattle(object oPC);


// Functions

// Returns the maximum Maneuver level the PC can learn.
// -nLevelCap: The maximum martial adept level that we're allowed to check for.
int GetInitiatorLevelup(object oPC, int nClass, int nLevelCap = 0)
{
	int nMartialAdept;
	int nNonMartial;
	int nCrusader = GetLevelByClass(CLASS_TYPE_CRUSADER, oPC);
	int nSaint = GetLevelByClass(CLASS_TYPE_SAINT, oPC);
	int nSwordsage = GetLevelByClass(CLASS_TYPE_SWORDSAGE, oPC);
	int nWarblade = GetLevelByClass(CLASS_TYPE_WARBLADE, oPC);

	if (nClass == CLASS_TYPE_CRUSADER)
	{
		nMartialAdept = nCrusader;
	}
	else if (nClass == CLASS_TYPE_SAINT)
	{
		nMartialAdept = nSaint;
	}
	else if (nClass == CLASS_TYPE_SWORDSAGE)
	{
		nMartialAdept = nSwordsage;
	}
	else if (nClass == CLASS_TYPE_WARBLADE)
	{
		nMartialAdept = nWarblade;
	}
	else // For Martial Study/Stance.
	{
		if (nCrusader > nSaint || nCrusader > nSwordsage || nCrusader > nWarblade)
		{
			nMartialAdept = nCrusader;
		}
		else if (nSaint > nCrusader || nSaint > nSwordsage || nSaint > nWarblade)
		{
			nMartialAdept = nSaint;
		}
		else if (nSwordsage > nCrusader || nSwordsage > nSaint || nSwordsage > nWarblade)
		{
			nMartialAdept = nSwordsage;
		}
		else if (nWarblade > nCrusader || nWarblade > nSaint || nWarblade > nSwordsage)
		{
			nMartialAdept = nWarblade;
		}
		else if (nCrusader > 0 || nSaint > 0 || nSwordsage > 0 || nWarblade > 0)
		{
			if (nCrusader == nSaint || nCrusader == nSwordsage || nCrusader == nWarblade)
			{
				nMartialAdept = nCrusader; // Fyi, purely an alphabetical preferance.
			}
			else if (nSaint == nSwordsage || nSaint == nWarblade)
			{
				nMartialAdept = nSaint;
			}
			else if (nSwordsage == nWarblade)
			{
				nMartialAdept = nSwordsage;
			}
			else nMartialAdept = 0;
		}
		else nMartialAdept = 0;
	}

	nNonMartial = ((GetHitDice(oPC) - nMartialAdept) / 2);

	if (nLevelCap > 0)
	{
		if (nMartialAdept > nLevelCap)
		{
			nMartialAdept = nLevelCap;
		}

		if (GetHitDice(oPC) > nLevelCap)
		{
			nNonMartial = ((nLevelCap - nMartialAdept) / 2);
		}
	}

	int nInitiator = nMartialAdept + nNonMartial;
	int nReturn;

	switch (nInitiator)
	{
		case 0: nReturn = 1;	break; // Minimum Initiator level.
		case 1:	nReturn = 1;	break;
		case 2:	nReturn = 1;	break;
		case 3:	nReturn = 2;	break;
		case 4:	nReturn = 2;	break;
		case 5:	nReturn = 3;	break;
		case 6:	nReturn = 3;	break;
		case 7:	nReturn = 4;	break;
		case 8:	nReturn = 4;	break;
		case 9:	nReturn = 5;	break;
		case 10:nReturn = 5;	break;
		case 11:nReturn = 6;	break;
		case 12:nReturn = 6;	break;
		case 13:nReturn = 7;	break;
		case 14:nReturn = 7;	break;
		case 15:nReturn = 8;	break;
		case 16:nReturn = 8;	break;
		default:nReturn = 9;	break;
	}

	return nReturn;
}

// Displays maneuvers that are chosen by the PC to gain on levelup.
void DisplayAddedManeuvers(object oPC, object oToB)
{
	string sScreen = "SCREEN_LEVELUP_MANEUVERS";
	string sListBox = "ADDED_MANEUVER_LIST";
	string sTexture, sPane, sVari, sTitle, sData, sTga;
	int nMax = GetNum2DARows("maneuvers");
	int nDW = GetLocalInt(oToB, "DWTotal");
	int nDS = GetLocalInt(oToB, "DSTotal");
	int nDM = GetLocalInt(oToB, "DMTotal");
	int nIH = GetLocalInt(oToB, "IHTotal");
	int nSS = GetLocalInt(oToB, "SSTotal");
	int nSH = GetLocalInt(oToB, "SHTotal");
	int nSD = GetLocalInt(oToB, "SDTotal");
	int nTC = GetLocalInt(oToB, "TCTotal");
	int nWR = GetLocalInt(oToB, "WRTotal");
	int nTitle, nIsStance, nMastery, nMasteryOf, nDiscipline, s, m, i;

	i = 1;

	while (i <= nMax)
	{
		sData = GetLocalString(oToB, "AddedManeuver" + IntToString(i));

		if (sData != "")
		{
			nMastery = tob_Get2daInt("maneuvers", "Mastery", i);
			nDiscipline = tob_Get2daInt("maneuvers", "Discipline", i);

			switch (nDiscipline)
			{
				case DESERT_WIND:	nMasteryOf = nDW;	break;
				case DEVOTED_SPIRIT:nMasteryOf = nDS;	break;
				case DIAMOND_MIND:	nMasteryOf = nDM;	break;
				case IRON_HEART:	nMasteryOf = nIH;	break;
				case SETTING_SUN:	nMasteryOf = nSS;	break;
				case SHADOW_HAND:	nMasteryOf = nSH;	break;
				case STONE_DRAGON:	nMasteryOf = nSD;	break;
				case TIGER_CLAW:	nMasteryOf = nTC;	break;
				case WHITE_RAVEN:	nMasteryOf = nWR;	break;
			}

			if ((nMasteryOf - 1) >= nMastery) //Maneuvers count for themselves so we need to subtract one to find the true count.
			{
				nIsStance = tob_Get2daInt("maneuvers", "IsStance", i);

				if (nIsStance == 1)
				{
					s++;
				}
				else m++;

				sTga = tob_Get2daString("maneuvers", "ICON", StringToInt(sData));
				nTitle = tob_Get2daInt("maneuvers", "StrRef", StringToInt(sData));
				sTitle = "MANEUVER_TEXT=" + GetStringByStrRef(nTitle);
				sTexture = "MANEUVER_IMAGE=" + sTga;
				sPane = "MANEUVERPANE_PROTO" + sData;
				sVari = "7=" + sData;

				AddListBoxRow(oPC, sScreen, sListBox, sPane, sTitle, sTexture + ".tga", sVari, "");
			}
			else // Weeds out maneuvers we no longer meet the prereqs for.
			{
				DeleteLocalString(oToB, "AddedManeuver" + IntToString(i));
				RemoveListBoxRow(oPC, sScreen, sListBox, "MANEUVERPANE_PROTO" + sData);
				PredictDisciplineStatus(nDiscipline, FALSE);
			}
		}
		i++;
	}

	int nNumber;
	int nLearn = GetLocalInt(oToB, "LevelupLearn");
	int nLearnStance = GetLocalInt(oToB, "LevelupStanceLearn");
	int nM = nLearn - m; // Possible to learn for the level minus the maneuvers that were flagged as added in the loop.
	int nS = nLearnStance - s; //Stances should never be more than one.

	SetLocalInt(oToB, "LevelupTotal", nM);
	SetLocalInt(oToB, "LevelupStance", nS);

	int nTotal = GetLocalInt(oToB, "LevelupTotal");
	int nStance = GetLocalInt(oToB, "LevelupStance");

	if (GetLocalInt(oToB, "CurrentLevelupLevel") == 0)
	{
		nNumber = nStance;
	}
	else nNumber = nTotal;

	SetGUIObjectText(oPC, "SCREEN_LEVELUP_MANEUVERS", "POINT_POOL_TEXT", -1, IntToString(nNumber));

	if ((nStance == 0) && (nTotal == 0))
	{
		SetGUIObjectDisabled(oPC, "SCREEN_LEVELUP_MANEUVERS", "CHOICE_NEXT", FALSE);
	}
	else SetGUIObjectDisabled(oPC, "SCREEN_LEVELUP_MANEUVERS", "CHOICE_NEXT", TRUE);
}

// Determines how many maneuvers a player should have without actually creating
// the items for them.  Used to determine which maneuvers a player can access.
// 1 = Initiate, 2 = Novice, 3 = Adept, 4 = Veteran, 5 or more = Master.
// -nDiscipline: Which discpline to add or subtract from.
// -bAddSubtract: Add or subtract from the total number of maneuvers of 
// nDiscipline.  Use TRUE to add and FALSE to subtract.
void PredictDisciplineStatus(int nDiscipline, int bAddSubtract)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nDW = GetLocalInt(oToB, "DWTotal");
	int nDS = GetLocalInt(oToB, "DSTotal");
	int nDM = GetLocalInt(oToB, "DMTotal");
	int nIH = GetLocalInt(oToB, "IHTotal");
	int nSS = GetLocalInt(oToB, "SSTotal");
	int nSH = GetLocalInt(oToB, "SHTotal");
	int nSD = GetLocalInt(oToB, "SDTotal");
	int nTC = GetLocalInt(oToB, "TCTotal");
	int nWR = GetLocalInt(oToB, "WRTotal");

	if (bAddSubtract == TRUE)
	{
		switch (nDiscipline)
		{
			case DESERT_WIND:	nDW += 1;	break;
			case DEVOTED_SPIRIT:nDS += 1;	break;
			case DIAMOND_MIND:	nDM += 1;	break;
			case IRON_HEART:	nIH += 1;	break;
			case SETTING_SUN:	nSS += 1;	break;
			case SHADOW_HAND:	nSH += 1;	break;
			case STONE_DRAGON:	nSD += 1;	break;
			case TIGER_CLAW:	nTC += 1;	break;
			case WHITE_RAVEN:	nWR += 1;	break;
		}
	}
	else if (bAddSubtract == FALSE)
	{
		switch (nDiscipline)
		{
			case DESERT_WIND:	nDW -= 1;	break;
			case DEVOTED_SPIRIT:nDS -= 1;	break;
			case DIAMOND_MIND:	nDM -= 1;	break;
			case IRON_HEART:	nIH -= 1;	break;
			case SETTING_SUN:	nSS -= 1;	break;
			case SHADOW_HAND:	nSH -= 1;	break;
			case STONE_DRAGON:	nSD -= 1;	break;
			case TIGER_CLAW:	nTC -= 1;	break;
			case WHITE_RAVEN:	nWR -= 1;	break;
		}
	}

	SetLocalInt(oToB, "DWTotal", nDW);
	SetLocalInt(oToB, "DSTotal", nDS);
	SetLocalInt(oToB, "DMTotal", nDM);
	SetLocalInt(oToB, "IHTotal", nIH);
	SetLocalInt(oToB, "SSTotal", nSS);
	SetLocalInt(oToB, "SHTotal", nSH);
	SetLocalInt(oToB, "SDTotal", nSD);
	SetLocalInt(oToB, "TCTotal", nTC);
	SetLocalInt(oToB, "WRTotal", nWR);
}

// Sets the PC's level of mastery based upon how many maneuvers of a certain
// discipline they have learned.  Used for determining prerequisites.
// 1 = Initiate, 2 = Novice, 3 = Adept, 4 = Veteran, 5 or more = Master.
void DetermineDisciplineStatus()
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oManeuver;
	int nManeuver, nDiscipline, nFeat;
	int nDW, nDS, nDM, nIH, nSS, nSH, nSD, nTC, nWR;

	oManeuver = GetFirstItemInInventory(oToB);

	while (GetIsObjectValid(oManeuver))
	{
		nManeuver = GetLocalInt(oManeuver, "2da");
		nDiscipline = tob_Get2daInt("maneuvers", "Discipline", nManeuver);

		switch (nDiscipline)
		{
			case DESERT_WIND:	nDW += 1;	break;
			case DEVOTED_SPIRIT:nDS += 1;	break;
			case DIAMOND_MIND:	nDM += 1;	break;
			case IRON_HEART:	nIH += 1;	break;
			case SETTING_SUN:	nSS += 1;	break;
			case SHADOW_HAND:	nSH += 1;	break;
			case STONE_DRAGON:	nSD += 1;	break;
			case TIGER_CLAW:	nTC += 1;	break;
			case WHITE_RAVEN:	nWR += 1;	break;
		}
		oManeuver = GetNextItemInInventory(oToB);
	}

	SetLocalInt(oToB, "DWTotal", nDW);
	SetLocalInt(oToB, "DSTotal", nDS);
	SetLocalInt(oToB, "DMTotal", nDM);
	SetLocalInt(oToB, "IHTotal", nIH);
	SetLocalInt(oToB, "SSTotal", nSS);
	SetLocalInt(oToB, "SHTotal", nSH);
	SetLocalInt(oToB, "SDTotal", nSD);
	SetLocalInt(oToB, "TCTotal", nTC);
	SetLocalInt(oToB, "WRTotal", nWR);

	// Add Maneuver Rank Feats
	if ((nDW > 0) && (!GetHasFeat(FEAT_DW_INITIATE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DW_INITIATE, TRUE);
	}

	if ((nDW > 1) && (!GetHasFeat(FEAT_DW_NOVICE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DW_NOVICE, TRUE);
	}

	if ((nDW > 2) && (!GetHasFeat(FEAT_DW_ADEPT, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DW_ADEPT, TRUE);
	}

	if ((nDW > 3) && (!GetHasFeat(FEAT_DW_VETERAN, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DW_VETERAN, TRUE);
	}

	if ((nDW > 4) && (!GetHasFeat(FEAT_DW_MASTER, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DW_MASTER, TRUE);
	}
	
	if ((nDS > 0) && (!GetHasFeat(FEAT_DS_INITIATE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DS_INITIATE, TRUE);
	}

	if ((nDS > 1) && (!GetHasFeat(FEAT_DS_NOVICE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DS_NOVICE, TRUE);
	}

	if ((nDS > 2) && (!GetHasFeat(FEAT_DS_ADEPT, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DS_ADEPT, TRUE);
	}

	if ((nDS > 3) && (!GetHasFeat(FEAT_DS_VETERAN, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DS_VETERAN, TRUE);
	}

	if ((nDS > 4) && (!GetHasFeat(FEAT_DS_MASTER, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DS_MASTER, TRUE);
	}
	
	if ((nDM > 0) && (!GetHasFeat(FEAT_DM_INITIATE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DM_INITIATE, TRUE);
	}

	if ((nDM > 1) && (!GetHasFeat(FEAT_DM_NOVICE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DM_NOVICE, TRUE);
	}

	if ((nDM > 2) && (!GetHasFeat(FEAT_DM_ADEPT, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DM_ADEPT, TRUE);
	}

	if ((nDM > 3) && (!GetHasFeat(FEAT_DM_VETERAN, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DM_VETERAN, TRUE);
	}

	if ((nDM> 4) && (!GetHasFeat(FEAT_DM_MASTER, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DM_MASTER, TRUE);
	}
	
	if ((nIH > 0) && (!GetHasFeat(FEAT_IH_INITIATE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_IH_INITIATE, TRUE);
	}

	if ((nIH > 1) && (!GetHasFeat(FEAT_IH_NOVICE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_IH_NOVICE, TRUE);
	}

	if ((nIH > 2) && (!GetHasFeat(FEAT_IH_ADEPT, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_IH_ADEPT, TRUE);
	}

	if ((nIH > 3) && (!GetHasFeat(FEAT_IH_VETERAN, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_IH_VETERAN, TRUE);
	}

	if ((nIH > 4) && (!GetHasFeat(FEAT_IH_MASTER, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_IH_MASTER, TRUE);
	}
	
	if ((nSS > 0) && (!GetHasFeat(FEAT_SS_INITIATE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SS_INITIATE, TRUE);
	}

	if ((nSS > 1) && (!GetHasFeat(FEAT_SS_NOVICE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SS_NOVICE, TRUE);
	}

	if ((nSS > 2) && (!GetHasFeat(FEAT_SS_ADEPT, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SS_ADEPT, TRUE);
	}

	if ((nSS > 3) && (!GetHasFeat(FEAT_SS_VETERAN, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SS_VETERAN, TRUE);
	}

	if ((nSS > 4) && (!GetHasFeat(FEAT_SS_MASTER, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SS_MASTER, TRUE);
	}
	
	if ((nSH > 0) && (!GetHasFeat(FEAT_SH_INITIATE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SH_INITIATE, TRUE);
	}

	if ((nSH > 1) && (!GetHasFeat(FEAT_SH_NOVICE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SH_NOVICE, TRUE);
	}

	if ((nSH > 2) && (!GetHasFeat(FEAT_SH_ADEPT, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SH_ADEPT, TRUE);
	}

	if ((nSH > 3) && (!GetHasFeat(FEAT_SH_VETERAN, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SH_VETERAN, TRUE);
	}

	if ((nSH > 4) && (!GetHasFeat(FEAT_SH_MASTER, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SH_MASTER, TRUE);
	}
	
	if ((nSD > 0) && (!GetHasFeat(FEAT_SD_INITIATE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SD_INITIATE, TRUE);
	}

	if ((nSD > 1) && (!GetHasFeat(FEAT_SD_NOVICE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SD_NOVICE, TRUE);
	}

	if ((nSD > 2) && (!GetHasFeat(FEAT_SD_ADEPT, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SD_ADEPT, TRUE);
	}

	if ((nSD > 3) && (!GetHasFeat(FEAT_SD_VETERAN, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SD_VETERAN, TRUE);
	}

	if ((nSD > 4) && (!GetHasFeat(FEAT_SD_MASTER, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SD_MASTER, TRUE);
	}
	
	if ((nTC > 0) && (!GetHasFeat(FEAT_TC_INITIATE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_TC_INITIATE, TRUE);
	}

	if ((nTC > 1) && (!GetHasFeat(FEAT_TC_NOVICE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_TC_NOVICE, TRUE);
	}

	if ((nTC > 2) && (!GetHasFeat(FEAT_TC_ADEPT, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_TC_ADEPT, TRUE);
	}

	if ((nTC > 3) && (!GetHasFeat(FEAT_TC_VETERAN, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_TC_VETERAN, TRUE);
	}

	if ((nTC > 4) && (!GetHasFeat(FEAT_TC_MASTER, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_TC_MASTER, TRUE);
	}
	
	if ((nWR > 0) && (!GetHasFeat(FEAT_WR_INITIATE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_WR_INITIATE, TRUE);
	}

	if ((nWR > 1) && (!GetHasFeat(FEAT_WR_NOVICE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_WR_NOVICE, TRUE);
	}

	if ((nWR > 2) && (!GetHasFeat(FEAT_WR_ADEPT, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_WR_ADEPT, TRUE);
	}

	if ((nWR > 3) && (!GetHasFeat(FEAT_WR_VETERAN, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_WR_VETERAN, TRUE);
	}

	if ((nWR > 4) && (!GetHasFeat(FEAT_WR_MASTER, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_WR_MASTER, TRUE);
	}

	// Remove Maneuver Rank Feats
	if ((nDW < 5) && (GetHasFeat(FEAT_DW_MASTER, oPC)))
	{
		FeatRemove(oPC, FEAT_DW_MASTER);
	}

	if ((nDW < 4) && (GetHasFeat(FEAT_DW_VETERAN, oPC)))
	{
		FeatRemove(oPC, FEAT_DW_VETERAN);
	}

	if ((nDW < 3) && (GetHasFeat(FEAT_DW_ADEPT, oPC)))
	{
		FeatRemove(oPC, FEAT_DW_ADEPT);
	}

	if ((nDW < 2) && (GetHasFeat(FEAT_DW_NOVICE, oPC)))
	{
		FeatRemove(oPC, FEAT_DW_NOVICE);
	}

	if ((nDW < 1) && (GetHasFeat(FEAT_DW_INITIATE, oPC)))
	{
		FeatRemove(oPC, FEAT_DW_INITIATE);
	}

	if ((nDS < 5) && (GetHasFeat(FEAT_DS_MASTER, oPC)))
	{
		FeatRemove(oPC, FEAT_DS_MASTER);
	}

	if ((nDS < 4) && (GetHasFeat(FEAT_DS_VETERAN, oPC)))
	{
		FeatRemove(oPC, FEAT_DS_VETERAN);
	}
	
	if ((nDS < 3) && (GetHasFeat(FEAT_DS_ADEPT, oPC)))
	{
		FeatRemove(oPC, FEAT_DS_ADEPT);
	}
	
	if ((nDS < 2) && (GetHasFeat(FEAT_DS_NOVICE, oPC)))
	{
		FeatRemove(oPC, FEAT_DS_NOVICE);
	}
	
	if ((nDS < 1) && (GetHasFeat(FEAT_DS_INITIATE, oPC)))
	{
		FeatRemove(oPC, FEAT_DS_INITIATE);
	}

	if ((nDM < 5) && (GetHasFeat(FEAT_DM_MASTER, oPC)))
	{
		FeatRemove(oPC, FEAT_DM_MASTER);
	}
	
	if ((nDM < 4) && (GetHasFeat(FEAT_DM_VETERAN, oPC)))
	{
		FeatRemove(oPC, FEAT_DM_VETERAN);
	}
	
	if ((nDM < 3) && (GetHasFeat(FEAT_DM_ADEPT, oPC)))
	{
		FeatRemove(oPC, FEAT_DM_ADEPT);
	}
	
	if ((nDM < 2) && (GetHasFeat(FEAT_DM_NOVICE, oPC)))
	{
		FeatRemove(oPC, FEAT_DM_NOVICE);
	}
	
	if ((nDM < 1) && (GetHasFeat(FEAT_DM_INITIATE, oPC)))
	{
		FeatRemove(oPC, FEAT_DM_INITIATE);
	}

	if ((nIH < 5) && (GetHasFeat(FEAT_IH_MASTER, oPC)))
	{
		FeatRemove(oPC, FEAT_IH_MASTER);
	}

	if ((nIH < 4) && (GetHasFeat(FEAT_IH_VETERAN, oPC)))
	{
		FeatRemove(oPC, FEAT_IH_VETERAN);
	}

	if ((nIH < 3) && (GetHasFeat(FEAT_IH_ADEPT, oPC)))
	{
		FeatRemove(oPC, FEAT_IH_ADEPT);
	}

	if ((nIH < 2) && (GetHasFeat(FEAT_IH_NOVICE, oPC)))
	{
		FeatRemove(oPC, FEAT_IH_NOVICE);
	}

	if ((nIH < 1) && (GetHasFeat(FEAT_IH_INITIATE, oPC)))
	{
		FeatRemove(oPC, FEAT_IH_INITIATE);
	}

	if ((nSS < 5) && (GetHasFeat(FEAT_SS_MASTER, oPC)))
	{
		FeatRemove(oPC, FEAT_SS_MASTER);
	}

	if ((nSS < 4) && (GetHasFeat(FEAT_SS_VETERAN, oPC)))
	{
		FeatRemove(oPC, FEAT_SS_VETERAN);
	}

	if ((nSS < 3) && (GetHasFeat(FEAT_SS_ADEPT, oPC)))
	{
		FeatRemove(oPC, FEAT_SS_ADEPT);
	}

	if ((nSS < 2) && (GetHasFeat(FEAT_SS_NOVICE, oPC)))
	{
		FeatRemove(oPC, FEAT_SS_NOVICE);
	}

	if ((nSS < 1) && (GetHasFeat(FEAT_SS_INITIATE, oPC)))
	{
		FeatRemove(oPC, FEAT_SS_INITIATE);
	}

	if ((nSH < 5) && (GetHasFeat(FEAT_SH_MASTER, oPC)))
	{
		FeatRemove(oPC, FEAT_SH_MASTER);
	}

	if ((nSH < 4) && (GetHasFeat(FEAT_SH_VETERAN, oPC)))
	{
		FeatRemove(oPC, FEAT_SH_VETERAN);
	}

	if ((nSH < 3) && (GetHasFeat(FEAT_SH_ADEPT, oPC)))
	{
		FeatRemove(oPC, FEAT_SH_ADEPT);
	}

	if ((nSH < 2) && (GetHasFeat(FEAT_SH_NOVICE, oPC)))
	{
		FeatRemove(oPC, FEAT_SH_NOVICE);
	}

	if ((nSH < 1) && (GetHasFeat(FEAT_SH_INITIATE, oPC)))
	{
		FeatRemove(oPC, FEAT_SH_INITIATE);
	}

	if ((nSD < 5) && (GetHasFeat(FEAT_SD_MASTER, oPC)))
	{
		FeatRemove(oPC, FEAT_SD_MASTER);
	}

	if ((nSD < 4) && (GetHasFeat(FEAT_SD_VETERAN, oPC)))
	{
		FeatRemove(oPC, FEAT_SD_VETERAN);
	}

	if ((nSD < 3) && (GetHasFeat(FEAT_SD_ADEPT, oPC)))
	{
		FeatRemove(oPC, FEAT_SD_ADEPT);
	}

	if ((nSD < 2) && (GetHasFeat(FEAT_SD_NOVICE, oPC)))
	{
		FeatRemove(oPC, FEAT_SD_NOVICE);
	}

	if ((nSD < 1) && (GetHasFeat(FEAT_SD_INITIATE, oPC)))
	{
		FeatRemove(oPC, FEAT_SD_INITIATE);
	}

	if ((nTC < 5) && (GetHasFeat(FEAT_TC_MASTER, oPC)))
	{
		FeatRemove(oPC, FEAT_TC_MASTER);
	}

	if ((nTC < 4) && (GetHasFeat(FEAT_TC_VETERAN, oPC)))
	{
		FeatRemove(oPC, FEAT_TC_VETERAN);
	}

	if ((nTC < 3) && (GetHasFeat(FEAT_TC_ADEPT, oPC)))
	{
		FeatRemove(oPC, FEAT_TC_ADEPT);
	}

	if ((nTC < 2) && (GetHasFeat(FEAT_TC_NOVICE, oPC)))
	{
		FeatRemove(oPC, FEAT_TC_NOVICE);
	}

	if ((nTC < 1) && (GetHasFeat(FEAT_TC_INITIATE, oPC)))
	{
		FeatRemove(oPC, FEAT_TC_INITIATE);
	}

	if ((nWR < 5) && (GetHasFeat(FEAT_WR_MASTER, oPC)))
	{
		FeatRemove(oPC, FEAT_WR_MASTER);
	}

	if ((nWR < 4) && (GetHasFeat(FEAT_WR_VETERAN, oPC)))
	{
		FeatRemove(oPC, FEAT_WR_VETERAN);
	}

	if ((nWR < 3) && (GetHasFeat(FEAT_WR_ADEPT, oPC)))
	{
		FeatRemove(oPC, FEAT_WR_ADEPT);
	}

	if ((nWR < 2) && (GetHasFeat(FEAT_WR_NOVICE, oPC)))
	{
		FeatRemove(oPC, FEAT_WR_NOVICE);
	}

	if ((nWR < 1) && (GetHasFeat(FEAT_WR_INITIATE, oPC)))
	{
		FeatRemove(oPC, FEAT_WR_INITIATE);
	}
}

// Used to only open the levelup xmls when all of the screen's data has been loaded.
void EnforceDataOpening(object oPC, object oToB)
{
	if ((GetLocalInt(oToB, "GUIOpeningSafe") == 1) && (GetLocalInt(oToB, "ManeuversCreated") == 0))
	{
		DisplayGuiScreen(oPC, "SCREEN_LEVELUP_MANEUVERS", TRUE, "levelup_maneuvers.xml");
	}
	else DelayCommand(0.5f, EnforceDataOpening(oPC, oToB));
}

// Creates a list of the PC's Known Maneuvers.
void GenerateKnownManeuvers(object oPC, object oToB)
{
	string sScreen = "SCREEN_LEVELUP_MANEUVERS";
	string sList = "RETRAIN_MANEUVER_LIST";
	string sPane = "MANEUVERPANE_PROTO";
	string sText, sTextures, sVari, sTga;
	object oManeuver;
	int nManeuver, nClass, nStrRef, nIsStance, nLevel;
	int i;

	oManeuver = GetFirstItemInInventory(oToB);

	while (GetIsObjectValid(oManeuver))
	{
		nManeuver = GetLocalInt(oManeuver, "2da");
		nClass = GetLocalInt(oManeuver, "Class");
		nIsStance = tob_Get2daInt("maneuvers", "IsStance", nManeuver);
		nLevel = tob_Get2daInt("maneuvers", "Level", nManeuver);

		if ((GetLocalInt(oToB, "LevelupRetrain") > 0) && (nIsStance == 0) && (nClass != 255) && (nLevel != 0) && (nManeuver != 0))
		{
			sTga = tob_Get2daString("maneuvers", "ICON", nManeuver);
			nStrRef = tob_Get2daInt("maneuvers", "StrRef", nManeuver);
			sTextures = "MANEUVER_IMAGE=" + sTga + ".tga";
			sText = "MANEUVER_TEXT=" + GetStringByStrRef(nStrRef);
			sVari = "7=" + IntToString(nManeuver);

			AddListBoxRow(oPC, sScreen, sList, sPane + IntToString(nManeuver), sText, sTextures, sVari, "");
		}

		oManeuver = GetNextItemInInventory(oToB);
	}

	SetLocalInt(oToB, "GUIOpeningSafe", 1);
	DelayCommand(6.0f, DeleteLocalInt(oToB, "GUIOpeningSafe"));
}

// Runs data needed by the Levelup screen before it opens.
// -nClass: Class constant of the class that is leveling.
// -nLearn: Number of maneuvers available to learn this level.
// -nRetrain: Number of maneuvers available to be retrained this level, typically
// at 4th and every even numbered level thereafter.
// -nStance: Number of stances available to learn this level.
// -nLevelcap: Level of the class that is being leveled.  Implemented to avoid
// abuse of the levelup system when a character is autoleveled or similar.
void LoadLevelup(object oPC, object oToB, int nClass, int nLearn, int nRetrain, int nStance, int nLevelCap)
{
	SetPause(FALSE);

	SetLocalInt(oToB, "LevelupClass", nClass);
	SetLocalInt(oToB, "LevelupLearn", nLearn); //Top number we can learn this level.
	SetLocalInt(oToB, "LevelupTotal", nLearn); //Total remaining to learn.
	SetLocalInt(oToB, "LevelupRetrain", nRetrain);
	SetLocalInt(oToB, "LevelupStanceLearn", nStance); //Top number we can learn this level.
	SetLocalInt(oToB, "LevelupStance", nStance);
	SetLocalInt(oToB, "LevelupCap", nLevelCap);
	GenerateKnownManeuvers(oPC, oToB);
	EnforceDataOpening(oPC, oToB);

	if (nLearn > 0 || nStance > 0)
	{
		DelayCommand(0.1f, SetGUIObjectDisabled(oPC, "SCREEN_LEVELUP_MANEUVERS", "CHOICE_NEXT", TRUE));
	}

	if (GetLocalInt(oToB, "CurrentLevelupLevel") == 0)
	{
		DelayCommand(0.1f, SetGUIObjectText(oPC, "SCREEN_LEVELUP_MANEUVERS", "POINT_POOL_TEXT", -1, IntToString(nStance)));
	}
	else DelayCommand(0.1f, SetGUIObjectText(oPC, "SCREEN_LEVELUP_MANEUVERS", "POINT_POOL_TEXT", -1, IntToString(nLearn)));

	DelayCommand(0.1f, SetGUIObjectText(oPC, "SCREEN_LEVELUP_MANEUVERS", "RETRAIN_POOL_TEXT", -1, IntToString(nRetrain)));
}

// Adds a Listbox to the maneuver selection screen.
// -nManeuver: Current number of the maneuver's listboxe, added to the maneuver selection screen.
void AddManeuver(object oPC, int nManeuver)
{
	if (nManeuver == 0)
	{
		return; //Sanity Check.
	}

	int nStrRef = tob_Get2daInt("maneuvers", "StrRef", nManeuver);
	string sScreen = "SCREEN_LEVELUP_MANEUVERS";
	string sList = "AVAILABLE_MANEUVER_LIST";
	string sPane = "MANEUVERPANE_PROTO";
	string sTga = tob_Get2daString("maneuvers", "ICON", nManeuver);
	string sTextures = "MANEUVER_IMAGE=" + sTga + ".tga";
	string sText = "MANEUVER_TEXT=" + GetStringByStrRef(nStrRef);
	string sVari = "7=" + IntToString(nManeuver);

	AddListBoxRow(oPC, sScreen, sList, sPane + IntToString(nManeuver), sText, sTextures, sVari, "");
}

// Filters which maneuvers can be displayed and adds them.  Returns the value of the last maneuver checked.
// -nLevel: Initiator level of the maneuvers to display.
// -nClass: Determines which maneuvers are availible to this class.
// -nInitLevel: Maximum initiator level allowed to generate maneuvers for.
int GenerateManeuvers(object oPC, object oToB, int nLevel, int nClass, int n, int nFinish, int nInitLevel)
{
	if ((nLevel != 0) && (nLevel > nInitLevel)) //Don't run it if we don't need to.
	{
		return nFinish;
	}

	int nDW = GetLocalInt(oToB, "DWTotal");
	int nDS = GetLocalInt(oToB, "DSTotal");
	int nDM = GetLocalInt(oToB, "DMTotal");
	int nIH = GetLocalInt(oToB, "IHTotal");
	int nSS = GetLocalInt(oToB, "SSTotal");
	int nSH = GetLocalInt(oToB, "SHTotal");
	int nSD = GetLocalInt(oToB, "SDTotal");
	int nTC = GetLocalInt(oToB, "TCTotal");
	int nWR = GetLocalInt(oToB, "WRTotal");
	int nRetrain = GetLocalInt(oToB, "RetrainManeuver");
	int nIsStance, nDiscipline, nLevelOf, nMastery, nMasteryOf, nSpecial, nValid;
	string sScript, sAdded;
	object oManeuver;

	while (n <= nFinish)
	{
		nValid = 0;
		sScript = tob_Get2daString("maneuvers", "Script", n);
		sAdded = GetLocalString(oToB, "AddedManeuver" + IntToString(n));
		oManeuver = GetObjectByTag(GetFirstName(oPC) + sScript);

		if ((nRetrain == n) && (StringToInt(sAdded) != n))
		{
			nValid = 1;
		}
		else if ((!GetIsObjectValid(oManeuver)) && (StringToInt(sAdded) != n))
		{
			nValid = 1;
		}

		if (nValid == 1) //Filter what we know or are learning.
		{
			if (nClass == CLASS_TYPE_CRUSADER)
			{
				nDiscipline = tob_Get2daInt("maneuvers", "Discipline", n);
	
				if (nDiscipline == DEVOTED_SPIRIT || nDiscipline == STONE_DRAGON || nDiscipline == WHITE_RAVEN)
				{
					switch (nDiscipline)
					{
						case DEVOTED_SPIRIT:	nMasteryOf = nDS;	break;
						case STONE_DRAGON:		nMasteryOf = nSD;	break;
						case WHITE_RAVEN:		nMasteryOf = nWR;	break;
					}
	
					nLevelOf = tob_Get2daInt("maneuvers", "Level", n);
					nIsStance = tob_Get2daInt("maneuvers", "IsStance", n);
					nMastery = tob_Get2daInt("maneuvers", "Mastery", n);
	
					if (nLevel == 0) //Stances
					{
						nMastery = tob_Get2daInt("maneuvers", "Mastery", n);
	
						if ((nIsStance == 1) && (nLevelOf <= nInitLevel) && (nMasteryOf >= nMastery))
						{
							AddManeuver(oPC, n);
						}
					}
					else if (nLevel == nLevelOf)
					{
						//Special Cases
						if ((n == STRIKE_DOOM_CHARGE) && (GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL))
						{
							nSpecial = 1;
						}
						else if ((n == STRIKE_LAW_BEARER) && (GetAlignmentLawChaos(oPC) != ALIGNMENT_LAWFUL))
						{
							nSpecial = 1;
						}
						else if ((n == STRIKE_RADIANT_CHARGE) && (GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD))
						{
							nSpecial = 1;
						}
						else if ((n == STRIKE_TIDE_OF_CHAOS) && (GetAlignmentLawChaos(oPC) != ALIGNMENT_CHAOTIC))
						{
							nSpecial = 1;
						}
	
						if ((nMasteryOf >= nMastery) && (nIsStance != 1) && (nSpecial == 0))
						{
							AddManeuver(oPC, n);
						}
					}
				}
			}
			else if (nClass == CLASS_TYPE_SAINT)
			{
				nDiscipline = tob_Get2daInt("maneuvers", "Discipline", n);
	
				if (nDiscipline == DEVOTED_SPIRIT || nDiscipline == SHADOW_HAND)
				{
					switch (nDiscipline)
					{
						case DEVOTED_SPIRIT:	nMasteryOf = nDS;	break;
						case SHADOW_HAND:		nMasteryOf = nSH;	break;
					}
	
					nLevelOf = tob_Get2daInt("maneuvers", "Level", n);
					nIsStance = tob_Get2daInt("maneuvers", "IsStance", n);
					nMastery = tob_Get2daInt("maneuvers", "Mastery", n);
	
					if (nLevel == 0) //Stances
					{
						nMastery = tob_Get2daInt("maneuvers", "Mastery", n);
	
						if ((nIsStance == 1) && (nLevelOf <= nInitLevel) && (nMasteryOf >= nMastery))
						{
							AddManeuver(oPC, n);
						}
					}
					else if (nLevel == nLevelOf)
					{
						//Special Cases
						if ((n == STRIKE_DOOM_CHARGE) && (GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL))
						{
							nSpecial = 1;
						}
						else if ((n == STRIKE_LAW_BEARER) && (GetAlignmentLawChaos(oPC) != ALIGNMENT_LAWFUL))
						{
							nSpecial = 1;
						}
						else if ((n == STRIKE_RADIANT_CHARGE) && (GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD))
						{
							nSpecial = 1;
						}
						else if ((n == STRIKE_TIDE_OF_CHAOS) && (GetAlignmentLawChaos(oPC) != ALIGNMENT_CHAOTIC))
						{
							nSpecial = 1;
						}
	
						if ((nMasteryOf >= nMastery) && (nIsStance != 1) && (nSpecial == 0))
						{
							AddManeuver(oPC, n);
						}
					}
				}
			}
			else if (nClass == CLASS_TYPE_SWORDSAGE)
			{
				nDiscipline = tob_Get2daInt("maneuvers", "Discipline", n);
	
				if (nDiscipline == DESERT_WIND || nDiscipline == DIAMOND_MIND || nDiscipline == SETTING_SUN
				|| nDiscipline == SHADOW_HAND || nDiscipline == STONE_DRAGON || nDiscipline == TIGER_CLAW)
				{
					switch (nDiscipline)
					{
						case DESERT_WIND:		nMasteryOf = nDW;	break;
						case DIAMOND_MIND:		nMasteryOf = nDM;	break;
						case SETTING_SUN:		nMasteryOf = nSS;	break;
						case SHADOW_HAND:		nMasteryOf = nSH;	break;
						case STONE_DRAGON:		nMasteryOf = nSD;	break;
						case TIGER_CLAW:		nMasteryOf = nTC;	break;
					}
	
					nLevelOf = tob_Get2daInt("maneuvers", "Level", n);
					nIsStance = tob_Get2daInt("maneuvers", "IsStance", n);
					nMastery = tob_Get2daInt("maneuvers", "Mastery", n);
	
					if (nLevel == 0) //Stances
					{
						// Special Cases
						if ((n == STANCE_HUNTERS_SENSE) && (GetHasFeat(FEAT_SCENT, oPC)))
						{
							nSpecial = 1;
						}
						else if ((n == STANCE_HEARING_THE_AIR) && (GetHasFeat(FEAT_KEEN_SENSE, oPC)))
						{
							nSpecial = 1;
						}

						nMastery = tob_Get2daInt("maneuvers", "Mastery", n);
	
						if ((nIsStance == 1) && (nLevelOf <= nInitLevel) && (nMasteryOf >= nMastery) && (nSpecial == 0))
						{
							AddManeuver(oPC, n);
						}
					}
					else if (nLevel == nLevelOf)
					{
						if ((nMasteryOf >= nMastery) && (nIsStance != 1))
						{
							AddManeuver(oPC, n);
						}
					}
				}
			}
			else if (nClass == CLASS_TYPE_WARBLADE)
			{
				nDiscipline = tob_Get2daInt("maneuvers", "Discipline", n);
	
				if (nDiscipline == DIAMOND_MIND || nDiscipline == IRON_HEART || nDiscipline == STONE_DRAGON
				|| nDiscipline == TIGER_CLAW || nDiscipline == WHITE_RAVEN)
				{
					switch (nDiscipline)
					{
						case DIAMOND_MIND:		nMasteryOf = nDM;	break;
						case IRON_HEART:		nMasteryOf = nIH;	break;
						case STONE_DRAGON:		nMasteryOf = nSD;	break;
						case TIGER_CLAW:		nMasteryOf = nTC;	break;
						case WHITE_RAVEN:		nMasteryOf = nWR;	break;
					}
	
					nLevelOf = tob_Get2daInt("maneuvers", "Level", n);
					nIsStance = tob_Get2daInt("maneuvers", "IsStance", n);
					nMastery = tob_Get2daInt("maneuvers", "Mastery", n);
	
					if (nLevel == 0) //Stances
					{
						// Special Cases
						if ((n == STANCE_HUNTERS_SENSE) && (GetHasFeat(FEAT_SCENT, oPC)))
						{
							nSpecial = 1;
						}
						else if ((n == STANCE_HEARING_THE_AIR) && (GetHasFeat(FEAT_KEEN_SENSE, oPC)))
						{
							nSpecial = 1;
						}

						nMastery = tob_Get2daInt("maneuvers", "Mastery", n);
	
						if ((nIsStance == 1) && (nLevelOf <= nInitLevel) && (nMasteryOf >= nMastery) && (nSpecial == 0))
						{
							AddManeuver(oPC, n);
						}
					}
					else if (nLevel == nLevelOf)
					{
						if ((nMasteryOf >= nMastery) && (nIsStance != 1))
						{
							AddManeuver(oPC, n);
						}
					}
				}
			}
			else // Martial Stance/Study
			{
				nDiscipline = tob_Get2daInt("maneuvers", "Discipline", n);
	
				switch (nDiscipline)
				{
					case DESERT_WIND:		nMasteryOf = nDW;	break;
					case DEVOTED_SPIRIT:	nMasteryOf = nDS;	break;
					case DIAMOND_MIND:		nMasteryOf = nDM;	break;
					case IRON_HEART:		nMasteryOf = nIH;	break;
					case SETTING_SUN:		nMasteryOf = nIH;	break;
					case SHADOW_HAND:		nMasteryOf = nIH;	break;
					case STONE_DRAGON:		nMasteryOf = nIH;	break;
					case TIGER_CLAW:		nMasteryOf = nTC;	break;
					case WHITE_RAVEN:		nMasteryOf = nWR;	break;
				}
	
				nLevelOf = tob_Get2daInt("maneuvers", "Level", n);
				nIsStance = tob_Get2daInt("maneuvers", "IsStance", n);
				nMastery = tob_Get2daInt("maneuvers", "Mastery", n);
	
				if (nLevel == 0) //Stances
				{
					if (nMasteryOf == 0)
					{
						nMasteryOf = 1; // Martial Study requires the player to know at least one maneuver of the discipline.
					}
	
					// Special Cases
					if ((n == STANCE_HUNTERS_SENSE) && (GetHasFeat(FEAT_SCENT, oPC)))
					{
						nSpecial = 1;
					}
					else if ((n == STANCE_HEARING_THE_AIR) && (GetHasFeat(FEAT_KEEN_SENSE, oPC)))
					{
						nSpecial = 1;
					}

					nMastery = tob_Get2daInt("maneuvers", "Mastery", n);
	
					if ((nIsStance == 1) && (nLevelOf <= nInitLevel) && (nMasteryOf >= nMastery) && (nSpecial == 0))
					{
						AddManeuver(oPC, n);
					}
				}
				else if (nLevel == nLevelOf)
				{
					//Special Cases
					if ((n == STRIKE_DOOM_CHARGE) && (GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL))
					{
						nSpecial = 1;
					}
					else if ((n == STRIKE_LAW_BEARER) && (GetAlignmentLawChaos(oPC) != ALIGNMENT_LAWFUL))
					{
						nSpecial = 1;
					}
					else if ((n == STRIKE_RADIANT_CHARGE) && (GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD))
					{
						nSpecial = 1;
					}
					else if ((n == STRIKE_TIDE_OF_CHAOS) && (GetAlignmentLawChaos(oPC) != ALIGNMENT_CHAOTIC))
					{
						nSpecial = 1;
					}

					if ((nMasteryOf >= nMastery) && (nIsStance != 1) && (nSpecial == 0))
					{
						AddManeuver(oPC, n);
					}
				}
			}
		}

		n++;
	}

	return n;
}

// Displays the maneuvers the PC can learn for the class they are leveling in.
// All stances are under level 0.
// -nLevel: Initiator level of the maneuvers to display.
// -nClass: Determines which maneuvers are availible to this class.
// -nInitLevel: Maximum initiator level allowed to generate maneuvers for.
void DisplayManeuversByClass(object oPC, object oToB, int nStart, int nFinish, int nLevel, int nClass, int nInitLevel)
{
	int nLimit = GetNum2DARows("maneuvers");
	int i = GenerateManeuvers(oPC, oToB, nLevel, nClass, nStart, nFinish, nInitLevel);

	if (i < nLimit) // The 2da hasn't been entirely run through yet, so we're picking up where we left off to avoid TMI.
	{
		if (nFinish + 50 > nLimit)
		{
			nFinish = nLimit;
		}
		else nFinish = nFinish + 50;

		DelayCommand(0.01f, DisplayManeuversByClass(oPC, oToB, i, nFinish, nLevel, nClass, nInitLevel));
	}
}

// !EXPERIMENTAL!
// Finds the Tome of Battle object on the player and curses it (and its contents) if it isn't already.
// This has been implemented to deal with reports of the releveling proceddures failing in Mask of the Betrayer.
object GetTomeOfBattle(object oPC)
{
	object oCheck, oToB;
	string sTag;

	oToB = OBJECT_INVALID;
	oCheck = GetFirstItemInInventory(oPC);

	while (GetIsObjectValid(oCheck))
	{
		sTag = GetResRef(oCheck); //Tags can change, resref doesn't

		if (sTag == "tob")
		{
			oToB = oCheck;

			if (!GetItemCursedFlag(oToB))
			{
				SetItemCursedFlag(oToB, TRUE);
			}

			break;
		}

		oCheck = GetNextItemInInventory(oPC);
	}

	if (GetIsObjectValid(oToB))
	{
		object oManeuver;

		oManeuver = GetFirstItemInInventory(oToB);

		while (GetIsObjectValid(oManeuver))
		{
			if (!GetItemCursedFlag(oManeuver))
			{
				SetItemCursedFlag(oManeuver, TRUE);
			}

			oManeuver = GetNextItemInInventory(oToB);
		}
	}

	return oToB;
}