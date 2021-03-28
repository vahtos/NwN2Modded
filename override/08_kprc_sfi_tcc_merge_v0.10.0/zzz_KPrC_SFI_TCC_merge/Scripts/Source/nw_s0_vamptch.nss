//::///////////////////////////////////////////////
//:: Vampiric Touch
//:: NW_S0_VampTch
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    drain 1d6
    HP per 2 caster levels from the target.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 29, 2001
//:://////////////////////////////////////////////

/*
bugfix by Kovi 2002.07.22
- did double damage with maximize
- temporary hp was stacked
2002.08.25
- got temporary hp some immune creatures (Negative Energy Protection), lost
temporary hp against other resistant (SR, Shadow Shield)

Georg 2003-09-11
- Put in melee touch attack check, as the fixed attack bonus is now calculated correctly

//:://////////////////////////////////////////////



  Reeron modified on 3-23-2007					
  Added critical hit check. Correctly calculates extra damage on critical. Respects 
  immunity to criticals. Correctly caps max damage and max heal at max hp + 10 
  even on critical hit. Now uses correct calculation for maximized damage.


  Reeron modified on 4-27-2007                    
  Added sneak attack damage.
  
  Reeron modified on 5-13-07
  I changed NOTHING. Re-compiled script as it 
  wasn't working correctly.
  
  Reeron modified on 10-15-07
  Added check for Weapon finesse feat on all
  melee touch attack spell. Added check for 
  point blank shot feat on all ranged touch 
  attack spells. Now does extra damage if you 
  have the (custom) feat Melee Spell Specialization.

  Reeron modified on 6-15-09
  Updated for patch 1.22.5588

//:://////////////////////////////////////////////
*/


// (Update JLR - OEI 07/19/05) -- Changed Dmg to 1d8/per 2 lvls
// PKM-OEI 09.16.06 -- Reduced the damage back down to 1d6


#include "x0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "Reeronspellinclude"
void main()
{

    //--------------------------------------------------------------------------
    /*  Spellcast Hook Code
       Added 2003-06-20 by Georg
       If you want to make changes to all spells,
       check x2_inc_spellhook.nss to find out more
    */
    //--------------------------------------------------------------------------

    if (!X2PreSpellCastCode())
    {
        return;
    }
    //--------------------------------------------------------------------------
    // End of Spell Cast Hook
    //--------------------------------------------------------------------------

    object oTarget = GetSpellTargetObject();
    int nmodifyattack;
    nmodifyattack=FINESSE(oTarget);
    //nmodifyattack=POINTBLANK(oTarget);
    int nSpecDamage =0;
	// GZ: * GetSpellCastItem() == OBJECT_INVALID is used to prevent feedback from showing up when used as OnHitCastSpell property
	int touch=TouchAttackMelee(oTarget,GetSpellCastItem() == OBJECT_INVALID,nmodifyattack);
    int nMetaMagic = GetMetaMagicFeat();
    
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nDDice = nCasterLevel /2;
	
    if ((nDDice) == 0)
    {
        nDDice = 1;
    }
    //--------------------------------------------------------------------------
    // GZ: Cap according to the book
    //--------------------------------------------------------------------------
    else if (nDDice>10)
    {
        nDDice = 10;
    }

    int nDamage = d6(nDDice);  // JLR - OEI 07/19/05
	int nDamage2 = d6(nDDice);

    //--------------------------------------------------------------------------
    //Enter Metamagic conditions
    //--------------------------------------------------------------------------

    nDamage = MaximizeOrEmpower(6,nDDice,nMetaMagic);  // JLR - OEI 07/19/05
	nDamage2 = MaximizeOrEmpower(6,nDDice,nMetaMagic);
    if(GetHasFeat(2992,OBJECT_SELF))
        {
        nSpecDamage=SPECIALIZATION(nDDice);
        //FloatingTextStringOnCreature("*MeleeTouchAttack modified by Melee Spell Specialization!* Value of "+IntToString(nSpecDamage), OBJECT_SELF);
        }
    nDamage+=nSpecDamage;
    nDamage2+=nSpecDamage;
    
    int nDuration = nCasterLevel/2;

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration *= 2;
    }

    //--------------------------------------------------------------------------
    //Limit damage to max hp + 10
    //--------------------------------------------------------------------------
    int nMax = GetCurrentHitPoints(oTarget) + 10;

    if (touch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT, OBJECT_SELF)) {nDamage = nDamage + nDamage2;}
    else {nDamage = nDamage;}
    nDamage=SNEAK(oTarget, nDamage);
    if(nMax < nDamage)
    {
        nDamage = nMax;
    }
	
    effect eHeal = EffectTemporaryHitpoints(nDamage);

    effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
    effect eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_S);
    if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) &&
            GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD &&
            GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT &&
            !GetHasSpellEffect(SPELL_NEGATIVE_ENERGY_PROTECTION, oTarget))
        {


            SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_VAMPIRIC_TOUCH, FALSE));
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_VAMPIRIC_TOUCH, TRUE));
            // GZ: * GetSpellCastItem() == OBJECT_INVALID is used to prevent feedback from showing up when used as OnHitCastSpell property
            if (touch != TOUCH_ATTACK_RESULT_MISS)
            {
                if(MyResistSpell(OBJECT_SELF, oTarget) == 0)
				
                 {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, OBJECT_SELF);
                    RemoveTempHitPoints();
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHeal, OBJECT_SELF, HoursToSeconds(nDuration));
                 }
            }
        }
    }
}