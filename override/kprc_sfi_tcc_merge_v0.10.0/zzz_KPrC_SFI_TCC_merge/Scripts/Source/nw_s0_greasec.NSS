//::///////////////////////////////////////////////
//:: Grease: Heartbeat
//:: NW_S0_GreaseC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creatures entering the zone of grease must make
    a reflex save or fall down.  Those that make
    their save have their movement reduced by 1/2.
	
    Reeron modified on 6-10-07
    Added check for immunity to knockdown. If immune 
    to knockdown, creature is immobilized using 
    CutSceneImmobilize. This simulates falling, as 
    being immune to knockdown doesn't make you immune 
    to falling down.

    Reeron modified on 6-15-09
    Updated for patch 1.22.5588	

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 1, 2001
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{


    //Declare major variables
    object oTarget;
    effect eFall = EffectKnockdown();
    effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);
    effect eLink = EffectLinkEffects(eFall, eHit);;
    float fDelay;
	effect eFall1 = EffectCutsceneImmobilize();
	effect eLink1 = EffectLinkEffects(eFall1, eHit);
    //Get first target in spell area
    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
       // if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) &&(GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )
       if( (GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )	// AFW-OEI 05/01/2006: Woodland Stride no longer protects from spells.
       {
            if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
            {
                fDelay = GetRandomDelay(0.0, 2.0);
                if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
                {
                    if (GetIsImmune(oTarget, IMMUNITY_TYPE_KNOCKDOWN))
                        {
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink1, oTarget, 4.0));
                        }
                    else 
                        {
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 4.0));
                        }
                  }
            }
        }
        //Get next target in spell area
        oTarget = GetNextInPersistentObject();
    }
}