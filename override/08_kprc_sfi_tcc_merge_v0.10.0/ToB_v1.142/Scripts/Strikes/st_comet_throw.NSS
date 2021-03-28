//////////////////////////////////////////////////////////////////
//	Author: Drammel												//
//	Date: 9/10/2009												//
//	Title: st_comet_throw										//
//	Description: This maneuver functions like Mighty Throw,     //
//  except as noted here.  As part of this maneuver, you must   //
//  succeed on a melee touch attack against your foe. You can   //
//  then make a trip attempt against your enemy. You gain a +4  //
//  bonus on the ability check. If you succeed in tripping your //
//  foe, you throw him up to 10 feet in front of you.  The      //
//  target falls prone in that space and takes 4d6 points of    //
//  damage. For every point by which you win the opposed check, //
//  you gain an additional foot of throw range. For example, if //
//  you win by 10, you place your foe 20 feet in front of you.  //
//  You can throw your opponent into a space occupied by a      //
//  second foe. In this case, the opponent in the target square //
//  also takes 4d6 points of damage and is knocked prone. A     //
//  Reflex save (DC 14 + your Str modifier) halves this damage  //
//  and allows the second target to remain standing. The thrown //
//  creature then falls prone in a clear space of your choice   //
//  adjacent to the second target.				        		//
//////////////////////////////////////////////////////////////////

#include "tob_i0_spells"
#include "bot9s_inc_feats"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 100);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "SettingSunStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "SettingSunStrike", 0));

	int nTouch = TouchAttackMelee(oTarget);

	PlayVoiceChat(VOICE_CHAT_PAIN1, oPC);
	WrapperPlayCustomAnimation(oPC, "Throw", 0);
	ExpendManeuver(100, "STR");

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
			effect eDamage = EffectDamage(d6(4), DAMAGE_TYPE_BLUDGEONING); // I don't think it's a far cry to assume this is bludgeoning damage.

			if (GetIsLocationValid(lLand))
			{
				float fGirth = GetMeleeRange(oTarget);
				object oComet, oCheck;

				oCheck = GetFirstObjectInShape(SHAPE_SPHERE, fGirth, lLand);

				while (GetIsObjectValid(oCheck))
				{
					if ((oCheck != oTarget) && (GetIsStandardHostileTarget(oCheck, oPC)))
					{
						oComet = oCheck;
						break;
					}
					else oComet = OBJECT_INVALID;

					oCheck = GetNextObjectInShape(SHAPE_SPHERE, fGirth, lLand);
				}

				ThrowTarget(oTarget, fSpace + fDistMod + FeetToMeters(10.0f));
				DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, 3.0f));
				DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));

				if (GetIsObjectValid(oComet))
				{
					location lComet = GetLocation(oComet);
					float fCheck = GetDistanceBetweenLocations(lLand, lComet);

					if (fCheck <= fGirth)
					{
						int nDC = GetManeuverDC(nMyStr, 0, 14);
						int nReflex = MySavingThrow(SAVING_THROW_REFLEX, oComet, nDC);

						if (nReflex > 0)
						{
							int nComet;

							if (GetHasFeat(FEAT_EVASION, oComet) || GetHasFeat(FEAT_IMPROVED_EVASION, oComet))
							{
								nComet = 0;
							}
							else nComet = d6(2);

							effect eComet = EffectDamage(nComet, DAMAGE_TYPE_BLUDGEONING);

							DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eComet, oComet));
						}
						else
						{
							int nComet;

							if (GetHasFeat(FEAT_IMPROVED_EVASION, oComet))
							{
								nComet = d6(2);
							}
							else nComet = d6(4);

							effect eComet = EffectDamage(nComet, DAMAGE_TYPE_BLUDGEONING);

							DelayCommand(1.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oComet, 3.0f));
							DelayCommand(1.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eComet, oComet));
						}
					}
				}
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