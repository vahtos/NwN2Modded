//::///////////////////////////////////////////////
//:: [Slay Living]
//:: [NW_S0_SlayLive.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Caster makes a touch attack and if the target
//:: fails a Fortitude save they die.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: January 22nd / 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: VFX Pass By: Preston W, On: June 25, 2001
/*

              Reeron modified on 3-13-07
              Now correctly calculates extra damage on critical hit.
              Respects immunity to critical hits.
              
              Reeron modified on 5-13-07
              Added sneak attack damage.
              
              Reeron modified on 10-21-07
              Added check for Weapon finesse feat on all
              melee touch attack spells. Added check for 
              point blank shot feat on all ranged touch 
              attack spells.

              Reeron modified on 10-21-07
              Now does extra damage if you have the (custom) feat 
              Melee Spell Specialization.

              Reeron modified on 6-15-09
              Updated for patch 1.22.5588

*/			  
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "Reeronspellinclude"
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


    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nDamage;
	int nDamage2;
    effect eDam;
    int nSpecDamage =0;
	
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
		if( GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
		{
			FloatingTextStrRefOnCreature(40105, OBJECT_SELF, FALSE);
			return;
		}
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SLAY_LIVING));
        int nmodifyattack;
        nmodifyattack=FINESSE(oTarget);
        //nmodifyattack=POINTBLANK(oTarget);
        int nTouch = TouchAttackMelee(oTarget,TRUE,nmodifyattack);
        //Make SR check
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
            //Make melee touch attack
            if (nTouch != TOUCH_ATTACK_RESULT_MISS)
            {
                //Make Fort save
                if  (!/*Fort Save*/ MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_DEATH))
                {
                    //Apply the death effect and VFX impact
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                }
                else
                {
                    if(GetHasFeat(2992,OBJECT_SELF))
                        {
                        nSpecDamage=SPECIALIZATION(3);
                        //FloatingTextStringOnCreature("*MeleeTouchAttack modified by Melee Spell Specialization!* Value of "+IntToString(nSpecDamage), OBJECT_SELF);
                        }
                    //Roll damage
                    nDamage = d6(3)+ nCasterLevel+nSpecDamage;
					nDamage2 = d6(3)+ nCasterLevel+nSpecDamage;
                    //Make metamagic checks
                    if (nMetaMagic == METAMAGIC_MAXIMIZE)
                    {
                        nDamage = 18 + nCasterLevel+nSpecDamage;
						nDamage2 = 18 + nCasterLevel+nSpecDamage;
                    }
                    if (nMetaMagic == METAMAGIC_EMPOWER)
                    {
                        nDamage = nDamage + (nDamage/2);
						nDamage2 = nDamage2 + (nDamage2/2);
                    }

					if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT, OBJECT_SELF))          { nDamage += nDamage2; }
					else        { nDamage = nDamage; }
                    nDamage=SNEAK(oTarget, nDamage);
                    //Apply damage effect and VFX impact
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                }
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }
}