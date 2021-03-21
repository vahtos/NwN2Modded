//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 9/15/2009									//
//	Title: st_radiant_charge						//
//	Description: You must make a charge attack as   //
//  part of this maneuver. If the target is evil    //
//  aligned, your attack deals an extra 6d6 points  //
//  of damage. In addition, if your charge attack   //
//  hits and the target is evil-aligned, you become //
//  wreathed in holy energy. You gain damage        //
//  reduction 10/— until the beginning of your next //
//  turn.											//
//////////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 45);
	
	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DevotedSpiritStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DevotedSpiritStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget, 2);
	int nAlign = GetAlignmentGoodEvil(oTarget);

	StrikeAttackSound(oWeapon, oTarget, nHit, 0.3f);
	DelayCommand(0.1f, BasicAttackAnimation(oWeapon, nHit)); 
	ExpendManeuver(45, "STR");

	if (nAlign == ALIGNMENT_EVIL)
	{
		DelayCommand(0.4f, StrikeWeaponDamage(oWeapon, nHit, oTarget, d6(6)));
	}
	else DelayCommand(0.4f, StrikeWeaponDamage(oWeapon, nHit, oTarget));

	if ((nAlign == ALIGNMENT_EVIL) && (nHit > 0))
	{
		effect eCharge = EffectVisualEffect(VFX_TOB_RADIANT_CHARGE);
		effect eRadiant = EffectDamageReduction(10, DAMAGE_POWER_NORMAL, 0, DR_TYPE_EPIC);
		eRadiant = ExtraordinaryEffect(eRadiant);

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRadiant, oPC, 6.0f);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCharge, oPC, 6.0f);
	}
}