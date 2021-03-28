//:://////////////////////////////////////////////////
//:: tob_i0_petrify based on X0_I0_PETRIFY
/*	Drammel's Note 2/4/2010: This is a copy of the original for use in the Tome of Battle.
	Using modified versions of the original files caues far too many compatibility issues,
	therefore a copy is made which is hooked into the relavent overriden files rather than
	the original.  Thus, I can use all the functionality of the original without worrying about
	recompiling errors into the original versions.
*/
/*
Small library for petrification-related functions. 
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/09/2002
//:://////////////////////////////////////////////////

/**********************************************************************
 * CONSTANTS
 **********************************************************************/


/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/


// Petrifies someone permanently (until depetrified)
// using the standard EffectPetrify effect. 
void Petrify(object oTarget);

// Removes a permanent petrification effect.
void Depetrify(object oTarget);

// Petrify something permanently using the barkskin texture instead of stone.
void PetrifyWood(object oTarget);

// Depetrify something turned to wood
void DepetrifyWood(object oTarget);

// Remove an effect of the given type
void RemoveEffectOfType(object oTarget, int nEffectType);

/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

// Petrifies someone permanently (until depetrified)
// using the standard EffectPetrify effect. 
void Petrify(object oTarget)
{
    effect ePetrify = EffectPetrify();
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePetrify, oTarget);
}
    

// Removes the petrification effect.
void Depetrify(object oTarget)
{
    RemoveEffectOfType(oTarget, EFFECT_TYPE_PETRIFY);
}

// Petrify something permanently using the barkskin texture instead of stone.
void PetrifyWood(object oTarget)
{
    effect eFreeze = EffectCutsceneParalyze();
    effect eBark = EffectVisualEffect(VFX_DUR_PROT_BARKSKIN);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFreeze, oTarget);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBark, oTarget);
}

// Depetrify something turned to wood
void DepetrifyWood(object oTarget)
{
    effect eBark = EffectVisualEffect(VFX_DUR_PROT_BARKSKIN);
    RemoveEffectOfType(oTarget, GetEffectType(eBark));
    RemoveEffectOfType(oTarget, EFFECT_TYPE_CUTSCENE_PARALYZE);
}

// Remove an effect of the given type
void RemoveEffectOfType(object oTarget, int nEffectType)
{
    effect eEff = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eEff)) {
        if ( GetEffectType(eEff) == nEffectType) { 
            RemoveEffect(oTarget, eEff);
        }
        eEff = GetNextEffect(oTarget);
    }
}

/*
void main() {}
/* */