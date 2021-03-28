//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 4/14/2009									//
//	Name: sf_stn_power								//
//	Description: Reduces attack by 5 and grants ten //
//	temporary hitpoints for six seconds.			//
//////////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void StonePower(object oPC, object oToB)
{
	effect eDecrease = EffectAttackDecrease(5);
	effect eHp = EffectTemporaryHitpoints(10);
	effect eStonePower = EffectLinkEffects(eDecrease, eHp);
	eStonePower = SupernaturalEffect(eStonePower);
	
	if (GetLocalInt(oToB, "StonePower") == 1)
	{
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStonePower, oPC, 6.0f);
		DelayCommand(6.0f, StonePower(oPC, oToB));
	}
	else FloatingTextStringOnCreature("<color=cyan>Stone Power mode was deactivated.</color>", oPC, TRUE, 5.0f, COLOR_CYAN, FOG_COLOR_BLUE_DARK);
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	if (GetLocalInt(oToB, "StonePower") == 0)
	{
		FloatingTextStringOnCreature("<color=cyan>*Stone Power mode activated.*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, FOG_COLOR_BLUE_DARK);
		SetLocalInt(oToB, "StonePower", 1);
		StonePower(oPC, oToB);
	}
	else if (GetLocalInt(oToB, "StonePower") == 1)
	{
		SetLocalInt(oToB, "StonePower", 0);
	}
}