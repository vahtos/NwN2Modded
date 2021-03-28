//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 10/27/2009								//
//	Title: ct_fools_strike					    	//
//	Description: If an opponent attacks you, you can//
//  initiate this maneuver to make an opposed attack//
//  roll as an immediate action. If your foe's      //
//  result is higher, he attacks you as normal. If  //
//  your result is higher, your foe rolls damage as //
//  normal for the attack and takes that much       //
//  damage.                                         //
//////////////////////////////////////////////////////

	//Most of the work of this maneuver is handled in bot9s_inc_maneuvers.

#include "bot9s_combat_overrides"
#include "bot9s_inc_maneuvers"

void GenerateFoes(object oPC, object oToB)
{
	int n;
	object oFoe;

	n = 1;
	oFoe = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE , oPC, n, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);

	while (GetIsObjectValid(oFoe))
	{
		if ((oFoe != oPC) && (GetIsReactionTypeHostile(oFoe, oPC)))
		{
			SetLocalObject(oToB, "FoolsStrikeFoe" + IntToString(n), oFoe);
			n++;

			if (n > 10)//Only so many that I can manually keep track of.
			{
				break;
			}
		}
		oFoe = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE , oPC, n, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
	}
}

void FoolsStrike(object oPC, object oToB)
{
	if ((ValidateCounter(103)) && (GetLocalInt(oPC, "FoolsStrike") == 1))
	{
		GenerateFoes(oPC, oToB);

		object oFoe1 = GetLocalObject(oToB, "FoolsStrikeFoe1");

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

		object oFoe2 = GetLocalObject(oToB, "FoolsStrikeFoe2");

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

		object oFoe3 = GetLocalObject(oToB, "FoolsStrikeFoe3");

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

		object oFoe4 = GetLocalObject(oToB, "FoolsStrikeFoe4");

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

		object oFoe5 = GetLocalObject(oToB, "FoolsStrikeFoe5");

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

		object oFoe6 = GetLocalObject(oToB, "FoolsStrikeFoe6");

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

		object oFoe7 = GetLocalObject(oToB, "FoolsStrikeFoe7");

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

		object oFoe8 = GetLocalObject(oToB, "FoolsStrikeFoe8");

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

		object oFoe9 = GetLocalObject(oToB, "FoolsStrikeFoe9");

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

		object oFoe10 = GetLocalObject(oToB, "FoolsStrikeFoe10");

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

		DelayCommand(6.0f, FoolsStrike(oPC, oToB));
	}
	else 
	{
		DeleteLocalInt(oPC, "FoolsStrike");
		DeleteLocalObject(oToB, "FoolsStrikeFoe1");
		DeleteLocalObject(oToB, "FoolsStrikeFoe2");
		DeleteLocalObject(oToB, "FoolsStrikeFoe3");
		DeleteLocalObject(oToB, "FoolsStrikeFoe4");
		DeleteLocalObject(oToB, "FoolsStrikeFoe5");
		DeleteLocalObject(oToB, "FoolsStrikeFoe6");
		DeleteLocalObject(oToB, "FoolsStrikeFoe7");
		DeleteLocalObject(oToB, "FoolsStrikeFoe8");
		DeleteLocalObject(oToB, "FoolsStrikeFoe9");
		DeleteLocalObject(oToB, "FoolsStrikeFoe10");
	}	
}

void FoolsStrikeCheck(object oPC, object oToB)
{
	if ((GetLocalInt(oPC, "FoolsStrike") == 2) && (GetLocalInt(oToB, "Swift") == 0))
	{
		DeleteLocalInt(oPC, "FoolsStrike");
		RunSwiftAction(103, "C");
	}
	else 
	{
		SetLocalInt(oPC, "FoolsStrike", 1);
		DelayCommand(0.1f, FoolsStrikeCheck(oPC, oToB));
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	SetLocalInt(oPC, "FoolsStrike", 1); //Switched off in bot9s_inc_maneuvers
	FoolsStrike(oPC, oToB);
	FoolsStrikeCheck(oPC, oToB);
	ExpendManeuver(103, "C");
}