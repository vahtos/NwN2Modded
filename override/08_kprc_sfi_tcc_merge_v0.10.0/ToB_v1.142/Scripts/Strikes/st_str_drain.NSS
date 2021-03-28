//////////////////////////////////////////////////////////
//	Author: Drammel										//
//	Date: 8/26/2009	 									//
//	Title: st_str_drain									//
//	Description: As part of this maneuver, you make a   //
//  single melee attack against an opponent. In addition//
//  to dealing normal melee damage with the attack, you //
//  deal 4 points of Strength damage. A successful		//
//  Fortitude save (DC 13 + your Wis modifier) halves 	//
//  this Strength damage, but has no effect on the 		//
//  normal melee damage you deal with the strike.		//
//////////////////////////////////////////////////////////

#include "tob_i0_spells"
#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 140);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "ShadowHandStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "ShadowHandStrike", 0));
	
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);

	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	BasicAttackAnimation(oWeapon, nHit); 
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));
	ExpendManeuver(140, "STR");

	int nNonLiving;

	if ((GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT) || (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD))
	{
		nNonLiving = 1;
	}
	else nNonLiving = 0;

	if (nHit > 0)
	{
		int nWisdom = GetAbilityModifier(ABILITY_WISDOM, oPC);
		int nDC = GetManeuverDC(nWisdom, 0, 13);
		int nFort = MySavingThrow(SAVING_THROW_FORT, oTarget, nDC);

		if ((nFort == 0) && (nNonLiving == 0) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_ABILITY_DECREASE)))
		{
			int nNumber;

			if (nHit == 2) // According the the Rules Compendium this does get multiplied.
			{
				nNumber = 8;
			}
			else nNumber = 4;

			effect eVis = EffectVisualEffect(VFX_HIT_SPELL_EVIL);
			effect eDamage = EffectAbilityDecrease(ABILITY_STRENGTH, nNumber);
			eDamage = ExtraordinaryEffect(eDamage);
			eDamage = SetEffectSpellId(eDamage, -1);

			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oTarget);
			DelayCommand(0.3f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
			DelayCommand(0.4f, DropDead(oTarget, ABILITY_STRENGTH));
		}
		else if (GetHasFeat(6818, oTarget))
		{
			return; //Mettle
		}
		else if ((nNonLiving == 0) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_ABILITY_DECREASE)))// Half Str damage.  Ouch.
		{
			int nNumber;

			if (nHit == 2) // According the the Rules Compendium this does get multiplied.
			{
				nNumber = 4;
			}
			else nNumber = 2;

			effect eVis = EffectVisualEffect(VFX_HIT_SPELL_EVIL);
			effect eDamage = EffectAbilityDecrease(ABILITY_STRENGTH, nNumber);
			eDamage = ExtraordinaryEffect(eDamage);
			eDamage = SetEffectSpellId(eDamage, -1);

			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oTarget);
			DelayCommand(0.3f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
			DelayCommand(0.4f, DropDead(oTarget, ABILITY_STRENGTH));
		}
	}
}