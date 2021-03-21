//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 8/23/2009								//
//	Title: ct_baffling_def						//
//	Description: If your opponent strikes you on//
//  his turn, you can replace your AC with the  //
//  result of a wisdom based Appraise check as  //
//  an immediate action. You initiate this 		//
//  maneuver before your opponent’s attack. Your//
//  Appraise check applies to only one attack.  //
//  You must be aware of the attack to which you//
//  will apply the effect of this maneuver. It  //
//  will not defend you against an enemeny that //
//  catches you flat-footed.					//
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
			if (GetObjectSeen(oFoe, oPC) || GetObjectHeard(oFoe, oPC))
			{
				SetLocalObject(oToB, "BafflingDefenseFoe" + IntToString(n), oFoe);
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

void BafflingDefense(int nRoll)
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	if ((ValidateCounter(97)) && (GetLocalInt(oPC, "BafflingDefenseActive") == 1))
	{
		AssignCommand(oPC, GenerateFoes(oPC, oToB));

		object oFoe1 = GetLocalObject(oToB, "BafflingDefenseFoe1");

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

		object oFoe2 = GetLocalObject(oToB, "BafflingDefenseFoe2");

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

		object oFoe3 = GetLocalObject(oToB, "BafflingDefenseFoe3");

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

		object oFoe4 = GetLocalObject(oToB, "BafflingDefenseFoe4");

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

		object oFoe5 = GetLocalObject(oToB, "BafflingDefenseFoe5");

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

		object oFoe6 = GetLocalObject(oToB, "BafflingDefenseFoe6");

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

		object oFoe7 = GetLocalObject(oToB, "BafflingDefenseFoe7");

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

		object oFoe8 = GetLocalObject(oToB, "BafflingDefenseFoe8");

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

		object oFoe9 = GetLocalObject(oToB, "BafflingDefenseFoe9");

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

		object oFoe10 = GetLocalObject(oToB, "BafflingDefenseFoe10");

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

		DelayCommand(6.0f, BafflingDefense(nRoll));
	}
	else 
	{
		DeleteLocalInt(oPC, "BafflingDefenseActive");
		DeleteLocalObject(oToB, "BafflingDefenseFoe1");
		DeleteLocalObject(oToB, "BafflingDefenseFoe2");
		DeleteLocalObject(oToB, "BafflingDefenseFoe3");
		DeleteLocalObject(oToB, "BafflingDefenseFoe4");
		DeleteLocalObject(oToB, "BafflingDefenseFoe5");
		DeleteLocalObject(oToB, "BafflingDefenseFoe6");
		DeleteLocalObject(oToB, "BafflingDefenseFoe7");
		DeleteLocalObject(oToB, "BafflingDefenseFoe8");
		DeleteLocalObject(oToB, "BafflingDefenseFoe9");
		DeleteLocalObject(oToB, "BafflingDefenseFoe10");
		RemoveAttackRollOverride(oPC, 1);
	}	
}

void BafflingDefenseCheck()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	if ((GetLocalInt(oPC, "BafflingDefenseActive") == 2) && (GetLocalInt(oToB, "Swift") == 0))
	{
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

		DeleteLocalInt(oPC, "BafflingDefenseActive");
		RemoveAttackRollOverride(oPC, 1);
		StrikeAttackSound(oWeapon, oPC, 1, 0.0f, FALSE);
		FloatingTextStringOnCreature("<color=cyan>*Baffling Defense!*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
		RunSwiftAction(97, "C");
	}
	else 
	{
		SetLocalInt(oPC, "BafflingDefenseActive", 1);
		DelayCommand(0.1f, BafflingDefenseCheck());
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	float fD20 = IntToFloat(d20());
	float fAppraise = IntToFloat(GetSkillRank(SKILL_APPRAISE, oPC, TRUE));
	float fCrossClass = (IntToFloat(GetHitDice(oPC)) + 3.0f) / 2.0f; // This is the reason that all of this is in floats.
	float fAdjustment;

	if (fAppraise > fCrossClass)
	{
		fAdjustment = 0.0f; // Class Skill
	}
	else fAdjustment = fCrossClass;

	if (GetHasFeat(FEAT_SILVER_PALM, oPC))
	{
		fAdjustment += 2.0f;
	}

	if (GetHasFeat(FEAT_THUG, oPC))
	{
		fAdjustment += 2.0f;
	}

	if (GetHasFeat(FEAT_BACKGROUND_APPRAISER, oPC))
	{
		fAdjustment += 2.0f;
	}

	if (GetHasFeat(FEAT_BACKGROUND_WILD_CHILD, oPC))
	{
		fAdjustment -= 2.0f;
	}

	if (GetHasFeat(FEAT_EPITHET_FORGOTTEN_LORD, oPC))
	{
		fAdjustment += 2.0f;
	}

	if (GetHasFeat(6910, oPC)) //Blade Meditation, Setting Sun
	{
		fAdjustment += 1.0f;
	}

	if (GetHasFeat(404, oPC)) //Skill Focus
	{
		fAdjustment += 3.0f;
	}

	if (GetHasFeat(588, oPC)) //Epic Skill Focus
	{
		fAdjustment += 10.0f;
	}

	float fWisdom = IntToFloat(GetAbilityModifier(ABILITY_WISDOM, oPC));
	float fAC = IntToFloat(GetAC(oPC));
	float fRoll = fD20 + fAppraise + fWisdom + fAdjustment;

	SendMessageToPC(oPC, "<color=chocolate>Baffling Defense: Appraise Check: (" + IntToString(FloatToInt(fD20)) + " + " + IntToString(FloatToInt(fAppraise)) + " + " + IntToString(FloatToInt(fWisdom)) + " + " + IntToString(FloatToInt(fAdjustment)) + " = " + IntToString(FloatToInt(fRoll)) + ") vs. " + GetName(oPC) + "'s AC: " + IntToString(FloatToInt(fAC)) + ".</color>");
	ExpendManeuver(97, "C");

	if (fRoll > fAC)
	{
		OverrideAttackRollAC(oPC, 3, FloatToInt(fRoll));
		SetLocalInt(oPC, "BafflingDefenseActive", 1); //Switched off in bot9s_inc_maneuvers
		BafflingDefense(FloatToInt(fRoll));
		BafflingDefenseCheck();
	}
}