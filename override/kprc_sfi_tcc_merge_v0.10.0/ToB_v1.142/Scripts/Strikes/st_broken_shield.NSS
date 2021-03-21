//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 9/10/2009								//
//	Title: st_broken_shield						//
//	Description: As part of this maneuver, make //
//  a single melee attack. This attack deals an //
//  extra 4d6 points of damage. In addition, the//
//  target must make a Reflex save (DC 14 + your//
//  Str modifier) or become flatfooted until the//
//  start of his next turn.	                	//
//////////////////////////////////////////////////

#include "tob_i0_spells"
#include "bot9s_armor"
#include "bot9s_combat_overrides"
#include "bot9s_inc_feats"
#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 114);
	
	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "SettingSunStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "SettingSunStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nRoll = StrikeAttackRoll(oWeapon, oTarget);

	StrikeAttackSound(oWeapon, oTarget, nRoll, 0.3f);
	DelayCommand(0.1f, BasicAttackAnimation(oWeapon, nRoll)); 
	DelayCommand(0.4f, StrikeWeaponDamage(oWeapon, nRoll, oTarget, d6(4)));
	ExpendManeuver(114, "STR"); 

	if (nRoll > 0)
	{
		int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
		int nDC = GetManeuverDC(nStr, 0, 14);
		int nReflex = MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC);

		if ((nReflex == 0) && (!GetHasFeat(FEAT_UNCANNY_DODGE, oTarget)))
		{
			int nAC = GetAC(oTarget);
			int nFlat = GetFlatFootedAC(oTarget);
			int nPenalty = nAC - nFlat;

			OverrideAttackRollAC(oTarget, 2);
			DelayCommand(6.0f, RemoveAttackRollOverride(oTarget, 1));

			if (nPenalty > 0)
			{
				effect eBroken = EffectACDecrease(nPenalty);
				eBroken = ExtraordinaryEffect(eBroken);

				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBroken, oTarget, 6.0f);
			}
		}

		if (GetLocalInt(oToB, "FallingSun") == 1) //Falling Sun Feat Support
		{
			effect eFallingSun = FallingSunAttack(oTarget);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFallingSun, oTarget, 6.0f);
		}
	}			
}