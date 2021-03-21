//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 8/28/2009								//
//	Title: sa_giant_killing						//
//	Description: When you are in this stance,   //
//  you gain a +2 bonus on attack rolls and a +4//
//  bonus on damage rolls against opponents of  //
//  a larger size category than yours. This     //
//  bonus applies to all attacks you make for 	//
//  the rest of your turn.						//
//////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void GiantKillingStyle()
{	
	if (ValidateStance(105))
	{
		object oPC = OBJECT_SELF;
		object oFoe = GetAttackTarget(oPC);
		int nMySize = GetCreatureSize(oPC);
		int nFoeSize = GetCreatureSize(oFoe);

		if (nMySize < nFoeSize)
		{
			object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
			int nDamageType = GetWeaponDamageType(oWeapon);
			effect eAttack = EffectAttackIncrease(2);
			effect eDamage = EffectDamageIncrease(4, nDamageType);
			effect eGiant = EffectLinkEffects(eAttack, eDamage);
			eGiant = SupernaturalEffect(eGiant);

			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGiant, oPC, 0.5f);
		}

		DelayCommand(0.5f, GiantKillingStyle());
	}
}

void main()
{
	GiantKillingStyle();
}