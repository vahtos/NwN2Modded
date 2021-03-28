//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 8/26/2009									//
//	Title: sa_leapn_dragon							//
//	Description: While you are in this stance, you  //
//  gain a +10-foot enhancement bonus on Taunt 		//
//  checks.  In addition, any jumps you make while  //
//  in this stance are considered running jumps.	//
//////////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
		
void LeapingDragonStance()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	if (ValidateStance(175))
	{
		effect eDragon = EffectSkillIncrease(SKILL_TAUNT, 10);
		eDragon = ExtraordinaryEffect(eDragon);

		SetLocalInt(oPC, "LeapingDragonStance", 1);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDragon, oPC, 6.0f);
		DelayCommand(6.0f, LeapingDragonStance());
	}
	else DeleteLocalInt(oPC, "LeapingDragonStance");
}

void main()
{
	LeapingDragonStance();
}