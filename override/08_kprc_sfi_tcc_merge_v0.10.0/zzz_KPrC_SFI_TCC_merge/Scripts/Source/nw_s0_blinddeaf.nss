//::///////////////////////////////////////////////
//:: Blindness and Deafness
//:: [NW_S0_BlindDead.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Causes the target creature to make a Fort
//:: save or be blinded and deafened.
//::
//:: Reeron modified on 6-19-07
//:: Duration is now permanent as per PnP.
//:: 
//:: Reeron modified on 2-24-08
//:: Now follows PnP: 50% movement speed decrease, -4 to search checks, 
//:: and automatically fail spot checks (simulated by giving a -50 penalty to spot skill).
//:: Target loses Dexterity bonus (only applies if Dexterity is above 10).
//::
//:: Reeron modified on 6-15-09
//:: Updated for patch 1.22.5588
//::
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 12, 2001
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"    
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


    //Declare major varibles
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    effect eBlind =  EffectBlindness();
    effect eDeaf = EffectDeaf();
    effect eAC = EffectACDecrease( 2 );
    effect eMoveDec = EffectMovementSpeedDecrease(50);
    effect eSpot = EffectSkillDecrease(SKILL_SPOT , 50);
    effect eSearch = EffectSkillDecrease(SKILL_SEARCH , 4);
    effect eDex;
    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_BLIND_DEAF);
    int nDex = GetAbilityScore( oTarget, ABILITY_DEXTERITY );
    if (nDex > 10)
        {
        int nDecr = (nDex-10);
        eDex = EffectAbilityDecrease( ABILITY_DEXTERITY, nDecr);
        }
    effect eLink = EffectLinkEffects(eBlind, eDeaf);
    eLink = EffectLinkEffects(eLink, eSpot);
    eLink = EffectLinkEffects(eLink, eSearch);
    eLink = EffectLinkEffects(eLink, eAC );
    eLink = EffectLinkEffects(eLink, eMoveDec );
    eLink = EffectLinkEffects(eLink, eDex );
    eLink = EffectLinkEffects(eLink, eVis);
    eLink = SupernaturalEffect(eLink);
	
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		if( GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
		{
			FloatingTextStrRefOnCreature(40105, OBJECT_SELF, FALSE);
			return;
		}
        //Fire cast spell at event
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BLINDNESS_AND_DEAFNESS));
        //Do SR check
        if (!MyResistSpell(OBJECT_SELF, oTarget))
        {
            // Make Fortitude save to negate
            if (!/*Fort Save*/ MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()))
            {
                //Metamagic check for duration
                if (nMetaMagic == METAMAGIC_EXTEND)
                {
                    nDuration = nDuration * 2;
                }
                //Apply visual and effects
                //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
            }
        }
    }
}