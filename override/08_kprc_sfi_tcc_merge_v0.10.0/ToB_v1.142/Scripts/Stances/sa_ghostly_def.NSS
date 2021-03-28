//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 10/28/2009								//
//	Title: sa_ghostly_def					    	//
//	Description: If an opponent attacks you, you can//
//  initiate this maneuver to make an opposed attack//
//  roll as an immediate action. If your foe's      //
//  result is higher, he attacks you as normal. If  //
//  your result is higher, your foe rolls damage as //
//  normal for the attack and takes that much       //
//  damage.                                         //
//////////////////////////////////////////////////////

	//Most of the work of this maneuver is handled in bot9s_inc_maneuvers.

#include "bot9s_armor"
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
			SetLocalObject(oToB, "GhostlyFoe" + IntToString(n), oFoe);
			n++;

			if (n > 10)//Only so many that I can manually keep track of.
			{
				break;
			}
		}
		oFoe = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE , oPC, n, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
	}
}

void GhostlyDefense()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	if (ValidateStance(104))
	{
		SetLocalInt(oPC, "Ghostly", 1); //Switched off in bot9s_inc_maneuvers

		if (!GetIsFlatFooted(oPC))
		{
			GenerateFoes(oPC, oToB);

			object oFoe1 = GetLocalObject(oToB, "GhostlyFoe1");

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

			object oFoe2 = GetLocalObject(oToB, "GhostlyFoe2");

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

			object oFoe3 = GetLocalObject(oToB, "GhostlyFoe3");

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

			object oFoe4 = GetLocalObject(oToB, "GhostlyFoe4");

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

			object oFoe5 = GetLocalObject(oToB, "GhostlyFoe5");

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

			object oFoe6 = GetLocalObject(oToB, "GhostlyFoe6");

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

			object oFoe7 = GetLocalObject(oToB, "GhostlyFoe7");

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

			object oFoe8 = GetLocalObject(oToB, "GhostlyFoe8");

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

			object oFoe9 = GetLocalObject(oToB, "GhostlyFoe9");

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

			object oFoe10 = GetLocalObject(oToB, "GhostlyFoe10");

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
		}

		DelayCommand(6.0f, GhostlyDefense());
	}
	else 
	{
		DeleteLocalInt(oPC, "Ghostly");
		DeleteLocalObject(oToB, "GhostlyFoe1");
		DeleteLocalObject(oToB, "GhostlyFoe2");
		DeleteLocalObject(oToB, "GhostlyFoe3");
		DeleteLocalObject(oToB, "GhostlyFoe4");
		DeleteLocalObject(oToB, "GhostlyFoe5");
		DeleteLocalObject(oToB, "GhostlyFoe6");
		DeleteLocalObject(oToB, "GhostlyFoe7");
		DeleteLocalObject(oToB, "GhostlyFoe8");
		DeleteLocalObject(oToB, "GhostlyFoe9");
		DeleteLocalObject(oToB, "GhostlyFoe10");
	}	
}

void main()
{
	GhostlyDefense();
}