//::///////////////////////////////////////////////
//:: Bigby's Interposing Hand
//:: [x0_s0_bigby1]
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Grants -10 to hit to target for 1 round / level
	
    Reeron modified 3-6-07
    Prevents stacking of this spell with other 
    Bigby's spells.
    
    Reeron modified on 9-21-07
    Lowered attack decrease to 4 (was 10) to match PnP.
    
    Reeron modified on 10-30-07
    Now slows down target as per PnP. Can't slow down 
    creatures weighing more than 2000 pounds (Huge creatures). 
    Obviously, this is an approximation.    

    Reeron modified on 6-28-09
    Updated for patch 1.22.5588

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:
#include "nw_i0_spells"

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
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
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


    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF,
                                              SPELL_BIGBYS_INTERPOSING_HAND,
                                              TRUE));
        //Check for metamagic extend
        if (nMetaMagic == METAMAGIC_EXTEND)	//Duration is +100%
        {
             nDuration = nDuration * 2;
        }
        if (!MyResistSpell(OBJECT_SELF, oTarget))
        {

        	effect eAC1 = EffectAttackDecrease(4);
        	effect eSlow = EffectMovementSpeedDecrease(50);
        	effect eVis = EffectVisualEffect(VFX_DUR_BIGBYS_INTERPOSING_HAND);
        	effect eLink = EffectLinkEffects(eAC1, eVis);
        	if(GetCreatureSize(oTarget)>CREATURE_SIZE_LARGE) // Can't slow down creatures weighing more than 2000 pounds.
        	{                                                // Obviously, this is an approximation.
        	eLink = EffectLinkEffects(eLink, eSlow); 
        	}
        	

       		//Apply the TO HIT PENALTIES bonuses and the VFX impact
        	ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration) );
        }
    }
}