//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 10/26/2009								//
//	Name: gui_gdivine_surge							//
//	Description: Controls the amount of constitution//
//  damage you take when you use Greater Divine     //
//  Surge.  For every point of constitution damage  //
//  you take the damage dealt with Greater Divine   //
//  Surge increases by 2d8.  You may take           //
//  constitution damage up to your initiator level.	//
//////////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nInit = GetInitiatorLevel(oPC);
	int nMax = GetAbilityScore(oPC, ABILITY_CONSTITUTION);
	int nCon = GetLocalInt(oToB, "GDivineCon");
	int nInitiator;

	if (nMax > nInit)
	{
		nInitiator = nInit;
	}
	else nInitiator = nMax;

	if (nCon == nInitiator + 1)
	{
		SetLocalInt(oToB, "GDivineCon", 0);
		FloatingTextStringOnCreature("<color=cyan>You will take 0 Con damage when you use Greater Divine Surge.</color>", oPC, TRUE, 5.0f, COLOR_CYAN, FOG_COLOR_BLUE_DARK);
	}
	else
	{
		SetLocalInt(oToB, "GDivineCon", nCon + 1);
		FloatingTextStringOnCreature("<color=cyan>You will take " + IntToString(nCon + 1) + " Con damage when you use Greater Divine Surge.</color>", oPC, TRUE, 5.0f, COLOR_CYAN, FOG_COLOR_BLUE_DARK);
	}
}