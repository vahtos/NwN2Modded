//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 10/6/2009									//
//	Title: st_snoose								//
//	Description: As part of this maneuver, you form //
//  a noose of shadow that wraps around your target //
//  and strangles him. This maneuver works only     //
//  against a flatfooted target. As part of this    //
//  maneuver, you make a ranged touch attack against//
//  a flat-footed creature within range. If it hits,//
//  your opponent takes 8d6 points of damage. In    //
//  addition, he must make a successful Fortitude   //
//  save (DC 16 + your Wis modifier) or be stunned  //
//  for 1 round. A successful save negates the stun,//
//  but not the extra damage. This strike has no    //
//  effect against nonliving creatures, such as     //
//  constructs and undead.							//
//////////////////////////////////////////////////////

#include "tob_i0_spells"
#include "bot9s_armor"
#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 136);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "ShadowHandStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "ShadowHandStrike", 0));

	int nRace = GetRacialType(oTarget);

	if (nRace != RACIAL_TYPE_CONSTRUCT && nRace != RACIAL_TYPE_ELEMENTAL && nRace != RACIAL_TYPE_UNDEAD)
	{
		if (!GetIsInCombat(oTarget) || (GetLocalInt(oTarget, "OverrideFlatFootedAC") == 1))
		{
			int nHit = TouchAttackRanged(oTarget);

			ExpendManeuver(136, "STR");

			if (nHit > 0)
			{
				int nWisdom = GetAbilityModifier(ABILITY_WISDOM, oPC);
				int nDC = GetManeuverDC(nWisdom, 0, 16);
				int nFort = MySavingThrow(SAVING_THROW_FORT, oTarget, nDC);
	
				if (nFort == 0)
				{
					int nDamage;
	
					if (nHit == 1)
					{
						nDamage = d6(8);
					}
					else nDamage = d6(16); // Critical Hit.
		
					effect eDamage = EffectDamage(nDamage);
					float fDelay = GetSpellEffectDelay(GetLocation(oPC), oTarget);
		
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));

					effect eNoose = EffectStunned();
					eNoose = SupernaturalEffect(eNoose);
	
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eNoose, oTarget, 6.0f);
				}
				else if (GetHasFeat(6818, oTarget)) //Mettle
				{
					// Do nothing.
				}
				else
				{
					int nDamage;
	
					if (nHit == 1)
					{
						nDamage = d6(8);
					}
					else nDamage = d6(16); // Critical Hit.
		
					effect eDamage = EffectDamage(nDamage);
					float fDelay = GetSpellEffectDelay(GetLocation(oPC), oTarget);
		
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
				}
			}
		}
		else SendMessageToPC(oPC, "<color=red>Shadow Noose can only be initiated against a flat-footed target.</color>");
	}
	else SendMessageToPC(oPC, "<color=red>Shadow Noose is ineffective aginst unliving creatures!</color>");

	effect eAttack = EffectVisualEffect(VFX_TOB_SHCHOKE);

	WatchOpponent(oTarget, oPC);
	WrapperPlayCustomAnimation(oPC, "Throw", 0);
	DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eAttack, oTarget));
}