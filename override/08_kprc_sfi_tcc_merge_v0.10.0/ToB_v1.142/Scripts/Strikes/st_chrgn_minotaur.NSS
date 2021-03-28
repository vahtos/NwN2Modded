//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 7/9/2009								//
//	Title:	st_chrgn_minotaur					//
//	Description: Allows the player to make a	//
//	bull rush without prokoking an attack of	//
//	opportunity and also adds 2d6 + Str damage. //
//////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"
#include "tob_x0_i0_position"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 146);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "StoneDragonStrike", 1);
	DelayCommand(RoundsToSeconds(1), SetLocalInt(oToB, "StoneDragonStrike", 0));

	int nMySize = GetCreatureSize(oPC);
	int nFoeSize = GetCreatureSize(oTarget);

	if (nMySize == nFoeSize || (nMySize - 1) == nFoeSize || (nMySize + 1) == nFoeSize) //Target must be one size category smaller, the same size or one larger than the player.
	{
		ExpendManeuver(146, "STR");

		int nMyStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
		int nFoeStr = GetAbilityModifier(ABILITY_STRENGTH, oTarget);
		int nBonus, nFoeBonus;

		nBonus += 2; // Granted since a charge is part of the initiation of this action.
	
		if (GetRacialType(oTarget) == RACIAL_TYPE_DWARF) // Dwarven Stability in all its stockiness!
		{
			nFoeBonus += 4;
		}
	
		if (nMySize > CREATURE_SIZE_MEDIUM)
		{
			nBonus += (nMySize - CREATURE_SIZE_MEDIUM) * 4;
		}
		else if (nMySize < CREATURE_SIZE_MEDIUM)
		{
			nBonus -= (CREATURE_SIZE_MEDIUM - nMySize) * 4;
		}

		if (nFoeSize > CREATURE_SIZE_MEDIUM)
		{
			nFoeBonus += (nFoeSize - CREATURE_SIZE_MEDIUM) * 4;
		}
		else if (nFoeSize < CREATURE_SIZE_MEDIUM)
		{
			nFoeBonus -= (CREATURE_SIZE_MEDIUM - nFoeSize) * 4;
		}

		int nMyd20 = d20(1);
		int nFoed20 = d20(1);
		int nMyRoll = nMyStr + nBonus + nMyd20;
		int nFoeRoll = nFoeStr + nFoeBonus + nFoed20;

		SendMessageToPC(oPC, "<color=chocolate>Bull Rush: " + GetName(oPC) + " : (" + IntToString(nMyStr) + " + " + IntToString(nBonus) + " + " + IntToString(nMyd20) + " = " + IntToString(nMyRoll) + ") vs. " + GetName(oTarget) + " : (" + IntToString(nFoeStr) + " + " + IntToString(nFoeBonus) + " + " + IntToString(nFoed20) + " = " + IntToString(nFoeRoll) + ")</color>");

		if (nMyRoll >= nFoeRoll)
		{
			int nDamage = d6(2) + nMyStr;
			effect eMinotuar = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);
			effect eSkid = EffectVisualEffect(VFX_TOB_SKIDBACK);
			location lFoe = GetLocation(oTarget);
			float fMove = GetDistanceBetween(oPC, oTarget);
			location lMove = GetAheadLocation(oPC, fMove);

			DelayCommand(0.5f, PlayVoiceChat(VOICE_CHAT_GATTACK3, oPC));
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eMinotuar, oTarget);
			WrapperPlayCustomAnimation(oPC, "shieldbash", 0);
			StrikeAttackSound(OBJECT_INVALID, oTarget, 1, 1.4);
			DelayCommand(1.41f, JumpToLocation(lMove));
			DelayCommand(1.35f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSkid, oTarget, 0.2f));
			
			int nResult = nMyRoll - nFoeRoll;
			float fDistance;

			fDistance = FeetToMeters(5.0f); // Minimum push distance.

			if (nResult >= 5)
			{
				fDistance += FeetToMeters(5.0f);
			}
			else if (nResult >= 10)
			{
				fDistance += FeetToMeters(10.0f);
			}
			else if (nResult >= 15)
			{
				fDistance += FeetToMeters(15.0f);
			}
			else if (nResult >= 20)
			{
				fDistance += FeetToMeters(20.0f);
			}
			else if (nResult >= 25)
			{
				fDistance += FeetToMeters(25.0f);
			}
			else if (nResult >= 30)
			{
				fDistance += FeetToMeters(30.0f);
			}
			else if (nResult >= 35)
			{
				fDistance += FeetToMeters(35.0f);
			}
			else if (nResult >= 40)
			{
				fDistance += FeetToMeters(40.0f);
			}

			location lPC = GetLocation(oPC);
			location lBullrush, lJump;

			lBullrush = GetAheadLocation(oPC, fMove + fDistance);

			if (!GetIsLocationValid(lBullrush))
			{
				fDistance -= FeetToMeters(5.0f); //40ft
			}
			else 
			{
				DelayCommand(1.4f, AssignCommand(oTarget, JumpToLocation(lBullrush)));
				return;
			}

			lBullrush = GetAheadLocation(oPC, fMove + fDistance);

			if (!GetIsLocationValid(lBullrush))
			{
				fDistance -= FeetToMeters(5.0f); //35ft
			}
			else 
			{
				DelayCommand(1.4f, AssignCommand(oTarget, JumpToLocation(lBullrush)));
				return;
			}

			lBullrush = GetAheadLocation(oPC, fMove + fDistance);

			if (!GetIsLocationValid(lBullrush))
			{
				fDistance -= FeetToMeters(5.0f); //30ft
			}
			else 
			{
				DelayCommand(1.4f, AssignCommand(oTarget, JumpToLocation(lBullrush)));
				return;
			}

			lBullrush = GetAheadLocation(oPC, fMove + fDistance);

			if (!GetIsLocationValid(lBullrush))
			{
				fDistance -= FeetToMeters(5.0f); //25ft
			}
			else 
			{
				DelayCommand(1.4f, AssignCommand(oTarget, JumpToLocation(lBullrush)));
				return;
			}

			lBullrush = GetAheadLocation(oPC, fMove + fDistance);

			if (!GetIsLocationValid(lBullrush))
			{
				fDistance -= FeetToMeters(5.0f); //20ft
			}
			else 
			{
				DelayCommand(1.4f, AssignCommand(oTarget, JumpToLocation(lBullrush)));
				return;
			}

			lBullrush = GetAheadLocation(oPC, fMove + fDistance);

			if (!GetIsLocationValid(lBullrush))
			{
				fDistance -= FeetToMeters(5.0f); //15ft
			}
			else 
			{
				DelayCommand(1.4f, AssignCommand(oTarget, JumpToLocation(lBullrush)));
				return;
			}

			lBullrush = GetAheadLocation(oPC, fMove + fDistance);

			if (!GetIsLocationValid(lBullrush))
			{
				fDistance -= FeetToMeters(5.0f); //10ft
			}
			else 
			{
				DelayCommand(1.4f, AssignCommand(oTarget, JumpToLocation(lBullrush)));
				return;
			}

			lBullrush = GetAheadLocation(oPC, fMove + FeetToMeters(5.0f));
			DelayCommand(1.4f, AssignCommand(oTarget, JumpToLocation(lBullrush)));
		}
		else 
		{
			SendMessageToPC(oPC, "<color=red>Your bull rush attempt failed!</color>");
			WrapperPlayCustomAnimation(oPC, "*knockdownB", 0);
		}
	}
	else SendMessageToPC(oPC, "<color=red>You can only bull rush a target that is one size category smaller than you are, your size, or one size category larger.</color>");
}