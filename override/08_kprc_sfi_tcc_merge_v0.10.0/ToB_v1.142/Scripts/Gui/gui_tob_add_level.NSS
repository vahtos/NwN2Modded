//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 4/5/2009							//
//	Title: gui_tob_add_level				//
//	Description: Checks oToB for			//
//	maneuvers and populates them in the 	//
//	appropriate listbox for their level.  	//
//	Also sets variables to be used later by //
//	Maneuvers Readied and Quickstrike.		//
//////////////////////////////////////////////

#include "bot9s_inc_index"
#include "bot9s_inc_constants"
#include "bot9s_include"

void AddLevel(object oPC, object oToB, string sClassType)
{
	int nManeuvers = GetNumberOfItemsInInventory(oToB);

	object oManeuver;
	int i, v;
	int nClassType;
	
	if (sClassType == "CR") // pulled off the second parameter of the gui
	{
		nClassType = CLASS_TYPE_CRUSADER;
	}
	else if (sClassType == "SA")
	{
		nClassType = CLASS_TYPE_SAINT;
	}
	else if (sClassType == "SS")
	{
		nClassType = CLASS_TYPE_SWORDSAGE;
	}
	else if (sClassType == "WB")
	{
		nClassType = CLASS_TYPE_WARBLADE;
	}
	else nClassType = CLASS_TYPE_INVALID;

	// Only run this when there's a reason to.
	if (Bot9SHasItem(oPC, "tob")/* && (GetLocalInt(oToB, "CheckListboxStatus") == 0)*/)
	{
		oManeuver = GetFirstItemInInventory(oToB);
		
		i = 1;	// counts rows per level
		v = 0;	// counts items in oToB to prevent an infinite loop
		
		while (v < nManeuvers + 1)
		{
			if (GetLocalInt(oManeuver, "Level") == 0)
			{
				PopulateBot9sMenu(oPC, oManeuver, 0, i, nClassType);
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			else if (GetLocalInt(oManeuver, "Level") != 0)
			{
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			
			if (GetLocalInt(oToB, "CheckI") == 2)
			{//set in PopulateBot9sMenu to correctly assign row numbers to the listboxes
				i++;
				SetLocalInt(oToB, "CheckI", 1);
			}
		}
		// reset values for the next loop
		i = 1;
		v = 0;
		oManeuver = GetFirstItemInInventory(oToB);

		while (v < nManeuvers + 1)
		{
			if (GetLocalInt(oManeuver, "Level") == 1)
			{
				PopulateBot9sMenu(oPC, oManeuver, 1, i, nClassType);
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			else if (GetLocalInt(oManeuver, "Level") != 1)
			{
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			
			if (GetLocalInt(oToB, "CheckI") == 2)
			{
				i++;
				SetLocalInt(oToB, "CheckI", 1);
			}
		}

		i = 1;
		v = 0;
		oManeuver = GetFirstItemInInventory(oToB);
		
		while (v < nManeuvers + 1)
		{
			if (GetLocalInt(oManeuver, "Level") == 2)
			{
				PopulateBot9sMenu(oPC, oManeuver, 2, i, nClassType);
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			else if (GetLocalInt(oManeuver, "Level") != 2)
			{
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			
			if (GetLocalInt(oToB, "CheckI") == 2)
			{
				i++;
				SetLocalInt(oToB, "CheckI", 1);
			}
		}

		i = 1;
		v = 0;
		oManeuver = GetFirstItemInInventory(oToB);
		
		while (v < nManeuvers + 1)
		{
			if (GetLocalInt(oManeuver, "Level") == 3)
			{
				PopulateBot9sMenu(oPC, oManeuver, 3, i, nClassType);
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			else if (GetLocalInt(oManeuver, "Level") != 3)
			{
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			
			if (GetLocalInt(oToB, "CheckI") == 2)
			{
				i++;
				SetLocalInt(oToB, "CheckI", 1);
			}
		}

		i = 1;
		v = 0;
		oManeuver = GetFirstItemInInventory(oToB);
		
		while (v < nManeuvers + 1)
		{
			if (GetLocalInt(oManeuver, "Level") == 4)
			{
				PopulateBot9sMenu(oPC, oManeuver, 4, i, nClassType);
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			else if (GetLocalInt(oManeuver, "Level") != 4)
			{
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			
			if (GetLocalInt(oToB, "CheckI") == 2)
			{
				i++;
				SetLocalInt(oToB, "CheckI", 1);
			}
		}
		
		i = 1;
		v = 0;
		oManeuver = GetFirstItemInInventory(oToB);
		
		while (v < nManeuvers + 1)
		{
			if (GetLocalInt(oManeuver, "Level") == 5)
			{
				PopulateBot9sMenu(oPC, oManeuver, 5, i, nClassType);
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			else if (GetLocalInt(oManeuver, "Level") != 5)
			{
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			
			if (GetLocalInt(oToB, "CheckI") == 2)
			{
				i++;
				SetLocalInt(oToB, "CheckI", 1);
			}
		}

		i = 1;
		v = 0;
		oManeuver = GetFirstItemInInventory(oToB);
		
		while (v < nManeuvers + 1)
		{
			if (GetLocalInt(oManeuver, "Level") == 6)
			{
				PopulateBot9sMenu(oPC, oManeuver, 6, i, nClassType);
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			else if (GetLocalInt(oManeuver, "Level") != 6)
			{
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			
			if (GetLocalInt(oToB, "CheckI") == 2)
			{
				i++;
				SetLocalInt(oToB, "CheckI", 1);
			}
		}

		i = 1;
		v = 0;
		oManeuver = GetFirstItemInInventory(oToB);
		
		while (v < nManeuvers + 1)
		{
			if (GetLocalInt(oManeuver, "Level") == 7)
			{
				PopulateBot9sMenu(oPC, oManeuver, 7, i, nClassType);
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			else if (GetLocalInt(oManeuver, "Level") != 7)
			{
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			
			if (GetLocalInt(oToB, "CheckI") == 2)
			{
				i++;
				SetLocalInt(oToB, "CheckI", 1);
			}
		}

		i = 1;
		v = 0;
		oManeuver = GetFirstItemInInventory(oToB);
		
		while (v < nManeuvers + 1)
		{
			if (GetLocalInt(oManeuver, "Level") == 8)
			{
				PopulateBot9sMenu(oPC, oManeuver, 8, i, nClassType);
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			else if (GetLocalInt(oManeuver, "Level") != 8)
			{
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			
			if (GetLocalInt(oToB, "CheckI") == 2)
			{
				i++;
				SetLocalInt(oToB, "CheckI", 1);
			}
		}
		
		i = 1;
		v = 0;
		oManeuver = GetFirstItemInInventory(oToB);
		
		while (v < nManeuvers + 1)
		{
			if (GetLocalInt(oManeuver, "Level") == 9)
			{
				PopulateBot9sMenu(oPC, oManeuver, 9, i, nClassType);
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			else if (GetLocalInt(oManeuver, "Level") != 9)
			{
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			
			if (GetLocalInt(oToB, "CheckI") == 2)
			{
				i++;
				SetLocalInt(oToB, "CheckI", 1);
			}
		}
	}
}

void AddReadied(object oPC, object oToB, string sClassType)
{
	string sClass;
	
	if (sClassType == "CR") // pulled off the second parameter of the gui
	{
		sClass = "_CR";
	}
	else if (sClassType == "SA")
	{
		sClass = "_SA";
	}
	else if (sClassType == "SS")
	{
		sClass = "_SS";
	}
	else if (sClassType == "WB")
	{
		sClass = "_WB";
	}
	else sClass = "___";

	if (Bot9SHasItem(oPC, "tob")/* && (GetLocalInt(oToB, "CheckListboxStatus") == 0)*/)
	{
		string sRed1 = GetLocalString(oToB, "Readied1" + sClass);
		string sRed2 = GetLocalString(oToB, "Readied2" + sClass);
		string sRed3 = GetLocalString(oToB, "Readied3" + sClass);
		string sRed4 = GetLocalString(oToB, "Readied4" + sClass);
		string sRed5 = GetLocalString(oToB, "Readied5" + sClass);
		string sRed6 = GetLocalString(oToB, "Readied6" + sClass);
		string sRed7 = GetLocalString(oToB, "Readied7" + sClass);
		string sRed8 = GetLocalString(oToB, "Readied8" + sClass);
		string sRed9 = GetLocalString(oToB, "Readied9" + sClass);
		string sRed10 = GetLocalString(oToB, "Readied10" + sClass);
		string sRed11 = GetLocalString(oToB, "Readied11" + sClass);
		string sRed12 = GetLocalString(oToB, "Readied12" + sClass);
		string sRed13 = GetLocalString(oToB, "Readied13" + sClass);
		string sRed14 = GetLocalString(oToB, "Readied14" + sClass);
		string sRed15 = GetLocalString(oToB, "Readied15" + sClass);
		string sRed16 = GetLocalString(oToB, "Readied16" + sClass);

		if (sClass == "_SS")
		{
			string sRed17 = GetLocalString(oToB, "Readied17" + sClass);

			if (sRed17 != "")
			{
				int nRow17 = GetLocalInt(oToB, "ReadiedRow17" + sClass);
				string sIcon17 = "RED_17=" + GetLocalString(oToB, "maneuvers_ICON" + IntToString(nRow17)) + ".tga";

				AddListBoxRow(oPC, "SCREEN_MANEUVERS_READIED_SS", "READIED_17", "RED_PANE_17", "", sIcon17, sRed17, "");

				if (GetLocalInt(oToB, "Readied17_SSDisabled") == 1)
				{
					SetGUIObjectDisabled(oPC, "SCREEN_MANEUVERS_READIED_SS", "READIED_17", FALSE);
				}
			}
		}

		PopulateManeuverReadied(sRed1, sClass, "1");
		PopulateManeuverReadied(sRed2, sClass, "2");
		PopulateManeuverReadied(sRed3, sClass, "3");
		PopulateManeuverReadied(sRed4, sClass, "4");
		PopulateManeuverReadied(sRed5, sClass, "5");
		PopulateManeuverReadied(sRed6, sClass, "6");
		PopulateManeuverReadied(sRed7, sClass, "7");
		PopulateManeuverReadied(sRed8, sClass, "8");
		PopulateManeuverReadied(sRed9, sClass, "9");
		PopulateManeuverReadied(sRed10, sClass, "10");
		PopulateManeuverReadied(sRed11, sClass, "11");
		PopulateManeuverReadied(sRed12, sClass, "12");
		PopulateManeuverReadied(sRed13, sClass, "13");
		PopulateManeuverReadied(sRed14, sClass, "14");
		PopulateManeuverReadied(sRed15, sClass, "15");
		PopulateManeuverReadied(sRed16, sClass, "16");
	}
}

void main(string sClassType)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");

	if ((GetLocalInt(oToB, "Encounter") == 0) || (GetLocalInt(oToB, "AdaptiveStyle") == 1))
	{
		//Used to prevent an issue with saved games clearing out the lisboxes when loaded.
	//	SetLocalInt(oToB, "CheckListboxStatus", 0);
		ClearManeuversKnown(sClassType);
		ClearManeuversReadied(sClassType);
		DelayCommand(0.03, AddLevel(oPC, oToB, sClassType));
		DelayCommand(0.03, AddReadied(oPC, oToB, sClassType));
	}
}