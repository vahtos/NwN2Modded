//////////////////////////////////////////
//  Author: Drammel						//
//  Date: 6/27/2009						//
//  Title: sa_bitw						//
//  Description: With each successful	//
//	citical hit the player gains a bonus//
//	for each hit to attack and damage.	//
//	If the player goes more than a		//
//	minute without a crit or ends the	//
//	stance the effect ends.				//
//////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_combat_overrides"
#include "bot9s_include"
#include "bot9s_inc_variables"

void BloodInTheWater(object oPC, object oToB)
{
	if (ValidateStance(165))
	{
		SetLocalInt(oPC, "BloodInTheWater", 1); // Status check to prevent extra callbacks of this function from running.

		if (GetLocalInt(oPC, "bot9s_overridestate") > 0)
		{
			//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
			//2 = Combat round is pending and the command has already been sent, do nothing.
		}
		else ManageCombatOverrides(TRUE);

		int nBonus = GetLocalInt(oToB, "CritCount");

		if (nBonus > 0)
		{
			object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
			int nBlood = GetConstDamageBonusFromNumber(nBonus);
			int nDamageType = GetWeaponDamageType(oWeapon);
			effect eAttack = EffectAttackIncrease(nBonus);
			effect eDamage = EffectDamageIncrease(nBlood, nDamageType);
			effect eBitW = EffectLinkEffects(eAttack, eDamage);
			eBitW = ExtraordinaryEffect(eBitW);

			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBitW, oPC, 6.0f);
		}
		DelayCommand(6.0f, BloodInTheWater(oPC, oToB));
	}
	else
	{
		DeleteLocalInt(oPC, "BloodInTheWater");
		DeleteLocalInt(oToB, "CritCount");
		DeleteLocalInt(oToB, "BitWLast");
		ProtectedClearCombatOverrides(oPC);
	}
}

void BitWTimer(object oPC, object oToB)
{
	if (ValidateStance(165))
	{
		int nCritCount = GetLocalInt(oToB, "CritCount");
		int nLast = GetLocalInt(oToB, "BitWLast");
		int nTimer = GetLocalInt(oToB, "BitWTimer");

		SetLocalInt(oToB, "BitWTimer", nTimer + 1);

		if (nLast < nCritCount)
		{
			SetLocalInt(oToB, "BitWTimer", 1);
		}
		else if (nTimer > 59)
		{
			SetLocalInt(oToB, "CritCount", 0);
		}

		SetLocalInt(oToB, "BitWLast", nCritCount);
		DelayCommand(1.0f, BitWTimer(oPC, oToB));
	}
	else DeleteLocalInt(oToB, "BitWTimer");
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nTimer = GetLocalInt(oToB, "BitWTimer");

	if (nTimer == 0) // Runs only when the timer isn't already counting.
	{
		BitWTimer(oPC, oToB);
	}

	if (GetLocalInt(oPC, "BloodInTheWater") == 0)
	{
		BloodInTheWater(oPC, oToB);
	}
}