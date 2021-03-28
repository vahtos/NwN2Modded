//::///////////////////////////////////////////////
//:: Prismatic Spray
//:: [NW_S0_PrisSpray.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Sends out a prismatic cone that has a random
//:: effect for each target struck.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Dec 19, 2000
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: Last Updated By: Aidan Scanlan On: April 11, 2001
//:: Last Updated By: Preston Watamaniuk, On: June 11, 2001
//:: Last Updated By: Brock Heinz, OEI, 08/17/05 (added Flesh to Stone)
//::
//::    Reeron modifed 3-7-07
//::
//::    Properly applied roll to see if 2 effects are done (1 in 8 chance) instead
//::    of always just 1 effect. When 1 effect was being done, wrong random roll
//::    was being used. Removed double save for stone effect. Removed double resistance check 
//::    for stone effect. Removed 2 visual effects being applied on paralyze. Now 
//::    only one visual effect is applied. Removed redefinition of target in 
//::    stone effect. Not necessary and may mess up the spell. 
//::    
//::    
//::    Reeron modified on 5-24-07
//::    
//::    Changed to be more like PnP version. Made confusion permanent effect so it acts 
//::    like insanity effect which is permanent. Can only be removed with a Heal Spell or
//::    Greater Restoration spell. Resting will not remove the effect. Removed Paralysis 
//::    effect as it doesn't exist in PnP. Changed size of cone to equal 60 feet not the 
//::    11 meters it was using. Changed duration of blindness to 2d4 rounds as per PnP. 
//::    Changed poison effect to take into account immunity to poison. If immune no effect.
//::    If not immune, but you make your save, you are still affected with a Constitution 
//::    decrease of 1d6 just like PnP.
//::    
//::    Reeron modified on 3-31-08
//::    No longer initiates a spell resistance check on the caster.
//::    
//::    Reeron modified on 6-25-09
//::    Updated for patch 1.22.5588
//::
int ApplyPrismaticEffect(int nEffect, object oTarget);

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 
object oCaster= OBJECT_SELF;
const int PS_EFFECT_FIRE 			= 0;
const int PS_EFFECT_ACID 			= 1;
const int PS_EFFECT_ELECTRICITY 	= 2;
const int PS_EFFECT_POISON 			= 3;
//const int PS_EFFECT_PARALYZE		= 4;
const int PS_EFFECT_CONFUSION		= 4;
const int PS_EFFECT_DEATH 			= 5;
const int PS_EFFECT_STONE 			= 6;
const int PS_EFFECT_COUNT 			= 7;

//Set the delay to apply to effects based on the distance to the target
float GetDelayForTarget( object oTarget )
{
	float fDelay = 1.5 + GetDistanceBetween(OBJECT_SELF, oTarget)/20;
	return fDelay;
}

void main()
{
    if (!X2PreSpellCastCode())
    {
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

	//SpawnScriptDebugger();

    //Declare major variables
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic	 = GetMetaMagicFeat();
    int nRandom, nHD, nVisual, bTwoEffects;
	effect eCone = EffectVisualEffect(VFX_DUR_CONE_COLORSPRAY);
	float fMaxDelay = 0.0f; // Used to determine length of Cone effect
    effect eVisual; int nVisual2 = 0;

    //Get first target in the spell area
	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 18.288, GetSpellTargetLocation());
	while (GetIsObjectValid(oTarget))
	{
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
		   
		    float fDelay = GetDelayForTarget( oTarget );
			if (fMaxDelay < fDelay)
			{
				fMaxDelay = fDelay;
			}

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PRISMATIC_SPRAY));
            //Make an SR check
            if ((oTarget != OBJECT_SELF) && !MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {
                //Blind the target if they are less than 9 HD
                nHD = GetHitDice(oTarget);
                if (nHD <= 8)
                {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oTarget, RoundsToSeconds(d4(2)));
                }

                //Determine if 1 or 2 effects are going to be applied
                nRandom = Random( 8 ); // Get an integer between 0 and 7.
                if ( nRandom == (7) ) //If nRandom=7 then apply 2 effects. This gives a 1 in 8 chance of 2 effects being applied.
				
                {
                    //Get the visual effects
                    nVisual = ApplyPrismaticEffect( Random(PS_EFFECT_COUNT), oTarget);
                    nVisual2 = ApplyPrismaticEffect( Random(PS_EFFECT_COUNT), oTarget);     
                }
                else
                {
                    //Get the visual effect
                    nVisual = ApplyPrismaticEffect( nRandom, oTarget);
                }
                //Set the visual effect
                if(nVisual != 0)
                {
                    eVisual = EffectVisualEffect(nVisual);
                    //Apply the visual effect
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget));
                }
				if(nVisual2 != 0)
				{
				    eVisual = EffectVisualEffect(nVisual2);
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget));
				}
            }
        }
        //Get next target in the spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 18.288, GetSpellTargetLocation());
	}
	// Apply Cone visual fx
	fMaxDelay += 0.5f;
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, OBJECT_SELF, fMaxDelay);
}

///////////////////////////////////////////////////////////////////////////////
//  ApplyPrismaticEffect
///////////////////////////////////////////////////////////////////////////////
/*  Given a reference integer and a target, this function will apply the effect
    of corresponding prismatic cone to the target.  To have any effect the
    reference integer (nEffect) must be from 0 to 7.*/
///////////////////////////////////////////////////////////////////////////////
//  Created By: Aidan Scanlan On: April 11, 2001
///////////////////////////////////////////////////////////////////////////////

int ApplyPrismaticEffect(int nEffect, object oTarget)
{

    effect 	ePrism;
    effect 	eVis;
    effect 	eDur 	= EffectVisualEffect( VFX_DUR_SPELL_PRISMATIC_SPRAY );
    effect	eLink;
    int 	nDamage = 0;
    int 	nVis 	= 0;
     float 	fDelay	= GetDelayForTarget( oTarget );

    //Based on the random number passed in, apply the appropriate effect and set the visual to
    //the correct constant
    switch(nEffect)
    {
        case PS_EFFECT_FIRE://fire
			{
	            nDamage = 20;
	            nVis = VFX_HIT_SPELL_FIRE;
	            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(),SAVING_THROW_TYPE_FIRE);
	            ePrism = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
			}
        break;

        case PS_EFFECT_ACID: //Acid
			{
	            nDamage = 40;
	            nVis = VFX_HIT_SPELL_ACID;
	            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(),SAVING_THROW_TYPE_ACID);
	            ePrism = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
			}
        break;

        case PS_EFFECT_ELECTRICITY: //Electricity
			{
	            nDamage = 80;
	            nVis = VFX_HIT_SPELL_LIGHTNING;
	            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(),SAVING_THROW_TYPE_ELECTRICITY);
	            ePrism = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
			}
        break;

        case PS_EFFECT_POISON: //Poison effect
            {             
                if (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))
                    {
                    string sName = GetName(oTarget);
                    string feedback=sName+" : Immune to Poison";
                    SendMessageToPC(oCaster, feedback);
                    }
                //FloatingTextStringOnCreature("Poison effect", oCaster);
                if (!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))
                    {
                    int nSave = FortitudeSave(oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_POISON, OBJECT_SELF);
                    if (nSave==0)
                    //if (!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_POISON, OBJECT_SELF, fDelay))
                        {
                        nVis = VFX_HIT_SPELL_NECROMANCY;
                        ePrism = EffectDeath();
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
                        }
                    else
                        {
                        nVis = VFX_HIT_SPELL_NECROMANCY;
                        ePrism = EffectAbilityDecrease(ABILITY_CONSTITUTION, d6());
                        DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));                
                        }
                    }
            }
            
        break;

  /*      case PS_EFFECT_PARALYZE: //Paralyze
            {
				nVis = VFX_HIT_SPELL_ENCHANTMENT;
                effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
				int nSaveDC = GetSpellSaveDC();
                if (MySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC) == 0)
                {
                    ePrism = EffectParalyze(nSaveDC, SAVING_THROW_FORT);
                    //eLink = EffectLinkEffects(eDur, ePrism);
                    eLink = EffectLinkEffects(ePrism, eDur2);
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(10)));
                }
            }
        break;*/

        case PS_EFFECT_CONFUSION: //Confusion
            {
                effect eDur = EffectVisualEffect( VFX_DUR_SPELL_CONFUSION );
                ePrism = EffectConfused();
                eLink = EffectLinkEffects(eDur, ePrism);
                eLink = SupernaturalEffect(eLink);

                if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
                {
                    //nVis = VFX_HIT_SPELL_ENCHANTMENT;
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget));
                }
            }
        break;

        case PS_EFFECT_DEATH: //Death
            {
                if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_DEATH, OBJECT_SELF, fDelay))
                {
                    nVis = VFX_HIT_SPELL_NECROMANCY;
                    ePrism = EffectDeath();
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
                }
            }
        break;

		case PS_EFFECT_STONE: // Flesh to Stone 
			{
                //if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_DEATH, OBJECT_SELF, fDelay))
                {
					//nVis = VFX_HIT_SPELL_TRANSMUTATION;
				   // object oTarget = GetSpellTargetObject();
				    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
				
				    //if (MyResistSpell(OBJECT_SELF,oTarget) <1)
				    {
				    	DelayCommand(fDelay, DoPetrification(nCasterLvl, OBJECT_SELF, oTarget, GetSpellId(), GetSpellSaveDC()) );
					}
				}
			}
    }
    return nVis;
}