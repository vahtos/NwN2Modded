//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 9/10/2009								//
//	Title: st_handodeath						//
//	Description: As part of this maneuver, you  //
//  make a single melee attack. This attack 	//
//  deals an extra 2d6 points of damage and 	//
//  automatically overcomes damage reduction.	//
//////////////////////////////////////////////////

#include "tob_i0_spells"
#include "bot9s_armor"
#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 128);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "ShadowHandStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "ShadowHandStrike", 0));

	if (GetIsFlatFooted(oTarget))
	{
		int nHit = TouchAttackMelee(oTarget);
		effect eVis = EffectVisualEffect(VFX_TOB_HANDOFDEATH);

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPC, 5.0f);
		WrapperPlayCustomAnimation(oPC, "Throw", 0); 
		ExpendManeuver(128, "STR");

		if (nHit > 0)
		{
			int nWisdom = GetAbilityModifier(ABILITY_WISDOM, oPC);
			int nDC = GetManeuverDC(nWisdom, 0, 14);
			int nFort = MySavingThrow(SAVING_THROW_FORT, oTarget, nDC);

			if ((nFort == 0) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_PARALYSIS)))
			{
				float fDuration = RoundsToSeconds(d3());
				effect eHoD = EffectParalyze(99, SAVING_THROW_FORT, FALSE);
				effect eHit = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
				effect ePara = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
				eHoD = SupernaturalEffect(eHoD);

				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHoD, oTarget, fDuration);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePara, oTarget, fDuration);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
			}
		}
	}
	else SendMessageToPC(oPC, "<color=red>This maneuver can only be initiated against flat-footed opponents.</color>");
}