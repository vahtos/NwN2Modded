//::///////////////////////////////////////////////
//:: Cure Minor Wounds
//:: NW_S0_CurMinW
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// As cure light wounds, except cure minor wounds
// cures only 1 point of damage

// Reeron modified on 7-7-07
// Now only heals 1 hitpoint per PnP.
// 

// Reeron modified on 5-4-09
// Updated for patch 1.22.5588

*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On: Oct 18, 2000
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: Feb 22, 2001
//:: Last Updated By: Preston Watamaniuk, On: April 6, 2001

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


    spellsCure(1, 0, 1, VFX_IMP_SUNSTRIKE, VFX_IMP_HEALING_S, GetSpellId());
}