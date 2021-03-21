///////////////////////////////////////////////////////////////
//	Author: Drammel											 //
//	Date: 5/12/2009											 //
//	Name: clf_furious_ctrs								     //
//	Description: Grants a bonus to attack and damage based on//
//	the amount of points in the delayed damage pool.		 //
///////////////////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_feats"
#include "bot9s_include"

void FuriousCounterstrike()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nPool = GetLocalInt(oToB, "DDPool");

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6532);

	if ((nPool > 0) && (GetIsInCombat(oPC)))
	{
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		int nDamageType = GetWeaponDamageType(oWeapon);
		int nDamagePool;

		if ((nPool > 0) && (nPool <= 9))
		{
			nDamagePool = DAMAGE_BONUS_1;
		}
		else if ((nPool > 9) && (nPool <= 14))
		{
			nDamagePool = DAMAGE_BONUS_2;
		}
		else if ((nPool > 14) && (nPool <= 19))
		{
			nDamagePool = DAMAGE_BONUS_3;
		}
		else if ((nPool > 19) && (nPool <= 24))
		{
			nDamagePool = DAMAGE_BONUS_4;
		}
		else if ((nPool > 24) && (nPool <= 29))
		{
			nDamagePool = DAMAGE_BONUS_5;
		}
		else if ((nPool > 29) && (nPool <= 34))
		{
			nDamagePool = DAMAGE_BONUS_6;
		}
		else if ((nPool > 34) && (nPool <= 39))
		{
			nDamagePool = DAMAGE_BONUS_7;
		}
		else if (nPool > 39)
		{
			nDamagePool = DAMAGE_BONUS_8;
		}

		effect eAttack = EffectAttackIncrease(nPool);
		effect eDamage = EffectDamageIncrease(nDamagePool, nDamageType);
		effect eFurious = EffectLinkEffects(eAttack, eDamage);
		eFurious = SupernaturalEffect(eFurious);

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFurious, oPC, 6.0f);
	}

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
	DelayCommand(6.0f, FuriousCounterstrike());
}		

void CheckLoopEffect()
{
	if(!CheckRecursive(6532))
	{
		FuriousCounterstrike(); //Only runs if the effect is no longer on the player.
	}
}

void main()
{
	DelayCommand(6.0f, CheckLoopEffect()); // Needs to be delayed because when the feat fires after resting the engine doesn't detect effects immeadiately.
}