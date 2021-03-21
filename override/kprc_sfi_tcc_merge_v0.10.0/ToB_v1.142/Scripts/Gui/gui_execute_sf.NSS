//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 4/10/2009							//
//	Title: gui_execute_sf					//
//	Description: Enables feats which require//
//	a swift or free action to activate.		//
//////////////////////////////////////////////

#include "bot9s_inc_2da"

void main(int nTarget)
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

	int nCheck;
	effect eSuck;

	eSuck = GetFirstEffect(oPC);

	while (GetIsEffectValid(eSuck))
	{
		nCheck = GetEffectType(eSuck);

		if (nCheck == EFFECT_TYPE_CHARMED || nCheck == EFFECT_TYPE_CONFUSED || nCheck == EFFECT_TYPE_CUTSCENE_PARALYZE
		|| nCheck == EFFECT_TYPE_DAZED || nCheck == EFFECT_TYPE_DOMINATED
		|| nCheck == EFFECT_TYPE_ENTANGLE || nCheck == EFFECT_TYPE_FRIGHTENED
		|| nCheck == EFFECT_TYPE_PARALYZE || nCheck == EFFECT_TYPE_PETRIFY
		|| nCheck == EFFECT_TYPE_STUNNED || nCheck == EFFECT_TYPE_TIMESTOP)
		{
			SendMessageToPC(oPC, "<color=red>You cannot take this action in your current state.</color>");
			return;
		}

		eSuck = GetNextEffect(oPC);
	}

	if (GetSubString(sData, 1, 1) == "_") // Number of Digits
	{
		sNumber = GetStringLeft(sData, 1);
	}
	else sNumber = GetStringLeft(sData, 2);

	int nRow = GetLocalInt(oToB, "BlueBoxF" + sNumber + sClass);
	string sScript = tob_Get2daString("maneuvers", "Script", nRow);

	SetLocalInt(oToB, "Target", nTarget);
	ExecuteScript(sScript, oPC);
}