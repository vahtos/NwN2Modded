//::///////////////////////////////////////////////
//:: Mind Fog: On Enter
//:: NW_S0_MindFogA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a bank of fog that lowers the Will save
    of all creatures within who fail a Will Save by
    -10.  Affect lasts for 2d6 rounds after leaving
    the fog
	
    Reeron modified on 4-16-07
    Now takes into account ranks in spellcraft. 
    Immunity to Mind Spells now works correctly.
    
    Reeron modified on 1-19-08
    Now applies -10 penalty to wisdom-related skills as per PnP.
    
    Reeron modified on 1-24-08
    Immunity feedback message now takes into account Protection from Good/Evil.

    Reeron modified on 6-25-09
    Updated for patch 1.22.5588

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 1, 2001
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"

int nDC= GetSpellSaveDC();

void main()
{

    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_MIND_FOG_VIC );
    effect eLower = EffectSavingThrowDecrease(SAVING_THROW_WILL, 10);
    effect eSkill1 = EffectSkillDecrease(SKILL_HEAL , 10);
    effect eSkill2 = EffectSkillDecrease(SKILL_LISTEN , 10);
    effect eSkill3 = EffectSkillDecrease(SKILL_SPOT , 10);
    effect eSkill4 = EffectSkillDecrease(SKILL_SURVIVAL , 10);
    effect eLink = EffectLinkEffects(eVis, eLower);
    eLink = EffectLinkEffects(eLink, eSkill1);
    eLink = EffectLinkEffects (eLink, eSkill2);
    eLink = EffectLinkEffects(eLink, eSkill3);
    eLink = EffectLinkEffects(eLink, eSkill4);
    int bValid = FALSE;
    float fDelay = GetRandomDelay(1.0, 2.2);
    object oCreator= GetAreaOfEffectCreator();
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MIND_FOG));
        //Make SR check
        effect eAOE = GetFirstEffect(oTarget);
        if(GetHasSpellEffect(SPELL_MIND_FOG, oTarget))
        {
            while (GetIsEffectValid(eAOE))
            {
                //If the effect was created by the Mind_Fog then remove it
                if (GetEffectSpellId(eAOE) == SPELL_MIND_FOG && GetAreaOfEffectCreator() == GetEffectCreator(eAOE))
                {
                    if(GetEffectType(eAOE) == EFFECT_TYPE_SAVING_THROW_DECREASE)
                    {
                        RemoveEffect(oTarget, eAOE);
                        bValid = TRUE;
                    }
                }
                //Get the next effect on the creation
                eAOE = GetNextEffect(oTarget);
            }
        //Check if the effect has been put on the creature already.  If no, then save again
        //If yes, apply without a save.
        }
        if(bValid == FALSE)
        {
            if(!MyResistSpell(OBJECT_SELF, oTarget))
            {
                    int nSave;
                    object oTarget2 = GetFactionLeader(oTarget);
                    string feedback;
                    string sName= GetName(oTarget);
                    int Skill= GetSkillRank(SKILL_SPELLCRAFT, oTarget, TRUE);
                    if( Skill<=0) {Skill=0;}
                    Skill= Skill/5;
                    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, Skill, SAVING_THROW_TYPE_MIND_SPELLS);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSave, oTarget, 0.1);
                    if (GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF))
                      {
                      feedback=sName+" : Immune to Mind Affecting Spells";
                      SendMessageToPC(oTarget2, feedback);
                      }
                //Make Will save to negate
                nSave = WillSave(oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, oCreator);
                if(nSave==0)
                {
					//effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);
                    //Apply VFX impact and lowered save effect
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget));
					//ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
                }
            }
        }
        else
        {
			//effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);
            //Apply VFX impact and lowered save effect
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
			//ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
        }
    }
}