//::///////////////////////////////////////////////
//:: Melf's Acid Arrow
//:: MelfsAcidArrow.nss
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
    An acidic arrow springs from the caster's hands
    and does 3d6 acid damage to the target.  For
    every 3 levels the caster has the target takes an
    additional 1d6 per round.
*/
/////////////////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Aidan Scanlan
//:: Created On: 01/09/01
//:://////////////////////////////////////////////
//:: Rewritten: Georg Zoeller, Oct 29, 2003
//:: Now uses VFX to track its own duration, cutting
//:: down the impact on the CPU to 1/6th
//:://////////////////////////////////////////////
//:: AFW-OEI 06/06/2006:
//::	Require ranged touch attack to hit.
//::
//::
//:: Reeron modifed on 3-13-07
//:: Now correctly calculates extra damage on critical hit.
//:: Respects immunity to critical hits.
//:: Only does critical on initial round.
//:: No spell resistance as per PnP.
//:: Does correct damage per round.
//:: 
//:: Reeron modified on 4-27-07
//:: Added sneak attack damage.
//:: Correctly made the spell not stack anymore.
//::
//:: Reeron modified on 5-13-07
//:: I changed NOTHING. Re-compiled script as it
//:: wasn't working correctly.
//:: 
//:: Reeron modified on 5-24-07
//:: Fixed stacking issues. You can (as it should be)
//:: stack this spell now. It keeps track of each 
//:: arrow's duration individually. A miss doesn't 
//:: cancel all other arrow's effects anymore.
//:: 
//:: Reeron modified on 10-21-07
//:: Added check for Weapon finesse feat on all melee touch 
//:: attack spells. Added check for point blank shot feat on 
//:: all ranged touch attack spells.
//::
//:: Reeron modified on 10-21-07
//:: Now does extra damage if you have the (custom) feat 
//:: Ranged Spell Specialization.
//::
//:: Reeron modified on 4-4-08
//:: Sneak attack function now takes into account concealment.
//:: Sneak attack function now takes into account being pinned (simulated by 
//:: Cutscene Immobilize). Cutscene Immobilize from the spell "Grease" 
//:: doesn't count towards being pinned.
//::
//:: Reeron modified on 6-15-09
//:: Updated for patch 1.22.5588
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "x2_i0_spells"
#include "nw_i0_spells"
#include "Reeronspellinclude"
void RunImpact(object oTarget, object oCaster, int nMetamagic, int nRounds);
int nRounds;
void main()
{
    object oTarget = GetSpellTargetObject();

    //--------------------------------------------------------------------------
    // Spellcast Hook Code
    // Added 2003-06-20 by Georg
    // If you want to make changes to all spells, check x2_inc_spellhook.nss to
    // find out more
    //--------------------------------------------------------------------------
    if (!X2PreSpellCastCode())
    {
        return;
    }
    // End of Spell Cast Hook
    effect eDur      = EffectVisualEffect(VFX_DUR_SPELL_MELFS_ACID_ARROW);
    //--------------------------------------------------------------------------
    // This spell no longer stacks. If there is one of that type, thats ok
    //--------------------------------------------------------------------------
/*    if (GetHasSpellEffect(GetSpellId(),oTarget))
    {
        //RemoveSpellEffects(GetSpellId(), OBJECT_SELF, oTarget);
        FloatingTextStringOnCreature("*That target is already affected by an Acid Arrow effect!*", OBJECT_SELF);
        return;
    }  */

    //--------------------------------------------------------------------------
    // Calculate the duration
    //--------------------------------------------------------------------------
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = (GetCasterLevel(OBJECT_SELF)/3);

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
       nDuration = nDuration * 2;
    }

    if (nDuration < 1)
    {
        nDuration = 1;
    }
    nRounds = nDuration;

    //--------------------------------------------------------------------------
    // Setup VFX
    //--------------------------------------------------------------------------
    effect eVis      = EffectVisualEffect(VFX_HIT_SPELL_ACID);
    //effect eDur      = EffectVisualEffect(VFX_DUR_SPELL_MELFS_ACID_ARROW);
    //effect eArrow = EffectVisualEffect(245);


    //--------------------------------------------------------------------------
    // Set the VFX to be non dispelable, because the acid is not magic
    //--------------------------------------------------------------------------
    eDur = ExtraordinaryEffect(eDur);
     // * Dec 2003- added the reaction check back in
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        int nmodifyattack;
        int nSpecDamage =0;
        //nmodifyattack=FINESSE(oTarget);
        nmodifyattack=POINTBLANK(oTarget);
        float fDist = GetDistanceToObject(oTarget);
        float fDelay = (fDist/25.0);//(3.0 * log(fDist) + 2.0);
        int touch=TouchAttackRanged(oTarget,TRUE,nmodifyattack);
		if (touch != TOUCH_ATTACK_RESULT_MISS)
		{
	        //if(MyResistSpell(OBJECT_SELF, oTarget) == FALSE)
	        {
	            //----------------------------------------------------------------------
	            // Do the initial 3d6 points of damage
	            //----------------------------------------------------------------------
                if(GetHasFeat(2991,OBJECT_SELF))
                    {
                    nSpecDamage=SPECIALIZATION(2);
                    //FloatingTextStringOnCreature("*RangedTouchAttack modified by Ranged Spell Specialization!* Value of "+IntToString(nSpecDamage), OBJECT_SELF);
                    }
				int nDamage = MaximizeOrEmpower(4,2,nMetaMagic)+nSpecDamage;
				if (touch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT, OBJECT_SELF))          { nDamage = MaximizeOrEmpower(4,4,nMetaMagic)+nSpecDamage*2; }
				else        { nDamage = nDamage; }
                nDamage=SNEAK(oTarget, nDamage);
	            effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);	            
				//DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	            //DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
	
	            //----------------------------------------------------------------------
	            // Apply the VFX that is used to track the spells duration
	            //----------------------------------------------------------------------
	            //DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDur,oTarget,RoundsToSeconds(nDuration)));
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDur,oTarget,RoundsToSeconds(nDuration));
	            object oSelf = OBJECT_SELF; // because OBJECT_SELF is a function
	            DelayCommand(5.0f,RunImpact(oTarget, oSelf,nMetaMagic,nRounds));
	        }
	       // else remove the double slashes from lines 94,115,116,120,121,122
	       // {
	            //----------------------------------------------------------------------
	            // Indicate Failure
	            //----------------------------------------------------------------------
	           // effect eSmoke = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);
	           // DelayCommand(fDelay+0.1f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eSmoke,oTarget));
	       // }
		}
    }
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eArrow, oTarget);

}


void RunImpact(object oTarget, object oCaster, int nMetaMagic, int nRounds)
{
    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    if (GZGetDelayedSpellEffectsExpired(SPELL_MELFS_ACID_ARROW,oTarget,oCaster))
    {
        return;
    }

    if (GetIsDead(oTarget) == FALSE)
    {
        //----------------------------------------------------------------------
        // Calculate Damage
        //----------------------------------------------------------------------
        int nDamage = MaximizeOrEmpower(4,2,nMetaMagic);
        effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
        effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ACID);
        eDam = EffectLinkEffects(eVis,eDam); // flare up
        ApplyEffectToObject (DURATION_TYPE_INSTANT,eDam,oTarget);
        nRounds-=1;
        if (nRounds>0)
        {
        DelayCommand(6.0f,RunImpact(oTarget,oCaster,nMetaMagic,nRounds));
        }
        
    }
}