//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 8/30/2009								//
//	Title: sa_pearl_obd							//
//	Description: Each time an opponent misses   //
//  you with a melee attack, you gain a +2 dodge//
//  bonus to AC. This bonus lasts until the 	//
//  start of your next turn and is cumulative 	//
//  for the round. The bonus applies to any 	//
//  attacks made by all opponents until the 	//
//  beginning of your next turn.				//
//////////////////////////////////////////////////

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
			SetLocalObject(oToB, "PearlofBlackDoubtFoe" + IntToString(n), oFoe);
			n++;

			if (n > 10)//Only so many that I can manually keep track of.
			{
				break;
			}
		}
		oFoe = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE , oPC, n, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
	}
}

void Pearl(object oPC, object oToB)
{
	if (ValidateStance(68))
	{
		AssignCommand(oPC, GenerateFoes(oPC, oToB));

		object oFoe1 = GetLocalObject(oToB, "PearlofBlackDoubtFoe1");

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

		object oFoe2 = GetLocalObject(oToB, "PearlofBlackDoubtFoe2");

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

		object oFoe3 = GetLocalObject(oToB, "PearlofBlackDoubtFoe3");

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

		object oFoe4 = GetLocalObject(oToB, "PearlofBlackDoubtFoe4");

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

		object oFoe5 = GetLocalObject(oToB, "PearlofBlackDoubtFoe5");

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

		object oFoe6 = GetLocalObject(oToB, "PearlofBlackDoubtFoe6");

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

		object oFoe7 = GetLocalObject(oToB, "PearlofBlackDoubtFoe7");

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

		object oFoe8 = GetLocalObject(oToB, "PearlofBlackDoubtFoe8");

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

		object oFoe9 = GetLocalObject(oToB, "PearlofBlackDoubtFoe9");

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

		object oFoe10 = GetLocalObject(oToB, "PearlofBlackDoubtFoe10");

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

		DelayCommand(6.0f, Pearl(oPC, oToB));
	}
	else 
	{
		DeleteLocalObject(oToB, "PearlofBlackDoubtFoe1");
		DeleteLocalObject(oToB, "PearlofBlackDoubtFoe2");
		DeleteLocalObject(oToB, "PearlofBlackDoubtFoe3");
		DeleteLocalObject(oToB, "PearlofBlackDoubtFoe4");
		DeleteLocalObject(oToB, "PearlofBlackDoubtFoe5");
		DeleteLocalObject(oToB, "PearlofBlackDoubtFoe6");
		DeleteLocalObject(oToB, "PearlofBlackDoubtFoe7");
		DeleteLocalObject(oToB, "PearlofBlackDoubtFoe8");
		DeleteLocalObject(oToB, "PearlofBlackDoubtFoe9");
		DeleteLocalObject(oToB, "PearlofBlackDoubtFoe10");
	}	
}

void BlackDoubt(object oPC, object oToB)
{
	if (ValidateStance(68))
	{
		int nPearlTimer = GetLocalInt(oPC, "PearlTimer");

		if (nPearlTimer > 59)
		{
			SetLocalInt(oPC, "PearlAC", 0);
			SetLocalInt(oPC, "PearlTimer", 0);
		}
		else SetLocalInt(oPC, "PearlTimer", nPearlTimer + 1);

		int nPearlAC = GetLocalInt(oPC, "PearlAC");

		if (nPearlAC > 0)
		{
			effect eAC = EffectACIncrease(nPearlAC);
			eAC = ExtraordinaryEffect(eAC);

			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, 0.1f);
		}

		DelayCommand(0.1f, BlackDoubt(oPC, oToB));
	}
	else
	{
		DeleteLocalInt(oPC, "PearlofBlackDoubtActive");
		DeleteLocalInt(oPC, "PearlTimer");
		DeleteLocalInt(oPC, "PearlAC");
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nPearlTimer = GetLocalInt(oPC, "PearlTimer");

	SetLocalInt(oPC, "PearlofBlackDoubtActive", 1);
	Pearl(oPC, oToB);

	if (nPearlTimer == 0) //Only run this when it isn't active.
	{
		BlackDoubt(oPC, oToB);
	}
}