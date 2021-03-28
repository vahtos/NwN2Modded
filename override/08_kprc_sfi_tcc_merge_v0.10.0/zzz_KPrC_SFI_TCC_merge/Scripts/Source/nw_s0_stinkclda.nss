//::///////////////////////////////////////////////
//:: Stinking Cloud On Enter
//:: NW_S0_StinkCldA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Those within the area of effect must make a
    fortitude save or be dazed.
	
    Reeron modified 3-3-07. Removed spell resistance
    check. No spell resistance as per PnP.
	
    Reeron modified on 7-17-07
    Duration properly set to 1d4+1 rounds (was 2).
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

#include "X0_I0_SPELLS"

void main()
{

    //Declare major variables
    effect eStink = EffectDazed();
    effect eMind = EffectVisualEffect( VFX_DUR_SPELL_DAZE );
    effect eSlow = EffectConcealment(20, MISS_CHANCE_TYPE_NORMAL);
    eSlow = EffectLinkEffects(eSlow, EffectMissChance(50, MISS_CHANCE_TYPE_VS_RANGED));
    eSlow = EffectLinkEffects(eSlow, EffectConcealment(50, MISS_CHANCE_TYPE_VS_RANGED));
    eSlow = ExtraordinaryEffect(eSlow);
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eMind, eStink);

    //eLink = EffectLinkEffects(eLink, eDur);

    //effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
    effect eFind;
    object oTarget;
    object oCreator;
    float fDelay;
    int nRounds;
    
    //Get the first object in the persistant area
    oTarget = GetEnteringObject();
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_STINKING_CLOUD));
        //Make a SR check
        //if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget))
        {
            DelayCommand(0.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oTarget, RoundsToSeconds(1)));
            //Make a Fort Save
            if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_POISON))
            {
               fDelay = GetRandomDelay(0.75, 1.75);
               //Apply the VFX impact and linked effects
               if (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) == FALSE)
               {
                   //DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                   nRounds = d4(1) + 1;
                   DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nRounds)));
               }
            }
        }
    }
}