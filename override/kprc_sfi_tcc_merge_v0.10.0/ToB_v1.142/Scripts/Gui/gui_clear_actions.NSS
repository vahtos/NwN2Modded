//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 7/30/2009								//
//	Name: gui_clear_actions						//
//	Description: Removes all currently enqueued //
//	actions from the action queue, including    //
//	strikes.									//
//////////////////////////////////////////////////

#include "bot9s_include"

void main()
{
	object oPC = GetControlledCharacter(OBJECT_SELF);

	AssignCommand(oPC, ClearAllActions());
	AssignCommand(oPC, ClearStrikes());
}