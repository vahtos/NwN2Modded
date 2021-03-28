//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 4/21/2009								//
//	Title: gui_recovery							//
//	Description: Activates a maneuver that has	//
//	been disabled via mask buttons.				//
//////////////////////////////////////////////////

#include "bot9s_inc_misc"
#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"

void main(string sClass, string sListBox)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");
	string sScreen;

	if (sClass == "___")
	{
		sScreen = "SCREEN_QUICK_STRIKE";
	}
	else sScreen = "SCREEN_QUICK_STRIKE" + sClass;

	SetGUIObjectDisabled(oPC, sScreen, sListBox, FALSE);
	ToggleMasks(TRUE, sScreen);

	if ((GetHasFeat(FEAT_VITAL_RECOVERY, oPC)) && (GetLocalInt(oToB, "VitalRecovery") == 0))
	{
		int nMax = GetMaxHitPoints(oPC);
		int nHP = GetCurrentHitPoints(oPC);
		
		if (nHP < nMax) // Won't heal when we're at full HP.
		{
			int nHitDice = GetHitDice(oPC);
			effect eHeal = ManeuverHealing(oPC, 3 + nHitDice);
			
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
			SetLocalInt(oToB, "VitalRecovery", 1);
		}
	}
}