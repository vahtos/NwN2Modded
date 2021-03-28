//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 4/14/2009									//
//	Name: sf_sotwr									//
//	Description: While in a White Raven Stance you	//
//	can activate Inspire Courage as a swift action.	//
//////////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_inc_constants"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	if (GetLocalInt(oToB, "Swift") == 0)
	{
		int nStance = GetLocalInt(oToB, "Stance");
		int nStance2 = GetLocalInt(oToB, "Stance2");

		if (nStance == STANCE_BOLSTERING_VOICE || nStance2 == STANCE_BOLSTERING_VOICE
		|| nStance == STANCE_LEADING_THE_CHARGE || nStance2 == STANCE_LEADING_THE_CHARGE
		|| nStance == STANCE_PRESS_THE_ADVANTAGE || nStance2 == STANCE_PRESS_THE_ADVANTAGE
		|| nStance == STANCE_SWARM_TACTICS || nStance2 == STANCE_SWARM_TACTICS
		|| nStance == STANCE_TACTICS_OF_THE_WOLF || nStance2 == STANCE_TACTICS_OF_THE_WOLF)
		{
			ExecuteScript("nw_s2_sngincour", oPC);
			RunSwiftAction(215, "F");
		}
	}
}