///////////////////////////////////////////////////////////
//	Author: Drammel										 //
//	Date: 5/15/2009										 //
//	Name: feat_diehard									 //
//	Description: When reduced to below 0 hitpoints the PC//
//	automatically heals one hit point.					 //
///////////////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_feats"

void Diehard()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nHp = GetCurrentHitPoints(oPC);

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6533);

	if (nHp >= 0)
	{
		SetLocalInt(oToB, "DiehardFlag", 0);
	}

	if ((nHp < 0) && (GetLocalInt(oToB, "DiehardFlag") == 0))
	{
		effect eHeal = EffectHeal(1);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
		SetLocalInt(oToB, "DiehardFlag", 1);
	}

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
	DelayCommand(6.0f, Diehard());
}

void CheckLoopEffect()
{
	if(!CheckRecursive(6533))
	{
		Diehard(); //Only runs if the effect is no longer on the player.
	}
}

void main()
{
	DelayCommand(6.0f, CheckLoopEffect()); // Needs to be delayed because when the feat fires after resting the engine doesn't detect effects immeadiately.
}