// 'gui_mrop_ok'
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
// v.beta 93 april 19 - conform changes.
// ~ 2016 ~
// v.beta.96 sept 9 - description & format.
// ~ 2020 ~
// v.beta.97a march 14 - reformat.
//
//
// meta-Rod of Preparation - GUI Okay Callback
// -----------------------------------------------------
// Does the appropriate action when the user clicks the Okay button.


#include "mrop_inc_gui"

void main()
{
	object oPC     = GetControlledCharacter(OBJECT_SELF);
	object oRod    = GetGUIItem(oPC);
	object oTarget = GetGUITarget(oPC);

	switch (GetGUIAction(oPC))
	{
		case MROP_FLG_MESSAGEBOX_SETUP: // User has chosen to cast As Actions.
			SetLocalInt(oRod, MROP_VAR_NOT_INSTANT, TRUE);
			ShowTutorial(oPC, oRod, MROP_MSG_WELCOME);
			break;

		case MROP_FLG_MESSAGEBOX_DESTROY: // User requested to destroy all preparations and book.
			ShowDestroyConfirmation(oPC, oRod, oTarget);
			break;

		case MROP_FLG_MESSAGEBOX_DELETE: // User confirmed to destroy all preparations and book.
			DestroyObject(oTarget);
			break;

		case MROP_FLG_MESSAGEBOX_DELETE_PAGE: // User wants to delete a preparation page.
			DestroyObject(oRod);
			break;

//		case MROP_FLG_MESSAGEBOX_EMPTY:
//			break;
	}
}
