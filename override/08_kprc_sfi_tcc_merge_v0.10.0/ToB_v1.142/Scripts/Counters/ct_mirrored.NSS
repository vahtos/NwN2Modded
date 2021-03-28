//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 9/18/2009							//
//	Title: ct_mirrored						//
//	Description: When an opponent adjacent  //
//  to you moves, you can initiate this     //
//  maneuver to immediately move adjacent to//
//  her as soon as she stops moving, as long//
//  as the distance you cover is less than  //
//  or equal to your speed. This movement   //
//  does not provoke attacks of opportunity.//
//////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void MirroredPursuit(object oPC, object oToB, float fRange)
{
	if (ValidateCounter(108))
	{
		object oTarget = GetLocalObject(oToB, "MirroredPursuit");
		location lTarget = GetLocation(oTarget);

		if (lTarget != GetLocalLocation(oPC, "MirroredFirst_loc"))
		{
			location lLast = GetLocalLocation(oPC, "Mirrored_loc");

			if (lLast == lTarget)
			{
				if ((LineOfEffect(oPC, lTarget, TRUE)) && (GetDistanceBetween(oPC, oTarget) - GetGirth(oTarget) <= fRange))
				{
					ClearStrikes();
					ClearAllActions();
					JumpToObject(oTarget);
					FloatingTextStringOnCreature("<color=cyan>*Mirrored Pursuit!*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
					RunSwiftAction(108, "C");
				}
				else
				{
					FloatingTextStringOnCreature("<color=red>*Mirrored Pursuit Failed!*</color>", oPC, TRUE, 5.0f, COLOR_RED, COLOR_RED_DARK);
					RunSwiftAction(108, "C");
				}
			}
			else 
			{
				SetLocalLocation(oPC, "Mirrored_loc", lTarget);
				DelayCommand(1.0f, MirroredPursuit(oPC, oToB, fRange));
			}
		}
		else DelayCommand(1.0f, MirroredPursuit(oPC, oToB, fRange));
	}
	else
	{
		DeleteLocalLocation(oPC, "MirroredFirst_loc");
		DeleteLocalLocation(oPC, "Mirrored_loc");
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = IntToObject(GetLocalInt(oToB, "Target"));
	
	if (NotMyFoe(oPC, oTarget))
	{
		SendMessageToPC(oPC, "<color=red>You cannot target yourself or your allies with this maneuver.</color>");
		return;
	}

	if (GetDistanceBetween(oPC, oTarget) - GetGirth(oTarget) <= FeetToMeters(8.0f))
	{
		int nRace = GetAppearanceType(oPC);
		float fBase = 3.0f * StringToFloat(Get2DAString("appearance", "RUNDIST", nRace));
		float fMod;

		effect eSpeed;
		int nLoadCheck, nSpeed;

		eSpeed = GetFirstEffect(oPC);

		while (GetIsEffectValid(eSpeed))
		{
			if (GetEffectType(eSpeed) == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE)
			{
				nSpeed += GetEffectInteger(eSpeed, 0);
			}
			else if (GetEffectType(eSpeed) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
			{
				nSpeed -= GetEffectInteger(eSpeed, 0);
				nLoadCheck = 1;
			}

			eSpeed = GetNextEffect(oPC);
		}

		if (nSpeed > 0)
		{
			fMod += ((IntToFloat(nSpeed))/17.0f) * 5.0f; // Conversion of % Speed modifier to feet per round.
		}

		if ((nLoadCheck == 0) && (GetLevelByClass(CLASS_TYPE_MONK, oPC) > 0)) // Monk Speed
		{
			int nArmor = GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC));

			if (nArmor <= ARMOR_RANK_LIGHT)
			{
				int nMonk = GetLevelByClass(CLASS_TYPE_MONK, oPC);

				switch (nMonk)
				{
					case 1:		fMod += 0.0f;	break;
					case 2:		fMod += 0.0f;	break;
					case 3:		fMod += 10.0f;	break;
					case 4:		fMod += 10.0f;	break;
					case 5:		fMod += 10.0f;	break;
					case 6:		fMod += 20.0f;	break;
					case 7:		fMod += 20.0f;	break;
					case 8:		fMod += 20.0f;	break;
					case 9:		fMod += 30.0f;	break;
					case 10:	fMod += 30.0f;	break;
					case 11:	fMod += 30.0f;	break;
					case 12:	fMod += 40.0f;	break;
					case 13:	fMod += 40.0f;	break;
					case 14:	fMod += 40.0f;	break;
					default:	fMod += 50.0f;	break;
				}
			}
		}

		if ((nLoadCheck == 0) && (GetLevelByClass(CLASS_TYPE_BARBARIAN, oPC) > 0)) // Barbarian Speed
		{
			int nArmor = GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC));

			if (nArmor <= ARMOR_RANK_MEDIUM)
			{
				fMod += 10.0f;
			}
		}

		if (GetHasFeat(FEAT_DASH, oPC))
		{
			fMod += 10.0f;
		}

		if (GetHasFeat(2248, oPC)) // Long Gait
		{
			fMod += 10.0f;
		}

		float fRange;

		fRange = FeetToMeters(fBase + fMod);

		if (fRange < 0.0f)
		{
			fRange = 0.0f;
		}

		SetLocalObject(oToB, "MirroredPursuit", oTarget);
		SetLocalLocation(oPC, "MirroredFirst_loc", GetLocation(oTarget));
		ExpendManeuver(108, "C");
		DelayCommand(1.0f, MirroredPursuit(oPC, oToB, fRange));
	}
	else SendMessageToPC(oPC, "<color=red>You must choose a target adjacent to you.</color>");
}