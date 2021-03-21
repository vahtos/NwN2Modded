//////////////////////////////////////////////////////
//  Author: Drammel									//
//  Date: 10/27/2009								//
//  Title: sa_alacrity								//
//  Description: While you are in this stance, you  //
//  can use one counter per round without taking an //
//  immediate action. You cannot use the same       //
//  maneuver two times in a round. In essence, one  //
//  counter you use during the round does not       //
//  require an immediate action. If you have already//
//  taken an immediate action within the past round,//
//  you can still use this stance to initiate a     //
//  counter.                                        //
//////////////////////////////////////////////////////

	/* Half of the work of this function is covered in bot9s_inc_maneuvers
	under the function RunSwiftAction. */

#include "bot9s_inc_maneuvers"

void StanceOfAlacrity()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	if (ValidateStance(73))
	{
		SetLocalInt(oToB, "AlacrityCounter", 0);
		SetLocalInt(oToB, "StanceOfAlacrity", 1);
		DelayCommand(6.0f, StanceOfAlacrity());
	}
	else 
	{
		DeleteLocalInt(oToB, "AlacrityCounter");
		DeleteLocalInt(oToB, "StanceOfAlacrity");
	}
}


void main()
{
	StanceOfAlacrity();
}