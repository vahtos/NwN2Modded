//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 9/11/2009								//
//	Title: bo_fountain							//
//	Description: If you reduce a living opponent//
//  to –1 or fewer hit points during your turn, //
//  you can initiate this maneuver. Your weapon //
//  rips into your foe as she drops, dealing an //
//  extra 1d6 points of damage and forcing all  //
//  your enemies within a 30-foot radius to make//
//  successful Will saves (DC 14 + your Str     //
//  modifier) or be shaken for 1 minute.		//
//////////////////////////////////////////////////

#include "tob_i0_spells"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"
#include "tob_x2_inc_itemprop"

effect EffectShaken()
{
	effect eShaken;
	effect eAttack = EffectAttackDecrease(2);
	effect eSaves = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
	effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
	eShaken = EffectLinkEffects(eAttack, eSaves);
	eShaken = EffectLinkEffects(eShaken, eSkill);
	eShaken = ExtraordinaryEffect(eShaken);

	return eShaken;
}

void GenerateFoes(object oPC, object oToB)
{
	location lPC = GetLocation(oPC);
	float fRange = GetMeleeRange(oPC);

	int n;
	object oFoe;

	n = 1;
	oFoe = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);

	while (GetIsObjectValid(oFoe))
	{
		if ((oFoe != oPC) && (GetIsStandardHostileTarget(oFoe, oPC)))
		{
			SetLocalObject(oToB, "FountainOfBloodFoe" + IntToString(n), oFoe);
			SetLocalInt(oToB, "FountainTotal", n);
			n++;

			if (n > 10)//Only so many that I can manually keep track of.
			{
				break;
			}
		}
		oFoe = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);
	}
}

void FountainOfBlood(float fThirty)
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oFoe1 = GetLocalObject(oToB, "FountainOfBloodFoe1");
	object oFoe2 = GetLocalObject(oToB, "FountainOfBloodFoe2");
	object oFoe3 = GetLocalObject(oToB, "FountainOfBloodFoe3");
	object oFoe4 = GetLocalObject(oToB, "FountainOfBloodFoe4");
	object oFoe5 = GetLocalObject(oToB, "FountainOfBloodFoe5");
	object oFoe6 = GetLocalObject(oToB, "FountainOfBloodFoe6");
	object oFoe7 = GetLocalObject(oToB, "FountainOfBloodFoe7");
	object oFoe8 = GetLocalObject(oToB, "FountainOfBloodFoe8");
	object oFoe9 = GetLocalObject(oToB, "FountainOfBloodFoe9");
	object oFoe10 = GetLocalObject(oToB, "FountainOfBloodFoe10");
	int nFountain = GetLocalInt(oToB, "FountainTotal");
	int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
	int nDC;

	nDC += GetManeuverDC(nStr, 0, 14);

	if (nFountain > 0) //Check how many there actually were, so the DC doesn't skyrocket.
	{
		if (!GetIsObjectValid(oFoe1) || (GetCurrentHitPoints(oFoe1) < 1))
		{
			nDC += 1;
		}
	}

	if (nFountain > 1)
	{
		if (!GetIsObjectValid(oFoe2) || (GetCurrentHitPoints(oFoe2) < 1))
		{
			nDC += 1;
		}
	}

	if (nFountain > 2)
	{
		if (!GetIsObjectValid(oFoe3) || (GetCurrentHitPoints(oFoe3) < 1))
		{
			nDC += 1;
		}
	}

	if (nFountain > 3)
	{
		if (!GetIsObjectValid(oFoe4) || (GetCurrentHitPoints(oFoe4) < 1))
		{
			nDC += 1;
		}
	}

	if (nFountain > 4)
	{
		if (!GetIsObjectValid(oFoe5) || (GetCurrentHitPoints(oFoe5) < 1))
		{
			nDC += 1;
		}
	}

	if (nFountain > 5)
	{
		if (!GetIsObjectValid(oFoe6) || (GetCurrentHitPoints(oFoe6) < 1))
		{
			nDC += 1;
		}
	}

	if (nFountain > 6)
	{
		if (!GetIsObjectValid(oFoe7) || (GetCurrentHitPoints(oFoe7) < 1))
		{
			nDC += 1;
		}
	}

	if (nFountain > 7)
	{
		if (!GetIsObjectValid(oFoe8) || (GetCurrentHitPoints(oFoe8) < 1))
		{
			nDC += 1;
		}
	}

	if (nFountain > 8)
	{
		if (!GetIsObjectValid(oFoe9) || (GetCurrentHitPoints(oFoe9) < 1))
		{
			nDC += 1;
		}
	}

	if (nFountain > 9)
	{
		if (!GetIsObjectValid(oFoe10) || (GetCurrentHitPoints(oFoe10) < 1))
		{
			nDC += 1;
		}
	}

	location lPC = GetLocation(oPC);
	effect eFountain = EffectShaken();
	object oTarget;
	int nWill;

	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fThirty, lPC, TRUE);

	while (GetIsObjectValid(oTarget))
	{
		if (GetIsStandardHostileTarget(oTarget, oPC))
		{
			nWill = MySavingThrow(SAVING_THROW_WILL, oTarget, nDC);

			if (nWill == 0)
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFountain, oTarget, 60.0f);
			}
		}

		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fThirty, lPC, TRUE);
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	
	if (GetLocalInt(oToB, "Swift") == 0)
	{
		float fThirty = FeetToMeters(30.0f);
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

		if ((!GetIsObjectValid(oWeapon)) || (GetWeaponRanged(oWeapon)))
		{
			oWeapon = GetItemInSlot(INVENTORY_SLOT_ARMS);
		}

		int nDamageType = GetWeaponDamageType(oWeapon);

		itemproperty iWeapon = ItemPropertyDamageBonus(nDamageType, IP_CONST_DAMAGEBONUS_1d6);

		IPSafeAddItemProperty(oWeapon, iWeapon, 6.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
		RunSwiftAction(171, "B");
		ExpendManeuver(171, "B");
		GenerateFoes(oPC, oToB);
		DelayCommand(6.0f, FountainOfBlood(fThirty));
	}
}