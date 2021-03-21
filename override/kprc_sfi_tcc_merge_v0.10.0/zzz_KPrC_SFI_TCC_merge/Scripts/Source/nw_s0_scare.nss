//::///////////////////////////////////////////////
//:: [Scare]
//:: [NW_S0_Scare.nss]
//:://////////////////////////////////////////////
/*
    Casts "Cause Fear" on multiple critters
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: June 11, 2005
//::
//::
//:: Reeron modified on 3-9-07
//:: On successful will save if creature has less than 6HD
//:: it is still shaken for 1 round as per PnP.
//:: 
//:: Reeron modified on 3-31-07
//:: Now affects multiple targets like it's supposed to.
//:: 
//:: Reeron modified on 7-5-07
//:: Changed Damage decrease to Skill decrease.
//:: Also changed saving throw decrease from will saves versus mind spells
//:: to all saves versus all types of spells as per PnP.
//::
//:: Reeron modified on 6-25-09
//:: Updated for patch 1.22.5588
//::
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: Modified March 2003 to give -2 attack and damage penalties

// JLR - OEI 08/23/05 -- Metamagic changes
#include "nwn2_inc_spells"

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
    object oTarget = GetSpellTargetObject();
    object oOrigTgt = oTarget;
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    float fDuration = RoundsToSeconds(nCasterLvl);
    int nNumTargets = (nCasterLvl / 3) + 1;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
    effect eScare = EffectFrightened();
    effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);
    //effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_CAUSE_FEAR );
    effect eSkillPenalty = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
    effect eAttackPenalty = EffectAttackDecrease(2, ATTACK_BONUS_MISC);
    //effect eLink = EffectLinkEffects(eMind, eScare);
    effect eLink2 = EffectLinkEffects(eSave, eDur);
    eLink2 = EffectLinkEffects(eLink2, eSkillPenalty);
    eLink2 = EffectLinkEffects(eLink2, eAttackPenalty);
    effect eLink  = eLink2;
    eLink2 = EffectLinkEffects(eLink2, eScare);

    //Do metamagic checks
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    // First, do the one we explicitly targeted, if any:
    if ( GetIsObjectValid(oTarget) )
        {
        //Check the Hit Dice of the creature
        if ((GetHitDice(oTarget) < 6) && GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
            {
            // * added rep check April 2003
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) == TRUE)
                {
                nNumTargets = nNumTargets - 1;

                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SCARE));
                //Make SR check
                if(!MyResistSpell(OBJECT_SELF, oTarget))
                    {
                    //Make Will save versus fear
                    if(!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FEAR))
                        {
                       
                        //Apply linked effects and VFX impact
                        //ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
                        ApplyEffectToObject(nDurType, eLink2, oTarget, fDuration);
                        }
                    else 
			    	    {
                    ApplyEffectToObject(nDurType, eLink, oTarget, RoundsToSeconds(1));
                        }
                    }
                }
            }
        }


    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget) && (nNumTargets > 0) )
        {
        effect eScare = EffectFrightened();
        effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);
        effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
        effect eSkillPenalty = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
        effect eAttackPenalty = EffectAttackDecrease(2, ATTACK_BONUS_MISC);
        //effect eLink = EffectLinkEffects(eMind, eScare);
        effect eLink2 = EffectLinkEffects(eSave, eMind);
        eLink2 = EffectLinkEffects(eLink2, eSkillPenalty);
        eLink2 = EffectLinkEffects(eLink2, eAttackPenalty);
        effect eLink  = eLink2;
        eLink2 = EffectLinkEffects(eLink2, eDur);
        eLink2 = EffectLinkEffects(eLink2, eScare);
						
        //Check the Hit Dice of the creature
        if ((GetHitDice(oTarget) < 6) && GetObjectType(oTarget) == OBJECT_TYPE_CREATURE && (oOrigTgt != oTarget))
            {
            // * added rep check April 2003
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) == TRUE)
                {
                nNumTargets = nNumTargets - 1;

                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SCARE));
                //Make SR check
                if(!MyResistSpell(OBJECT_SELF, oTarget))
                    {
                    //Make Will save versus fear
                    if(!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FEAR))
                        {
                       
                        //Apply linked effects and VFX impact
                        //ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
                        ApplyEffectToObject(nDurType, eLink2, oTarget, fDuration);
                        }
                    else 
				        {
                        ApplyEffectToObject(nDurType, eLink, oTarget, 6.0);
                        //ApplyEffectToObject(nDurType, eLink2, oTarget, 6.0);
                        }
                    }
                }
            }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}