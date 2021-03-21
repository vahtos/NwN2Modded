//////////////////////////////////////////////////////////////////
//	Author: Drammel												//
//	Date: 9/15/2009												//
//	Title: st_disrupting										//
//	Description: As part of this maneuver, you make a melee     //
//  attack. If this attack hits, your target takes normal melee //
//  damage and must make a Will save (DC 15 + your Str modifier)//
//  or be unable to take any actions for 1 round.               //
//////////////////////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "tob_i0_spells"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 59);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DiamondMindStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DiamondMindStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);

	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	BasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));
	ExpendManeuver(59, "STR");

	if (nHit > 0)
	{
		int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
		int nDC = GetManeuverDC(nStr, 0, 15);
		int nWill = MySavingThrow(SAVING_THROW_WILL, oTarget, nDC);

		if (nWill == 0)
		{
			effect eVis = EffectVisualEffect(VFX_DUR_STUN);
			effect eDisrupting = EffectDazed();
			eDisrupting = ExtraordinaryEffect(eDisrupting);
	
			DelayCommand(0.3f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 6.0f));
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDisrupting, oTarget, 6.0f);
		}
	}
}