//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 6/19/2009							//
//	Title: sa_ironguard						//
//	Description: Stance; Applies a minus 4	//
//	penalty to attack rolls to an creature	//
//	that is not targeting the initiator of	//
//	this stance.							//
//////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void RunLoop(float fRange)
{
	object oPC = OBJECT_SELF;
	location lPC = GetLocation(oPC);
	object oFoe;

	oFoe = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);

	while (GetIsObjectValid(oFoe))
	{
		if ((GetIsReactionTypeHostile(oFoe, oPC)) && (GetAttackTarget(oFoe) != oPC) && (GetIsInCombat(oFoe)))
		{
			effect eMinus = EffectAttackDecrease(4);
			eMinus = ExtraordinaryEffect(eMinus);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMinus, oFoe, 6.0f);
			AssignCommand(oFoe, ClearAllActions(TRUE));
			AssignCommand(oFoe, ActionAttack(oPC));
		}
		oFoe = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);
	}
}

void IronGuardsGlare()
{
	if (ValidateStance(42))
	{
		object oPC = OBJECT_SELF;
		object oToB = GetItemPossessedBy(oPC, "tob");
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		float fRange = GetMeleeRange(oPC);

		if ((fRange < FeetToMeters(8.0f)) || (GetWeaponRanged(oWeapon)))
		{
			fRange = FeetToMeters(8.0f);
		}

		AssignCommand(oPC, RunLoop(fRange));
		DelayCommand(6.0f, IronGuardsGlare());
	}
}

void main()
{
	IronGuardsGlare();
}