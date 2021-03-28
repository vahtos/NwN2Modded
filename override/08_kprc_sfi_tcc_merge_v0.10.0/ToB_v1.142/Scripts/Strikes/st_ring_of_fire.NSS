//////////////////////////////////////////////////////////////////
//	Author: Drammel												//
//	Date: 10/11/2009											//
//	Title: st_ring_of_fire										//
//	Description: A raging inferno erupts within the area        //
//  surrounding you. All creatures within the area take 12d6    //
//  points of fire damage, with a Reflex save (DC 16 + your Wis //
//  modifier) for half damage.  You are not damaged by your own //
//  Ring of Fire.                                               //
//////////////////////////////////////////////////////////////////

#include "tob_i0_spells"
#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"
	
void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	SetLocalInt(oToB, "DesertWindStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DesertWindStrike", 0));
	WrapperPlayCustomAnimation(oPC, "mspirit", 0);

	float fRange = FeetToMeters(30.0f) + GetGirth(oPC);
	location lPC = GetLocation(oPC);
	int nWisdom = GetAbilityModifier(ABILITY_WISDOM, oPC);
	int nDC = GetManeuverDC(nWisdom, 0, 16);
	effect eHit = EffectVisualEffect(VFX_HIT_AOE_FIRE);
	effect eVis = EffectVisualEffect(VFX_TOB_RINGOFFIRE);

	object oBurned;
	int nDamage;
	effect eDamage;
	float fDist, fDelay;

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPC, 3.0f);
	oBurned = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);

	while (GetIsObjectValid(oBurned))
	{
		if ((oBurned != oPC) && (spellsIsTarget(oBurned, SPELL_TARGET_STANDARDHOSTILE, oPC)))
		{
			fDist = GetDistanceBetween(oPC, oBurned);
			fDelay = fDist / 20.0f;
			nDamage = Bot9sReflexAdjustedDamage(d6(12), oBurned, nDC, SAVING_THROW_TYPE_FIRE);

			DelayCommand(1.0f + fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oBurned));

			if (nDamage > 0)
			{
				eDamage = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
				DelayCommand(1.0f + fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oBurned));
			}
		}

		oBurned = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);
	}

	ExpendManeuver(20, "STR");
}