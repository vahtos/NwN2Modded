//////////////////////////////////////////////////////////////
//	Author: Drammel											//
//	Date: May Day 2009										//
//	Name: clf_bmastery									    //
//	Description: Grants a bonus to the PC's attacks of 		//
//	opportunity based on his int bonus.						//
//////////////////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_feats"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void CheckNoAoO()
{
	object oPC = OBJECT_SELF;
	effect eNoAoO;
	int nAoO;

	eNoAoO = GetFirstEffect(oPC);
	nAoO = TRUE;
	
	while (GetIsEffectValid(eNoAoO))
	{
		if (GetEffectType(eNoAoO) == EFFECT_TYPE_INVISIBILITY)
		{
			nAoO = FALSE;
			break;
		}
		else if (GetEffectType(eNoAoO) == EFFECT_TYPE_STUNNED)
		{
			nAoO = FALSE;
			break;
		}
		else if (GetEffectType(eNoAoO) == EFFECT_TYPE_SLEEP)
		{
			nAoO = FALSE;
			break;
		}
		else if (GetEffectType(eNoAoO) == EFFECT_TYPE_PARALYZE)
		{
			nAoO = FALSE;
			break;
		}
		else if (GetEffectType(eNoAoO) == EFFECT_TYPE_ETHEREAL)
		{
			nAoO = FALSE;
			break;
		}
		else if (GetEffectType(eNoAoO) == EFFECT_TYPE_PETRIFY)
		{
			nAoO = FALSE;
			break;
		}
		else if (GetEffectType(eNoAoO) == EFFECT_TYPE_CUTSCENE_PARALYZE)
		{
			nAoO = FALSE;
			break;
		}
		else if (GetEffectType(eNoAoO) == EFFECT_TYPE_SANCTUARY)
		{
			nAoO = FALSE;
			break;
		}
		else if (GetEffectType(eNoAoO) == EFFECT_TYPE_TIMESTOP)
		{
			nAoO = FALSE;
			break;
		}
		
		eNoAoO = GetNextEffect(oPC);
	}

	if (GetCurrentHitPoints(oPC) < 1)
	{
		nAoO = FALSE;
	}
	SetLocalInt(oPC, "BattleMasteryAoOCheck", nAoO);
}

void BattleMastery()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6529);

	AssignCommand(oPC, CheckNoAoO());

	int nAoO = GetLocalInt(oPC, "BattleMasteryAoOCheck");
	int nMode = GetActionMode(oPC, ACTION_MODE_STEALTH);
	int nUsed = GetLocalInt(oToB, "BMasteryAoO");

	if ((nAoO == TRUE) && (nMode == FALSE) && GetIsInCombat(oPC) && (nUsed == 0))
	{
		int nIntelligence = GetAbilityModifier(ABILITY_INTELLIGENCE);
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 1.0f);
		DelayCommand(1.0f, BattleMastery());

		if ((nIntelligence < 1) || (GetWeaponRanged(oWeapon)))// Don't run any of this if there's no point.
		{
			return;
		}

		int nDamageType = GetWeaponDamageType(oWeapon);
		float fRange = GetMeleeRange(oPC);
		location lPC = GetLocation(oPC);

		object oFoe;

		oFoe = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);

		while (GetIsObjectValid(oFoe))
		{
			if ((GetIsReactionTypeHostile(oFoe, oPC)) && (GetObjectSeen(oFoe, oPC)))
			{
				int nTumble;

				if (GetSkillRank(SKILL_TUMBLE, oFoe, TRUE) < 1)
				{
					nTumble = 0;
				}
				else nTumble = GetSkillRank(SKILL_TUMBLE, oFoe) + d20(1);

				object oFoeWeapon = GetLastWeaponUsed(oFoe);

				if ((nTumble < 15) && (GetActionMode(oFoe, ACTION_MOVETOPOINT) == TRUE))
				{
					effect eAttack = EffectAttackIncrease(nIntelligence);
					effect eDamage = EffectDamageIncrease(nIntelligence, nDamageType);
					effect eLink = EffectLinkEffects(eAttack, eDamage);
					eLink = SupernaturalEffect(eLink);

					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 1.0f);
					SetLocalInt(oToB, "BMasteryAoO", 1);
					DelayCommand(6.0f, SetLocalInt(oToB, "BMasteryAoO", 0));
					break; //Only one attack of opportunity per round.
				}
				else if ((GetWeaponRanged(oFoeWeapon)) && (GetCurrentAction(oFoe) == ACTION_ATTACKOBJECT))
				{
					effect eAttack = EffectAttackIncrease(nIntelligence);
					effect eDamage = EffectDamageIncrease(nIntelligence, nDamageType);
					effect eLink = EffectLinkEffects(eAttack, eDamage);
					eLink = SupernaturalEffect(eLink);

					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 1.0f);
					SetLocalInt(oToB, "BMasteryAoO", 1);
					DelayCommand(6.0f, SetLocalInt(oToB, "BMasteryAoO", 0));
					break; //Only one attack of opportunity per round.
				}
				else if (GetCurrentAction(oFoe) == ACTION_CASTSPELL)
				{
					effect eAttack = EffectAttackIncrease(nIntelligence);
					effect eDamage = EffectDamageIncrease(nIntelligence, nDamageType);
					effect eLink = EffectLinkEffects(eAttack, eDamage);
					eLink = SupernaturalEffect(eLink);

					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 1.0f);
					SetLocalInt(oToB, "BMasteryAoO", 1);
					DelayCommand(6.0f, SetLocalInt(oToB, "BMasteryAoO", 0));
					break; //Only one attack of opportunity per round.
				}
			}
			oFoe = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);
		}
	}
	else
	{
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 1.0f);
		DelayCommand(1.0f, BattleMastery());
	}
}

void CheckLoopEffect()
{
	if(!CheckRecursive(6529))
	{
		BattleMastery(); //Only runs if the effect is no longer on the player.
	}
}

void main()
{
	DelayCommand(6.0f, CheckLoopEffect()); // Needs to be delayed because when the feat fires after resting the engine doesn't detect effects immeadiately.
}