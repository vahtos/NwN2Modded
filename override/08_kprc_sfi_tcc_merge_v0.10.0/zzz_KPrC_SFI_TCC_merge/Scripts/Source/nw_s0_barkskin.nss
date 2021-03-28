//::///////////////////////////////////////////////
//:: [Barkskin]
//:: [NW_S0_BarkSkin.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Enhances the casters Natural AC by an amount
   dependant on the caster's level.
   
   Reeron modified on 7-14-07
   Now follows PnP stats. Base AC of 2. Increases by +1 
   for every 3 levels above 3rd level. Max of +5 at 12th level.
   Sets duration (1.5 min/level)to mid-way between 1 min/level and 1 hour/level 
   since 2 minutes = 1 game hour. 10 min/level spell should be more than 1 min/level 
   spell but not quite 1 hour/level spell.
   
   Reeron modified on 8-8-07
   Was incorrectly calculating AC bonus. Now fixed.
   
   Reeron modified on 6-15-09
   Updated for patch 1.22.5588

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 21, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 5, 2001
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: July 20, 2001

// JLR - OEI 08/24/05 -- Metamagic changes
// BDF - 6/20/06: revised to work with NWN2 visual effects
#include "nwn2_inc_spells"

#include "x2_inc_spellhook" 

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
	int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nCasterLevel2 = nCasterLevel*15; // This sets it to 1 1/2 minutes per level. More than 1 min/level spells but not quite equal to 1 hour/level spells.
    int nBonus;
    float fDuration = RoundsToSeconds(nCasterLevel2);

    //effect eVis = EffectVisualEffect(VFX_DUR_PROT_BARKSKIN);	// BDF - 6/20/06: this original constant is still valid, but we elect to use our new constants for consistency
    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_BARKSKIN);
   
	// BDF - 6/20/06: invalid for NWN2, all impact and cessation effects are now integrated in the visual effect (see visualeffects.2da)
	//effect eHead = EffectVisualEffect(VFX_IMP_HEAD_NATURE);	
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);	// NWN1 VFX
	
    effect eAC;

    //Signal spell cast at event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BARKSKIN, FALSE));

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Determine AC Bonus based Level.
    if (nCasterLevel < 6)
    {
        nBonus = 2;
    }
    else
    {
        if (nCasterLevel < 9)
        {
            nBonus = 3;
        }
        else if (nCasterLevel < 12)
        {
            nBonus = 4;
        }
		else
		{
		    nBonus = 5;
		}
    }

    //Make sure the Armor Bonus is of type Natural
    eAC = EffectACIncrease(nBonus, AC_NATURAL_BONUS);
    effect eLink = EffectLinkEffects(eVis, eAC);
    //eLink = EffectLinkEffects(eLink, eDur);	// NWN1 VFX

    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eHead, oTarget);	// BDF - 6/20/06: effect eHead is no longer valid
}