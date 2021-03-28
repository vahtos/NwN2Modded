//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 7/31/2009								//
//	Title: st_hatchling							//
//	Description: This maneuver allows you to 	//
//  create a wave of fire that sweeps over your //
//  enemies. When you initiate this maneuver,   //
//  you blast forth a cone of flame that deals  //
//  2d6 points of fire damage.					//
//////////////////////////////////////////////////

#include "tob_i0_spells"
#include "tob_x0_i0_position"
#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 14);

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

	// The ability used is determined by discipline, despite it not being listed in the Tome of Battle.
	// I'm going with the information stated at http://boards1.wizards.com/showpost.php?p=13144675&postcount=5

	TurnToFaceObject(oTarget, oPC);

	int nDC = GetManeuverDC(nWisdom, 2);
	float fRange = FeetToMeters(30.0f);
	float fFace = GetFacing(oPC);
	effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
	effect eBreath = EffectVisualEffect(VFX_DUR_CONE_FIRE);

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.5f);
	ExpendManeuver(14, "STR");

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
			SetLocalObject(oToB, "HatchlingFoe" + IntToString(n), oFoe);
			n++;
		}

		if (n > 10)
		{
			break;
		}
		oFoe = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);
    }

	object oFoe1 = GetLocalObject(oToB, "HatchlingFoe1");

	if (GetIsObjectValid(oFoe1))
	{
		fDist = GetDistanceBetween(oPC, oFoe1);

		if ((IsFacingWithin(45.0f, oFoe1)) && (fDist <= fRange))
		{
			nDamage = d6(2) + nBonus;
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

	object oFoe2 = GetLocalObject(oToB, "HatchlingFoe2");

	if (GetIsObjectValid(oFoe2))
	{
		fDist = GetDistanceBetween(oPC, oFoe2);

		if ((IsFacingWithin(45.0f, oFoe2)) && (fDist <= fRange))
		{
			nDamage = d6(2) + nBonus;
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

	object oFoe3 = GetLocalObject(oToB, "HatchlingFoe3");

	if (GetIsObjectValid(oFoe3))
	{
		fDist = GetDistanceBetween(oPC, oFoe3);

		if ((IsFacingWithin(45.0f, oFoe3)) && (fDist <= fRange))
		{
			nDamage = d6(2) + nBonus;
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

	object oFoe4 = GetLocalObject(oToB, "HatchlingFoe4");

	if (GetIsObjectValid(oFoe4))
	{
		fDist = GetDistanceBetween(oPC, oFoe4);

		if ((IsFacingWithin(45.0f, oFoe4)) && (fDist <= fRange))
		{
			nDamage = d6(2) + nBonus;
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

	object oFoe5 = GetLocalObject(oToB, "HatchlingFoe5");

	if (GetIsObjectValid(oFoe5))
	{
		fDist = GetDistanceBetween(oPC, oFoe5);

		if ((IsFacingWithin(45.0f, oFoe5)) && (fDist <= fRange))
		{
			nDamage = d6(2) + nBonus;
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

	object oFoe6 = GetLocalObject(oToB, "HatchlingFoe6");

	if (GetIsObjectValid(oFoe6))
	{
		fDist = GetDistanceBetween(oPC, oFoe6);

		if ((IsFacingWithin(45.0f, oFoe6)) && (fDist <= fRange))
		{
			nDamage = d6(2) + nBonus;
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

	object oFoe7 = GetLocalObject(oToB, "HatchlingFoe7");

	if (GetIsObjectValid(oFoe7))
	{
		fDist = GetDistanceBetween(oPC, oFoe7);

		if ((IsFacingWithin(45.0f, oFoe7)) && (fDist <= fRange))
		{
			nDamage = d6(2) + nBonus;
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

	object oFoe8 = GetLocalObject(oToB, "HatchlingFoe8");

	if (GetIsObjectValid(oFoe8))
	{
		fDist = GetDistanceBetween(oPC, oFoe8);

		if ((IsFacingWithin(45.0f, oFoe8)) && (fDist <= fRange))
		{
			nDamage = d6(2) + nBonus;
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

	object oFoe9 = GetLocalObject(oToB, "HatchlingFoe9");

	if (GetIsObjectValid(oFoe9))
	{
		fDist = GetDistanceBetween(oPC, oFoe9);

		if ((IsFacingWithin(45.0f, oFoe9)) && (fDist <= fRange))
		{
			nDamage = d6(2) + nBonus;
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

	object oFoe10 = GetLocalObject(oToB, "HatchlingFoe10");

	if (GetIsObjectValid(oFoe10))
	{
		fDist = GetDistanceBetween(oPC, oFoe10);

		if ((IsFacingWithin(45.0f, oFoe10)) && (fDist <= fRange))
		{
			nDamage = d6(2) + nBonus;
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

	DeleteLocalInt(oToB, "HatchlingFoe1");
	DeleteLocalInt(oToB, "HatchlingFoe2");
	DeleteLocalInt(oToB, "HatchlingFoe3");
	DeleteLocalInt(oToB, "HatchlingFoe4");
	DeleteLocalInt(oToB, "HatchlingFoe5");
	DeleteLocalInt(oToB, "HatchlingFoe6");
	DeleteLocalInt(oToB, "HatchlingFoe7");
	DeleteLocalInt(oToB, "HatchlingFoe8");
	DeleteLocalInt(oToB, "HatchlingFoe9");
	DeleteLocalInt(oToB, "HatchlingFoe10");
}