//////////////////////////////////////////////////////////
//	Author: Drammel										//
//	Date: 8/27/2009										//
//	Title: st_death_mark								//
//	Description: When you use the strike, you channel 	//
//  overwhelming fiery energy into the body of your foe.//
//  In addition to dealing normal melee damage with your//
//  attack, you cause fire to erupt from your enemy’s 	//
//  body in a spread. Small or smaller creatures produce//
//  a 5 foot radius; Medium 10 feet; Large 20 feet; Huge//
//  30 feet; Gargantuan 40 feet.  The radius of the 	//
//  spread is determined by the size of the target 		//
//  creature. All creatures in the area, including your //
//  enemy, take 6d6 points of fire damage, with a Reflex//
//  save (DC 13 + your Wis modifier) for half. This 	//
//  radius is centered on the creature’s position.  You //
//  have immunity to the fire damage from your own death//
//  mark.												//
//////////////////////////////////////////////////////////

#include "tob_i0_spells"
#include "bot9s_include"
#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 4);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DesertWindStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DesertWindStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);
	effect eVis = EffectVisualEffect(VFX_HIT_AOE_FIRE);

	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	BasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));
	ExpendManeuver(4, "STR");

	if (nHit > 0)
	{
		int nSize = GetCreatureSize(oTarget);
		float fGirth = GetGirth(oTarget);
		float fRange;

		switch (nSize)
		{
			case CREATURE_SIZE_INVALID: fRange = FeetToMeters(5.0f) + fGirth;	break;
			case CREATURE_SIZE_TINY: 	fRange = FeetToMeters(5.0f) + fGirth;	break;
			case CREATURE_SIZE_SMALL: 	fRange = FeetToMeters(5.0f) + fGirth;	break;
			case CREATURE_SIZE_MEDIUM: 	fRange = FeetToMeters(10.0f) + fGirth;	break;
			case CREATURE_SIZE_LARGE: 	fRange = FeetToMeters(20.0f) + fGirth;	break;
			case CREATURE_SIZE_HUGE: 	fRange = FeetToMeters(30.0f) + fGirth;	break;
			default:					fRange = FeetToMeters(40.0f) + fGirth;	break;
		}

		object oMarked;
		effect eFire;
		int nFire;
		int nWisdom = GetAbilityModifier(ABILITY_WISDOM, oPC);
		int nDC = GetManeuverDC(nWisdom, 0, 13);
		location lTarget = GetLocation(oTarget);

		oMarked = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lTarget, TRUE);

		while (GetIsObjectValid(oMarked))
		{
			if (GetIsReactionTypeHostile(oMarked, oPC))
			{
				nFire = Bot9sReflexAdjustedDamage(d6(6), oMarked, nDC, SAVING_THROW_TYPE_FIRE);
				eFire = EffectDamage(nFire, DAMAGE_TYPE_FIRE);

				ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oMarked);
			}
		
			oMarked = GetNextObjectInShape(SHAPE_SPHERE, fRange, lTarget, TRUE);
		}
	}
}