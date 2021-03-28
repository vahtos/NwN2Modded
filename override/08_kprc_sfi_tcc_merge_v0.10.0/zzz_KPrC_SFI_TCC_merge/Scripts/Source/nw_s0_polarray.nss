//::///////////////////////////////////////////////
//:: Polar Ray
//:: [nw_s0_polarray.nss]
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
    If the caster succeeds at a ranged touch attack
    the target takes 1d6 cold damage/caster level
    (max 25d6).
    
    Reeron modified 3-13-07.
    Now correctly calculates extra damage on critical hit.
    Respects immunity to critical hits.
    
    Reeron modified on 5-13-07
    Added sneak attack damage.
    
    Reeron modified on 10-21-07
    Added check for Weapon finesse feat on all melee touch 
    attack spells. Added check for point blank shot feat on 
    all ranged touch attack spells.

    Reeron modified on 10-21-07
    Now does extra damage if you have the (custom) feat 
    Ranged Spell Specialization.

    Reeron modified on 5-4-09
    Updated for patch 1.22.5588

*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 06/06/2006
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 
#include "Reeronspellinclude"
void main()
{
    if (!X2PreSpellCastCode())
    {	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }


    //Declare major variables
    object oTarget	 	= GetSpellTargetObject();
	int    nCasterLevel = GetCasterLevel(OBJECT_SELF);
	if (nCasterLevel > 25)	// Cap caster level
		nCasterLevel = 25;
	else if (nCasterLevel <= 0)
		nCasterLevel = 1;
    int nmodifyattack;
    int nSpecDamage =0;
    //nmodifyattack=FINESSE(oTarget);
    nmodifyattack=POINTBLANK(oTarget);
    int touch=TouchAttackRanged(oTarget,TRUE,nmodifyattack);

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_POLAR_RAY));

		if (touch != TOUCH_ATTACK_RESULT_MISS)
		{	//Make SR Check
	        if(!MyResistSpell(OBJECT_SELF, oTarget))
	        {
	            if(GetHasFeat(2991,OBJECT_SELF))
                    {
                    nSpecDamage=SPECIALIZATION(nCasterLevel);
                    //FloatingTextStringOnCreature("*RangedTouchAttack modified by Ranged Spell Specialization!* Value of "+IntToString(nSpecDamage), OBJECT_SELF);
                    }
                //Enter Metamagic conditions
	 			int nDam = d6(nCasterLevel)+nSpecDamage;
				int nDam2 = d6(nCasterLevel)+nSpecDamage;
	    		int nMetaMagic = GetMetaMagicFeat();
	            if (nMetaMagic == METAMAGIC_MAXIMIZE)
	            {
	                nDam = 6 * nCasterLevel +nSpecDamage;//Damage is at max
					nDam2 = 6 * nCasterLevel +nSpecDamage;//Damage is at max
	            }
	            else if (nMetaMagic == METAMAGIC_EMPOWER)
	            {
	                nDam = nDam + nDam/2; //Damage/Healing is +50%
					nDam2 = nDam2 + nDam2/2; //Damage/Healing is +50%
	            }
				if (touch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT, OBJECT_SELF))          { nDam = nDam + nDam2; }
		
	            //Set damage effect
                nDam=SNEAK(oTarget, nDam);
	            effect eDam = EffectDamage(nDam, DAMAGE_TYPE_COLD);
	   	 		effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ICE);
	
	            //Apply the VFX impact and damage effect
	            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
	        }
		}
    }
	
    effect eRay = EffectBeam(VFX_BEAM_ICE, OBJECT_SELF, BODY_NODE_HAND);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
}