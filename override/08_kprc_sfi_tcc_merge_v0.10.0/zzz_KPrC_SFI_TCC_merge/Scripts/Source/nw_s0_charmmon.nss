//::///////////////////////////////////////////////
//:: [Charm Monster]
//:: [NW_S0_CharmMon.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is charmed for 1 round
//:: per caster level.
//:: 
//:: Reeron modified on 12-27-07
//:: Now uses duration of 1 hour per level (can't use PnP duration of 1 day per level due to game-engine limitations).
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
//:: Update Pass By: Preston W, On: July 25, 2001

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
    effect eDispel = EffectOnDispel(0.0f, RemoveEffectsFromSpell(oTarget, SPELL_CHARM_MONSTER));
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
    //int nDuration = 3 + nCasterLevel/2;
    int nDuration = nCasterLevel;
    nDuration = GetScaledDuration(nDuration, oTarget);
    //int nRacial = GetRacialType(oTarget);	// This spell can affect any creature regardless of race or size
	
    //Metamagic extend check
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2;
    }
    if (nDuration > 41) {nDuration = 41;} // Anything larger and the Charm effect becomes permanent unless Dispel Magic is used.
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CHARM_MONSTER, FALSE));
        // Make SR Check
        if (!MyResistSpell(OBJECT_SELF, oTarget))
    	{
            if (GetIsInCombat(oTarget))
                {
                //nSave = nSave - 5;
                effect eSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, 5, SAVING_THROW_TYPE_MIND_SPELLS);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSave, oTarget, 0.1);
                }
                //Make a Will Save check
            if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS))
            {
                //Apply impact and linked effect
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
                if ((nDom == 1) && !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF))
                {
                    FloatingTextStringOnCreature("Target failed opposed Charisma check and is now Dominated!", OBJECT_SELF);
                    SetLocalInt(oTarget,"Has Dominate", 1);
                }
            }
        }
    }
}