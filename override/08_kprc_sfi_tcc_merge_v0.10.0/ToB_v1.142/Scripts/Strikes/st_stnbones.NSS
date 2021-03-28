//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 2/9/2009							//
//	Title: st_stnbones						//
//	Description: Standard Action; On a		//
//	successful hit with this maneuver, gain	//
//	DR 5/adamantine.						//
//////////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 160);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "StoneDragonStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "StoneDragonStrike", 0));
	
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);
	
	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	BasicAttackAnimation(oWeapon, nHit); 
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));
	ExpendManeuver(160, "STR");

	if (nHit > 0)
	{
		effect eVis = EffectNWN2SpecialEffectFile("sp_stoneskin", oPC);
		effect eDR = EffectDamageReduction(5, GMATERIAL_METAL_ADAMANTINE, 0, DR_TYPE_GMATERIAL);
		eDR = ExtraordinaryEffect(eDR);

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDR, oPC, 6.0f);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPC, 6.0f);
	}
}