//::///////////////////////////////////////////////
//:: Mass Cure Moderate Wounds
//:: NW_S0_MaCurMod
//:://////////////////////////////////////////////
/*
	Mass Cure Critical Wounds
	PHB, pg. 215
	School:			Conjuration (Healing)
	Components: 	Verbal, Somatic
	Range:			Close
	Target:			One creature/level
	Duration:		Instantaneous
	
	This uses positive energy to cure 4d8 points of damage +1 point 
	per caster level (maximum +40). This affects first the caster 
	and his immediate party, then the nearest non-hostile targets 
	(Neutral targets exempt) within range of the caster. This
	 spell can be spontaneously cast.
	 
    Reeron modified on 3-25-07
    Uses will save now instead of incorrect fortitude save.
    Was using wrong variable during metmagic mods (Casterlevel
    instead of nBonus). Shouldn't automatically
    hurt friendly undead anymore.
		
    Reeron modified on 4-27-07
    Now takes into account Augmented Healing Feat.

    Reeron modified on 6-15-09
    Updated for patch 1.22.5588

*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: August 01, 2005
//:://////////////////////////////////////////////

// JLR - OEI 08/23/05 -- Metamagic changes
#include "nwn2_inc_spells"


#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 




// Brock H. - OEI 10/06/05 -- Added code to heal faction, then nearby, and cap based on level
int CureFaction( int nMaxToCure, effect eVis, effect eVis2, int nCasterLvl, int nMetaMagic ); 
int CureNearby( int nMaxToCure, effect eVis, effect eVis2, int nCasterLvl, int nMetaMagic ); 


void main()
{

    if (!X2PreSpellCastCode())
    {
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }



     //Declare major variables
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    effect eVis = EffectVisualEffect( VFX_IMP_SUNSTRIKE );
    effect eVis2 = EffectVisualEffect(VFX_IMP_HEALING_G);
    effect eImpact = EffectVisualEffect(VFX_HIT_CURE_AOE);

	// Fire a pretty impact effect
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());

	// Cure people in your faction, and then anybody nearby
	int nMaxToCure = nCasterLvl;
	int nCuredInFaction = CureFaction( nMaxToCure, eVis, eVis2, nCasterLvl, nMetaMagic );
	nMaxToCure = nMaxToCure - nCuredInFaction;
	CureNearby( nMaxToCure, eVis, eVis2, nCasterLvl, nMetaMagic );

}



   


void CureObject( object oTarget, effect eVis, effect eVis2, int nCasterLvl, int nMetaMagic )
{
	int nDamagen, nModify, nHurt, nHP;
	effect eKill, eHeal;
	float fDelay = GetRandomDelay();
	int nBonus = nCasterLvl;
	if ( nBonus > 40 ) // Cap the bonus at 30
		nBonus = 40;

	//Check if racial type is undead
     if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD )
     {
     	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
     	{
             //Fire cast spell at event for the specified target
             SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
             //Make SR check
             if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
             {
                 nModify = d8(4) + nBonus;
                 //Make metamagic check
                 nModify = ApplyMetamagicVariableMods(nModify, 32 + nBonus);

                 //Make Fort save
                 if (MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
                 {
                     nModify /= 2;
                 }
                 //Calculate damage
                 nHurt =  nModify;
                 //Set damage effect
                 eKill = EffectDamage(nHurt, DAMAGE_TYPE_POSITIVE);
                 //Apply damage effect and VFX impact
                 DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
                 DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
             }
         }
     }
     else
     {
         // * May 2003: Heal Neutrals as well
     	if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF))
     	{
             //Fire cast spell at event for the specified target
             SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
             nHP = d8(4);
             //Enter Metamagic conditions
             nHP = ApplyMetamagicVariableMods(nHP, 32);
             if ( GetHasFeat(FEAT_AUGMENT_HEALING) && !GetIsObjectValid(GetSpellCastItem()) )
             {
                 int nSpellLvl = GetSpellLevel(GetSpellId());
                 nHP += (2 * nSpellLvl);
             }
             //Set healing effect
             nHP = nHP + nBonus;
             eHeal = EffectHeal(nHP);
             //Apply heal effect and VFX impact
             DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
             DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
         }
     }

}
int CureFaction( int nMaxToCure, effect eVis, effect eVis2, int nCasterLvl, int nMetaMagic ) // returns the # cured
{
	int nNumCured = 0;
	int bPCOnly=FALSE;
	object oTarget = GetFirstFactionMember( OBJECT_SELF, bPCOnly );
    while ( GetIsObjectValid(oTarget) && nNumCured < nMaxToCure )
    {
    if (GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
    {
		CureObject( oTarget, eVis, eVis2, nCasterLvl, nMetaMagic );
		nNumCured++;
		oTarget = GetNextFactionMember( OBJECT_SELF, bPCOnly );
	}
    else
    {
        oTarget = GetNextFactionMember( OBJECT_SELF, bPCOnly );
    }
    }
    return nNumCured;
}


int CureNearby( int nMaxToCure, effect eVis, effect eVis2, int nCasterLvl, int nMetaMagic ) // returns the # cured
{
	int nNumCured = 0;

    //Get first target in shape
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
    while ( GetIsObjectValid(oTarget) && nNumCured < nMaxToCure )
    {
		if ( !GetFactionEqual( oTarget, OBJECT_SELF ) || GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD ) // We've already done faction checks
		{
 			CureObject( oTarget, eVis, eVis2, nCasterLvl, nMetaMagic );
			nNumCured++;
		}


        //Get next target in the shape
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
    }

	return nNumCured;
}