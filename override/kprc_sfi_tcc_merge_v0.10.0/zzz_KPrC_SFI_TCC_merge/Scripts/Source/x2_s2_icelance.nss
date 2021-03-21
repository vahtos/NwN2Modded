//::///////////////////////////////////////////////
//:: IceLance
//:: Created by Reeron on 4-1-08
//:://////////////////////////////////////////////
/*
    You must succeed on a ranged touch attack. If 
    you hit, the icelance deals 6d6 points of damage 
    to the target. Half of this damage is piercing 
    damage; the rest is cold damage. In addition, the 
    target must make a Fortitude save or be stunned 
    for 1d4 rounds.

    Reeron modified on 6-28-09
    Updated for patch 1.22.5588

*/
/////////////////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: 
//:: Reeron modifed on 4-1-08
//:: 
//:: Respects immunity to critical hits.
//:: Added sneak attack damage.
//:: Added check for point blank shot feat.
//:: Now does extra damage if you have the (custom) feat 
//:: Ranged Spell Specialization.
//::
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "x2_i0_spells"
#include "nw_i0_spells"
#include "Reeronspellinclude"

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
    effect eStun = EffectStunned();
    effect eDur = EffectVisualEffect( VFX_DUR_STUN );
    eStun = EffectLinkEffects( eStun, eDur );

    //--------------------------------------------------------------------------
    // Calculate the duration
    //--------------------------------------------------------------------------
    int nDuration = d4(1);
    int nMetaMagic = GetMetaMagicFeat();
    if (nDuration < 1)
        {
        nDuration = 1;
        }
    if (nMetaMagic == METAMAGIC_EXTEND)
        {
        nDuration = nDuration * 2;
        }


    //--------------------------------------------------------------------------
    // Setup VFX
    //--------------------------------------------------------------------------
    effect eVis      = EffectVisualEffect(VFX_HIT_SPELL_ICE);

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        int nmodifyattack;
        int nSpecDamage =0;
        nmodifyattack=POINTBLANK(oTarget);
        float fDist = GetDistanceToObject(oTarget);
        float fDelay = (fDist/25.0);//(3.0 * log(fDist) + 2.0);
        int touch=TouchAttackRanged(oTarget,TRUE,nmodifyattack);
        if (touch != TOUCH_ATTACK_RESULT_MISS)
            {
            if(!MyResistSpell(OBJECT_SELF, oTarget))
                {
                if(GetHasFeat(2991,OBJECT_SELF))
                    {
                    nSpecDamage=SPECIALIZATION(2);
                    //FloatingTextStringOnCreature("*RangedTouchAttack modified by Ranged Spell Specialization!* Value of "+IntToString(nSpecDamage), OBJECT_SELF);
                    }
                int nDamage = MaximizeOrEmpower(6,6,nMetaMagic)+nSpecDamage;
                if (touch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT, OBJECT_SELF))          { nDamage = MaximizeOrEmpower(6,12,nMetaMagic)+nSpecDamage*2; }
                else        { nDamage = nDamage; }
                nDamage=SNEAK(oTarget, nDamage);
                int nDamage2 = nDamage/2;
                int nDamage3 = nDamage-nDamage2;
                effect eDam1 = EffectDamage(nDamage2, DAMAGE_TYPE_PIERCING);
                effect eDam2 = EffectDamage(nDamage3, DAMAGE_TYPE_COLD);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam1, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam2, oTarget);
                if (!/*Fort Save*/ MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()))
                    {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(nDuration)));
                    }
                }
            }
        }
}