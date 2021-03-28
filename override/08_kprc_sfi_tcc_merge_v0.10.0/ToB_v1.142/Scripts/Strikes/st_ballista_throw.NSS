//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 10/9/2009									//
//	Title: st_ballista_throw						//
//	Description: As part of this maneuver, you must //
//  succeed on a melee touch attack against your    //
//  foe. You can then make a trip attempt against   //
//  your enemy. You gain a +4 bonus on the ability  //
//  check.  If you succeed in tripping your foe, you//
//  throw him in a 60-foot line. The target and all //
//  creatures in this area take 6d6 points of       //
//  damage. The thrown creature lands prone at the  //
//  end of this line. You must place the target in  //
//  an empty space. If the space at the end of the  //
//  line is occupied, your opponent falls prone in  //
//  the open space closest to the line's endpoint.  //
//////////////////////////////////////////////////////

#include "bot9s_inc_feats"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"
#include "tob_x0_i0_position"

void BallistaThrow(object oTarget, float fSpace)
{
	object oPC = OBJECT_SELF;
	location lPC = GetLocation(oPC);
	location lLand = GetLocalLocation(oPC, "bot9s_landing");
	vector vPC = GetPosition(oPC);
	vector vTarget = GetPositionFromLocation(lLand);
	float fFive = FeetToMeters(5.0f); // Preferred number for incrementing because in Pen and Paper rules this is the size of a square.
	float fMax = GetDistanceBetweenLocations(lPC, lLand);
	float fDest = GetAngle(vPC, vTarget, fMax);
	float fGirth = GetGirth(oTarget); //Assuming that the rules as intended mean that we're throwing the target through others and therefore the damage area is equal to its size.

	object oBallista;
	location lLine;
	float fDistance;
	effect eDamage;

	fDistance += fFive; // Five feet out from the PC's origin position.
	lLine = GenerateNewLocation(oPC, fDistance, fDest, fDest);

	if (GetIsLocationValid(lLine))
	{
		oBallista = GetFirstObjectInShape(SHAPE_SPHERE, fGirth, lLine);

		while (GetIsObjectValid(oBallista))
		{
			if ((GetIsReactionTypeHostile(oBallista, oPC)) && (GetLocalInt(oBallista, "BallistaThrow") == 0))
			{
				eDamage = EffectDamage(d6(6), DAMAGE_TYPE_BLUDGEONING);

				SetLocalInt(oBallista, "BallistaThrow", 1); // Prevent the damage from being applied more than once by this maneuver.
				AssignCommand(oBallista, DelayCommand(0.5f, DeleteLocalInt(oBallista, "BallistaThrow")));
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oBallista);
			}

			oBallista = GetNextObjectInShape(SHAPE_SPHERE, fGirth, lLine);
		}
	}

	fDistance += fFive; // 10 feet.
	lLine = GenerateNewLocation(oPC, fDistance, fDest, fDest);

	if (GetIsLocationValid(lLine))
	{
		oBallista = GetFirstObjectInShape(SHAPE_SPHERE, fGirth, lLine);

		while (GetIsObjectValid(oBallista))
		{
			if ((GetIsReactionTypeHostile(oBallista, oPC)) && (GetLocalInt(oBallista, "BallistaThrow") == 0))
			{
				eDamage = EffectDamage(d6(6), DAMAGE_TYPE_BLUDGEONING);

				SetLocalInt(oBallista, "BallistaThrow", 1); // Prevent the damage from being applied more than once by this maneuver.
				AssignCommand(oBallista, DelayCommand(0.5f, DeleteLocalInt(oBallista, "BallistaThrow")));
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oBallista);
			}

			oBallista = GetNextObjectInShape(SHAPE_SPHERE, fGirth, lLine);
		}
	}

	fDistance += fFive; // 15 feet.
	lLine = GenerateNewLocation(oPC, fDistance, fDest, fDest);

	if (GetIsLocationValid(lLine))
	{
		oBallista = GetFirstObjectInShape(SHAPE_SPHERE, fGirth, lLine);

		while (GetIsObjectValid(oBallista))
		{
			if ((GetIsReactionTypeHostile(oBallista, oPC)) && (GetLocalInt(oBallista, "BallistaThrow") == 0))
			{
				eDamage = EffectDamage(d6(6), DAMAGE_TYPE_BLUDGEONING);

				SetLocalInt(oBallista, "BallistaThrow", 1); // Prevent the damage from being applied more than once by this maneuver.
				AssignCommand(oBallista, DelayCommand(0.5f, DeleteLocalInt(oBallista, "BallistaThrow")));
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oBallista);
			}

			oBallista = GetNextObjectInShape(SHAPE_SPHERE, fGirth, lLine);
		}
	}

	fDistance += fFive; // 20 feet.
	lLine = GenerateNewLocation(oPC, fDistance, fDest, fDest);

	if (GetIsLocationValid(lLine))
	{
		oBallista = GetFirstObjectInShape(SHAPE_SPHERE, fGirth, lLine);

		while (GetIsObjectValid(oBallista))
		{
			if ((GetIsReactionTypeHostile(oBallista, oPC)) && (GetLocalInt(oBallista, "BallistaThrow") == 0))
			{
				eDamage = EffectDamage(d6(6), DAMAGE_TYPE_BLUDGEONING);

				SetLocalInt(oBallista, "BallistaThrow", 1); // Prevent the damage from being applied more than once by this maneuver.
				AssignCommand(oBallista, DelayCommand(0.5f, DeleteLocalInt(oBallista, "BallistaThrow")));
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oBallista);
			}

			oBallista = GetNextObjectInShape(SHAPE_SPHERE, fGirth, lLine);
		}
	}

	fDistance += fFive; // 25 feet.
	lLine = GenerateNewLocation(oPC, fDistance, fDest, fDest);

	if (GetIsLocationValid(lLine))
	{
		oBallista = GetFirstObjectInShape(SHAPE_SPHERE, fGirth, lLine);

		while (GetIsObjectValid(oBallista))
		{
			if ((GetIsReactionTypeHostile(oBallista, oPC)) && (GetLocalInt(oBallista, "BallistaThrow") == 0))
			{
				eDamage = EffectDamage(d6(6), DAMAGE_TYPE_BLUDGEONING);

				SetLocalInt(oBallista, "BallistaThrow", 1); // Prevent the damage from being applied more than once by this maneuver.
				AssignCommand(oBallista, DelayCommand(0.5f, DeleteLocalInt(oBallista, "BallistaThrow")));
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oBallista);
			}

			oBallista = GetNextObjectInShape(SHAPE_SPHERE, fGirth, lLine);
		}
	}

	fDistance += fFive; // 30 feet.
	lLine = GenerateNewLocation(oPC, fDistance, fDest, fDest);

	if (GetIsLocationValid(lLine))
	{
		oBallista = GetFirstObjectInShape(SHAPE_SPHERE, fGirth, lLine);

		while (GetIsObjectValid(oBallista))
		{
			if ((GetIsReactionTypeHostile(oBallista, oPC)) && (GetLocalInt(oBallista, "BallistaThrow") == 0))
			{
				eDamage = EffectDamage(d6(6), DAMAGE_TYPE_BLUDGEONING);

				SetLocalInt(oBallista, "BallistaThrow", 1); // Prevent the damage from being applied more than once by this maneuver.
				AssignCommand(oBallista, DelayCommand(0.5f, DeleteLocalInt(oBallista, "BallistaThrow")));
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oBallista);
			}

			oBallista = GetNextObjectInShape(SHAPE_SPHERE, fGirth, lLine);
		}
	}

	fDistance += fFive; // 35 feet.
	lLine = GenerateNewLocation(oPC, fDistance, fDest, fDest);

	if (GetIsLocationValid(lLine))
	{
		oBallista = GetFirstObjectInShape(SHAPE_SPHERE, fGirth, lLine);

		while (GetIsObjectValid(oBallista))
		{
			if ((GetIsReactionTypeHostile(oBallista, oPC)) && (GetLocalInt(oBallista, "BallistaThrow") == 0))
			{
				eDamage = EffectDamage(d6(6), DAMAGE_TYPE_BLUDGEONING);

				SetLocalInt(oBallista, "BallistaThrow", 1); // Prevent the damage from being applied more than once by this maneuver.
				AssignCommand(oBallista, DelayCommand(0.5f, DeleteLocalInt(oBallista, "BallistaThrow")));
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oBallista);
			}

			oBallista = GetNextObjectInShape(SHAPE_SPHERE, fGirth, lLine);
		}
	}

	fDistance += fFive; // 40 feet.
	lLine = GenerateNewLocation(oPC, fDistance, fDest, fDest);

	if (GetIsLocationValid(lLine))
	{
		oBallista = GetFirstObjectInShape(SHAPE_SPHERE, fGirth, lLine);

		while (GetIsObjectValid(oBallista))
		{
			if ((GetIsReactionTypeHostile(oBallista, oPC)) && (GetLocalInt(oBallista, "BallistaThrow") == 0))
			{
				eDamage = EffectDamage(d6(6), DAMAGE_TYPE_BLUDGEONING);

				SetLocalInt(oBallista, "BallistaThrow", 1); // Prevent the damage from being applied more than once by this maneuver.
				AssignCommand(oBallista, DelayCommand(0.5f, DeleteLocalInt(oBallista, "BallistaThrow")));
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oBallista);
			}

			oBallista = GetNextObjectInShape(SHAPE_SPHERE, fGirth, lLine);
		}
	}

	fDistance += fFive; // 45 feet.
	lLine = GenerateNewLocation(oPC, fDistance, fDest, fDest);

	if (GetIsLocationValid(lLine))
	{
		oBallista = GetFirstObjectInShape(SHAPE_SPHERE, fGirth, lLine);

		while (GetIsObjectValid(oBallista))
		{
			if ((GetIsReactionTypeHostile(oBallista, oPC)) && (GetLocalInt(oBallista, "BallistaThrow") == 0))
			{
				eDamage = EffectDamage(d6(6), DAMAGE_TYPE_BLUDGEONING);

				SetLocalInt(oBallista, "BallistaThrow", 1); // Prevent the damage from being applied more than once by this maneuver.
				AssignCommand(oBallista, DelayCommand(0.5f, DeleteLocalInt(oBallista, "BallistaThrow")));
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oBallista);
			}

			oBallista = GetNextObjectInShape(SHAPE_SPHERE, fGirth, lLine);
		}
	}

	fDistance += fFive; // 50 feet.
	lLine = GenerateNewLocation(oPC, fDistance, fDest, fDest);

	if (GetIsLocationValid(lLine))
	{
		oBallista = GetFirstObjectInShape(SHAPE_SPHERE, fGirth, lLine);

		while (GetIsObjectValid(oBallista))
		{
			if ((GetIsReactionTypeHostile(oBallista, oPC)) && (GetLocalInt(oBallista, "BallistaThrow") == 0))
			{
				eDamage = EffectDamage(d6(6), DAMAGE_TYPE_BLUDGEONING);

				SetLocalInt(oBallista, "BallistaThrow", 1); // Prevent the damage from being applied more than once by this maneuver.
				AssignCommand(oBallista, DelayCommand(0.5f, DeleteLocalInt(oBallista, "BallistaThrow")));
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oBallista);
			}

			oBallista = GetNextObjectInShape(SHAPE_SPHERE, fGirth, lLine);
		}
	}

	fDistance += fFive; // 55 feet.
	lLine = GenerateNewLocation(oPC, fDistance, fDest, fDest);

	if (GetIsLocationValid(lLine))
	{
		oBallista = GetFirstObjectInShape(SHAPE_SPHERE, fGirth, lLine);

		while (GetIsObjectValid(oBallista))
		{
			if ((GetIsReactionTypeHostile(oBallista, oPC)) && (GetLocalInt(oBallista, "BallistaThrow") == 0))
			{
				eDamage = EffectDamage(d6(6), DAMAGE_TYPE_BLUDGEONING);

				SetLocalInt(oBallista, "BallistaThrow", 1); // Prevent the damage from being applied more than once by this maneuver.
				AssignCommand(oBallista, DelayCommand(0.5f, DeleteLocalInt(oBallista, "BallistaThrow")));
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oBallista);
			}

			oBallista = GetNextObjectInShape(SHAPE_SPHERE, fGirth, lLine);
		}
	}

	fDistance += fFive; // 60 feet.
	lLine = GenerateNewLocation(oPC, fDistance, fDest, fDest);

	if (GetIsLocationValid(lLine))
	{
		oBallista = GetFirstObjectInShape(SHAPE_SPHERE, fGirth, lLine);

		while (GetIsObjectValid(oBallista))
		{
			if ((GetIsReactionTypeHostile(oBallista, oPC)) && (GetLocalInt(oBallista, "BallistaThrow") == 0))
			{
				eDamage = EffectDamage(d6(6), DAMAGE_TYPE_BLUDGEONING);

				SetLocalInt(oBallista, "BallistaThrow", 1); // Prevent the damage from being applied more than once by this maneuver.
				AssignCommand(oBallista, DelayCommand(0.5f, DeleteLocalInt(oBallista, "BallistaThrow")));
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oBallista);
			}

			oBallista = GetNextObjectInShape(SHAPE_SPHERE, fGirth, lLine);
		}
	}

	fDistance += fSpace; // Going this far out because the distance check starts from the center of the player rather than the edge of the square the player is in.
	lLine = GenerateNewLocation(oPC, fDistance, fDest, fDest);

	if (GetIsLocationValid(lLine))
	{
		oBallista = GetFirstObjectInShape(SHAPE_SPHERE, fGirth, lLine);

		while (GetIsObjectValid(oBallista))
		{
			if ((GetIsReactionTypeHostile(oBallista, oPC)) && (GetLocalInt(oBallista, "BallistaThrow") == 0))
			{
				eDamage = EffectDamage(d6(6), DAMAGE_TYPE_BLUDGEONING);

				SetLocalInt(oBallista, "BallistaThrow", 1); // Prevent the damage from being applied more than once by this maneuver.
				AssignCommand(oBallista, DelayCommand(0.5f, DeleteLocalInt(oBallista, "BallistaThrow")));
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oBallista);
			}

			oBallista = GetNextObjectInShape(SHAPE_SPHERE, fGirth, lLine);
		}
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 98);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "SettingSunStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "SettingSunStrike", 0));

	int nTouch = TouchAttackMelee(oTarget);

	PlayVoiceChat(VOICE_CHAT_PAIN1, oPC);
	WrapperPlayCustomAnimation(oPC, "Throw", 0);
	ExpendManeuver(98, "STR");

	if (nTouch > 0)
	{
		int nMyStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
		int nFoeStr = GetAbilityModifier(ABILITY_STRENGTH, oTarget);
		int nMyDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
		int nFoeDex = GetAbilityModifier(ABILITY_DEXTERITY, oTarget);
		int nBonus, nFoeBonus, nAbility, nFoeAbility;

		if (nMyStr >= nMyDex)
		{
			nAbility = nMyStr + 4;
		}
		else nAbility = nMyDex + 4;

		if (nFoeStr >= nFoeDex)
		{
			nFoeAbility = nFoeStr;
		}
		else nFoeAbility = nFoeDex;

		int nMySize = GetCreatureSize(oPC);
		int nFoeSize = GetCreatureSize(oTarget);

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
		int nMyRoll = nAbility + nBonus + nMyd20;
		int nFoeRoll = nFoeAbility + nFoeBonus + nFoed20;

		SendMessageToPC(oPC, "<color=chocolate>Trip: " + GetName(oPC) + " : (" + IntToString(nAbility) + " + " + IntToString(nBonus) + " + " + IntToString(nMyd20) + " = " + IntToString(nMyRoll) + ") vs. " + GetName(oTarget) + " : (" + IntToString(nFoeAbility) + " + " + IntToString(nFoeBonus) + " + " + IntToString(nFoed20) + " = " + IntToString(nFoeRoll) + ")</color>");

		if (nMyRoll >= nFoeRoll)
		{
			float fSpace = GetDistanceBetween(oPC, oTarget);
			effect eDamage = EffectDamage(d6(6), DAMAGE_TYPE_BLUDGEONING);
			effect eKnockdown = EffectKnockdown();

			ThrowTarget(oTarget, fSpace + FeetToMeters(60.0f), TRUE); //ThrowTarget automatically adjusts distance if we can't go the full 60 feet.
			SetLocalInt(oTarget, "BallistaThrow", 1); // Prevent the damage from being applied more than once by this maneuver.
			AssignCommand(oTarget, DelayCommand(1.01f, DeleteLocalInt(oTarget, "BallistaThrow")));
			DelayCommand(0.5f, BallistaThrow(oTarget, fSpace));
			DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, 3.0f));
			DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));

			if (GetLocalInt(oToB, "FallingSun") == 1) //Falling Sun Feat Support
			{
				effect eFallingSun = FallingSunAttack(oTarget);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFallingSun, oTarget, 6.0f);
			}
		}
	}
}