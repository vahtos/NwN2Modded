//////////////////////////////////////////////////////
//  Author: Drammel									//
//  Date: 10/17/2009	                            //
//  Title: bo_quicksilver							//
//  Description: You must currently be in a move    //
//  action to initiate this maneuver.  For six      //
//  seconds your movement speed doubles.            //
//  Additionally, if you have already expended your //
//  swift or immediate action for the round, you    //
//  instantly recover its use.  Quicksilver Motion  //
//  can only be initiated once per six seconds.  A  //
//  Warblade cannot use this maneuver to bypass the //
//  use of a swift action to recover maneuvers.     //
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
		SendMessageToPC(oPC, "<color=red>You can only use Quicksilver Motion on yourself.</color>");
		return;
	}

	if (GetCurrentAction(oPC) != ACTION_MOVETOPOINT)
	{
		SendMessageToPC(oPC, "<color=red>Quicksilver Motion can only be initiated during a move action.</color>");
		return;
	}

	if (GetLocalInt(oToB, "WarbladeRecovery") == 1)
	{
		SendMessageToPC(oPC, "<color=red>Quicksilver Motion cannot be used in conjunction with the Warblade's maneuver recovery method.</color>");
		return;
	}

	if (GetLocalInt(oToB, "Quicksilver") == 0)
	{
		effect eQuick = EffectMovementSpeedIncrease(99);
		effect eSilver = EffectVisualEffect(VFX_TOB_QUICKSILVER);
		eQuick = ExtraordinaryEffect(eQuick);

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSilver, oPC, 6.0f);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eQuick, oPC, 6.0f);
		RunSwiftAction(69, ""); //Not run as a boost to prevent interference with Dual Boost.
		ExpendManeuver(69, "B");
	}
	else SendMessageToPC(oPC, "<color=red>You have already expended your use of Quicksilver Motion for this round.</color>");
}