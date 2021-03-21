///////////////////////////////////////////////////////////////
//	Author: Drammel											 //
//	Date: 4/28/2009											 //
//	Name: clf_bclarity									     //
//	Description: Grants a bonus to reflex saves based on Int.//
//	Battle Clarity is capped at the Warblade's maximum level.//
///////////////////////////////////////////////////////////////

#include "tob_i0_spells"
#include "bot9s_inc_constants"

void main()
{
	object oPC = OBJECT_SELF;
	int nIntelligence = GetAbilityModifier(ABILITY_INTELLIGENCE);
	int nWarblade = GetLevelByClass(CLASS_TYPE_WARBLADE);
	int nEffectID = SPELL_FEAT_BCLARITY;
	int nBonus;

	if (GetHasSpellEffect(nEffectID))
	{
		RemoveSpellEffects(nEffectID, oPC, oPC);
	}
	
	if (nIntelligence >= nWarblade)
	{
		nBonus = nWarblade;
	}
	else if (nIntelligence < 1)
	{
		nBonus = 0;
	}
	else nBonus = nIntelligence;

	effect eReflex = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nBonus);
	eReflex = SupernaturalEffect(eReflex);
	eReflex = SetEffectSpellId(eReflex, nEffectID);

	DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eReflex, oPC));
}