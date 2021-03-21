//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 7/22/2009	 						//
//	Title: st_drain_vit						//
//	Description: As part of this maneuver,  //
//	make a single melee attack. If this 	//
//	attack hits, you deal normal melee		//
//	damage and the target must make a 		//
//	successful Fortitude save (DC 12 + your //
//	Wis modifier) or take 2 points of 		//
//	Constitution damage. A successful save  //
//	negates the Constitution damage but not //
//	the normal melee damage.				//
//////////////////////////////////////////////

#include "tob_i0_spells"
#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 124);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "ShadowHandStrike", 1);
	DelayCommand(RoundsToSeconds(1), SetLocalInt(oToB, "ShadowHandStrike", 0));
	
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);

	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	BasicAttackAnimation(oWeapon, nHit); 
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));
	ExpendManeuver(124, "STR");

	int nNonLiving;

	if ((GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT) || (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD))
	{
		nNonLiving = 1;
	}
	else nNonLiving = 0;

	if ((nHit > 0) && (nNonLiving == 0) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)))
	{
		int nWisdom = GetAbilityModifier(ABILITY_WISDOM, oPC);
		int nDC = GetManeuverDC(nWisdom, 0, 12);
		int nFort = MySavingThrow(SAVING_THROW_FORT, oTarget, nDC);

		if (nFort == 0)
		{
			int nNumber;

			if (nHit == 2) // According the the Rules Compendium this does get multiplied.
			{
				nNumber = 4;
			}
			else nNumber = 2;

			effect eVis = EffectVisualEffect(VFX_HIT_SPELL_EVIL);
			effect eDamage = EffectAbilityDecrease(ABILITY_CONSTITUTION, nNumber);
			eDamage = ExtraordinaryEffect(eDamage);
			eDamage = SetEffectSpellId(eDamage, -1);

			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oTarget);
			DelayCommand(0.3f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
			DelayCommand(0.4f, DropDead(oTarget, ABILITY_CONSTITUTION));
		}
	}
}