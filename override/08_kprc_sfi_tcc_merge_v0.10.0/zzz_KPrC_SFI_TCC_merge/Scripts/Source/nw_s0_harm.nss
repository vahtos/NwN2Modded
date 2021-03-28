//::///////////////////////////////////////////////
//:: [Harm]
//:: [NW_S0_Harm.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Reduces target to 1d4 HP on successful touch
//:: attack.  If the target is undead it is healed.
//:://////////////////////////////////////////////
//:: Created By: Keith Soleski
//:: Created On: Jan 18, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: Aug 1, 2001
//:: Last Update: Georg Zoeller On: Oct 10, 2004
//:://////////////////////////////////////////////
//:: Update Pass By: Brock H. - OEI - 08/17/05
/*
    5.2.6.1.2	Harm
    This spell works very differently now. Negative energy deals 10 damage 
    per caster level (maximum 150). If the target makes a successful Will save, 
    they only take half damage and can’t be reduced below 1 hit point.
	
    Reeron modified on 3-17-07
    Spell now properly targets hostile creatures.
    Now does critical hits for extra damage. No change
    versus undead since it's not an attack. Therefore no 
    critical heal. Respects immunity to criticals. Can't 
    lower target's hitpoints to less than 1 per PnP.
    
    Reeron modified on 4-27-07
    Added sneak attack damage.

    Reeron modified on 6-25-09
    Updated for patch 1.22.5588

*/


#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 
#include "nwn2_inc_hlhrm"
#include "Reeronspellinclude"
void main()
{
	//SpawnScriptDebugger();

    if (!X2PreSpellCastCode())
    {
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }


    //Declare major variables
	object oCaster 	= OBJECT_SELF;
	object oTarget 	= GetSpellTargetObject();
	int CurHP = GetCurrentHitPoints(oTarget);
	int nSpellID = GetSpellId();
    //Check that the target is undead
    if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
    	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, FALSE));
    				HealTarget( oTarget, oCaster, SPELL_HARM );
		}
	else if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)) 
	/*{
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID));	
	HarmTarget( oTarget, oCaster, SPELL_HARM );
	}  */
	{
	int nTouch = TouchAttackMelee(oTarget);
	if (nTouch != TOUCH_ATTACK_RESULT_MISS )
	 {
	 if ( !MyResistSpell(oCaster, oTarget) )
        {
            // Let the Harming begin!
			int 	nCasterLevel 	= GetCasterLevel(oCaster);
			//int 	nDamageAmt		= ClampInt( 10*nCasterLevel, 0, 150 );
			int 	nDamageType;
			effect 	eVisual;
			int 	nDamageAmt;
			
			if ( nSpellID == SPELL_HARM ) 		nDamageType = DAMAGE_TYPE_NEGATIVE;
			else     							nDamageType = DAMAGE_TYPE_POSITIVE;
			
			if ( nSpellID == SPELL_HARM ) 	eVisual = EffectVisualEffect( VFX_HIT_SPELL_INFLICT_6 );
			else     						eVisual = EffectVisualEffect( VFX_IMP_HEALING_G );

            //Set damage
            //effect 	eDamage = EffectDamage( nDamageAmt, nDamageType );
			
            int nSave = WillSave(oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oCaster);
	
            if (nSave == 2)
            {
                return;
            }
            else if (nSave == 1)
            {   
               if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT, OBJECT_SELF))
               {
                nDamageAmt= ClampInt( 10*nCasterLevel, 0, 150 );
               }
               else
               {				
                nDamageAmt= ClampInt( 5*nCasterLevel, 0, 75 );
               }
               nDamageAmt=SNEAK(oTarget, nDamageAmt);   
               if(CurHP < nDamageAmt){ nDamageAmt= CurHP-1;}
				
               effect  eDamage = EffectDamage( nDamageAmt, nDamageType );
               ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
               ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
            }
            else
            {
                if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT, OBJECT_SELF))
                {
                nDamageAmt= ClampInt( 20*nCasterLevel, 0, 300 );
                }
                else
                {
                nDamageAmt= ClampInt( 10*nCasterLevel, 0, 150 );
                }
                nDamageAmt=SNEAK(oTarget, nDamageAmt);
                if(CurHP < nDamageAmt){ nDamageAmt= CurHP-1;}
				
                effect  eDamage = EffectDamage( nDamageAmt, nDamageType );
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
			}

        }
	  }
	} 

}