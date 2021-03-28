//////////////////////////////////////////////////////////
//	Author: Drammel										//
//	Date: 5/15/2009										//
//	Name: clf_cr_soul									//
//	Description: Gratns a bonus to the Crusader's will	//
//	based on the Crusader's CHA modifier.				//
//////////////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_feats"

void IndomitableSoul()
{
	object oPC = OBJECT_SELF;
	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6536);

	if (!GetHasFeat(FEAT_DIVINE_GRACE, oPC) && !GetHasFeat(FEAT_PRESTIGE_DARK_BLESSING, oPC))
	{
		int nCha = GetAbilityModifier(ABILITY_CHARISMA, oPC);

		if (nCha > 0)
		{
			effect eSoul = EffectSavingThrowIncrease(SAVING_THROW_WILL, nCha);
			eSoul = SupernaturalEffect(eSoul);

			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSoul, oPC, 6.0f);
		}
	}

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
	DelayCommand(6.0f, IndomitableSoul());
}

void CheckLoopEffect()
{
	if(!CheckRecursive(6536))
	{
		IndomitableSoul(); //Only runs if the effect is no longer on the player.
	}
}

void main()
{
	DelayCommand(6.0f, CheckLoopEffect()); // Needs to be delayed because when the feat fires after resting the engine doesn't detect effects immeadiately.
}