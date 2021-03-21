//::///////////////////////////////////////////////
//:: Implosion
//:: NW_S0_Implosion.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All persons within a 5ft radius of the spell must
    save at +3 DC or die.
	
    Reeron modified on 6-12-07
    Changed to be closer to PnP. Max of 4 targets can 
    be affected. Only one creature per round can be affected. 
    +3 to save DC was removed as this isn't true for PnP. 
    Incorporeal creatures, such as shadows, can't be affected 
    by this spell (and don't count towards cap of 4). Changed 
    to SelectiveHostile as in PnP you pick your targets.
	
    Reeron modified on 7-1-07
    Being immune to death magic or having death immunity (undead) 
    doesn't protect from this spell. It's not a Necromancy 
    spell doing a death effect, it's a Destruction spell 
    that causes matter to collapse in on itself (kind of 
    like a blackhole). Special case for Trolls uses fire damage 
    as this is the only way to simulate instant destruction to Trolls.

    Reeron modified on 6-25-09
    Updated for patch 1.22.5588

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 13, 2001
//:://////////////////////////////////////////////

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
    object oTarget;
    effect eDeath;
    effect eHit = EffectVisualEffect( VFX_FNF_IMPLOSION );
    float fDelay;
    int ncount=0;
    //Get the first target in the shape
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetSpellTargetLocation());
    while (GetIsObjectValid(oTarget) && ncount<4 )
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
    	{
           //Fire cast spell at event for the specified target
           SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_IMPLOSION));
           fDelay = GetRandomDelay(0.4, 1.2);
           if (!(GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL)))
               {

               //Make SR check
               if ( !MyResistSpell(OBJECT_SELF, oTarget, fDelay))
                   {
                   //Make Reflex save
                   if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_DEATH, OBJECT_SELF, fDelay))
                       {
                       eDeath = EffectDeath(TRUE);
                       //Apply death effect and the VFX impact
                       if (GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH))
                           {
                           eDeath = EffectDamage((GetCurrentHitPoints(oTarget)+30)); //Just in case they have Magic DR (such as 30/magic)
                           }
                       if (GetAppearanceType(oTarget)==164 || GetAppearanceType(oTarget)==165 || GetAppearanceType(oTarget)==167) //164,165,167 are Trolls
                           {
                           eDeath = EffectDamage(GetCurrentHitPoints(oTarget), DAMAGE_TYPE_FIRE);
                           }
                       DelayCommand(RoundsToSeconds(ncount), ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                       DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget)); // Shows death effect right away so you know which targets were affected.
                       DelayCommand(RoundsToSeconds(ncount), ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget)); // Shows death effect when target actually dies.
                       }
           
                   }
               ncount++;
               }
        }
       //Get next target in the shape
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetSpellTargetLocation());
    }
}