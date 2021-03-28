//::///////////////////////////////////////////////
//:: Combust
//:: X2_S0_Combust
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
   The initial eruption of flame causes  2d6 fire damage +1
   point per caster level(maximum +10)
   with no saving throw.

   Further, the creature must make
   a Reflex save or catch fire taking a further 1d6 points
   of damage. This will continue until the Reflex save is
   made.

   There is an undocumented artificial limit of
   10 + casterlevel rounds on this spell to prevent
   it from running indefinitly when used against
   fire resistant creatures with bad saving throws
   
   Reeron modified on 6-14-07
   Initial damage changed to 1d8/level (max level=10).
   
   Reeron modified on 6-19-07
   Changed secondary damage to equal PnP damage of 1d6 per round.
   
   Reeron modified on 6-22-07
   Changed secondary save to a set Reflex 15 as per PnP.
   
   Reeron modified on 12-9-07
   Added in missing Melee Touch Attack roll. Now correctly 
   calculates extra damage on a critical hit. Respects immunity 
   to critical hits. Added sneak attack damage. Added check for 
   Weapon finesse feat on all melee touch attack spell. Added 
   check for point blank shot feat on all ranged touch attack spells. 
   Now does extra damage if you have the (custom) feat Melee Spell Specialization.

   Reeron modified on 6-28-09
   Updated for patch 1.22.5588

*/
//:://////////////////////////////////////////////
// Created: 2003/09/05 Georg Zoeller
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
// Modified: 8/16/06 - BDF-OEI: updated the target validity check 
//:://////////////////////////////////////////////

#include "x2_I0_SPELLS"
#include "x2_inc_toollib"
#include "x2_inc_spellhook"
#include "Reeronspellinclude"

void RunCombustImpact(object oTarget, object oCaster, int nLevel, int nMetaMagic);

void main()
{

    object oTarget = GetSpellTargetObject();
    object oCaster = OBJECT_SELF;
    int nmodifyattack;


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

    //--------------------------------------------------------------------------
    // Calculate the save DC
    //--------------------------------------------------------------------------
    //int nDC = GetSpellSaveDC();
    int nLevel = GetCasterLevel(OBJECT_SELF);
    int nDamage;
    int nDamage2;
    nmodifyattack=FINESSE(oTarget);
    int nSpecDamage =0;
    int nTouch = TouchAttackMelee(oTarget,TRUE,nmodifyattack);


    //--------------------------------------------------------------------------
    // Calculate the damage, 1d8/casterlevel, capped at 10
    //--------------------------------------------------------------------------
    //int nDamage = GetCasterLevel(OBJECT_SELF);
    if (nLevel > 10)
    {
        nLevel = 10;
    }
    if(GetHasFeat(2992,OBJECT_SELF))
        {
        nSpecDamage=SPECIALIZATION(1);
        //FloatingTextStringOnCreature("*MeleeTouchAttack modified by Melee Spell Specialization!* Value of "+IntToString(nSpecDamage), OBJECT_SELF);
        }
    int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        //nDamage += 12;//Damage is at max
        nDamage = 8 * nLevel;//Damage is at max
        nDamage2 = 8 * nLevel;//Damage is at max
    }
    else
    {
        //nDamage  += d6(2);
        nDamage  = d8(nLevel);
        nDamage2  = d8(nLevel);
        if (nMetaMagic == METAMAGIC_EMPOWER)
        {
            nDamage = nDamage + (nDamage/2);//Damage/Healing is +50%
            nDamage2 = nDamage2 + (nDamage2/2);//Damage/Healing is +50%
        }
    }
    nDamage+=nSpecDamage;
    nDamage2+=nSpecDamage;
    if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT, OBJECT_SELF))
    {
    nDamage = nDamage + nDamage2;
    }
    else        { nDamage = nDamage; }
    nDamage=SNEAK(oTarget, nDamage);

    //--------------------------------------------------------------------------
    // Calculate the duration (we need a duration or bad things would happen
    // if someone is immune to fire but fails his safe all the time)
    //--------------------------------------------------------------------------
    int nDuration = 10 + GetCasterLevel(OBJECT_SELF);
    if (nDuration < 1)
    {
        nDuration = 10;
    }

    //--------------------------------------------------------------------------
    // Setup Effects
    //--------------------------------------------------------------------------
    effect eDam      = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
    effect eVis      = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
	effect eVis2	= EffectVisualEffect(VFX_DUR_FIRE);
	effect eHit = EffectLinkEffects(eDam, eVis);

    //if(!GetIsReactionTypeFriendly(oTarget))	// BDF: obsolete conditional
    if (nTouch != FALSE)
    {
    if ( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) )
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

       //-----------------------------------------------------------------------
       // Check SR
       //-----------------------------------------------------------------------
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
            //------------------------------------------------------------------
            // This spell no longer stacks. If there is one of that type,
            // that's enough
            //------------------------------------------------------------------
            if (GetHasSpellEffect(GetSpellId(),oTarget) || GetHasSpellEffect(SPELL_INFERNO,oTarget)  )
            {
                FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
                return;
            }


           //-------------------------------------------------------------------
           // Apply VFX
           //-------------------------------------------------------------------
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis2, oTarget, RoundsToSeconds(nDuration));
            TLVFXPillar(VFX_HIT_SPELL_EVOCATION, GetLocation(oTarget), 5, 0.1f,0.0f, 2.0f);



            //------------------------------------------------------------------
            // Save the spell save DC as a variable for later retrieval
            //------------------------------------------------------------------
            //SetLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (SPELL_COMBUST), nDC);

            //------------------------------------------------------------------
            // Tick damage after 6 seconds again
            //------------------------------------------------------------------
            DelayCommand(6.0, RunCombustImpact(oTarget,oCaster,nLevel, nMetaMagic));
        }
    }
    }
	
}

void RunCombustImpact(object oTarget, object oCaster, int nLevel, int nMetaMagic)
{
     //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    if (GZGetDelayedSpellEffectsExpired(SPELL_COMBUST,oTarget,oCaster))
    {
        return;
    }

    if (GetIsDead(oTarget) == FALSE)
    {

        //int nDC = GetLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (SPELL_COMBUST));
        int nDC = 15;

        if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_FIRE))
        {
            //------------------------------------------------------------------
            // Calculate the damage, 1d6 + casterlevel, capped at +10
            //------------------------------------------------------------------
            //int nDamage = nLevel;
            int nDamage = d6();
            /*if (nDamage > 10)
            {
                nDamage = 10;
            }*/
            if (nMetaMagic == METAMAGIC_MAXIMIZE)
            {
                //nDamage += 6;
                nDamage = 6;
            }
            else if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                    nDamage = nDamage + (nDamage/2);
                }

            effect eDmg = EffectDamage(nDamage,DAMAGE_TYPE_FIRE);
            effect eVFX = EffectVisualEffect(VFX_HIT_SPELL_FIRE);

            ApplyEffectToObject(DURATION_TYPE_INSTANT,eDmg,oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eVFX,oTarget);

            //------------------------------------------------------------------
            // After six seconds (1 round), check damage again
            //------------------------------------------------------------------
            DelayCommand(6.0f,RunCombustImpact(oTarget,oCaster, nLevel,nMetaMagic));
        }
        else
        {
            //DeleteLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (SPELL_COMBUST));
            GZRemoveSpellEffects(SPELL_COMBUST, oTarget);
        }

   }

}