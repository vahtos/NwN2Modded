//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 10/16/2009								//
//	Title: ct_shield_counter				    	//
//	Description: As an immediate action, you can    //
//  attempt a shield bash against an opponent you   //
//  threaten. This attack is made with a –2 penalty.//
//  If your shield attack hits, your target’s next  //
//  attack automatically misses.                    //
//////////////////////////////////////////////////////

	//Most of the work of this maneuver is handled in bot9s_inc_maneuvers.

#include "bot9s_combat_overrides"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void GenerateFoes(object oPC, object oToB)
{
	float fRange = GetMeleeRange(oPC);
	location lPC = GetLocation(oPC);

	int n;
	object oFoe;

	n = 1;
	oFoe = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);

	while (GetIsObjectValid(oFoe))
	{
		if ((oFoe != oPC) && (GetIsReactionTypeHostile(oFoe, oPC)))
		{
			SetLocalObject(oToB, "ShieldCounterFoe" + IntToString(n), oFoe);
			n++;

			if (n > 10)//Only so many that I can manually keep track of.
			{
				break;
			}
		}
		oFoe = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);
	}
}

void ShieldCounter(object oPC, object oToB)
{
	if ((ValidateCounter(49)) && (GetLocalInt(oPC, "ShieldCounter") == 1))
	{
		AssignCommand(oPC, GenerateFoes(oPC, oToB));

		object oFoe1 = GetLocalObject(oToB, "ShieldCounterFoe1");

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

		object oFoe2 = GetLocalObject(oToB, "ShieldCounterFoe2");

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

		object oFoe3 = GetLocalObject(oToB, "ShieldCounterFoe3");

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

		object oFoe4 = GetLocalObject(oToB, "ShieldCounterFoe4");

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

		object oFoe5 = GetLocalObject(oToB, "ShieldCounterFoe5");

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

		object oFoe6 = GetLocalObject(oToB, "ShieldCounterFoe6");

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

		object oFoe7 = GetLocalObject(oToB, "ShieldCounterFoe7");

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

		object oFoe8 = GetLocalObject(oToB, "ShieldCounterFoe8");

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

		object oFoe9 = GetLocalObject(oToB, "ShieldCounterFoe9");

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

		object oFoe10 = GetLocalObject(oToB, "ShieldCounterFoe10");

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

		DelayCommand(6.0f, ShieldCounter(oPC, oToB));
	}
	else 
	{
		DeleteLocalInt(oPC, "ShieldCounter");
		DeleteLocalObject(oToB, "ShieldCounterFoe1");
		DeleteLocalObject(oToB, "ShieldCounterFoe2");
		DeleteLocalObject(oToB, "ShieldCounterFoe3");
		DeleteLocalObject(oToB, "ShieldCounterFoe4");
		DeleteLocalObject(oToB, "ShieldCounterFoe5");
		DeleteLocalObject(oToB, "ShieldCounterFoe6");
		DeleteLocalObject(oToB, "ShieldCounterFoe7");
		DeleteLocalObject(oToB, "ShieldCounterFoe8");
		DeleteLocalObject(oToB, "ShieldCounterFoe9");
		DeleteLocalObject(oToB, "ShieldCounterFoe10");
	}	
}

void ShieldCounterCheck(object oPC, object oToB)
{
	if ((GetLocalInt(oPC, "ShieldCounter") == 2) && (GetLocalInt(oToB, "Swift") == 0))
	{
		DeleteLocalInt(oPC, "ShieldCounter");
		RunSwiftAction(49, "C");
	}
	else 
	{
		SetLocalInt(oPC, "ShieldCounter", 1);
		DelayCommand(0.1f, ShieldCounterCheck(oPC, oToB));
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	int nType = GetBaseItemType(oShield);

	if (!GetIsObjectValid(oShield))
	{
		SendMessageToPC(oPC, "<color=red>You must have a shield equipped to initiate this maneuver.");
		return;
	}
	else if ((nType != BASE_ITEM_LARGESHIELD) && (nType != BASE_ITEM_SMALLSHIELD) && (nType != BASE_ITEM_TOWERSHIELD))
	{
		SendMessageToPC(oPC, "<color=red>You must have a shield equipped to initiate this maneuver.");
		return;
	}

	object oToB = GetItemPossessedBy(oPC, "tob");

	SetLocalInt(oPC, "ShieldCounter", 1); //Switched off in bot9s_inc_maneuvers
	ShieldCounter(oPC, oToB);
	ShieldCounterCheck(oPC, oToB);
	ExpendManeuver(49, "C");
}