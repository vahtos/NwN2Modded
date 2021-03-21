//////////////////////////////////////////////////
//  Author: Drammel								//
//  Date: 2/28/2010								//
//  Title: bot9s_inc_2da						//
//  Description: Stores 2da data on dataobjects.//
//  The aim of these functions is to reduce 2da //
//  data load times by storing the information  //
//  on sets of dataobjects which represent a 2da//
//  file/column combo.  These dataobjects should//
//  only be created on module load, facilitated //
//  by the pseudo-module event of the Tome of   //
//  Battle item's OnAquired item script.        //
//////////////////////////////////////////////////

/*	These functions are loosely based on BrainMeyer's work.  One reason I'm not using the original version is
	because I don't need all of the extras for PWs.  They tend to use their own lookup and storage systems and
	I've left the option open to switch to those systems in the tob_Get2daFloat, tob_Get2daString, and 
	tob_Get2daInt functions.  For anyone doing so, keep in mind that the Tome of Battle is very large, and that
	indroducing any changes will require you to recomplie its scripts in sections, rather than all at once.  
	
	The other reason I don't use the original is that I'm not as smart as he is, and am still trying to wrap my
	brain around his work.  My version is essentially array functions for dummies :p.  Big thanks to you Brian 
	for sharing your stuff, I can't think of anyone as consistently generous in the community as you are.

	The reason for creating all of this wonderful array stuff, rather than using Get2daString, is that it is
	demonstartably slower than the GetLocal and GetVariable sets of functions, especially when it comes to
	scipts run from Guis.  Boy, do I run a lot of scripts from Guis.
*/

//Prototypes

// Creates an invisible containier object for the objects that represent 2da columns.  Works in a very similar
// manner to how the Tome of Battle object on the player functions, except that it is not carried over on module
// transitions.  There are numeruous advantages to using "plc_ipoint" as the storage object, not the least of
// which is that it acts like a pointer for the 2da objects.  It can also make use of events such as heartbeat.
object tob_Get2daCore();

// Returns the item on the 2da core object which contains the varaibles of a 2da column.  If it does not exist
// this function creates the object.
object tob_Get2daDataObject(string s2da, string sColumn);

// Writes 2da data on the data object with a variable name that coresponds to its 2da index number.
// -o2da: Determines which of the data objects we're writing to.
// -s2da: The 2da file name.
// -sColumn: The name of the column in s2da.
// -nVar: The type of data to write to o2da.  1 = int, 2 = string, 3 = float, all others are ignored.
// -i: The 2da index number to begin writing at.  2das will start at either zero or one.
// -nEnd: Where to end the 2da writing at.
int Write2DAColumn(object o2da, string s2da, string sColumn, int nVar, int i, int nEnd);

// Runs the 2da writing function in a recursive loop in order to avoid Too Many Instructions errors.
// The loop ends when the entire 2da column has been written to the 2da object.
void RecursiveWrite2daColumn(object oPC, string s2da, string sColumn, int nMax, int nVar, int i, int nEnd, int nDomino);

// Sets into motion sequenced 2da data writing to data objects.  The script is recursive so that it can 'wait'
// for 2da data to be written in one column before it moves onto the next.  In this manner, TMI is avoided 
// without having to makes guesses as to when it is safe to run while loops.  To initiate this function, nDomino
// must be set to one and preceeded by the line SetLocalInt(GetModule(), "bot9s_domino", 1);  It should be safe
// to run this function from anywhere.  The recursive firing of this function ends when the switch statement 
// reaches default.
void Domino(object oPC, int nDomino);

// Returns a 2da string.
// -nLookup: Determines how this function finds the 2da data.
string tob_Get2daString(string s2da, string sColumn, int nRow, int nLookup = 1);

// Returns a 2da int.
// -nLookup: Determines how this function finds the 2da data.
int tob_Get2daInt(string s2da, string sColumn, int nRow, int nLookup = 1);

// Returns a 2da float.
// -nLookup: Determines how this function finds the 2da data.
float tob_Get2daFloat(string s2da, string sColumn, int nRow, int nLookup = 1);


// Functions

// Creates an invisible containier object for the objects that represent 2da columns.  Works in a very similar
// manner to how the Tome of Battle object on the player functions, except that it is not carried over on module
// transitions.  There are numeruous advantages to using "plc_ipoint" as the storage object, not the least of
// which is that it acts like a pointer for the 2da objects.  It can also make use of events such as heartbeat.
object tob_Get2daCore()
{
	object oModule = GetModule();
	object o2daCore = GetLocalObject(oModule, "tob_2daCore");

	if (!GetIsObjectValid(o2daCore))
	{
		o2daCore = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_ipoint ", GetStartingLocation(), FALSE, "tob_2daCore"); 
		
		SetPlotFlag(o2daCore, TRUE);
		SetLocalObject(oModule, "tob_2daCore", o2daCore);
		SetFirstName(o2daCore, "tob_2daCore");
		SetLastName(o2daCore, "");
	}

	return o2daCore;
}

// Returns the item on the 2da core object which contains the varaibles of a 2da column.  If it does not exist
// this function creates the object.
object tob_Get2daDataObject(string s2da, string sColumn)
{
	object oCore = tob_Get2daCore();
	string s2daColumn = s2da + sColumn;

	object o2da;

	o2da = GetLocalObject(oCore, s2daColumn);

	if (!GetIsObjectValid(o2da))
	{
		o2da = CreateItemOnObject("maneuver", oCore, 1, s2daColumn, FALSE);

		SetPlotFlag(o2da, TRUE);
		SetLocalObject(oCore, s2daColumn, o2da);
		SetFirstName(o2da, s2daColumn);
	}

	return o2da;
}

// Writes 2da data on the data object with a variable name that coresponds to its 2da index number.
// -o2da: Determines which of the data objects we're writing to.
// -s2da: The 2da file name.
// -sColumn: The name of the column in s2da.
// -nVar: The type of data to write to o2da.  1 = int, 2 = string, 3 = float, all others are ignored.
// -i: The 2da index number to begin writing at.  2das will start at either zero or one.
// -nEnd: Where to end the 2da writing at.
int Write2DAColumn(object o2da, string s2da, string sColumn, int nVar, int i, int nEnd)
{
	if (GetIsObjectValid(o2da))
	{
		if (nVar == 1) //Int
		{
			int nEntry, nTotal, nData;
			string sString, sIndex;
	
			while (i <= nEnd)
			{//The engine reads **** from the 2da files as a blank string.  Actually using "****" checks for "****".
				sString = Get2DAString(s2da, sColumn, i);

				if (sString != "" || sString != "0")
				{
					nEntry = StringToInt(sString);
					sIndex = IntToString(i);
					nData = GetLocalInt(o2da, sIndex);

					if (nData != nEntry)
					{
						SetLocalInt(o2da, sIndex, nEntry);
					}
				}

				i++;
			}
		}
		else if (nVar == 2) //String
		{
			int nTotal;
			string sString, sIndex, sData;

			while (i <= nEnd)
			{
				sString = Get2DAString(s2da, sColumn, i);

				if (sString != "")
				{
					sIndex = IntToString(i);
					sData = GetLocalString(o2da, sIndex);

					if (sData != sString)
					{
						SetLocalString(o2da, sIndex, sString);
					}
				}

				i++;
			}
		}
		else if (nVar == 3) //Float
		{
			int nTotal;
			float fEntry, fData;
			string sString, sIndex;

			while (i <= nEnd)
			{
				sString = Get2DAString(s2da, sColumn, i);

				if (sString != "" || sString != "0.0")
				{
					sIndex = IntToString(i);
					fEntry = StringToFloat(sString);
					fData = GetLocalFloat(o2da, sIndex);

					if (fData != fEntry)
					{
						SetLocalFloat(o2da, sIndex, fEntry);
					}
				}

				i++;
			}
		}
	}

	return i;
}

// Runs the 2da writing function in a recursive loop in order to avoid Too Many Instructions errors.
// The loop ends when the entire 2da column has been written to the 2da object.
void RecursiveWrite2daColumn(object oPC, string s2da, string sColumn, int nMax, int nVar, int i, int nEnd, int nDomino)
{
	object o2da = tob_Get2daDataObject(s2da, sColumn);
	int nColumn = Write2DAColumn(o2da, s2da, sColumn, nVar, i, nEnd); // Returns the int of the last row that was checked.

	if (nColumn <= nMax) // The 2da hasn't been entirely run through yet, so we're picking up where we left off to avoid TMI.
	{
		if (nEnd + 50 > nMax)
		{
			nEnd = nMax;
		}
		else nEnd = nEnd + 50;

		DelayCommand(0.001f, RecursiveWrite2daColumn(oPC, s2da, sColumn, nMax, nVar, nColumn, nEnd, nDomino));
	}
	else SetLocalInt(oPC, "bot9s_domino", nDomino + 1);
}

// Sets into motion sequenced 2da data writing to data objects.  The script is recursive so that it can 'wait'
// for 2da data to be written in one column before it moves onto the next.  In this manner, TMI is avoided 
// without having to makes guesses as to when it is safe to run while loops.  To initiate this function, nDomino
// must be set to one and preceeded by the line SetLocalInt(GetModule(), "bot9s_domino", 1);  It should be safe
// to run this function from anywhere.  The recursive firing of this function ends when the switch statement 
// reaches default.
void Domino(object oPC, int nDomino)
{
	int nCurrent = GetLocalInt(oPC, "bot9s_domino");

	if (nCurrent == nDomino)
	{
		float fDelay = 0.025f;
		int nMax;
		string s2da;

		/* Columns are listed in order of priority to the Tome of Battle's functions.  Any number of 2da columns
		can be added to this list by copying and pasting one of the lines, changing the name of the 2da file and
		column, and correctly setting the variable type (1 = int, 2 = string, 3 = float).  Remember to adjust
		the case number order when you add to it.*/

		switch (nCurrent)
		{
			case 1:		s2da = "maneuvers";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "Script", nMax, 2, 0, 50, nCurrent);						DelayCommand(fDelay, Domino(oPC, 2));			break;
			case 2:		s2da = "maneuvers";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "ICON", nMax, 2, 0, 50, nCurrent);						DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 3:		s2da = "maneuvers";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "StrRef", nMax, 1, 0, 50, nCurrent);						DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 4:		s2da = "maneuvers";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "Description", nMax, 1, 0, 50, nCurrent);				DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 5:		s2da = "maneuvers";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "Level", nMax, 1, 0, 50, nCurrent);						DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 6:		s2da = "maneuvers";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "Mastery", nMax, 1, 0, 50, nCurrent);					DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 7:		s2da = "maneuvers";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "IsStance", nMax, 1, 0, 50, nCurrent);					DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 8:		s2da = "maneuvers";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "IsStance", nMax, 1, 0, 50, nCurrent);					DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 9:		s2da = "maneuvers";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "Discipline", nMax, 1, 0, 50, nCurrent);					DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 10:	s2da = "maneuvers";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "Type", nMax, 1, 0, 50, nCurrent);						DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 11:	s2da = "maneuvers";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "Movement", nMax, 1, 0, 50, nCurrent);					DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 12:	s2da = "maneuvers";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "Location", nMax, 1, 0, 50, nCurrent);					DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 13:	s2da = "maneuvers";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "SupressAoO", nMax, 1, 0, 50, nCurrent);					DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 14:	s2da = "maneuvers";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "Range", nMax, 1, 0, 50, nCurrent);						DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 15:	s2da = "appearance";	nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "PREFATCKDIST", nMax, 3, 0, 50, nCurrent);				DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 16:	s2da = "appearance";	nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "HITDIST", nMax, 3, 0, 50, nCurrent);					DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 17:	s2da = "baseitems";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "PrefAttackDist", nMax, 3, 0, 50, nCurrent);				DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 18:	s2da = "baseitems";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "NumDice", nMax, 1, 0, 50, nCurrent);					DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 19:	s2da = "baseitems";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "DieToRoll", nMax, 1, 0, 50, nCurrent);					DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 20:	s2da = "baseitems";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "CritThreat", nMax, 1, 0, 50, nCurrent);					DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 21:	s2da = "baseitems";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "CritHitMult", nMax, 1, 0, 50, nCurrent);				DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 22:	s2da = "baseitems";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "FEATImprCrit", nMax, 1, 0, 50, nCurrent);				DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 23:	s2da = "baseitems";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "FEATWpnFocus", nMax, 1, 0, 50, nCurrent);				DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 24:	s2da = "baseitems";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "FEATWpnSpec", nMax, 1, 0, 50, nCurrent);				DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 25:	s2da = "baseitems";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "FEATEpicDevCrit", nMax, 1, 0, 50, nCurrent);			DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 26:	s2da = "baseitems";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "FEATEpicWpnFocus", nMax, 1, 0, 50, nCurrent);			DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 27:	s2da = "baseitems";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "FEATEpicWpnSpec", nMax, 1, 0, 50, nCurrent);			DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 28:	s2da = "baseitems";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "FEATOverWhCrit", nMax, 1, 0, 50, nCurrent);				DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 29:	s2da = "baseitems";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "FEATWpnOfChoice", nMax, 1, 0, 50, nCurrent);			DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 30:	s2da = "baseitems";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "FEATGrtrWpnFocus", nMax, 1, 0, 50, nCurrent);			DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 31:	s2da = "baseitems";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "FEATGrtrWpnSpec", nMax, 1, 0, 50, nCurrent);			DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 32:	s2da = "baseitems";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "FEATPowerCrit", nMax, 1, 0, 50, nCurrent);				DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 33:	s2da = "iprp_feats";	nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "Label", nMax, 2, 0, 50, nCurrent);						DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 34:	s2da = "iprp_feats";	nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "FeatIndex", nMax, 1, 0, 50, nCurrent);					DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 35:	s2da = "armorrulestats";nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "ACCHECK", nMax, 1, 0, 50, nCurrent);					DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 36:	s2da = "spells";		nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "School", nMax, 2, 0, 50, nCurrent);						DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 37:	s2da = "nwn2_deities";	nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "FirstName", nMax, 2, 0, 50, nCurrent);					DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 38:	s2da = "nwn2_deities";	nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "FavoredWeaponFocus", nMax, 1, 0, 50, nCurrent);			DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 39:	s2da = "nwn2_deities";	nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "FavoredWeaponSpecialization", nMax, 1, 0, 50, nCurrent);DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 40:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "ICON", nMax, 2, 0, 50, nCurrent);						DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 41:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "FEAT", nMax, 1, 0, 50, nCurrent);						DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 42:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "FeatCategory", nMax, 2, 0, 50, nCurrent);				DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 43:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "OrReqFeat0", nMax, 1, 0, 50, nCurrent);					DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 44:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "OrReqFeat1", nMax, 1, 0, 50, nCurrent);					DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 45:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "OrReqFeat2", nMax, 1, 0, 50, nCurrent);					DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 46:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "OrReqFeat3", nMax, 1, 0, 50, nCurrent);					DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 47:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "OrReqFeat4", nMax, 1, 0, 50, nCurrent);					DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 48:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "OrReqFeat5", nMax, 1, 0, 50, nCurrent);					DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 49:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "PREREQFEAT1", nMax, 1, 0, 50, nCurrent);				DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 50:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "PREREQFEAT2", nMax, 1, 0, 50, nCurrent);				DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 51:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "REMOVED", nMax, 1, 0, 50, nCurrent);					DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 52:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "MAXSTR", nMax, 1, 0, 50, nCurrent);						DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 53:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "MAXDEX", nMax, 1, 0, 50, nCurrent);						DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 54:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "MAXCON", nMax, 1, 0, 50, nCurrent);						DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 55:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "MAXINT", nMax, 1, 0, 50, nCurrent);						DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 56:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "MAXWIS", nMax, 1, 0, 50, nCurrent);						DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 57:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "MAXCHA", nMax, 1, 0, 50, nCurrent);						DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 58:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "REQSKILL", nMax, 1, 0, 50, nCurrent);					DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 59:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "REQSKILL2", nMax, 1, 0, 50, nCurrent);					DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 60:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "ReqSkillMinRanks", nMax, 1, 0, 50, nCurrent);			DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 61:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "ReqSkillMinRanks2", nMax, 1, 0, 50, nCurrent);			DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 62:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "MINSTR", nMax, 1, 0, 50, nCurrent);						DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 63:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "MINDEX", nMax, 1, 0, 50, nCurrent);						DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 64:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "MINCON", nMax, 1, 0, 50, nCurrent);						DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 65:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "MININT", nMax, 1, 0, 50, nCurrent);						DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 66:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "MINWIS", nMax, 1, 0, 50, nCurrent);						DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 67:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "MINCHA", nMax, 1, 0, 50, nCurrent);						DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 68:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "MinLevelClass", nMax, 1, 0, 50, nCurrent);				DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 69:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "MinLevel", nMax, 1, 0, 50, nCurrent);					DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 70:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "MaxLevel", nMax, 1, 0, 50, nCurrent);					DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 71:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "MinFortSave", nMax, 1, 0, 50, nCurrent);				DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 72:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "AlignRestrict", nMax, 1, 0, 50, nCurrent);				DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			case 73:	s2da = "feat";			nMax = GetNum2DARows(s2da);	RecursiveWrite2daColumn(oPC, s2da, "MINATTACKBONUS", nMax, 1, 0, 50, nCurrent);				DelayCommand(fDelay, Domino(oPC, nDomino + 1));	break;
			default:	DeleteLocalInt(oPC, "bot9s_domino");	return;
		}
	}
	else DelayCommand(0.1f, Domino(oPC, nDomino));
}

// Returns a 2da string.
// -nLookup: Determines how this function finds the 2da data.
string tob_Get2daString(string s2da, string sColumn, int nRow, int nLookup = 1)
{
	string sReturn;

	if (nLookup == 0) // Straight 2da lookup.  Not optimal in a PW environment, but just dandy for single player.
	{
		sReturn = Get2DAString(s2da, sColumn, nRow);
	}
	else if (nLookup == 1) //The Tome of Battle's lookup system.
	{
		object o2da = tob_Get2daDataObject(s2da, sColumn);

		if (GetIsObjectValid(o2da))
		{
			sReturn = GetLocalString(o2da, IntToString(nRow));

			if (sReturn == "")
			{
				sReturn = Get2DAString(s2da, sColumn, nRow);
			}
		}
		else sReturn = Get2DAString(s2da, sColumn, nRow);
	}
	else if (nLookup == 2) //Other sytems here.
	{
		/* Use this space when you already have a 2da storage system in place.  This option exists so that
		you can route your own lookup system into the Tome of Battle's scripts with minimal effort.*/
	}

	return sReturn;
}

// Returns a 2da int.
// -nLookup: Determines how this function finds the 2da data.
int tob_Get2daInt(string s2da, string sColumn, int nRow, int nLookup = 1)
{
	int nReturn;

	if (nLookup == 0) // Straight 2da lookup.  Not optimal in a PW environment, but just dandy for single player.
	{
		string sReturn = Get2DAString(s2da, sColumn, nRow);
		nReturn = StringToInt(sReturn);
	}
	else if (nLookup == 1) //The Tome of Battle's lookup system.
	{
		object o2da = tob_Get2daDataObject(s2da, sColumn);

		if (GetIsObjectValid(o2da))
		{
			nReturn = GetLocalInt(o2da, IntToString(nRow));

			if (nReturn == 0)
			{
				string sReturn = Get2DAString(s2da, sColumn, nRow);
				nReturn = StringToInt(sReturn);
			}
		}
		else
		{
			string sReturn = Get2DAString(s2da, sColumn, nRow);
			nReturn = StringToInt(sReturn);
		}
	}
	else if (nLookup == 2) //Other sytems here.
	{
		/* Use this space when you already have a 2da storage system in place.  This option exists so that
		you can route your own lookup system into the Tome of Battle's scripts with minimal effort.*/
	}

	return nReturn;
}

// Returns a 2da float.
// -nLookup: Determines how this function finds the 2da data.
float tob_Get2daFloat(string s2da, string sColumn, int nRow, int nLookup = 1)
{
	float fReturn;

	if (nLookup == 0) // Straight 2da lookup.  Not optimal in a PW environment, but just dandy for single player.
	{
		string sReturn = Get2DAString(s2da, sColumn, nRow);
		fReturn = StringToFloat(sReturn);
	}
	else if (nLookup == 1) //The Tome of Battle's lookup system.
	{
		object o2da = tob_Get2daDataObject(s2da, sColumn);

		if (GetIsObjectValid(o2da))
		{
			fReturn = GetLocalFloat(o2da, IntToString(nRow));

			if (fReturn == 0.0f)
			{
				string sReturn = Get2DAString(s2da, sColumn, nRow);
				fReturn = StringToFloat(sReturn);
			}
		}
		else
		{
			string sReturn = Get2DAString(s2da, sColumn, nRow);
			fReturn = StringToFloat(sReturn);
		}
	}
	else if (nLookup == 2) //Other sytems here.
	{
		/* Use this space when you already have a 2da storage system in place.  This option exists so that
		you can route your own lookup system into the Tome of Battle's scripts with minimal effort.*/
	}

	return fReturn;
}