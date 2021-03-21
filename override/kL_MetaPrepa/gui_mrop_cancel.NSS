// 'gui_mrop_cancel'
//
// LostCreation
// Rod of Preparation
// Version 0.04 (preview 2):
// 2010 april 1
//
// kevL's, 2012 july 2
// MetaRod of Preparations
// v.beta.5
// v.beta.6, july 11
// v.beta.7, july 14
// v.beta.8, july 25
// ~ 2013 ~
// v.beta.93 april 19 - conform changes.
// ~ 2016 ~
// v.beta.96 sept 9 - description & format.
// ~ 2020 ~
// v.beta.97a march 14 - reformat.
//
//
// meta-Rod of Preparation - GUI Cancel Callback
// -----------------------------------------------------
// Does the appropriate action when the user clicks the Cancel button.


#include "mrop_inc_gui"

void main()
{
	object oPC     = GetControlledCharacter(OBJECT_SELF);
	object oRod    = GetGUIItem(oPC);
	object oTarget = GetGUITarget(oPC);

	switch (GetGUIAction(oPC))
	{
		case MROP_FLG_MESSAGEBOX_SETUP: // User has chosen to cast as Fast.
			DeleteLocalInt(oRod, MROP_VAR_NOT_INSTANT);
			ShowTutorial(oPC, oRod, MROP_MSG_WELCOME);
			break;

//		case MROP_FLG_MESSAGEBOX_DESTROY: // dismiss the GUI ...
//		case MROP_FLG_MESSAGEBOX_DELETE:
//		case MROP_FLG_MESSAGEBOX_DELETE_PAGE:
//		case MROP_FLG_MESSAGEBOX_EMPTY:
//			break;
	}
}
