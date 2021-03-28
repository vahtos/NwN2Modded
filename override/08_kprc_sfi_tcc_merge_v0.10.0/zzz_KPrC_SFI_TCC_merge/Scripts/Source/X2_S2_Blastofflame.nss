//::///////////////////////////////////////////////
//:: Blast of Flame
//:: X2_S2_Blastofflame
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// Created by Reeron on 3-18-08
//
// Flames fill the area, dealing 1d6 points of fire damage 
// per caster level (maximum 10d6) to any creature in the 
// area that fails its saving throw.
//
// Modified by Reeron on 3-31-08
// No longer damages caster by mistake.
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
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    float fDelay;
    location lTargetLocation = GetSpellTargetLocation();
	float fMaxDelay = 0.0f; // Used to determine duration of fire cone
    object oTarget;
    //Limit Caster level for the purposes of damage.
    if (nCasterLevel > 10)
    {
        nCasterLevel = 10;
    }
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && (oTarget!=OBJECT_SELF))
    	{


                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
                //Get the distance between the target and caster to delay the application of effects
                fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20.0;
				if (fDelay > fMaxDelay)
				{
					fMaxDelay = fDelay;
				}
                //Make SR check, and appropriate saving throw(s).

                    //Detemine damage
                    nDamage = d6(nCasterLevel);
        		    //Enter Metamagic conditions
        		    if (nMetaMagic == METAMAGIC_MAXIMIZE)
        		    {
        			     nDamage = 6 * nCasterLevel;//Damage is at max
        		    }
        		    else if (nMetaMagic == METAMAGIC_EMPOWER)
        		    {
        			     nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                    }
                    //Adjust damage according to Reflex Save, Evasion or Improved Evasion
                    nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);

                    // Apply effects to the currently selected target.
                    effect eFire = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
                    if(nDamage > 0)
                    {
                        //Apply delayed effects
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget));
                    }


        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
	fMaxDelay += 0.5f;
	effect eCone = EffectVisualEffect(VFX_DUR_CONE_FIRE);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, OBJECT_SELF, fMaxDelay);
}