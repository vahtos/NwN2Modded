//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 1/19/2009							//
//	Title:	bo_dstrember					//
//	Description: Swift Action; Creates a 	//
//	fire elemental to flank with.			//
//////////////////////////////////////////////

#include "tob_x0_i0_position"
#include "bot9s_inc_2da"
#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = IntToObject(GetLocalInt(oToB, "Target"));
	
	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	object oDstrEmber = GetNearestObjectByTag("c_distractingember", oPC);
	float fDistance = DISTANCE_TINY;
	float fRange = FeetToMeters(30.0f) + tob_Get2daFloat("appearance", "PREFATCKDIST", GetAppearanceType(oTarget));
	string sTemplate = "c_distractingember";
	location lLocation = GetBehindLocation(oTarget, fDistance);
	float fDelay = 6.0f;
	
	if (GetDistanceToObject(oTarget) <= fRange)
	{	
		if (GetLocalInt(oToB, "Swift") == 0)	
		{
			RunSwiftAction(6, "B");
		
			effect eSummon = EffectSummonCreature(sTemplate, VFX_FNF_SMOKE_PUFF);
			ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lLocation, fDelay);
			AssignCommand(oTarget, ClearAllActions());
			AssignCommand(oTarget, ActionAttack(oDstrEmber));
			AssignCommand(oTarget, TurnToFaceObject(oDstrEmber, oTarget));
			ExpendManeuver(6, "B");
		}
	}
	else SendMessageToPC(oPC, "<color=red>The target is out of range.</color>");
}