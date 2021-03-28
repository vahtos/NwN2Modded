// 'mrop_inc_gui'
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
// v.beta.7c, july 19 - touchup message in ShowDeletePreparation()
// v.beta.8, july 25
// ~ 2013 ~
// v.beta.93 april 19 - rename ShowEraseConfirmation() to ShowDestroyConfirmation()
//                    - change 'oStore' to 'oBook'
//                    - rename ShowAddReplaceMessage() to ShowDestroyBook()
//                    - reformated Messages.
// ~ 2016 ~
// v.beta.96 sept 9 - changed "Instantly" to "Fast".
// ~ 2020 ~
// v.beta.97a march 14 - reformat.
//
//
// GUI Related functions.


#include "mrop_inc_const"

// __________________
// ------------------
// *** Prototypes ***
// __________________
// ------------------

// oItem:	The item that was activated.
// oTarget: What was clicked on.
void SetGUIAction(int iAction, object oPC, object oItem, object oTarget = OBJECT_INVALID);

// The action being completed.
int GetGUIAction(object oPC);

// Returns the item that was used to show this GUI.
object GetGUIItem(object oPC);

// Returns the GUI target item.
object GetGUITarget(object oPC);

// Shows the Delete Confirmation message.
void ShowDestroyConfirmation(object oPC, object oRod, object oBook);

// Shows the user a Setup message box.
void ShowSetupMessage(object oPC, object oRod);

// Shows the Add/Replace message.
void ShowDestroyBook(object oPC, object oRod, object oBook);

// Shows the tutorial message.
void ShowTutorial(object oPC, object oRod, string sGreet);

// Asks the user to confirm preparation delete.
void ShowDeletePreparation(object oPC, object oPrep);

// _________________
// -----------------
// *** Functions ***
// _________________
// -----------------

//
void SetGUIAction(int iAction, object oPC, object oItem, object oTarget = OBJECT_INVALID)
{
	SetLocalObject(oPC, MROP_VAR_ITEM, oItem);
	SetLocalInt(oPC, MROP_VAR_MESSAGEBOX, iAction);

	if (!GetIsObjectValid(oTarget))
		DeleteLocalObject(oPC, MROP_VAR_TARGET);
	else
		SetLocalObject(oPC, MROP_VAR_TARGET, oTarget);
}

//
int GetGUIAction(object oPC)
{
	int iAction = GetLocalInt(oPC, MROP_VAR_MESSAGEBOX);
	DeleteLocalInt(oPC, MROP_VAR_MESSAGEBOX);

	return iAction;
}

//
object GetGUIItem(object oPC)
{
	object oItem = GetLocalObject(oPC, MROP_VAR_ITEM);
	DeleteLocalObject(oPC, MROP_VAR_ITEM);

	return oItem;
}

//
object GetGUITarget(object oPC)
{
	object oTarget = GetLocalObject(oPC, MROP_VAR_TARGET);
	DeleteLocalObject(oPC, MROP_VAR_TARGET);

	return oTarget;
}

//
void ShowDestroyConfirmation(object oPC, object oRod, object oBook)
{
	SetGUIAction(MROP_FLG_MESSAGEBOX_DELETE, oPC, oRod, oBook);

	string sMessage = "<c=red>Warning!</c>\n\n"
					+ "Once you've destroyed this Book, any Pages you had written inside will"
					+ " be lost. This action cannot be undone, but a new Book can be created"
					+ " later by Activating the Rod and preparing more buffs in Learn mode.\n\n"

					+ "Are you sure you want to destroy the Book?";

	DisplayMessageBox(oPC,								// Display a message box for this PC
					  -1,								// string ref to display
					  sMessage,							// Message to display
					  "gui_mrop_ok",					// Callback for clicking the OK button
					  "gui_mrop_cancel",				// Callback for clicking the Cancel button
					  TRUE,								// Display the Cancel button
					  "SCREEN_MESSAGEBOX_LEFTALIGNED",	// Display the tutorial message box
					  -1,								// OK string ref
					  "Yes",							// OK string
					  -1,								// Cancel string ref
					  "No");							// Cancel string
}

//
void ShowSetupMessage(object oPC, object oRod)
{
	SetGUIAction(MROP_FLG_MESSAGEBOX_SETUP, oPC, oRod);

	string sMessage = "<c=gold><b>You've used the " + GetName(oRod) + "!</b></c>\n\n"

					+ "This Rod remembers what Spell Buffs you have cast on your"
					+ " party and allows you to quickly recast them again later.\n\n"

					+ "Setup has two options : <c=gold>Fast</c> and <c=gold>As"
					+ " Actions</c>.\n\n"

					+ "If you choose <c=gold>Fast</c>, spellbuffs and Bardic"
					+ " Inspirations will be cast rapidly during the buffing"
					+ " routine. Otherwise, preparations will be added to your"
					+ " action queue normally and take a round each to cast.\n\n"

					+ "How do you want to Buff?";

	DisplayMessageBox(oPC,								// Display a message box for this PC
					  -1,								// string ref to display
					  sMessage,							// Message to display
					  "gui_mrop_ok",					// Callback for clicking the OK button
					  "gui_mrop_cancel",				// Callback for clicking the Cancel button
					  TRUE,								// Display the Cancel button
					  "SCREEN_MESSAGEBOX_LEFTALIGNED",	// Display which message box
					  -1,								// OK string ref
					  "As Actions",						// OK string
					  -1,								// Cancel string ref
					  "Fast");							// Cancel string
}

//
void ShowDestroyBook(object oPC, object oRod, object oBook)
{
	SetGUIAction(MROP_FLG_MESSAGEBOX_DESTROY, oPC, oRod, oBook);

	string sMessage = "Do you want to permanently destroy this " + GetName(oBook)
			+ " and all of the Spells and Inspirations stored within?";
	DisplayMessageBox(oPC,								// Display a message box for this PC
					  -1,								// string ref to display
					  sMessage,							// Message to display
					  "gui_mrop_ok",					// Callback for clicking the OK button
					  "gui_mrop_cancel",				// Callback for clicking the Cancel button
					  TRUE,								// Display the Cancel button
					  "SCREEN_MESSAGEBOX_LEFTALIGNED",	// Display the tutorial message box
					  -1,								// OK string ref
					  "Destroy",						// OK string
					  -1,								// Cancel string ref
					  "");								// Cancel string
}

//
void ShowTutorial(object oPC, object oRod, string sGreet)
{
	SetGUIAction(MROP_FLG_MESSAGEBOX_EMPTY, oPC, oRod);

	string sMessage = (sGreet == "") ? "<c=gold><b>The " + GetName(oRod)
			+ " Is Empty !</b></c>\n\n" : "<c=gold><b>" + sGreet + "</b></c>\n\n";
	// kL, new tutorial for the MetaRod of Preparations:
	sMessage += "To add new Spells and Bardic Inspirations to this Rod:\n\n"

			+ "1. Activate the MetaRod and target it on itself. This puts the"
			+ " Rod into Learn mode. You can drag the Rod to your hotbar for"
			+ " easy access.\n\n"
//			+ "1. Double-click the Rod, or right-click it and choose *Activate"
//			+ " Item, then target ( click on ) the Rod itself. This puts the"
//			+ " Rod into Learn mode.\n\n"

			+ "2. Cast spells and feats on your party. A Book of MetaPrepas"
			+ " will be created on each character that casts a buff spell or"
			+ " activates (or deactivates) a Bardic Inspiration, if they don't"
			+ " have one already. The spells and Inspirations that are cast"
			+ " ought be recorded as Pages of MetaPrepas inside a Book, one"
			+ " Page for each buff that was cast. While the Rod is in Learn"
			+ " mode every character who casts or Inspires will receive a Page"
			+ " in their Book of MetaPrepas. Pages are created only for Bardic"
			+ " Inspirations and spellbuffs. Be sure to read the Pages'"
			+ " descriptions for more info!\n\n"

			+ "Spells that are cast on the ground will not be prepared. Pages"
			+ " can be added either singly or many at a time per Rod"
			+ " activation.\n\n"

			+ "3. Activate the MetaRod on itself again. This takes the Rod out"
			+ " of Learn mode and into Play mode, so that spells you don't want"
			+ " prepared won't be.\n\n"

			+ "<b>4. Adventure !</b>\n\n"

			+ "5. Then after resting, Activate the Rod and this time target"
			+ " anything <b>except</b> the Rod itself. This will command your"
			+ " party members to begin casting the spells and using"
			+ " Inspirations that they have written as Pages in their Books.\n\n"

			+ "The Books of MetaPrepas are like most other containers, so you"
			+ " can take individual Pages out of them if you don't want a"
			+ " character to cast a certain spell or use a given Inspiration"
			+ " anymore, and you can put them back in later if you change your"
			+ " mind. You can also delete Pages by taking them out of a Book"
			+ " and simply Activating them, or even destroy an entire Book and"
			+ " its contents by Activating the MetaRod and targeting on it."
			+ " Although Pages should not be transfered to different Books, the"
			+ " Rod itself can be carried and used by anyone in your party.\n\n"

			+ "<c=gold>Combat :</c> The MetaRod will cast buffs while in"
			+ " combat but these preparations will <b>not</b> be Fast"
			+ " cast, even if you chose the Fast option during setup."
			+ " Neither can the Rod be put in Learn mode while in combat.\n\n"

			+ "Prepared buffs that are still in effect - since some buffs last"
			+ " longer than others - will be refreshed if the character has a"
			+ " cast of that spell memorized. Bardic Inspirations remain"
			+ " active if they were active, and should never get turned off by"
			+ " the MetaRod. But be careful if you keep preparations for"
			+ " multiple Inspirations inside a Book - only the last Bardic"
			+ " preparation will take effect.\n\n"

			+ "Once you are done reading this you may Activate the Rod on"
			+ " itself to begin preparing Pages of MetaPrepas. And before you"
			+ " go, remember that you may run the MRoP script from the console"
			+ " at any time to bring back this setup & Welcome message.\n\n\n"

			+ "Good Luck !";

	DisplayMessageBox(oPC,							// Display a message box for this PC
					  -1,							// string ref to display
					  sMessage,						// Message to display
					  "gui_mrop_ok",				// Callback for clicking the OK button
					  "gui_mrop_cancel",			// Callback for clicking the Cancel button
					  FALSE,						// Display the Cancel button
					  "SCREEN_MESSAGEBOX_REPORT",	// Display the tutorial message box
					  -1,							// OK string ref
					  "",							// OK string
					  -1,							// Cancel string ref
					  "");							// Cancel string
}

//
void ShowDeletePreparation(object oPC, object oPrep)
{
	SetGUIAction(MROP_FLG_MESSAGEBOX_DELETE_PAGE, oPC, oPrep);

	string sMessage = "Are you sure you want to delete the Page : " + GetName(oPrep) + "?\n\n"

			+ "This action cannot be undone.\n\n";

	DisplayMessageBox(oPC,								// Display a message box for this PC
					  -1,								// string ref to display
					  sMessage,							// Message to display
					  "gui_mrop_ok",					// Callback for clicking the OK button
					  "gui_mrop_cancel",				// Callback for clicking the Cancel button
					  TRUE,								// Display the Cancel button
					  "SCREEN_MESSAGEBOX_LEFTALIGNED",	// Display the tutorial message box
					  -1,								// OK string ref
					  "Delete",							// OK string
					  -1,								// Cancel string ref
					  "");								// Cancel string
}
