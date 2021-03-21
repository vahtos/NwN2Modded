//////////////////////////////////////////////////////////
//	Author: Drammel										//
//	Date: 10/6/2009										//
//	Title: st_irresistible								//
//	Description: As part of this maneuver, you make a   //
//  single melee attack. This attack deals an extra 4d6 //
//  points of damage. A creature hit by this strike must//
//  also make a successful Fortitude save (DC 16 + your //
//  Str modifier) or become dazed for 1 round.  A       //
//  creature that successfully saves still takes the    //
//  extra damage.				                		//
//////////////////////////////////////////////////////////

#include "tob_i0_spells"
#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 154);

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
	ExpendManeuver(154, "STR");

	if (nHit > 0)
	{
		int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
		int nDC = GetManeuverDC(nStr, 0, 16);
		int nFort = MySavingThrow(SAVING_THROW_FORT, oTarget, nDC);
		int nDamage;

		if (nFort == 0)
		{
			effect eIMS = EffectDazed();
			eIMS = ExtraordinaryEffect(eIMS);
			nDamage = d6(4);

			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eIMS, oTarget, 6.0f);
		}
		else if (GetHasFeat(6818, oTarget)) //Mettle
		{
			nDamage = 0;
		}
		else nDamage = d6(4);

		DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget, nDamage));
	}
	else DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));
}