//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 4/13/2009									//
//	Name: sf_avenge_strike							//
//	Description: Handles the daily uses of the feat	//
//	Avenging Strike.								//
//////////////////////////////////////////////////////

#include "bot9s_include"
#include "bot9s_inc_constants"
	
void main()
{
	object oPC = OBJECT_SELF;

	if (!GetHasFeat(FEAT_AVENGING_STRIKE, oPC))
	{
		WrapperFeatAdd(oPC, FEAT_AVENGING_STRIKE, FALSE);
	}

	int nMyCHA = GetAbilityModifier(ABILITY_CHARISMA);

	if (GetLastRestEventType() == REST_EVENTTYPE_REST_FINISHED)
	{
		SetLocalInt(oPC, "AvengingStrikeUses", nMyCHA);
	}
}