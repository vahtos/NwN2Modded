//::///////////////////////////////////////////////
//:: Freezing Sphere
//:: X2_S2_FreezingSphere
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// Created by Reeron on 3-18-08
//
// A freezing sphere is a burst of cold that detonates
// and inflicts 1d6 points of damage per
// caster level (maximum of 15d6) to all creatures
// within the area. Unattended objects also take
// damage. The explosion creates almost no pressure.
//
// Reeron modified on 6-28-09
// Updated for patch 1.22.5588
//
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On: Oct 18 , 2000
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "x2_inc_spellhook"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-07-07 by Georg Zoeller
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
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    float fDelay;
    int nWe = 0; // Used for Water Elemental damage application. If nWe==1 apply d8 damage dice.
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ICE);
    effect eDam;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
    //Limit Caster level for the purposes of damage
    if (nCasterLvl > 15)
    {
        nCasterLvl = 15;
    }
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/10;
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {
                //Roll damage for each target
                nDamage = d6(nCasterLvl);
                int nApp= GetAppearanceType(oTarget);
                if(nApp==APPEARANCE_TYPE_ELEMENTAL_WATER_ELDER /*69*/|| nApp==APPEARANCE_TYPE_ELEMENTAL_WATER /*68*/ || nApp==560 || nApp==561)// Water Elemantals 560 and 561 are not listed in NWscript.nss
                    {
                    nDamage = d8(nCasterLvl); // Water Elementals take more damage.
                    nWe = 1; 
                    }
                //Resolve metamagic
                if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                    nDamage = 6 * nCasterLvl;
                    if (nWe==1)
                        {
                        nDamage = 8 * nCasterLvl; // Water Elementals take more damage.
                        }
                }
                else if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                    nDamage = nDamage + nDamage / 2;
                }
                //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_COLD);
                //Set the damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
                if(nDamage > 0)
                {
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the cold that erupts on the target not on the ground.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
             }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}