//::///////////////////////////////////////////////
//:: Negative Energy Burst
//:: NW_S0_NegBurst
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The caster releases a burst of negative energy
    at a specified point doing 1d8 + 1 / level
    negative energy damage.

    Reeron modified on 1-18-08
    Spell was enabled. Added a visual effect for the 
    strength-drain that gets applied to non-undead.
    
    Reeron modified on 1-19-08
    Added feedback if target is immune to strength-drain effect.
    Capped at 20 levels.
    
    Reeron modified on 10-6-08
    Corrected scripting error where Undead would make a save and 
    get healed for only half the amount. Targets now take damage 
    immediately instead of having a small delay before the spell 
    affects them.

    Reeron modified on 5-4-09
    Updated for patch 1.22.5588

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 13, 2001
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 

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


    //Declare major variables
    object oCaster = OBJECT_SELF;
    int nCasterLvl = GetCasterLevel(oCaster);
    if (nCasterLvl > 20) {nCasterLvl = 20;}
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    float fDelay;
    float fDelay2;
    effect eExplode = EffectVisualEffect(VFX_FNF_LOS_EVIL_20); //Replace with Negative Pulse
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_M);
    effect eDam, eHeal;
    int nStr = nCasterLvl / 4;
    if (nStr == 0)
    {
        nStr = 1;
    }
    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, nStr);
    effect eStr_Low = EffectAbilityDecrease(ABILITY_STRENGTH, nStr);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur3 = EffectVisualEffect( VFX_DUR_SPELL_RAY_ENFEEBLE );
    
    effect eGood = EffectLinkEffects(eStr, eDur);
    effect eBad = EffectLinkEffects(eStr_Low, eDur2);

    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
    //Apply the explosion at the location captured above.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
       if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
       {
            //Roll damage for each target
            nDamage = d8() + nCasterLvl;
            //Resolve metamagic
    	    if (nMetaMagic == METAMAGIC_MAXIMIZE)
            {
                nDamage = 8 + nCasterLvl;
            }
    	        else if (nMetaMagic == METAMAGIC_EMPOWER)
            {
               nDamage = nDamage + (nDamage / 2);
            }
            if((GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)&&(MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NEGATIVE, OBJECT_SELF, fDelay)))
            {
                nDamage /= 2;
            }
            //Get the distance between the explosion and the target to calculate delay
            //fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
            fDelay = 0.0f; // Removed delay as it could be quite long. - Reeron
            //fDelay2 = fDelay + 1.5f;
            fDelay2 = fDelay + 0.1f; // Removed most of the delay as it was quite long. - Reeron

            // * any undead should be healed, not just Friendlies
        	if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
        	{
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_BURST, FALSE));
                //Set the heal effect
                eHeal = EffectHeal(nDamage);
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
                //This visual effect is applied to the target object not the location as above.  This visual effect
                //represents the flame that erupts on the target not on the ground.
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGood, oTarget));
            }
            else if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        	{
                if(GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
                {
                    if(!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            	    {
                        //Fire cast spell at event for the specified target
                        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_BURST));
                        //Set the damage effect
                        eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
                        // Apply effects to the currently selected target.
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                        //This visual effect is applied to the target object not the location as above.  This visual effect
                        //represents the flame that erupts on the target not on the ground.
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBad, oTarget));
                        if (!GetIsImmune(oTarget, IMMUNITY_TYPE_ABILITY_DECREASE, OBJECT_SELF))
                            {
                            DelayCommand(fDelay2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDur3, oTarget));
                            }
                        else {FloatingTextStringOnCreature("Target is Immune to Strength-drain!", oTarget, TRUE, 2.0f);}
                    }
                }
            }
        }

       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget);
    }
}