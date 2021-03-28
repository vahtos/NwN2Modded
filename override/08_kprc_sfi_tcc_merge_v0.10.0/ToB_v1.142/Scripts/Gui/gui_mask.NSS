//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 4/21/2009								//
//	Title: gui_mask								//
//	Description: Activates the Swordsage mask	//
//	buttons for maneuver recovery.				//
//////////////////////////////////////////////////

void ToggleMasks(object oPC, int bToggle, string sScreen)
{
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

void main()
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	string sScreen = "SCREEN_MARTIAL_MENU_SS";
	string sMaskScreen = "SCREEN_QUICK_STRIKE_SS";

	FloatingTextStringOnCreature("<color=cyan>*Select a maneuver to recover!*</color>", oPC, FALSE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
	ToggleMasks(oPC, FALSE, sMaskScreen);
}