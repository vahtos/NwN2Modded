//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 2/9/2009							//
//	Title: ct_ctrcharge						//
//	Description: Immeadiate Action; Redirect//
//	an oppenent who makes a charge at you.	//
//////////////////////////////////////////////

#include "bot9s_include"
#include "bot9s_inc_variables"
#include "tob_x0_i0_enemy"
#include "bot9s_inc_maneuvers"

void CounterCharge(object oPC, object oToB, location lFoeStart)
{		
	if (ValidateCounter(209))
	{
		object oFoe = IntToObject(GetLocalInt(oToB, "CounterCharge"));
		float fRange = GetMeleeRange(oPC);
		
		if (GetDistanceToObject(oFoe) - GetGirth(oFoe) <= fRange)
		{
			location lFoe = GetLocation(oFoe);
			float fThrow = FeetToMeters(10.0f);
			float fCharge = GetDistanceBetweenLocations(lFoeStart, lFoe);

			if (fCharge >= fThrow)
			{
				int nMySize = GetCreatureSize(oPC);
				int nFoeSize = GetCreatureSize(oFoe);
				int nMyStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
				int nMyDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
				int nFoeStr = GetAbilityModifier(ABILITY_STRENGTH, oFoe);
				int nFoeDex = GetAbilityModifier(ABILITY_DEXTERITY, oFoe);
				
				if (nMySize > nFoeSize)
				{
					nMyStr = nMyStr + 4;
				}
				else if (nMySize < nFoeSize)
				{
					 nMyDex = nMyDex + 4;
				}
	
				if (nMyStr >= nFoeStr)
				{
					if ((nMyStr + d20(1)) >= (nFoeStr+ d20(1)))
					{
						ThrowTarget(oFoe, fThrow);
						FloatingTextStringOnCreature("<color=cyan>*Counter Charge!*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
						RunSwiftAction(209, "C");
					}
					else
					{
						effect eFoeAttack = EffectAttackIncrease(4, EFFECT_TYPE_ENEMY_ATTACK_BONUS);

						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFoeAttack, oFoe, 6.0f);
						FloatingTextStringOnCreature("<color=cyan>*Counter Charge Failed!*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
						RunSwiftAction(209, "C");
					}
				}
				else if (nMyDex >= nFoeDex)
				{
					if ((nMyDex + d20(1)) >= (nFoeDex + d20(1)))
					{
						ThrowTarget(oFoe, fThrow);
						FloatingTextStringOnCreature("<color=cyan>*Counter Charge!*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
						RunSwiftAction(209, "C");
					}
					else
					{
						effect eFoeAttack = EffectAttackIncrease(4, EFFECT_TYPE_ENEMY_ATTACK_BONUS);
	
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFoeAttack, oFoe, 6.0f);
						FloatingTextStringOnCreature("<color=cyan>*Counter Charge Failed!*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
						RunSwiftAction(209, "C");
					}
				}
			}
		}
		else DelayCommand(0.1f, CounterCharge(oPC, oToB, lFoeStart));				
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = IntToObject(GetLocalInt(oToB, "Target"));
	
	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}
	
	int nTarget = GetLocalInt(oToB, "Target");

	location lTarget = GetLocation(oTarget);
	
	SetLocalInt(oToB, "CounterCharge", nTarget);
	ExpendManeuver(209, "C");
	DelayCommand(0.1f, CounterCharge(oPC, oToB, lTarget));
}