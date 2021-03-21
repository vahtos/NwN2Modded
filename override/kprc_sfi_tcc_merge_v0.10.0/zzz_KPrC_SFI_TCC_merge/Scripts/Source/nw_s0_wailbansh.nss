//::///////////////////////////////////////////////
//:: Wail of the Banshee
//:: NW_S0_WailBansh
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  You emit a terrible scream that kills enemy creatures who hear it
  The spell affects up to one creature per caster level. Creatures
  closest to the point of origin are affected first.
  
  Reeron modified on 6-6-07
  Changed to PnP correct 40 foot radius spread.
  
  Reeron modified on 2-2-09
  Fixed issue where target, nearest to spell target location, would
  get counted twice. Shortened the time that the spell takes to 
  affect the targets by about 2.5 seconds. Now properly takes into 
  account you and your allies (if in the area you/they will not count 
  towards the total number that can be affected).

  Reeron modified on 6-25-09
  Updated for patch 1.22.5588

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On:  Dec 12, 2000
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: VFX Pass By: Preston W, On: June 25, 2001
//:: 6/21/06 - BDF-OEI: updated to use NWN2 VFX
//:: 7.08.06 - PKM-OEI: updated VFX again to make it hot & spicy (changed darkness hit to necro hit)


#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-20 by Georg
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
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nToAffect = nCasterLevel;
    object oTarget;
    float fTargetDistance;
    float fDelay;
    int nSave = GetSpellSaveDC(); // There is no need to get this value for every creature in the loop.
    location lTarget;
    location lTarget2 = GetSpellTargetLocation(); // There is no need to keep getting this location multiple times
                                                  // throughout the spell-script.
    //effect eVis = EffectVisualEffect(VFX_IMP_DEATH);//NWN1 vfx, this works but doesn't look as cool
    effect eVis = EffectVisualEffect (VFX_HIT_SPELL_NECROMANCY);//looks cooler
    //effect eWail = EffectVisualEffect(VFX_FNF_WAIL_O_BANSHEES);	// no longer using NWN1 VFX
    effect eWail = EffectVisualEffect( VFX_HIT_SPELL_WAIL_OF_THE_BANSHEE );	// makes use of NWN2 VFX
    //int nCnt = 0; // Zero is an invalid integer. You start at the "FIRST" object, not the "ZERO'TH" object.
    int nCnt = 1;
    //Apply the FNF VFX impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eWail, lTarget2);
    //Get the closet target from the spell target location
    oTarget = GetSpellTargetObject(); // direct target
    if (!GetIsObjectValid(oTarget))
    {
      //nCnt++; Not needed anymore.
      oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, lTarget2, nCnt);
    }
    while (nCnt <= nToAffect)// Changed to <= rather than <
    {
        lTarget = GetLocation(oTarget);
        //Get the distance of the target from the center of the effect
        fDelay = GetRandomDelay(0.5, 1.5);// Old value of 3-4 seconds was too long.
        fTargetDistance = GetDistanceBetweenLocations(lTarget2, lTarget);
        //Check that the current target is valid and closer than 10.0m. Should be 12.138m which is 40 feet.
        if(GetIsObjectValid(oTarget) && fTargetDistance <= 12.138)
        {
            if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WAIL_OF_THE_BANSHEE));
                //Make SR check
                if(!MyResistSpell(OBJECT_SELF, oTarget)) //, 0.1))
                {
                    //Make a fortitude save to avoid death
                    if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nSave, SAVING_THROW_TYPE_DEATH)) //, OBJECT_SELF, 3.0))
                    {
                        //Apply the delay VFX impact and death effect
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                        effect eDeath = EffectDeath();
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget)); // no delay
                    }
                }
            }
            else 
            {
            nToAffect++; //Makes up for allies in the AoE
            }
        }
        else
        {
            //Kick out of the loop
            nCnt = nToAffect;
        }
        //Increment the count of creatures targeted
        nCnt++;
        //Get the next closest target in the spell target location.
        oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, lTarget2, nCnt);
    }
}