//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 8/25/2009									//
//	Title: st_bonecrusher							//
//	Description: As part of this maneuver, you make //
//  a melee attack. If your attack hits, it deals an//
//  extra 4d6 points of damage. The creature struck //
//  must succeed on a Fortitude save (DC 13 + your  //
//  Str modifier) or its skeletal structure becomes //
//  massively weakened, and rolls made by strikes to//
//  confirm a critical hit against the target gain a//
//  +10 bonus. A successful save does not negate the//
//  extra damage. This effect lasts until the 		//
//  target's hit points are restored to their full  //
//  normal total, whether by magical or normal 		//
//  healing. Creatures without a discernible anatomy//
//  or that are immune to critical hits are immune  //
//  to this maneuver's special effect. The extra 	//
//  damage still applies against such targets.		//
//////////////////////////////////////////////////////

#include "tob_i0_spells"
#include "bot9s_combat_overrides"
#include "bot9s_inc_maneuvers"

void Bonecrusher(object oTarget)
{
	int nMax = GetMaxHitPoints();
	int nHP = GetCurrentHitPoints();

	if ((nHP >= nMax) || (nHP <= 0))
	{
		RemoveAttackRollOverride(oTarget, 3);
	}
	else AssignCommand(oTarget, DelayCommand(1.0f, Bonecrusher(oTarget)));
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 144);
	
	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "StoneDragonStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "StoneDragonStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nRoll = StrikeAttackRoll(oWeapon, oTarget);

	StrikeAttackSound(oWeapon, oTarget, nRoll, 0.2f);
	BasicAttackAnimation(oWeapon, nRoll); 
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nRoll, oTarget, d6(4)));
	ExpendManeuver(144, "STR");

	if (nRoll > 0)
	{
		int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
		int nDC = GetManeuverDC(nStr, 0, 13);
		int nFort = MySavingThrow(SAVING_THROW_FORT, oTarget, nDC);

		if ((nFort == 0) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)))
		{
			OverrideCritConfirmRoll(oTarget, 10, TRUE);
			AssignCommand(oTarget, Bonecrusher(oTarget));
		}
	}
}