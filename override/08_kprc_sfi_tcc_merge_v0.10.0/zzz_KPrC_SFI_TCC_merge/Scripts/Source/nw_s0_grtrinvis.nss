///::///////////////////////////////////////////////
//:: Greater Invisibility
//:: NW_S0_GrtrInvis.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target creature can attack and cast spells while
    invisible
	
	Reeron modified on 3-7-07
	Changed the invisibility type to INVISIBILITY_TYPE_IMPROVED. 
	This allows the affected creature to remain invisible even 
	after attacking, just like PnP. Only creatures that can 
	see invisible creatures or succeed at a listen check can 
	target the affected creature.
	
	
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

// (Updated JLR - OEI 07/05/05 NWN2 3.5)

#include "x2_inc_spellhook"
#include "nw_i0_spells"

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
    effect eImpact = EffectVisualEffect(VFX_HIT_SPELL_ILLUSION);

    effect eInvis = EffectInvisibility( INVISIBILITY_TYPE_IMPROVED );
	effect eVis = EffectVisualEffect( VFX_DUR_INVISIBILITY );

    //effect eCover = EffectConcealment(50);
    effect eLink = EffectLinkEffects(eInvis, eVis);
	
	//eLink = EffectLinkEffects( eLink, eVis );


    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GREATER_INVISIBILITY, FALSE));
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
}