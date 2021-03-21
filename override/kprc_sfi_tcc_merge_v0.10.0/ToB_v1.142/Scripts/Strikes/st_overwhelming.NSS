//////////////////////////////////////////////////////////
//	Author: Drammel										//
//	Date: 9/8/2009	 									//
//	Title: st_overwhelming								//
//	Description: As part of this maneuver, you make a   //
//  melee attack. This attack deals an extra 2d6 points //
//  of damage. Your attack also causes the target to    //
//  lose its ability to take a move action for 1 round. //
//  It can otherwise act normally. A successful 		//
//  Fortitude save (DC 14 + your Str modifier) by the   //
//  creature struck negates the loss of its move action,//
//  but not the extra damage.							//
//////////////////////////////////////////////////////////

#include "tob_i0_spells"
#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 158);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "StoneDragonStrike", 1);
	DelayCommand(RoundsToSeconds(1), SetLocalInt(oToB, "StoneDragonStrike", 0));
	
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);

	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	BasicAttackAnimation(oWeapon, nHit);
	ExpendManeuver(158, "STR");

	if (nHit == 0)
	{
		DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));
	}
	else if (nHit > 0)
	{
		int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
		int nDC = GetManeuverDC(nStr, 0, 14);
		int nFort = MySavingThrow(SAVING_THROW_FORT, oTarget, nDC);

		if (nFort == 0)
		{
			effect eOverwhelm = EffectMovementSpeedDecrease(99);
			eOverwhelm = ExtraordinaryEffect(eOverwhelm);

			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eOverwhelm, oTarget, 6.0f);
			DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget, d6(2)));
		}
		else if (GetHasFeat(6818, oTarget))
		{
			return; //Mettle
		}
		else
		{
			DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget, d6(2)));
		}
	}
}