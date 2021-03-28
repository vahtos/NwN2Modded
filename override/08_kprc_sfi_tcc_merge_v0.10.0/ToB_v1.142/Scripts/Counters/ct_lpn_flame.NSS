//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 9/13/2009									//
//	Title: ct_lpn_flame						    	//
//	Description: You instantly appear in a square   //
//  adjacent to a creature that attacks you with a  //
//  melee or ranged attack, after resolving the     //
//  enemy's attack. You cannot move into a space    //
//  that is occupied by a creature or object. You   //
//  can move up to 100 feet in this manner.			//
//////////////////////////////////////////////////////

#include "bot9s_combat_overrides"
#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"
#include "tob_i0_spells"
#include "tob_x0_i0_position"

void GenerateFoes(object oPC, object oToB)
{
	float fRange = FeetToMeters(100.0f);

	int n;
	object oFoe;
	float fDist;

	n = 1;
	oFoe = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE , oPC, n, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);

	while (GetIsObjectValid(oFoe))
	{
		fDist = GetDistanceBetween(oPC, oFoe);

		if ((oFoe != oPC) && (GetIsReactionTypeHostile(oFoe, oPC)) && (fDist <= fRange))
		{
			SetLocalObject(oToB, "LeapingFlameFoe" + IntToString(n), oFoe);
			n++;

			if (n > 10)//Only so many that I can manually keep track of.
			{
				break;
			}
		}
		oFoe = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE , oPC, n, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
	}
}

void LeapingFlame(object oPC, object oToB)
{
	if ((ValidateCounter(18)) && (GetLocalInt(oPC, "LeapingFlameActive") == 1))
	{
		AssignCommand(oPC, GenerateFoes(oPC, oToB));

		object oFoe1 = GetLocalObject(oToB, "LeapingFlameFoe1");

		if ((GetIsObjectValid(oFoe1)) && (GetAttackTarget(oFoe1) == oPC))
		{
			if (GetLocalInt(oFoe1, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else
			{
				AssignCommand(oFoe1, ManageCombatOverrides(TRUE, oFoe1));
				DelayCommand(5.99f, ProtectedClearCombatOverrides(oFoe1));
			}
		}

		object oFoe2 = GetLocalObject(oToB, "LeapingFlameFoe2");

		if ((GetIsObjectValid(oFoe2)) && (GetAttackTarget(oFoe2) == oPC))
		{
			if (GetLocalInt(oFoe2, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else
			{
				AssignCommand(oFoe2, ManageCombatOverrides(TRUE, oFoe2));
				DelayCommand(5.99f, ProtectedClearCombatOverrides(oFoe2));
			}
		}

		object oFoe3 = GetLocalObject(oToB, "LeapingFlameFoe3");

		if ((GetIsObjectValid(oFoe3)) && (GetAttackTarget(oFoe3) == oPC))
		{
			if (GetLocalInt(oFoe3, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else
			{
				AssignCommand(oFoe3, ManageCombatOverrides(TRUE, oFoe3));
				DelayCommand(5.99f, ProtectedClearCombatOverrides(oFoe3));
			}
		}

		object oFoe4 = GetLocalObject(oToB, "LeapingFlameFoe4");

		if ((GetIsObjectValid(oFoe4)) && (GetAttackTarget(oFoe4) == oPC))
		{
			if (GetLocalInt(oFoe4, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else
			{
				AssignCommand(oFoe4, ManageCombatOverrides(TRUE, oFoe4));
				DelayCommand(5.99f, ProtectedClearCombatOverrides(oFoe4));
			}
		}

		object oFoe5 = GetLocalObject(oToB, "LeapingFlameFoe5");

		if ((GetIsObjectValid(oFoe5)) && (GetAttackTarget(oFoe5) == oPC))
		{
			if (GetLocalInt(oFoe5, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else
			{
				AssignCommand(oFoe5, ManageCombatOverrides(TRUE, oFoe5));
				DelayCommand(5.99f, ProtectedClearCombatOverrides(oFoe5));
			}
		}

		object oFoe6 = GetLocalObject(oToB, "LeapingFlameFoe6");

		if ((GetIsObjectValid(oFoe6)) && (GetAttackTarget(oFoe6) == oPC))
		{
			if (GetLocalInt(oFoe6, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else
			{
				AssignCommand(oFoe6, ManageCombatOverrides(TRUE, oFoe6));
				DelayCommand(5.99f, ProtectedClearCombatOverrides(oFoe6));
			}
		}

		object oFoe7 = GetLocalObject(oToB, "LeapingFlameFoe7");

		if ((GetIsObjectValid(oFoe7)) && (GetAttackTarget(oFoe7) == oPC))
		{
			if (GetLocalInt(oFoe7, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else
			{
				AssignCommand(oFoe7, ManageCombatOverrides(TRUE, oFoe7));
				DelayCommand(5.99f, ProtectedClearCombatOverrides(oFoe7));
			}
		}

		object oFoe8 = GetLocalObject(oToB, "LeapingFlameFoe8");

		if ((GetIsObjectValid(oFoe8)) && (GetAttackTarget(oFoe8) == oPC))
		{
			if (GetLocalInt(oFoe8, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else
			{
				AssignCommand(oFoe8, ManageCombatOverrides(TRUE, oFoe8));
				DelayCommand(5.99f, ProtectedClearCombatOverrides(oFoe8));
			}
		}

		object oFoe9 = GetLocalObject(oToB, "LeapingFlameFoe9");

		if ((GetIsObjectValid(oFoe9)) && (GetAttackTarget(oFoe9) == oPC))
		{
			if (GetLocalInt(oFoe9, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else
			{
				AssignCommand(oFoe9, ManageCombatOverrides(TRUE, oFoe9));
				DelayCommand(5.99f, ProtectedClearCombatOverrides(oFoe9));
			}
		}

		object oFoe10 = GetLocalObject(oToB, "LeapingFlameFoe10");

		if ((GetIsObjectValid(oFoe10)) && (GetAttackTarget(oFoe10) == oPC))
		{
			if (GetLocalInt(oFoe10, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else
			{
				AssignCommand(oFoe10, ManageCombatOverrides(TRUE, oFoe10));
				DelayCommand(5.99f, ProtectedClearCombatOverrides(oFoe10));
			}
		}

		DelayCommand(6.0f, LeapingFlame(oPC, oToB));
	}
	else 
	{
		DeleteLocalInt(oPC, "LeapingFlameActive");
		DeleteLocalObject(oToB, "LeapingFlameFoe1");
		DeleteLocalObject(oToB, "LeapingFlameFoe2");
		DeleteLocalObject(oToB, "LeapingFlameFoe3");
		DeleteLocalObject(oToB, "LeapingFlameFoe4");
		DeleteLocalObject(oToB, "LeapingFlameFoe5");
		DeleteLocalObject(oToB, "LeapingFlameFoe6");
		DeleteLocalObject(oToB, "LeapingFlameFoe7");
		DeleteLocalObject(oToB, "LeapingFlameFoe8");
		DeleteLocalObject(oToB, "LeapingFlameFoe9");
		DeleteLocalObject(oToB, "LeapingFlameFoe10");
	}	
}

void LeapingFlameCheck(object oPC, object oToB)
{
	if ((GetLocalInt(oPC, "LeapingFlameActive") == 2) && (GetLocalInt(oToB, "Swift") == 0))
	{
		object oTarget = GetLocalObject(oPC, "LeapingFlameTarget");

		if ((GetIsObjectValid(oTarget)) && (LineOfEffect(oPC, GetLocation(oTarget), TRUE)))
		{
			effect eFwoosh = EffectVisualEffect(VFX_TOB_LPN_FLAME);

			ClearStrikes();
			ClearAllActions();
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFwoosh, oPC, 2.5f);
			JumpToObject(oTarget);
			DeleteLocalObject(oPC, "LeapingFlameTarget");
			DeleteLocalInt(oPC, "LeapingFlameActive");
			RunSwiftAction(18, "C");
		}
		else
		{
			DeleteLocalObject(oPC, "LeapingFlameTarget");
			SetLocalInt(oPC, "LeapingFlameActive", 1);
			DelayCommand(0.1f, LeapingFlameCheck(oPC, oToB));
		}
	}
	else DelayCommand(0.1f, LeapingFlameCheck(oPC, oToB));
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	SetLocalInt(oPC, "LeapingFlameActive", 1); //Switched off in bot9s_inc_maneuvers
	LeapingFlame(oPC, oToB);
	LeapingFlameCheck(oPC, oToB);
	ExpendManeuver(18, "C");
}