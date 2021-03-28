//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 5/18/2009								//
//	Title: bot9s_cr_recovery					//
//	Description: Library file for the scripts	//
//	that govern the Crusader's recovery method.	//
//	The big long lists are used instead of a	//
//	while loop because these functions are run	//
//	from within one and doing that usually makes//
//	the script cry.								//
//////////////////////////////////////////////////

#include "bot9s_inc_variables"

// Prototypes

// Finds the number of readied maneuvers of each type.
void GenerateReadiedManeuvers(string sType, int nBoxes, object oPC = OBJECT_SELF);

// Generates the listbox of a random readied strike, boost, or counter.
string RandomManeuver(object oToB);

// Disables all of the listboxes on the Crusader's Quickstrike screen.
void DisableAll(object oPC = OBJECT_SELF);

// Clears all of the RandomRecovery# Flags.
void ClearRecoveryFlags(object oPC = OBJECT_SELF);

// Returns TRUE if all RandomRecoveryFlags are cleared.
int CheckWithheldManeuvers(object oPC = OBJECT_SELF);

// Clears sListBox from the RandomRecoveryFlag# it has been set in.
void ClearCrusaderRecoveryFlag(string sListBox, object oPC = OBJECT_SELF);

// Flags sListBox as being used so that we don't attempt to disable the same box later.
void SetDisabledStatus(string sListBox, int nTotal, object oPC = OBJECT_SELF);

// Functions

// Finds the number of readied maneuvers of each type.
void GenerateReadiedManeuvers(string sType, int nBoxes, object oPC = OBJECT_SELF)
{
	object oToB = GetItemPossessedBy(oPC, "tob");

	int i;

	i = 1;

	while (i <= nBoxes)
	{
		if (GetLocalInt(oToB, "BlueBox" + sType + IntToString(i) + "_CR") > 0)
		{
			SetLocalInt(oToB, sType + "CrLimit", i);
			i++;
		}
		else break;
	}
}

// Generates the listbox of a random readied strike, boost, or counter.
string RandomManeuver(object oToB)
{
	int nBoostLimit = GetLocalInt(oToB, "BCrLimit");
	int nCounterLimit = GetLocalInt(oToB, "CCrLimit");
	int nStrikeLimit = GetLocalInt(oToB, "STRCrLimit");

	string sType;
	int nLimit;

	// Double check to make sure that we actually have maneuvers readied for the type.
	if (nStrikeLimit == 0 && nCounterLimit == 0)
	{
		nLimit = nBoostLimit;
		sType = "BOOST";
	}
	else if (nStrikeLimit == 0 && nBoostLimit == 0)
	{
		nLimit = nCounterLimit;
		sType = "COUNTER";
	}
	else if (nCounterLimit == 0 && nBoostLimit == 0)
	{
		nLimit = nStrikeLimit;
		sType = "STRIKE";
	}
	else if (nStrikeLimit == 0)
	{
		int nRandomType = d2(1);

		switch (nRandomType)
		{
			case 1:	nLimit = nCounterLimit;	sType = "COUNTER";	break;
			case 2:	nLimit = nBoostLimit;	sType = "BOOST";	break;
		}
	}
	else if (nCounterLimit == 0)
	{
		int nRandomType = d2(1);

		switch (nRandomType)
		{
			case 1:	nLimit = nStrikeLimit;	sType = "STRIKE";	break;
			case 2:	nLimit = nBoostLimit;	sType = "BOOST";	break;
		}
	}
	else if (nBoostLimit == 0)
	{
		int nRandomType = d2(1);

		switch (nRandomType)
		{
			case 1:	nLimit = nStrikeLimit;	sType = "STRIKE";	break;
			case 2:	nLimit = nCounterLimit;	sType = "COUNTER";	break;
		}
	}
	else
	{
		int nRandomType = d3(1);

		switch (nRandomType)
		{
			case 1:	nLimit = nStrikeLimit;	sType = "STRIKE";	break;
			case 2:	nLimit = nCounterLimit;	sType = "COUNTER";	break;
			case 3:	nLimit = nBoostLimit;	sType = "BOOST";	break;
		}
	}

	RandomBetween(1, nLimit); // Random is not used because we're not using zero.

	int nRoll = GetLocalInt(oToB, "RandomNumber");
	string sNumber;

	switch (nRoll)
	{
		case 1:	sNumber = "ONE";		break;
		case 2: sNumber = "TWO";		break;
		case 3: sNumber = "THREE";		break;
		case 4: sNumber = "FOUR";		break;
		case 5: sNumber = "FIVE";		break;
		case 6: sNumber = "SIX";		break;
		case 7: sNumber = "SEVEN";		break;
		case 8: sNumber = "EIGHT";		break;
		case 9: sNumber = "NINE";		break;
		case 10:sNumber = "TEN";		break;
		case 11:sNumber = "ELEVEN";		break;
		case 12:sNumber = "TWELVE";		break;
		case 13:sNumber = "THRITEEN";	break;
		case 14:sNumber = "FOURTEEN";	break;
		case 15:sNumber = "FIFTEEN";	break;
		case 16:sNumber = "SIXTEEN";	break;
		case 17:sNumber = "SEVENTEEN";	break;
		case 18:sNumber = "EIGHTEEN";	break;
		case 19:sNumber = "NINETEEN";	break;
		case 20:sNumber = "TWENTY";		break;
	}

	string sReturn = sType + "_" + sNumber;
	return sReturn;
}

// Disables all of the listboxes on the Crusader's Quickstrike screen.
void DisableAll(object oPC = OBJECT_SELF)
{
	string sScreen = "SCREEN_QUICK_STRIKE_CR";
	object oToB = GetItemPossessedBy(oPC, "tob");
	string sRRF = "RandomRecoveryFlag";
	int i;

	i = 1;

	if (GetLocalInt(oToB, "BlueBoxSTR1_CR") > 0) // The extra checks improve preformance.
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_ONE", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_ONE");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR2_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TWO", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_TWO");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR3_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_THREE", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_THREE");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR4_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FOUR", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_FOUR");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR5_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FIVE", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_FIVE");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR6_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SIX", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_SIX");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR7_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SEVEN", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_SEVEN");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR8_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_EIGHT", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_EIGHT");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR9_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_NINE", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_NINE");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR10_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TEN", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_TEN");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR11_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_ELEVEN", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_ELEVEN");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR12_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TWELVE", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_TWELVE");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR13_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_THIRTEEN", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_THIRTEEN");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR14_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FOURTEEN", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_FOURTEEN");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR15_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FIFTEEN", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_FIFTEEN");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR16_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SIXTEEN", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_SIXTEEN");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR17_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SEVENTEEN", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_SEVENTEEN");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR18_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_EIGHTEEN", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_EIGHTEEN");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR19_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_NINETEEN", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_NINETEEN");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR20_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TWENTY", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_TWENTY");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxB1_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_ONE", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "BOOST_ONE");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxB2_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_TWO", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "BOOST_TWO");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxB3_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_THREE", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "BOOST_THREE");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxB4_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_FOUR", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "BOOST_FOUR");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxB5_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_FIVE", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "BOOST_FIVE");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxB6_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_SIX", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "BOOST_SIX");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxB7_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_SEVEN", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "BOOST_SEVEN");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxB8_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_EIGHT", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "BOOST_EIGHT");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxB9_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_NINE", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "BOOST_NINE");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxB10_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_TEN", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "BOOST_TEN");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxC1_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_ONE", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "COUNTER_ONE");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxC2_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_TWO", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "COUNTER_TWO");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxC3_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_THREE", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "COUNTER_THREE");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxC4_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_FOUR", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "COUNTER_FOUR");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxC5_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_FIVE", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "COUNTER_FIVE");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxC6_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_SIX", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "COUNTER_SIX");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxC7_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_SEVEN", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "COUNTER_SEVEN");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxC8_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_EIGHT", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "COUNTER_EIGHT");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxC9_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_NINE", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "COUNTER_NINE");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxC10_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_TEN", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "COUNTER_TEN");
		i++;
	}
}

// Clears all of the RandomRecovery# Flags.
void ClearRecoveryFlags(object oPC = OBJECT_SELF)
{
	object oToB = GetItemPossessedBy(oPC, "tob");

	SetLocalString(oToB, "RandomRecoveryFlag1", "");
	SetLocalString(oToB, "RandomRecoveryFlag2", "");
	SetLocalString(oToB, "RandomRecoveryFlag3", "");
	SetLocalString(oToB, "RandomRecoveryFlag4", "");
	SetLocalString(oToB, "RandomRecoveryFlag5", "");
	SetLocalString(oToB, "RandomRecoveryFlag6", "");
	SetLocalString(oToB, "RandomRecoveryFlag7", "");
	SetLocalString(oToB, "RandomRecoveryFlag8", "");
	SetLocalString(oToB, "RandomRecoveryFlag9", "");
	SetLocalString(oToB, "RandomRecoveryFlag10", "");
	SetLocalString(oToB, "RandomRecoveryFlag11", "");
	SetLocalString(oToB, "RandomRecoveryFlag12", "");
	SetLocalString(oToB, "RandomRecoveryFlag13", "");
	SetLocalString(oToB, "RandomRecoveryFlag14", "");
	SetLocalString(oToB, "RandomRecoveryFlag15", "");
	SetLocalString(oToB, "RandomRecoveryFlag16", "");
	SetLocalString(oToB, "RandomRecoveryFlag17", "");
	SetLocalString(oToB, "RandomRecoveryFlag18", "");
	SetLocalString(oToB, "RandomRecoveryFlag19", "");
	SetLocalString(oToB, "RandomRecoveryFlag20", "");
	SetLocalString(oToB, "RandomRecoveryFlag21", "");
	SetLocalString(oToB, "RandomRecoveryFlag22", "");
	SetLocalString(oToB, "RandomRecoveryFlag23", "");
	SetLocalString(oToB, "RandomRecoveryFlag24", "");
	SetLocalString(oToB, "RandomRecoveryFlag25", "");
	SetLocalString(oToB, "RandomRecoveryFlag26", "");
	SetLocalString(oToB, "RandomRecoveryFlag27", "");
	SetLocalString(oToB, "RandomRecoveryFlag28", "");
	SetLocalString(oToB, "RandomRecoveryFlag29", "");
	SetLocalString(oToB, "RandomRecoveryFlag30", "");
	SetLocalString(oToB, "RandomRecoveryFlag31", "");
	SetLocalString(oToB, "RandomRecoveryFlag32", "");
	SetLocalString(oToB, "RandomRecoveryFlag33", "");
	SetLocalString(oToB, "RandomRecoveryFlag34", "");
	SetLocalString(oToB, "RandomRecoveryFlag35", "");
	SetLocalString(oToB, "RandomRecoveryFlag36", "");
	SetLocalString(oToB, "RandomRecoveryFlag37", "");
	SetLocalString(oToB, "RandomRecoveryFlag38", "");
	SetLocalString(oToB, "RandomRecoveryFlag39", "");
	SetLocalString(oToB, "RandomRecoveryFlag40", "");
}

// Returns TRUE if all RandomRecoveryFlags are cleared.
int CheckWithheldManeuvers(object oPC = OBJECT_SELF)
{
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nTotal = GetLocalInt(oToB, "CrLimit");

	string s1 = GetLocalString(oToB, "RandomRecoveryFlag1");
	string s2 = GetLocalString(oToB, "RandomRecoveryFlag2");
	string s3 = GetLocalString(oToB, "RandomRecoveryFlag3");
	string s4 = GetLocalString(oToB, "RandomRecoveryFlag4");
	string s5 = GetLocalString(oToB, "RandomRecoveryFlag5");
	string s6 = GetLocalString(oToB, "RandomRecoveryFlag6");
	string s7 = GetLocalString(oToB, "RandomRecoveryFlag7");
	string s8 = GetLocalString(oToB, "RandomRecoveryFlag8");
	string s9 = GetLocalString(oToB, "RandomRecoveryFlag9");
	string s10 = GetLocalString(oToB, "RandomRecoveryFlag10");
	string s11 = GetLocalString(oToB, "RandomRecoveryFlag11");
	string s12 = GetLocalString(oToB, "RandomRecoveryFlag12");
	string s13 = GetLocalString(oToB, "RandomRecoveryFlag13");
	string s14 = GetLocalString(oToB, "RandomRecoveryFlag14");
	string s15 = GetLocalString(oToB, "RandomRecoveryFlag15");
	string s16 = GetLocalString(oToB, "RandomRecoveryFlag16");
	string s17 = GetLocalString(oToB, "RandomRecoveryFlag17");
	string s18 = GetLocalString(oToB, "RandomRecoveryFlag18");
	string s19 = GetLocalString(oToB, "RandomRecoveryFlag19");
	string s20 = GetLocalString(oToB, "RandomRecoveryFlag20");
	string s21 = GetLocalString(oToB, "RandomRecoveryFlag21");
	string s22 = GetLocalString(oToB, "RandomRecoveryFlag22");
	string s23 = GetLocalString(oToB, "RandomRecoveryFlag23");
	string s24 = GetLocalString(oToB, "RandomRecoveryFlag24");
	string s25 = GetLocalString(oToB, "RandomRecoveryFlag25");
	string s26 = GetLocalString(oToB, "RandomRecoveryFlag26");
	string s27 = GetLocalString(oToB, "RandomRecoveryFlag27");
	string s28 = GetLocalString(oToB, "RandomRecoveryFlag28");
	string s29 = GetLocalString(oToB, "RandomRecoveryFlag29");
	string s30 = GetLocalString(oToB, "RandomRecoveryFlag30");
	string s31 = GetLocalString(oToB, "RandomRecoveryFlag31");
	string s32 = GetLocalString(oToB, "RandomRecoveryFlag32");
	string s33 = GetLocalString(oToB, "RandomRecoveryFlag33");
	string s34 = GetLocalString(oToB, "RandomRecoveryFlag34");
	string s35 = GetLocalString(oToB, "RandomRecoveryFlag35");
	string s36 = GetLocalString(oToB, "RandomRecoveryFlag36");
	string s37 = GetLocalString(oToB, "RandomRecoveryFlag37");
	string s38 = GetLocalString(oToB, "RandomRecoveryFlag38");
	string s39 = GetLocalString(oToB, "RandomRecoveryFlag39");
	string s40 = GetLocalString(oToB, "RandomRecoveryFlag40");

	if (nTotal == 1)
	{
		if (s1 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 2)
	{
		if (s1 == "" && s2 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 3)
	{
		if (s1 == "" && s2 == "" && s3 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 4)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 5)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 6)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 7)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 8)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 9)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 10)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 11)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 12)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 13)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 14)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 15)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 16)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 17)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 18)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 19)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 20)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 21)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 22)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 23)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 24)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 25)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 26)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 27)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "" 
		&& s27 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 28)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "" 
		&& s27 == "" && s28 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 29)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "" 
		&& s27 == "" && s28 == "" && s29 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 30)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "" 
		&& s27 == "" && s28 == "" && s29 == "" && s30 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 31)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "" 
		&& s27 == "" && s28 == "" && s29 == "" && s30 == "" && s31 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 32)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "" 
		&& s27 == "" && s28 == "" && s29 == "" && s30 == "" && s31 == "" && s32 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 33)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "" 
		&& s27 == "" && s28 == "" && s29 == "" && s30 == "" && s31 == "" && s32 == "" 
		&& s33 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 34)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "" 
		&& s27 == "" && s28 == "" && s29 == "" && s30 == "" && s31 == "" && s32 == "" 
		&& s33 == "" && s34 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 35)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "" 
		&& s27 == "" && s28 == "" && s29 == "" && s30 == "" && s31 == "" && s32 == "" 
		&& s33 == "" && s34 == "" && s35 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 36)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "" 
		&& s27 == "" && s28 == "" && s29 == "" && s30 == "" && s31 == "" && s32 == "" 
		&& s33 == "" && s34 == "" && s35 == "" && s36 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 37)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "" 
		&& s27 == "" && s28 == "" && s29 == "" && s30 == "" && s31 == "" && s32 == "" 
		&& s33 == "" && s34 == "" && s35 == "" && s36 == "" && s37 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 38)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "" 
		&& s27 == "" && s28 == "" && s29 == "" && s30 == "" && s31 == "" && s32 == "" 
		&& s33 == "" && s34 == "" && s35 == "" && s36 == "" && s37 == "" && s38 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 39)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "" 
		&& s27 == "" && s28 == "" && s29 == "" && s30 == "" && s31 == "" && s32 == "" 
		&& s33 == "" && s34 == "" && s35 == "" && s36 == "" && s37 == "" && s38 == ""
		&& s39 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 40)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "" 
		&& s27 == "" && s28 == "" && s29 == "" && s30 == "" && s31 == "" && s32 == "" 
		&& s33 == "" && s34 == "" && s35 == "" && s36 == "" && s37 == "" && s38 == ""
		&& s39 == "" && s40 == "")
		{
			return TRUE;
		}
	}
	return FALSE;
}

// Clears sListBox from the RandomRecoveryFlag# it has been set in.
void ClearCrusaderRecoveryFlag(string sListBox, object oPC = OBJECT_SELF)
{
	object oToB = GetItemPossessedBy(oPC, "tob");

	if (GetLocalString(oToB, "RandomRecoveryFlag1") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag1", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag2") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag2", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag3") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag3", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag4") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag4", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag5") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag5", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag6") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag6", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag7") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag7", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag8") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag8", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag9") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag9", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag10") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag10", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag11") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag11", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag12") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag12", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag13") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag13", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag14") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag14", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag15") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag15", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag16") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag16", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag17") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag17", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag18") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag18", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag19") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag19", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag20") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag20", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag21") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag21", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag22") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag22", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag23") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag23", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag24") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag24", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag25") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag25", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag26") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag26", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag27") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag27", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag28") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag28", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag29") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag29", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag30") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag30", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag31") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag31", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag32") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag32", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag33") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag33", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag34") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag34", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag35") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag35", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag36") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag36", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag37") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag37", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag38") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag38", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag39") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag39", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag40") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag40", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}

	if (CheckWithheldManeuvers() == TRUE)
	{
		SetLocalInt(oToB, "RRFCleared", 1);
	}
}

// Flags sListBox as being used so that we don't attempt to disable the same box later.
void SetDisabledStatus(string sListBox, int nTotal, object oPC = OBJECT_SELF)
{
	object oToB = GetItemPossessedBy(oPC, "tob");
	string sScreen = "SCREEN_QUICK_STRIKE_CR";

	if ((GetLocalString(oToB, "RandomRecoveryFlag1") == "") && (1 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag1", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag2") == "") && (2 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag2", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag3") == "") && (3 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag3", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag4") == "") && (4 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag4", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag5") == "") && (5 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag5", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag6") == "") && (6 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag6", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag7") == "") && (7 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag7", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag8") == "") && (8 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag8", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag9") == "") && (9 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag9", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag10") == "") && (10 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag10", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag11") == "") && (11 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag11", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag12") == "") && (12 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag12", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag13") == "") && (13 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag13", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag14") == "") && (14 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag14", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag15") == "") && (15 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag15", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag16") == "") && (16 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag16", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag17") == "") && (17 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag17", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag18") == "") && (18 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag18", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag19") == "") && (19 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag19", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag20") == "") && (20 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag20", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag21") == "") && (21 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag21", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag22") == "") && (22 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag22", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag23") == "") && (23 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag23", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag24") == "") && (24 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag24", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag25") == "") && (25 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag25", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag26") == "") && (26 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag26", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag27") == "") && (27 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag27", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag28") == "") && (28 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag28", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag29") == "") && (29 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag29", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag30") == "") && (30 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag30", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag31") == "") && (31 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag31", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag32") == "") && (32 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag32", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag33") == "") && (33 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag33", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag34") == "") && (34 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag34", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag35") == "") && (35 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag35", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag36") == "") && (36 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag36", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag37") == "") && (37 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag37", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag38") == "") && (38 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag38", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag39") == "") && (39 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag39", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag40") == "") && (40 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag40", sListBox);
	}
}