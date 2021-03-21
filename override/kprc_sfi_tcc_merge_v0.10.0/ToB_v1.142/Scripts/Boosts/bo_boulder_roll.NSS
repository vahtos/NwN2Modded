//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 9/11/2009								//
//	Title: bo_boulder_roll						//
//	Description: You make an overrun attack     //
//  against the first valid enemey you move past//
//  when you initiate this boost. You gain a +4 //
//  bonus on your Strength check made to overrun//
//  and if you fail your check, your target     //
//  can't knock you prone. You simply stop      //
//  moving in the last legal space you occupied.//
//////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void DelayedJump(object oPC, object oToB, object oTarget)
{
	location lPC = GetLocation(oPC);
	float fGirth = GetGirth(oTarget) + 0.01f;
	location lPop = CalcSafeLocation(oPC, lPC, fGirth, FALSE, TRUE);

	JumpToLocation(lPop);
	DeleteLocalLocation(oPC, "BoulderRoll_loc");
	DeleteLocalObject(oToB, "BoulderRoll");
}

void BoulderRoll(object oPC, object oToB)
{
	location lPC = GetLocation(oPC);
	location lLast = GetLocalLocation(oPC, "BoulderRoll_loc");

	if (lPC != lLast)
	{
		SetLocalLocation(oPC, "BoulderRoll_loc", lPC);

		if (GetCollision(oPC) == TRUE)
		{
			SetCollision(oPC, FALSE);
		}

		float fRange = GetMeleeRange(oPC);
		object oTarget, oFoe;

		oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);

		while (GetIsObjectValid(oTarget))
		{
			if (GetIsReactionTypeHostile(oTarget, oPC))
			{
				SetLocalObject(oToB, "BoulderRoll", oTarget);
				oFoe = oTarget;
				break;
			}
			else oFoe = OBJECT_INVALID;

			oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);
		}

		if ((GetIsObjectValid(oFoe)) && (!GetIsImmune(oFoe, IMMUNITY_TYPE_KNOCKDOWN)))
		{
			int nMySize = GetCreatureSize(oPC);
			int nFoeSize = GetCreatureSize(oFoe);

			if ((nMySize == nFoeSize) || (nMySize + 1 == nFoeSize) || (nMySize - 1 == nFoeSize))
			{
				int nMyStr = GetAbilityModifier(ABILITY_STRENGTH, oPC) + 4;
				int nFoeStr = GetAbilityModifier(ABILITY_STRENGTH, oFoe);
				int nFoeDex = GetAbilityModifier(ABILITY_DEXTERITY, oFoe);
				int nFoeMod;

				if (nFoeStr >= nFoeDex)
				{
					nFoeMod = nFoeStr;
				}
				else nFoeMod = nFoeDex;

				int nBonus;
				int nFoeBonus;

				if (nMySize > CREATURE_SIZE_MEDIUM)
				{
					nBonus += 4;
				}
				else if (nMySize < CREATURE_SIZE_MEDIUM)
				{
					nBonus -= 4;
				}

				if ((GetRacialType(oFoe) == RACIAL_TYPE_DWARF) || (GetRacialType(oFoe) == RACIAL_TYPE_ANIMAL)
				|| (GetRacialType(oFoe) == RACIAL_TYPE_BEAST) || (GetRacialType(oFoe) == RACIAL_TYPE_DRAGON)
				|| (GetRacialType(oFoe) == RACIAL_TYPE_MAGICAL_BEAST)) //Stable creatures
				{
					nFoeBonus += 4;
				}

				int nd20 = d20();
				int nFoed20 = d20();
				int nRoll = nd20 + nMyStr + nBonus;
				int nFoeRoll = nFoed20 + nFoeMod + nFoeBonus;

				SendMessageToPC(oPC, "<color=chocolate>Overrun: " + GetName(oPC) + " vs. " + GetName(oFoe) + " (" + IntToString(nd20) + " + " + IntToString(nMyStr) + " + " + IntToString(nBonus) + " = " + IntToString(nRoll) + ") vs. (" + IntToString(nFoed20) + " + " + IntToString(nFoeMod) + " + " + IntToString(nFoeBonus) + " = " + IntToString(nFoeRoll) + ").</color>");

				if (nRoll >= nFoeRoll)
				{
					effect eBoulder = EffectKnockdown();

					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBoulder, oFoe, 3.0f);
					DelayCommand(5.9f, SetCollision(oPC, TRUE));
					DelayCommand(6.0f, DelayedJump(oPC, oToB, oFoe));
				}
				else
				{
					ClearStrikes();
					ClearAllActions();
					SetCollision(oPC, TRUE);
					DelayCommand(0.1f, DelayedJump(oPC, oToB, oFoe));
				}
			}
			else DelayCommand(1.0f, BoulderRoll(oPC, oToB));
		}
		else DelayCommand(1.0f, BoulderRoll(oPC, oToB));
	}
	else
	{
		object oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE);

		ClearStrikes();
		ClearAllActions();
		SetCollision(oPC, TRUE);
		DelayCommand(0.1f, DelayedJump(oPC, oToB, oTarget));
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	float fx = GetManeuverX(oToB, 145);
	float fy = GetManeuverY(oToB, 145);
	float fz = GetManeuverZ(oToB, 145);
	vector vTarget = Vector(fx, fy, fz);
	location lTarget = Location(GetArea(oPC), vTarget, GetFacing(oPC));
	
	if (GetLocalInt(oToB, "Swift") == 0)	
	{
		if (GetCollision(oPC) == TRUE)
		{
			SetCollision(oPC, FALSE);
		}

		ClearAllActions();
		ClearStrikes();
		ActionMoveToLocation(lTarget, TRUE);
		RunSwiftAction(145, "B");
		ExpendManeuver(145, "B");
		BoulderRoll(oPC, oToB);
	}
}