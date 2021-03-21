//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 9/7/2009	 						//
//	Title: st_entangling					//
//	Description: As part of this maneuver,  //
//  you make a melee attack against an 		//
//  opponent. Your attack deals an extra 2d6//
//  points of damage. In addition, if your  //
//  attack hits, your target's speed is 	//
//  reduced by 20 feet until the end of its //
//  next turn, which might prevent it from  //
//  moving entirely.						//
//////////////////////////////////////////////

#include "tob_i0_spells"
#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 39);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DevotedSpiritStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DevotedSpiritStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);

	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	BasicAttackAnimation(oWeapon, nHit); 
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget, d6(2)));
	ExpendManeuver(39, "STR");

	if (nHit > 0)
	{
		effect eVis = EffectVisualEffect(VFX_DUR_ENTANGLE);
		effect eEnt = EffectMovementSpeedDecrease(68); // Rougly 20ft per round.
		eEnt = ExtraordinaryEffect(eEnt);

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 6.0f);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEnt, oTarget, 6.0f);
	}
}