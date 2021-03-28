//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 10/1/2009								//
//	Title: sa_fiery_assault						//
//	Description: While you are in this stance,  //
//  every melee attack you make deals an extra  //
//  1d6 points of fire damage. This stance is a //
//  supernatural ability.						//
//////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void FieryAssault()
{	
	if (ValidateStance(9))
	{
		object oPC = OBJECT_SELF;
		object oToB = GetItemPossessedBy(oPC, "tob");

		if ((GetCurrentAction(oPC) == ACTION_ATTACKOBJECT) || (GetLocalInt(oPC, "bot9s_maneuver_running") > 0))
		{
			effect eFire = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE);
			eFire = SupernaturalEffect(eFire);
	
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFire, oPC, 1.0f);
		}

		DelayCommand(1.0f, FieryAssault());
	}
}

void main()
{
	FieryAssault();
}