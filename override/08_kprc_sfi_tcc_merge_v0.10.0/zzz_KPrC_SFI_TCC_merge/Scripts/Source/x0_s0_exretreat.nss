//::///////////////////////////////////////////////
//:: Expeditious retreat
//:: x0_s0_exretreat.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Increases movement rate to the max, allowing
 the spell-caster to flee.
 Also gives + 2 AC bonus
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: September 6, 2002
//:://////////////////////////////////////////////
//:: Last Update By: Andrew Nobbs May 01, 2003
/*     

       Reeron modified on 3-5-07
	   Movement speed increases above 99 aren't possible according to the 
	   script assist. In the function for EffectMovementSpeedIncrease it lists
	   0-99 as the range. Therefore, passing through the numeric value of 150 
	   isn't possible. Changed to an increase of 50% as this is what is listed 
	   for PnP (30 feet increase). Quoted from PnP: "If you do nothing but move (that is, 
	   if you use both of your actions in a round to move your speed), you can move 
	   double your speed " (60 feet total). So 30 feet would be a 50% increase. 
	   Also, changed duration to 1 minute per level as per PnP. 
	   	   
	   
*/
// JLR - OEI 08/23/05 -- Metamagic changes
#include "nwn2_inc_spells"


#include "NW_I0_SPELLS"
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

    if (GetHasSpellEffect(SPELL_HASTE, oTarget) == TRUE)
    {
        return ; // does nothing if caster already has haste
    }
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);	// NWN1 VFX
    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_EXPEDITIOUS_RETREAT );	// NWN2 VFX
    //effect eFast = EffectMovementSpeedIncrease(150);
	effect eFast = EffectMovementSpeedIncrease(50);
    effect eLink = EffectLinkEffects(eFast, eDur);
    
    //float fDuration = RoundsToSeconds(GetCasterLevel(OBJECT_SELF));
	float fDuration = TurnsToSeconds(GetCasterLevel(OBJECT_SELF));
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 455, FALSE));

	//Apply the VFX impact and effects
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}