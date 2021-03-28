//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 4/5/2009							//
//	Title: gui_run_charge					//
//	Description: Activates charge attacks.	//
//////////////////////////////////////////////

#include "bot9s_inc_2da"
#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"
#include "bot9s_inc_misc"
#include "bot9s_inc_variables"
#include "bot9s_include"

void ChargeRules(object oPC, object oToB, object oTarget, float fStart, float fRange)
{
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
	float fDist = fRange + fSize;

	if ((GetLocalInt(oToB, "ChargeStatus") == 1) && (lPC != lCharge) && (GetLocalInt(oToB, "ChargeSpeedCheck") == 0))
	{
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCharge, oPC, 6.0f);
		SetLocalInt(oToB, "ChargeSpeedCheck", 1);
	}

	if (lPC == lCharge)// The player has come to a stop.
	{
		if (GetDistanceToObject(oTarget) <= fDist)
		{
			RemoveChargeSpeed(oPC);
			SetLocalInt(oToB, "ChargeStatus", 0);
			SetLocalInt(oToB, "ChargeSpeedCheck", 0);
			SetStrike(211);
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
	else if ((fCharge < fStart - 0.25f) || (fCharge > fStart + 0.25f)) //Acounts for small bumps that aren't technically what you'd call 'rough terrain'.
	{
		RemoveChargeSpeed(oPC);
		SetLocalInt(oToB, "ChargeStatus", 0);
		SetLocalInt(oToB, "ChargeSpeedCheck", 0);
		ClearAllActions();
		ClearStrikes();
		SendMessageToPC(oPC, "<color=red>You cannot charge over uneven terrain.</color>");
	}
	
	if ((GetLocalInt(oToB, "ChargeStatus") == 1) && (lPC != lCharge))
	{
		DelayCommand(0.3f, ChargeRules(oPC, oToB, oTarget, fStart, fRange));
	}
	else SetLocalInt(oToB, "ChargeSpeedCheck", 0);
}

void RunPCChargePosition()
{
	object oPC = OBJECT_SELF;
	location lPC = GetLocation(oPC);
	object oToB = GetItemPossessedBy(oPC, "tob");
	
	if (GetLocalInt(oToB, "ChargeStatus") == 1)
	{
		SetLocalLocation(oPC, "bot9s_pc_pos_charge", lPC);
		DelayCommand(0.3f, RunPCChargePosition());
	}
	else DeleteLocalLocation(oPC, "bot9s_pc_pos_charge");
}

void main(int nTarget)
{	
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = IntToObject(nTarget);
	int nRow = 211;
	string sScript = tob_Get2daString("maneuvers", "Script", nRow);
	
	IndexStrikeTarget(oToB, nRow, oTarget);
	SetLocalInt(oToB, "Strike", nRow);
	
	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
	int nWeapon = GetBaseItemType(oWeapon);
	float fRange = GetMeleeRange(oPC) + tob_Get2daFloat("appearance", "HITDIST", GetAppearanceType(oTarget));

	if ((GetDistanceBetween(oPC, oTarget) >= FeetToMeters(10.0f)) && (!GetWeaponRanged(oWeapon)))
	{
		if (LineOfSightObject(oPC, oTarget))
		{	
			vector vStart = GetPosition(oPC);
			float fStart = GetZ(vStart);

			ClearAllActions();
			ClearStrikes();
			SetLocalInt(oToB, "ChargeStatus", 1);
			DelayCommand(6.0f, SetLocalInt(oToB, "ChargeStatus", 0));
			DelayCommand(0.1f, RunPCChargePosition());
			DelayCommand(0.5f, ChargeRules(oPC, oToB, oTarget, fStart, fRange));
			ActionMoveToObject(oTarget, TRUE, fRange);
		}
		else SendMessageToPC(oPC, "<color=red>You do not have line of sight to the target.</color>");
	}
	else SendMessageToPC(oPC, "<color=red>You must be at least ten feet away from the target and equipped with a melee weapon to make a charge.</color>");
}