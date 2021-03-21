//::///////////////////////////////////////////////
//:: Bigby's Clenched Fist
//:: [x0_s0_bigby4]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does an attack EACH ROUND for 1 round/level.
    If the attack hits does
     1d8 +12 points of damage

    Any creature struck must make a FORT save or
    be stunned for one round.

    GZ, Oct 15 2003:
    Changed how this spell works by adding duration
    tracking based on the VFX added to the character.
    Makes the spell dispellable and solves some other
    issues with wrong spell DCs, checks, etc.\
	
    Reeron modified on 3-25-07
    Now does magical damage, not plain bludgeoning damage. 
    Checks to see if the target is under the effects of 
    another Bigby's spell. If it is, this spell will not 
    have an effect. Metamagic now working properly as far
    as storing the metamagic variable for future callbacks.

    Reeron modified on 6-28-09
    Updated for patch 1.22.5588

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Zoeller October 15, 2003

#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "x2_i0_spells"


//int nSpellID = 462;	// GetSpellId() will do the job for us

void RunHandImpact(object oTarget, object oCaster, int nMeta)
{
	//SpawnScriptDebugger();

	int nSpellID = 462;
    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    if (GetIsDead(oTarget) || 
	!GetIsObjectValid(oCaster) || GetIsDead(oCaster) || GetArea(oCaster)!=GetArea(oTarget) ||
	GZGetDelayedSpellEffectsExpired(462,oTarget,oCaster))
    {
        return;
    }
	
    int nCasterModifiers = GetCasterAbilityModifier(oCaster) + GetCasterLevel(oCaster);
    int nCasterRoll = d20(1) + nCasterModifiers + 11 + -1;
    int nTargetRoll = GetAC(oTarget);
    if (nCasterRoll >= nTargetRoll)
    {
       	int nDC = GetLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (nSpellID));

       	int nDam  = MaximizeOrEmpower(8, 1, nMeta, 11);
       	effect eDam = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
       	//effect eVis = EffectVisualEffect(VFX_IMP_ACID_L);	// NWN1 VFX
       	effect eVis = EffectVisualEffect( 837 );	// NWN2 VFX: VFX_HIT_BIGBYS_CLENCHED_FIST

       	DelayCommand( 0.8f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget) );
       	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

       	if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
       	{
			effect eStun = EffectStunned();
			effect eDur = EffectVisualEffect( VFX_DUR_STUN );
			eStun = EffectLinkEffects( eStun, eDur );
           	DelayCommand( 0.8f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(1)) );
       	}

      	DelayCommand(6.0f,RunHandImpact(oTarget,oCaster, nMeta));
   	}
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

    object oTarget = GetSpellTargetObject();
	int nSpellID = 462;

    //--------------------------------------------------------------------------
    // This spell no longer stacks. If there is one hand, that's enough
    //--------------------------------------------------------------------------
    if (GetHasSpellEffect(462,oTarget) ||  GetHasSpellEffect(463,oTarget)  )
    {
        FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
        return;
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

    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    int nMeta = GetMetaMagicFeat();	
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
         nDuration = nDuration * 2;
    }

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, TRUE));
        int nResult = MyResistSpell(OBJECT_SELF, oTarget);

        if(nResult  == 0)
        {
			int nCasterModifier = GetCasterAbilityModifier(OBJECT_SELF);
            effect eHand = EffectVisualEffect(VFX_DUR_BIGBYS_CLENCHED_FIST);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHand, oTarget, RoundsToSeconds(nDuration));

            //----------------------------------------------------------
            // GZ: 2003-Oct-15
            // Save the current save DC on the character because
            // GetSpellSaveDC won't work when delayed
            //----------------------------------------------------------
            SetLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (nSpellID), GetSpellSaveDC());
            RunHandImpact(oTarget,OBJECT_SELF, nMeta );
        }
    }
}