//::///////////////////////////////////////////////
//:: [Shocking Grasp]
//:: [NW_S0_ShkngGrsp.nss]
//:://////////////////////////////////////////////
//:: 
//:: 
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: July 06, 2005
//:://////////////////////////////////////////////
//:: 
//:: Reeron modified on 3-13-07
//:: Now correctly calculates extra damage on critical hit.
//:: Respects immunity to critical hits.
//:: 
//:: Reeron modified on 4-27-07
//:: Added sneak attack damage
//::
//::     Reeron modified on 4-29-07
//::     Added check for Weapon finesse feat on all
//::     melee touch attack spell. Added check for 
//::     point blank shot feat on all ranged touch 
//::     attack spells.
//::
//::     Reeron modified on 10-12-07
//::     Reworked touch attack routine being modified by WeaponFinesse.
//::
//::     Reeron modified on 10-15-07
//::     Now does extra damage if you have the (custom) feat 
//::     Melee Spell Specialization.
//::     
//::     Reeron modified on 6-15-09
//::     Updated for patch 1.22.5588
//::
//:://////////////////////////////////////////////

// JLR - OEI 08/23/05 -- Metamagic changes
#include "nwn2_inc_spells"


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
    object oTarget = GetSpellTargetObject();
    int nmodifyattack;
    nmodifyattack=FINESSE(oTarget);
    //nmodifyattack=POINTBLANK(oTarget);
    int nDamage, nHeal;
    int nDamage2;
    int nSpecDamage =0;
    int nTouch = TouchAttackMelee(oTarget,TRUE,nmodifyattack);
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);	//VFX_IMP_HARM
    effect eRay = EffectBeam(VFX_BEAM_SHOCKING_GRASP, OBJECT_SELF, BODY_NODE_HAND);
    effect eDam;
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    if (nTouch != FALSE)  //GZ: Fixed boolean check to work in NWScript. 1 or 2 are valid return numbers from TouchAttackMelee
    {
    	  if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	  {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

            if (!MyResistSpell(OBJECT_SELF, oTarget))
            {   

                int nMaxLvl = nCasterLvl;
                if ( nMaxLvl > 5 )
                {
                    nMaxLvl = 5;
                }
                if(GetHasFeat(2992,OBJECT_SELF))
                    {
                    nSpecDamage=SPECIALIZATION(nMaxLvl);
                    //FloatingTextStringOnCreature("*MeleeTouchAttack modified by Melee Spell Specialization!* Value of "+IntToString(nSpecDamage), OBJECT_SELF);
                    }
                nDamage = d6(nMaxLvl);
				nDamage2 = d6(nMaxLvl);
                //Check for metamagic
                nDamage = ApplyMetamagicVariableMods(nDamage, nMaxLvl*6);
				nDamage2 = ApplyMetamagicVariableMods(nDamage2, nMaxLvl*6);
                nDamage+=nSpecDamage;
                nDamage2+=nSpecDamage;
				if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT, OBJECT_SELF))
                  {
                   nDamage = nDamage + nDamage2;
                  }
                else        { nDamage = nDamage; }
                nDamage=SNEAK(oTarget, nDamage);
                eDam = EffectDamage(nDamage,DAMAGE_TYPE_ELECTRICAL);

                //Apply the VFX impact and effects
                DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.0);
}