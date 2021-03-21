//::///////////////////////////////////////////////
//:: Searing Light
//:: s_SearLght.nss
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Focusing holy power like a ray of the sun, you project
//:: a blast of light from your open palm. You must succeed
//:: at a ranged touch attack to strike your target. A creature
//:: struck by this ray of light suffers 1d8 points of damage
//:: per two caster levels (maximum 5d8). Undead creatures suffer
//:: 1d6 points of damage per caster level (maximum 10d6), and
//:: undead creatures particularly vulnerable to sunlight, such
//:: as vampires, suffer 1d8 points of damage per caster level
//:: (maximum 10d8). Constructs and inanimate objects suffer only
//:: 1d6 points of damage per two caster levels (maximum 5d6).
//:://////////////////////////////////////////////
//:: Created By: Keith Soleski
//:: Created On: 02/05/2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 25, 2001
//:: AFW-OEI 06/06/2006:
//::	Rays hit with ranged touch attacks
/*

          Reeron modified on 3-13-07
          Now correctly calculates extra damage on critical hit.
          Respects immunity to critical hits.
		  
          Reeron modified on 4-27-07
          Added sneak attack damage.
          
          Reeron modified on 5-13-07
          I changed NOTHING. Re-compiled script as it 
          wasn't working correctly.
          
          Reeron modified on 10-21-07
          Reworked touch attack routine being modified by PointBlankShot.

          Reeron modified on 10-21-07
          Now does extra damage if you have the (custom) feat 
          Ranged Spell Specialization.

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
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nTouch = TouchAttackRanged(oTarget);
	

    int nCasterLevel = GetCasterLevel(oCaster);
    if (nCasterLevel > 10)	 // Limit caster level
        nCasterLevel = 10;
    else if (nCasterLevel <= 0)
        nCasterLevel = 1;
			
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SEARING_LIGHT));
        int nmodifyattack;
        int nSpecDamage =0;
        //nmodifyattack=FINESSE(oTarget);
        nmodifyattack=POINTBLANK(oTarget);
        int touch=TouchAttackRanged(oTarget,TRUE,nmodifyattack);
        if (nTouch != TOUCH_ATTACK_RESULT_MISS)
	    {    //Make an SR Check
	        if (!MyResistSpell(oCaster, oTarget))
	        {
                int nDamage;
                int nDamage2;
                int nMax;
	            //Check for racial type undead
                if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
                {
                    if(GetHasFeat(2991,OBJECT_SELF))
                        {
                        nSpecDamage=SPECIALIZATION(nCasterLevel);
                        //FloatingTextStringOnCreature("*RangedTouchAttack modified by Ranged Spell Specialization!* Value of "+IntToString(nSpecDamage), OBJECT_SELF);
                        }
                    nDamage = d6(nCasterLevel)+nSpecDamage;
                    nMax = 6;

                }
	            //Check for racial type construct
	            else if (GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT)
	            {
	                nCasterLevel /= 2;
                    if(GetHasFeat(2991,OBJECT_SELF))
                        {
                        nSpecDamage=SPECIALIZATION(nCasterLevel);
                        //FloatingTextStringOnCreature("*RangedTouchAttack modified by Ranged Spell Specialization!* Value of "+IntToString(nSpecDamage), OBJECT_SELF);
                        }
                    nDamage = d6(nCasterLevel)+nSpecDamage;
	                nMax = 6;
	            }
	            else
	            {
	                nCasterLevel = nCasterLevel/2;
                    if(GetHasFeat(2991,OBJECT_SELF))
                        {
                        nSpecDamage=SPECIALIZATION(nCasterLevel);
                        //FloatingTextStringOnCreature("*RangedTouchAttack modified by Ranged Spell Specialization!* Value of "+IntToString(nSpecDamage), OBJECT_SELF);
                        }
	                nDamage = d8(nCasterLevel)+nSpecDamage;
					nDamage2 = d8(nCasterLevel)+nSpecDamage;
	                nMax = 8;
	            }
	
	            //Make metamagic checks
	            int nMetaMagic = GetMetaMagicFeat();
	            if (nMetaMagic == METAMAGIC_MAXIMIZE)
	            {
                    nDamage = nMax * nCasterLevel+nSpecDamage;
                    nDamage2 = nMax * nCasterLevel+nSpecDamage;
                }
                if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                 nDamage = nDamage + (nDamage/2);
                 nDamage2 = nDamage2 + (nDamage2/2);
                }
                if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT, OBJECT_SELF))          { nDamage = nDamage + nDamage2; }
                else        { nDamage = nDamage; }
                nDamage=SNEAK(oTarget, nDamage);
	            //Set the damage effect
                effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);
            	effect eVis = EffectVisualEffect( VFX_HIT_SPELL_SEARING_LIGHT );

	            //Apply the damage effect and VFX impact
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
	        }
		}
    }
    effect eRay = EffectBeam(VFX_BEAM_HOLY, OBJECT_SELF, BODY_NODE_HAND);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
}