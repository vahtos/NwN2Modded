//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 3/13/2010								//
//	Title: gui_tob_cancel_var					//
//	Description: Sets a variable that flags the //
//  KnownManeuver variables for deletion.		//
//////////////////////////////////////////////////

void main()
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");

	SetLocalInt(oToB, "ManeuversCreated", 1);
}