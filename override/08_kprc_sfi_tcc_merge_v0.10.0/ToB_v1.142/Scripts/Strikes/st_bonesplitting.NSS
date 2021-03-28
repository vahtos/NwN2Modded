//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 9/8/2009							//
//	Title: st_bonesplitting					//
//	Description: As part of this maneuver,  //
//  you make a single melee attack. If your //
//  attack hits, the target takes normal    //
//  damage as well as 2 points of 			//
//  Constitution damage.					//
//////////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 143);

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
	ExpendManeuver(143, "STR");

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
			nNumber = 4;
		}
		else nNumber = 2;

		effect eSplit = EffectAbilityDecrease(ABILITY_CONSTITUTION, nNumber);
		eSplit = ExtraordinaryEffect(eSplit);
		eSplit = SetEffectSpellId(eSplit, -1);

		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSplit, oTarget);
		DelayCommand(0.4f, DropDead(oTarget, ABILITY_CONSTITUTION));
	}
}