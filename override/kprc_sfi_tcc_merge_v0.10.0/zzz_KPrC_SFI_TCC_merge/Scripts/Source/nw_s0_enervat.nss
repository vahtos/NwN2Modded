//::///////////////////////////////////////////////
//:: Enervation
//:: NW_S0_Enervat.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target Loses 1d4 levels for 1 hour per caster
    level
	
    Reeron modified 3-13-07
    Now correctly calculates extra damage on critical hit.
    Respects immunity to critical hits.
    
    Reeron modified on 5-13-07
    Added sneak attack damage.
    
    Reeron modified on 12-13-07
    Added missing beam effect. This effect gets shown 
    on a miss or a hit.
    
    Reeron modified on 10-6-08
    Duration now capped at 15 hours max (matches PnP).

    Reeron modified on 1-5-09
    Made the level-drain effect supernatural so Dispel Magic can't remove it. 
    Energy Drain is done this way already.

    Reeron modified on 6-15-09
    Updated for patch 1.22.5588	

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: AFW-OEI 06/06/2006:
//::	Require a ranged touch attack to hit.
//::	Remove saving throw.

#include "x0_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "Reeronspellinclude"
void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
    effect eBeam = EffectBeam( VFX_BEAM_NECROMANCY, OBJECT_SELF, BODY_NODE_HAND );
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = GetMetaMagicFeat();
    int nDrain = d4();
    int nDrain2 = d4();
    int nTouch = TouchAttackRanged(oTarget);
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nDamage;
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
    	nDrain = 4;//Damage is at max
        nDrain2 = 4;//Damage is at max
    }
    else if (nMetaMagic == METAMAGIC_EMPOWER)
    {
    	nDrain = nDrain + (nDrain/2); //Damage/Healing is +50%
        nDrain2 = nDrain2 + (nDrain2/2); //Damage/Healing is +50%
    }
    else if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT, OBJECT_SELF))          {nDrain = nDrain + nDrain2; }

    effect eDrain = EffectNegativeLevel(nDrain);
    eDrain = SupernaturalEffect(eDrain);
    nDamage=SNEAK(oTarget, nDamage);

    if (nDuration > 15) { nDuration = 15;} // PnP maximum duration.

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ENERVATION));
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.7 );
        if (nTouch != TOUCH_ATTACK_RESULT_MISS)
        {
            //Resist magic check
            if(!MyResistSpell(OBJECT_SELF, oTarget))
            {
                //if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NEGATIVE))
                {
                    //Apply the VFX impact and effects
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDrain, oTarget, HoursToSeconds(nDuration));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE), oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
        }
    }
}