//::///////////////////////////////////////////////
//:: Bigby's Grasping Hand
//:: [x0_s0_bigby3]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*  

    Reeron modified 3-25-07
    Checks to see if the target is under the effects of 
    another Bigby's spell. If it is, this spell will not have an effect.
	
    Makes a grapple check. If succesful target is held for 1 round/level.
    Can't affect a creature who is bigger than HUGE.
    Removes armor bonus from chest slot, armor bonus from bracers
    or gauntlets, natural armor bonus from amulets, shield bonus from an equipped shield, 
    and armor bonus from belts. By doing this it more closely simulates a melee touch attack 
    which doesn't allow	your armor bonus, natural armor bonus, or shield bonus.
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
//:: PKM-OEI- 08.18.06 - Old spell commented out, new spell based on bigby 5

#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "x2_i0_spells"

int nSpellID = GetSpellId();	// 11/09/06 - BDF(OEI): let's use GetSpellID() instead
int RunGrappleHit( object oTarget, int level);
int RunGrappleHold( object oTarget, int level);
void RunHandImpact(object oTarget, object oCaster, int nMeta, int nDuration, int handstate, int level);
int AlreadyBigby(object oTarget)
{
    if(!GetIsObjectValid(oTarget) || GetHasSpellEffect(SPELL_BIGBYS_INTERPOSING_HAND, oTarget) ||
        GetHasSpellEffect(SPELL_BIGBYS_FORCEFUL_HAND, oTarget) ||
        GetHasSpellEffect(SPELL_BIGBYS_GRASPING_HAND, oTarget) ||
        GetHasSpellEffect(SPELL_BIGBYS_CLENCHED_FIST, oTarget) ||
        GetHasSpellEffect(SPELL_BIGBYS_CRUSHING_HAND, oTarget))
        return 1;
    return 0;
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

    //--------------------------------------------------------------------------
    // This spell no longer stacks. If there is one hand, that's enough
    //--------------------------------------------------------------------------
    //if (GetHasSpellEffect(nSpellID,oTarget) ||  GetHasSpellEffect(461,oTarget)  )
    if (GetHasSpellEffect(nSpellID,oTarget) ||  GetHasSpellEffect(461,oTarget)  )
    {
        FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
        return;
    }
    if(AlreadyBigby(oTarget))
    {
        SendMessageToPC(OBJECT_SELF, "That target is already being assaulted by a hand of force!");
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
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, TRUE));

        //SR
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
            // * grapple HIT succesful,
            //if (RunGrappleHit( oTarget ))
            //{			
                effect eHold =EffectVisualEffect( VFX_DUR_PARALYZED );
                float fDuration = RoundsToSeconds( nDuration );
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHold, oTarget, fDuration);
                //RunGrappleHold( oTarget, nDuration );
                //int i;
                //for ( i = 0; i <= nDuration; i++ )
                //{
                    //if ( !GetIsDead(OBJECT_SELF) && GetArea(oTarget) == GetArea(OBJECT_SELF) )
                    //{
                        //DelayCommand( RoundsToSeconds(i), RunGrappleHold(oTarget, nDuration) );
                    //}
                //}
            //}
            if(GetCreatureSize(oTarget)>CREATURE_SIZE_HUGE)
                SendMessageToPC(OBJECT_SELF, "That creature is too large to grapple!");
            else
                RunHandImpact(oTarget, OBJECT_SELF, nMeta, nDuration, 0, GetCasterLevel(OBJECT_SELF));
        }
    }
}

int RunGrappleHit( object oTarget, int level)
{
    int nCasterModifier = GetCasterAbilityModifier(OBJECT_SELF) + level + 10 -1;
    int nCasterRoll = d20(1);
    int nTargetRoll = GetAC(oTarget)-GetItemACValue(GetItemInSlot(INVENTORY_SLOT_CHEST))-GetItemACValue(GetItemInSlot(INVENTORY_SLOT_NECK))-GetItemACValue(GetItemInSlot(INVENTORY_SLOT_ARMS))-GetItemACValue(GetItemInSlot(INVENTORY_SLOT_LEFTHAND))-GetItemACValue(GetItemInSlot(INVENTORY_SLOT_BELT));
    string feedback="Your grasping hand attempts to grapple "+GetName(oTarget);
    feedback+=": "+IntToString(nCasterRoll);
    feedback+="+"+IntToString(nCasterModifier); 
    if((nCasterRoll==20 || nCasterRoll+nCasterModifier>=nTargetRoll) && !GetIsImmune(oTarget,IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE,OBJECT_SELF))
    {
        feedback+=" -> HIT";
        SendMessageToPC(OBJECT_SELF, feedback);
        nCasterModifier+=5;
        nCasterRoll=d20();
        nTargetRoll=d20()+GetBaseAttackBonus(oTarget)+GetSizeModifier(oTarget)+ GetAbilityModifier(ABILITY_STRENGTH, oTarget);
        feedback="Opposed grapple check: "+IntToString(nCasterRoll)+"+"+IntToString(nCasterModifier);
        if((nCasterRoll==20 || nCasterRoll+nCasterModifier>=nTargetRoll) && !GetIsImmune(oTarget,IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE,OBJECT_SELF))
        {
            feedback+=" -> SUCCESS";
            SendMessageToPC(OBJECT_SELF, feedback);
            SendMessageToPC(oTarget, GetName(OBJECT_SELF)+"'s grasping hand grapples you!");
            //FloatingTextStrRefOnCreature(2478, OBJECT_SELF);
            return TRUE;
        }
        feedback+=" -> FAILURE";
    }
    else feedback+=" -> MISS";
    SendMessageToPC(OBJECT_SELF, feedback);
    //FloatingTextStrRefOnCreature(83309, OBJECT_SELF);
    return FALSE;
}

int RunGrappleHold( object oTarget, int level)
{
    int nCasterRoll= d20(1);
    int nTargetRoll= d20(1)+ GetBaseAttackBonus(oTarget)+GetSizeModifier(oTarget) + GetAbilityModifier(ABILITY_STRENGTH, oTarget);
    int nCasterModifier = GetCasterAbilityModifier(OBJECT_SELF)	+ level + 10 + 4;
    string feedback="Your grasping hand grapples "+GetName(oTarget);
    feedback+=", opposed check: "+IntToString(nCasterRoll)+"+"+IntToString(nCasterModifier);
    if((nCasterRoll==20 || nCasterRoll+nCasterModifier>=nTargetRoll) && !GetIsImmune(oTarget,IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE,OBJECT_SELF))
    {    
        feedback+=" -> SUCCESS";
        SendMessageToPC(oTarget, GetName(OBJECT_SELF)+"'s grasping hand grapples you!");
        SendMessageToPC(OBJECT_SELF, feedback);
        //FloatingTextStrRefOnCreature(2478, OBJECT_SELF);
        return TRUE;
    }
    feedback+=" -> FAILURE";
    SendMessageToPC(OBJECT_SELF, feedback);
    //FloatingTextStrRefOnCreature(83309, OBJECT_SELF);
    return FALSE;
}

void RunHandImpact(object oTarget, object oCaster, int nMeta, int nDuration, int handstate, int level)
{
    if (!GetIsObjectValid(oTarget) || GetIsDead(oTarget) || 
    !GetIsObjectValid(oCaster) || GetIsDead(oCaster) || GetArea(oCaster)!=GetArea(oTarget) ||
    GZGetDelayedSpellEffectsExpired(nSpellID,oTarget,oCaster) || nDuration<1)
    {
        return;
    }
    if(GetCreatureSize(oTarget)>CREATURE_SIZE_HUGE)
    {
        SendMessageToPC(oCaster, GetName(oTarget)+" is too large to grapple!");
    }
    if(!handstate) handstate=RunGrappleHit(oTarget, level);
    else handstate=RunGrappleHold(oTarget, level);
    if(handstate)
    {
        if(GetCreatureSize(oTarget)<=CREATURE_SIZE_HUGE)
        {
            effect eKnockdown = EffectLinkEffects(EffectSpellFailure(),EffectCutsceneImmobilize());
            eKnockdown=EffectLinkEffects(eKnockdown, EffectAttackDecrease(4));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, 6.0 );
        }
    }
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_BIGBYS_GRASPING_HAND), oTarget );
    nDuration--;
    if(nDuration>=1)
    {
        DelayCommand(6.0f,RunHandImpact(oTarget, oCaster, nMeta, nDuration, handstate, level));
    }

}