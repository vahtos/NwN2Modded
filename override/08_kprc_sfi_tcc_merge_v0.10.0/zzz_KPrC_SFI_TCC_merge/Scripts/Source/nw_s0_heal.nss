//::///////////////////////////////////////////////
//:: Heal
//:: [NW_S0_Heal.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 12, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: Aug 1, 2001
//:: Update Pass By: Brock H. - OEI - 08/17/05
/*
    5.2.6.1.3	Heal
    This spell works differently now. Positive energy cures 10 damage per caster 
    level (maximum 150). It also removes the following conditions: ability damage, 
    blinded, confuse, dazed, dazzled, deafened, diseased, exhausted, fatigued, feebleminded, 
    insanity, nausea, poison, and stunned. [Note: some of these conditions may not exist 
    in NWN. If the condition doesn’t exist, just ignore during implementation.]

    Reeron modified on 3-17-07
    Now removes effects, as per PnP. Heal versus undead now 
    uses a touch attack like it should. Won't remove the effects of Iron Body, Stone 
    Body, Enlarge Person, or Duergar Enlarge Racial Ability.

    Reeron modified on 6-25-09
    Updated for patch 1.22.5588
    Won't remove "Reduce" spell effects.
    Removes Solipsism effect.

    Reeron modified on 8-20-11
    Can't reduce undead's hitpoints to less than one, per PnP.
    Now removes Insanity, Fatigue, and Exhaustion as per PnP.

*/


#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 
#include "nwn2_inc_hlhrm"

void main()
{
	//SpawnScriptDebugger();

    if (!X2PreSpellCastCode())
    {
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }


	//Declare major variables
	object oCaster 	= OBJECT_SELF;
	object oTarget 	= GetSpellTargetObject();

    //Check to see if the target is an undead
    if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
    	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)) //if the target is undead and hostile, or hardcore rules are on
    	{
			HarmTarget( oTarget, oCaster, SPELL_HEAL );
        }
		else //undead, even friendly ones, will never be healed by this spell
		{
			return;
		}
    }
    else
    {
		HealTarget( oTarget, oCaster, SPELL_HEAL );
		
		effect eBad = GetFirstEffect(oTarget);
		while(GetIsEffectValid(eBad))
		{
        if ((GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
            GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
            GetEffectType(eBad) == EFFECT_TYPE_DISEASE ||
            GetEffectType(eBad) == EFFECT_TYPE_POISON ||
            GetEffectType(eBad) == EFFECT_TYPE_DAZED ||
            GetEffectType(eBad) == EFFECT_TYPE_CONFUSED ||
            GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
            GetEffectType(eBad) == EFFECT_TYPE_INSANE ||
            GetEffectType(eBad) == EFFECT_TYPE_STUNNED) &&
            GetEffectSpellId(eBad) != SPELL_ENLARGE_PERSON &&
            GetEffectSpellId(eBad) != SPELL_STONE_BODY &&
            GetEffectSpellId(eBad) != SPELL_IRON_BODY &&
            GetEffectSpellId(eBad) != SPELL_REDUCE_PERSON &&
            GetEffectSpellId(eBad) != SPELL_REDUCE_ANIMAL &&
            GetEffectSpellId(eBad) != SPELL_REDUCE_PERSON_GREATER &&
            GetEffectSpellId(eBad) != SPELL_REDUCE_PERSON_MASS &&
            GetEffectSpellId(eBad) != 803 ||
            GetEffectSpellId(eBad) == 1129) //Solipsism
			{
			RemoveEffect(oTarget, eBad);
			eBad = GetFirstEffect(oTarget);
			}
			else
			eBad = GetNextEffect(oTarget);
    	}
	    if ( GetHasSpellEffect( 55, oTarget ))
          	{RemoveEffectsFromSpell( oTarget, 55);}
        if ( GetHasSpellEffect( -998, oTarget ))// Fatigue
            {RemoveEffectsFromSpell( oTarget, -998);}
        if ( GetHasSpellEffect( -999, oTarget ))// Exhaustion
            {RemoveEffectsFromSpell( oTarget, -999);}
		
    }
}