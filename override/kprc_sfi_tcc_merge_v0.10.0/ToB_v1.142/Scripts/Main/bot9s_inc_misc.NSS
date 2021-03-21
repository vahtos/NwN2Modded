//////////////////////////////////
//	Author: Drammel				//
//	Date: 3/29/2009				//
//	Title: bot9s_inc_misc		//
//	Description: Misc functions.//
//////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"

//Prototype

// Targeting function for strike maneuvers.  This function takes object oTarget from gui_execute_strike and 
// stores it on the Tome of Battle object as "Target" + nStrike, where nStrike is the row index of the strike in
// maneuvers.2da.  This is done to prevent the action queue from assigning the wrong target to a strike.
// -nStrike: The row number of the strike in maneuvers.2da.
// -oTarget: Data of the object targeted GUI-side by UIObject_Input_ActionTargetScript.
void IndexStrikeTarget(object oToB, int nStrike, object oTarget);

// Placing a location value on an item tends to crash NWN2 so the location information here is stored in its 
// raw state as three floats.  The information is stored as nManeuver's index row numer on maneuvers.2da in the
// format of #x, #y, #z.
// -nManeuver: A maneuver of any type.
// -fx: The location's x position.
// -fy: The location's y position.
// -fz: The location's z position.
void IndexManeuverPosition(object oToB, int nManeuver, float fx, float fy, float fz);

//  Marks nRow as the next strike to be activated by the script activate_strike.
//  This is similar to the action queue, but works outside of it.  Strikes are
//  only removed from the action queue after they've been passed through the
//  script activate_strike or when the player fails to reach attacking range.
void SetStrike(int nRow);

// Switches the mask buttons for the Swordsage maneuver recovery method on and off.
void ToggleMasks(int bToggle, string sScreen);

// Recovers all maneuvers.  Intended use is for out of combat, the feat Adaptive
// Style and for use in the Warblade's recovery method.
// -sScreen: Xml screen for which we are recovering maneuvers.
// -bCheckLoc: For Warblade recovery only.  Checks the Warblade's current location against vStart.  If the
// Warblade is more than five feet away from vStart maneuver recovery is prevented.
void RecoverAllManeuvers(string sScreen, int bCheckLoc = FALSE, vector vStart=[0.0,0.0,0.0]);

// Checks for stances that bypass the uneven terrain rule for charging.
int CheckStanceChargeRules(object oToB);

// Returns an itemproperty from an item based on a desired itemproperty constant.
// nSubType by default ignores subtypes until a constant is entered as its value.
itemproperty GetItemPropertyByConst(int nItemProp, object oItem, int nSubType = 0);

//Returns the integer value of nSubType if it matches the subtype of the test item.
int GetItemPropertySubTypeByConst(int nItemProp, object oItem, int nSubType = -1);

// Returns a constant from an item based on a desired itemproperty constant.
// nSubType by default ignores subtypes until a constant is entered as its value.
int GetItemPropertyConst(itemproperty ip, int nItemProp, object oItem, int nSubType = -1);

// Tracks movement for the Strike Desert Tempest.  If the player has stopped
// moving, this function sets the strike to an inactive status.
void DoDesertTempestLoc();

// Runs the attack rolls and damage for the maneuver Desert Tempest while the 
// PC is moving by his opponents.  This maneuver has a cap of ten opponents.
void DoDesertTempest(object oPC, object oToB, float fRange);

// Determines if a Crusader has readied all aviablable maneuvers.
// Returns TRUE if the crusader has.
int CheckRedCrusader(object oPC, object oToB);

// Removes the speed bonus and AC pentaly for the charge action.
void RemoveChargeSpeed(object oPC);

//Functions

// Targeting function for strike maneuvers.  This function takes object oTarget from gui_execute_strike and 
// stores it on the Tome of Battle object as "Target" + nStrike, where nStrike is the row index of the strike in
// maneuvers.2da.  This is done to prevent the action queue from assigning the wrong target to a strike.
// -nStrike: The row number of the strike in maneuvers.2da.
// -oTarget: Data of the object targeted GUI-side by UIObject_Input_ActionTargetScript.
void IndexStrikeTarget(object oToB, int nStrike, object oTarget)
{
	SetLocalObject(oToB, "Target" + IntToString(nStrike), oTarget);
}

// Placing a location value on an item tends to crash NWN2 so the location information here is stored in its 
// raw state as three floats.  The information is stored as nManeuver's index row numer on maneuvers.2da in the
// format of #x, #y, #z.
// -nManeuver: A maneuver of any type.
// -fx: The location's x position.
// -fy: The location's y position.
// -fz: The location's z position.
void IndexManeuverPosition(object oToB, int nManeuver, float fx, float fy, float fz)
{
	SetLocalFloat(oToB, IntToString(nManeuver) + "x", fx);
	SetLocalFloat(oToB, IntToString(nManeuver) + "y", fy);
	SetLocalFloat(oToB, IntToString(nManeuver) + "z", fz);
}

//  Marks nRow as the next strike to be activated by the script activate_strike.
//  This is similar to the action queue, but works outside of it.  Strikes are
//  only removed from the action queue after they've been passed through the
//  script activate_strike or when the player fails to reach attacking range.
void SetStrike(int nRow)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");
	int i;

	i = 0;

	SetLocalInt(oToB, "Strike0", 1);

	while (GetLocalInt(oToB, "Strike" + IntToString(i)) > 0)
	{
		i++;

		if (GetLocalInt(oToB, "Strike" + IntToString(i)) == 0)
		{
			SetLocalInt(oToB, "Strike" + IntToString(i), nRow);
			SetLocalInt(oToB, "HighStrike", i);
			break;
		}
	}
}

// Switches the mask buttons for the Swordsage maneuver recovery method on and off.
void ToggleMasks(int bToggle, string sScreen)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);

	SetGUIObjectHidden(oPC, sScreen, "STRIKE_ONE_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_TWO_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_THREE_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_FOUR_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_FIVE_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_SIX_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_SEVEN_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_EIGHT_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_NINE_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_TEN_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_ELEVEN_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_TWELVE_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_THIRTEEN_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_FOURTEEN_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_FIFTEEN_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_SIXTEEN_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_SEVENTEEN_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_EIGHTEEN_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_NINETEEN_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_TWENTY_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "BOOST_ONE_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "BOOST_TWO_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "BOOST_THREE_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "BOOST_FOUR_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "BOOST_FIVE_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "BOOST_SIX_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "BOOST_SEVEN_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "BOOST_EIGHT_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "BOOST_NINE_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "BOOST_TEN_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "COUNTER_ONE_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "COUNTER_TWO_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "COUNTER_THREE_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "COUNTER_FOUR_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "COUNTER_FIVE_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "COUNTER_SIX_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "COUNTER_SEVEN_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "COUNTER_EIGHT_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "COUNTER_NINE_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "COUNTER_TEN_MASK", bToggle);
}

// Recovers all maneuvers.  Intended use is for out of combat, the feat Adaptive
// Style and for use in the Warblade's recovery method.
// -sScreen: Xml screen for which we are recovering maneuvers.
// -bCheckLoc: For Warblade recovery only.  Checks the Warblade's current location against vStart.  If the
// Warblade is more than five feet away from vStart maneuver recovery is prevented.
void RecoverAllManeuvers(string sScreen, int bCheckLoc = FALSE, vector vStart=[0.0,0.0,0.0])
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");
	string sClass = GetStringRight(sScreen, 3);

	if (sClass == "_CR")
	{
		SetLocalInt(oToB, "EncounterR1", 0);
		return;
	}

	if (bCheckLoc == TRUE)
	{
		location lStart = Location(GetArea(oPC), vStart, GetFacing(oPC));
		location lPC = GetLocation(oPC);

		if (GetDistanceBetweenLocations(lStart, lPC) > FeetToMeters(5.0f))
		{
			SendMessageToPC(oPC, "<color=red>Warblade maneuver recovery was canceled by movement.</color>");
			return;
		}
	}

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

// Checks for stances that bypass the uneven terrain rule for charging.
int CheckStanceChargeRules(object oToB)
{
	int nStance = GetLocalInt(oToB, "Stance");
	int nStance2 = GetLocalInt(oToB, "Stance2");
	int nReturn;

	if (nStance == STANCE_STEP_OF_THE_WIND || nStance2 == STANCE_STEP_OF_THE_WIND)
	{
		nReturn = TRUE;
	}
	else nReturn = FALSE;

	return nReturn;
}

// Returns an itemproperty from an item based on a desired itemproperty constant.
// nSubType by default ignores subtypes until a constant is entered as its value.
itemproperty GetItemPropertyByConst(int nItemProp, object oItem, int nSubType = -1)
{
	itemproperty iNull = ItemPropertyNoDamage();
    itemproperty ip = GetFirstItemProperty(oItem);
	int nSub = GetItemPropertySubType(ip);
	
    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) == nItemProp)
        {
			if (nSubType == -1 || nSub == nSubType)
			{
            	return ip;
			}
        }
        ip = GetNextItemProperty(oItem);
		nSub = GetItemPropertySubType(ip);
    }
    return iNull; //47, No combat damage property.
}

//Returns the integer value of nSubType if it matches the subtype of the test item.
int GetItemPropertySubTypeByConst(int nItemProp, object oItem, int nSubType = -1)
{
    itemproperty ip = GetFirstItemProperty(oItem);
	int nSub = GetItemPropertySubType(ip);
	
    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) == nItemProp)
        {
			if (nSubType == -1 || nSub == nSubType)
			{
            	return nSubType;
			}
        }
        ip = GetNextItemProperty(oItem);
		nSub = GetItemPropertySubType(ip);
    }
    return -1; // Nothing should have this subtype.
}

// Returns a constant from an item based on a desired itemproperty constant.
// nSubType by default ignores subtypes until a constant is entered as its value.
int GetItemPropertyConst(itemproperty ip, int nItemProp, object oItem, int nSubType = -1)
{
	int nSub = GetItemPropertySubType(ip);
	
	if (GetItemPropertyType(ip) == nItemProp)
	{
		if (nSubType == -1 || nSub == nSubType)
		{
           	return nItemProp;
		}
	}
    return -1;
}

// Tracks movement for the Strike Desert Tempest.  If the player has stopped
// moving, this function sets the strike to an inactive status.
void DoDesertTempestLoc()
{
	object oPC = OBJECT_SELF;
	location lPC = GetLocation(oPC);

	if (GetLocalLocation(oPC, "DesertTempestLoc") != lPC)
	{
		SetLocalLocation(oPC, "DesertTempestLoc", lPC);
		DelayCommand(0.1f, DoDesertTempestLoc());
	}
	else DeleteLocalInt(oPC, "DesertTempestActive");
}

// Runs the attack rolls and damage for the maneuver Desert Tempest while the 
// PC is moving by his opponents.  This maneuver has a cap of ten opponents.
void DoDesertTempest(object oPC, object oToB, float fRange)
{
	if (GetLocalInt(oPC, "DesertTempestActive") == 1)
	{
		location lPC = GetLocation(oPC);
		object oCreature;
		float fDist;
		int n;

		oCreature = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);
		n = 1;

		while (GetIsObjectValid(oCreature))
		{
			fDist = GetDistanceBetween(oPC, oCreature);

			if ((oCreature != oPC) && (GetLocalInt(oCreature, "DesertTempestHit") == 0) && (GetIsReactionTypeHostile(oCreature, oPC)) && (fDist <= fRange))
			{
				SetLocalInt(oCreature, "DesertTempestHit", 1);
				AssignCommand(oCreature, DelayCommand(6.0f, DeleteLocalInt(oCreature, "DesertTempestHit")));
				SetLocalObject(oToB, "DesertTempestFoe" + IntToString(n), oCreature);
				n++;

				if (n > 10)
				{
					break;
				}
			}
			oCreature = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);
		}

		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		object oFoe1 = GetLocalObject(oToB, "DesertTempestFoe1");

		if (GetIsObjectValid(oFoe1))
		{
			int nHit1 = StrikeAttackRoll(oWeapon, oFoe1);

			StrikeAttackSound(oWeapon, oFoe1, nHit1, 0.0f);
			StrikeWeaponDamage(oWeapon, nHit1, oFoe1);
			DelayCommand(0.1f, DeleteLocalObject(oToB, "DesertTempestFoe1"));
		}

		object oFoe2 = GetLocalObject(oToB, "DesertTempestFoe2");

		if (GetIsObjectValid(oFoe2))
		{
			int nHit2 = StrikeAttackRoll(oWeapon, oFoe2);

			StrikeAttackSound(oWeapon, oFoe2, nHit2, 0.0f);
			StrikeWeaponDamage(oWeapon, nHit2, oFoe2);
			DelayCommand(0.1f, DeleteLocalObject(oToB, "DesertTempestFoe2"));
		}

		object oFoe3 = GetLocalObject(oToB, "DesertTempestFoe3");

		if (GetIsObjectValid(oFoe3))
		{
			int nHit3 = StrikeAttackRoll(oWeapon, oFoe3);

			StrikeAttackSound(oWeapon, oFoe3, nHit3, 0.0f);
			StrikeWeaponDamage(oWeapon, nHit3, oFoe3);
			DelayCommand(0.1f, DeleteLocalObject(oToB, "DesertTempestFoe3"));
		}

		object oFoe4 = GetLocalObject(oToB, "DesertTempestFoe4");

		if (GetIsObjectValid(oFoe4))
		{
			int nHit4 = StrikeAttackRoll(oWeapon, oFoe4);

			StrikeAttackSound(oWeapon, oFoe4, nHit4, 0.0f);
			StrikeWeaponDamage(oWeapon, nHit4, oFoe4);
			DelayCommand(0.1f, DeleteLocalObject(oToB, "DesertTempestFoe4"));
		}

		object oFoe5 = GetLocalObject(oToB, "DesertTempestFoe5");

		if (GetIsObjectValid(oFoe5))
		{
			int nHit5 = StrikeAttackRoll(oWeapon, oFoe5);

			StrikeAttackSound(oWeapon, oFoe5, nHit5, 0.0f);
			StrikeWeaponDamage(oWeapon, nHit5, oFoe5);
			DelayCommand(0.1f, DeleteLocalObject(oToB, "DesertTempestFoe5"));
		}

		object oFoe6 = GetLocalObject(oToB, "DesertTempestFoe6");

		if (GetIsObjectValid(oFoe6))
		{
			int nHit6 = StrikeAttackRoll(oWeapon, oFoe6);

			StrikeAttackSound(oWeapon, oFoe6, nHit6, 0.0f);
			StrikeWeaponDamage(oWeapon, nHit6, oFoe6);
			DelayCommand(0.1f, DeleteLocalObject(oToB, "DesertTempestFoe6"));
		}

		object oFoe7 = GetLocalObject(oToB, "DesertTempestFoe7");

		if (GetIsObjectValid(oFoe7))
		{
			int nHit7 = StrikeAttackRoll(oWeapon, oFoe7);

			StrikeAttackSound(oWeapon, oFoe7, nHit7, 0.0f);
			StrikeWeaponDamage(oWeapon, nHit7, oFoe7);
			DelayCommand(0.1f, DeleteLocalObject(oToB, "DesertTempestFoe7"));
		}

		object oFoe8 = GetLocalObject(oToB, "DesertTempestFoe8");

		if (GetIsObjectValid(oFoe8))
		{
			int nHit8 = StrikeAttackRoll(oWeapon, oFoe8);

			StrikeAttackSound(oWeapon, oFoe8, nHit8, 0.0f);
			StrikeWeaponDamage(oWeapon, nHit8, oFoe8);
			DelayCommand(0.1f, DeleteLocalObject(oToB, "DesertTempestFoe8"));
		}

		object oFoe9 = GetLocalObject(oToB, "DesertTempestFoe9");

		if (GetIsObjectValid(oFoe9))
		{
			int nHit9 = StrikeAttackRoll(oWeapon, oFoe9);

			StrikeAttackSound(oWeapon, oFoe9, nHit9, 0.0f);
			StrikeWeaponDamage(oWeapon, nHit9, oFoe9);
			DelayCommand(0.1f, DeleteLocalObject(oToB, "DesertTempestFoe9"));
		}

		object oFoe10 = GetLocalObject(oToB, "DesertTempestFoe10");

		if (GetIsObjectValid(oFoe10))
		{
			int nHit10 = StrikeAttackRoll(oWeapon, oFoe10);

			StrikeAttackSound(oWeapon, oFoe10, nHit10, 0.0f);
			StrikeWeaponDamage(oWeapon, nHit10, oFoe10);
			DelayCommand(0.1f, DeleteLocalObject(oToB, "DesertTempestFoe10"));
		}

		DelayCommand(1.0f, DoDesertTempest(oPC, oToB, fRange));
	}
	else
	{
		DeleteLocalObject(oToB, "DesertTempestFoe1");
		DeleteLocalObject(oToB, "DesertTempestFoe2");
		DeleteLocalObject(oToB, "DesertTempestFoe3");
		DeleteLocalObject(oToB, "DesertTempestFoe4");
		DeleteLocalObject(oToB, "DesertTempestFoe5");
		DeleteLocalObject(oToB, "DesertTempestFoe6");
		DeleteLocalObject(oToB, "DesertTempestFoe7");
		DeleteLocalObject(oToB, "DesertTempestFoe8");
		DeleteLocalObject(oToB, "DesertTempestFoe9");
		DeleteLocalObject(oToB, "DesertTempestFoe10");
	}
}

// Determines if a Crusader has readied all aviablable maneuvers.
// Returns TRUE if the crusader has.
int CheckRedCrusader(object oPC, object oToB)
{
	int nReadiedTotal = GetLocalInt(oToB, "ReadiedTotal_CR");
	int n, nRed, nReturn;
	string sRed;

	n = 1;
	nRed = 0;

	while (n < 18)
	{
		sRed = "RedBox" + IntToString(n) + "_CR";

		if (GetLocalInt(oToB, sRed) == 1)
		{
			nRed += 1;
		}

		if (nRed == nReadiedTotal)
		{
			nReturn = TRUE;
			break;
		}

		n++;
	}

	return nReturn;
}

// Removes the speed bonus and AC pentaly for the charge action.
void RemoveChargeSpeed(object oPC)
{
	effect eTest; // Remove the speed effect since we've come to a stop.
	int nSpell;

	eTest = GetFirstEffect(oPC);

	while (GetIsEffectValid(eTest))
	{
		nSpell = GetEffectSpellId(eTest);
		
		if (nSpell == 6561)
		{
			RemoveEffect(oPC, eTest);
			eTest = GetFirstEffect(oPC); // Helps to clean out supernatural effects all the way.  Or so I hear.
		}
		else eTest = GetNextEffect(oPC);
	}
}