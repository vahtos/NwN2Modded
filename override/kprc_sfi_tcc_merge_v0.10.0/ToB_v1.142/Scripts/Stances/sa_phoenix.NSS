//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 10/24/2009							//
//	Title: sa_phoenix							//
//	Description: A column of superheated air    //
//  surrounds you.  If you remain in place for a//
//  round or more, the column of air becomes    //
//  scorching, dealing 3d6 points of fire damage//
//  to creatures within five feet of you. You   //
//  are not harmed by this effect.  While you   //
//  maintain this stance, if you are reduced to //
//  zero or fewer hit points you immolate in a  //
//  burst of fire and superheated air.  This    //
//  immolation causes you to return to life with//
//  one hit point.  Additionally, all creatures //
//  within a thirty foot radius of you are      //
//  caught in your fiery immolation, dealing 8d6//
//  damage to them.   Half of this damage is    //
//  fire and half sonic.  The Rising Phoenix    //
//  stance immediately ends when you immolate.  //
//  You can only immolate once per encounter.   //
//////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"
#include "tob_i0_spells"

void RisingPhoenix(object oPC, object oToB, float fRange, effect eHit)
{
	if (ValidateStance(21))
	{
		location lPC = GetLocation(oPC);
		location lPhoenix = GetLocalLocation(oPC, "RisingPhoenix_loc");
		float fDist = GetDistanceBetweenLocations(lPC, lPhoenix);

		if (fDist <= FeetToMeters(5.0f))
		{
			int nWisdom = GetAbilityModifier(ABILITY_WISDOM, oPC);
			int nDC = GetManeuverDC(nWisdom, 0, 18);
			int nDamage;
			effect eDamage;

			object oFoe;

			oFoe = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);

			if (GetIsObjectValid(oFoe))
			{
				while (GetIsObjectValid(oFoe))
				{
					if (spellsIsTarget(oFoe, SPELL_TARGET_STANDARDHOSTILE, oPC))
					{
						nDamage = Bot9sReflexAdjustedDamage(d6(3), oFoe, nDC, SAVING_THROW_TYPE_FIRE);
	
						if (nDamage > 0)
						{
							eDamage = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
	
							ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oFoe);
							ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oFoe);
						}
					}
	
					oFoe = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);
				}
			}
		}

		SetLocalLocation(oPC, "RisingPhoenix_loc", lPC);
		DelayCommand(6.0f, RisingPhoenix(oPC, oToB, fRange, eHit));
	}
	else
	{
		if (GetHasSpellEffect(6560))
		{
			RemoveSpellEffects(6560, oPC, oPC);
		}

		DeleteLocalLocation(oPC, "RisingPhoenix_loc");
	}
}

void Immolate(object oPC, object oToB, float fBurst, effect eHit)
{
	if (ValidateStance(21))
	{
		if ((GetLocalInt(oToB, "RisingPhoenix") == 0) && (!GetHasSpellEffect(6560, oPC)))
		{
			SetLocalInt(oToB, "RisingPhoenix", 1);
			SetLocalInt(oToB, "Stance", 0);
			SetLocalInt(oToB, "Stance2", 0);

			location lPC = GetLocation(oPC);
			int nWisdom = GetAbilityModifier(ABILITY_WISDOM, oPC);
			int nDC = GetManeuverDC(nWisdom, 0, 18);
			effect eImmolate = EffectVisualEffect(VFX_TOB_PHOENIX);
			int nPhoenix;
			effect eFire, eSonic, ePhoenix;
			float fDist, fDelay;

			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eImmolate, oPC, 6.0f);

			object oFoe;

			oFoe = GetFirstObjectInShape(SHAPE_SPHERE, fBurst, lPC, TRUE);

			while (GetIsObjectValid(oFoe))
			{
				if (spellsIsTarget(oFoe, SPELL_TARGET_STANDARDHOSTILE, oPC))
				{
					nPhoenix = Bot9sReflexAdjustedDamage(d6(8), oFoe, nDC, SAVING_THROW_TYPE_SONIC) / 2;

					if (nPhoenix > 0)
					{
						fDist = GetDistanceBetween(oPC, oFoe);
						fDelay = fDist / 20;
						eFire = EffectDamage(nPhoenix, DAMAGE_TYPE_FIRE);
						eSonic = EffectDamage(nPhoenix, DAMAGE_TYPE_SONIC);
						ePhoenix = EffectLinkEffects(eFire, eSonic);

						DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oFoe));
						DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePhoenix, oFoe));
						WrapperPlayCustomAnimation(oPC, "mjr_conjure", 0);
					}
				}

				oFoe = GetNextObjectInShape(SHAPE_SPHERE, fBurst, lPC, TRUE);
			}
		}

		DelayCommand(0.1f, Immolate(oPC, oToB, fBurst, eHit));
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	float fRange = GetGirth(oPC) + FeetToMeters(5.0f);
	float fBurst = GetGirth(oPC) + FeetToMeters(30.0f);
	effect eHit = EffectVisualEffect(VFX_TOB_PHOENIX_HIT);
	location lPC = GetLocation(oPC);

	if (GetLocalInt(oToB, "Encounter") == 0)
	{
		SetLocalInt(oToB, "RisingPhoenix", 0);
	}

	if (GetLocalInt(oToB, "RisingPhoenix") == 0)
	{
		if (GetHasSpellEffect(6560, oPC))
		{
			RemoveSpellEffects(6560, oPC, oPC);
		}

		int nWisdom;

		if (GetAbilityModifier(ABILITY_WISDOM, oPC) < 1)
		{
			nWisdom = 1;
		}
		else nWisdom = GetAbilityModifier(ABILITY_WISDOM, oPC);

		int nInit = GetInitiatorLevel(oPC);
		int nHeal = nInit * nWisdom;
		effect eRising = EffectHealOnZeroHP(oPC, nHeal);
		eRising = SupernaturalEffect(eRising);
		eRising = SetEffectSpellId(eRising, 6560);

		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRising, oPC);
	}

	SetLocalLocation(oPC, "RisingPhoenix_loc", lPC);
	RisingPhoenix(oPC, oToB, fRange, eHit);
	DelayCommand(0.1f, Immolate(oPC, oToB, fBurst, eHit));
}