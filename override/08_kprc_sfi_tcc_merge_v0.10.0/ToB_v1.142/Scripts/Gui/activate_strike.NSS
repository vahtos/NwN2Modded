//////////////////////////////////////////
//	Author: Drammel						//
//	Date: 3/6/2009						//
//	Title: activate_strike				//
//	Description: Funnel script which is	//
//	used to enqueue strikes.			//
//////////////////////////////////////////

#include "bot9s_inc_2da"

int GetStrike(object oPC, object oToB)
{
	int nMaxStrike = GetLocalInt(oToB, "HighStrike");
	int nAction = GetCurrentAction(oPC);
	int nStrike, nOk;

	nOk = 1;
	nStrike = GetLocalInt(oToB, "Strike1");//Always return this value.

	// Sanity checks.  A couple of these conditions should never occur, but I'm seeing if paranoia helps.
	if (GetCurrentHitPoints(oPC) < 1)
	{
		nOk = 0;
	}
	else if (nAction == ACTION_ATTACKOBJECT || nAction == ACTION_MOVETOPOINT) //Indicates that an attack or move action has been called which means that the strike will hang unless we clear it out.
	{
		nOk = 0;
	}
	else
	{
		effect eSuck;

		eSuck = GetFirstEffect(oPC);

		while (GetIsEffectValid(eSuck)) // In order to initiate a maneuver the player must be able to move(ToB p.38).
		{
			if (GetEffectType(eSuck) == EFFECT_TYPE_CHARMED || GetEffectType(eSuck) == EFFECT_TYPE_CONFUSED || GetEffectType(eSuck) == EFFECT_TYPE_CUTSCENE_PARALYZE
			|| GetEffectType(eSuck) == EFFECT_TYPE_DAZED || GetEffectType(eSuck) == EFFECT_TYPE_DOMINATED
			|| GetEffectType(eSuck) == EFFECT_TYPE_ENTANGLE || GetEffectType(eSuck) == EFFECT_TYPE_FRIGHTENED
			|| GetEffectType(eSuck) == EFFECT_TYPE_PARALYZE || GetEffectType(eSuck) == EFFECT_TYPE_PETRIFY
			|| GetEffectType(eSuck) == EFFECT_TYPE_STUNNED || GetEffectType(eSuck) == EFFECT_TYPE_TIMESTOP)
			{
				nOk = 0;
				break;
			}

			eSuck = GetNextEffect(oPC);
		}
	}

	if (nOk == 1)
	{
		int i, nNewStrike;
	
		i = 1;
	
		while (i <= nMaxStrike)
		{
			nNewStrike = GetLocalInt(oToB, "Strike" + IntToString(i + 1));
	
			if (nNewStrike > 0) // Move everything down one.
			{
				SetLocalInt(oToB, "Strike" + IntToString(i), nNewStrike);
			}
			else DeleteLocalInt(oToB, "Strike" + IntToString(i));
	
			i++;
		}
	}
	else // Clear out everything.
	{
		int i;

		i = 1;

		while (GetLocalInt(oToB, "Strike" + IntToString(i)) > 0)
		{
			DeleteLocalInt(oToB, "Strike" + IntToString(i));
			i++;
		}
		nStrike = 0;

		ClearAllActions();
	}

	return nStrike;
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nRow = GetStrike(oPC, oToB);

	if (nRow == 0)
	{
		return;
	}

	string sScript = tob_Get2daString("maneuvers", "Script", nRow);

	SetLocalInt(oPC, "bot9s_maneuver_running", nRow); // Tells many functions what maneuver is currently being used.
	DelayCommand(6.0f, DeleteLocalInt(oPC, "bot9s_maneuver_running"));
	ExecuteScript(sScript, oPC);
}