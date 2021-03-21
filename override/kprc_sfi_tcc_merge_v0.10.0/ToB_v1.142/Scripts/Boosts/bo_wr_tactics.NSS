//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 8/24/2009								//
//	Title: bo_wr_tactics						//
//	Description: Grants the effects of the spell//
//  Haste to a single ally for a duration of one//
//  round per initiator level.					//
//////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = IntToObject(GetLocalInt(oToB, "Target"));
	
	if ((GetLocalInt(oToB, "Swift") == 0) && (oTarget != oPC) && (!GetIsReactionTypeHostile(oTarget, oPC)))
	{
		float fDist = GetDistanceBetween(oPC, oTarget);
		float fCheck = FeetToMeters(10.0f) + GetGirth(oPC) + GetGirth(oTarget); // Distance checks start from the center of the creature, not the edge.

		if (fDist <= fCheck)
		{
			float fDuration = RoundsToSeconds(GetInitiatorLevel(oPC));
			effect eHaste = EffectHaste();
			effect eVis = EffectVisualEffect(VFX_TOB_WR_TACTICS);
			eHaste = ExtraordinaryEffect(eHaste);
	
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHaste, oTarget, fDuration);
			RunSwiftAction(207, "B");
			ExpendManeuver(207, "B");
		}
		else SendMessageToPC(oPC, "<color=red>This target is farther than 10 feet away.</color>");
	}
	else SendMessageToPC(oPC, "<color=red>You can only target an ally with this maneuver.</color>");
}