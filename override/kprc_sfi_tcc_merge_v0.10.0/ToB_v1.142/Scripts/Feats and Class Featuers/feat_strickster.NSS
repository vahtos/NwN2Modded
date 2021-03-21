//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 3/29/2009									//
//	Title: feat_strickster							//
//	Description: While in a Shadow Hand stance, gain//
//	+2 to the DC of illusion spells cast and +2 	//
//	damage to sneak attacks.						//
//////////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_feats"
#include "bot9s_include"

// The boost to illusion spell DC is covered in the override of tob_i0_spells.

void ShadowTrickster()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nStance = GetLocalInt(oToB, "Stance");
	int nStance2 = GetLocalInt(oToB, "Stance2");

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6507);

	if (nStance == 116 || nStance2 == 116 || nStance == 117 || nStance2 == 117
	|| nStance == 119 || nStance2 == 119 || nStance == 122 || nStance2 == 122
	|| nStance == 129 || nStance2 == 129 || nStance == 139 || nStance2 == 139)
	{
		object oCreature = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE, oPC);

		if (IsTargetValidForSneakAttack(oCreature, oPC))
		{
			object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
			int nWeapon = GetWeaponDamageType(oWeapon);
			effect eTrickster = EffectDamageIncrease(DAMAGE_BONUS_2, nWeapon);
			eTrickster = ExtraordinaryEffect(eTrickster);
	
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTrickster, oPC, 6.0f);
		}
	}

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
	DelayCommand(6.0f, ShadowTrickster());
}

void CheckLoopEffect()
{
	if(!CheckRecursive(6507))
	{
		ShadowTrickster(); //Only runs if the effect is no longer on the player.
	}
}

void main()
{
	DelayCommand(6.0f, CheckLoopEffect()); // Needs to be delayed because when the feat fires after resting the engine doesn't detect effects immeadiately.
}