////////////////////////////////////////////////////////////
//	Author: Drammel										  //
//	Date: 5/8/2009										  //
//	Name: gui_wbl_recovery								  //
//	Description: Allows the Warblade to recover all of his//
//	expended maneuvers.									  //
////////////////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void WBLRecoverAllManeuvers(object oPC, object oToB, string sScreen)
{
	string sClass = GetStringRight(sScreen, 3);

	if (GetLocalInt(oToB, "BlueBoxSTR1" + sClass) > 0) // The extra checks improve preformance.
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_ONE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR2" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TWO", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR3" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_THREE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR4" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FOUR", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR5" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FIVE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR6" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SIX", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR7" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SEVEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR8" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_EIGHT", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR9" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_NINE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR10" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR11" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_ELEVEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR12" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TWELVE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR13" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_THIRTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR14" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FOURTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR15" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FIFTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR16" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SIXTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR17" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SEVENTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR18" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_EIGHTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR19" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_NINETEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR20" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TWENTY", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB1" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_ONE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB2" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_TWO", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB3" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_THREE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB4" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_FOUR", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB5" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_FIVE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB6" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_SIX", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB7" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_SEVEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB8" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_EIGHT", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB9" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_NINE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB10" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_TEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC1" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_ONE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC2" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_TWO", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC3" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_THREE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC4" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_FOUR", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC5" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_FIVE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC6" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_SIX", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC7" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_SEVEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC8" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_EIGHT", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC9" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_NINE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC10" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_TEN", FALSE);
	}
}

void WarbladeRecovery(object oPC, object oToB)
{
	vector vStart = GetPosition(oPC);

	RunSwiftAction(222, "");
	SetGUIObjectDisabled(oPC, "SCREEN_MARTIAL_MENU_WB", "RECOVERY_IMAGE", TRUE);
	DelayCommand(6.0f, SetGUIObjectDisabled(oPC, "SCREEN_MARTIAL_MENU_WB", "RECOVERY_IMAGE", FALSE));
	DelayCommand(6.0f, WBLRecoverAllManeuvers(oPC, oToB, "SCREEN_QUICK_STRIKE_WB"));

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

void main()
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

	if ((GetCurrentAction(oPC) == ACTION_ATTACKOBJECT) && (!GetWeaponRanged(oWeapon)))
	{
		object oToB = GetItemPossessedBy(oPC, "tob");

		if ((GetLocalInt(oToB, "Swift") == 0) && (GetLocalInt(oToB, "Quicksilver") == 0))
		{
			SetLocalInt(oToB, "WarbladeRecovery", 1);
			DelayCommand(6.0f, SetLocalInt(oToB, "WarbladeRecovery", 0));
			WarbladeRecovery(oPC, oToB);
		}
	}
}