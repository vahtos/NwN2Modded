//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 7/11/2009							//
//	Title: st_mighty_throw					//
//	Description: Gain a +4 on your attack	//
//	roll for this strike, but all enemies	//
//	except the target gain +4 to attack vs	//
//	you.									//
//////////////////////////////////////////////

#include "bot9s_inc_feats"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"
#include "tob_x0_i0_position"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 107);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "SettingSunStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "SettingSunStrike", 0));

	int nTouch = TouchAttackMelee(oTarget);

	PlayVoiceChat(VOICE_CHAT_PAIN1, oPC);
	WrapperPlayCustomAnimation(oPC, "Throw", 0);
	ExpendManeuver(107, "STR");

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
			location lLand = GetAheadLocation(oPC, fSpace + FeetToMeters(10.0f));
			effect eKnockdown = EffectKnockdown();

			if (GetIsLocationValid(lLand))
			{
				ThrowTarget(oTarget, fSpace + FeetToMeters(10.0f));
				DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, 3.0f));
			}
			else ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, 3.0f);

			if (GetLocalInt(oToB, "FallingSun") == 1) //Falling Sun Feat Support
			{
				effect eFallingSun = FallingSunAttack(oTarget);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFallingSun, oTarget, 6.0f);
			}
		}
	}
}