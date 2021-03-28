//::///////////////////////////////////////////////
//:: Assay Resistance
//:: NW_S0_AssayRest.nss
//:://////////////////////////////////////////////
/*

    Reeron modified on 3-15-07
    Gives correct 1 round/level duration.
    Correctly applies +10 Spell Penentration 
    Bonus to Caster instead of target.
    EventSpellCastAt is now using correct 
    Spell_Target_StandardHostile.

    Reeron modified on 5-4-09
    Updated for patch 1.22.5588

*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: June 15, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001



// JLR - OEI 08/24/05 -- Metamagic changes
#include "nwn2_inc_spells"

#include "nw_i0_spells"
#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
  Reeron modified on 3-15-07
  Corrected duration to 1 round/level.
  
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
	object oCaster = OBJECT_SELF;
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    float fDuration = RoundsToSeconds(nCasterLvl);

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    RemoveEffectsFromSpell(oTarget, GetSpellId());

    effect eAssay = EffectAssayResistance(oTarget);
    //effect eHit = EffectVisualEffect(VFX_HIT_SPELL_DIVINATION);	// no longer using NWN1 VFX
    effect eHit = EffectVisualEffect( VFX_DUR_SPELL_ASSAY_RESISTANCE );	// NWN2 VFX
	//effect eLink = EffectLinkEffects( eAssay, eHit );
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Apply the VFX impact and effects
    //ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
	ApplyEffectToObject(nDurType, eHit, oTarget, fDuration);
	ApplyEffectToObject(nDurType, eAssay, oCaster, fDuration);
	//ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
	}
}