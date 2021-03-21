//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 7/22/2009								//
//	Title: st_stone_vise						//
//	Description: As part of this maneuver, you  //
//	make a single melee attack. This attack  deals an//
//	extra 1d6 points of damage. If the creature //
//	hit is standing on the ground, your attack  //
//	also drops the target’s speed to 0 feet (for//
//  all movement capabilities) for 1 round. It  //
//	can otherwise act normally.	 A successful 	//
//	Fortitude save (DC 12 + your Str modifier)  //
//	by the creature struck negates the 			//
//	immobilization, but not the extra damage.	//
//////////////////////////////////////////////////

#include "tob_i0_spells"
#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 162);

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
	ExpendManeuver(162, "STR");

	if (nHit > 0)
	{
		int nWeapon = GetWeaponType(oWeapon);
		int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
		int nDC = GetManeuverDC(nStr, 0, 12);
		int nFort = MySavingThrow(SAVING_THROW_FORT, oTarget, nDC);
		int nDamageType;

		if (nWeapon == WEAPON_TYPE_PIERCING_AND_SLASHING || nWeapon == WEAPON_TYPE_PIERCING)
		{
			nDamageType = DAMAGE_TYPE_PIERCING;
		}
		else if (nWeapon == WEAPON_TYPE_SLASHING)
		{
			nDamageType = DAMAGE_TYPE_SLASHING;
		}
		else nDamageType = DAMAGE_TYPE_BLUDGEONING;


		if (nFort == 0)
		{
			effect eVis = EffectVisualEffect(VFX_TOB_SKIDBACK);
			effect eVise = EffectMovementSpeedDecrease(99);
			effect eStoneVise = EffectLinkEffects(eVis, eVise);
			eStoneVise = ExtraordinaryEffect(eStoneVise);
			effect eDamage = EffectDamage(d6(1), nDamageType);

			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStoneVise, oTarget, 6.0f);
			DelayCommand(0.3f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
		}
		else
		{
			if (GetHasFeat(6818, oTarget)) // Mettle
			{
				return;
			}
			else
			{
				effect eDamage = EffectDamage(d6(1), nDamageType);
				DelayCommand(0.3f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
			}
		}
	}
}