//::///////////////////////////////////////////////
//:: Darkness
//:: NW_S0_Darkness.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a globe of darkness around those in the area
    of effect.
	
    Reeron modified on 6-19-07
    Changed duration to match that of PnP. However, since game 
    minutes are different than real-time minutes, the spell 
    duration is 10 minutes per level (game minutes). If I used 
    real-time minutes, the AOE would last for 200 minutes (20th level) 
    which would be equal to 100 game-time hours (4 game-days).

    Reeron modified on 9-30-07
    Now uses Assassin levels for duration when cast by an assassin.

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
// ChazM 7/14/06 If cast on an object, signal the object cast on (needed for crafting)
//:: AFW-OEI 08/03/2007: Account for Assassins.

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


    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_DARKNESS);
    object oTarget = GetSpellTargetObject();
    if (GetIsObjectValid(oTarget))
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DARKNESS));
	
    location lTarget = GetSpellTargetLocation();
    int nDuration = GetCasterLevel(OBJECT_SELF);
	
	if (GetSpellId() == SPELLABILITY_AS_DARKNESS)
	{	// Duration is equal to Assassin level for Assassins.
		nDuration = GetLevelByClass(CLASS_TYPE_ASSASSIN);
	}

    int nDuration2 = (10 * nDuration)/3;// This sets the duration to 10 minutes/level in game-time minutes.
    int nMetaMagic = GetMetaMagicFeat();
    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
	   nDuration = nDuration *2;	//Duration is +100%
    }
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration2));
}