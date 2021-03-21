//::///////////////////////////////////////////////
//:: Warpriest Mass Heal
//:: [NW_S2_WPMasHeal.nss]
//:: Copyright (c) 2006 Obisidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Mass Heal
	
	This acts like the Heal spell except it heals 
	multiple targets.

	Warpriest's spell-like ability to cast Mass Heal.
	Just like Mass Heal, except variable effects are
	controlled by Warpriest class level.
	
    Reeron modified on 3-25-07
    Now removes effects, except fatigue, as per PnP. Since fatigue is applied as an
    extraordinary effect, it can't be removed by this spell. Heal versus undead now
    uses a touch attack like it should. Wont' remove the effects of Iron Body, Stone 
    Body, Enlarge Person, or Duergar Enlarge Racial Ability. Shouldn't automatically
    hurt friendly undead anymore.

    Reeron modified on 6-25-09
    Updated for patch 1.22.5588
    Won't remove "Reduce" spell effects.
    Removes Solipsism effect.
    
    Reeron modified on 8-20-11
    Mass Heal now damages undead for a maximum of 250 hitpoints, per PnP.
    However, it can't reduce the undead's hitpoints to less than one. Also per PnP.
    Mass Heal now removes Insanity, Fatigue, and Exhaustion as per PnP.

*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/20/2006
//:://////////////////////////////////////////////
//:: PKM-OEI 07.11.06 - VFX Pass

#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 
#include "nwn2_inc_hlhrm"

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
    int 	nCasterLvl 	= GetLevelByClass(CLASS_TYPE_WARPRIEST);	// AFW-OEI 05/20/2006: main difference w/ Mass Heal
    effect	eVis 		= EffectVisualEffect(VFX_IMP_SUNSTRIKE); 
    effect 	eVis2	 	= EffectVisualEffect(VFX_IMP_HEALING_M);
    effect 	eImpact 	= EffectVisualEffect(VFX_HIT_CURE_AOE);

	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());    

	int nMaxToCure = nCasterLvl;
	int nCuredInFaction = CureFaction( nMaxToCure, eVis, eVis2, nCasterLvl, GetSpellId() );
	nMaxToCure = nMaxToCure - nCuredInFaction;
	CureNearby( nMaxToCure, eVis, eVis2, nCasterLvl, GetSpellId() );

}



void CureObject( object oTarget, effect eVis, effect eVis2, int nCasterLvl, int nSpellId )
{
	float fDelay = GetRandomDelay();

	//Check to see if the target is an undead
	if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		DelayCommand(fDelay, HarmTarget( oTarget, OBJECT_SELF, nSpellId ) );
	}
  	else if( GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD && spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF))
	{
		DelayCommand(fDelay, HealTarget( oTarget, OBJECT_SELF, nSpellId ) );
		
        effect eBad = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eBad))
        {
         if ((GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
            GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
            GetEffectType(eBad) == EFFECT_TYPE_DISEASE ||
            GetEffectType(eBad) == EFFECT_TYPE_POISON ||
            GetEffectType(eBad) == EFFECT_TYPE_DAZED ||
            GetEffectType(eBad) == EFFECT_TYPE_CONFUSED ||
            GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
            GetEffectType(eBad) == EFFECT_TYPE_INSANE ||
            GetEffectType(eBad) == EFFECT_TYPE_STUNNED) &&
            GetEffectSpellId(eBad) != SPELL_ENLARGE_PERSON &&
            GetEffectSpellId(eBad) != SPELL_STONE_BODY &&
            GetEffectSpellId(eBad) != SPELL_IRON_BODY &&
            GetEffectSpellId(eBad) != SPELL_REDUCE_PERSON &&
            GetEffectSpellId(eBad) != SPELL_REDUCE_ANIMAL &&
            GetEffectSpellId(eBad) != SPELL_REDUCE_PERSON_GREATER &&
            GetEffectSpellId(eBad) != SPELL_REDUCE_PERSON_MASS &&
            GetEffectSpellId(eBad) != 803 ||
            GetEffectSpellId(eBad) == 1129) //Solipsism
			{
			RemoveEffect(oTarget, eBad);
			eBad = GetFirstEffect(oTarget);
			}
			else
			eBad = GetNextEffect(oTarget);
    	}
	    if ( GetHasSpellEffect( 55, oTarget ))
          	{RemoveEffectsFromSpell( oTarget, 55);}
        if ( GetHasSpellEffect( -998, oTarget ))// Fatigue
            {RemoveEffectsFromSpell( oTarget, -998);}
        if ( GetHasSpellEffect( -999, oTarget ))// Exhaustion
            {RemoveEffectsFromSpell( oTarget, -999);}
   }
    

}

int CureFaction( int nMaxToCure, effect eVis, effect eVis2, int nCasterLvl, int nSpellId ) // returns the # cured
{
	int nNumCured = 0;
	int bPCOnly=FALSE;
	object oTarget = GetFirstFactionMember( OBJECT_SELF, bPCOnly );
    while ( GetIsObjectValid(oTarget) && nNumCured < nMaxToCure )
    {
    if (GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
    {
		CureObject( oTarget, eVis, eVis2, nCasterLvl, nSpellId );
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


int CureNearby( int nMaxToCure, effect eVis, effect eVis2, int nCasterLvl, int nSpellId ) // returns the # cured
{
	int nNumCured = 0;

    //Get first target in shape
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
    while ( GetIsObjectValid(oTarget) && nNumCured < nMaxToCure )
    {
		if ( !GetFactionEqual( oTarget, OBJECT_SELF ) || GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD ) // We've already done faction characters
		{
 			CureObject( oTarget, eVis, eVis2, nCasterLvl, nSpellId );
			nNumCured++;
		}

        //Get next target in the shape
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
    }

	return nNumCured;
}