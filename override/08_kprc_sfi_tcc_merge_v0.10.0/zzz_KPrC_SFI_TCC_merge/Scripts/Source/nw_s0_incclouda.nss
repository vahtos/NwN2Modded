//::///////////////////////////////////////////////
//:: Incendiary Cloud: On Enter
//:: NW_S0_IncCloud.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Person within the AoE take 4d6 fire damage
    per round.
	
    Reeron modified on 3-3-07
    Removed spell resistance check
    
    Reeron modified on 7-17-07
    Added 20% Concealment to Melee attacks as per PnP.
    Added 50% Concealment to Ranged attacks (in-coming and out-going) 
    to simulate the miss chance per PnP for targets further than 
    5 feet away. Assumes you would change to melee weapon if closer 
    than 5.1 feet. This assumption isn't 100% accurate but something 
    had to be done to simulate being further than 5 feet away.

    Reeron modified on 6-25-09
    Updated for patch 1.22.5588

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: March 2003: Removed movement speed penalty
#include "X0_I0_SPELLS"

void main()
{

    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    effect eDam;
    effect eSlow = EffectConcealment(20, MISS_CHANCE_TYPE_NORMAL);
    eSlow = EffectLinkEffects(eSlow, EffectMissChance(50, MISS_CHANCE_TYPE_VS_RANGED));
    eSlow = EffectLinkEffects(eSlow, EffectConcealment(50, MISS_CHANCE_TYPE_VS_RANGED));
    eSlow = ExtraordinaryEffect(eSlow);
    object oTarget;
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
    float fDelay;
    //Capture the first target object in the shape.
    oTarget = GetEnteringObject();
    //Declare the spell shape, size and the location.
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_INCENDIARY_CLOUD));
        //Make SR check, and appropriate saving throw(s).
       // if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget, fDelay))
      //  {
            fDelay = GetRandomDelay(0.5, 2.0);
            //Roll damage.
            nDamage = d6(4);
            //Enter Metamagic conditions
                if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                   nDamage = 24;//Damage is at max
                }
                if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                     nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                }
            //Adjust damage for Reflex Save, Evasion and Improved Evasion
            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE, GetAreaOfEffectCreator());
            // Apply effects to the currently selected target.
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
            DelayCommand(0.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oTarget, RoundsToSeconds(1)));
            if(nDamage > 0)
            {
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
       // }
    }
}