//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 8/18/2009								//
//	Title: ct_wallofblades						//
//	Description: When an enemy makes a melee or //
//  ranged attack against you, you can initiate //
//  this counter to oppose that attack by making//
//  an attack roll with any melee weapon you are//
//	holding.  Use the higher of your AC or your //
//  attack roll as your effective AC against the// 
//  incoming attack. You can’t use this maneuver// 
//  if you are denied your Dexterity bonus to AC//
//  against your attacker.						//
//////////////////////////////////////////////////

#include "bot9s_attack"
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
			if (GetObjectSeen(oFoe, oPC) || GetObjectHeard(oFoe, oPC))
			{
				SetLocalObject(oToB, "WallofBladesFoe" + IntToString(n), oFoe);
				n++;

				if (n > 10)//Only so many that I can manually keep track of.
				{
					break;
				}
			}
		}
		oFoe = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE , oPC, n, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
	}
}

void WallOfBlades(object oPC, object oToB, int nRoll)
{
	if ((ValidateCounter(96)) && (GetLocalInt(oPC, "WallofBladesActive") == 1))
	{
		AssignCommand(oPC, GenerateFoes(oPC, oToB));

		object oFoe1 = GetLocalObject(oToB, "WallofBladesFoe1");

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

		object oFoe2 = GetLocalObject(oToB, "WallofBladesFoe2");

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

		object oFoe3 = GetLocalObject(oToB, "WallofBladesFoe3");

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

		object oFoe4 = GetLocalObject(oToB, "WallofBladesFoe4");

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

		object oFoe5 = GetLocalObject(oToB, "WallofBladesFoe5");

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

		object oFoe6 = GetLocalObject(oToB, "WallofBladesFoe6");

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

		object oFoe7 = GetLocalObject(oToB, "WallofBladesFoe7");

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

		object oFoe8 = GetLocalObject(oToB, "WallofBladesFoe8");

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

		object oFoe9 = GetLocalObject(oToB, "WallofBladesFoe9");

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

		object oFoe10 = GetLocalObject(oToB, "WallofBladesFoe10");

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

		DelayCommand(6.0f, WallOfBlades(oPC, oToB, nRoll));
	}
	else 
	{
		DeleteLocalInt(oPC, "WallofBladesActive");
		DeleteLocalObject(oToB, "WallofBladesFoe1");
		DeleteLocalObject(oToB, "WallofBladesFoe2");
		DeleteLocalObject(oToB, "WallofBladesFoe3");
		DeleteLocalObject(oToB, "WallofBladesFoe4");
		DeleteLocalObject(oToB, "WallofBladesFoe5");
		DeleteLocalObject(oToB, "WallofBladesFoe6");
		DeleteLocalObject(oToB, "WallofBladesFoe7");
		DeleteLocalObject(oToB, "WallofBladesFoe8");
		DeleteLocalObject(oToB, "WallofBladesFoe9");
		DeleteLocalObject(oToB, "WallofBladesFoe10");
		RemoveAttackRollOverride(oPC, 1);
	}	
}

void WallOfBladesCheck(object oPC, object oToB)
{
	if ((GetLocalInt(oPC, "WallofBladesActive") == 2) && (GetLocalInt(oToB, "Swift") == 0))
	{
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

		DeleteLocalInt(oPC, "WallofBladesActive");
		RemoveAttackRollOverride(oPC, 1);
		StrikeAttackSound(oWeapon, oPC, 1, 0.0f, FALSE);
		FloatingTextStringOnCreature("<color=cyan>*Wall of Blades!*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
		RunSwiftAction(96, "C");
	}
	else 
	{
		SetLocalInt(oPC, "WallofBladesActive", 1);
		DelayCommand(0.1f, WallOfBladesCheck(oPC, oToB));
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nD20 = d20();
	int nAB = GetMaxAB(oPC, oWeapon, oPC); //Not a true attack roll, therefore vs self to normalize the return roll.
	int nAC = GetAC(oPC);
	int nRoll = nD20 + nAB;

	SendMessageToPC(oPC, "<color=chocolate>Wall of Blades: Attack Roll: (" + IntToString(nD20) + " + " + IntToString(nAB) + " = " + IntToString(nRoll) + ") vs. " + GetName(oPC) + "'s AC: " + IntToString(nAC) + ".</color>");
	ExpendManeuver(96, "C");

	if (nRoll > nAC)
	{
		object oToB = GetItemPossessedBy(oPC, "tob");

		OverrideAttackRollAC(oPC, 3, nRoll);
		SetLocalInt(oPC, "WallofBladesActive", 1); //Switched off in bot9s_inc_maneuvers
		WallOfBlades(oPC, oToB, nRoll);
		WallOfBladesCheck(oPC, oToB);
	}
}