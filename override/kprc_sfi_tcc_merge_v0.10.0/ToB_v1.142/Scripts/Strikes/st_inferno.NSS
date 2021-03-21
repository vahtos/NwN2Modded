//////////////////////////////////////////////////////////////////
//	Author: Drammel												//
//	Date: 10/30/2009											//
//	Title: st_inferno   										//
//	Description: You focus your internal ki into a blinding hot //
//  burst of fire that deals 100 points of fire damage to all   //
//  creatures in the area. You are not harmed by your own       //
//  inferno blast.                                              //
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

	float fRange = FeetToMeters(60.0f);
	location lPC = GetLocation(oPC);
	int nWisdom = GetAbilityModifier(ABILITY_WISDOM, oPC);
	int nDC = GetManeuverDC(nWisdom, 0, 19);
	effect eHit = EffectVisualEffect(VFX_TOB_PHOENIX_HIT);
	effect eVis = EffectVisualEffect(VFX_TOB_INFERNO);

	object oBurned;
	int nDamage;
	effect eDamage;
	float fDist, fDelay;

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPC, 4.0f);
	oBurned = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);

	while (GetIsObjectValid(oBurned))
	{
		if ((oBurned != oPC) && (spellsIsTarget(oBurned, SPELL_TARGET_STANDARDHOSTILE, oPC)))
		{
			fDist = GetDistanceBetween(oPC, oBurned);
			fDelay = fDist / 20;
			nDamage = Bot9sReflexAdjustedDamage(100, oBurned, nDC, SAVING_THROW_TYPE_FIRE);

			DelayCommand(1.0f + fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHit, oBurned, 2.0f));

			if (nDamage > 0)
			{
				eDamage = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
				DelayCommand(1.0f + fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oBurned));
			}
		}

		oBurned = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);
	}

	ExpendManeuver(17, "STR");
}