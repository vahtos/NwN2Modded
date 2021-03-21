//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 2/17/2009							//
//	Title: gui_execute_counter				//
//	Description: This is it!  This is the	//
//	script which bypasses the main action	//
//	queue to enable swift maneuvers.		//
//////////////////////////////////////////////

#include "bot9s_inc_2da"

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

	if ((GetCurrentHitPoints(oPC) < 1) || (IntToObject(nTarget) == OBJECT_INVALID) || (GetLocalInt(oToB, "RedCrusader") == 1))
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
	
	int nRow = GetLocalInt(oToB, "BlueBoxC" + sNumber + sClass);
	string sScript = tob_Get2daString("maneuvers", "Script", nRow);

	DeleteLocalInt(oPC, "bot9s_status_check");

	if (GetLocalInt(oToB, "Counter") != nRow) // Prevent multiple callback for the same maneuver.
	{
		SetLocalInt(oToB, "Counter", nRow);
		SetLocalInt(oToB, "Target", nTarget);
		ExecuteScript(sScript, oPC);
	}
}