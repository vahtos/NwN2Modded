///////////////////////////////////////////////////////////////
//	Author: Drammel											 //
//	Date: 4/28/2009											 //
//	Name: clf_bcunning									     //
//	Description: Grants a damage bouns based on Int to any   //
//	any target that is usually vaild for a sneak attack. Ie: //
//	flanked or flatfooted.									 //
///////////////////////////////////////////////////////////////

#include "bot9s_include"
#include "bot9s_inc_constants"
#include "bot9s_inc_feats"

void BattleCunning()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6526);

	if (GetIsInCombat(oPC))
	{
		object oFoe = GetAttackTarget(oPC);

		if ((IsFlankValid(oPC, oFoe)) || (!GetIsInCombat(oFoe)))
		{
			int nIntelligence = GetAbilityModifier(ABILITY_INTELLIGENCE);

			if (nIntelligence < 1)
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 1.0f);
				DelayCommand(1.0f, BattleCunning());
				return;
			}

			object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
			int nWeapon = GetWeaponType(oWeapon);
			int nDamageType = GetWeaponDamageType(oWeapon);

			effect eDamage = EffectDamageIncrease(nIntelligence, nDamageType);
			eDamage = SupernaturalEffect(eDamage);

			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDamage, oPC, 6.0f);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
			DelayCommand(6.0f, BattleCunning());
		}
		else
		{
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 1.0f);
			DelayCommand(1.0f, BattleCunning());
		}
	}
	else
	{
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 1.0f);
		DelayCommand(1.0f, BattleCunning());
	}
}

void CheckLoopEffect()
{
	if (!CheckRecursive(6526))
	{
		BattleCunning(); //Only runs if the effect is no longer on the player.
	}
}

void main()
{
	DelayCommand(6.0f, CheckLoopEffect()); // Needs to be delayed because when the feat fires after resting the engine doesn't detect effects immeadiately.
}