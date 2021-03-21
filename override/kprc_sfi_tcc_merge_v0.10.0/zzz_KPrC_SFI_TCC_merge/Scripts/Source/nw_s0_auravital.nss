//::///////////////////////////////////////////////
//:: Aura of Vitality
//:: NW_S0_AuraVital
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All allies within the AOE gain +4 Str, Con, Dex


    Reeron modified on 3-25-07
    Won't stack with itself anymore.
    
    Reeron modified on 7-4-07
    Changed radius size from Colossal to Large (15' radius) to match PnP.
    Maximum number of allies affected is equal to CasterLevel/3 as per PnP.

    Reeron modified on 6-15-09
    Updated for patch 1.22.5588

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 29, 2001
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"

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
    object oTarget;
    int nMax = GetCasterLevel(OBJECT_SELF)/3;
	int nCount = 0;
    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH,4);
    effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY,4);
    effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION,4);
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);	// NWN1 VFX
    
    effect eLink = EffectLinkEffects(eStr, eDex);
    eLink = EffectLinkEffects(eLink, eCon);
    //eLink = EffectLinkEffects(eLink, eDur);	// NWN1 VFX
    
    //effect eVis = EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION);	// NWN1 VFX
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_AURA_OF_VITALITY );	// NWN2 VFX
    eLink = EffectLinkEffects(eLink, eVis);
    int nDuration = GetCasterLevel(OBJECT_SELF);
    float fDelay;
    
    int nMetaMagic = GetMetaMagicFeat();
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration *= 2;	//Duration is +100%
    }
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget) && nCount < nMax)
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF))
        {
            fDelay = GetRandomDelay(0.4, 1.1);
            //Signal the spell cast at event
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
            //Apply effects and VFX to target
            RemoveEffectsFromSpell(oTarget, GetSpellId());
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
            //DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            nCount++;
        }

        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
    }
}