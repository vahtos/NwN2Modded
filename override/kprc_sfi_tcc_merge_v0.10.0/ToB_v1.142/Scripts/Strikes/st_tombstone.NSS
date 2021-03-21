//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: Halloween 2009					//
//	Title: st_tombstone						//
//	Description: As part of this maneuver,  //
//  you make a single melee attack. If this //
//  attack hits, you deal 2d6 points of     //
//  Constitution damage in addition to your //
//  normal damage.                          //
//////////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 157);

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
	ExpendManeuver(157, "STR");

	int nNonLiving;

	if ((GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT) || (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD))
	{
		nNonLiving = 1;
	}
	else nNonLiving = 0;

	if ((nHit > 0) && (nNonLiving == 0) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_ABILITY_DECREASE)))
	{
		int nNumber;

		if (nHit == 2) // According the the Rules Compendium this does get multiplied.
		{
			nNumber = d6(4);
		}
		else nNumber = d6(2);

		effect eTombstone = EffectAbilityDecrease(ABILITY_CONSTITUTION, nNumber);
		eTombstone = ExtraordinaryEffect(eTombstone);
		eTombstone = SetEffectSpellId(eTombstone, -1);

		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTombstone, oTarget);
		DelayCommand(0.4f, DropDead(oTarget, ABILITY_CONSTITUTION));
	}
}