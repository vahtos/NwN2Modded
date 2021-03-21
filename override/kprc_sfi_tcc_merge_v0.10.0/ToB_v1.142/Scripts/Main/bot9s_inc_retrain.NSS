//////////////////////////////////////////////////////////////////////
//	Author: Drammel													//
//	Date: 6/9/2009													//
//	Title: bot9s_inc_retrain										//
//	Description: Script library for feat retraining functions.		//
//////////////////////////////////////////////////////////////////////

#include "bot9s_inc_2da"
#include "bot9s_inc_constants"

// Prototypes

// Creates a list of feats that the PC knows.
// Must be broken into several parts to avoid a TMI error.
int AddKnownFeats(object oPC, object oToB, int nStart, int nFinish);

// Runs the above function for the entire feat.2da listing.
void AddAllKnownFeats(object oPC, object oToB, int nStart, int nFinish);

// Filters which feats should be added and which should not.
int CheckFeat(int i, object oPC, object oToB);

// Displays the feats that the PC qualifies for and does not already know.
// Again, this is a setup for the big TMI prevention function.
int GetAvailableFeats(int i, int nFinish, object oPC, object oToB);

// Runs the above function in segments to avoid TMI errors.
void GetAllAvailableFeats(object oPC, object oToB, int nStart, int nFinish);

// Displays discplines for the Insightful Strike: Weapon Focus menu.
void DisplaySSInsightfulStrike(object oPC, object oToB);

// Adds Feats pending to be switched for the feats the PC is retraining to the 
// Added Feats window.
void DisplayAddedFeats(object oPC, object oToB);

// Functions

// Creates a list of feats that the PC knows.
// Must be broken into several parts to avoid a TMI error.
int AddKnownFeats(object oPC, object oToB, int nStart, int nFinish)
{
	string sScreen = "SCREEN_LEVELUP_RETRAIN_FEATS";
	string sPane = "RETRAINPANE_PROTO";
	int i, nFSWpnFocus, nFSWeaponSpec, nForbidden, nForbidden1, nForbidden2, nForbidden3, nForbidden4, nForbidden5, nForbidden6;
	string sFeatType, sIcon, sName, sVari;

	if (GetLocalInt(oToB, "HaltRetrainFeats") == 1) // Kill the loops if we just want to finish leveling.
	{
		return 0;
	}

	// Favored Soul Weapon Proficeny is granted as a bonus feat and if it is
	// removed is granted again on each levelup it isn't present.  A check must
	// be used to prevent the class from granting free feats.
	if (GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oPC) > 0)
	{
		string sGod = GetDeity(oPC);
		string sCheck;
		int nSeraph;

		nSeraph = 1;
		sCheck = tob_Get2daString("nwn2_deities", "FirstName", nSeraph);

		while (sCheck != "")
		{
			if (sGod == sCheck)
			{
				nFSWpnFocus = tob_Get2daInt("nwn2_deities", "FavoredWeaponFocus", nSeraph);
				nFSWeaponSpec = tob_Get2daInt("nwn2_deities", "FavoredWeaponSpecialization", nSeraph);
				break;
			}

			nSeraph++;
			sCheck = tob_Get2daString("nwn2_deities", "FirstName", nSeraph);
		}
	}

	i = nStart;

	while (i < nFinish)
	{
		nForbidden = 0;
		nForbidden1 = GetLocalInt(oToB, "ForbiddenRetrain1");
		nForbidden2 = GetLocalInt(oToB, "ForbiddenRetrain2");
		nForbidden3 = GetLocalInt(oToB, "ForbiddenRetrain3");
		nForbidden4 = GetLocalInt(oToB, "ForbiddenRetrain4");
		nForbidden5 = GetLocalInt(oToB, "ForbiddenRetrain5");
		nForbidden6 = GetLocalInt(oToB, "ForbiddenRetrain6");

		if (i == nForbidden1)
		{
			nForbidden = 1;
		}

		if ((i == nForbidden2) && (nForbidden2 > 0)) // Because Alertness is something we'd never think of retraining! ;)
		{
			nForbidden = 1;
		}

		if ((i == nForbidden3) && (nForbidden3 > 0))
		{
			nForbidden = 1;
		}

		if ((i == nForbidden4) && (nForbidden4 > 0))
		{
			nForbidden = 1;
		}

		if ((i == nForbidden5) && (nForbidden5 > 0))
		{
			nForbidden = 1;
		}

		if ((i == nForbidden6) && (nForbidden6 > 0))
		{
			nForbidden = 1;
		}

		// Special cases, like Use Poison.
		if (i == 0 || i == 1799 || i == 1800 || i == 2129 || i == 2130 || i == 2131
		|| i == 1912 || i == 1913 || i == 1914 || i == 1915 || i == 1916 || i == 960
		|| i == 1113 || i == 1116 || i == 1917 ||  i == 2132 || i == 2133 || i == 6945
		|| i == 6831 || i == FEAT_MARTIAL_STUDY || i == FEAT_MARTIAL_STANCE)
		{
			nForbidden = 1;
		}

		// Bonus feats for classes.  Must be forbidden because feats granted by classes are automatically regranted to the player on levelup if they have been removed.
		if ((GetLevelByClass(CLASS_TYPE_CRUSADER, oPC) > 9) && (i == FEAT_DIEHARD_CRUSADER))
		{
			nForbidden = 1;
		}

		if ((GetLevelByClass(CLASS_TYPE_SWORDSAGE, oPC) > 4) && (i == FEAT_IMPROVED_INITIATIVE))
		{
			nForbidden = 1;
		}

		if ((GetLevelByClass(CLASS_TYPE_SWASHBUCKLER, oPC) > 0) && (i == FEAT_LUCK_OF_HEROES || i == FEAT_MOBILITY || i == FEAT_WEAPON_FINESSE))
		{
			nForbidden = 1;
		}

		if (i == nFSWpnFocus || i == nFSWeaponSpec) //Favored Soul Stuff
		{
			nForbidden = 1;
		}

		if (GetLevelByClass(CLASS_TYPE_ARCANE_SCHOLAR, oPC) > 0)
		{
			if (i == FEAT_MAXIMIZE_SPELL || i == FEAT_QUICKEN_SPELL || i == FEAT_IMPROVED_EMPOWER_SPELL
			|| i == FEAT_IMPROVED_MAXIMIZE_SPELL || i == FEAT_IMPROVED_QUICKEN_SPELL)
			{
				nForbidden = 1;
			}
		}

		if (GetLevelByClass(CLASS_TYPE_MONK, oPC) > 0)
		{
			if (i == 21 || i == 39 || i == 8 || i == 17 || i == 24)
			{
				nForbidden = 1;
			}
		}

		if ((GetLevelByClass(CLASS_TYPE_RANGER, oPC) > 0) && (i == FEAT_TOUGHNESS))
		{
			nForbidden = 1;
		}

		if ((GetLevelByClass(CLASS_TYPE_FRENZIEDBERSERKER, oPC) > 0) && (i == FEAT_TOUGHNESS))
		{
			nForbidden = 1;
		}

		// Racial abilites that shouldn't be retrained as well.
		if (GetSubRace(oPC) == RACIAL_SUBTYPE_AASIMAR)
		{
			if (i == 427 || i == 428 || i == 430)
			{
				nForbidden = 1;
			}
		}
		else if (GetSubRace(oPC) == RACIAL_SUBTYPE_TIEFLING)
		{
			if (i == 427 || i == 429 || i == 430)
			{
				nForbidden = 1;
			}
		}
		else if (GetSubRace(oPC) == RACIAL_SUBTYPE_GRAYORC)
		{
			if (i == 2178 || i == 1116 || i == 2248)
			{
				nForbidden = 1;
			}
		}
		else if (GetSubRace(oPC) == RACIAL_SUBTYPE_YUANTI)
		{
			if (i == 0 || i == 408 || i == 2171)
			{
				nForbidden = 1;
			}
		}

		if ((GetHasFeat(i, oPC)) && (GetLocalInt(oToB, "FeatRetrain1") != i) && (nForbidden == 0) && (i != 0))
		{
			sFeatType = tob_Get2daString("feat", "FeatCategory", i);

			if (sFeatType == "GENERAL_FT_CAT" || sFeatType == "SKILLNSAVE_FT_CAT" || sFeatType == "SPELLCASTING_FT_CAT" || sFeatType == "METAMAGIC_FT_CAT" || sFeatType == "DIVINE_FT_CAT" || sFeatType == "EPIC_FT_CAT")
			{
				sIcon = "RETRAIN_IMAGE=" + tob_Get2daString("feat", "ICON", i) + ".tga";
				sName = "RETRAIN_TEXT=" + GetStringByStrRef(tob_Get2daInt("feat", "FEAT", i));
				sVari = "7=" + IntToString(i);

				AddListBoxRow(oPC, sScreen, "RETRAIN_FEATS_LIST", sPane + IntToString(i), sName, sIcon, sVari, "");
			}
		}
		i++;
	}

	return i;
}

// Runs the above function for the entire feat.2da listing.
void AddAllKnownFeats(object oPC, object oToB, int nStart, int nFinish)
{
	if (GetLocalInt(oToB, "HaltRetrainFeats") == 1) // Kill the loop if we just want to finish leveling.
	{
		return;
	}

	// nStart is at 1 because Alertness causes all sorts of problems and needs to be excluded.
	int nLimit = GetNum2DARows("feat");
	int i = AddKnownFeats(oPC, oToB, nStart, nFinish);

	if (i < nLimit) // The 2da hasn't been entirely run through yet, so we're picking up where we left off to avoid TMI.
	{
		if (nFinish + 50 > nLimit)
		{
			nFinish = nLimit;
		}
		else nFinish = nFinish + 50;

		DelayCommand(0.01f, AddAllKnownFeats(oPC, oToB, i, nFinish));
	}
}

// Filters which feats should be added and which should not.
int CheckFeat(int i, object oPC, object oToB)
{
	if (GetLocalInt(oToB, "HaltRetrainFeats") == 1) // Kill the loops if we just want to finish leveling.
	{
		return 0;
	}

	string sFeatType = tob_Get2daString("feat", "FeatCategory", i);

	if (sFeatType == "GENERAL_FT_CAT" || sFeatType == "SKILLNSAVE_FT_CAT" || sFeatType == "DIVINE_FT_CAT")
	{
		int nPending1 = GetLocalInt(oToB, "PendingFeat1");
		int nPending2 = GetLocalInt(oToB, "PendingFeat2");

		if (i == nPending1)
		{
			return FALSE;
		}
		else if (i == nPending2)
		{
			return FALSE;
		}

		int nRetrain1 = GetLocalInt(oToB, "FeatRetrain1");
		int nRetrain2 = GetLocalInt(oToB, "FeatRetrain2");

		if ((!GetHasFeat(i, oPC)) || (i == nRetrain1) || (i == nRetrain2))
		{
			// Special cases to enable, such as maneuver requirements.
			if ((i == FEAT_DESERT_FIRE) && (GetLocalInt(oToB, "DWTotal") >= 1))
			{
				return TRUE;
			}

			if ((i == FEAT_DESERT_WIND_DODGE) && (GetLocalInt(oToB, "DWTotal") >= 1) && (GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE) > 12))
			{
				return TRUE;
			}

			if ((i == FEAT_DEVOTED_BULWARK) && (GetLocalInt(oToB, "DSTotal") >= 1))
			{
				return TRUE;
			}

			if (i == FEAT_DIVINE_SPIRIT)
			{
				if ((GetLocalInt(oToB, "DSTotal") >= 1) && (GetHasFeat(FEAT_TURN_UNDEAD, oPC, TRUE)))
				{
					return TRUE;
				}
			}

			if (i == FEAT_FALLING_SUN_ATTACK)
			{
				if ((GetLocalInt(oToB, "SSTotal") >= 1) && (GetHasFeat(FEAT_STUNNING_FIST, oPC, TRUE)))
				{
					return TRUE;
				}
			}

			if ((i == FEAT_IRONHEART_AURA) && (GetLocalInt(oToB, "IHTotal") >= 1))
			{
				return TRUE;
			}

			if (i == FEAT_SHADOW_BLADE || i == FEAT_SHADOW_TRICKSTER)
			{
				if (GetLocalInt(oToB, "SHTotal") >= 1)
				{
					return TRUE;
				}
			}

			if (i == FEAT_SONG_OF_THE_WHITE_RAVEN)
			{
				if ((GetLocalInt(oToB, "WRTotal") >= 1) && (GetHasFeat(FEAT_BARDSONG_INSPIRE_COURAGE, oPC)))
				{
					return TRUE;
				}
			}

			if ((i == FEAT_STONE_POWER) && (GetLocalInt(oToB, "SDTotal") >= 1) && (GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE)) > 12)
			{
				return TRUE;
			}

			if (i == FEAT_SUDDEN_RECOVERY || i == FEAT_MARTIAL_STANCE) //Not identical to what the actual checks are in the 2da, but equal.
			{
				int nDW = GetLocalInt(oToB, "DWTotal");
				int nDS = GetLocalInt(oToB, "DSTotal");
				int nDM = GetLocalInt(oToB, "DMTotal");
				int nIH = GetLocalInt(oToB, "IHTotal");
				int nSS = GetLocalInt(oToB, "SSTotal");
				int nSH = GetLocalInt(oToB, "SHTotal");
				int nSD = GetLocalInt(oToB, "SDTotal");
				int nTC = GetLocalInt(oToB, "TCTotal");
				int nWR = GetLocalInt(oToB, "WRTotal");

				if ((nDW >= 1) || (nDS >= 1) || (nDM >= 1) || (nIH >= 1) || (nSS >= 1) || (nSH >= 1) || (nSD >= 1) || (nTC >= 1) || (nWR >= 1))
				{
					return TRUE;
				}
			}

			if ((i == FEAT_TIGER_BLOODED) && (GetLocalInt(oToB, "TCTotal") >= 1))
			{
				if ((GetHasFeat(FEAT_BARBARIAN_RAGE, oPC, TRUE)) || (GetHasFeat(FEAT_WILD_SHAPE, oPC, TRUE)))
				{
					return TRUE;
				}
			}

			if (i == FEAT_VITAL_RECOVERY)
			{
				if (GetHasFeat(FEAT_MARTIAL_STANCE, oPC) || GetHasFeat(FEAT_MARTIAL_STUDY_2, oPC) || GetHasFeat(FEAT_SWORDSAGE, oPC) || GetHasFeat(FEAT_SAINT, oPC) || GetHasFeat(FEAT_WARBLADE, oPC) || GetHasFeat(FEAT_CRUSADER, oPC))
				{
					return TRUE;
				}
			}

			if ((i == FEAT_WHITE_RAVEN_DEFENSE) && (GetLocalInt(oToB, "WRTotal") >= 1))
			{
				return TRUE;
			}

			if ((i == FEAT_EXTRA_GRANTED_MANEUVER) && (GetLevelByClass(CLASS_TYPE_CRUSADER, oPC) > 0))
			{
				return TRUE;
			}

			if ((i == FEAT_EXTRA_READIED_MANEUVER) && (GetLevelByClass(CLASS_TYPE_SWORDSAGE, oPC) > 0))
			{
				return TRUE;
			}

			int nOrReq0 = tob_Get2daInt("feat", "OrReqFeat0", i);
			int nOrReq1 = tob_Get2daInt("feat", "OrReqFeat1", i);
			int nOrReq2 = tob_Get2daInt("feat", "OrReqFeat2", i);
			int nOrReq3 = tob_Get2daInt("feat", "OrReqFeat3", i);
			int nOrReq4 = tob_Get2daInt("feat", "OrReqFeat4", i);
			int nOrReq5 = tob_Get2daInt("feat", "OrReqFeat5", i);

			int nOrReq0State = 0;
			int nOrReq1State = 0;
			int nOrReq2State = 0;
			int nOrReq3State = 0;
			int nOrReq4State = 0;
			int nOrReq5State = 0;

			if (nOrReq0 == 0 || (GetHasFeat(nOrReq0, oPC)))
			{
				nOrReq0State = 1;
			}

			if (nOrReq1 == 0 || (GetHasFeat(nOrReq0, oPC)))
			{
				nOrReq1State = 1;
			}

			if (nOrReq2 == 0 || (GetHasFeat(nOrReq0, oPC)))
			{
				nOrReq2State = 1;
			}

			if (nOrReq3 == 0 || (GetHasFeat(nOrReq0, oPC)))
			{
				nOrReq3State = 1;
			}

			if (nOrReq4 == 0 || (GetHasFeat(nOrReq0, oPC)))
			{
				nOrReq4State = 1;
			}

			if (nOrReq5 == 0 || (GetHasFeat(nOrReq0, oPC)))
			{
				nOrReq5State = 1;
			}

			if ((nOrReq0State == 1) && (nOrReq1State == 1) && (nOrReq2State == 1) && (nOrReq3State == 1) && (nOrReq4State == 1) && (nOrReq5State == 1))
			{
				int nRemoved = tob_Get2daInt("feat", "REMOVED", i);
	
				if (nRemoved == 1)
				{
					return FALSE;
				}

				if (i == nRetrain1)
				{
					return TRUE;
				}

				if (i == nRetrain2)
				{
					return TRUE;
				}

				int nPrereq1 = tob_Get2daInt("feat", "PREREQFEAT1", i);

				if ((nPrereq1 != 0) && (!GetHasFeat(nPrereq1, oPC)))
				{
					return FALSE;
				}

				int nPrereq2 = tob_Get2daInt("feat", "PREREQFEAT2", i);

				if ((nPrereq2 != 0) && (!GetHasFeat(nPrereq2, oPC)))
				{
					return FALSE;
				}
	
				int nMinSTR = tob_Get2daInt("feat", "MINSTR", i);
				int nMinDEX = tob_Get2daInt("feat", "MINDEX", i);
				int nMinCON = tob_Get2daInt("feat", "MINCON", i);
				int nMinINT = tob_Get2daInt("feat", "MININT", i);
				int nMinWIS = tob_Get2daInt("feat", "MINWIS", i);
				int nMinCHA = tob_Get2daInt("feat", "MINCHA", i);
	
				if (nMinSTR != 0)
				{
					if (GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE) < nMinSTR)
					{
						return FALSE;
					}
				}

				if (nMinDEX != 0)
				{
					if (GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE) < nMinDEX)
					{
						return FALSE;
					}
				}
	
				if (nMinCON != 0)
				{
					if (GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE) < nMinCON)
					{
						return FALSE;
					}
				}

				if (nMinINT != 0)
				{
					if (GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE) < nMinINT)
					{
						return FALSE;
					}
				}

				if (nMinWIS != 0)
				{
					if (GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) < nMinWIS)
					{
						return FALSE;
					}
				}
	
				if (nMinCHA != 0)
				{
					if (GetAbilityScore(oPC, ABILITY_CHARISMA, TRUE) < nMinCHA)
					{
						return FALSE;
					}
				}
	
				int nMaxSTR = tob_Get2daInt("feat", "MAXSTR", i);
				int nMaxDEX = tob_Get2daInt("feat", "MAXDEX", i);
				int nMaxCON = tob_Get2daInt("feat", "MAXCON", i);
				int nMaxINT = tob_Get2daInt("feat", "MAXINT", i);
				int nMaxWIS = tob_Get2daInt("feat", "MAXWIS", i);
				int nMaxCHA = tob_Get2daInt("feat", "MAXCHA", i);

				if (nMaxSTR != 0)
				{
					if (GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE) > nMaxSTR)
					{
						return FALSE;
					}
				}

				if (nMaxDEX != 0)
				{
					if (GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE) > nMaxDEX)
					{
						return FALSE;
					}
				}
	
				if (nMaxCON != 0)
				{
					if (GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE) > nMaxCON)
					{
						return FALSE;
					}
				}

				if (nMaxINT != 0)
				{
					if (GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE) > nMaxINT)
					{
						return FALSE;
					}
				}
	
				if (nMaxWIS != 0)
				{
					if (GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) > nMaxWIS)
					{
						return FALSE;
					}
				}

				if (nMaxCHA != 0)
				{
					if (GetAbilityScore(oPC, ABILITY_CHARISMA, TRUE) > nMaxCHA)
					{
						return FALSE;
					}
				}
	
				int nReqSkill = tob_Get2daInt("feat", "REQSKILL", i);
				int nReqSkill2 = tob_Get2daInt("feat", "REQSKILL2", i);

				if (nReqSkill != 0)
				{
					int nMyRanks1 = GetSkillRank(nReqSkill, oPC, TRUE);
					int nReqSkillMinRank = tob_Get2daInt("feat", "ReqSkillMinRanks", i);
					int nReqSkillMaxRank = tob_Get2daInt("feat", "ReqSkillMaxRanks", i);

					if (nReqSkillMinRank != 0)
					{
						if (nMyRanks1 < nReqSkillMinRank)
						{
							return FALSE;
						}
					}
	
					if (nReqSkillMaxRank != 0)
					{
						if (nMyRanks1 >= nReqSkillMaxRank)
						{
							return FALSE;
						}
					}
				}
	
				if (nReqSkill2 != 0)
				{
					int nMyRanks2 = GetSkillRank(nReqSkill2, oPC, TRUE);
					int nReqSkillMinRank2 = tob_Get2daInt("feat", "ReqSkillMinRanks2", i);
					int nReqSkillMaxRank2 = tob_Get2daInt("feat", "ReqSkillMaxRanks2", i);
	
					if (nReqSkillMinRank2 != 0)
					{
						if (nMyRanks2 < nReqSkillMinRank2)
						{
							return FALSE;
						}
					}

					if (nReqSkillMaxRank2 != 0)
					{
						if (nMyRanks2 >= nReqSkillMaxRank2)
						{
							return FALSE;
						}
					}
				}
	
				int nMinFortSave = tob_Get2daInt("feat", "MinFortSave", i);

				if (nMinFortSave != 0)
				{
					if (GetFortitudeSavingThrow(oPC) < nMinFortSave)
					{
						return FALSE;
					}
				}
	
				int nMinLevelClass = tob_Get2daInt("feat", "MinLevelClass", i);
				int nMinLevel = tob_Get2daInt("feat", "MinLevel", i);
				int nMaxLevel = tob_Get2daInt("feat", "MaxLevel", i);
	
				if ((nMinLevelClass == 0) && (nMinLevel != 0))
				{
					int nHitDie = GetHitDice(oPC);
				
					if (nHitDie < nMinLevel)
					{
						return FALSE;
					}
				}
				else if (nMinLevelClass != 0)
				{
					int nClassLvl = GetLevelByClass(nMinLevelClass, oPC);
			
					if (nMinLevel != 0)
					{
						if (nClassLvl < nMinLevel)
						{
							return FALSE;
						}
					}

					if (nMaxLevel != 0)
					{
						if (nClassLvl > nMaxLevel)
						{
							return FALSE;
						}
					}
				}
	
				int nAlignRestrict = tob_Get2daInt("feat", "AlignRestrict", i);

				if (nAlignRestrict != 0)
				{
					if (nAlignRestrict == 2)
					{
						int nLaw = GetAlignmentLawChaos(oPC);
	
						if (nLaw == ALIGNMENT_LAWFUL)
						{
							return FALSE;
						}
					}
					else if (nAlignRestrict == 3)
					{
						int nChaos = GetAlignmentLawChaos(oPC);
	
						if (nChaos == ALIGNMENT_CHAOTIC)
						{
							return FALSE;
						}
					}
					else if (nAlignRestrict == 4)
					{
						int nGood = GetAlignmentGoodEvil(oPC);
	
						if (nGood == ALIGNMENT_GOOD)
						{
							return FALSE;
						}
					}
					else if (nAlignRestrict == 5)
					{
						int nEvil = GetAlignmentGoodEvil(oPC);

						if (nEvil == ALIGNMENT_EVIL)
						{
							return FALSE;
						}
					}
				}

					/* Drammel's Notes on nMinSpellLvl, nMinCasterLvl:
					These checks are currently not supported due to the inability to reliably
					determine either via scripting.  Most of the feats that require these
					also check for other variables and as such are reliable for an accurate
					listing of available feats to retrain.  Hence, I will wait until Obsidian
					implements these checks, if ever.  The only feats that I am aware of that
					allow a 'cheat' on retraining are a handful of skill focus feats.  Considering
					the nature of the feats and the level 1 requirement on caster level, I'm not
					too concerned.*/

				int nMinAB = tob_Get2daInt("feat", "MINATTACKBONUS", i);
				int nAB;

				if (nMinAB != 0)
				{
					// There is no pure way to determine the BAB at previous levels, but the level cap does help moderate a bit.
					if (GetBaseAttackBonus(oPC) > GetLocalInt(oToB, "LevelupCap"))
					{
						nAB = GetLocalInt(oToB, "LevelupCap");
					}
					else nAB = GetBaseAttackBonus(oPC);
	
					if (nAB < nMinAB)
					{
						return FALSE;
					}
				}

				// Special cases, like Use Poison.
				if (i == 0 || i == 1799 || i == 1800 || i == 2129 || i == 2130 || i == 2131 || i == 2132 
				|| i == 2133 || i == 1912 || i == 1913 || i == 1914 || i == 1915 || i == 1916 || i == 960
				|| i == 1113 || i == 1116 || i == 1917 || i == 6831 || i == 6945)
				{
					return FALSE;
				}

				string sScent = GetName(oPC) + "sa_huntersns";
				object oScent = GetObjectByTag(sScent);

				if (GetIsObjectValid(oScent))
				{
					if (i == FEAT_SCENT) //Hunter's Sense actually grants the feat.  This prevents 'gaining a spare to trade'.
					{
						return FALSE;
					}
				}

				int nForbidden1 = GetLocalInt(oToB, "ForbiddenRetrain1");

				if (nForbidden1 > 0) // For the Swordsage's Insightful Strike: Weapon Focus, mostly.
				{
					int nForbidden2 = GetLocalInt(oToB, "ForbiddenRetrain2");
					int nForbidden3 = GetLocalInt(oToB, "ForbiddenRetrain3");
					int nForbidden4 = GetLocalInt(oToB, "ForbiddenRetrain4");
					int nForbidden5 = GetLocalInt(oToB, "ForbiddenRetrain5");
					int nForbidden6 = GetLocalInt(oToB, "ForbiddenRetrain6");

					if (i == nForbidden1)
					{
						return FALSE;
					}

					if ((i == nForbidden2) && (nForbidden2 > 0)) // Because Alertness is something we'd never think of retraining! ;)
					{
						return FALSE;
					}

					if ((i == nForbidden3) && (nForbidden3 > 0))
					{
						return FALSE;
					}
				
					if ((i == nForbidden4) && (nForbidden4 > 0))
					{
						return FALSE;
					}

					if ((i == nForbidden5) && (nForbidden5 > 0))
					{
						return FALSE;
					}

					if ((i == nForbidden6) && (nForbidden6 > 0))
					{
						return FALSE;
					}
				}

			}
			else return FALSE;
		}
		else return FALSE;
	}
	else return FALSE;

	return TRUE;
}

// Displays the feats that the PC qualifies for and does not already know.
// Again, this is a setup for the big TMI prevention function.
int GetAvailableFeats(int i, int nFinish, object oPC, object oToB)
{
	if (GetLocalInt(oToB, "HaltRetrainFeats") == 1) // Kill the loops if we just want to finish leveling.
	{
		return 0;
	}

	while (i <= nFinish)
	{
		if (CheckFeat(i, oPC, oToB))
		{
			string sIcon = "RETRAIN_IMAGE=" + tob_Get2daString("feat", "ICON", i) + ".tga";
			string sName = "RETRAIN_TEXT=" + GetStringByStrRef(tob_Get2daInt("feat", "FEAT", i));
			string sVari = "7=" + IntToString(i);

			AddListBoxRow(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "AVAILABLE_RETRAIN_LIST", "RETRAINPANE_PROTO" + IntToString(i), sName, sIcon, sVari, "");
		}
		i++;
	}

	return i;
}

// Runs the above function in segments to avoid TMI errors.
void GetAllAvailableFeats(object oPC, object oToB, int nStart, int nFinish)
{
	if (GetLocalInt(oToB, "HaltRetrainFeats") == 1) // Kill the loops if we just want to finish leveling.
	{
		return;
	}

	// nStart is at 1 because Alertness causes all sorts of problems and needs to be excluded.
	int nLimit = GetNum2DARows("feat");
	int i = GetAvailableFeats(nStart, nFinish, oPC, oToB);

	if (i < nLimit) // The 2da hasn't been entirely run through yet, so we're picking up where we left off to avoid TMI.
	{
		if (nFinish + 25 > nLimit)
		{
			nFinish = nLimit;
		}
		else nFinish = nFinish + 25;

		DelayCommand(0.01f, GetAllAvailableFeats(oPC, oToB, i, nFinish));
	}
	else DeleteLocalInt(oToB, "RetrainLoopCheck"); //Keeps us from running this function before the first loop has finished.
}

// Displays discplines for the Insightful Strike: Weapon Focus menu.
void DisplaySSInsightfulStrike(object oPC, object oToB)
{
	string sScreen = "SCREEN_LEVELUP_RETRAIN_FEATS";

	ClearListBox(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "AVAILABLE_RETRAIN_LIST");

	if (GetLocalInt(oToB, "SSWeaponFocus") != 1)
	{
		string sDWIcon = "RETRAIN_IMAGE=desertwind.tga";
		string sDWName = "RETRAIN_TEXT=Desert Wind";
		string sDWVari = "7=" + IntToString(1);

		AddListBoxRow(oPC, sScreen, "AVAILABLE_RETRAIN_LIST", "RETRAINPANE_PROTO" + IntToString(1), sDWName, sDWIcon, sDWVari, "");
	}

	if (GetLocalInt(oToB, "SSWeaponFocus") != 3)
	{
		string sDMIcon = "RETRAIN_IMAGE=diamondmind.tga";
		string sDMName = "RETRAIN_TEXT=Diamond Mind";
		string sDMVari = "7=" + IntToString(3);

		AddListBoxRow(oPC, sScreen, "AVAILABLE_RETRAIN_LIST", "RETRAINPANE_PROTO" + IntToString(3), sDMName, sDMIcon, sDMVari, "");
	}

	if (GetLocalInt(oToB, "SSWeaponFocus") != 5)
	{
		string sSSIcon = "RETRAIN_IMAGE=settingsun.tga";
		string sSSName = "RETRAIN_TEXT=Setting Sun";
		string sSSVari = "7=" + IntToString(5);
	
		AddListBoxRow(oPC, sScreen, "AVAILABLE_RETRAIN_LIST", "RETRAINPANE_PROTO" + IntToString(5), sSSName, sSSIcon, sSSVari, "");
	}

	if (GetLocalInt(oToB, "SSWeaponFocus") != 6)
	{
		string sSHIcon = "RETRAIN_IMAGE=greenhand.tga";
		string sSHName = "RETRAIN_TEXT=Shadow Hand";
		string sSHVari = "7=" + IntToString(6);

		AddListBoxRow(oPC, sScreen, "AVAILABLE_RETRAIN_LIST", "RETRAINPANE_PROTO" + IntToString(6), sSHName, sSHIcon, sSHVari, "");
	}

	if (GetLocalInt(oToB, "SSWeaponFocus") != 7)
	{
		string sSDIcon = "RETRAIN_IMAGE=stonedragon.tga";
		string sSDName = "RETRAIN_TEXT=Stone Dragon";
		string sSDVari = "7=" + IntToString(7);

		AddListBoxRow(oPC, sScreen, "AVAILABLE_RETRAIN_LIST", "RETRAINPANE_PROTO" + IntToString(7), sSDName, sSDIcon, sSDVari, "");
	}

	if (GetLocalInt(oToB, "SSWeaponFocus") != 8)
	{
		string sTCIcon = "RETRAIN_IMAGE=tigerclaw.tga";
		string sTCName = "RETRAIN_TEXT=Tiger Claw";
		string sTCVari = "7=" + IntToString(8);

		AddListBoxRow(oPC, sScreen, "AVAILABLE_RETRAIN_LIST", "RETRAINPANE_PROTO" + IntToString(8), sTCName, sTCIcon, sTCVari, "");
	}
}

// Adds Feats pending to be switched for the feats the PC is retraining to the 
// Added Feats window.
void DisplayAddedFeats(object oPC, object oToB)
{
	int nPending1 = GetLocalInt(oToB, "PendingFeat1");
	int nPending2 = GetLocalInt(oToB, "PendingFeat2");

	ClearListBox(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "ADDED_RETRAIN_LIST");

	if (nPending1 > 0)
	{
		string sIcon = "RETRAIN_IMAGE=" + tob_Get2daString("feat", "ICON", nPending1) + ".tga";
		string sName = "RETRAIN_TEXT=" + GetStringByStrRef(tob_Get2daInt("feat", "FEAT", nPending1));
		string sVari = "7=" + IntToString(nPending1);

		AddListBoxRow(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "ADDED_RETRAIN_LIST", "RETRAINPANE_PROTO" + IntToString(nPending1), sName, sIcon, sVari, "");
	}

	if (nPending2 > 0)
	{
		string sIcon = "RETRAIN_IMAGE=" + tob_Get2daString("feat", "ICON", nPending2) + ".tga";
		string sName = "RETRAIN_TEXT=" + GetStringByStrRef(tob_Get2daInt("feat", "FEAT", nPending2));
		string sVari = "7=" + IntToString(nPending1);

		AddListBoxRow(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "ADDED_RETRAIN_LIST", "RETRAINPANE_PROTO" + IntToString(nPending2), sName, sIcon, sVari, "");
	}
}