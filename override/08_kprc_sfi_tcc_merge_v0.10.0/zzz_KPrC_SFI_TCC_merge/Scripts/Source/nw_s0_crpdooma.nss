//::///////////////////////////////////////////////
//:: Creeping Doom: On Enter
//:: NW_S0_AcidFogA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creature caught in the swarm take an initial
    damage of 1d20, but there after they take
    1d4 per swarm counter on the AOE.
	
    Reeron modified on 8-28-07
    Complete script re-write. This now follows PnP. Auto-hit (no attack roll) for 2d6 damage (plus poison)
    while in the AOE as per PnP. DC 13 poison check for 1d4 Dexterity damage on both initial damage 
    and secondary damage (1 minute later). Daze DC 13 Fortitude check in heartbeat script 
    (nauseated as per PnP "distraction"). DC 20 spell failure check- if failed you can't cast spells.
    Both distraction and spell failure only last 1 round. Both checks are made every round while 
    in the AOE. Caps at 20th level for number of swarms (10 max). Can't stack spell anymore. Caster 
    level stored on AOE for proper dispel magic callback. Since it's a diminutive swarm, it can't be 
    damaged with weapons as per PnP. Duration doesn't follow PnP as 1 min/level is waaaaay
    too long. Kept as 1 round/level so non-Druid PW players aren't excessively penalized by this spell.
    Poison damage is temporary, so it is removed on resting. Setting it to Permanent and Extraordinary 
    gives the same effect. Incorporeal creatures can't be hurt by swarms as per PnP.

    Reeron modified on 6-15-09
    Updated for patch 1.22.5588

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
//#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "x2_i0_spells"
effect eHit = EffectVisualEffect(VFX_HIT_SPELL_POISON);
//effect eHit = EffectVisualEffect(VFX_DUR_SPELL_CREEPING_DOOM);
int nSpellID = 364;// SpellID for Creeping Doom
//void DelayedPoison(object oTarget);
//void DelayedPoison2(object oTarget);
void DelayedPoison(object oTarget)
{
    //if(GZGetDelayedSpellEffectsExpired(nSpellID, oTarget, OBJECT_SELF)) {return;}// Don't do secondary damage
                                                                             // if poison effect was removed
    //if(GetHasSpellEffect(364, oTarget)) {FloatingTextStringOnCreature("poisoned", oTarget);}
    //FloatingTextStringOnCreature("poisoned 2nd statement", oTarget);
    effect eHit = EffectVisualEffect(VFX_HIT_SPELL_POISON);
    int nSpelleffect = GetEffectSpellId(eHit);
    //FloatingTextStringOnCreature("nSpelleffect = "+IntToString(nSpelleffect), oTarget);
    {
    if(GetIsObjectValid(oTarget) && !GetIsDead(oTarget)/* && GetIsObjectValid(oCaster)*/)
        {
        if(!MySavingThrow(SAVING_THROW_FORT, oTarget, 13, SAVING_THROW_TYPE_POISON))
            {
            if (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))// This second check is needed as target
                                                           // could gain immunity before second save.
                {
                string feedback;
                string sName2 = GetName(oTarget);
                //object oTarget2 = GetFactionLeader(OBJECT_SELF); // Not needed as I found a better way.
                feedback=sName2+" : Immune to Poison";
                //SendMessageToPC(oTarget2, feedback); // Not needed as I found a better way.
                SendMessageToPC(GetFirstPC(FALSE), feedback);
                }
            if (!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))
                {
                int nDam3 = d4();
                effect eCon2 = EffectAbilityDecrease( ABILITY_DEXTERITY, nDam3);
                effect eLink2 = EffectLinkEffects(eCon2,eHit);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eLink2), oTarget);
                }
            }   
        }
    }

}
void main()
{
/*
    //Declare major variables
    int nDamage;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_COM_BLOOD_REG_RED);
    object oTarget = GetEnteringObject();
    effect eSpeed = EffectMovementSpeedDecrease(50);
    //effect eVis2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);	// NWN1 VFX
    effect eVis2 = EffectVisualEffect( VFX_DUR_SPELL_SLOW );	// NWN2 VFX
    effect eLink = EffectLinkEffects(eSpeed, eVis2);
    float fDelay;
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_CREEPING_DOOM));
        fDelay = GetRandomDelay(1.0, 1.8);
        //Spell resistance check
        if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget, fDelay))
        {
            //Roll Damage
            nDamage = d20();
            //Set Damage Effect with the modified damage
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING);
            //Apply damage and visuals
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
        }
    }*/
    int nDamage;
    object oCaster = GetAreaOfEffectCreator();
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_COM_BLOOD_REG_RED);
    object oTarget = GetEnteringObject();
    float fDelay;
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_CREEPING_DOOM));
        fDelay = GetRandomDelay(0.5, 1.3);
        //Roll Damage
        nDamage = d6(2);
        //Set Damage Effect with the modified damage
        eDam = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING);
        if (!GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL))
            {
            //Apply damage and visuals
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            if(!MySavingThrow(SAVING_THROW_FORT, oTarget, 13, SAVING_THROW_TYPE_POISON))
                    {
                    if (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))
                        {
                        string feedback;
                        string sName = GetName(oTarget);
                        //object oTarget2 = GetFactionLeader(OBJECT_SELF); // Not needed as I found a better way.
                        feedback=sName+" : Immune to Poison";
                        //FloatingTextStringOnCreature(feedback, oTarget2) // Not needed as I found a better way.
                        FloatingTextStringOnCreature(feedback, GetFirstPC(FALSE));
                        }
                    
                    if (!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))
                        {
                        int nDam2 = d4();
                        effect eCon = EffectAbilityDecrease( ABILITY_DEXTERITY, nDam2);
                        effect eLink = EffectLinkEffects(eCon,eHit);
                        ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eLink), oTarget);
                        DelayCommand(60.0f, DelayedPoison(oTarget));
                        }
                    }
                //daze and concentration checks go here in heartbeat script only.

            }
    }
}
/*void DelayedPoison(object oTarget)
{
DelayCommand(59.9f, DelayedPoison2(oTarget));
}
void DelayedPoison2(object oTarget)
{
    //if(GZGetDelayedSpellEffectsExpired(nSpellID, oTarget, oCaster)) {return;}// Don't do secondary damage
                                                                             // if poison effect was removed
    if(GetHasSpellEffect(364, oTarget)) {FloatingTextStringOnCreature("poisoned", oTarget);}
    FloatingTextStringOnCreature("poisoned 2nd statement", oTarget);
    effect eHit = EffectVisualEffect(VFX_HIT_SPELL_POISON);
    int nSpelleffect = GetEffectSpellId(eHit);
    FloatingTextStringOnCreature("nSpelleffect = "+IntToString(nSpelleffect), oTarget);
    {
    if(GetIsObjectValid(oTarget) && !GetIsDead(oTarget)/* && GetIsObjectValid(oCaster))
        {
        if(!MySavingThrow(SAVING_THROW_FORT, oTarget, 13, SAVING_THROW_TYPE_POISON))
            {
            if (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))// This second check is needed as target
                                                           // could gain immunity before second save.
                {
                string feedback;
                string sName2 = GetName(oTarget);
                object oTarget2 = GetFactionLeader(OBJECT_SELF);
                feedback=sName2+" : Immune to Poison";
                SendMessageToPC(oTarget2, feedback);
                }
            if (!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))
                {
                int nDam3 = d4();
                effect eCon2 = EffectAbilityDecrease( ABILITY_DEXTERITY, nDam3);
                effect eLink2 = EffectLinkEffects(eCon2,eHit);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eLink2), oTarget);
                }
            }
        }
    }
    
}*/