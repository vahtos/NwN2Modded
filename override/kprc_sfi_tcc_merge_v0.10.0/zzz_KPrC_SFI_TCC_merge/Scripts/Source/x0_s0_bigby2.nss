//::///////////////////////////////////////////////
//:: Bigby's Forceful Hand
//:: [x0_s0_bigby2]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    dazed vs strength check (+14 on strength check); Target knocked down.
    Target dazed down for 1 round per level of caster
	
    Reeron modified on 3-6-07
    Can't stack with other Bigby's spells anymore.
    Copied RunHandImpact from 8th level Bigby's spell. 
    Used Immobilize attempted once per round rather 
    than one knockdown attempt that lasts the entire 
    duration. This is as close to PnP as I can get.

    Reeron modified on 6-28-09
    Updated for patch 1.22.5588

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs May 01, 2003

#include "x0_i0_spells"
#include "x2_inc_spellhook" 
#include "x2_i0_spells"


void RunHandImpact(object oTarget, object oCaster)
{
    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
	int nSpellID = 460;/* GetSpellId() will do the job for us or could just use "460" 
	                               instead of using "GetSpellId()". Either way would work. */
    if (!GetIsObjectValid(oTarget) || GetIsDead(oTarget) || 
	!GetIsObjectValid(oCaster) || GetIsDead(oCaster) || GetArea(oCaster)!=GetArea(oTarget) ||
	GZGetDelayedSpellEffectsExpired(460,oTarget,oCaster))
    {
        return;
    }

    int nCasterRoll = d20();
    int nTargetRoll = d20(1) + GetAbilityModifier(ABILITY_STRENGTH, oTarget) + GetSizeModifier(oTarget);
    if (nCasterRoll==20 || nCasterRoll+14 >= nTargetRoll) {
        effect eBullrush = EffectCutsceneImmobilize(); /* Immobilize much better than Knockdown. 
		Target still has limited actions available to it. Also, this is a BullRush not a knockdown attempt. 
		Having immunity to knockdown should not negate this spell effect. */
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBullrush, oTarget, 5.0f); /* Apply it for 5 seconds so 
		the effect just runs out at the end of the round. 1 second later it will be attempted again. Target 
		will not have had a chance to do anything before the effect is applied again. */
    }
    DelayCommand(6.0f,RunHandImpact(oTarget,oCaster));
}
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
	int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND)	//Duration is +100%
    {
         nDuration = nDuration * 2;
    }
	if(!GetIsObjectValid(oTarget))   
	{	SendMessageToPC(OBJECT_SELF, "That target is an invalid target!");
		return;
		}
		if( GetHasSpellEffect(SPELL_BIGBYS_INTERPOSING_HAND, oTarget) ||
	    GetHasSpellEffect(SPELL_BIGBYS_FORCEFUL_HAND, oTarget) ||
        GetHasSpellEffect(SPELL_BIGBYS_GRASPING_HAND, oTarget) ||
        GetHasSpellEffect(SPELL_BIGBYS_CLENCHED_FIST, oTarget) ||
        GetHasSpellEffect(SPELL_BIGBYS_CRUSHING_HAND, oTarget))
		 {
        SendMessageToPC(OBJECT_SELF, "That target is already being assaulted by a Bigby's Hand!");
        return;
    }
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        // Apply the impact effect
        effect eImpact = EffectVisualEffect(VFX_IMP_BIGBYS_FORCEFUL_HAND);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 460, TRUE));
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        { 
		
		/* The following is a much better aproximation of the PnP version of the spell */
		
		effect eImpact = EffectVisualEffect(VFX_DUR_BIGBYS_GRASPING_HAND);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eImpact, oTarget, RoundsToSeconds(nDuration));
			if(GetCreatureSize(oTarget)>CREATURE_SIZE_LARGE)
                SendMessageToPC(OBJECT_SELF, "That creature is too large to bull rush!");
			else
               RunHandImpact(oTarget, OBJECT_SELF); 
	  
          /*  This is original code. Not implemented per PnP so I remarked it out and used a different effect.
		  
		  
		  int nCasterRoll = d20(1) + 14;
            int nTargetRoll = d20(1) + GetAbilityModifier(ABILITY_STRENGTH, oTarget) + GetSizeModifier(oTarget);
            // * bullrush succesful, knockdown target for duration of spell
            if (nCasterRoll >= nTargetRoll)
            {
                effect eVis = EffectVisualEffect( VFX_DUR_SPELL_DAZE );
                effect eKnockdown = EffectDazed();
                effect eKnockdown2 = EffectKnockdown();
                //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                //Link effects
                effect eLink = EffectLinkEffects(eKnockdown, eVis);
                eLink = EffectLinkEffects(eLink, eKnockdown2);
                //Apply the penalty
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, RoundsToSeconds(nDuration));
                // * Bull Rush succesful
                FloatingTextStrRefOnCreature(8966,OBJECT_SELF, FALSE);
            }
            else
            {
                FloatingTextStrRefOnCreature(8967,OBJECT_SELF, FALSE);
            }*/
		  }	
       }
	}
	   