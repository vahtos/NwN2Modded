//:://////////////////////////////////////////////////
//:: tob_x0_i0_debug based on X0_I0_DEBUG
/*	Drammel's Note 2/4/2010: This is a copy of the original for use in the Tome of Battle.
	Using modified versions of the original files caues far too many compatibility issues,
	therefore a copy is made which is hooked into the relavent overriden files rather than
	the original.  Thus, I can use all the functionality of the original without worrying about
	recompiling errors into the original versions.
*/
/*
  Small library of debugging functions for nw_i0_generic.
  Included in x0_inc_generic, as that's the first base
  library.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/20/2003
//:://////////////////////////////////////////////////

/**********************************************************************
 * CONSTANTS
 **********************************************************************/


/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

// * displays debug info added since November 2002.
void newdebug(string sString);

// TYPO! Use DebugPrintTalentID(talent tTalent) instead.
// This function is commented out for release; use PrintString for
// debugging.
void DubugPrintTalentID(talent tTalent);

// Prints a log string with the ID of the passed in talent.
// This function is commented out for release; use PrintString for
// debugging.
void DebugPrintTalentID(talent tTalent);

// Inserts a debug print string into the client log file.
// This function is commented out for release; use PrintString for
// debugging.
void MyPrintString(string sString);

/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

void newdebug(string sString)
{
    // SpeakString("New debug = " + sString);
}

void DebugPrintTalentID(talent tTalent)
{
    //int nID = GetIdFromTalent(tTalent);
    //MyPrintString("Using Spell ID: " + IntToString(nID));
}

// Misspelled old version, bleah
void DubugPrintTalentID(talent tTalent)
{
    //int nID = GetIdFromTalent(tTalent);
    //MyPrintString("Using Spell ID: " + IntToString(nID));
}

void MyPrintString(string sString)
{
    //PrintString(sString);
    //SpeakString(sString);
}
