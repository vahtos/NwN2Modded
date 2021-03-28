//////////////////////////////////////////////////////////////////
//	Author: Drammel												//
//	Date: 8/31/2009												//
//	Title: st_devastating										//
//	Description: This maneuver functions like mighty throw, 	//
//  except as noted here.  To set up a devastating throw, you   //
//  must move at least 15 feet.  As part of this maneuver, you  //
//  must succeed on a melee touch attack against your foe. You  //
//  can then make a trip attempt against your enemy. You gain a //
//  +4 bonus on the ability check. If you succeed in tripping 	//
//  your foe, you throw him up to 10 feet away from you. The 	//
//  target falls prone in the destination space and takes 2d6 	//
//  points of damage. You choose where he lands. For every 5 	//
//  points by which you win the opposed check, you gain an 		//
//  additional 5 feet of throw distance. For example, if you win//
//  by 10, you place your foe in a space within 20 feet in front//
//  of you. You must place the target in an empty space. If you //
//  lack the distance to throw your target into a clear space,  //
//  he falls prone in his current space.						//
//////////////////////////////////////////////////////////////////

#include "bot9s_inc_feats"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"
#include "tob_x0_i0_position"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 101);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "SettingSunStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "SettingSunStrike", 0));

	int nTouch = TouchAttackMelee(oTarget);

	PlayVoiceChat(VOICE_CHAT_PAIN3, oPC);
	WrapperPlayCustomAnimation(oPC, "Throw", 0);
	ExpendManeuver(101, "STR");

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
			float fDiff = IntToFloat(nMyRoll - nFoeRoll);
			float fDistMod;

			if (fDiff >= 5.0f) // Far simpler than doing it in increments of five, and better suited to the NWN2 engine.
			{
				fDistMod = fDiff;
			}
			else fDistMod = 0.0f;

			float fSpace = GetDistanceBetween(oPC, oTarget);
			location lLand = GetAheadLocation(oPC, fSpace + fDistMod + FeetToMeters(10.0f));
			effect eKnockdown = EffectKnockdown();
			effect eDamage = EffectDamage(d6(2), DAMAGE_TYPE_BLUDGEONING); // I don't think it's a far cry to assume this is bludgeoning damage.

			if (GetIsLocationValid(lLand))
			{
				ThrowTarget(oTarget, fSpace + fDistMod + FeetToMeters(10.0f));
				DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, 3.0f));
				DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
			}
			else
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, 3.0f);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
			}

			if (GetLocalInt(oToB, "FallingSun") == 1) //Falling Sun Feat Support
			{
				effect eFallingSun = FallingSunAttack(oTarget);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFallingSun, oTarget, 6.0f);
			}
		}
	}
}