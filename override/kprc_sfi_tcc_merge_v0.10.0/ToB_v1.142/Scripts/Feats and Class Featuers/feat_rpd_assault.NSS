//////////////////////////////////////////////////////////
//	Author: Drammel										//
//	Date: 3/31/2009										//
//	Title: feat_rpd_assault								//
//	Description: During the first round of combat in	//
//	an encounter you gain +1d6 to melee weapon damage.	//
//////////////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_feats"
#include "tob_x2_inc_itemprop"

void RapidAssault()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6511);

	if (GetLocalInt(oToB, "Encounter") == 1)
	{
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

		if ((GetIsObjectValid(oWeapon) == FALSE) || (GetWeaponRanged(oWeapon) == TRUE))
		{
			oWeapon = GetItemInSlot(INVENTORY_SLOT_ARMS);
		}

		int nWeapon = GetWeaponType(oWeapon);
		int nDamageType;

		if (nWeapon == WEAPON_TYPE_PIERCING_AND_SLASHING || nWeapon == WEAPON_TYPE_PIERCING)
		{
			nDamageType = IP_CONST_DAMAGETYPE_PIERCING;
		}
		else if (nWeapon == WEAPON_TYPE_SLASHING)
		{
			nDamageType = IP_CONST_DAMAGETYPE_SLASHING;
		}
		else nDamageType = IP_CONST_DAMAGETYPE_BLUDGEONING;

		if (GetCurrentHitPoints(oPC) > 0)
		{
			itemproperty iWeapon = ItemPropertyDamageBonus(nDamageType, IP_CONST_DAMAGEBONUS_1d6);
			IPSafeAddItemProperty(oWeapon, iWeapon, 6.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
		}	
	}

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
	DelayCommand(6.0f, RapidAssault());
}

void CheckLoopEffect()
{
	if(!CheckRecursive(6511))
	{
		RapidAssault(); //Only runs if the effect is no longer on the player.
	}
}

void main()
{
	DelayCommand(6.0f, CheckLoopEffect()); // Needs to be delayed because when the feat fires after resting the engine doesn't detect effects immeadiately.
}