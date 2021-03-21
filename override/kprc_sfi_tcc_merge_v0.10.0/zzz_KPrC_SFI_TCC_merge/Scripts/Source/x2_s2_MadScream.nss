/* 

    Reeron created this spell on 2-18-08

    Enchantment (Compulsion) [Mind-Affecting]
    Level: Sor/Wiz 8, Madness 8
    Components: V
    Casting Time: One action
    Range: Touch
    Target: Living creature touched
    Duration: 1d4+1 rounds
    Saving Throw: None
    Spell Resistance: Yes
    The subject cannot keep him or herself from behaving as though completely mad. 
    This spell makes it impossible for the victim to do anything other than race 
    about caterwauling. The effect worsens the Armor Class of the creature by 4, 
    makes Reflex saving throws impossible except on a roll of 20, and makes it 
    impossible to use a shield.

    Reeron modified on 6-28-09
    Updated for patch 1.22.5588

*/

#include "NW_I0_SPELLS"
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

    object oTarget = GetSpellTargetObject();
    int nDuration = d4(1) + 1;
    int i = 0;
    int nmodifyattack;
    nmodifyattack=FINESSE(oTarget);
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_CONFUSION );


    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_ENFEEBLEMENT));//Maddening Scream
 
        // Ray spells require a ranged touch attack
        if (TouchAttackMelee(oTarget,TRUE,nmodifyattack) != TOUCH_ATTACK_RESULT_MISS) 
        {
            
            if(GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT && GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
                {//Make SR check
                if (!MyResistSpell(OBJECT_SELF, oTarget))
                    {
                    
                    int nMetaMagic = GetMetaMagicFeat();
                    if (nMetaMagic == METAMAGIC_MAXIMIZE)
                    {
                        nDuration = 5;
                    }
                    if (nMetaMagic == METAMAGIC_EXTEND)
                    {
                        nDuration = nDuration * 2;
                    }
                    int nDuration2 = nDuration;

                    effect eAC=EffectACDecrease(4, AC_DODGE_BONUS);
                    effect eSave=EffectSavingThrowDecrease(SAVING_THROW_REFLEX, 50);
                    effect eMove=EffectMovementSpeedIncrease(99);
                    effect eDaze=EffectDazed();
                    effect eLink = EffectLinkEffects(eAC, eSave);
                    eLink = EffectLinkEffects(eMove, eLink);
                    eLink = EffectLinkEffects(eDaze, eLink);
                    eLink = EffectLinkEffects(eVis, eLink);
                    if (!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF))
                        {
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                        ExecuteScript("n2_s0_RanWalk", oTarget);
                        }
                    else {FloatingTextStringOnCreature("Target is immune to Mind-Affecting Spells!", GetFirstPC(FALSE));}
                    }
                }
            else
                {
                FloatingTextStringOnCreature("Target must be a living creature to have any effect!", GetFirstPC(FALSE));
                }
        }
	
 	    effect eRay = EffectBeam(VFX_BEAM_ENCHANTMENT, OBJECT_SELF, BODY_NODE_HAND);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.0);
    }
}