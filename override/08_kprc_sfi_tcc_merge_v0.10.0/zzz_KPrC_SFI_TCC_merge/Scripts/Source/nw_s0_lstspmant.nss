//::///////////////////////////////////////////////
//:: Least Spell Mantle
//:: NW_S0_LstSpTurn.nss
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
    Absorbs 1d4 + 4 spell levels before collapsing

    Bold-faced rip-off from Lesser Spell Mantle
	
    Reeron modified on 11-24-08
    Now keeps track of rounds remaining, on the target of the spell, 
    so I can recall the duration later.

    Reeron modified on 12-31-08
    Unlinked effects so removing one effect 
    doesn't remove all of the effects anymore. 
    This was needed so that my custom Spell Resistance 
    function would work correctly.

    Reeron modified on 6-15-09
    Updated for patch 1.22.5588

*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/22/2006
//:://////////////////////////////////////////////
//: PKM-OEI 07.10.06 VFX pass

#include "nw_i0_spells"

#include "x2_inc_spellhook"

void MantleDuration(int nId,object oTarget);

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
    int nId= GetSpellId();
    //effect eVis = EffectVisualEffect(VFX_DUR_SPELLTURNING);//nwn1 vfx
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);//nwn1 vfx
    effect eDur = EffectVisualEffect(VFX_DUR_SPELL_LESSER_SPELL_MANTLE);//nwn2 vfx
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nAbsorb = d4() + 4;
    int nMetaMagic = GetMetaMagicFeat();

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nAbsorb = 8;//Damage is at max
    }
    else if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nAbsorb = nAbsorb + (nAbsorb/2); //Damage/Healing is +50%
    }
    else if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    //Link Effects
    effect eAbsob = EffectSpellLevelAbsorption(9, nAbsorb);
    //effect eLink = EffectLinkEffects(eVis, eAbsob);
    //eLink = EffectLinkEffects(eLink, eDur);
    effect eLink = EffectLinkEffects(eDur, eAbsob);
    effect eDispel = EffectOnDispel(0.0f, RemoveEffectsFromSpell(oTarget, nId));
    eAbsob = EffectLinkEffects(eAbsob, eDispel);
    eDur = EffectLinkEffects(eDur, eDispel);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LEAST_SPELL_MANTLE, FALSE));
    RemoveEffectsFromSpell(oTarget, GetSpellId());
	RemoveEffectsFromSpell(oTarget, SPELL_LESSER_SPELL_MANTLE);
    RemoveEffectsFromSpell(oTarget, SPELL_GREATER_SPELL_MANTLE);
    RemoveEffectsFromSpell(oTarget, SPELL_SPELL_MANTLE);
    //Apply the VFX impact and effects
    //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAbsob, oTarget, RoundsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(nDuration));
    
    int nTime = nDuration * 6;
    SetLocalInt(oTarget,"MantleTimeRemaining", nTime);
    //SendMessageToPC(GetFirstPC(FALSE), "<color=deepskyblue>Original nTime = "+IntToString(GetLocalInt(oTarget,"MantleTimeRemaining")));
    //FloatingTextStringOnCreature("nTime = "+IntToString(nTime), oTarget, TRUE, 2.0);
    // Delay command goes here
    DelayCommand(1.0, MantleDuration(nId,oTarget));

}
// Delay loop goes here
void MantleDuration(int nId,object oTarget)
{
    if (GetHasSpellEffect(nId, oTarget) /*&& !GetIsDead(oTarget)*/)
        {
        int nTime = GetLocalInt(oTarget,"MantleTimeRemaining");
        nTime-=1;
        if (nTime<1)
            {
            RemoveEffectsFromSpell(oTarget, nId);
            DeleteLocalInt(oTarget,"MantleTimeRemaining");
            }
        else
            {
            SetLocalInt(oTarget,"MantleTimeRemaining", nTime);
            //SendMessageToPC(GetFirstPC(FALSE), "<color=coral>nTime = "+IntToString(nTime));
            DelayCommand(1.0, MantleDuration(nId,oTarget));
            }
        }
}