//::///////////////////////////////////////////////
//:: [Charm Person or Animal]
//:: [NW_S0_DomAni.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is charmed for 1 round
//:: per caster level.
//:: 
//:: Reeron modified on 12-27-07
//:: Now uses correct PnP duration of 1 hour per level.
//:: Target gets +5 to save attempt if in combat (as per PnP).
//:: If Target fails an opposed Charisma check, it is Dominated instead of Charmed.
//:: This simulates the caster being able to convince the Target to do something 
//:: it wouldn’t ordinarily do. (Retries are not allowed.)
//:: 
//:: Reeron modified on 12-30-07
//:: Reworked script so charm isn't permanent anymore.
//:: Now actually increases saving throw of target creature, rather than lowering Save DC.
//:: Have to cap at 41 hours max or the Charm effect is permanent (except with Dispel Magic).
//::
//:: Reeron modified on 6-15-09
//:: Updated for patch 1.22.5588
//::
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 29, 2001
//:://////////////////////////////////////////////

#include "x0_I0_SPELLS"    
#include "x2_inc_spellhook" 

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
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_CHARM_MONSTER);
    effect eCharm2;
    effect eCharm = EffectCharmed();
    effect eDispel = EffectOnDispel(0.0f, RemoveEffectsFromSpell(oTarget, SPELL_CHARM_PERSON_OR_ANIMAL));
    int nCharisma1 = GetAbilityModifier(5, oTarget); // Enemy's Charisma modifier.
    int nCharisma2 = GetAbilityModifier(5, OBJECT_SELF); // Caster's Charisma modifier.
    int nTargetroll = d20(1) + nCharisma1;
    int nCasterroll = d20(1) + nCharisma2;
    int nDom = 0;
    if (nCasterroll >= nTargetroll)
        {
        eCharm2 = EffectDominated();
        eCharm = EffectLinkEffects(eCharm, eDispel);
        eCharm = EffectLinkEffects(eCharm, eCharm2);
        eCharm = SupernaturalEffect(eCharm);
        nDom = 1;
        }
    
    eCharm = GetScaledEffect(eCharm, oTarget);
    //int nSave = GetSpellSaveDC();
    
    //Link effects
    effect eLink;
    if(nDom == 1) {eLink = EffectLinkEffects(eVis, eCharm2);}
    else {eLink = EffectLinkEffects(eVis, eCharm);}

    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    //int nDuration = 2  + nCasterLevel/3;
    int nDuration = nCasterLevel;
    nDuration = GetScaledDuration(nDuration, oTarget);
    int nRacial = GetRacialType(oTarget);
    //Meta magic duration check
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2;
    }
    if (nDuration > 41) {nDuration = 41;} // Anything larger and the Charm effect becomes permanent unless Dispel Magic is used.
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
        //Fire spell cast at event to fire on the target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CHARM_PERSON_OR_ANIMAL, FALSE));
        //Make SR Check
        if (!MyResistSpell(OBJECT_SELF, oTarget))
        {
            //Make sure the racial type of the target is applicable
            if  ((nRacial == RACIAL_TYPE_DWARF) ||
                (nRacial == RACIAL_TYPE_ANIMAL) ||
                (nRacial == RACIAL_TYPE_ELF) ||
                (nRacial == RACIAL_TYPE_GNOME) ||
                (nRacial == RACIAL_TYPE_HUMANOID_GOBLINOID) ||
                (nRacial == RACIAL_TYPE_HALFLING) ||
                (nRacial == RACIAL_TYPE_HUMAN) ||
                (nRacial == RACIAL_TYPE_HALFELF) ||
                (nRacial == RACIAL_TYPE_HALFORC) ||
                (nRacial == RACIAL_TYPE_HUMANOID_MONSTROUS) ||
                (nRacial == RACIAL_TYPE_HUMANOID_ORC) ||
                (nRacial == RACIAL_TYPE_HUMANOID_REPTILIAN))
            {
                if (GetIsInCombat(oTarget))
                    {
                    //nSave = nSave - 5;
                    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, 5, SAVING_THROW_TYPE_MIND_SPELLS);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSave, oTarget, 0.1);
                    }
                //Make Will Save
                if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    //Apply impact effects and linked duration and charm effect
                    //ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCharm, oTarget);
                    //ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
                    if ((nDom == 1) && !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF))
                    {
                        FloatingTextStringOnCreature("Target failed opposed Charisma check and is now Dominated!", OBJECT_SELF);

                    }
                }
            }
        }
    }
}