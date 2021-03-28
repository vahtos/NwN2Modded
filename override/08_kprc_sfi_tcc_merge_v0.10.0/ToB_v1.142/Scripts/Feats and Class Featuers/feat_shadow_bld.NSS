//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 3/29/2009									//
//	Title: feat_shadow_bld							//
//	Description: While in a Shadow Hand stance, 	//
//	apply Dex mod to weapon damage.					//
//////////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_feats"
#include "bot9s_inc_variables"

void ShadowBlade()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oRightHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6508);

	if (GetIsShadowBladeValid(oRightHand))
	{
		int nDexMod = GetAbilityModifier(ABILITY_DEXTERITY, oPC);

		if (nDexMod > 0) //Only do this if it actually matters.
		{
			object oLeftHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
			int nBonus, nDamage;
	
			if (!GetIsObjectValid(oLeftHand))
			{
				//Two-Handed
				nBonus = ((nDexMod * 3)/2);
			}
			else
			{
				//One-Handed
				nBonus = nDexMod;
			}
	
			nDamage = GetConstDamageBonusFromNumber(nBonus);
	
			int nWeapon = GetWeaponType(oRightHand);
					
			if (nWeapon == WEAPON_TYPE_PIERCING_AND_SLASHING || nWeapon == WEAPON_TYPE_PIERCING)
			{
				effect eDamage = EffectDamageIncrease(nDamage, DAMAGE_TYPE_PIERCING);
				eDamage = SupernaturalEffect(eDamage);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDamage, oPC, 6.0f);
			}
			else if (nWeapon == WEAPON_TYPE_SLASHING)
			{
				effect eDamage = EffectDamageIncrease(nDamage, DAMAGE_TYPE_SLASHING);
				eDamage = SupernaturalEffect(eDamage);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDamage, oPC, 6.0f);
			}
			else
			{
				effect eDamage = EffectDamageIncrease(nDamage, DAMAGE_TYPE_BLUDGEONING);
				eDamage = SupernaturalEffect(eDamage);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDamage, oPC, 6.0f);
			}
		}
	}

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
	DelayCommand(6.0f, ShadowBlade());
}

void CheckLoopEffect()
{
	if(!CheckRecursive(6508))
	{
		ShadowBlade(); //Only runs if the effect is no longer on the player.
	}
}

void main()
{
	DelayCommand(6.0f, CheckLoopEffect()); // Needs to be delayed because when the feat fires after resting the engine doesn't detect effects immeadiately.
}