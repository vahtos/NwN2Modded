//:://////////////////////////////////////////////////
//:: tob_x0_i0_modes based on X0_I0_MODES
/*	Drammel's Note 2/4/2010: This is a copy of the original for use in the Tome of Battle.
	Using modified versions of the original files caues far too many compatibility issues,
	therefore a copy is made which is hooked into the relavent overriden files rather than
	the original.  Thus, I can use all the functionality of the original without worrying about
	recompiling errors into the original versions.
*/
/*
  Small include library for various behavior modes,
  such as stealth mode, detect mode, etc.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/19/2003
//:://////////////////////////////////////////////////
//:: Updated On: 04/09/2003 - GZ: Implemented new action
//::                              mode stuff to make this actually work

/**********************************************************************
 * CONSTANTS
 **********************************************************************/

const string sModeVarname = "NW_MODES_CONDITION";

const int NW_MODE_STEALTH                = 0x00000001;
const int NW_MODE_DETECT                 = 0x00000002;

// int NW_MODE_                = 0x00000000;

/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

// TRUE if the given creature has the given mode active
int GetModeActive(int nMode, object oCreature=OBJECT_SELF);

// Mark that the given creature has the given mode active or not
void SetModeActive(int nMode, int bActive=TRUE, object oCreature=OBJECT_SELF);

// If stealth mode is active, turn on the appropriate skills.
void UseStealthMode();

// If detect mode is active, turn on the appropriate skills.
void UseDetectMode();


/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

// TRUE if the given creature has the given mode active
int GetModeActive(int nMode, object oCreature=OBJECT_SELF)
{
    if (nMode ==  NW_MODE_STEALTH)
    {
           return GetActionMode(OBJECT_SELF,ACTION_MODE_STEALTH);
    }
        else if (nMode ==  NW_MODE_DETECT)
    {
           return GetActionMode(OBJECT_SELF,ACTION_MODE_DETECT);
    }
    else
    {  //dummy
        return (GetLocalInt(oCreature, sModeVarname) & nMode);
    }
}

// Mark that the given creature has the given mode active or not
void SetModeActive(int nMode, int bActive=TRUE, object oCreature=OBJECT_SELF)
{

    if (nMode ==  NW_MODE_STEALTH)
    {
        SetActionMode(OBJECT_SELF,ACTION_MODE_STEALTH,bActive);
    }
        else if (nMode ==  NW_MODE_DETECT)
    {
        SetActionMode(OBJECT_SELF,ACTION_MODE_DETECT,bActive);
    }
    else //dummy
    {
        int nCurrentModes = GetLocalInt(oCreature, sModeVarname);
        if (bActive) {
            SetLocalInt(oCreature, sModeVarname, nCurrentModes | nMode);
        } else {
            SetLocalInt(oCreature, sModeVarname, nCurrentModes & ~nMode);
        }
    }
}

// If stealth mode is active, turn on the appropriate skills.
void UseStealthMode()
{
//        SetActionMode(OBJECT_SELF,ACTION_MODE_STEALTH,TRUE);
}

// If detect mode is active, turn on the appropriate skills.
void UseDetectMode()
{
//        SetActionMode(OBJECT_SELF,ACTION_MODE_DETECT,TRUE);
}