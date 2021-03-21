//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 7/12/2009							//
//	Title: sa_punishing						//
//	Description: While you are in this 		//
//	stance, you deal an extra 1d6 points of	//
//	damage with all melee attacks. You also //
//	take a –2 penalty to AC, because this 	//
//	fighting stance emphasizes power over a //
//	defensive posture.						//
//////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "tob_x2_inc_itemprop"

void PunishingStance()
{	
	if (ValidateStance(90))
	{
		object oPC = OBJECT_SELF;
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

		itemproperty iWeapon = ItemPropertyDamageBonus(nDamageType, IP_CONST_DAMAGEBONUS_1d6);
		IPSafeAddItemProperty(oWeapon, iWeapon, 5.99f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);

		effect eAC = EffectACDecrease(2);
		eAC = ExtraordinaryEffect(eAC);

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, 6.0f);
		DelayCommand(6.0f, PunishingStance());
	}
}

void main()
{
	PunishingStance();
}