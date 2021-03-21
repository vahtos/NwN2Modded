//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 10/25/2009							//
//	Title: st_wyrm								//
//	Description: This maneuver allows you to 	//
//  create a wave of fire that sweeps over your //
//  enemies. When you initiate this maneuver,   //
//  you blast forth a cone of flame that deals  //
//  10d6 points of fire damage.					//
//////////////////////////////////////////////////

#include "tob_i0_spells"
#include "tob_x0_i0_position"
#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 26);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DesertWindStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DesertWindStrike", 0));

	location lPC = GetLocation(oPC);
	int nWisdom;

	if (GetAbilityModifier(ABILITY_WISDOM, oPC) > 0)
	{
		nWisdom = GetAbilityModifier(ABILITY_WISDOM, oPC);
	}
	else nWisdom = 0;

	TurnToFaceObject(oTarget, oPC);

	int nDC = GetManeuverDC(nWisdom, 0, 15);
	float fRange = FeetToMeters(30.0f);
	float fFace = GetFacing(oPC);
	effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
	effect eBreath = EffectVisualEffect(VFX_TOB_WYRMSFLAME);

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.5f);
	ExpendManeuver(26, "STR");

	object oFoe;
	effect eCone;
	int nDamage, n, nBonus;
	float fDelay, fDist;

	if (GetHasFeat(FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_DW, oPC) || GetHasFeat(FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_DW2, oPC))
	{
		nBonus += nWisdom;
	}

	n = 1;
	oFoe = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE); // Can't use GetSpellTargetLocation with maneuvers :p 

	while(GetIsObjectValid(oFoe))
	{
		if (oFoe != OBJECT_SELF && spellsIsTarget(oFoe, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
			SetLocalObject(oToB, "WyrmFoe" + IntToString(n), oFoe);
			n++;
		}

		if (n > 10)
		{
			break;
		}
		oFoe = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);
    }

	object oFoe1 = GetLocalObject(oToB, "WyrmFoe1");

	if (GetIsObjectValid(oFoe1))
	{
		fDist = GetDistanceBetween(oPC, oFoe1);

		if ((IsFacingWithin(45.0f, oFoe1)) && (fDist <= fRange))
		{
			nDamage = d6(10) + nBonus;
			fDelay = fDist/20;
			nDamage = Bot9sReflexAdjustedDamage(nDamage, oFoe1, nDC, SAVING_THROW_TYPE_FIRE);
			eCone = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
	
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oFoe1));
	
			if (nDamage > 0)
			{
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCone, oFoe1));
			}
		}
	}

	object oFoe2 = GetLocalObject(oToB, "WyrmFoe2");

	if (GetIsObjectValid(oFoe2))
	{
		fDist = GetDistanceBetween(oPC, oFoe2);

		if ((IsFacingWithin(45.0f, oFoe2)) && (fDist <= fRange))
		{
			nDamage = d6(10) + nBonus;
			fDelay = fDist/20;
			nDamage = Bot9sReflexAdjustedDamage(nDamage, oFoe2, nDC, SAVING_THROW_TYPE_FIRE);
			eCone = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
	
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oFoe2));
	
			if (nDamage > 0)
			{
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCone, oFoe2));
			}
		}
	}

	object oFoe3 = GetLocalObject(oToB, "WyrmFoe3");

	if (GetIsObjectValid(oFoe3))
	{
		fDist = GetDistanceBetween(oPC, oFoe3);

		if ((IsFacingWithin(45.0f, oFoe3)) && (fDist <= fRange))
		{
			nDamage = d6(10) + nBonus;
			fDelay = fDist/20;
			nDamage = Bot9sReflexAdjustedDamage(nDamage, oFoe3, nDC, SAVING_THROW_TYPE_FIRE);
			eCone = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
	
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oFoe3));
	
			if (nDamage > 0)
			{
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCone, oFoe3));
			}
		}
	}

	object oFoe4 = GetLocalObject(oToB, "WyrmFoe4");

	if (GetIsObjectValid(oFoe4))
	{
		fDist = GetDistanceBetween(oPC, oFoe4);

		if ((IsFacingWithin(45.0f, oFoe4)) && (fDist <= fRange))
		{
			nDamage = d6(10) + nBonus;
			fDelay = fDist/20;
			nDamage = Bot9sReflexAdjustedDamage(nDamage, oFoe4, nDC, SAVING_THROW_TYPE_FIRE);
			eCone = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
	
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oFoe4));
	
			if (nDamage > 0)
			{
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCone, oFoe4));
			}
		}
	}

	object oFoe5 = GetLocalObject(oToB, "WyrmFoe5");

	if (GetIsObjectValid(oFoe5))
	{
		fDist = GetDistanceBetween(oPC, oFoe5);

		if ((IsFacingWithin(45.0f, oFoe5)) && (fDist <= fRange))
		{
			nDamage = d6(10) + nBonus;
			fDelay = fDist/20;
			nDamage = Bot9sReflexAdjustedDamage(nDamage, oFoe5, nDC, SAVING_THROW_TYPE_FIRE);
			eCone = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
	
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oFoe5));
	
			if (nDamage > 0)
			{
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCone, oFoe5));
			}
		}
	}

	object oFoe6 = GetLocalObject(oToB, "WyrmFoe6");

	if (GetIsObjectValid(oFoe6))
	{
		fDist = GetDistanceBetween(oPC, oFoe6);

		if ((IsFacingWithin(45.0f, oFoe6)) && (fDist <= fRange))
		{
			nDamage = d6(10) + nBonus;
			fDelay = fDist/20;
			nDamage = Bot9sReflexAdjustedDamage(nDamage, oFoe6, nDC, SAVING_THROW_TYPE_FIRE);
			eCone = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
	
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oFoe6));
	
			if (nDamage > 0)
			{
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCone, oFoe6));
			}
		}
	}

	object oFoe7 = GetLocalObject(oToB, "WyrmFoe7");

	if (GetIsObjectValid(oFoe7))
	{
		fDist = GetDistanceBetween(oPC, oFoe7);

		if ((IsFacingWithin(45.0f, oFoe7)) && (fDist <= fRange))
		{
			nDamage = d6(10) + nBonus;
			fDelay = fDist/20;
			nDamage = Bot9sReflexAdjustedDamage(nDamage, oFoe7, nDC, SAVING_THROW_TYPE_FIRE);
			eCone = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
	
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oFoe7));
	
			if (nDamage > 0)
			{
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCone, oFoe7));
			}
		}
	}

	object oFoe8 = GetLocalObject(oToB, "WyrmFoe8");

	if (GetIsObjectValid(oFoe8))
	{
		fDist = GetDistanceBetween(oPC, oFoe8);

		if ((IsFacingWithin(45.0f, oFoe8)) && (fDist <= fRange))
		{
			nDamage = d6(10) + nBonus;
			fDelay = fDist/20;
			nDamage = Bot9sReflexAdjustedDamage(nDamage, oFoe8, nDC, SAVING_THROW_TYPE_FIRE);
			eCone = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
	
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oFoe8));
	
			if (nDamage > 0)
			{
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCone, oFoe8));
			}
		}
	}

	object oFoe9 = GetLocalObject(oToB, "WyrmFoe9");

	if (GetIsObjectValid(oFoe9))
	{
		fDist = GetDistanceBetween(oPC, oFoe9);

		if ((IsFacingWithin(45.0f, oFoe9)) && (fDist <= fRange))
		{
			nDamage = d6(10) + nBonus;
			fDelay = fDist/20;
			nDamage = Bot9sReflexAdjustedDamage(nDamage, oFoe9, nDC, SAVING_THROW_TYPE_FIRE);
			eCone = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
	
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oFoe9));
	
			if (nDamage > 0)
			{
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCone, oFoe9));
			}
		}
	}

	object oFoe10 = GetLocalObject(oToB, "WyrmFoe10");

	if (GetIsObjectValid(oFoe10))
	{
		fDist = GetDistanceBetween(oPC, oFoe10);

		if ((IsFacingWithin(45.0f, oFoe10)) && (fDist <= fRange))
		{
			nDamage = d6(10) + nBonus;
			fDelay = fDist/20;
			nDamage = Bot9sReflexAdjustedDamage(nDamage, oFoe10, nDC, SAVING_THROW_TYPE_FIRE);
			eCone = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
	
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oFoe10));
	
			if (nDamage > 0)
			{
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCone, oFoe10));
			}
		}
	}

	DeleteLocalInt(oToB, "WyrmFoe1");
	DeleteLocalInt(oToB, "WyrmFoe2");
	DeleteLocalInt(oToB, "WyrmFoe3");
	DeleteLocalInt(oToB, "WyrmFoe4");
	DeleteLocalInt(oToB, "WyrmFoe5");
	DeleteLocalInt(oToB, "WyrmFoe6");
	DeleteLocalInt(oToB, "WyrmFoe7");
	DeleteLocalInt(oToB, "WyrmFoe8");
	DeleteLocalInt(oToB, "WyrmFoe9");
	DeleteLocalInt(oToB, "WyrmFoe10");
}