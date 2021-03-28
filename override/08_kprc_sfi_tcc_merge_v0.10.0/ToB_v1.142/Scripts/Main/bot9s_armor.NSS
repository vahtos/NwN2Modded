/////////////////////////////////////////////
//	Author: Drammel                        //
//	Date: 4/30/2009                        //
//	Title: bot9s_armor                     //
//	Description: Functions which determines//
//	various AC bonuses and properties.     //
/////////////////////////////////////////////

/* Luckily the creators of these functions listed themselves in the function
 description.  I've edited the scripts for SoZ since they're about a year old.
 Again, I owe these guys a round of drinks.

 Also, as it applies elsewhere, many feats from MotB and SoZ have no listing
 in nwscript.nss and therefore no listing in the toolset.  These feats are
 listed by number, although I have commented which are which where I can.*/

#include "bot9s_inc_2da"

// Prototypes

// Returns a GMATERIAL_* constant that represents the type of material of 
// oItem. This function is not foolproof, but it's the best way I can think 
// of to query the material type.
// This function was written by Elysius.
int GetMaterialType(object oItem);

// Returns the AC bonus of oItem. If oItem has no AC bonus, this function 
// returns 0.
// This function was written by Elysius, modified by Mithdradates May 3, 2008
int GetItemACBonus(object oItem);

// Returns the maximum Dexterity bonus of oArmor.
// This function was written by Elysius, modified by Mithdradates May 3, 2008
// Updated for patch 1.23 by Drammel 8/12/2009.
int GetMaxDexBonus(object oArmor);

//Function to get the dodge and dex AC of a creature.
// This function was written by Mithdradates May 3, 2008.
int GetDodgeAC(object oCreature=OBJECT_SELF);

// Function to get the touch AC of a creature.
// This function was written by Mithdradates May 9, 2008.
int GetTouchAC(object oCreature=OBJECT_SELF);

// Returns a creature's Flat Footed AC value.  This value is equal to the forumla:
// Flat-footed AC = AC – Dex bonus – dodge bonuses.  It usually applies when a
// creature is ambushed or suprised.
int GetFlatFootedAC(object oCreature);

// Returns TRUE if oTarget is flat-footed.
int GetIsFlatFooted(object oTarget);

// Functions	
		
// Returns a GMATERIAL_* constant that represents the type of material of 
// oItem. This function is not foolproof, but it's the best way I can think 
// of to query the material type.
// This function was written by Elysius.
int GetMaterialType(object oItem)
{
    int nMaterial = GMATERIAL_NONSPECIFIC;
    // Extract the substring that indicates the material of the item.
    string sResRef = GetResRef(oItem);
    int nStart = FindSubString(sResRef, "_");
    if (nStart >= 0)
    {
        ++nStart;
        int nLen = GetStringLength(sResRef);
        nLen -= nStart;
        string sMaterial = GetStringRight(sResRef, nLen);
        if (sMaterial != "")
        {
            nStart = FindSubString(sMaterial, "_") + 1;
            sMaterial = GetStringRight(sMaterial, nLen - nStart);
            if (sMaterial != "")
            {
                int nEnd = FindSubString(sMaterial, "_");
                sMaterial = GetSubString(sMaterial, 0, nEnd);
                // Determine the material type from the substring.
                if (sMaterial == "slv")
                    nMaterial = GMATERIAL_METAL_ALCHEMICAL_SILVER;
                else if (sMaterial == "cld")
                    nMaterial = GMATERIAL_METAL_COLD_IRON;
                else if (sMaterial == "drk")
                    nMaterial = GMATERIAL_METAL_DARKSTEEL;
                else if (sMaterial == "mth")
                    nMaterial = GMATERIAL_METAL_MITHRAL;
                else if (sMaterial == "ada")
                    nMaterial = GMATERIAL_METAL_ADAMANTINE;
                else if (sMaterial == "rdh")
                    nMaterial = GMATERIAL_CREATURE_RED_DRAGON;
                else if (sMaterial == "uhh")
                    nMaterial = GMATERIAL_CREATURE_UMBER_HULK;
                else if (sMaterial == "wyh")
                    nMaterial = GMATERIAL_CREATURE_WYVERN;
                else if (sMaterial == "slh")
                    nMaterial = GMATERIAL_CREATURE_SALAMANDER;
                else if (sMaterial == "dsk")
                    nMaterial = GMATERIAL_WOOD_DUSKWOOD;
            }
        }
    }
    return nMaterial;
}

// Returns the AC bonus of oItem. If oItem has no AC bonus, this function 
// returns 0.
// This function was written by Elysius, modified by Mithdradates May 3, 2008
int GetItemACBonus(object oItem)
{
    int nBonus = 0;
    int nPenalty = 0;
    itemproperty ip = GetFirstItemProperty(oItem);
	int nIPType, nThisValue;
    while (GetIsItemPropertyValid(ip))
    {
       	nIPType = GetItemPropertyType(ip);
        if (nIPType == ITEM_PROPERTY_AC_BONUS)
        {
            nThisValue = GetItemPropertyCostTableValue(ip);
            if (nThisValue > nBonus)
                nBonus = nThisValue;
        }
        else if (nIPType == ITEM_PROPERTY_DECREASED_AC)
        {
            nThisValue = GetItemPropertyCostTableValue(ip);
            if (nThisValue > nPenalty)
                nPenalty = nThisValue;
        }
        ip = GetNextItemProperty(oItem);
    }
    return nBonus - nPenalty;
}
 
// Returns the maximum Dexterity bonus of oArmor.
// This function was written by Elysius, modified by Mithdradates May 3, 2008
// Updated for patch 1.23 by Drammel 8/12/2009.
int GetMaxDexBonus(object oArmor)
{
	int nMaxDexBonus;
	int nArmor;

	if (oArmor == OBJECT_INVALID)
	{
		nArmor = 0; //Prevents the function from shutting down.
	}
	else nArmor = GetArmorRulesType(oArmor);

	string s2da = tob_Get2daString("armorrulestats", "MAXDEXBONUS", nArmor);

	if (s2da == "")
	{
		nMaxDexBonus = 100;
	}
	else nMaxDexBonus = StringToInt(s2da);

	/* The older stuff before GetArmorRulesType came along.
    int nMaxDexBonus = 100;
 
    if (GetBaseItemType(oArmor) == BASE_ITEM_ARMOR)
    {
        int nACValue = GetItemACValue(oArmor) - GetItemACBonus(oArmor);
        switch (nACValue)
        {
            case 1:  // Padded
                nMaxDexBonus = 8;
                break;
            case 2:  // Leather
                nMaxDexBonus = 6;
                break;
            case 3:  // Studded leather, Hide
                nMaxDexBonus = 5;  // Studded leather
                if (GetArmorRank(oArmor) == ARMOR_RANK_MEDIUM)
                    nMaxDexBonus = 4;  // Hide
                break;
            case 4:  // Chain shirt, scale mail
                nMaxDexBonus = 4;  // Chain shirt
                if (GetArmorRank(oArmor) == ARMOR_RANK_MEDIUM)
                    nMaxDexBonus = 3;  // Scale mail
                // If the armor's material is mithral, increase maximum 
                // Dexterity bonus by 2.
                if (GetMaterialType(oArmor) == GMATERIAL_METAL_MITHRAL)
                    nMaxDexBonus += 2;
                break;
            case 5:  // Breastplate, Chainmail
			    if (FindSubString(GetResRef(oArmor),"arcl")!=-1||FindSubString(GetResRef(oArmor),"mdcm")!=-1) nMaxDexBonus = 2;
                else nMaxDexBonus = 3;  // Breastplate
                // If the armor's material is mithral, this is light armor instead of medium, increase maximum 
                // Dexterity bonus by 2.
                if (GetArmorRank(oArmor) == ARMOR_RANK_LIGHT) nMaxDexBonus +=2;
                // Note: I can't figure out how to distinguish breastplate from
                // chainmail.
                break;
            case 6:  // Banded, Splint mail
 				nMaxDexBonus = 1;  // Banded
                // If the armor's material is mithral, this is medium armor instead of heavy, increase maximum 
                // Dexterity bonus by 2.
                if (GetArmorRank(oArmor) == ARMOR_RANK_MEDIUM) nMaxDexBonus +=2;
                // Note: I can't figure out how to distinguish banded from
                // splint mail.
                break;
            case 7:  // Half plate
                nMaxDexBonus = 0;
                // If the armor's material is mithral, this is medium armor instead of heavy, increase maximum 
                // Dexterity bonus by 2.
                if (GetArmorRank(oArmor) == ARMOR_RANK_MEDIUM) nMaxDexBonus +=2;
                break;
            case 8:  // Full plate
                nMaxDexBonus = 1;
                // If the armor's material is mithral, this is medium armor instead of heavy, increase maximum 
                // Dexterity bonus by 2.
                if (GetArmorRank(oArmor) == ARMOR_RANK_MEDIUM) nMaxDexBonus +=2;
                break;
        }
    }*/
    return nMaxDexBonus;
}

//Function to get the dodge and dex AC of a creature.
// This function was written by Mithdradates May 3, 2008.
int GetDodgeAC(object oCreature=OBJECT_SELF)
{
	int iAC=0;
	int iACdown=0;
	int iAChaste=0;
	effect eEffect=GetFirstEffect(oCreature);
	while (GetIsEffectValid(eEffect))
	{
		if (GetEffectType(eEffect)==EFFECT_TYPE_AC_INCREASE&&GetEffectInteger(eEffect,0)==AC_DODGE_BONUS) iAC+=GetEffectInteger(eEffect,1);
		if (GetEffectType(eEffect)==EFFECT_TYPE_AC_DECREASE&&GetEffectInteger(eEffect,0)==AC_DODGE_BONUS) iAC-=GetEffectInteger(eEffect,1);
		if (GetEffectType(eEffect)==EFFECT_TYPE_HASTE) iAChaste=1;
		eEffect=GetNextEffect(oCreature);
	};
	object oItem=GetItemInSlot(INVENTORY_SLOT_BOOTS,oCreature);
	itemproperty ipProp;
	if (GetIsObjectValid(oItem))
	{		
		ipProp=GetFirstItemProperty(oItem);
		while(GetIsItemPropertyValid(ipProp))
		{
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_AC_BONUS) iAC+=GetItemPropertyCostTableValue(ipProp);
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_DECREASED_AC) iACdown+=GetItemPropertyCostTableValue(ipProp);
			ipProp=GetNextItemProperty(oItem);
		};
	};
	int i;
	for (i=0; i<NUM_INVENTORY_SLOTS; i++)
	{
		oItem=GetItemInSlot(i,oCreature);
		if (GetIsObjectValid(oItem))
		{		
			ipProp=GetFirstItemProperty(oItem);
			while(GetIsItemPropertyValid(ipProp))
			{
				if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_HASTE) iAChaste=1;
				ipProp=GetNextItemProperty(oItem);
			};
		};
	};
	iAC+=iAChaste;
	if (iAC>20) iAC=20;
	if (iACdown>20) iACdown=20;
	iAC+=GetSkillRank(SKILL_TUMBLE, oCreature, TRUE)/10;
	i=GetAbilityModifier(ABILITY_DEXTERITY, oCreature);
	if (i>GetMaxDexBonus(GetItemInSlot(INVENTORY_SLOT_CHEST,oCreature))) i=GetMaxDexBonus(GetItemInSlot(INVENTORY_SLOT_CHEST,oCreature));
	iAC+=i;
	if (GetHasFeat(FEAT_DODGE,oCreature,TRUE)) iAC++;
	if (GetHasFeat(1082,oCreature,TRUE)) iAC+=4; //FEAT_SVIRFNEBLIN_DODGE
	if (GetHasFeat(1575,oCreature,TRUE)) iAC+=4; //FEAT_IMPROVED_DEFENSE_4
	else if (GetHasFeat(1574,oCreature,TRUE)) iAC+=3; //FEAT_IMPROVED_DEFENSE_3
	else if (GetHasFeat(1573,oCreature,TRUE)) iAC+=2; //FEAT_IMPROVED_DEFENSE_2
	else if (GetHasFeat(1572,oCreature,TRUE)) iAC+=1; //FEAT_IMPROVED_DEFENSE_1
	i=0;
	if (GetHasFeat(FEAT_CANNY_DEFENSE,oCreature,TRUE))
	{
		oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oCreature);
		if (GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST,oCreature))==ARMOR_RANK_NONE&&GetBaseItemType(oItem)!=BASE_ITEM_LARGESHIELD&&GetBaseItemType(oItem)!=BASE_ITEM_SMALLSHIELD&&GetBaseItemType(oItem)!=BASE_ITEM_TOWERSHIELD)
		{
			i=GetAbilityModifier(ABILITY_INTELLIGENCE, oCreature);
			if (i>GetLevelByClass(CLASS_TYPE_DUELIST,oCreature)) i=GetLevelByClass(CLASS_TYPE_DUELIST,oCreature);
		}
	}
	int j=0;
	if (GetHasFeat(2049,oCreature,TRUE))
	{
		if (GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST,oCreature))==ARMOR_RANK_NONE)
		{
			j=GetAbilityModifier(ABILITY_INTELLIGENCE, oCreature);
			if (j>GetLevelByClass(CLASS_TYPE_INVISIBLE_BLADE,oCreature)) j=GetLevelByClass(CLASS_TYPE_INVISIBLE_BLADE,oCreature);
		}
	}
	if (j>i) iAC+=j;
	else iAC+=i;
	return iAC-iACdown;
}

// Function to get the touch AC of a creature.
// This function was written by Mithdradates May 9, 2008.
int GetTouchAC(object oCreature=OBJECT_SELF)
{
	int iAC=0;
	int iACDeflection=0;
	int iACDefDown=0;
	int iACdown=0;
	int iAChaste=0;
	effect eEffect=GetFirstEffect(oCreature);
	while (GetIsEffectValid(eEffect))
	{
		if (GetEffectType(eEffect)==EFFECT_TYPE_AC_INCREASE&&GetEffectInteger(eEffect,0)==AC_DODGE_BONUS) iAC+=GetEffectInteger(eEffect,1);
		if (GetEffectType(eEffect)==EFFECT_TYPE_AC_INCREASE&&GetEffectInteger(eEffect,0)==AC_DEFLECTION_BONUS&&GetEffectInteger(eEffect,1)>iACDeflection) iACDeflection=GetEffectInteger(eEffect,1);
		if (GetEffectType(eEffect)==EFFECT_TYPE_AC_DECREASE&&GetEffectInteger(eEffect,0)==AC_DODGE_BONUS) iAC-=GetEffectInteger(eEffect,1);
		if (GetEffectType(eEffect)==EFFECT_TYPE_AC_DECREASE&&GetEffectInteger(eEffect,0)==AC_DEFLECTION_BONUS&&GetEffectInteger(eEffect,1)>iACDefDown) iACDefDown=GetEffectInteger(eEffect,1);
		if (GetEffectType(eEffect)==EFFECT_TYPE_HASTE) iAChaste=1;
		eEffect=GetNextEffect(oCreature);
	};
	object oItem=GetItemInSlot(INVENTORY_SLOT_BOOTS,oCreature);
	itemproperty ipProp;
	if (GetIsObjectValid(oItem))
	{		
		ipProp=GetFirstItemProperty(oItem);
		while(GetIsItemPropertyValid(ipProp))
		{
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_AC_BONUS) iAC+=GetItemPropertyCostTableValue(ipProp);
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_DECREASED_AC) iACdown+=GetItemPropertyCostTableValue(ipProp);
			ipProp=GetNextItemProperty(oItem);
		};
	};
	oItem=GetItemInSlot(INVENTORY_SLOT_BELT,oCreature);
	if (GetIsObjectValid(oItem))
	{		
		ipProp=GetFirstItemProperty(oItem);
		while(GetIsItemPropertyValid(ipProp))
		{
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_AC_BONUS&&GetItemPropertyCostTableValue(ipProp)>iACDeflection) iACDeflection=GetItemPropertyCostTableValue(ipProp);
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_DECREASED_AC&&GetItemPropertyCostTableValue(ipProp)>iACDefDown) iACDefDown=GetItemPropertyCostTableValue(ipProp);
			ipProp=GetNextItemProperty(oItem);
		};
	};
	oItem=GetItemInSlot(INVENTORY_SLOT_CLOAK,oCreature);
	if (GetIsObjectValid(oItem))
	{		
		ipProp=GetFirstItemProperty(oItem);
		while(GetIsItemPropertyValid(ipProp))
		{
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_AC_BONUS&&GetItemPropertyCostTableValue(ipProp)>iACDeflection) iACDeflection=GetItemPropertyCostTableValue(ipProp);
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_DECREASED_AC&&GetItemPropertyCostTableValue(ipProp)>iACDefDown) iACDefDown=GetItemPropertyCostTableValue(ipProp);
			ipProp=GetNextItemProperty(oItem);
		};
	};
	oItem=GetItemInSlot(INVENTORY_SLOT_HEAD,oCreature);
	if (GetIsObjectValid(oItem))
	{		
		ipProp=GetFirstItemProperty(oItem);
		while(GetIsItemPropertyValid(ipProp))
		{
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_AC_BONUS&&GetItemPropertyCostTableValue(ipProp)>iACDeflection) iACDeflection=GetItemPropertyCostTableValue(ipProp);
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_DECREASED_AC&&GetItemPropertyCostTableValue(ipProp)>iACDefDown) iACDefDown=GetItemPropertyCostTableValue(ipProp);
			ipProp=GetNextItemProperty(oItem);
		};
	};
	oItem=GetItemInSlot(INVENTORY_SLOT_LEFTRING,oCreature);
	if (GetIsObjectValid(oItem))
	{		
		ipProp=GetFirstItemProperty(oItem);
		while(GetIsItemPropertyValid(ipProp))
		{
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_AC_BONUS&&GetItemPropertyCostTableValue(ipProp)>iACDeflection) iACDeflection=GetItemPropertyCostTableValue(ipProp);
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_DECREASED_AC&&GetItemPropertyCostTableValue(ipProp)>iACDefDown) iACDefDown=GetItemPropertyCostTableValue(ipProp);
			ipProp=GetNextItemProperty(oItem);
		};
	};
	oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTRING,oCreature);
	if (GetIsObjectValid(oItem))
	{		
		ipProp=GetFirstItemProperty(oItem);
		while(GetIsItemPropertyValid(ipProp))
		{
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_AC_BONUS&&GetItemPropertyCostTableValue(ipProp)>iACDeflection) iACDeflection=GetItemPropertyCostTableValue(ipProp);
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_DECREASED_AC&&GetItemPropertyCostTableValue(ipProp)>iACDefDown) iACDefDown=GetItemPropertyCostTableValue(ipProp);
			ipProp=GetNextItemProperty(oItem);
		};
	};
	oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oCreature);
	if (GetIsObjectValid(oItem))
	{		
		ipProp=GetFirstItemProperty(oItem);
		while(GetIsItemPropertyValid(ipProp))
		{
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_AC_BONUS&&GetItemPropertyCostTableValue(ipProp)>iACDeflection) iACDeflection=GetItemPropertyCostTableValue(ipProp);
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_DECREASED_AC&&GetItemPropertyCostTableValue(ipProp)>iACDefDown) iACDefDown=GetItemPropertyCostTableValue(ipProp);
			ipProp=GetNextItemProperty(oItem);
		};
	};
	oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oCreature);
	if (GetIsObjectValid(oItem)&&GetBaseItemType(oItem)!=BASE_ITEM_LARGESHIELD&&GetBaseItemType(oItem)!=BASE_ITEM_SMALLSHIELD&&GetBaseItemType(oItem)!=BASE_ITEM_TOWERSHIELD)
	{		
		ipProp=GetFirstItemProperty(oItem);
		while(GetIsItemPropertyValid(ipProp))
		{
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_AC_BONUS&&GetItemPropertyCostTableValue(ipProp)>iACDeflection) iACDeflection=GetItemPropertyCostTableValue(ipProp);
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_DECREASED_AC&&GetItemPropertyCostTableValue(ipProp)>iACDefDown) iACDefDown=GetItemPropertyCostTableValue(ipProp);
			ipProp=GetNextItemProperty(oItem);
		};
	};
	oItem=GetItemInSlot(INVENTORY_SLOT_ARMS,oCreature);
	if (GetIsObjectValid(oItem)&&GetBaseItemType(oItem)!=BASE_ITEM_BRACER)
	{		
		ipProp=GetFirstItemProperty(oItem);
		while(GetIsItemPropertyValid(ipProp))
		{
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_AC_BONUS&&GetItemPropertyCostTableValue(ipProp)>iACDeflection) iACDeflection=GetItemPropertyCostTableValue(ipProp);
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_DECREASED_AC&&GetItemPropertyCostTableValue(ipProp)>iACDefDown) iACDefDown=GetItemPropertyCostTableValue(ipProp);
			ipProp=GetNextItemProperty(oItem);
		};
	};
	int i;
	for (i=0; i<NUM_INVENTORY_SLOTS; i++)
	{
		oItem=GetItemInSlot(i,oCreature);
		if (GetIsObjectValid(oItem))
		{		
			ipProp=GetFirstItemProperty(oItem);
			while(GetIsItemPropertyValid(ipProp))
			{
				if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_HASTE) iAChaste=1;
				ipProp=GetNextItemProperty(oItem);
			};
		};
	};
	iAC+=iAChaste;
	if (iAC>20) iAC=20;
	if (iACdown>20) iACdown=20;
	iAC+=GetSkillRank(SKILL_TUMBLE, oCreature, TRUE)/10;
	i=GetAbilityModifier(ABILITY_DEXTERITY, oCreature);
	if (i>GetMaxDexBonus(GetItemInSlot(INVENTORY_SLOT_CHEST,oCreature))) i=GetMaxDexBonus(GetItemInSlot(INVENTORY_SLOT_CHEST,oCreature));
	iAC+=i;
	if (GetHasFeat(FEAT_LUCK_OF_HEROES,oCreature,TRUE)) iAC++;
	if (GetHasFeat(FEAT_LUCKY,oCreature,TRUE)) iAC++;
	iAC+=3-GetCreatureSize(oCreature);
	if (GetActionMode(oCreature,ACTION_MODE_COMBAT_EXPERTISE)) iAC+=3;
	if (GetActionMode(oCreature,ACTION_MODE_IMPROVED_COMBAT_EXPERTISE)) iAC+=6;
	if (GetHasFeat(1082,oCreature,TRUE)) iAC+=4; //FEAT_SVIRFNEBLIN_DODGE
	if (GetHasFeat(1575,oCreature,TRUE)) iAC+=4; //FEAT_IMPROVED_DEFENSE_4
	else if (GetHasFeat(1574,oCreature,TRUE)) iAC+=3; //FEAT_IMPROVED_DEFENSE_3
	else if (GetHasFeat(1573,oCreature,TRUE)) iAC+=2; //FEAT_IMPROVED_DEFENSE_2
	else if (GetHasFeat(1572,oCreature,TRUE)) iAC+=1; //FEAT_IMPROVED_DEFENSE_1
	i=0;
	if (GetHasFeat(FEAT_CANNY_DEFENSE,oCreature,TRUE))
	{
		oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oCreature);
		if (GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST,oCreature))==ARMOR_RANK_NONE&&GetBaseItemType(oItem)!=BASE_ITEM_LARGESHIELD&&GetBaseItemType(oItem)!=BASE_ITEM_SMALLSHIELD&&GetBaseItemType(oItem)!=BASE_ITEM_TOWERSHIELD)
		{
			i=GetAbilityModifier(ABILITY_INTELLIGENCE, oCreature);
			if (i>GetLevelByClass(CLASS_TYPE_DUELIST,oCreature)) i=GetLevelByClass(CLASS_TYPE_DUELIST,oCreature);
		}
	}
	int j=0;
	if (GetHasFeat(2049,oCreature,TRUE)) //FEAT_UNFETTERED_DEFENSE
	{
		if (GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST,oCreature))==ARMOR_RANK_NONE)
		{
			j=GetAbilityModifier(ABILITY_INTELLIGENCE, oCreature);
			if (j>GetLevelByClass(CLASS_TYPE_INVISIBLE_BLADE,oCreature)) j=GetLevelByClass(CLASS_TYPE_INVISIBLE_BLADE,oCreature);
		}
	}

	if (GetIsInCombat(oCreature))
	{
		object oFoe = GetLastAttacker(oCreature);
		object oTarget = GetAttackTarget(oCreature);
		object oChest = GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature);
		int nArmor = GetArmorRank(oChest);
		int nSwash = GetLevelByClass(CLASS_TYPE_SWASHBUCKLER, oCreature);

		if ((nSwash > 0) && (oFoe == oTarget) && (nArmor <= ARMOR_RANK_LIGHT))
		{
			if (nSwash >= 30) // Swashbuckler's Dodge +6
			{
				iAC += 6;
			}
			else if (nSwash >= 25)  // Swashbuckler's Dodge +5
			{
				iAC += 5;
			}
			else if (nSwash >= 20)  // Swashbuckler's Dodge +4
			{
				iAC += 4;
			}
			else if (nSwash >= 15)  // Swashbuckler's Dodge +3
			{
				iAC += 3;
			}
			else if (nSwash >= 10)  // Swashbuckler's Dodge +2
			{
				iAC += 2;
			}
			else if (nSwash >= 5)  // Swashbuckler's Dodge +1
			{
				iAC += 1;
			}
		}
		
		if (GetHasFeat(FEAT_DODGE, oCreature, TRUE) && (oFoe == oTarget))
		{
			iAC += 1;
		}
	}

	if (j>i) iAC+=j;
	else iAC+=i;
	return iAC-iACdown+10+iACDeflection-iACDefDown;
}

// Returns a creature's Flat Footed AC value.  This value is equal to the forumla:
// Flat-footed AC = AC – Dex bonus – dodge bonuses.  It usually applies when a
// creature is ambushed or suprised.
int GetFlatFootedAC(object oCreature)
{
	int nTotalAC = GetAC(oCreature);
	int nDodgeAC = GetDodgeAC(oCreature);  //Includes the Dex mod in the calculation.
	int nFlatFootAC = nTotalAC - nDodgeAC;

	return nFlatFootAC;
}

// Returns TRUE if oTarget is flat-footed.
int GetIsFlatFooted(object oTarget)
{
	if (GetHasFeat(FEAT_UNCANNY_DODGE, oTarget))
	{
		return FALSE;
	}
	else if (GetLocalInt(oTarget, "OverrideFlatFootedAC") == 1)
	{
		return TRUE;
	}
	else if (!GetIsInCombat(oTarget))
	{
		return TRUE;
	}
	else return FALSE;
}