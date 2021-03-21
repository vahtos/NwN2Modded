//:://///////////////////////////////////////////////
//:: Righteous Might
//:: nw_s0_sngodisc.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 08/11/05
//::////////////////////////////////////////////////
/*
        5.2.5.3.1	Righteous Might
        PHB, pg. 273
        School:		    Transmutation
        Components: 	Verbal, Somatic
        Range:		    Personal
        Target:		    You
        Duration:		1 round / level

        This increases the size of the caster by 50%. All size increasing spells 
        use this effect, and no size increasing spells stack (the second size 
        increasing spell automatically fails if targeted on someone who has Enlarge 
        Person cast on them for example). They get a +4 Strength Bonus, +2 Constitution Bonus, 
        and a +2 natural armor AC bonus. Additionally the caster gains damage resistance 3/evil 
        (if they are non-evil) or 5/good (if they are evil). At 12th level the damage 
        resistance goes up to 6, and at 15th it goes up to 9. They get a -1 attack 
        and -1 AC penalty because of size. All melee weapons deal +3 damage. 

        [B] They threaten opponents within 10 feet instead of 5 feet. This may
        not be implemented depending on how the AoO works in the Aurora engine.


        [Rules Note] In 3.5 melee weapons actually go up one size category. The
        +3 damage is an average of some of the typical weapons a PC would use. 
        E.g. a longsword goes from 1d8 to 2d6 (avg. gain of 2.5) and a two-handed 
        sword goes from 2d6 to 3d6 (avg. gain of 3.5).
        Also in the Righteous Might description in the PHB it covers cases where 
        you don't have enough space to grow that much. That part of the spell is 
        removed from NWN2 for simplicity's sake. Also the stats don't match the 
        PHB - they match the errata on the WotC web-site.
		
        Reeron modified on 3-9-07
        Now gives correct 1 round/level duration. Also changed stats to 
        PnP description. This is as close to PnP as possible. Now gives 
        Damage Reduction vs evil/good instead of Damage Resistance positive/negative.
        
        Reeron modified on 8-29-07
        Changed values back to 3.5 Errata correct values.
		
        Reeron modified on 11-7-07
        Allows Righteous Might to stack with Bull's Strength or 
        Mass Bull's Strength.
        
*/


// JLR - OEI 08/23/05 -- Metamagic changes

#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "nwn2_inc_spells"
#include "x2_i0_spells" 

void RunBullBonus( object oTarget, float fDuration, effect eStr2 );
object oCaster = OBJECT_SELF;
void main()
{

    if (!X2PreSpellCastCode())
    {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // Determine and validate the target ( this SHOULD be the caster!)
    object oTarget = GetSpellTargetObject();
    effect eStr2;
    int nModify2 = 0;

	if ( HasSizeIncreasingSpellEffect( oTarget ) == TRUE || GetHasSpellEffect( 803, oTarget ))
	{
		// TODO: fizzle effect? 
		FloatingTextStrRefOnCreature( 3734, oTarget );  //"Failed"
		return;
	}

    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    float fDuration  = ApplyMetamagicDurationMods(RoundsToSeconds(nCasterLvl));
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	int nAlignment = GetAlignmentGoodEvil( oTarget );
	
	int nDmgResist;
	int nDmgType;

	if ( nAlignment != ALIGNMENT_EVIL )
	{
		//nDmgType = DAMAGE_TYPE_NEGATIVE;
		nDmgType = ALIGNMENT_EVIL;
	}
	else
	{
		//nDmgType = DAMAGE_TYPE_POSITIVE;
		nDmgType = ALIGNMENT_GOOD;		
	}

	nDmgResist = 3;
		
	if (( nCasterLvl >= 12) && (nCasterLvl <15) ) 	{nDmgResist = 6;}
	
	else if ( nCasterLvl >= 15 ) 		{nDmgResist = 9;}
	
	
	//else 							nDmgResist = 3;

    if (GetHasSpellEffect(9, oTarget) || GetHasSpellEffect(1025, oTarget))// Spell 9 is Bull's Strength in Spells.2da
        {                                                                 // Spell 1025 is Mass Bull's Strength.
        nModify2 = 8;
        }
    RemoveEffectsFromSpell(oTarget, GetSpellId());
    RemovePermanencySpells(oTarget);
	// Effects 
    //effect eVis 	= EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
	
//	effect eResist	= EffectDamageResistance( nDmgType, nDmgResist );
    effect eResist  = EffectDamageReduction(nDmgResist, nDmgType, 0, DR_TYPE_ALIGNMENT);
    effect eStr 	= EffectAbilityIncrease(ABILITY_STRENGTH, 4);
    eStr2 = EffectAbilityIncrease(ABILITY_STRENGTH,nModify2);
    effect eCon 	= EffectAbilityIncrease(ABILITY_CONSTITUTION, 2);
    effect eACInc 	= EffectACIncrease(2, AC_NATURAL_BONUS); 
    effect eACDec   = EffectACDecrease(1, AC_DODGE_BONUS);
	effect eAtkDec	= EffectAttackDecrease( 1, ATTACK_BONUS_MISC ); // ATTACK_BONUS_MISC???
    effect eDmg 	= EffectDamageIncrease(3, DAMAGE_TYPE_MAGICAL);	// Should be Melee-only!
    effect eScale 	= EffectSetScale(1.5);
    effect eDur 	= EffectVisualEffect( VFX_HIT_SPELL_ENLARGE_PERSON );
    effect eLink 	= EffectLinkEffects(eStr, eCon);
    eLink = EffectLinkEffects(eLink, eResist);
    eLink = EffectLinkEffects(eLink, eACInc);
    eLink = EffectLinkEffects(eLink, eACDec);
    eLink = EffectLinkEffects(eLink, eAtkDec);
	eLink = EffectLinkEffects(eLink, eDmg);
    eLink = EffectLinkEffects(eLink, eScale);
    eLink = EffectLinkEffects(eLink, eDur);
    effect eDispel = EffectOnDispel(0.0f, RemoveEffectsFromSpell(oTarget, 890));// 890 is Righteous Might.
    eLink = EffectLinkEffects(eLink, eDispel);
    eStr2 = EffectLinkEffects(eStr2, eDispel);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Apply the VFX impact and effects
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    DelayCommand(1.5, ApplyEffectToObject(nDurType, eLink, oTarget, fDuration));
    if (nModify2>0)
        {
        ApplyEffectToObject(nDurType, eStr2, oTarget, fDuration);
        RunBullBonus(oTarget, fDuration, eStr2);
        }
}

void RunBullBonus( object oTarget, float fDuration, effect eStr2 ) // Under the effects of Bull's Strength
                                                                   // or Mass Bull's Strength.
{
    if (GZGetDelayedSpellEffectsExpired(9, oTarget, oCaster) && GZGetDelayedSpellEffectsExpired(1025, oTarget, oCaster))
        {
        RemoveEffect(oTarget, eStr2);
        return;
        }
    DelayCommand(6.0f,RunBullBonus(oTarget, fDuration, eStr2));

}