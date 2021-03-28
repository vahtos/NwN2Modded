//::///////////////////////////////////////////////
//:: General Include for Spells
//:: cmi_ginc_spells
//:: Utility script for spells
//:: Created By: Kaedrin (Matt)
//:: Created On: June 25, 2007
//:://////////////////////////////////////////////

/*	Drammel's Note 3/21/2010: This is a copy of the original for use in the Tome of Battle.
	Using modified versions of the original files caues far too many compatibility issues,
	therefore a copy is made which is hooked into the relavent overriden files rather than
	the original.  Thus, I can use all the functionality of the original without worrying about
	recompiling errors into the original versions.
*/

//#include "X0_I0_SPELLS"

// X2_IP_ADDPROP_POLICY_REPLACE_EXISTING is in x2_inc_itemprop
// x2_inc_itemprop for item properties, reference marker.
// X2_IP_ADDPROP_POLICY_REPLACE_EXISTING
// X2_IP_ADDPROP_POLICY_KEEP_EXISTING
// X2_IP_ADDPROP_POLICY_IGNORE_EXISTING
// bIgnoreDurationType, bIgnoreSubType
// X2_IP_ADDPROP_POLICY_REPLACE_EXISTING should ALWAYS be FALSE, FALSE/TRUE
// only weapon visuals should be FALSE, TRUE
// OnHit props should be TRUE, FALSE
// Rest should be FALSE, FALSE


// Dec 30 : Integrated old Energy Substitution code

#include "tob_x2_inc_itemprop"
#include "tob_cmi_includes"
#include "tob_cmi_inc_sneakattack"
#include "tob_x0_i0_spells"

const int INT_CASTER = 1;
const int CHA_CASTER = 2;
const int WIS_CASTER = 3;

const int ELEMENTAL_TYPE_AIR = 0;
const int ELEMENTAL_TYPE_EARTH = 1;
const int ELEMENTAL_TYPE_FIRE = 2;
const int ELEMENTAL_TYPE_WATER = 3;


object cmi_GetTargetedOrEquippedMeleeWeapon()
{
  object oTarget = GetSpellTargetObject();
  if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
  {
    if (IPGetIsMeleeWeapon(oTarget))
    {
        return oTarget;
    }
    else
    {
        return OBJECT_INVALID;
    }

  }

  object oWeapon1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
  if (GetIsObjectValid(oWeapon1) && IPGetIsMeleeWeapon(oWeapon1))
  {
    return oWeapon1;
  }

  oWeapon1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
  if (GetIsObjectValid(oWeapon1) && IPGetIsMeleeWeapon(oWeapon1))
  {
    return oWeapon1;
  }

  oWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget);
  if (GetIsObjectValid(oWeapon1))
  {
    return oWeapon1;
  }  
  
  oWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);
  if (GetIsObjectValid(oWeapon1))
  {
    return oWeapon1;
  }
  
  oWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget);
  if (GetIsObjectValid(oWeapon1))
  {
    return oWeapon1;
  }
  
  oWeapon1 = GetItemInSlot(INVENTORY_SLOT_ARMS, oTarget);
  if (GetIsObjectValid(oWeapon1) && GetBaseItemType(oWeapon1) == BASE_ITEM_GLOVES)
  {
    return oWeapon1;
  } 

  return OBJECT_INVALID;

}

int AdjustPiercingColdDamage(int nDam, object oTgt)
{		
	int nDamage = nDam;
	if (GetIsObjectValid(oTgt))
	{

		int PercentVuln = 0;
	    effect eVuln = GetFirstEffect(oTgt);	
	    while (GetIsEffectValid(eVuln))
	    {
			if (GetEffectType(eVuln) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE)
			{
				int nDamageType = GetEffectInteger(eVuln, 0);	//Dmg Type
				if (nDamageType == DAMAGE_TYPE_COLD)
				{
					int iVuln = GetEffectInteger(eVuln, 1);	 //Vuln %
					PercentVuln += iVuln;
				}				
			}
	        eVuln = GetNextEffect(oTgt);
	    }	
			
		object oChest = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oTgt);
		if (GetIsObjectValid(oChest))
		{
			int iHasVuln = GetItemHasItemProperty(oChest, ITEM_PROPERTY_DAMAGE_VULNERABILITY);	
			if (iHasVuln)
			{	
				int iTable;
				int iTableVal;
				int iSubType;
				itemproperty ip = GetFirstItemProperty(oChest);
				while (GetIsItemPropertyValid(ip))
				{	
					iTable = GetItemPropertyCostTable(ip); // 22 = Dmg Vuln Table
					iSubType = GetItemPropertySubType(ip); //Dmg Type
					
					if (iTable == 22 && iSubType == IP_CONST_DAMAGETYPE_COLD)	
					{		
						iTableVal = GetItemPropertyCostTableValue(ip); //Vuln %
						if (iTableVal == 4)
							PercentVuln += 50;
						else
						if (iTableVal == 7)
							PercentVuln += 100;	
						else
						if (iTableVal == 3)
							PercentVuln += 25;
						else
						if (iTableVal == 1)
							PercentVuln += 5; 
						else
						if (iTableVal == 5)
							PercentVuln += 75;
						else
						if (iTableVal == 6)
							PercentVuln += 90;
						else
						if (iTableVal == 2)
							PercentVuln += 10;																										
					}													
					ip = GetNextItemProperty(oChest);
				}
			}
		}
		
		if (PercentVuln > 100)
			PercentVuln = 100;	
			
		if (PercentVuln > 0)
			nDamage = nDamage + (nDamage * PercentVuln / 100);
	}
	return nDamage;
}

int GetWarlockCasterLevel(object oCaster)
{
	int nCasterLevel = GetCasterLevel(oCaster);

	if (GetHasFeat(FEAT_PRACTICED_INVOKER,oCaster))
	{
		int nHD = GetHitDice(oCaster);
		if (nCasterLevel < nHD)
		{
			nCasterLevel += 4;
			if (nCasterLevel > nHD)
				nCasterLevel = nHD;
		}

	}	
	
	if (GetHasFeat(FEAT_FEY_POWER, oCaster))
		nCasterLevel++;
	if (GetHasFeat(FEAT_FIENDISH_POWER, oCaster))
		nCasterLevel++;	
		
	return nCasterLevel;
}

int GetPrestigeCasterLevelByClassLevel(int nClass, int nClassLevel, object oTarget)
{
	
	if (nClass == CLASS_BLACK_FLAME_ZEALOT)
		return nClassLevel / 2;
		
	if (nClass == CLASS_FOREST_MASTER || nClass == CLASS_TYPE_SACREDFIST || nClass == CLASS_SHADOWBANE_STALKER)
	{
		//1, 2, 3, 5, 6, 7, 9, and 10
		return (nClassLevel + 1) * 3/4;
	}
	
	if (nClass == CLASS_SWIFTBLADE)
	{
		//2, 3, 5, 6, 8, and 9
		if (nClassLevel < 4)
			return nClassLevel - 1;
		else
		if (nClassLevel < 7)
			return nClassLevel - 2;
		else
		if (nClassLevel < 10)
			return nClassLevel - 3;
		else 
			return nClassLevel - 4;	
	}
	
	if (nClass == CLASS_HOSPITALER)
	{
		//2, 3, 4, 6, 7, 8, and 10	
		if (nClassLevel < 5)
			return nClassLevel - 1;
		else
		if (nClassLevel < 9)
			return nClassLevel - 2;
		else
			return nClassLevel - 3;	
	}	
	
	
	return 0;
}


int GetRangedTouchSpecDamage(object oCaster, int nDice, int nCrit)
{

	int nBonus;
	
	if (GetHasFeat(FEAT_RANGED_TOUCH_SPELL_SPECIALIZATION, oCaster))	
	{
		if (nCrit)
			nBonus = 4;
		else
			nBonus = 2;
	}
	else
		nBonus = 0;
		
	int iImprovedSpellSpec = GetLocalInt(GetModule(), "SpellSpecAdds1PerDie");	
	if (iImprovedSpellSpec)
	{
		if (nCrit)
			nBonus = nDice * 2;
		else
			nBonus = nDice;
	}
	
	int nDMage = GetLevelByClass(CLASS_DAGGERSPELL_MAGE, oCaster);
	if (nDMage > 0)
	{
		object oWeapon1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
		if (GetIsObjectValid(oWeapon1) && (GetBaseItemType(oWeapon1) == BASE_ITEM_DAGGER) )
		{
			nBonus += d4(1) + IPGetWeaponEnhancementBonus(oWeapon1);
		}	
		/*if (nDMage > 4)
		{
			object oWeapon2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);
			if (GetIsObjectValid(oWeapon2) && (GetBaseItemType(oWeapon2) == BASE_ITEM_DAGGER) )
			{
				nBonus += d4(1) + IPGetWeaponEnhancementBonus(oWeapon2);
			}
		}*/

	}
		
			
	return nBonus;
}

int GetMeleeTouchSpecDamage(object oCaster, int nDice, int nCrit)
{
	//Needs +1/dice cmi_option still
	int nBonus;
	
	if (GetHasFeat(FEAT_MELEE_TOUCH_SPELL_SPECIALIZATION, oCaster))	
	{
		if (nCrit)
			nBonus = 4;
		else
			nBonus = 2;
	}
	else
		nBonus = 0;
		
	int iImprovedSpellSpec = GetLocalInt(GetModule(), "SpellSpecAdds1PerDie");	
	if (iImprovedSpellSpec)
	{
		if (nCrit)
			nBonus = nDice * 2;
		else
			nBonus = nDice;
	}	
	
	int nDMage = GetLevelByClass(CLASS_DAGGERSPELL_MAGE, oCaster);
	if (nDMage > 0)
	{
		object oWeapon1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
		if (GetIsObjectValid(oWeapon1) && (GetBaseItemType(oWeapon1) == BASE_ITEM_DAGGER) )
		{
			nBonus += d4(1) + IPGetWeaponEnhancementBonus(oWeapon1);
		}	
		if (nDMage > 4)
		{
			object oWeapon2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);
			if (GetIsObjectValid(oWeapon2) && (GetBaseItemType(oWeapon2) == BASE_ITEM_DAGGER) )
			{
				nBonus += d4(1) + IPGetWeaponEnhancementBonus(oWeapon2);
			}
		}

	}
	
	int nDShaper = GetLevelByClass(CLASS_DAGGERSPELL_SHAPER, oCaster);
	if (nDShaper > 0)
	{
		object oWeapon1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
		if (GetIsObjectValid(oWeapon1) && (GetBaseItemType(oWeapon1) == BASE_ITEM_DAGGER) )
		{
			nBonus += d4(1) + IPGetWeaponEnhancementBonus(oWeapon1);
		}	
		if (nDShaper > 9)
		{
			object oWeapon2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);
			if (GetIsObjectValid(oWeapon2) && (GetBaseItemType(oWeapon2) == BASE_ITEM_DAGGER) )
			{
				nBonus += d4(1) + IPGetWeaponEnhancementBonus(oWeapon2);
			}
		}

	}					
	
	return nBonus;		
}

int GetBlackguardCasterLevel(object oCaster)
{
	int nCasterLvl = GetLevelByClass(CLASS_TYPE_BLACKGUARD, oCaster);
	int nKoT = GetLevelByClass(CLASS_KNIGHT_TIERDRIAL, oCaster);
	int nDrSlr = GetLevelByClass(CLASS_DRAGONSLAYER, oCaster);
	int nCoN = GetLevelByClass(CLASS_CHILD_NIGHT, oCaster);
	
	if (GetHasFeat(FEAT_PRACTICED_SPELLCASTER_BLACKGUARD, oCaster))
	{
		nCasterLvl += 4;
	}	
	
	if (nKoT > 0 && GetHasFeat(FEAT_KOT_SPELLCASTING_BLACKGUARD, oCaster))
		nCasterLvl += nKoT;	
		
	if (nDrSlr > 0 && GetHasFeat(FEAT_DRSLR_SPELLCASTING_BLACKGUARD, oCaster))
		nCasterLvl += nDrSlr / 2;
		
	if (nCoN > 1 && GetHasFeat(FEAT_CHLDNIGHT_SPELLCASTING_BLACKGUARD, oCaster))
		nCasterLvl += (nCoN - 1);			
		
	if (nCasterLvl > GetHitDice(oCaster))
		nCasterLvl = GetHitDice(oCaster);				
	
	return nCasterLvl;
}

int GetAssassinCasterLevel(object oCaster)
{
	int nAssasLvl = GetLevelByClass(CLASS_TYPE_ASSASSIN);
	int nAvengLvl = GetLevelByClass(CLASS_AVENGER);
	int nKoT = GetLevelByClass(CLASS_KNIGHT_TIERDRIAL, oCaster);
	int nDrSlr = GetLevelByClass(CLASS_DRAGONSLAYER, oCaster);
	int nCoN = GetLevelByClass(CLASS_CHILD_NIGHT, oCaster);
				
	if (GetHasFeat(FEAT_PRACTICED_SPELLCASTER_ASSASSIN, oCaster))
	{
			nAssasLvl += 4;
	}
	if (GetHasFeat(FEAT_PRACTICED_SPELLCASTER_AVENGER, oCaster))
	{
			nAvengLvl += 4;
	}	
	
	if (nKoT > 0 && GetHasFeat(FEAT_KOT_SPELLCASTING_ASSASSIN, oCaster))
		nAssasLvl += nKoT;	
	if (nKoT > 0 && GetHasFeat(FEAT_KOT_SPELLCASTING_AVENGER, oCaster))
		nAvengLvl += nKoT;							
		
	if (nDrSlr > 0 && GetHasFeat(FEAT_DRSLR_SPELLCASTING_ASSASSIN, oCaster))
		nAssasLvl += nDrSlr / 2;	
	if (nDrSlr > 0 && GetHasFeat(FEAT_DRSLR_SPELLCASTING_AVENGER, oCaster))
		nAvengLvl += nDrSlr / 2;	
		
	if (nCoN > 1 && GetHasFeat(FEAT_CHLDNIGHT_SPELLCASTING_ASSASSIN, oCaster))
		nAssasLvl += (nCoN - 1);	
	if (nCoN > 1 && GetHasFeat(FEAT_CHLDNIGHT_SPELLCASTING_AVENGER, oCaster))
		nAvengLvl += (nCoN - 1);						
	
	int nCasterLvl = nAssasLvl + nAvengLvl;	
	
	if (nCasterLvl > GetHitDice(oCaster))
		nCasterLvl = GetHitDice(oCaster);	
	
	return nCasterLvl;
}

int GetWarlockDC(object oWarlock, int nInvocation = 0)
{
	int nDC = GetSpellSaveDC();
	
	if (nInvocation == 0 && GetHasFeat(FEAT_ABILITY_FOCUS_ELDRITCH_BLAST, oWarlock))
	{
		nDC += 2;
	}
	if (nInvocation == 1 && GetHasFeat(FEAT_ABILITY_FOCUS_INVOCATIONS, oWarlock))
	{
		nDC += 2;	
	}
	
	if (GetHasFeat(FEAT_FEY_POWER, oWarlock))
		nDC++;
		
	if (GetHasFeat(FEAT_FIENDISH_POWER, oWarlock))
		nDC++;

	return nDC;
}

int GetConeEffect(int DAMAGE_TYPE_X)
{
	switch (DAMAGE_TYPE_X)
	{
		case DAMAGE_TYPE_ACID:
			return VFX_DUR_CONE_ACID;
		case DAMAGE_TYPE_ALL:
			return VFX_DUR_CONE_MAGIC;
		case DAMAGE_TYPE_BLUDGEONING:
			return VFX_DUR_CONE_MAGIC;
		case DAMAGE_TYPE_COLD:
			return VFX_DUR_CONE_ICE;
		case DAMAGE_TYPE_DIVINE:
			return VFX_DUR_CONE_HOLY;
		case DAMAGE_TYPE_ELECTRICAL:
			return VFX_DUR_CONE_LIGHTNING;
		case DAMAGE_TYPE_FIRE:
			return VFX_DUR_CONE_FIRE;				
		case DAMAGE_TYPE_MAGICAL:
			return VFX_DUR_CONE_MAGIC;
		case DAMAGE_TYPE_NEGATIVE:
			return VFX_DUR_CONE_EVIL;
		case DAMAGE_TYPE_PIERCING:
			return VFX_DUR_CONE_MAGIC;
		case DAMAGE_TYPE_POSITIVE:
			return VFX_DUR_CONE_HOLY;
		case DAMAGE_TYPE_SLASHING:
			return VFX_DUR_CONE_MAGIC;
		case DAMAGE_TYPE_SONIC:
			return VFX_DUR_CONE_SONIC;																																	
		default: 
			return VFX_DUR_CONE_MAGIC;
	}
	return VFX_DUR_CONE_MAGIC;
}

int GetHitEffect(int DAMAGE_TYPE_X)
{
	switch (DAMAGE_TYPE_X)
	{
		case DAMAGE_TYPE_ACID:
			return VFX_HIT_SPELL_ACID;
		case DAMAGE_TYPE_ALL:
			return VFX_HIT_SPELL_MAGIC;
		case DAMAGE_TYPE_BLUDGEONING:
			return VFX_HIT_SPELL_MAGIC;
		case DAMAGE_TYPE_COLD:
			return VFX_HIT_SPELL_ICE;
		case DAMAGE_TYPE_DIVINE:
			return VFX_HIT_SPELL_HOLY;
		case DAMAGE_TYPE_ELECTRICAL:
			return VFX_HIT_SPELL_LIGHTNING;
		case DAMAGE_TYPE_FIRE:
			return VFX_HIT_SPELL_FIRE;					
		case DAMAGE_TYPE_MAGICAL:
			return VFX_HIT_SPELL_MAGIC;
		case DAMAGE_TYPE_NEGATIVE:
			return VFX_HIT_SPELL_NECROMANCY;
		case DAMAGE_TYPE_PIERCING:
			return VFX_HIT_SPELL_MAGIC;
		case DAMAGE_TYPE_POSITIVE:
			return VFX_HIT_SPELL_HOLY;
		case DAMAGE_TYPE_SLASHING:
			return VFX_HIT_SPELL_MAGIC;
		case DAMAGE_TYPE_SONIC:
			return VFX_HIT_SPELL_SONIC;																																	
		default: 
			return VFX_HIT_SPELL_MAGIC;
	}
	return VFX_HIT_SPELL_MAGIC;
}

int GetSaveType(int DAMAGE_TYPE_X)
{			
	switch (DAMAGE_TYPE_X)
	{
		case DAMAGE_TYPE_ACID:
			return SAVING_THROW_TYPE_ACID;
		case DAMAGE_TYPE_ALL:
			return SAVING_THROW_TYPE_ALL;
		case DAMAGE_TYPE_BLUDGEONING:
			return SAVING_THROW_TYPE_ALL;
		case DAMAGE_TYPE_COLD:
			return SAVING_THROW_TYPE_COLD;
		case DAMAGE_TYPE_DIVINE:
			return SAVING_THROW_TYPE_DIVINE;
		case DAMAGE_TYPE_ELECTRICAL:
			return SAVING_THROW_TYPE_ELECTRICITY;
		case DAMAGE_TYPE_FIRE:
			return SAVING_THROW_TYPE_FIRE;		
		case DAMAGE_TYPE_MAGICAL:
			return SAVING_THROW_TYPE_ALL;
		case DAMAGE_TYPE_NEGATIVE:
			return SAVING_THROW_TYPE_NEGATIVE;
		case DAMAGE_TYPE_PIERCING:
			return SAVING_THROW_TYPE_ALL;
		case DAMAGE_TYPE_POSITIVE:
			return SAVING_THROW_TYPE_POSITIVE;
		case DAMAGE_TYPE_SLASHING:
			return SAVING_THROW_TYPE_ALL;
		case DAMAGE_TYPE_SONIC:
			return SAVING_THROW_TYPE_SONIC;																																	
		default: 
			return SAVING_THROW_TYPE_ALL;
	}
	return SAVING_THROW_TYPE_ALL;
}

int GetDamageType(int DAMAGE_TYPE_X, object oCaster = OBJECT_SELF, int isSpell = 1, int isEnergySubsValid = 0)
{	
	//Handles Piercing Cold
	if (GetHasFeat(FEAT_FROSTMAGE_PIERCING_COLD , oCaster) && isSpell && DAMAGE_TYPE_X == DAMAGE_TYPE_COLD)
	{
		if (DAMAGE_TYPE_X == DAMAGE_TYPE_COLD)
			return DAMAGE_TYPE_MAGICAL;
	}
		
	if (GetHasFeat(FEAT_ENERGY_SUBSTITUTION , oCaster) && isSpell && isEnergySubsValid)
	{
		if (GetHasSpellEffect(SPELLABILITY_ENERGY_SUBSTITUTION_ACID,oCaster) )
			return DAMAGE_TYPE_ACID;
		else
		if (GetHasSpellEffect(SPELLABILITY_ENERGY_SUBSTITUTION_COLD,oCaster) )
			return DAMAGE_TYPE_COLD;
		else
		if (GetHasSpellEffect(SPELLABILITY_ENERGY_SUBSTITUTION_ELEC,oCaster) )
			return DAMAGE_TYPE_ELECTRICAL;
		else
		if (GetHasSpellEffect(SPELLABILITY_ENERGY_SUBSTITUTION_FIRE,oCaster) )
			return DAMAGE_TYPE_FIRE;
		else
		if (GetHasSpellEffect(SPELLABILITY_ENERGY_SUBSTITUTION_SONIC,oCaster) )
			return DAMAGE_TYPE_SONIC;											
	}
		
	switch (DAMAGE_TYPE_X)
	{
		case DAMAGE_TYPE_ACID:
			return DAMAGE_TYPE_ACID;
		case DAMAGE_TYPE_ALL:
			return DAMAGE_TYPE_ALL;
		case DAMAGE_TYPE_BLUDGEONING:
			return DAMAGE_TYPE_BLUDGEONING;
		case DAMAGE_TYPE_COLD:
			return DAMAGE_TYPE_COLD;
		case DAMAGE_TYPE_DIVINE:
			return DAMAGE_TYPE_DIVINE;
		case DAMAGE_TYPE_ELECTRICAL:
			return DAMAGE_TYPE_ELECTRICAL;
		case DAMAGE_TYPE_FIRE:
			return DAMAGE_TYPE_FIRE;			
		case DAMAGE_TYPE_MAGICAL:
			return DAMAGE_TYPE_MAGICAL;
		case DAMAGE_TYPE_NEGATIVE:
			return DAMAGE_TYPE_NEGATIVE;
		case DAMAGE_TYPE_PIERCING:
			return DAMAGE_TYPE_PIERCING;
		case DAMAGE_TYPE_POSITIVE:
			return DAMAGE_TYPE_POSITIVE;
		case DAMAGE_TYPE_SLASHING:
			return DAMAGE_TYPE_SLASHING;
		case DAMAGE_TYPE_SONIC:
			return DAMAGE_TYPE_SONIC;																																	
		default: 
			return DAMAGE_TYPE_ALL;
	}
	return DAMAGE_TYPE_ALL;
}

void WildShape_Unarmed(object oPC, float fDuration)
{
	object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);	
	
	itemproperty iBonusFeat;
	
	if (GetHasFeat(1355, oPC))
	{
		iBonusFeat = ItemPropertyBonusFeat(293); //	Power Crit Cr. 
		AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat,oHide,fDuration);	
	}
	
	if (GetHasFeat(1129, oPC))
	{
		iBonusFeat = ItemPropertyBonusFeat(345); //	G Wpn Foc Cr. 
		AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat,oHide,fDuration);	
	}	
	
	if (GetHasFeat(1169, oPC))
	{
		iBonusFeat = ItemPropertyBonusFeat(385); //	G Wpn Spec Cr.
		AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat,oHide,fDuration);	
	}
	
	if (GetHasFeat(100, oPC))
	{
		iBonusFeat = ItemPropertyBonusFeat(402); //	Wpn Foc Cr.
		AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat,oHide,fDuration);	
	}
	
	if (GetHasFeat(62, oPC))
	{
		iBonusFeat = ItemPropertyBonusFeat(IPRP_FEAT_IMPCRITCREATURE); //	Imp Crit Cr.
		AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat,oHide,fDuration);	
	}	
	
	if (GetHasFeat(138, oPC))
	{
		iBonusFeat = ItemPropertyBonusFeat(IPRP_FEAT_WPNSPEC_CREATURE); //	Wpn Spec Cr.
		AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat,oHide,fDuration);	
	}
	
	if (GetHasFeat(630, oPC))
	{
		iBonusFeat = ItemPropertyBonusFeat(IPRP_FEAT_EPICWPNFOC_CREATURE); //	 Epic Wpn Foc Cr.
		AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat,oHide,fDuration);	
	}	
	
	if (GetHasFeat(668, oPC))
	{
		iBonusFeat = ItemPropertyBonusFeat(IPRP_FEAT_EPICWPNSPEC_CREATURE); //	 Epic Wpn Spec Cr.
		AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat,oHide,fDuration);	
	}	
	
	if (GetHasFeat(720, oPC))
	{
		iBonusFeat = ItemPropertyBonusFeat(IPRP_FEAT_EPICOVERWHELMCRIT_CREATURE); //	 Epic Over Crit Cr.
		AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat,oHide,fDuration);	
	}
												
	//IPRP   xxx       Unarmed_FeatId
	//293 Power Crit Cr. 1355
	//345 G Wpn Foc Cr. 1129
	//385 G Wpn Spec Cr. 1169
	//402 Wpn Foc Cr.  100
	//804 Imp Crit Cr.   62
	//805 Wpn Spec Cr. 138
	//806 Epic Wpn Foc Cr. 	630
	//807 Epic Wpn Spec Cr. 668
	//808 Epic Over Crit Cr. 720
	
}

void BuffSummons(object oPC, int nElemental = 0, int nAshbound = 0)
{
	object oTarget = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);
	if (GetHasFeat(FEAT_BECKON_THE_FROZEN, oPC))
	{
		effect eDmg = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_COLD);
		effect eDmgImm = EffectDamageResistance(DAMAGE_TYPE_COLD, 9999, 0);
		effect eDmgVul = EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, 50);
		effect eLink = EffectLinkEffects(eDmgVul, eDmgImm);
		eLink = EffectLinkEffects(eLink, eDmg);
		eLink = SetEffectSpellId(eLink,FEAT_BECKON_THE_FROZEN);
		eLink = SupernaturalEffect(eLink);	
		DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget));
	}
	if (nElemental == 1 && GetHasFeat(FEAT_AUGMENT_ELEMENTAL, oPC))
	{	
		effect eLink = EffectTemporaryHitpoints(GetHitDice(oTarget)*2);
		eLink = SetEffectSpellId(eLink,FEAT_AUGMENT_ELEMENTAL);
		eLink = SupernaturalEffect(eLink);	
		DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget));
	
		itemproperty iEnhance = ItemPropertyEnhancementBonus(2);	
	   object oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget);
	  if (GetIsObjectValid(oWeapon))
	  {
		AddItemProperty(DURATION_TYPE_PERMANENT, iEnhance, oWeapon);
	  } 
	
	  oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);
	  if (GetIsObjectValid(oWeapon))
	  {
		AddItemProperty(DURATION_TYPE_PERMANENT, iEnhance, oWeapon);
	  }
	
	  oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget);
	  if (GetIsObjectValid(oWeapon))
	  {
		AddItemProperty(DURATION_TYPE_PERMANENT, iEnhance, oWeapon);
	  }	
		
	}
	
	if (nAshbound == 1 && GetHasFeat(FEAT_ASHBOUND, oPC))
	{	
		effect eLink = EffectAttackIncrease(3);
		eLink = SetEffectSpellId(eLink,FEAT_ASHBOUND);
		eLink = SupernaturalEffect(eLink);	
		DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget));
	}		
	
	//return TRUE;

}

effect IncorporealEffect(object oTarget)
{

	int nChaAC = GetAbilityModifier(ABILITY_CHARISMA, oTarget);
	effect eAC = EffectACIncrease(nChaAC, AC_DEFLECTION_BONUS);
	effect eConceal = EffectConcealment(50);
	effect eSR = EffectSpellResistanceIncrease(25);
	
	effect eLink = EffectLinkEffects(eAC,eConceal);
	eLink = EffectLinkEffects(eSR, eLink);
	eLink = SupernaturalEffect(eLink);

	return eLink;
	
}

void ApplyPhantomStats(object oOwner)
{
	object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oOwner);
	effect eLink = IncorporealEffect(oSummon);
	effect eDamage = EffectDamageIncrease(DAMAGE_BONUS_2d10, DAMAGE_TYPE_COLD);
	eLink = EffectLinkEffects(eDamage, eLink);

	DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oSummon));
}

void WildshapeCheck(object oTarget, object oCursedPolyItem)
{

    if (!GetHasEffect( EFFECT_TYPE_POLYMORPH, oTarget))
    {
    	DelayCommand(0.3f, DestroyObject(oCursedPolyItem, 0.1f, FALSE));
		RemoveEffectsFromSpell(oTarget, SPELLABILITY_EXALTED_WILD_SHAPE);
		RemoveEffectsFromSpell(oTarget, -FEAT_NATWARR_NATARM_CROC);
		RemoveEffectsFromSpell(oTarget, -FEAT_NATWARR_NATARM_GRIZZLY);
		RemoveEffectsFromSpell(oTarget, -FEAT_NATWARR_NATARM_GROWTH);
		RemoveEffectsFromSpell(oTarget, -FEAT_NATWARR_NATARM_BLAZE);
		RemoveEffectsFromSpell(oTarget, -FEAT_NATWARR_NATARM_CLOUD);
		RemoveEffectsFromSpell(oTarget, -FEAT_NATWARR_NATARM_EARTH);
		if (GetLevelByClass(CLASS_FIST_FOREST, oTarget) > 0)
			ExecuteScript("cmi_s2_fotfacbonus",oTarget);									
        return;
    }
	else
	    DelayCommand(6.0f, WildshapeCheck(oTarget, oCursedPolyItem) );

}

void AddSpellSlotsToObject(object oSource, object oTarget, float nDuration)
{

		if (GetIsObjectValid(oSource))
		{
			itemproperty ipLoop=GetFirstItemProperty(oSource);
			while (GetIsItemPropertyValid(ipLoop))
			{
			
				//SendMessageToPC(OBJECT_SELF, "InLoop");
			  	if (GetItemPropertyType(ipLoop)==ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N)
				{
				  //SendMessageToPC(OBJECT_SELF, "Bonus Slot Found on Item");
				  AddItemProperty(DURATION_TYPE_TEMPORARY, ipLoop, oTarget,nDuration);
				}
			
			   	ipLoop=GetNextItemProperty(oSource);
			}
		}

}


int GetDamageBonusByValue(int nValue)
{

	switch (nValue)
	{
		case 1: 
			return DAMAGE_BONUS_1;
		break;
		
		case 2: 
			return DAMAGE_BONUS_2;
		break;	
		
		case 3: 
			return DAMAGE_BONUS_3;
		break;	
	
		case 4: 
			return DAMAGE_BONUS_4;
		break;	

		case 5: 
			return DAMAGE_BONUS_5;
		break;	
		
		case 6: 
			return DAMAGE_BONUS_6;
		break;	

		case 7: 
			return DAMAGE_BONUS_7;
		break;	
		
		case 8: 
			return DAMAGE_BONUS_8;
		break;	
		
		case 9: 
			return DAMAGE_BONUS_9;
		break;	
		
		case 10: 
			return DAMAGE_BONUS_10;
		break;	
		
		case 11: 
			return DAMAGE_BONUS_11;
		break;																								
	
		case 12: 
			return DAMAGE_BONUS_12;
		break;	
		
		case 13: 
			return DAMAGE_BONUS_13;
		break;	
		
		case 14: 
			return DAMAGE_BONUS_14;
		break;	
		
		case 15: 
			return DAMAGE_BONUS_15;
		break;
					
		case 16: 
			return DAMAGE_BONUS_16;
		break;
					
		case 17: 
			return DAMAGE_BONUS_17;
		break;
					
		case 18: 
			return DAMAGE_BONUS_18;
		break;
					
		case 19: 
			return DAMAGE_BONUS_19;
		break;
					
		case 20: 
			return DAMAGE_BONUS_20;
		break;
				
		default: 
			return DAMAGE_BONUS_21;																			
		break;											
	}
	return 0;

}

int UsePaladinFullCaster()
{

	int nPaladinFullCaster = GetLocalInt(GetModule(), "PaladinFullCaster");

	if	( nPaladinFullCaster )
		return TRUE;
	else
		return FALSE;

}

int UseRangerFullCaster()
{

	int nRangerFullCaster = GetLocalInt(GetModule(), "RangerFullCaster");

	if	( nRangerFullCaster )
		return TRUE;
	else
		return FALSE;

}

int GetCasterLevelForRangers(object oCaster = OBJECT_SELF)
{

	int nRangerCaster = 	GetLastSpellCastClass();
	int nCasterLevel = 0;
	nCasterLevel = GetCasterLevel(oCaster);	
	//SendMessageToPC(GetFirstPC(),IntToString(nCasterLevel));
	if (nRangerCaster != CLASS_TYPE_RANGER) // Not a Ranger
	{
		return nCasterLevel;		
	}
	else // Use full caster level for Rangers
	{
	
		int nFullCaster = UseRangerFullCaster();
		if (nFullCaster)
		{
			int nRanger = GetLevelByClass(CLASS_TYPE_RANGER, oCaster);
			
			//Begin Ugly Fix till the new caster level function is done
			if (GetHasFeat(FEAT_NATWAR_SPELLCASTING_RANGER, oCaster))
			{
				nRanger += GetLevelByClass(CLASS_NATURES_WARRIOR, oCaster)/2;
			}
			if (GetHasFeat(FEAT_DSHAPE_SPELLCASTING_RANGER, oCaster))
			{
				nRanger += GetLevelByClass(CLASS_DAGGERSPELL_SHAPER, oCaster) - 1;
			}
		    if (GetHasFeat(FEAT_CHLDNIGHT_SPELLCASTING_RANGER, oCaster))
		    {
		        nRanger += GetLevelByClass(CLASS_CHILD_NIGHT, oCaster) - 1;
		    }	
		    if (GetHasFeat(FEAT_SWRDNCR_SPELLCASTING_RANGER, oCaster))
		    {
		        nRanger += GetLevelByClass(CLASS_SWORD_DANCER, oCaster);
		    }						
		    if (GetHasFeat(FEAT_DRSLR_SPELLCASTING_RANGER, oCaster))
		    {
		        nRanger += (GetLevelByClass(CLASS_DRAGONSLAYER, oCaster) + 1 ) / 2;
		    }	
		    if (GetHasFeat(FEAT_ELDDISC_SPELLCASTING_RANGER, oCaster))
		    {
		        nRanger += GetLevelByClass(CLASS_ELDRITCH_DISCIPLE, oCaster);
		    }
		    if (GetHasFeat(FEAT_KOT_SPELLCASTING_RANGER, oCaster))
		    {
		        nRanger += GetLevelByClass(CLASS_KNIGHT_TIERDRIAL, oCaster);
		    }	
		    if (GetHasFeat(FEAT_SHDWSTLKR_SPELLCASTING_RANGER, oCaster))
		    {
		        nRanger += (GetLevelByClass(CLASS_SHADOWBANE_STALKER, oCaster) + 1) * 3/4;
		    }			
		    if (GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_RANGER, oCaster))
		    {
		        nRanger += GetLevelByClass(CLASS_FROST_MAGE, oCaster);
		    }	
		    if (GetHasFeat(FEAT_CANAITH_SPELLCASTING_RANGER, oCaster))
		    {
		        nRanger += GetLevelByClass(CLASS_CANAITH_LYRIST, oCaster);
		    }							
		    if (GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_RANGER, oCaster))
		    {
		        nRanger += GetLevelByClass(CLASS_HEARTWARDER, oCaster);
		    }			
		    if (GetHasFeat(FEAT_FOREST_MASTER_SPELLCASTING_RANGER, oCaster))
		    {
		        nRanger += (GetLevelByClass(CLASS_FOREST_MASTER, oCaster) + 1) * 3/4;
		    }				
		    if (GetHasFeat(FEAT_MASTER_RADIANCE_SPELLCASTING_RANGER, oCaster))
		    {
		        nRanger += GetLevelByClass(CLASS_MASTER_RADIANCE, oCaster) - 1;
		    }				
		    if (GetHasFeat(FEAT_LION_TALISID_SPELLCASTING_RANGER, oCaster))
		    {
		        nRanger += GetLevelByClass(CLASS_LION_TALISID, oCaster);
		    }				
		    if (GetHasFeat(FEAT_STORMSINGER_SPELLCASTING_RANGER, oCaster))
		    {
		        nRanger += GetLevelByClass(CLASS_STORMSINGER, oCaster);
		    }			
		    if (GetHasFeat(FEAT_BFZ_SPELLCASTING_RANGER, oCaster))
		    {
		        nRanger += GetLevelByClass(CLASS_BLACK_FLAME_ZEALOT, oCaster) / 2;
		    }				
			if (GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_RANGER, oCaster))
		    {
				int nLevel = GetLevelByClass(CLASS_HOSPITALER, oCaster);
		        nRanger += GetPrestigeCasterLevelByClassLevel(CLASS_HOSPITALER, nLevel, oCaster);
		    }		
		    if (GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_RANGER, oCaster))
		    {
		        nRanger += GetLevelByClass(CLASS_SHINING_BLADE, oCaster) / 2;
		    }			
		    if (GetHasFeat(1552, oCaster)) //sacred fist
		    {
		        nRanger += (GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster) + 1) * 3/4;
		    }
		    if (GetHasFeat(1583, oCaster)) //harper
		    {
		        nRanger += GetLevelByClass(CLASS_TYPE_HARPER, oCaster) - 1;
		    }
		    if (GetHasFeat(1811, oCaster)) //warpriest
		    {
		        nRanger += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster) / 2;
		    }
		    if (GetHasFeat(2036, oCaster)) //stormlord
		    {
		        nRanger += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster);
		    }
		    if (GetHasFeat(2254, oCaster)) //doomguide
		    {
		        nRanger += GetLevelByClass(60, oCaster);
		    }			
					
			//End Ugly Fix
			
			int nHD = GetHitDice(oCaster);	
			if (nHD > nRanger)
			{
				if (GetHasFeat(FEAT_PRACTICED_SPELLCASTER_RANGER, oCaster))
					nRanger = nRanger + 4;
				if (nRanger > nHD)
					nRanger = nHD;
					
				return nRanger;
				
			}
			else
				return nHD; // Full Paladin	
		}
		else return nCasterLevel;
		
	}

}

int GetCasterLevelForPaladins(object oCaster = OBJECT_SELF)
{

	int nPaladinCaster = 	GetLastSpellCastClass();
	int nCasterLevel = 0;
	nCasterLevel = GetCasterLevel(oCaster);	
	//SendMessageToPC(GetFirstPC(),IntToString(nCasterLevel));
	if (nPaladinCaster != CLASS_TYPE_PALADIN) // Not a Paladin
	{
		return nCasterLevel;		
	}
	else // Use full caster level for Paladins
	{
	
		int nFullCaster = UsePaladinFullCaster();
		if (nFullCaster)
		{
			int nPaladin = GetLevelByClass(CLASS_TYPE_PALADIN, oCaster);
			
			//Begin Ugly Fix till the new caster level function is done
			if (GetHasFeat(FEAT_DSHAPE_SPELLCASTING_PALADIN, oCaster))
			{
				nPaladin += GetLevelByClass(CLASS_DAGGERSPELL_SHAPER, oCaster) - 1;
			}
		    if (GetHasFeat(FEAT_COTSF_SPELLCASTING_PALADIN, oCaster))
		    {
		        nPaladin += GetLevelByClass(CLASS_CHAMP_SILVER_FLAME, oCaster);
		    }	
		    if (GetHasFeat(FEAT_CHLDNIGHT_SPELLCASTING_PALADIN, oCaster))
		    {
		        nPaladin += GetLevelByClass(CLASS_CHILD_NIGHT, oCaster) - 1;
		    }	
		    if (GetHasFeat(FEAT_SWRDNCR_SPELLCASTING_PALADIN, oCaster))
		    {
		        nPaladin += GetLevelByClass(CLASS_SWORD_DANCER, oCaster);
		    }						
		    if (GetHasFeat(FEAT_DRSLR_SPELLCASTING_PALADIN, oCaster))
		    {
		        nPaladin += (GetLevelByClass(CLASS_DRAGONSLAYER, oCaster) + 1 ) / 2;
		    }	
		    if (GetHasFeat(FEAT_ELDDISC_SPELLCASTING_PALADIN, oCaster))
		    {
		        nPaladin += GetLevelByClass(CLASS_ELDRITCH_DISCIPLE, oCaster);
		    }
		    if (GetHasFeat(FEAT_KOT_SPELLCASTING_PALADIN, oCaster))
		    {
		        nPaladin += GetLevelByClass(CLASS_KNIGHT_TIERDRIAL, oCaster);
		    }	
		    if (GetHasFeat(FEAT_SHDWSTLKR_SPELLCASTING_PALADIN, oCaster))
		    {
		        nPaladin += (GetLevelByClass(CLASS_SHADOWBANE_STALKER, oCaster) + 1) * 3/4;
		    }			
		    if (GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_PALADIN, oCaster))
		    {
		        nPaladin += GetLevelByClass(CLASS_FROST_MAGE, oCaster);
		    }	
		    if (GetHasFeat(FEAT_CANAITH_SPELLCASTING_PALADIN, oCaster))
		    {
		        nPaladin += GetLevelByClass(CLASS_CANAITH_LYRIST, oCaster);
		    }							
		    if (GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_PALADIN, oCaster))
		    {
		        nPaladin += GetLevelByClass(CLASS_HEARTWARDER, oCaster);
		    }			
		    if (GetHasFeat(FEAT_FOREST_MASTER_SPELLCASTING_PALADIN, oCaster))
		    {
		        nPaladin += (GetLevelByClass(CLASS_FOREST_MASTER, oCaster) + 1) * 3/4;
		    }				
		    if (GetHasFeat(FEAT_MASTER_RADIANCE_SPELLCASTING_PALADIN, oCaster))
		    {
		        nPaladin += GetLevelByClass(CLASS_MASTER_RADIANCE, oCaster) - 1;
		    }				
		    if (GetHasFeat(FEAT_LION_TALISID_SPELLCASTING_PALADIN, oCaster))
		    {
		        nPaladin += GetLevelByClass(CLASS_LION_TALISID, oCaster);
		    }				
		    if (GetHasFeat(FEAT_STORMSINGER_SPELLCASTING_PALADIN, oCaster))
		    {
		        nPaladin += GetLevelByClass(CLASS_STORMSINGER, oCaster);
		    }			
		    if (GetHasFeat(FEAT_BFZ_SPELLCASTING_PALADIN, oCaster))
		    {
		        nPaladin += GetLevelByClass(CLASS_BLACK_FLAME_ZEALOT, oCaster) / 2;
		    }				
			if (GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_PALADIN, oCaster))
		    {
				int nLevel = GetLevelByClass(CLASS_HOSPITALER, oCaster);
		        nPaladin += GetPrestigeCasterLevelByClassLevel(CLASS_HOSPITALER, nLevel, oCaster);
		    }		
		    if (GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_PALADIN, oCaster))
		    {
		        nPaladin += GetLevelByClass(CLASS_SHINING_BLADE, oCaster) / 2;
		    }			
		    if (GetHasFeat(1551, oCaster)) //sacred fist
		    {
		        nPaladin += (GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster) + 1) * 3/4;
		    }
		    if (GetHasFeat(1582, oCaster)) //harper
		    {
		        nPaladin += GetLevelByClass(CLASS_TYPE_HARPER, oCaster) - 1;
		    }
		    if (GetHasFeat(1810, oCaster)) //warpriest
		    {
		        nPaladin += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster) / 2;
		    }
		    if (GetHasFeat(2035, oCaster)) //stormlord
		    {
		        nPaladin += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster);
		    }
		    if (GetHasFeat(2250, oCaster)) //doomguide
		    {
		        nPaladin += GetLevelByClass(60, oCaster);
		    }			
					
			//End Ugly Fix
			
			int nHD = GetHitDice(oCaster);	
			if (nHD > nPaladin)
			{
				if (GetHasFeat(FEAT_PRACTICED_SPELLCASTER_PALADIN, oCaster))
					nPaladin = nPaladin + 4;
				if (nPaladin > nHD)
					nPaladin = nHD;
					
				return nPaladin;
				
			}
			else
				return nHD; // Full Paladin	
		}
		else return nCasterLevel;
		
	}

}

int GetPalRngCasterLevel(object oCaster = OBJECT_SELF)
{
	int nLastCastingClass = GetLastSpellCastClass();
	int nCasterLevel = GetHitDice(oCaster);
	if (nLastCastingClass == CLASS_TYPE_PALADIN)
	{
		nCasterLevel = GetCasterLevelForPaladins(oCaster);
	}
	else	
	if (nLastCastingClass == CLASS_TYPE_RANGER)
	{
		nCasterLevel = GetCasterLevelForRangers(oCaster);
	}
	else
		nCasterLevel = GetCasterLevel(oCaster);
	return nCasterLevel;
	
}

object IPGetTargetedOrEquippedShield()
{
  object oTarget = GetSpellTargetObject();
  if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
  {
    if (GetBaseItemType(oTarget) == BASE_ITEM_LARGESHIELD ||
                               GetBaseItemType(oTarget) == BASE_ITEM_SMALLSHIELD ||
                                GetBaseItemType(oTarget) == BASE_ITEM_TOWERSHIELD)
    {
        return oTarget;
    }
    else
    {
		return OBJECT_INVALID;
    }


  }
  else
  {
      object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
      if (GetIsObjectValid(oShield) && (GetBaseItemType(oShield) == BASE_ITEM_LARGESHIELD ||
                               GetBaseItemType(oShield) == BASE_ITEM_SMALLSHIELD ||
                                GetBaseItemType(oShield) == BASE_ITEM_TOWERSHIELD))
      {
        return oShield;
      }
    }



  return OBJECT_INVALID;

}


object IPGetTargetedOrEquippedWeapon()
{
  object oTarget = GetSpellTargetObject();
  if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
  {
  
   if (IPGetIsMeleeWeapon(oTarget) || IPGetIsRangedWeapon(oTarget))
    {
        return oTarget;
    }
    else
    {
        return OBJECT_INVALID;
    }

  }

  object oWeapon1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
  if (GetIsObjectValid(oWeapon1) && (IPGetIsRangedWeapon(oWeapon1) || IPGetIsMeleeWeapon(oWeapon1)))
  {
    return oWeapon1;
  }

  oWeapon1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
  if (GetIsObjectValid(oWeapon1) && (IPGetIsRangedWeapon(oWeapon1) || IPGetIsMeleeWeapon(oWeapon1)))
  {
    return oWeapon1;
  }
  
   oWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget);
  if (GetIsObjectValid(oWeapon1))
  {
    return oWeapon1;
  } 

  oWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);
  if (GetIsObjectValid(oWeapon1))
  {
    return oWeapon1;
  }

  oWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget);
  if (GetIsObjectValid(oWeapon1))
  {
    return oWeapon1;
  }

  oWeapon1 = GetItemInSlot(INVENTORY_SLOT_ARMS, oTarget);
  if (GetIsObjectValid(oWeapon1))
  {
    return oWeapon1;
  } 

  return OBJECT_INVALID;

}

void DoCamoflage2(object oTarget)
{
    //Declare major variables
    //effect eVis = EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION);	// NWN1 VFX
    effect eVis = EffectVisualEffect( 631 );	// NWN2 VFX: VFX_DUR_SPELL_CAMOFLAGE
    effect eHide = EffectSkillIncrease(SKILL_HIDE, 10);
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);	// NWN1 VFX
    effect eLink = EffectLinkEffects(eHide, eVis);

    float fDuration = TurnsToSeconds(GetPalRngCasterLevel()); // * Duration 1 turn/level
    fDuration = tob_ApplyMetamagicDurationMods(fDuration);
    int nDurType = tob_ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Fire spell cast at event for target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 421, FALSE));

    //Apply VFX impact and bonus effects
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// NWN1 VFX
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}