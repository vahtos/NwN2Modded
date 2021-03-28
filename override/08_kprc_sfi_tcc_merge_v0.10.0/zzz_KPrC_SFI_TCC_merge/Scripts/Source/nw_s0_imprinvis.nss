///::///////////////////////////////////////////////
//:: Improved Invisibility
//:: NW_S0_ImprInvis.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target creature can attack and cast spells while
    invisible
	
	Reeron modified on 3-9-07
	Changed the invisibility type to INVISIBILITY_TYPE_IMPROVED. 
	This allows the affected creature to remain invisible even 
	after attacking, just like PnP. Only creatures that can 
	see invisible creatures or succeed at a listen check can 
	target the affected creature. Lowered duration to 1 round 
	per level to make it the same as Greater Invisibility as 
	this is what spell the Assassin is actually using.
	
	Reeron modified on 9-30-07
	Now takes into account assassin levels for duration.
	
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: AFW-OEI 08/03/2007: Account for Assassins.

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
    //effect eImpact = EffectVisualEffect(VFX_IMP_HEAD_MIND);

    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_IMPROVED);
	
    effect eVis = EffectVisualEffect(VFX_DUR_INVISIBILITY);
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    //effect eCover = EffectConcealment(50);
    //effect eLink = EffectLinkEffects(eDur, eCover);
	effect eLink = EffectLinkEffects(eInvis, eVis);
	

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    int nDuration = GetCasterLevel(OBJECT_SELF);
	if (GetSpellId() == SPELLABILITY_AS_GREATER_INVISIBLITY)
	{	// Duration is equal to Assassin level for Assassins.
		nDuration = GetLevelByClass(CLASS_TYPE_ASSASSIN);
	}
	
    int nMetaMagic = GetMetaMagicFeat();
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    //Apply the VFX impact and effects
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
	
    //eInvis = EffectLinkEffects(eInvis, eDispel);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
    //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oTarget, TurnsToSeconds(nDuration));
}