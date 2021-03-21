//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 7/25/2009							//
//	Title: bo_sudden_leap					//
//	Description: Jump as a swift action.	//
//////////////////////////////////////////////

#include "bot9s_inc_2da"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	
	if (GetLocalInt(oToB, "Swift") == 0)
	{
		location lPC = GetLocation(oPC);
		float fx = GetManeuverX(oToB, 182);
		float fy = GetManeuverY(oToB, 182);
		float fz = GetManeuverZ(oToB, 182);
		vector vTarget = Vector(fx, fy, fz);
		location lTarget;

		lTarget = Location(GetArea(oPC), vTarget, GetFacing(oPC));

		if (!GetIsLocationValid(lTarget) || lTarget == lPC || !LineOfEffect(oPC, lTarget, TRUE) || !LineOfSightVector(GetPositionFromLocation(lPC), vTarget))
		{
			SendMessageToPC(oPC, "<color=red>This is not a valid location to jump to.</color>");
			return;
		}

		float fDist = GetDistanceBetweenLocations(lPC, lTarget) * 3.28083989501312f; // Meters to Feet conversion.

		float fRun;
		int nTaunt;

		if ((GetCurrentAction(oPC) == ACTION_MOVETOPOINT) || (GetLocalInt(oPC, "LeapingDragonStance") == 1))
		{
			fRun = 1.0f;

			if (GetHasFeat(FEAT_DASH)) // Using this instead of the "Run" feat.
			{
				nTaunt += 4;
			}
		}
		else fRun = 2.0f;

		effect eSpeed;

		eSpeed = GetFirstEffect(oPC);

		while (GetIsEffectValid(eSpeed))
		{
			int nType = GetEffectType(eSpeed);

			if (nType == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE)
			{
				int nSpeed = GetEffectInteger(eSpeed, 0);
				float fCheck = IntToFloat(nSpeed) / (5.0f/3.0f);

				if (fCheck >= 59.0f) //Double Speed. Max value of the movement increase % is 99.
				{
					nTaunt += 12;
				}
				else if (fCheck >= 50.0f)
				{
					nTaunt += 8;
				}
				else if (fCheck >= 40.0f)
				{
					nTaunt += 4;
				}
			}
			else if (nType == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
			{
				int nSpeed = GetEffectInteger(eSpeed, 0);
				float fCheck = IntToFloat(nSpeed) / (5.0f/3.0f);

				if (fCheck >= 59.0f) //Immobile. Max value of the movement decrease % is 99.
				{
					nTaunt -= 18;
				}
				else if (fCheck >= 50.0f)
				{
					nTaunt -= 12;
				}
				else if (fCheck >= 40.0f)
				{
					nTaunt -= 6;
				}
			}

			eSpeed = GetNextEffect(oPC);
		}

		float fDC = fDist * fRun;
		int nDC = FloatToInt(fDC);
		object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
		int nArmor, nShield;

		if (oArmor == OBJECT_INVALID)
		{
			nArmor = 0; //Prevents the function from shutting down.
		}
		else nArmor = GetArmorRulesType(oArmor);

		int nArmorPenalty = abs(tob_Get2daInt("armorrulestats", "ACCHECK", nArmor));

		object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

		if (oShield == OBJECT_INVALID)
		{
			nShield = 0; //Prevents the function from shutting down.
		}
		else nShield = GetArmorRulesType(oShield);

		int nShieldPenalty = abs(tob_Get2daInt("armorrulestats", "ACCHECK", nShield));

		int nArmorCheckPenalty = nArmorPenalty + nShieldPenalty;
		int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
		int nd20 = d20();

		nTaunt += GetSkillRank(SKILL_TAUNT, oPC, TRUE);

		if (GetHasFeat(FEAT_SKILL_FOCUS_TAUNT, oPC))
		{
			nTaunt += 3;
		}

		if (GetHasFeat(FEAT_EPIC_SKILL_FOCUS_TAUNT, oPC))
		{
			nTaunt += 10;
		}

		if (GetHasFeat(FEAT_EPIC_REPUTATION, oPC))
		{
			nTaunt += 4;
		}

		if (GetSkillRank(SKILL_TUMBLE, oPC, TRUE) > 4)
		{
			nTaunt += 2; //Synergy
		}

		if (GetRacialType(oPC) == RACIAL_TYPE_HALFLING)
		{
			nTaunt += 2; //Racial Bonus
		}

		if (GetHasFeat(6913, oPC)) //Blade Meditation: Tiger Claw
		{
			nTaunt += 2;
		}

		int nRoll = (nd20 + nStr + nTaunt) - nArmorCheckPenalty;

		SendMessageToPC(oPC, "<color=chocolate>" + GetName(oPC) + ": Jump Check: (" + IntToString(nd20) + " + " + IntToString(nStr) + " + " + IntToString(nTaunt) + " - " + IntToString(nArmorCheckPenalty) + " = " + IntToString(nRoll) + ") vs. DC: " + IntToString(nDC) + "</color>");

		if (nRoll < nDC)
		{
			SendMessageToPC(oPC, "<color=red>You failed your skill check for Sudden Leap.</color>");
		}
		else
		{
			ClearAllActions();
			AssignCommand(oPC, ClearStrikes());
			WrapperPlayCustomAnimation(oPC, "leapup", 0);
			DelayCommand(1.0f, AssignCommand(oPC, JumpToLocation(lTarget)));
			DelayCommand(1.02f, WrapperPlayCustomAnimation(oPC, "leapdown", 0));
		}

		RunSwiftAction(182, "B");
		ExpendManeuver(182, "B");
	}
}