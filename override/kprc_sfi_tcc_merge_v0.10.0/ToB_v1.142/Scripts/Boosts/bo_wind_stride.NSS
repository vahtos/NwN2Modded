//////////////////////////////////////////////////////
//  Author: Drammel									//
//  Date: 10/1/2009	(Oops! Missed this one!)		//
//  Title: bo_wind_stride							//
//  Description: The desert wind envelops you and   //
//  carries you across the battlefield, giving you a//
//  burst of speed to move around and through your  //
//  enemies. Until the end of your turn, you gain a //
//  +10-foot enhancement bonus to your land speed.	//
//////////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = IntToObject(GetLocalInt(oToB, "Target"));

	if (oTarget != oPC)
	{
		SendMessageToPC(oPC, "<color=red>You can only use Wind Stride on yourself.</color>");
		return;
	}

	if (GetLocalInt(oToB, "Swift") == 0)
	{
		effect eStride = EffectMovementSpeedIncrease(33);// Roughly ten feet more per round.
		effect eVis = EffectVisualEffect(VFX_TOB_LEAFSPIN);
		eStride = ExtraordinaryEffect(eStride);

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPC, 6.0f);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStride, oPC, 6.0f);
		RunSwiftAction(25, "B");
		ExpendManeuver(25, "B");
	}
}