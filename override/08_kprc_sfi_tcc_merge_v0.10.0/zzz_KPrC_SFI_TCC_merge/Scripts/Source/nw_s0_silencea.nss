//::///////////////////////////////////////////////
//:: Silence: On Enter
//:: NW_S0_SilenceA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The target is surrounded by a zone of silence
    that allows them to move without sound.  Spell
    casters caught in this area will be unable to cast
    spells.

    Reeron modified on 4-10-08
    Increased duration to take into account epic levels 
    and Practiced Spellcaster.

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
// ChazM 1/18/07 - EvenFlw modifications

//RedRover updated 4/29/2012 - Added sonic immunity check and changed damage 
//reduction type from Kaedrin's script

#include "X0_I0_SPELLS"

// this has the silence constant EVENFLW_SILENCE, and is the only reason we include it.
// Affects NW_S0_Silence & NW_S0_SilenceA
#include "nw_i0_generic"

void main()
{
    //Declare major variables including Area of Effect Object
    //effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ILLUSION);

    effect eDur2 = EffectVisualEffect( VFX_DUR_SPELL_SILENCE );
    effect eSilence = EffectSilence();
//  effect eImmune = EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, 100); //RedRover - this what Reeron was using
    effect eImmune = EffectDamageResistance(DAMAGE_TYPE_SONIC, 9999, 0); // RedRover - this is what Kaedrin was using	

    effect eLink = EffectLinkEffects(eDur2, eSilence);
    eLink = EffectLinkEffects(eLink, eImmune);

    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();
	int bHostile = FALSE;

//	Redrover - **begin Kaedrin's addition
	int nSpellId = GetSpellId();
	
	//Still need to scan all effects and the hide to see if they have sonic immunity
	//If so, stop this script from continuing.
	//Also need to make sure that when scanning effects, 
	//this spell id is accounted for. Don't stop the script if it's just this spell
	if (GetHasSpellEffect(nSpellId,oTarget))
	{
		RemoveSpellEffects(nSpellId, oCaster, oTarget);
	}
//	**end Kaedrins's addition	
	
	if ( spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster) )//Was STANDARDHOSTILE
    {
	    if(!GetIsInCombat(oTarget))
			SignalEvent( oTarget, EventSpellCastAt(oCaster, SPELL_SILENCE) );
	    //if ( !MyResistSpell(oCaster,oTarget) )
    	{   
        	//Fire cast spell at event for the specified target
        	ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(70));// Was 40 rounds.
			//ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
       	}
    }
	else
	{
	    //Fire cast spell at event for the specified target
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(70));// Was 40 rounds.
        SignalEvent( oTarget, EventSpellCastAt(oCaster, SPELL_SILENCE, FALSE) );
		//ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
	}
	if(!GetLocalInt(oTarget, EVENFLW_SILENCE))
		SetLocalObject(oTarget, EVENFLW_SILENCE, OBJECT_SELF);
	else 
		SetLocalObject(oTarget, EVENFLW_SILENCE, OBJECT_INVALID);
}