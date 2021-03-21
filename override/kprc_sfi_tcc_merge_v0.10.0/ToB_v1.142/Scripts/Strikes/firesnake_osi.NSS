///////////////////////////////////////////////////////////////
//	Author: Drammel											 //
//	Date: 9/8/2009											 //
//	Name: firesnake_osi									     //
//	Description: The On Spawn In script for the Firesnake	 //
//  creature created by the maneuver of the same name.  This //
//  script handles the movement of the creature, the damage  //
//  of the maneuver, and properly destroying the creature.   //
///////////////////////////////////////////////////////////////

#include "tob_i0_spells"
#include "bot9s_include"

void Firesnake(object oFiresnake, object oPC, int nDC, float fRange, effect eHit)
{
	location lFiresnake = GetLocation(oFiresnake);
	location lLast = GetLocalLocation(oFiresnake, "LastLoc");

	if (lFiresnake == lLast) // The snake must move or else it is destroyed.
	{
		DestroyObject(oFiresnake);
		return;
	}
	else SetLocalLocation(oFiresnake, "LastLoc", lFiresnake);

	object oCreature;
	float fDist;
	int nFire, nDamage;

	oCreature = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lFiresnake);

	while (GetIsObjectValid(oCreature))
	{
		fDist = GetDistanceBetween(oFiresnake, oCreature);

		if ((oCreature != oPC) && (GetLocalInt(oCreature, "FiresnakeHit") == 0) && (GetIsReactionTypeHostile(oCreature, oPC)) && (fDist <= fRange))
		{
			nFire = d6(6);
			nDamage = Bot9sReflexAdjustedDamage(nFire, oCreature, nDC, SAVING_THROW_TYPE_FIRE);

			if (nDamage > 0)
			{
				effect eFiresnake = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);

				SetLocalInt(oCreature, "FiresnakeHit", 1);
				AssignCommand(oCreature, DelayCommand(6.0f, DeleteLocalInt(oCreature, "FiresnakeHit")));
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oCreature);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eFiresnake, oCreature);
				SendMessageToPC(oPC, "<color=chocolate>" + "Firesnake damages " + GetName(oCreature) + ": " + IntToString(nDamage) + " (</color>" + "<color=red>" + IntToString(nDamage) + " Fire</color>" + "<color=chocolate>).</color>");
			}
		}
		oCreature = GetNextObjectInShape(SHAPE_SPHERE, fRange, lFiresnake);
	}

	DelayCommand(1.0f, Firesnake(oFiresnake, oPC, nDC, fRange, eHit));
}

void main()
{
	object oFiresnake = OBJECT_SELF;
	object oPC = GetLocalObject(oFiresnake, "PC");
	object oTarget = GetLocalObject(oFiresnake, "Target");
	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
	float fRange = GetMeleeRange(oFiresnake);
	int nWisdom = GetAbilityModifier(ABILITY_WISDOM, oPC);
	location lLast = GetLocation(oFiresnake);
	int nDC;

	if (GetHasFeat(6906, oPC)) //Blade Meditation
	{
		nDC += 1;
	}

	nDC += nWisdom + 14;

//	SetLocalLocation(oFiresnake, "LastLoc", lLast);
	SetCollision(oFiresnake, FALSE);
	AssignCommand(oFiresnake, ActionMoveToObject(oTarget));
	DelayCommand(0.01f, Firesnake(oFiresnake, oPC, nDC, fRange, eHit));
}