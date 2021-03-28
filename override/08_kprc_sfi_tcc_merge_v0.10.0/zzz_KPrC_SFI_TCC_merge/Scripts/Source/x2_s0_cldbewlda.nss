//::///////////////////////////////////////////////
//:: Cloud of Bewilderment
//:: X2_S0_CldBewldA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A cone of noxious air goes forth from the caster.
    Enemies in the area of effect are stunned and blinded
    1d6 rounds. Foritude save negates effect.
*/

//  Reeron modified on 4-2-07
//  Saving throw MUST use the area of effect creator, otherwise
//  saves aren't done correctly. Changed save type to SPELL
//  instead of POISON. This prevents losing your chance to save
//  against the effects if you were immune to poison, and it gives
//  you your bonus to save based on your ranks in Spellcraft.
//  Needed valid area of effect creator check. Will remove
//  area of effect if caster is dead.
//  
//  Reeron modified on 4-16-07
//  Now takes into account ranks in spellcraft, and changed 
//  save type back to POISON, so increased saves versus poison
//  will be taken into account. Immunity to poison now works 
//  correctly.
//
//  Reeron modified on 6-28-09
//  Updated for patch 1.22.5588
//
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: November 04, 2002
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "x2_inc_spellhook"

int nDC= GetSpellSaveDC();
object oCaster = OBJECT_SELF;

void main()
{

    //Declare major variables
    int nRounds;
    effect eStun = EffectStunned();
    effect eBlind = EffectBlindness();
	effect eDur = EffectVisualEffect( VFX_DUR_STUN );
    eStun = EffectLinkEffects(eBlind,eStun);
    eStun = EffectLinkEffects(eStun,eDur);
    effect eVis = EffectVisualEffect(VFX_DUR_BLIND);
    effect eFind;
    object oTarget;
    object oCreator= GetAreaOfEffectCreator();
    float fDelay = GetRandomDelay(0.75, 1.75);
    
    //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // When the caster is no longer there, all functions calling
    // GetAreaOfEffectCreator will fail. Its better to remove the barrier then
    //--------------------------------------------------------------------------
    if (!GetIsObjectValid(GetAreaOfEffectCreator()))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }
    //Get the first object in the persistant area
    oTarget = GetEnteringObject();
    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF,SPELL_CLOUD_OF_BEWILDERMENT));
        //Make a SR check
        if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget))
        {
            //Make a Fort Save
                    string feedback;
                    //string feedback2 ="immune to mind spells";
                    //int nDC2 = nDC;
                    int nSave;
                    string sName = GetName(oTarget);
                    object oTarget2 = GetFactionLeader(oTarget);
                    int Skill= GetSkillRank(SKILL_SPELLCRAFT, oTarget, TRUE);
                    if( Skill<=0) {Skill=0;}
                    Skill= Skill/5;
                    //nDC2 -= Skill;
                    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_FORT, Skill, SAVING_THROW_TYPE_POISON);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSave, oTarget, 0.1);
                    if (Skill>0)
                    {
                    //feedback="Lowered DC by "+IntToString(Skill)+" to compensate for ranks in SPELLCRAFT";
                    //SendMessageToPC(oTarget, feedback);
                    
                    }
                    if (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))
                      {
                      feedback=sName+" : Immune to Poison";
                      //SendMessageToPC(oTarget2, feedback); // Found a better way.
                      SendMessageToPC(GetFirstPC(FALSE), feedback);
                      }
                    //nSave = MySavingThrow(((SAVING_THROW_FORT)+(Skill)), oTarget, nDC2, SAVING_THROW_TYPE_POISON, oCreator);
                    nSave = FortitudeSave(oTarget, nDC, SAVING_THROW_TYPE_POISON, oCreator);
                    if (nSave==0)
              {
               nRounds = d6(1);
               //fDelay = GetRandomDelay(0.75, 1.75);
               //Apply the VFX impact and linked effects
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
               //if(!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
               {
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(nRounds)));
               }
               //else {SendMessageToPC(oTarget, feedback2);}
              }
        }
    }
}