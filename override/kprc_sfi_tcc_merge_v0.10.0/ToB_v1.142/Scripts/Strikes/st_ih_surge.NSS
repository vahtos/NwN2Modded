//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 8/27/2009								//
//	Title: st_ih_surge							//
//	Description: When you use this maneuver you //
//  end a, spell, effect, or other 				//
//  condition currently affecting you and with a//
//  duration of 1 or more rounds. That effect 	//
//  ends immediately. You also surge with 		//
//  confidence and vengeance against your 		//
//  enemies, gaining a +2 morale bonus on attack//
//  rolls until the end of your next turn.		//
//////////////////////////////////////////////////

#include "tob_i0_spells"
#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	effect eIHSurge, eTest;
	int nTest;

	eTest = GetFirstEffect(oPC);

	while (GetIsEffectValid(eTest))
	{
		nTest = GetEffectType(eTest);

		if (nTest == EFFECT_TYPE_NEGATIVELEVEL)
		{
			eIHSurge = eTest;
			break;
		}
		else if (nTest == EFFECT_TYPE_FRIGHTENED)
		{
			eIHSurge = eTest;
			break;
		}
		else if (nTest == EFFECT_TYPE_DISEASE)
		{
			eIHSurge = eTest;
			break;
		}
		else if (nTest == EFFECT_TYPE_POISON)
		{
			eIHSurge = eTest;
			break;
		}
		else if (nTest == EFFECT_TYPE_CURSE)
		{
			eIHSurge = eTest;
			break;
		}
		else if (nTest == EFFECT_TYPE_DAMAGEOVERTIME)
		{
			eIHSurge = eTest;
			break;
		}
		else if (nTest == EFFECT_TYPE_SILENCE)
		{
			eIHSurge = eTest;
			break;
		}
		else if (nTest == EFFECT_TYPE_BLINDNESS)
		{
			eIHSurge = eTest;
			break;
		}
		else if (nTest == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE)
		{
			eIHSurge = eTest;
			break;
		}
		else if (nTest == EFFECT_TYPE_SAVING_THROW_DECREASE)
		{
			eIHSurge = eTest;
			break;
		}
		else if (nTest == EFFECT_TYPE_SPELL_FAILURE)
		{
			eIHSurge = eTest;
			break;
		}
		else if (nTest == EFFECT_TYPE_ARCANE_SPELL_FAILURE)
		{
			eIHSurge = eTest;
			break;
		}
		else if (nTest == EFFECT_TYPE_ASSAYRESISTANCE)
		{
			eIHSurge = eTest;
			break;
		}
		else if (nTest == EFFECT_TYPE_CONCEALMENT_NEGATED)
		{
			eIHSurge = eTest;
			break;
		}
		else if (nTest == EFFECT_TYPE_SLOW)
		{
			eIHSurge = eTest;
			break;
		}
		else if (nTest == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
		{
			eIHSurge = eTest;
			break;
		}
		else if (nTest == EFFECT_TYPE_DAMAGE_REDUCTION_NEGATED)
		{
			eIHSurge = eTest;
			break;
		}
		else if (nTest == EFFECT_TYPE_AC_DECREASE)
		{
			eIHSurge = eTest;
			break;
		}
		else if (nTest == EFFECT_TYPE_ATTACK_DECREASE)
		{
			eIHSurge = eTest;
			break;
		}
		else if (nTest == EFFECT_TYPE_DAMAGE_DECREASE)
		{
			eIHSurge = eTest;
			break;
		}
		else if (nTest == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE)
		{
			eIHSurge = eTest;
			break;
		}
		else if (nTest == EFFECT_TYPE_SKILL_DECREASE)
		{
			eIHSurge = eTest;
			break;
		}
		else if (nTest == EFFECT_TYPE_POLYMORPH)
		{
			eIHSurge = eTest;
			break;
		}
		else if (nTest == EFFECT_TYPE_DEAF)
		{
			eIHSurge = eTest;
			break;
		}
		else if (nTest == EFFECT_TYPE_TURN_RESISTANCE_DECREASE)
		{
			eIHSurge = eTest;
			break;
		}

		eTest = GetNextEffect(oPC);
	}

	RemoveEffect(oPC, eIHSurge);

	effect eAttack = EffectAttackIncrease(2);
	effect eSurge = EffectVisualEffect(VFX_TOB_IH_SURGE);
	eAttack = ExtraordinaryEffect(eAttack);

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAttack, oPC, 6.0f);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSurge, oPC, 2.0f);
	PlayVoiceChat(VOICE_CHAT_PAIN3, oPC);
	WrapperPlayCustomAnimation(oPC, "*rage", 0);
	ExpendManeuver(85, "STR");
}