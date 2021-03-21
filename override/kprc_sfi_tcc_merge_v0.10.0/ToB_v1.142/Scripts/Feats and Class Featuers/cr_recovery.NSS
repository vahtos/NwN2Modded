//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 5/17/2009								//
//	Title: cr_recovery							//
//	Description: Initiates the recovery method	//
//	for a crusader's maneuvers.					//
//////////////////////////////////////////////////

#include "bot9s_cr_recovery"
#include "bot9s_inc_constants"
#include "bot9s_inc_feats"
#include "bot9s_inc_maneuvers"

void CrusaderRecovery()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nHp = GetCurrentHitPoints(oPC);

	if (nHp < 1) // Death tends to gum up the works.  
	{
		ClearRecoveryFlags();
		DisableAll();
	}

	if (GetLocalInt(oToB, "AS_HaltCrCycle") == 1)
	{
		return; // For use in conjunction with Adaptive Style.
	}

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6538);

	if ((GetIsInCombat(oPC)) && (nHp > 0))
	{
		GenerateReadiedManeuvers("B", 10);
		GenerateReadiedManeuvers("C", 10);
		GenerateReadiedManeuvers("STR", 20);

		string sScreen = "SCREEN_QUICK_STRIKE_CR";
		int nBoostLimit = GetLocalInt(oToB, "BCrLimit");
		int nCounterLimit = GetLocalInt(oToB, "CCrLimit");
		int nStrikeLimit = GetLocalInt(oToB, "STRCrLimit");
		int nTotal = nBoostLimit + nCounterLimit + nStrikeLimit;

		SetLocalInt(oToB, "CrLimit", nTotal);

		if (GetLocalInt(oToB, "EncounterR1") == 0) // First round of combat grants more maneuvers.
		{
			SetLocalInt(oToB, "EncounterR1", 1);
			ClearRecoveryFlags();
			DisableAll();

			int nStarting;
			int nLevel = GetLevelByClass(CLASS_TYPE_CRUSADER, oPC);

			if (GetHasFeat(FEAT_EXTRA_GRANTED_MANEUVER, oPC))
			{
				nStarting += 1;
			}

			if (nLevel > 29)
			{
				nStarting += 5;
			}
			else if (nLevel > 19)
			{
				nStarting += 4;
			}
			else if (nLevel > 9)
			{
				nStarting += 3;
			}
			else nStarting += 2;

			if (nStarting > nTotal)
			{
				nStarting = nTotal;
			}

			int i;
			int nCheck;
			string sRandomManeuver;

			i = 1;

			while (i <= nStarting)
			{
				sRandomManeuver = RandomManeuver(oToB);
				ClearCrusaderRecoveryFlag(sRandomManeuver);
				nCheck = GetLocalInt(oToB, "RRFCleared");

				if (nCheck == 1)
				{
					SetLocalInt(oToB, "RRFCleared", 0);
					SetGUIObjectDisabled(oPC, sScreen, sRandomManeuver, FALSE);
					i++;
				}
			}
		}
		else if (GetLocalInt(oToB, "EncounterR1") == 1)
		{
			int i;
			int nCheck;
			string sRandomManeuver;

			i = 1;

			while (i < 2) // Just one this round.
			{
				sRandomManeuver = RandomManeuver(oToB);

				// If all of the Crusader's Maneuvers are enabled, clear em out and start over.
				if (CheckWithheldManeuvers() == TRUE)
				{
					SetLocalInt(oToB, "EncounterR1", 0);
					DelayCommand(0.1f, CrusaderRecovery());
					return;
				}
				else ClearCrusaderRecoveryFlag(sRandomManeuver);

				nCheck = GetLocalInt(oToB, "RRFCleared");

				if (nCheck == 1)
				{
					SetLocalInt(oToB, "RRFCleared", 0);
					SetGUIObjectDisabled(oPC, sScreen, sRandomManeuver, FALSE);
					break;
				}
			}

			if ((GetHasFeat(FEAT_VITAL_RECOVERY)) && (GetLocalInt(oToB, "VitalRecovery") == 0))
			{
				int nMax = GetMaxHitPoints(oPC);
				int nHP = GetCurrentHitPoints(oPC);
				
				if (nHP < nMax) // Won't heal when we're at full HP.
				{
					int nHitDice = GetHitDice(oPC);
					effect eHeal = ManeuverHealing(oPC, 3 + nHitDice);

					ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
					SetLocalInt(oToB, "VitalRecovery", 1);
				}
			}
		}

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
		DelayCommand(6.0f, CrusaderRecovery());
	}
	else
	{
		SetLocalInt(oToB, "EncounterR1", 0);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 0.1f);
		DelayCommand(0.1f, CrusaderRecovery());
	}
}

void CheckLoopEffect()
{
	if(!CheckRecursive(6538))
	{
		CrusaderRecovery(); //Only runs if the effect is no longer on the player.
	}
}

void main()
{
	DelayCommand(6.0f, CheckLoopEffect()); // Needs to be delayed because when the feat fires after resting the engine doesn't detect effects immeadiately.
}