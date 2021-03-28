//\/////////////////////////////////////////////////////////////////////////////
//
//  nwn2_inc_hlhrm.nss
//
//  Shared functions for the Heal and Harm spells for NWN2
//
//  (c) Obsidian Entertainment Inc., 2005
//
//\/////////////////////////////////////////////////////////////////////////////

#include "nwn2_inc_spells"
#include "NW_I0_SPELLS"    
#include "x0_i0_petrify"


///////////////////////////////////////////////////////////////////////////////
// HealTarget
///////////////////////////////////////////////////////////////////////////////
//
// Created By:	Brock Heinz
// Created On:	08/17/2005
// Description: Heals the target for 10 hit points per level of the caster, 
//              capped at 150. Harm spells cast on Undead should call this 
//              instead of HarmTarget
// 
// 
// Reeron modified on 3-25-07
// Per PnP description, Mass Heal can heal a maximum of 250 hitpoints.
// Mass Heal now removes wounding effect. Works with Warpriest version also.
//
//
///////////////////////////////////////////////////////////////////////////////
void HealTarget( object oTarget, object oCaster, int nSpellID )
{
	int 	nCasterLevel 	= GetCasterLevel( oCaster );
	int 	nHealAmt		= ClampInt( 10*nCasterLevel, 0, 150 );
    if ( nSpellID == SPELL_MASS_HEAL || nSpellID == 965) 
    {
    int 	nHealAmt		= ClampInt( 10*nCasterLevel, 0, 250 );// per PnP description
    }
    effect  eHeal 			= EffectHeal( nHealAmt );
	effect 	eVisual;

	if ( nSpellID == SPELL_HEAL || nSpellID == SPELL_MASS_HEAL || nSpellID == 965) 	eVisual = EffectVisualEffect(VFX_IMP_HEALING_X);
	else     						eVisual = EffectVisualEffect(VFX_HIT_SPELL_INFLICT_6);
	

	//Apply the heal effect and the VFX impact
	if ( nSpellID == SPELL_HEAL || nSpellID == SPELL_MASS_HEAL || nSpellID == 965)
	{
		RemoveEffectOfType( oTarget, EFFECT_TYPE_WOUNDING );
	}
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
}

///////////////////////////////////////////////////////////////////////////////
// HarmTarget
///////////////////////////////////////////////////////////////////////////////
//
// Created By:	Brock Heinz
// Created On:	08/17/2005
// Description: Damages the target for 10 hit points per level of the caster, 
//              capped at 150. Heal spells cast on Undead should call this 
//              instead of HealTarget
// 
//
//              Reeron modified on 3-18-07
//              Now uses touch attack, like it should, for heal spell versus undead.
//              Won't fail to harm undead when using mass heal. Won't even try a touch
//              attack versus undead if mass heal is used.
//
//              Reeron modified on 8-18-11
//              Mass Heal now damages undead for a maximum of 250 hitpoints, per PnP.
//              However, it can't reduce the undead's hitpoints to less than one. Also per PnP.        
//
///////////////////////////////////////////////////////////////////////////////

void HarmTarget( object oTarget, object oCaster, int nSpellID )
{

	 //Make a touch attack
    if ( (nSpellID == SPELL_MASS_HEAL) || (nSpellID == 965) || TouchAttackMelee(oTarget) != TOUCH_ATTACK_RESULT_MISS) //No touch attack is needed to zap people. Reeron- the hell it isn't.
    {
        //Make SR check
        if ( !MyResistSpell(oCaster, oTarget) )
        {
            // Let the Harming begin!
			int 	nCasterLevel 	= GetCasterLevel( oCaster );
			//int 	nDamageAmt		= ClampInt( 10*nCasterLevel, 0, 150 );
			int 	nDamageType;
			effect 	eVisual;
			
			if ( nSpellID == SPELL_HARM ) 		nDamageType = DAMAGE_TYPE_NEGATIVE;
			else     							nDamageType = DAMAGE_TYPE_POSITIVE;
			
			if ( nSpellID == SPELL_HARM ) 	eVisual = EffectVisualEffect( VFX_HIT_SPELL_INFLICT_6 );
			else     						eVisual = EffectVisualEffect( VFX_IMP_HEALING_G );

            //Set damage
            //effect 	eDamage = EffectDamage( nDamageAmt, nDamageType );
			
			int CurHP = GetCurrentHitPoints(oTarget);
			int nSave = WillSave(oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oCaster);
	
			if (nSave == 2)
			{
				return;
			}
			else if (nSave == 1)
			{
				int 	nDamageAmt			= ClampInt( 5*nCasterLevel, 0, 75 );
				if ((nSpellID == SPELL_MASS_HEAL) || (nSpellID == 965))
					{
					nDamageAmt			= ClampInt( 5*nCasterLevel, 0, 125 );
					}
				if(CurHP < nDamageAmt){ nDamageAmt= CurHP-1;}
   				effect  eDamage 			= EffectDamage( nDamageAmt, nDamageType );
           		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
           		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
			}
			else
			{
				int 	nDamageAmt			= ClampInt( 10*nCasterLevel, 0, 150 );
				if ((nSpellID == SPELL_MASS_HEAL) || (nSpellID == 965))
					{
					nDamageAmt			= ClampInt( 10*nCasterLevel, 0, 250 );
					}
				if(CurHP < nDamageAmt){ nDamageAmt= CurHP-1;}
   				effect  eDamage 			= EffectDamage( nDamageAmt, nDamageType );
           		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
           		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
			}

        }
    }

}