//::///////////////////////////////////////////////
//:: Polymorph Self
//:: NW_S0_PolySelf.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The PC is able to changed their form to one of
    several forms.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 21, 2002
//:://////////////////////////////////////////////
// ChazM 1/18/07 - EvenFlw modifications

//RedRover 4/29/2012 - added changes by Reeron


#include "x2_i0_spells" //RedRover - include from Reeron's script
#include "x2_inc_spellhook"

#include "cmi_ginc_spells"


// RedRover - **begin Reeron addition
void RunAbilityBonus( object oTarget, int nSpell, float fDuration, effect eInt, effect eWis, effect eCha );
object oCaster = OBJECT_SELF;
string sTag;
// **end Reeron addition

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

	int nArcaneShapesCanCast = GetLocalInt(GetModule(), "ArcaneShapesCanCast");


    //Declare major variables
    int nSpell = GetSpellId();
	
	// constrain to allowed values
	if(nSpell<387 || nSpell>391)
		nSpell=387 + Random(5); // set default as random (instead of cow)
		
    object oTarget = GetSpellTargetObject();

//  RedRover - **begin Reeron's addition
    sTag = GetTag(oTarget);
    int nInt = GetAbilityScore(oTarget,3);
    int nInt2 = GetAbilityScore(oTarget,3,TRUE);
    int nInt3 = nInt-nInt2;
    int nWis = GetAbilityScore(oTarget,4);
    int nWis2 = GetAbilityScore(oTarget,4,TRUE);
    int nWis3 = nWis-nWis2;
    int nCha = GetAbilityScore(oTarget,5);
    int nCha2 = GetAbilityScore(oTarget,5,TRUE);
    int nCha3 = nCha-nCha2;
    effect eInt = EffectAbilityIncrease(3,(nInt3));
    effect eWis = EffectAbilityIncrease(4,(nWis3));
    effect eCha = EffectAbilityIncrease(5,(nCha3));
    eInt = ExtraordinaryEffect(eInt);// Don't want it removed by a Dispel Magic until my delay loop removes it.
    eWis = ExtraordinaryEffect(eWis);// Don't want it removed by a Dispel Magic until my delay loop removes it.
    eCha = ExtraordinaryEffect(eCha);// Don't want it removed by a Dispel Magic until my delay loop removes it.
//  **end Reeron's addition

    effect eVis = EffectVisualEffect( VFX_DUR_POLYMORPH );
    effect ePoly;
    int nPoly = POLYMORPH_TYPE_TROLL;
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = GetPalRngCasterLevel();
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    //Determine Polymorph subradial type
    if(nSpell == 387)
    {
        nPoly = POLYMORPH_TYPE_SWORD_SPIDER;

//	RedRover - **begin Reeron's addition        
        if (sTag == "c_summ_succubus")
        nPoly = POLYMORPH_TYPE_TROLL;
//	**end Reeron's addition
        
    }
    else if (nSpell == 388)
    {
        nPoly = POLYMORPH_TYPE_TROLL;
    }
    else if (nSpell == 389)
    {
        nPoly = POLYMORPH_TYPE_UMBER_HULK;
        
//	RedRover - **begin Reeron's addition
        if (sTag == "c_summ_succubus")
        nPoly = POLYMORPH_TYPE_GARGOYLE;
//	**end Reeron's addion        

    }
    else if (nSpell == 390)
    {
        nPoly = POLYMORPH_TYPE_GARGOYLE;
    }
    else if (nSpell == 391)
    {
        nPoly = POLYMORPH_TYPE_MINDFLAYER;
    }
    ePoly = EffectPolymorph(nPoly, FALSE, nArcaneShapesCanCast);
	ePoly = EffectLinkEffects( ePoly, eVis );
	
	if (!nArcaneShapesCanCast && !GetHasFeat(FEAT_NATURAL_SPELL))
	{
		effect eSpellFailure = EffectSpellFailure(100);
		ePoly = EffectLinkEffects( ePoly, eSpellFailure );
	}
	
	if(!GetIsPC(OBJECT_SELF)) 
		SetEffectSpellId(ePoly, SPELL_I_WORD_OF_CHANGING);	
		
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_POLYMORPH_SELF, FALSE));

    //Apply the VFX impact and effects
    AssignCommand(oTarget, ClearAllActions()); // prevents an exploit
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInt, oTarget, TurnsToSeconds(nDuration));// Added by Reeron
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWis, oTarget, TurnsToSeconds(nDuration));// Added by Reeron
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCha, oTarget, TurnsToSeconds(nDuration));// Added by Reeron

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oTarget, TurnsToSeconds(nDuration));

    float fDuration = TurnsToSeconds(nDuration);
    DelayCommand(2.0f, RunAbilityBonus(oTarget, nSpell, fDuration, eInt, eWis, eCha));
}

//RedRover - **Begin Reeron addition
void RunAbilityBonus( object oTarget, int nSpell, float fDuration, effect eInt, effect eWis, effect eCha )

{
    //FloatingTextStringOnCreature("*RunAbilityBonus!*", oTarget);
    //FloatingTextStringOnCreature("nSpell = "+IntToString(nSpell),oTarget);
    if (!GetHasEffect( EFFECT_TYPE_POLYMORPH, oTarget))
        {
        DelayCommand(1.0f, RemoveEffect(oTarget, eInt));
        DelayCommand(1.0f, RemoveEffect(oTarget, eWis));
        DelayCommand(1.0f, RemoveEffect(oTarget, eCha));
        //FloatingTextStringOnCreature("*AbilityBonusEnded!*", oTarget);
        return;
        }
    DelayCommand(6.0f,RunAbilityBonus(oTarget, nSpell, fDuration, eInt, eWis, eCha));

}
//**end Reeron addition