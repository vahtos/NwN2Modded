//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 10/6/2009								//
//	Title: st_crushing_vise						//
//	Description: As part of this maneuver, you  //
//  make a melee attack. This attack deals an   //
//  extra 4d6 points of damage. Your attack also//
//  drops the target’s speed to 0 feet for 1    //
//  round.                                      //
//////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 148);

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
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget, d6(4)));
	ExpendManeuver(148, "STR");

	if (nHit > 0)
	{
		effect eVis = EffectVisualEffect(VFX_TOB_SKIDBACK);
		effect eVise = EffectMovementSpeedDecrease(99);
		effect eCrushingVise = EffectLinkEffects(eVis, eVise);
		eCrushingVise = ExtraordinaryEffect(eCrushingVise);

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCrushingVise, oTarget, 6.0f);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 6.0f);
	}
}