//////////////////////////////////////////////
//  Author: Drammel							//
//  Date: 7/29/2009							//
//  Title: sa_step_wind						//
//  Description: Depending on the terrain	//
//	the player is standing on, they gain a	//
//	damage immunity bonus of 5%.			//
//////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"

void StepOfTheWind()
{
	if (ValidateStance(113))
	{
		object oPC = OBJECT_SELF;
		location lPC = GetLocation(oPC);
		//Doesn't return a single constatnt, but a range between the SM_* constants 
		//which I feel is safe to assume why a bitmask is used for its constants 
		//rather than successive integers.  
		int nTerrain = GetSurfaceMaterialsAtLocation(lPC);

		if ((nTerrain >= SM_TYPE_CARPET) && (nTerrain < SM_TYPE_METAL))
		{
			effect eBonus = EffectDamageImmunityIncrease(DAMAGE_TYPE_DIVINE, 5);
			eBonus = SupernaturalEffect(eBonus);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oPC, 1.0f);
		}
		else if ((nTerrain >= SM_TYPE_DIRT) && (nTerrain < SM_TYPE_GRASS))
		{
			effect eBonus = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 5);
			eBonus = SupernaturalEffect(eBonus);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oPC, 1.0f);
		}
		else if ((nTerrain >= SM_TYPE_GRASS) && (nTerrain < SM_TYPE_STONE))
		{
			effect eBonus = EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 5);
			eBonus = SupernaturalEffect(eBonus);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oPC, 1.0f);
		}
		else if ((nTerrain >= SM_TYPE_LEAVES) && (nTerrain < SM_TYPE_WATER))
		{
			effect eBonus = EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, 5);
			eBonus = SupernaturalEffect(eBonus);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oPC, 1.0f);
		}
		else if ((nTerrain >= SM_TYPE_METAL) && (nTerrain < SM_TYPE_SWAMP))
		{
			effect eBonus = EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 5);
			eBonus = SupernaturalEffect(eBonus);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oPC, 1.0f);
		}
		else if ((nTerrain >= SM_TYPE_MUD) && (nTerrain < SM_TYPE_LEAVES))
		{
			effect eBonus = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 5);
			eBonus = SupernaturalEffect(eBonus);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oPC, 1.0f);
		}
		else if (nTerrain >= SM_TYPE_PUDDLES)
		{
			effect eBonus = EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 5);
			eBonus = SupernaturalEffect(eBonus);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oPC, 1.0f);
		}
		else if ((nTerrain >= SM_TYPE_STONE) && (nTerrain < SM_TYPE_WOOD))
		{
			effect eBonus = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 5);
			eBonus = SupernaturalEffect(eBonus);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oPC, 1.0f);
		}
		else if ((nTerrain >= SM_TYPE_SWAMP) && (nTerrain < SM_TYPE_MUD))
		{
			effect eBonus = EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 5);
			eBonus = SupernaturalEffect(eBonus);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oPC, 1.0f);
		}
		else if ((nTerrain >= SM_TYPE_WATER) && (nTerrain < SM_TYPE_PUDDLES))
		{
			effect eBonus = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 5);
			eBonus = SupernaturalEffect(eBonus);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oPC, 1.0f);
		}
		else if ((nTerrain >= SM_TYPE_WOOD) && (nTerrain < SM_TYPE_CARPET))
		{
			effect eBonus = EffectDamageImmunityIncrease(DAMAGE_TYPE_POSITIVE, 5);
			eBonus = SupernaturalEffect(eBonus);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oPC, 1.0f);
		}
		else if ((nTerrain == SM_TYPE_WALKABLE) && (nTerrain < SM_TYPE_DIRT))
		{
			effect eBonus = EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL, 5);
			eBonus = SupernaturalEffect(eBonus);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oPC, 1.0f);
		}

		DelayCommand(1.0f, StepOfTheWind());
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	effect eVis = EffectVisualEffect(VFX_TOB_LEAFSPIN);

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPC, 6.0f);
	StepOfTheWind();
}