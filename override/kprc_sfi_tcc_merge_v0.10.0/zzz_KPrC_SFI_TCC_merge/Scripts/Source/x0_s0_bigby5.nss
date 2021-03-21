//::///////////////////////////////////////////////
//:: Bigby's Crushing Hand
//:: [x0_s0_bigby5]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Similar to Bigby's Grasping Hand.
    If Grapple succesful then will hold the opponent and do 2d6 + 12 points
    of damage EACH round for 1 round/level


   // Mark B's famous advice:
   // Note:  if the target is dead during one of these second-long heartbeats,
   // the DelayCommand doesn't get run again, and the whole package goes away.
   // Do NOT attempt to put more than two parameters on the delay command.  They
   // may all end up on the stack, and that's all bad.  60 x 2 = 120. 
   
   Reeron modified on 3-25-07
   Checks to see if the target is under the effects of 
   another Bigby's spell. If it is, this spell will not have an effect.
	
   Now does magical damage, not plain bludgeoning damage. 
   Can't grapple a creature who is bigger than HUGE. But it can still damage it. 
   Just can't immobilize it. Modified to better simulate a touch attack
   on the grapple to hit roll. Removes armor bonus from chest slot, armor bonus from bracers
   or gauntlets, natural armor bonus from amulets, shield bonus from an equipped shield, 
   and armor bonus from belts. By doing this it more closely simulates a melee touch attack 
   which doesn't allow your armor bonus, natural armor bonus, or shield bonus.
   Metamagic now working properly as far as storing the metamagic variable for future callbacks.
   
   Reeron modified on 12-23-07
   Freedom of Movement now makes you immune to this spell.

   Reeron modified on 6-28-09
   Updated for patch 1.22.5588
 
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By: PKM-OEI 08.09.06
//:: PKM-OEI 08.18.06 - Forced a grapple check each round for the duration

#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "x2_i0_spells"

int nSpellID = 463;
int RunGrappleHit( object oTarget );
void RunGrappleHold( object oTarget, int nDuration, int nMeta );
void RunHandImpact( object oTarget, object oCaster, int nDuration, int nMeta );

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

    //--------------------------------------------------------------------------
    // This spell no longer stacks. If there is one hand, that's enough
    //--------------------------------------------------------------------------
    if (GetHasSpellEffect(462,oTarget) ||  GetHasSpellEffect(463,oTarget)  )
    {
        FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
        return;
    }
    if(!GetIsObjectValid(oTarget))   
    {
        SendMessageToPC(OBJECT_SELF, "That target is an invalid target!");
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

    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND) //Duration is +100%
    {
         nDuration = nDuration * 2;
    }

    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BIGBYS_CRUSHING_HAND, TRUE));

        //SR
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
            // * grapple HIT succesful,
            if (RunGrappleHit( oTarget ))
            {			
                effect eHold = EffectVisualEffect( VFX_DUR_PARALYZED );	
                float fDuration = RoundsToSeconds( nDuration );
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHold, oTarget, fDuration);
                //RunGrappleHold( oTarget, nDuration );
                int i;
                for ( i = 0; i <= nDuration; i++ )
                {
                    if ( !GetIsDead(OBJECT_SELF) && GetArea(oTarget) == GetArea(OBJECT_SELF) )
                    {
                        DelayCommand( RoundsToSeconds(i), RunGrappleHold(oTarget, nDuration, nMeta) );
                    }
                }
            }
        }
    }
}



int RunGrappleHit( object oTarget )
{
    int nCasterModifier = GetCasterAbilityModifier(OBJECT_SELF);
    int nCasterRoll = d20(1) + nCasterModifier + GetCasterLevel(OBJECT_SELF) + 12 + -1;
    int nTargetRoll = GetAC(oTarget)-GetItemACValue(GetItemInSlot(INVENTORY_SLOT_CHEST))-GetItemACValue(GetItemInSlot(INVENTORY_SLOT_NECK))-GetItemACValue(GetItemInSlot(INVENTORY_SLOT_ARMS))-GetItemACValue(GetItemInSlot(INVENTORY_SLOT_LEFTHAND))-GetItemACValue(GetItemInSlot(INVENTORY_SLOT_BELT));

    // * grapple HIT succesful,
    if (nCasterRoll >= nTargetRoll && !GetIsImmune(oTarget,IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE,OBJECT_SELF))
    {
        return TRUE;
    }
    return FALSE;
}

void RunGrappleHold( object oTarget, int nDuration, int nMeta )
{

    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    int nSpellID = 463;
    object oCaster = OBJECT_SELF;
    if (GZGetDelayedSpellEffectsExpired(nSpellID,oTarget,oCaster))
    {
        return;
    }
	
    int nCasterRoll;
    int nTargetRoll;
    int nCasterModifier = GetCasterAbilityModifier(OBJECT_SELF);
	
    nCasterRoll = d20(1) + nCasterModifier + GetCasterLevel(OBJECT_SELF) + 12 + 4;
    nTargetRoll = d20(1) + GetBaseAttackBonus(oTarget) + GetSizeModifier(oTarget) + GetAbilityModifier(ABILITY_STRENGTH, oTarget);

    if (nCasterRoll >= nTargetRoll && !GetIsImmune(oTarget,IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE,OBJECT_SELF))
    {    
        //effect eKnockdown = EffectParalyze();

        // creatures immune to paralzation are still prevented from moving
      /*  if (GetIsImmune(oTarget, IMMUNITY_TYPE_PARALYSIS) ||
        GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
        {
        	eKnockdown = EffectCutsceneImmobilize();
        }    */
        if(GetCreatureSize(oTarget)<=CREATURE_SIZE_HUGE) {
        effect eKnockdown = EffectLinkEffects(EffectSpellFailure(),EffectCutsceneImmobilize());
        eKnockdown=EffectLinkEffects(eKnockdown, EffectAttackDecrease(4));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, 6.0 );
    
        effect eHand = EffectVisualEffect(VFX_DUR_BIGBYS_CRUSHING_HAND);
        //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, 6.0 );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eHand, oTarget );}

        object oSelf = OBJECT_SELF;
        DelayCommand( 0.8, RunHandImpact(oTarget, oSelf, nDuration, nMeta ));
        FloatingTextStrRefOnCreature(2478, OBJECT_SELF);
    }	
    else
    {
        FloatingTextStrRefOnCreature(83309, OBJECT_SELF);
    }
}

void RunHandImpact(object oTarget, object oCaster, int nDuration, int nMeta )
{
if (!GetIsObjectValid(oTarget) || GetIsDead(oTarget) || 
    !GetIsObjectValid(oCaster) || GetIsDead(oCaster) || GetArea(oCaster)!=GetArea(oTarget))
    {
        return;
    }

   	int nDam = MaximizeOrEmpower(6,2,nMeta, 12);
   	effect eDam = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
   	effect eVis = EffectVisualEffect( VFX_HIT_SPELL_EVOCATION );
   	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
   	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    if(GetCreatureSize(oTarget)>CREATURE_SIZE_HUGE)
    {
       SendMessageToPC(oCaster, GetName(oTarget)+" is too large to grapple!");
    }
       //DelayCommand(6.0f,RunHandImpact(oTarget,oCaster, nDuration));

}