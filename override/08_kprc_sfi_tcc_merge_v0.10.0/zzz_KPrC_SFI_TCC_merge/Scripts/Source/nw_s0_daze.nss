//::///////////////////////////////////////////////
//:: [Daze]
//:: [NW_S0_Daze.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is dazed for 1 round
//::
//:: Reeron modified on 6-19-07
//:: Changed max level of target able to be affected
//:: from 5 HD to 4 HD. This matches PnP. Range in 
//:: Spells.2da was changed from Long to Short to 
//:: match PnP. Duration was set to 1 round not 2.
//:: This matches PnP.
//::
//:: Reeron modified on 6-15-09
//:: Updated for patch 1.22.5588
//::
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 15, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 27, 2001

#include "x0_I0_SPELLS"    
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
    object oTarget = GetSpellTargetObject();
    //effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);	// NWN1 VFX
    effect eMind = EffectVisualEffect( VFX_DUR_SPELL_DAZE );
    effect eDaze = EffectDazed();
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);	// NWN1 VFX
	//effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);	// NWN1 VFX

    effect eLink = EffectLinkEffects(eMind, eDaze);
    //eLink = EffectLinkEffects(eLink, eDur);

    //effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);	// no longer using NWN1 VFX
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = 1;
    //check meta magic for extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = 2;
    }
    
    
    //Make sure the target is a humaniod
    if (AmIAHumanoid(oTarget) == TRUE)
    {
        if(GetHitDice(oTarget) <= 4)
        {
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        	{
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DAZE));
               //Make SR check
               if (!MyResistSpell(OBJECT_SELF, oTarget))
        	   {
                    //Make Will Save to negate effect
                    if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS))
                    {
                        //Apply VFX Impact and daze effect
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
						//ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);	// NWN1 VFX
                        //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// NWN1 VFX
                    }
                }
            }
        }
    }
}