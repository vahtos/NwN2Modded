//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 2/3/2009							//
//	Title: gui_execute_boost				//
//	Description: This is it!  This is the	//
//	script which bypasses the main action	//
//	queue to enable swift maneuvers.		//
//////////////////////////////////////////////

#include "bot9s_inc_2da"
#include "bot9s_inc_misc"

void CheckStatus(object oPC)
{
	int nCheck;
	effect eSuck;

	eSuck = GetFirstEffect(oPC);

	while (GetIsEffectValid(eSuck)) // In order to initiate a maneuver the player must be able to move(ToB p.38).
	{
		nCheck = GetEffectType(eSuck);

		if (nCheck == EFFECT_TYPE_CHARMED || nCheck == EFFECT_TYPE_CONFUSED || nCheck == EFFECT_TYPE_CUTSCENE_PARALYZE
		|| nCheck == EFFECT_TYPE_DAZED || nCheck == EFFECT_TYPE_DOMINATED
		|| nCheck == EFFECT_TYPE_ENTANGLE || nCheck == EFFECT_TYPE_FRIGHTENED
		|| nCheck == EFFECT_TYPE_PARALYZE || nCheck == EFFECT_TYPE_PETRIFY
		|| nCheck == EFFECT_TYPE_STUNNED || nCheck == EFFECT_TYPE_TIMESTOP)
		{
			SetLocalInt(oPC, "bot9s_status_check", 1);
			break;
		}

		eSuck = GetNextEffect(oPC);
	}
}

void main(int nTarget, float fPosX, float fPosY, float fPosZ)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");
	string sData = GetLocalString(oToB, "BlackBox");
	string sClass = GetStringRight(sData, 3);
	string sNumber;

	if ((GetCurrentHitPoints(oPC) < 1) || (GetLocalInt(oToB, "RedCrusader") == 1))
	{
		return;
	}

	AssignCommand(oPC, CheckStatus(oPC));

	int nStatus = GetLocalInt(oPC, "bot9s_status_check");

	if (nStatus == 1)
	{
		SendMessageToPC(oPC, "<color=red>You cannot take this action in your current state.</color>");
		return;
	}

	if (GetSubString(sData, 1, 1) == "_") // Number of Digits
	{
		sNumber = GetStringLeft(sData, 1);
	}
	else sNumber = GetStringLeft(sData, 2);

	int nRow = GetLocalInt(oToB, "BlueBoxB" + sNumber + sClass);

	string sScript = tob_Get2daString("maneuvers", "Script", nRow);
	string sManeuver = GetFirstName(oPC) + sScript;
	object oManeuver = GetObjectByTag(sManeuver); //Object and script names are intended to be identical.
	int nLocation = GetLocalInt(oManeuver, "Location");

	if (nLocation == 1) // Object or Location as the target?
	{
		IndexManeuverPosition(oToB, nRow, fPosX, fPosY, fPosZ);
	}
	else if (IntToObject(nTarget) == OBJECT_INVALID)
	{
		return;
	}
	else SetLocalInt(oToB, "Target", nTarget);

	SetLocalInt(oPC, "bot9s_status_check", 0);
	ExecuteScript(sScript, oPC);
}