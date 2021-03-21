//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 5/3/2009							//
//	Title: gui_execute_stance2				//
//	Description: This is it!  This is the	//
//	script which bypasses the main action	//
//	queue to enable swift maneuvers.		//
//////////////////////////////////////////////

#include "bot9s_inc_2da"
#include "bot9s_inc_maneuvers"

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

	int nRow =  GetLocalInt(oToB, "BlueBoxDSTA" + sNumber + sClass);
	string sScript = tob_Get2daString("maneuvers", "Script", nRow);

	if (nRow == (GetLocalInt(oToB, "Stance2")))
	{
		SetLocalInt(oToB, "Stance2", 0);
		SendMessageToPC(oPC, "You have ended your current stance.");
	}
	else if (GetLocalInt(oToB, "Swift") == 0)
	{
		SetLocalInt(oToB, "Stance2", nRow);
		
		int nStance = GetLocalInt(oToB, "Stance");
		int nStance2 = GetLocalInt(oToB, "Stance2");

		if (nStance == nStance2) // Check to prevent two identical stances from being run at the same time.
		{
			SendMessageToPC(oPC, "<color=red>This stance is already active, please choose another.</color>");
			return;
		}
		else
		{
			SetLocalInt(oToB, "Target", nTarget);
			SetLocalInt(oPC, "bot9s_status_check", 0);

			if (GetLevelByClass(71, oPC) > 7) //Swordsage Defensive Stance
			{
				DefensiveStance(oPC, oToB, nRow);
			}

			ExecuteScript(sScript, oPC);
			RunSwiftAction(nRow, "STA", oPC);
		}
	}
}