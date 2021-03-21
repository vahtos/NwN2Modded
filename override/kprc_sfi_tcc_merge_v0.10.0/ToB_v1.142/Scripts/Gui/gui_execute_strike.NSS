//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 3/6/2009							//
//	Title: gui_execute_strike				//
//	Description: Enqueues strike maneuvers.	//
//////////////////////////////////////////////

#include "bot9s_inc_2da"
#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"
#include "bot9s_inc_misc"
#include "bot9s_inc_variables"
#include "bot9s_include"

void StrikeInRange(object oPC, object oToB, object oTarget, float fRange, int nTarget, int nRow, int nLocation, float fPosX, float fPosY, float fPosZ)
{
	location lPC = GetLocation(oPC);
	location lMelee = GetLocalLocation(oPC, "bot9s_pc_pos_strike");
	
	if (lPC == lMelee) // The player has come to a stop.
	{
		float fSize = GetGirth(oTarget);
		int nAppearance = GetAppearanceType(oTarget); //Index number of the target in appearance.2da
		float fHitDist = tob_Get2daFloat("appearance", "HITDIST", nAppearance);

		if ((GetDistanceToObject(oTarget) - fSize) <= (fRange + fHitDist)) // Is the player in attack range of the target?
		{
			if (nLocation == 1) // Object or Location as the target?
			{
				IndexManeuverPosition(oToB, nRow, fPosX, fPosY, fPosZ);
			}
			else if (IntToObject(nTarget) == OBJECT_INVALID)
			{
				return;
			}
			else IndexStrikeTarget(oToB, nRow, oTarget);
	
			SetLocalInt(oToB, "StrikeMoveStatus", 0);
			//AssignCommand(oPC, SetStrike(nRow));
			ActionUseFeat(FEAT_STUDENT_OF_THE_SUBLIME_WAY, oPC);
		}
		else // The player stopped, but wasn't in range of the target.  Clear out the action queue so that we can attempt the maneuver again.
		{
			SetLocalInt(oToB, "StrikeMoveStatus", 0);
			ClearAllActions();
			ClearStrikes();
		}
	}
	
	if (GetLocalInt(oToB, "StrikeMoveStatus") == 1)
	{
		DelayCommand(0.3f, StrikeInRange(oPC, oToB, oTarget, fRange, nTarget, nRow, nLocation, fPosX, fPosY, fPosZ));
	}
}
		
void RunPCStrikePosition(object oPC, object oToB)
{
	location lPC = GetLocation(oPC);
	object oToB = GetItemPossessedBy(oPC, "tob");

	if (GetLocalInt(oToB, "StrikeMoveStatus") == 1)
	{
		SetLocalLocation(oPC, "bot9s_pc_pos_strike", lPC);
		DelayCommand(0.3f, RunPCStrikePosition(oPC, oToB));
	}
	else DeleteLocalLocation(oPC, "bot9s_pc_pos_strike");
}

void ChargeRules(object oPC, object oToB, object oTarget, float fStart, float fRange, int nTarget, int nRow, int nLocation, float fPosX, float fPosY, float fPosZ)
{
	string sManeuver = GetFirstName(oPC) + tob_Get2daString("maneuvers", "Script", nRow);
	object oManeuver = GetObjectByTag(sManeuver);
	int nSupressAoO = GetLocalInt(oManeuver, "SupressAoO");
	
	location lPC = GetLocation(oPC);
	location lCharge = GetLocalLocation(oPC, "bot9s_pc_pos_charge");
	vector vCharge = GetPositionFromLocation(lCharge);
	float fCharge = GetZ(vCharge);
	
	effect eSpeed = EffectMovementSpeedIncrease(99);
	effect eAC = EffectACDecrease(2);
	effect eCharge = EffectLinkEffects(eAC, eSpeed);
	eCharge = SupernaturalEffect(eCharge);
	eCharge = SetEffectSpellId(eCharge, 6561); //Placeholder ID in spells.2da so that the effect can be removed properly.

	float fSize = GetGirth(oTarget);
	int nAppearance = GetAppearanceType(oTarget); //Index number of the target in appearance.2da
	float fHitDist = tob_Get2daFloat("appearance", "HITDIST", nAppearance) + fSize;
	float fDist = fRange + fHitDist;

	if ((GetLocalInt(oToB, "ChargeStatus") == 1) && (lPC != lCharge) && (GetLocalInt(oToB, "ChargeSpeedCheck") == 0))
	{
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCharge, oPC, 6.0f);
		SetLocalInt(oToB, "ChargeSpeedCheck", 1);
	}

	if (lPC == lCharge) // The player has come to a stop.
	{
		if (GetDistanceToObject(oTarget) <= fDist)
		{
			if (nSupressAoO == 1)
			{
				if ((!IsInConversation(oPC)) || (GetNumCutsceneActionsPending() == 0))
				{
					ClearCombatOverrides(oPC);
				}
			}
	
			if (nLocation == 1) // Object or Location as the target?
			{
				IndexManeuverPosition(oToB, nRow, fPosX, fPosY, fPosZ);
			}
			else if (IntToObject(nTarget) == OBJECT_INVALID)
			{
				return;
			}
			else IndexStrikeTarget(oToB, nRow, oTarget);

			RemoveChargeSpeed(oPC);
			DeleteLocalInt(oToB, "ChargeStatus");
			DeleteLocalInt(oToB, "ChargeSpeedCheck");
			AssignCommand(oPC, SetStrike(nRow));
			ActionUseFeat(FEAT_STUDENT_OF_THE_SUBLIME_WAY, oPC);
		}
		else // The player stopped, but wasn't in range of the target.  Clear out the action queue so that we can attempt the maneuver again.
		{
			RemoveChargeSpeed(oPC);
			DeleteLocalInt(oToB, "ChargeStatus");
			DeleteLocalInt(oToB, "ChargeSpeedCheck");
			ClearAllActions();
			ClearStrikes();
		}
	}
	else if ((fCharge < fStart - 0.25f) || (fCharge > fStart + 0.25f)) //Accounts for small bumps that aren't technically what you'd call 'rough terrain'.
	{
		if (nSupressAoO == 1)
		{
			if ((!IsInConversation(oPC)) || (GetNumCutsceneActionsPending() == 0))
			{
				ClearCombatOverrides(oPC);
			}
		}

		if (!CheckStanceChargeRules(oToB))
		{
			RemoveChargeSpeed(oPC);
			ActionForceMoveToLocation(GetLocation(oPC));
			DeleteLocalInt(oToB, "ChargeStatus");
			DeleteLocalInt(oToB, "ChargeSpeedCheck");
			ClearAllActions();
			ClearStrikes();
			SendMessageToPC(oPC, "<color=red>You cannot charge over uneven terrain.</color>");
		}
	}
	
	if ((GetLocalInt(oToB, "ChargeStatus") == 1) && (lPC != lCharge))
	{
		DelayCommand(0.3f, ChargeRules(oPC, oToB, oTarget, fStart, fRange, nTarget, nRow, nLocation, fPosX, fPosY, fPosZ));
	}
	else SetLocalInt(oToB, "ChargeSpeedCheck", 0);
}

void RunPCChargePosition(object oPC, object oToB)
{
	location lPC = GetLocation(oPC);
	
	if (GetLocalInt(oToB, "ChargeStatus") == 1)
	{
		SetLocalLocation(oPC, "bot9s_pc_pos_charge", lPC);
		DelayCommand(0.3f, RunPCChargePosition(oPC, oToB));
	}
	else DeleteLocalLocation(oPC, "bot9s_pc_pos_charge");
}

void main(int nTarget, float fPosX, float fPosY, float fPosZ)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");
	string sData = GetLocalString(oToB, "BlackBox");
	string sClass = GetStringRight(sData, 3);
	string sNumber;

	//RedCrusader is designed to enforce Crusaders readying all of their maneuvers.
	//It should only be set to 1 if the Crusader's Martial Adept menu is open.
	if ((GetCurrentHitPoints(oPC) < 1) || (GetLocalInt(oToB, "RedCrusader") == 1))
	{
		return;
	}

	if (GetSubString(sData, 1, 1) == "_") // Number of Digits
	{
		sNumber = GetStringLeft(sData, 1);
	}
	else sNumber = GetStringLeft(sData, 2);
	
	int nRow = GetLocalInt(oToB, "BlueBoxSTR" + sNumber + sClass);

	// Action queue redundancy prevention.  This is intended to prevent Crusaders from using two maneuvers in a row
	// if one of the maneuvers they currently have enqueued refreshes before the other expends.  It's also a handy way to catch bugs in the action queue.
	if (nRow == GetLocalInt(oToB, "Strike1") || nRow == GetLocalInt(oToB, "Strike2") ||
	nRow == GetLocalInt(oToB, "Strike3") || nRow == GetLocalInt(oToB, "Strike4") ||
	nRow == GetLocalInt(oToB, "Strike5") || nRow == GetLocalInt(oToB, "Strike6") ||
	nRow == GetLocalInt(oToB, "Strike7") || nRow == GetLocalInt(oToB, "Strike8") ||
	nRow == GetLocalInt(oToB, "Strike9") || nRow == GetLocalInt(oToB, "Strike10") ||
	nRow == GetLocalInt(oToB, "Strike11") || nRow == GetLocalInt(oToB, "Strike12") ||
	nRow == GetLocalInt(oToB, "Strike13") || nRow == GetLocalInt(oToB, "Strike14"))
	{
		SendMessageToPC(oPC, "<color=red>This strike is currently enqueued.  Please select another.</color>");
		return;
	}

	string sScript = tob_Get2daString("maneuvers", "Script", nRow);
	string sManeuver = GetFirstName(oPC) + sScript;
	object oManeuver = GetObjectByTag(sManeuver); //Object and script names are intended to be identical.
	object oTarget = IntToObject(nTarget);
	int nMovement = GetLocalInt(oManeuver, "Movement");
	int nLocation = GetLocalInt(oManeuver, "Location");

	if (nMovement == 0) // Does the maneuver require us to move?
	{
		if (nLocation == 1) // Object or Location as the target?
		{
			IndexManeuverPosition(oToB, nRow, fPosX, fPosY, fPosZ);
		}
		else if (!GetIsObjectValid(oTarget))
		{
			return;
		}
		else IndexStrikeTarget(oToB, nRow, oTarget);

		SetStrike(nRow);
		ActionUseFeat(FEAT_STUDENT_OF_THE_SUBLIME_WAY, oPC);
	}
	else if (nMovement == 2) // Is this a charge attack?
	{
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
		float fRange = GetMeleeRange(oPC);

		if ((GetDistanceBetween(oPC, oTarget) >= FeetToMeters(10.0f)) && (!GetWeaponRanged(oWeapon)))
		{
			if (LineOfSightObject(oPC, oTarget) == TRUE)
			{	
				vector vStart = GetPosition(oPC);
				float fStart = GetZ(vStart);
				int nSupressAoO = GetLocalInt(oManeuver, "SupressAoO");

				if (nSupressAoO == 1)
				{
					if ((!IsInConversation(oPC)) || (GetNumCutsceneActionsPending() == 0))
					{
						SetCombatOverrides(oPC, OBJECT_INVALID, -1, -1, OVERRIDE_ATTACK_RESULT_DEFAULT, -1, -1, TRUE, FALSE, FALSE, FALSE);
					}
				}

				// Special Cases

				if (nRow == STRIKE_DOOM_CHARGE)
				{
					effect eDoom = EffectVisualEffect(VFX_TOB_DOOMCHARGE);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDoom, oPC, 6.0f);
				}
				else if (nRow == STRIKE_LAW_BEARER)
				{
					effect eBearer = EffectVisualEffect(VFX_TOB_LAWBEARER);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBearer, oPC, 6.0f);
				}
				else if (nRow == STRIKE_RADIANT_CHARGE)
				{
					effect eRadiant = EffectVisualEffect(VFX_TOB_RADIANT_CHARGE);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRadiant, oPC, 6.0f);
				}
				else if (nRow == STRIKE_TIDE_OF_CHAOS)
				{
					effect eTide = EffectVisualEffect(VFX_TOB_TIDEOFCHAOS);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTide, oPC, 6.0f);
				}

				ClearAllActions();
				AssignCommand(oPC, ClearStrikes()); // Just in case.  Loops never seem to agree with me.
				SetLocalInt(oToB, "ChargeStatus", 1);
				DelayCommand(6.0f, SetLocalInt(oToB, "ChargeStatus", 0));
				DelayCommand(0.1f, RunPCChargePosition(oPC, oToB));
				DelayCommand(0.5f, ChargeRules(oPC, oToB, oTarget, fStart, fRange, nTarget, nRow, nLocation, fPosX, fPosY, fPosZ));
				ActionMoveToObject(oTarget, TRUE, fRange);
			}
			else SendMessageToPC(oPC, "<color=red>You do not have line of sight to the target.</color>");
		}
		else SendMessageToPC(oPC, "<color=red>You must be at least ten feet away from the target and equipped with a melee weapon to make a charge.</color>");
	}
	else //Normal Movement.
	{
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

		if (GetWeaponRanged(oWeapon) && (!GetHasFeat(FEAT_AIM, oPC)))
		{
			SendMessageToPC(oPC, "<color=red>You cannot execute a ranged strike without training.</color>");
			return;
		}

		float fRange;
		float fDefaultRange = GetLocalFloat(oManeuver, "Range");

		if (fDefaultRange > 0.0f) // Is there a preferred attack range?
		{
			fRange = FeetToMeters(fDefaultRange);
		}
		else fRange = GetMeleeRange(oPC);

		int nAppearance = GetAppearanceType(oTarget); //Index number of the target in appearance.2da
		float fHitDist = tob_Get2daFloat("appearance", "HITDIST", nAppearance);

		// Special Cases
		if (nRow == STRIKE_BOUNDING_ASSAULT)
		{
			effect eSpeed = EffectMovementSpeedIncrease(99);
			eSpeed = ExtraordinaryEffect(eSpeed);

			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpeed, oPC, 6.0f);
		}
		else if (nRow == STRIKE_DEVASTATING_THROW)
		{
			float fCheck = GetDistanceBetween(oPC, oTarget);
	
			if (fCheck < FeetToMeters(15.0f))
			{
				SendMessageToPC(oPC, "<color=red>You must be at least 15 feet away from your target to initiate a Devastating Throw.</color>");
				return;
			}
		}
		else if (nRow == STRIKE_DSRTTEMP)
		{
			float fDsrtTemp = GetMeleeRange(oPC);

			SetLocalInt(oPC, "DesertTempestActive", 1);
			SetLocalInt(oToB, "DesertWindStrike", 1);
			DelayCommand(6.0f, SetLocalInt(oToB, "DesertWindStrike", 0));
			SetLocalLocation(oPC, "DesertTempestLoc", GetLocation(oPC));
			DelayCommand(0.1f, DoDesertTempestLoc());
			DoDesertTempest(oPC, oToB, fDsrtTemp);
			ExpendManeuver(5, "STR");// Too powerful if you can cancel the maneuver before it starts.
		}
		else if (nRow == STRIKE_SLMDRCHRG)
		{
			if ((GetDistanceBetween(oPC, oTarget) <= FeetToMeters(10.0f)) || (GetWeaponRanged(oWeapon)))
			{
				SendMessageToPC(oPC, "<color=red>You must be at least ten feet away from the target and equipped with a melee weapon to make a charge.</color>");
				return;
			}

			int nNumber = GetLocalInt(oPC, "SalamanderTopNumber");
			effect eSpeed = EffectMovementSpeedIncrease(99);
			effect eAC = EffectACDecrease(2);
			effect eCharge = EffectLinkEffects(eSpeed, eAC);
			eCharge = ExtraordinaryEffect(eCharge);

			if (nNumber > 0) // Reinitiating this maneuver ends previous effects.
			{
				int s;

				s = 1;

				while (s <= nNumber)
				{
					DeleteLocalLocation(oPC, "SalamanderLoc" + IntToString(s));
					s++;
				}

				effect eTest;

				eTest = GetFirstEffect(oPC);

				while (GetIsEffectValid(eTest))
				{
					if (GetEffectSpellId(eTest) == 6554)
					{
						RemoveEffect(oPC, eTest);
						break;
					}
					eTest = GetNextEffect(oPC);
				}
			}

			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCharge, oPC, 6.0f);
			SetLocalLocation(oPC, "SalamanderLoc", GetLocation(oPC));
			DeleteLocalInt(oPC, "SalamanderTimer"); //Reset the timer that tracks the duration of the effect.
			SetLocalInt(oToB, "DesertWindStrike", 1);
			DelayCommand(6.0f, SetLocalInt(oToB, "DesertWindStrike", 0));
			DelayCommand(0.1f, ExecuteScript("salamander_charge", oPC));
			ExpendManeuver(22, "STR");// Too powerful if you can cancel the maneuver before it starts.
		}

		if ((GetDistanceBetween(oPC, oTarget) - GetGirth(oTarget)) <= (fRange + fHitDist)) // We're at the target and don't need to move.
		{
			if (nLocation == 1) // Object or Location as the target?
			{
				IndexManeuverPosition(oToB, nRow, fPosX, fPosY, fPosZ);
			}
			else if (!GetIsObjectValid(oTarget))
			{
				return;
			}
			else IndexStrikeTarget(oToB, nRow, oTarget);

			AssignCommand(oPC, SetStrike(nRow));
			ActionUseFeat(FEAT_STUDENT_OF_THE_SUBLIME_WAY, oPC);
		}
		else
		{
			SetStrike(nRow);
			DelayCommand(0.5f, StrikeInRange(oPC, oToB, oTarget, fRange, nTarget, nRow, nLocation, fPosX, fPosY, fPosZ));

			if ((GetLocalInt(oToB, "StrikeMoveStatus") == 1) || (GetLocalInt(oToB, "ChargeStatus") == 1))//Already moving for a strike when this was called.
			{
				if (GetLocalInt(oToB, "ChargeStatus") == 1)
				{
					RemoveChargeSpeed(oPC);
				}

				ClearAllActions();
				ActionMoveToObject(oTarget, TRUE, fRange + fHitDist);
			}
			else // We're not moving yet, so let's get going.
			{
				SetLocalInt(oToB, "StrikeMoveStatus", 1);
				DelayCommand(0.1f, RunPCStrikePosition(oPC, oToB));
				ActionMoveToObject(oTarget, TRUE, fRange + fHitDist);
			}
		}
	}
}