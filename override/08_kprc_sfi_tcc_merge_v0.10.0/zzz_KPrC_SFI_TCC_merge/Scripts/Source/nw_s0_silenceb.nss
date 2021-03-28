//::///////////////////////////////////////////////
//:: Silence: On Exit
//:: NW_S0_SilenceB.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The target is surrounded by a zone of silence
    that allows them to move without sound.  Spell
    casters caught in this area will be unable to cast
    spells.

    Reeron modified on 4-10-08
    Now takes into account spell-radial versions.

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{
    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    int bValid = FALSE;
    effect eAOE;

    if ( GetHasSpellEffect(SPELL_SILENCE, oTarget) || GetHasSpellEffect(2208, oTarget) || GetHasSpellEffect(2209, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect( oTarget );
        while ( GetIsEffectValid(eAOE) && bValid == FALSE )
        {
            if ( GetEffectCreator(eAOE) == GetAreaOfEffectCreator() )
            {
                //if ( GetEffectType(eAOE) == EFFECT_TYPE_SILENCE )
                {
                    //If the effect was created by the Silence then remove it
                    if ( GetEffectSpellId(eAOE) == SPELL_SILENCE || GetEffectSpellId(eAOE) == 2208 || GetEffectSpellId(eAOE) == 2209)
                    {
                        //AssignAOEDebugString("Removing Effects");
                        RemoveEffect( oTarget, eAOE );
                        bValid = TRUE;
                    }
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect( oTarget );
        }
    }
}