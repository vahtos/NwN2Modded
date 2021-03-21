//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 2/12/2009							//
//	Title: bot9s_inc_index					//
//	Description: Indexing functions for the	//
//	Book of the Nine Swords classes.		//
//////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_2da"

/*	Unique tags are created on the placeholder items, specific to the player they are generated for.
	Here we are making sure that we're checking for those tags and not the base item.
	This prevents PCs of the same class from interfering with another PC's interface.
	
	Red, Blue, and Green Boxes are local ints stored on the item oToB.  They are the heart
	of the indexing functions.  RedBox refers to the listboxes on the Maneuvers Readied screen.
	BlueBoxes come in four types and GreenBoxes come in three types each coresponding to a type of maneuver.
	STA for Stance, STR for Strike, B for Boost, and C for Counter.  GreenBoxes are not used for STA
	because Stances never are put on the Maneuvers Readied screen. BlueBoxes contain the 2da row number
	from the maneuvers 2da and tell the buttons on the QuickStrike menu what icon to display and which
	script to run.  GreenBoxes are bridges between Red and Blue.  When RedBox tells us that the player has
	selected a particular maneuver for the numbered box, GreenBox copies the number of the RedBox.  When
	another maneuver is added a check is run to find the first availible empty box on Maneuvers
	Readied.  Since RedBox# now has been set to 1 (indicating that it is used) the function GetRed finds
	the next availible RedBox.  Once it has done that it looks for the next empty box on QuickStrike.  Since
	BlueBox holds the actual 2da information GreenBox is needed to properly determine which boxes are 
	occupied.  Once the function GetGreen finds that listbox it is set to the RedBox number and GetBlue sets the 
	2da for the approriate ListBox based on the ListBox GetGreen tells it to use.  When a maneuver is removed, RemoveManeuver
	checks the number on GreenBox (also the same number as RedBox) and the data can be reset to 0 for the specific
	listbox.  To clarify, no data from these boxes is ever stored on the GUI, it is stored in oToB.
	The GUI merely executes the script to check for or modify the variables when selected.
	
	4/10/2009: Major overhaul of the indexing system; reduced clutter scripts, added routing for
	Classes, and added support for swift feats.

	12/12/2009: Changed all of the functions that store data on the guis SCREEN_MANEUVERS_READIED_*
	to store data on oToB.*/

//Prototypes

//Sets Variables, adds and modifies listboxes for the bo9s menus.
// - oPC: Person calling the menu.
// - oManeuver: Item in oToB that we extract variables from.
// - nLevel: Which teir of listboxes we're populating.
// - nIndexRow: Number of the listbox row and pertinet variables being modified.
// - nClassType: The menu of the class to populate the menu for.
void PopulateBot9sMenu(object oPC, object oManeuver, int nLevel, int nIndexRow, int nClassType);

//Sets variables and disbaled status for the Maneuvers Readied screen.
// -sRed: Data string embeded into the listbox row.  Contains many values.
// -sClass: Class menu to populate.
// -sNumber: The number of the Readied Maneuver box on the screen.
void PopulateManeuverReadied(string sRed, string sClass, string sNumber);

//Returns the first unoccupied RedBox with number.
string GetRed(string sClass);

//Returns the number of the RedBox called by GetRed
int GetRedNumber(string sClass);

//Returns the first unoccupied GreenBox by type and number.
// - sType: Either STR, B, or C (STA is not used by GreenBoxes).
// - sClass: Type of Class that can use this particular box.
string GetGreen(string sType, string sClass);

//Cross references the first availible GreenBox to determine the first unoccupied BlueBox.
//Returns the first unoccupied BlueBox.
// - sType:  Checks by types STR, B, or C (STA directly bypasses these checks because it is never used on Maneuvers Readied).
// - sClass: Type of Class that can use this particular box.
string GetBlue(string sType, string sClass);

// Returns the first empty swift feat box.
// - sClass: Absolutely necessary to display the box correctly.
string GetSwiftFeat(string sClass);
			
//Sets Red, Blue, and Green box variables when a Listbox under Level nLevel is selected
//from the Maneuvers Known Screen.  RedBox is for Maneuvers Readied, BlueBox is a 2da refrence
//for Quickstrike, and GreenBox determines if the Quickstrike buttons are occupied.
// - oPC: Person calling the menu.
// - nLevel: Level listing of the maneuver to add.
// - nIndexRow: Numeric value of the listbox row being selected. ie: "L1R#Type", "Level1Row#".
// - nRed: ID Number of "READIED_", "RED_PANE_", and "RED_" GUIObject (for textures) and the variable "RedBox#".
// - sClass: Class suffix of the screens to modify.
void AddLevelRow(object oPC, int nLevel, int nIndexRow, int nRed, string sClass);

//Sets the textures of the Quickstrike Listboxes
// - sListbox: Name of the ListBox to be modified.
// - sUIPane: Name of the UIPane to be modified.
// - sIndexType: Letter suffix of the BlueBox we're extracting the 2da refrence from.
// - nIndexRow: Index number of the 2da row which tells us which texture to use.
// - sClass: Which Quickstrike Menu to add to.
void AddQuickstrike(string sListBox, string sUIPane, string sIndexType, int nIndexRow, string sClass);

//Cross References the number of the RedBox as nRed againt the local int of GreenBoxes
//in order to find and clear the appropriate maneuvers from Maneuvers Readied and Quickstrike.
// - nRed: Number of the calling RedBox and local int stored on GreenBox.
void RemoveManeuver(int nRed, string sClass);

// Determine if the target is carrying the specified object.
int Bot9SHasItem(object oTarget, string sTag);

//Returns the number of items in oContainer.
int GetNumberOfItemsInInventory(object oContainer);

//Functions

//Sets Variables, adds and modifies listboxes for the bo9s menus.
// - oPC: Person calling the menu.
// - oManeuver: Item in oToB that we extract variables from.
// - nLevel: Which teir of listboxes we're populating.
// - nIndexRow: Number of the listbox row and pertinet variables being modified.
// - nClassType: The menu of the class to populate the menu for.
void PopulateBot9sMenu(object oPC, object oManeuver, int nLevel, int nIndexRow, int nClassType)
{
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nClass = GetLocalInt(oManeuver, "Class"); // variable is set on item at creation
	int nRow, nType, nStrRef;
	string sLevel, sIndexRow, sScreen, sList, sText, sTextures, sClass, sTga;

	switch (nClass)
	{
		case CLASS_TYPE_CRUSADER:	sScreen = "SCREEN_MANEUVERS_KNOWN_CR";	sClass = "_CR";	break;
		case CLASS_TYPE_SAINT:		sScreen = "SCREEN_MANEUVERS_KNOWN_SA";	sClass = "_SA";	break;
		case CLASS_TYPE_SWORDSAGE:	sScreen = "SCREEN_MANEUVERS_KNOWN_SS";	sClass = "_SS";	break;
		case CLASS_TYPE_WARBLADE:	sScreen = "SCREEN_MANEUVERS_KNOWN_WB";	sClass = "_WB";	break;
		case 255:					sScreen = "SCREEN_MANEUVERS_KNOWN";		sClass = "___";	break;
		default:					sScreen = "SCREEN_MANEUVERS_KNOWN";		sClass = "___";	break;
	}

	if ((nLevel == 0) && (nClass == nClassType))
	{
		nRow = GetLocalInt(oManeuver, "2da");
		nType = GetLocalInt(oManeuver, "Type");
		nStrRef = tob_Get2daInt("maneuvers", "StrRef", nRow);
		sTga = tob_Get2daString("maneuvers", "ICON", nRow);
		sLevel = IntToString(nLevel);
		sIndexRow = IntToString(nIndexRow);
		sList = "STANCE_LIST";
		sText = "STANCE_ITEM_TEXT=" + GetStringByStrRef(nStrRef);
		sTextures = "STANCE_ITEM_ICON=" + sTga + ".tga";

		SetLocalInt(oToB, "CheckI", 2);
		SetLocalInt(oToB, "BlueBoxSTA" + sIndexRow + sClass, nRow);
		AddListBoxRow(oPC, sScreen, sList, "STANCE_LISTBOX_ITEM" + sIndexRow, sText, sTextures, "", "");

		if (GetHasFeat(FEAT_STANCE_MASTERY, oPC))
		{
			SetLocalInt(oToB, "BlueBoxDSTA" + sIndexRow + sClass, nRow);
		}
	}
	else if (nClass == nClassType)
	{
		nRow = GetLocalInt(oManeuver, "2da");
		nType = GetLocalInt(oManeuver, "Type");
		nStrRef = tob_Get2daInt("maneuvers", "StrRef", nRow);
		sTga = tob_Get2daString("maneuvers", "ICON", nRow);
		sLevel = IntToString(nLevel);
		sIndexRow = IntToString(nIndexRow);
		sList = "LEVEL" + sLevel + "_LIST";
		sText = "LEVEL" + sLevel + "_ITEM_TEXT=" + GetStringByStrRef(nStrRef);
		sTextures = "LEVEL" + sLevel + "_ITEM_ICON=" + sTga + ".tga";

		SetLocalInt(oToB, "CheckI", 2);
		SetLocalInt(oToB, "Level" + sLevel + "Row" + sIndexRow + sClass, nRow);
		SetLocalInt(oToB, "L" + sLevel + "R" + sIndexRow + "Type" + sClass, nType);
		AddListBoxRow(oPC, sScreen, sList, "LEVEL" + sLevel + "_LISTBOX_ITEM" + sIndexRow, sText, sTextures, "", "");

		if (GetLocalInt(oToB, "Known" + sClass + sLevel + "Row" + sIndexRow + "Disabled") == 1)
		{
			if (sClass == "___")
			{
				SetGUIObjectDisabled(oPC, "SCREEN_MANEUVERS_KNOWN", "LEVEL" + sLevel + "_LISTBOX_ITEM" + sIndexRow, TRUE);
			}
			else SetGUIObjectDisabled(oPC, "SCREEN_MANEUVERS_KNOWN" + sClass, "LEVEL" + sLevel + "_LISTBOX_ITEM" + sIndexRow, TRUE);
		}
	}
}

//Sets variables and disbaled status for the Maneuvers Readied screen.
// -sRed: Data string embeded into the listbox row.  Contains many values.
// -sClass: Class menu to populate.
// -sNumber: The number of the Readied Maneuver box on the screen.
void PopulateManeuverReadied(string sRed, string sClass, string sNumber)
{
	if (sRed != "")
	{
		object oOrigin = OBJECT_SELF;
		object oPC = GetControlledCharacter(oOrigin);
		object oToB = GetItemPossessedBy(oPC, "tob");
		int nRow = GetLocalInt(oToB, "ReadiedRow" + sNumber + sClass);
		string sTga = tob_Get2daString("maneuvers", "ICON", nRow);
		string sIcon = "RED_" + sNumber + "=" + sTga + ".tga";

		if (sClass == "___")
		{
			AddListBoxRow(oPC, "SCREEN_MANEUVERS_READIED", "READIED_" + sNumber, "RED_PANE_" + sNumber, "", sIcon, sRed, "");

			if (GetLocalInt(oToB, "Readied" + sNumber + sClass + "Disabled") == 1)
			{
				SetGUIObjectDisabled(oPC, "SCREEN_MANEUVERS_READIED", "READIED_" + sNumber, FALSE);
			}
		}
		else
		{
			AddListBoxRow(oPC, "SCREEN_MANEUVERS_READIED" + sClass, "READIED_" + sNumber, "RED_PANE_" + sNumber, "", sIcon, sRed, "");

			if (GetLocalInt(oToB, "Readied" + sNumber + sClass + "Disabled") == 1)
			{
				SetGUIObjectDisabled(oPC, "SCREEN_MANEUVERS_READIED" + sClass, "READIED_" + sNumber, FALSE);
			}
		}
	}
}

//Returns the first unoccupied RedBox with number.
string GetRed(string sClass)
{
	object oOrigin = OBJECT_SELF;
	object oPC = GetControlledCharacter(oOrigin);
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nReadiedTotal = GetLocalInt(oToB, "ReadiedTotal" + sClass);
	
	string sRedBox; //Strings that do not exist always return as "".

	if ((GetLocalInt(oToB, "RedBox17" + sClass) == 0) && (GetHasFeat(FEAT_EXTRA_READIED_MANEUVER, oPC)))
	{
		sRedBox = "RedBox17" + sClass;
	}
	else if (GetLocalInt(oToB, "RedBox1" + sClass) == 0)
	{
		sRedBox = "RedBox1" + sClass;
	}
	else if (GetLocalInt(oToB, "RedBox2" + sClass) == 0)
	{
		sRedBox = "RedBox2" + sClass;
	}
	else if (GetLocalInt(oToB, "RedBox3" + sClass) == 0)
	{
		sRedBox = "RedBox3" + sClass;
	}
	else if ((GetLocalInt(oToB, "RedBox4" + sClass) == 0) && (nReadiedTotal >= 4))
	{
		sRedBox = "RedBox4" + sClass;
	}
	else if ((GetLocalInt(oToB, "RedBox5" + sClass) == 0) && (nReadiedTotal >= 5))
	{
		sRedBox = "RedBox5" + sClass;
	}
	else if ((GetLocalInt(oToB, "RedBox6" + sClass) == 0) && (nReadiedTotal >= 6))
	{
		sRedBox = "RedBox6" + sClass;
	}
	else if ((GetLocalInt(oToB, "RedBox7" + sClass) == 0) && (nReadiedTotal >= 7))
	{
		sRedBox = "RedBox7" + sClass;
	}
	else if ((GetLocalInt(oToB, "RedBox8" + sClass) == 0) && (nReadiedTotal >= 8))
	{
		sRedBox = "RedBox8" + sClass;
	}
	else if ((GetLocalInt(oToB, "RedBox9" + sClass) == 0) && (nReadiedTotal >= 9))
	{
		sRedBox = "RedBox9" + sClass;
	}
	else if ((GetLocalInt(oToB, "RedBox10" + sClass) == 0) && (nReadiedTotal >= 10))
	{
		sRedBox = "RedBox10" + sClass;
	}
	else if ((GetLocalInt(oToB, "RedBox11" + sClass) == 0) && (nReadiedTotal >= 11))
	{
		sRedBox = "RedBox11" + sClass;
	}
	else if ((GetLocalInt(oToB, "RedBox12" + sClass) == 0) && (nReadiedTotal >= 12))
	{
		sRedBox = "RedBox12" + sClass;
	}
	else if ((GetLocalInt(oToB, "RedBox13" + sClass) == 0) && (nReadiedTotal >= 13))
	{
		sRedBox = "RedBox13" + sClass;
	}
	else if ((GetLocalInt(oToB, "RedBox14" + sClass) == 0) && (nReadiedTotal >= 14))
	{
		sRedBox = "RedBox14" + sClass;
	}
	else if ((GetLocalInt(oToB, "RedBox15" + sClass) == 0) && (nReadiedTotal >= 15))
	{
		sRedBox = "RedBox15" + sClass;
	}
	else if ((GetLocalInt(oToB, "RedBox16" + sClass) == 0) && (nReadiedTotal >= 16))
	{
		sRedBox = "RedBox16" + sClass;
	}
	return sRedBox;
}

//Returns the number of the RedBox called by GetRed
int GetRedNumber(string sClass)
{
	object oOrigin = OBJECT_SELF;
	object oPC = GetControlledCharacter(oOrigin);
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nReadiedTotal = GetLocalInt(oToB, "ReadiedTotal" + sClass);
	
	int r;

	if ((GetLocalInt(oToB, "RedBox17" + sClass) == 0) && (GetHasFeat(FEAT_EXTRA_READIED_MANEUVER, oPC)))
	{
		r = 17;
	}
	else if (GetLocalInt(oToB, "RedBox1" + sClass) == 0)
	{
		r = 1;
	}
	else if (GetLocalInt(oToB, "RedBox2" + sClass) == 0)
	{
		r = 2;
	}
	else if (GetLocalInt(oToB, "RedBox3" + sClass) == 0)
	{
		r = 3;
	}
	else if ((GetLocalInt(oToB, "RedBox4" + sClass) == 0) && (nReadiedTotal >= 4))
	{
		r = 4;
	}
	else if ((GetLocalInt(oToB, "RedBox5" + sClass) == 0) && (nReadiedTotal >= 5))
	{
		r = 5;
	}
	else if ((GetLocalInt(oToB, "RedBox6" + sClass) == 0) && (nReadiedTotal >= 6))
	{
		r = 6;
	}
	else if ((GetLocalInt(oToB, "RedBox7" + sClass) == 0) && (nReadiedTotal >= 7))
	{
		r = 7;
	}
	else if ((GetLocalInt(oToB, "RedBox8" + sClass) == 0) && (nReadiedTotal >= 8))
	{
		r = 8;
	}
	else if ((GetLocalInt(oToB, "RedBox9" + sClass) == 0) && (nReadiedTotal >= 9))
	{
		r = 9;
	}
	else if ((GetLocalInt(oToB, "RedBox10" + sClass) == 0) && (nReadiedTotal >= 10))
	{
		r = 10;
	}
	else if ((GetLocalInt(oToB, "RedBox11" + sClass) == 0) && (nReadiedTotal >= 11))
	{
		r = 11;
	}
	else if ((GetLocalInt(oToB, "RedBox12" + sClass) == 0) && (nReadiedTotal >= 12))
	{
		r = 12;
	}
	else if ((GetLocalInt(oToB, "RedBox13" + sClass) == 0) && (nReadiedTotal >= 13))
	{
		r = 13;
	}
	else if ((GetLocalInt(oToB, "RedBox14" + sClass) == 0) && (nReadiedTotal >= 14))
	{
		r = 14;
	}
	else if ((GetLocalInt(oToB, "RedBox15" + sClass) == 0) && (nReadiedTotal >= 15))
	{
		r = 15;
	}
	else if ((GetLocalInt(oToB, "RedBox16" + sClass) == 0) && (nReadiedTotal >= 16))
	{
		r = 16;
	}

	return r;
}

//Returns the first unoccupied GreenBox by type and number.
// - sType: Either STR, B, or C (STA is not used by GreenBoxes).
// - sClass: Type of Class that can use this particular box.
string GetGreen(string sType, string sClass)
{
	object oOrigin = OBJECT_SELF;
	object oPC = GetControlledCharacter(oOrigin);
	object oToB = GetItemPossessedBy(oPC, "tob");

	string sGreenBox;
	
	if (GetLocalInt(oToB, "GreenBox" + sType + "1" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "1" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "2" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "2" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "3" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "3" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "4" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "4" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "5" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "5" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "6" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "6" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "7" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "7" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "8" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "8" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "9" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "9" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "10" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "10" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "11" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "11" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "12" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "12" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "13" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "13" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "14" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "14" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "15" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "15" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "16" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "16" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "17" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "17" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "18" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "18" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "19" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "19" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "20" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "20" + sClass;
	}
	return sGreenBox;
}

//Cross references the first availible GreenBox to determine the first unoccupied BlueBox.
//Returns the first unoccupied BlueBox.
// - sType:  Checks by types STR, B, or C (STA directly bypasses these checks because it is never used on Maneuvers Readied).
// - sClass: Type of Class that can use this particular box.
string GetBlue(string sType, string sClass)
{
	object oOrigin = OBJECT_SELF;
	object oPC = GetControlledCharacter(oOrigin);
	object oToB = GetItemPossessedBy(oPC, "tob");
	
	string sBlueBox;
	
	int nCheck1 = GetLocalInt(oToB, "GreenBox" + sType + "1" + sClass);
	int nCheck2 = GetLocalInt(oToB, "GreenBox" + sType + "2" + sClass);
	int nCheck3 = GetLocalInt(oToB, "GreenBox" + sType + "3" + sClass);
	int nCheck4 = GetLocalInt(oToB, "GreenBox" + sType + "4" + sClass);
	int nCheck5 = GetLocalInt(oToB, "GreenBox" + sType + "5" + sClass);
	int nCheck6 = GetLocalInt(oToB, "GreenBox" + sType + "6" + sClass);
	int nCheck7 = GetLocalInt(oToB, "GreenBox" + sType + "7" + sClass);
	int nCheck8 = GetLocalInt(oToB, "GreenBox" + sType + "8" + sClass);
	int nCheck9 = GetLocalInt(oToB, "GreenBox" + sType + "9" + sClass);
	int nCheck10 = GetLocalInt(oToB, "GreenBox" + sType + "10" + sClass);
	int nCheck11 = GetLocalInt(oToB, "GreenBox" + sType + "11" + sClass);
	int nCheck12 = GetLocalInt(oToB, "GreenBox" + sType + "12" + sClass);
	int nCheck13 = GetLocalInt(oToB, "GreenBox" + sType + "13" + sClass);
	int nCheck14 = GetLocalInt(oToB, "GreenBox" + sType + "14" + sClass);
	int nCheck15 = GetLocalInt(oToB, "GreenBox" + sType + "15" + sClass);
	int nCheck16 = GetLocalInt(oToB, "GreenBox" + sType + "16" + sClass);
	int nCheck17 = GetLocalInt(oToB, "GreenBox" + sType + "17" + sClass);
	int nCheck18 = GetLocalInt(oToB, "GreenBox" + sType + "18" + sClass);
	int nCheck19 = GetLocalInt(oToB, "GreenBox" + sType + "19" + sClass);
	int nCheck20 = GetLocalInt(oToB, "GreenBox" + sType + "20" + sClass);
	int nCheckGreen = GetLocalInt(oToB, GetGreen(sType, sClass));
		
	if (nCheck1 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "1" + sClass;
	}
	else if (nCheck2 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "2" + sClass;
	}
	else if (nCheck3 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "3" + sClass;
	}
	else if (nCheck4 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "4" + sClass;
	}
	else if (nCheck5 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "5" + sClass;
	}
	else if (nCheck6 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "6" + sClass;
	}
	else if (nCheck7 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "7" + sClass;
	}
	else if (nCheck8 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "8" + sClass;
	}
	else if (nCheck9 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "9" + sClass;
	}
	else if (nCheck10 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "10" + sClass;
	}
	else if (nCheck11 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "11" + sClass;
	}
	else if (nCheck12 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "12" + sClass;
	}
	else if (nCheck13 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "13" + sClass;
	}
	else if (nCheck14 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "14" + sClass;
	}
	else if (nCheck15 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "15" + sClass;
	}
	else if (nCheck16 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "16" + sClass;
	}
	else if (nCheck17 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "17" + sClass;
	}
	else if (nCheck18 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "18" + sClass;
	}
	else if (nCheck19 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "19" + sClass;
	}
	else if (nCheck20 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "20" + sClass;
	}
	return sBlueBox;
}

// Returns the first empty swift feat box.
// - sClass: Absolutely necessary to display the box correctly.
string GetSwiftFeat(string sData)
{
	/* This is a depricated function since patch 1.23 introduced true swift
	feats.  However, I've kept it around because it is useful to display
	misc buttons related to the maneuvers.*/

	object oOrigin = OBJECT_SELF;
	object oPC = GetControlledCharacter(oOrigin);
	string sClass = GetStringRight(sData, 3);
	object oToB = GetItemPossessedBy(oPC, "tob");
	
	string sFeatBox; //Variables that do not exist always return as 0.
	//BlueBoxF1 is reserved for Charge.
	if (GetLocalInt(oToB, "BlueBoxF2" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF2" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF3" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF3" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF4" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF4" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF5" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF5" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF6" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF6" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF7" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF7" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF8" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF8" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF9" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF9" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF10" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF10" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF11" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF11" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF12" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF12" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF13" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF13" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF14" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF14" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF15" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF15" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF16" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF16" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF17" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF17" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF18" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF18" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF19" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF19" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF20" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF20" + sClass;
	}
	return sFeatBox;
}

//Sets Red, Blue, and Green box variables when a Listbox under Level nLevel is selected
//from the Maneuvers Known Screen.  RedBox is for Maneuvers Readied, BlueBox is a 2da refrence
//for Quickstrike, and GreenBox determines if the Quickstrike buttons are occupied.
// - oPC: Person calling the menu.
// - nLevel: Level listing of the maneuver to add.
// - nIndexRow: Numeric value of the listbox row being selected. ie: "L1R#Type", "Level1Row#".
// - nRed: ID Number of "READIED_", "RED_PANE_", and "RED_" GUIObject (for textures) and the variable "RedBox#".
// - sClass: Class suffix of the screens to modify.
void AddLevelRow(object oPC, int nLevel, int nIndexRow, int nRed, string sClass)
{
	string sLevel = IntToString(nLevel);
	string sIndexRow = IntToString(nIndexRow);
	string sRed = IntToString(nRed);
	object oToB = GetItemPossessedBy(oPC, "tob");

	int nRow = GetLocalInt(oToB, "Level" + sLevel + "Row" + sIndexRow + sClass);
	int nType = GetLocalInt(oToB, "L" + sLevel + "R" + sIndexRow + "Type" + sClass);
	string sTga = tob_Get2daString("maneuvers", "ICON", nRow);

	string sTextures = "RED_" + sRed + "=" + sTga + ".tga";
	string sBox = "READIED_" + sRed;
	string sVari = sLevel + sRed + sClass + IntToString(nRow) + "_" + sIndexRow; // GetSubString type functions are used to break this apart.

	string sGreenBoxSTR = GetGreen("STR", sClass);
	string sGreenBoxB = GetGreen("B", sClass);
	string sGreenBoxC = GetGreen("C", sClass);

	string sBlueBoxSTR = GetBlue("STR", sClass);
	string sBlueBoxB = GetBlue("B", sClass);
	string sBlueBoxC = GetBlue("C", sClass);

	if (sClass == "___")
	{
		AddListBoxRow(oPC, "SCREEN_MANEUVERS_READIED", sBox, "RED_PANE_" + sRed, "", sTextures, "", "");
		SetLocalString(oToB, "Readied" + sRed + sClass, sVari);
		SetLocalInt(oToB, "ReadiedRow" + sRed + sClass, nRow);
	}
	else 
	{
		AddListBoxRow(oPC, "SCREEN_MANEUVERS_READIED" + sClass, sBox, "RED_PANE_" + sRed, "", sTextures, "", "");
		SetLocalString(oToB, "Readied" + sRed + sClass, sVari);
		SetLocalInt(oToB, "ReadiedRow" + sRed + sClass, nRow);
	}

	SetLocalInt(oToB, "RedBox" + sRed + sClass, 1);

	if (nType == 2)
	{
		SetLocalInt(oToB, sBlueBoxSTR, nRow);
		SetLocalInt(oToB, sGreenBoxSTR, nRed);
	}
	else if (nType == 3)
	{
		SetLocalInt(oToB, sBlueBoxB, nRow);
		SetLocalInt(oToB, sGreenBoxB, nRed);
	}
	else if (nType == 4)
	{
		SetLocalInt(oToB, sBlueBoxC, nRow);
		SetLocalInt(oToB, sGreenBoxC, nRed);
	}

	if (sClass == "___")
	{
		SetGUIObjectDisabled(oPC, "SCREEN_MANEUVERS_KNOWN", "LEVEL" + sLevel + "_LISTBOX_ITEM" + sIndexRow, TRUE);
		SetLocalInt(oToB, "Known" + sClass + sLevel + "Row" + sIndexRow + "Disabled", 1);
	}
	else 
	{
		SetGUIObjectDisabled(oPC, "SCREEN_MANEUVERS_KNOWN" + sClass, "LEVEL" + sLevel + "_LISTBOX_ITEM" + sIndexRow, TRUE);
		SetLocalInt(oToB, "Known" + sClass + sLevel + "Row" + sIndexRow + "Disabled", 1);
	}

	if (sClass == "___")
	{
		SetGUIObjectDisabled(oPC, "SCREEN_MANEUVERS_READIED", sBox, FALSE);
		SetLocalInt(oToB, "Readied" + sRed + sClass + "Disabled", 1);
	}
	else 
	{
		SetGUIObjectDisabled(oPC, "SCREEN_MANEUVERS_READIED" + sClass, sBox, FALSE);
		SetLocalInt(oToB, "Readied" + sRed + sClass + "Disabled", 1);
	}
}

//Sets the textures of the Quickstrike Listboxes
// - sListbox: Name of the ListBox to be modified.
// - sUIPane: Name of the UIPane to be modified.
// - sIndexType: Letter suffix of the BlueBox we're extracting the 2da refrence from.
// - nIndexRow: Index number of the 2da row which tells us which texture to use.
// - sClass: Which Quickstrike Menu to add to.
void AddQuickstrike(string sListBox, string sUIPane, string sIndexType, int nIndexRow, string sData)
{
	object oOrigin = OBJECT_SELF;
	object oPC = GetControlledCharacter(oOrigin);
	string sClass = GetStringRight(sData, 3);
	string sScreen;
	
	if (sClass != "___")
	{
		sScreen = "SCREEN_QUICK_STRIKE" + sClass;
	}
	else sScreen = "SCREEN_QUICK_STRIKE";
	
	string sIndexRow = IntToString(nIndexRow);
	string sBox;
	string sTextures;
	
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nRow = GetLocalInt(oToB, "BlueBox" + sIndexType + sIndexRow + sClass);
	
	if (nRow == 0)
	{
		sTextures = sIndexType + sIndexRow + "=" + "b_empty.tga";
		sBox = sListBox;

		ModifyListBoxRow(oPC, sScreen, sBox, sUIPane, "", sTextures, "", "");
		SetGUIObjectHidden(oPC, sScreen, sBox, TRUE);
	}
	else if (nRow != 0)
	{
		string sTga = tob_Get2daString("maneuvers", "ICON", nRow);

		sTextures = sIndexType + sIndexRow + "=" + sTga + ".tga";
		sBox = sListBox;

		ModifyListBoxRow(oPC, sScreen, sBox, sUIPane, "", sTextures, "", "");
		SetGUIObjectHidden(oPC, sScreen, sBox, FALSE);
	}
}

//Cross References the number of the RedBox as nRed againt the local int of GreenBoxes
//in order to find and clear the appropriate maneuvers from Maneuvers Readied and Quickstrike.
// - nRed: Number of the calling RedBox and local int stored on GreenBox.
void RemoveManeuver(int nRed, string sClass)
{
	object oOrigin = OBJECT_SELF;
	object oPC = GetControlledCharacter(oOrigin);
	object oToB = GetItemPossessedBy(oPC, "tob");
	
	SetLocalInt(oToB, "RedBox" + IntToString(nRed) + sClass, 0);
	
	if (GetLocalInt(oToB, "GreenBoxSTR1" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR1" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR1" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR2" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR2" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR2" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR3" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR3" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR3" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR4" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR4" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR4" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR5" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR5" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR5" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR6" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR6" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR6" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR7" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR7" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR7" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR8" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR8" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR8" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR9" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR9" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR9" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR10" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR10" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR10" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR11" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR11" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR11" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR12" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR12" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR12" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR13" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR13" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR13" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR14" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR14" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR14" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR15" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR15" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR15" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR16" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR16" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR16" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR17" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR17" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR17" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR18" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR18" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR18" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR19" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR19" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR19" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR20" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR20" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR20" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxB1" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxB1" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxB1" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxB2" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxB2" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxB2" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxB3" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxB3" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxB3" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxB4" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxB4" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxB4" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxB5" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxB5" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxB5" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxB6" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxB6" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxB6" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxB7" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxB7" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxB7" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxB8" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxB8" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxB8" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxB9" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxB9" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxB9" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxB10" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxB10" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxB10" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxC1" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxC1" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxC1" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxC2" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxC2" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxC2" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxC3" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxC3" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxC3" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxC4" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxC4" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxC4" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxC5" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxC5" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxC5" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxC6" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxC6" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxC6" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxC7" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxC7" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxC7" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxC8" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxC8" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxC8" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxC9" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxC9" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxC9" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxC10" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxC10" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxC10" + sClass, 0);
	}
}
	
// Determine if the target is carrying the specified object.
int Bot9SHasItem(object oTarget, string sTag)
{
    if (GetIsObjectValid(oTarget))
	{
        return GetIsObjectValid(GetItemPossessedBy(oTarget, sTag));
    }
    return FALSE;
}

//Returns the number of items in oContainer.
int GetNumberOfItemsInInventory(object oContainer)
{
	object oItem;
	int nReturn;
	
	oItem = GetFirstItemInInventory(oContainer);
	
	while (GetIsObjectValid(oItem))
	{
		nReturn += 1;
		oItem = GetNextItemInInventory(oContainer);
	}
	return nReturn;
}