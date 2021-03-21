//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 2/10/2009							//
//	Title: bot9s_inc_variables				//
//	Description: Functions that control the	//
//	status of variables.					//
//////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "tob_x0_i0_position"

// Prototypes

/*	GetDamageByIPConstDamageBonus, GetDamageByDamageBonus, and GetDamageByDice, 
  and are adaptations from Kaedrin's cmi_ginc_wpns script.*/

// Returns TRUE for weapons favored by the Desert Wind school.
// -oWeapon: The weapon weilded by the caller of the function.
int GetIsDesertWindWeapon(object oWeapon);

// Returns TRUE for weapons favored by the Devoted Spirit school.
// -oWeapon: The weapon weilded by the caller of the function.
int GetIsDevotedSpiritWeapon(object oWeapon);

// Returns TRUE for weapons favored by the Diamond Mind school.
// -oWeapon: The weapon weilded by the caller of the function.
int GetIsDiamondMindWeapon(object oWeapon);

// Returns TRUE for weapons favored by the Iron Heart school.
// -oWeapon: The weapon weilded by the caller of the function.
int GetIsIronHeartWeapon(object oWeapon);

// Returns TRUE for weapons favored by the Setting Sun school.
// -oWeapon: The weapon weilded by the caller of the function.
int GetIsSettingSunWeapon(object oWeapon);

// Returns TRUE for weapons favored by the Shadow Hand school.
// -oWeapon: The weapon weilded by the caller of the function.
int GetIsShadowHandWeapon(object oWeapon);

// Returns TRUE for weapons favored by the Stone Dragon school.
// -oWeapon: The weapon weilded by the caller of the function.
int GetIsStoneDragonWeapon(object oWeapon);

// Returns TRUE for weapons favored by the Tiger Claw school.
// -oWeapon: The weapon weilded by the caller of the function.
int GetIsTigerClawWeapon(object oWeapon);

// Returns TRUE for weapons favored by the White Raven school.
// -oWeapon: The weapon weilded by the caller of the function.
int GetIsWhiteRavenWeapon(object oWeapon);

// Returns true if the PC is in a Shadow Hand stance and is Weilding a Shadow Hand weapon.
// -oWeapon: Left or right hand.
int GetIsShadowBladeValid(object oWeapon);

// Returns TRUE if oWeapon is vaild for Weapon Finesse and similar feats.
int GetIsLightWeapon(object oWeapon, object oPC);

// Returns TRUE if oTarget is a favored enemy of oPC.
int GetIsFavoredEnemy(object oPC, object oTarget);

// Returns TRUE if oPC has Improved Favored Enemy for oTarget.
int GetIsImpFavoredEnemy(object oPC, object oTarget);

// Returns TRUE if oPC has Power Attack Favored Enemy for oTarget.
int GetIsFavoredEnemyPA(object oPC, object oTarget);

// Returns a specific ALIGNMENT constant for oTarget.
int GetAlignment(object oTarget);

// Returns TRUE if oPC is Raging.
int GetIsRaging(object oPC);

// Returns the Z position of a vector as a float.
float GetZ(vector vPos);

// Returns an integer including and between nLow and nHigh.
// Only works if oToB is a valid object.
void RandomBetween(int nLow, int nHigh);

// Returns the percent remaining of oTarget's hit points.
int GetPercentHP(object oTarget = OBJECT_SELF);

//Returns the correct amount of damage for IP_CONST_DAMAGEBONUS_*.
//This function is not intended to return the IP_CONST_DAMAGEBONUS_* values as #d#. Only integers.
// -nNumber: The damage bonus we're searching for.
int IPGetConstDamageBonusFromNumber(int nNumber);

//Returns the correct amount of damage for DAMAGE_BONUS_*.
//This function is not intended to return the DAMAGE_BONUS_* values as #d#. Only integers.
// -nNumber: The damage bonus we're searching for. 
int GetConstDamageBonusFromNumber(int nNumber);

// Converts IP_CONST_DAMAGEBONUS_* constants into real numbers.
int GetDamageByIPConstDamageBonus(int nDamageBonus);

// Converts DAMAGE_BONUS_* constants into real numbers.
int GetDamageByDamageBonus(int nDamageBonus);

// Returns the damage of a die with nDice sides, for nNum amount of Dice.
int GetDamageByDice(int nDice, int nNum);

// Functions

// Returns TRUE for weapons favored by the Desert Wind school.
// -oWeapon: The weapon weilded by the caller of the function.
int GetIsDesertWindWeapon(object oWeapon)
{
	int nReturn;
	int nWeapon = GetBaseItemType(oWeapon);
	switch (nWeapon)
	{
		case BASE_ITEM_SCIMITAR:	nReturn = TRUE; break;
		case BASE_ITEM_SCIMITAR_R:	nReturn = TRUE; break;
		case BASE_ITEM_MACE:		nReturn = TRUE; break;
		case BASE_ITEM_MACE_R:		nReturn = TRUE; break;
		case BASE_ITEM_SPEAR:		nReturn = TRUE; break;
		case BASE_ITEM_SPEAR_R:		nReturn = TRUE; break;
		case BASE_ITEM_FALCHION:	nReturn = TRUE; break;
		case BASE_ITEM_FALCHION_R:	nReturn = TRUE; break;
		default:					nReturn = FALSE; break;
	}
	return nReturn;
}

// Returns TRUE for weapons favored by the Devoted Spirit school.
// -oWeapon: The weapon weilded by the caller of the function.
int GetIsDevotedSpiritWeapon(object oWeapon)
{
	int nReturn;
	int nWeapon = GetBaseItemType(oWeapon);
	switch (nWeapon)
	{
		case BASE_ITEM_FALCHION:	nReturn = TRUE; break;
		case BASE_ITEM_FALCHION_R:	nReturn = TRUE; break;
		case BASE_ITEM_LONGSWORD:	nReturn = TRUE; break;
		case BASE_ITEM_LONGSWORD_R:	nReturn = TRUE; break;
		case BASE_ITEM_WARMACE:		nReturn = TRUE; break; //Greatclubs are disabled.
		case BASE_ITEM_WARMACE_R:	nReturn = TRUE; break;
		case BASE_ITEM_LONGBOW:		nReturn = TRUE; break;
		default:					nReturn = FALSE; break;
	}
	// No Maul in NWN2 so I'm replacing them with longbows to accomidate Saints.
	return nReturn;
}

// Returns TRUE for weapons favored by the Diamond Mind school.
// -oWeapon: The weapon weilded by the caller of the function.
int GetIsDiamondMindWeapon(object oWeapon)
{
	int nReturn;
	int nWeapon = GetBaseItemType(oWeapon);
	switch (nWeapon)
	{
		case BASE_ITEM_RAPIER:			nReturn = TRUE; break;
		case BASE_ITEM_RAPIER_R:		nReturn = TRUE; break;
		case BASE_ITEM_SICKLE:			nReturn = TRUE; break; //Shortspears are disabled.
		case BASE_ITEM_SICKLE_R:		nReturn = TRUE; break;
		case BASE_ITEM_BASTARDSWORD:	nReturn = TRUE; break;
		case BASE_ITEM_BASTARDSWORD_R:	nReturn = TRUE; break;
		case BASE_ITEM_KATANA:			nReturn = TRUE; break;
		case BASE_ITEM_KATANA_R:		nReturn = TRUE; break;
		default:						nReturn = FALSE; break;
	}
	return nReturn;
}

// Returns TRUE for weapons favored by the Iron Heart school.
// -oWeapon: The weapon weilded by the caller of the function.
int GetIsIronHeartWeapon(object oWeapon)
{
	int nReturn;
	int nWeapon = GetBaseItemType(oWeapon);
	switch (nWeapon)
	{
		case BASE_ITEM_DWARVENWARAXE:	nReturn = TRUE; break;
		case BASE_ITEM_DWARVENWARAXE_R:	nReturn = TRUE; break;
		case BASE_ITEM_LONGSWORD:		nReturn = TRUE; break;
		case BASE_ITEM_LONGSWORD_R:		nReturn = TRUE; break;
		case BASE_ITEM_BASTARDSWORD:	nReturn = TRUE; break;
		case BASE_ITEM_BASTARDSWORD_R:	nReturn = TRUE; break;
		case BASE_ITEM_FLAIL:			nReturn = TRUE; break; // No 2-bladed swords in NWN2
		case BASE_ITEM_FLAIL_R:			nReturn = TRUE; break;
		default:						nReturn = FALSE; break;
	}
	return nReturn;
}

// Returns TRUE for weapons favored by the Setting Sun school.
// -oWeapon: The weapon weilded by the caller of the function.
int GetIsSettingSunWeapon(object oWeapon)
{
	object oPC = OBJECT_SELF;
	int nReturn;
	int nWeapon = GetBaseItemType(oWeapon);
	
	if (oWeapon == OBJECT_INVALID)
	{
		nReturn = TRUE; // No base item const for unarmed strikes, but this is a close aproximation.
	}
	else
	{
		switch (nWeapon)
		{
			case BASE_ITEM_SHORTSWORD:		nReturn = TRUE; break;
			case BASE_ITEM_SHORTSWORD_R:	nReturn = TRUE; break;
			case BASE_ITEM_SLING:			nReturn = TRUE; break;
			case BASE_ITEM_QUARTERSTAFF:	nReturn = TRUE; break;
			case BASE_ITEM_QUARTERSTAFF_R:	nReturn = TRUE; break;
			default:						nReturn = FALSE; break;
		}
	}
	return nReturn;
}

// Returns TRUE for weapons favored by the Shadow Hand school.
// -oWeapon: The weapon weilded by the caller of the function.
int GetIsShadowHandWeapon(object oWeapon)
{
	object oPC = OBJECT_SELF;
	int nReturn;
	int nWeapon = GetBaseItemType(oWeapon);
	
	if (oWeapon == OBJECT_INVALID)
	{
		nReturn = TRUE; // No base item const for unarmed strikes, but this is a close aproximation.
	}
	else
	{
		switch (nWeapon)
		{
			case BASE_ITEM_DAGGER:		nReturn = TRUE; break;
			case BASE_ITEM_DAGGER_R:	nReturn = TRUE; break;
			case BASE_ITEM_SHORTSWORD:	nReturn = TRUE; break;
			case BASE_ITEM_SHORTSWORD_R:nReturn = TRUE; break;
			case BASE_ITEM_SHORTBOW:	nReturn = TRUE; break;
			case BASE_ITEM_SCYTHE:		nReturn = TRUE; break;
			case BASE_ITEM_SCYTHE_R:	nReturn = TRUE; break;
			case BASE_ITEM_SHURIKEN:	nReturn = TRUE; break;
			default:					nReturn = FALSE; break;
		}
	}
//Replacing Sai with shortbow for my Saints, Siangham with Shuriken, and Spiked Chain with Scythe.
	return nReturn;
}

// Returns TRUE for weapons favored by the Stone Dragon school.
// -oWeapon: The weapon weilded by the caller of the function.
int GetIsStoneDragonWeapon(object oWeapon)
{
	object oPC = OBJECT_SELF;
	int nReturn;
	int nWeapon = GetBaseItemType(oWeapon);
	
	if (oWeapon == OBJECT_INVALID)
	{
		nReturn = TRUE; // No base item const for unarmed strikes, but this is a close aproximation.
	}
	else
	{
		switch (nWeapon)
		{
			case BASE_ITEM_GREATSWORD:	nReturn = TRUE; break;
			case BASE_ITEM_GREATSWORD_R:nReturn = TRUE; break;
			case BASE_ITEM_GREATAXE:	nReturn = TRUE; break;
			case BASE_ITEM_GREATAXE_R:	nReturn = TRUE; break;
			case BASE_ITEM_WARMACE:		nReturn = TRUE; break;
			case BASE_ITEM_WARMACE_R:	nReturn = TRUE; break;
			default:					nReturn = FALSE; break;
		}
	}
	return nReturn;
}

// Returns TRUE for weapons favored by the Tiger Claw school.
// -oWeapon: The weapon weilded by the caller of the function.
int GetIsTigerClawWeapon(object oWeapon)
{
	object oPC = OBJECT_SELF;
	int nReturn;
	int nWeapon = GetBaseItemType(oWeapon);

	if (oWeapon == OBJECT_INVALID)
	{
		nReturn = TRUE; // No base item const for unarmed strikes, but this is a close aproximation.
	}
	else
	{
		switch (nWeapon)
		{
			case BASE_ITEM_KUKRI:			nReturn = TRUE; break;
			case BASE_ITEM_KUKRI_R:			nReturn = TRUE; break;
			case BASE_ITEM_HANDAXE:			nReturn = TRUE; break;
			case BASE_ITEM_HANDAXE_R:		nReturn = TRUE; break;
			case BASE_ITEM_SHORTBOW:		nReturn = TRUE; break;
			case BASE_ITEM_KAMA:			nReturn = TRUE; break;
			case BASE_ITEM_KAMA_R:			nReturn = TRUE; break;
			case BASE_ITEM_CSLSHPRCWEAP:	nReturn = TRUE; break;
			case BASE_ITEM_CBLUDGWEAPON:	nReturn = TRUE; break;
			case BASE_ITEM_CPIERCWEAPON:	nReturn = TRUE; break;
			case BASE_ITEM_CSLASHWEAPON:	nReturn = TRUE; break;
			case BASE_ITEM_GREATAXE:		nReturn = TRUE; break;
			case BASE_ITEM_GREATAXE_R:		nReturn = TRUE; break;
			default:						nReturn = FALSE; break;
		}
	}
	return nReturn;
}

// Returns TRUE for weapons favored by the White Raven school.
// -oWeapon: The weapon weilded by the caller of the function.
int GetIsWhiteRavenWeapon(object oWeapon)
{
	int nReturn;
	int nWeapon = GetBaseItemType(oWeapon);
	switch (nWeapon)
	{
		case BASE_ITEM_LONGSWORD:		nReturn = TRUE; break;
		case BASE_ITEM_LONGSWORD_R:		nReturn = TRUE; break;
		case BASE_ITEM_BATTLEAXE:		nReturn = TRUE; break;
		case BASE_ITEM_BATTLEAXE_R:		nReturn = TRUE; break;
		case BASE_ITEM_WARHAMMER:		nReturn = TRUE; break;
		case BASE_ITEM_WARHAMMER_R:		nReturn = TRUE; break;
		case BASE_ITEM_GREATSWORD:		nReturn = TRUE; break;
		case BASE_ITEM_GREATSWORD_R:	nReturn = TRUE; break;
		case BASE_ITEM_HALBERD:			nReturn = TRUE; break;
		case BASE_ITEM_HALBERD_R:		nReturn = TRUE; break;
		default:						nReturn = FALSE; break;
	}
	return nReturn;
}

// Returns true if the PC is in a Shadow Hand stance and is Weilding a Shadow Hand weapon.
// -oWeapon: Left or right hand.
int GetIsShadowBladeValid(object oWeapon)
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nStance = GetLocalInt(oToB, "Stance");
	int nStance2 = GetLocalInt(oToB, "Stance2");
	int nReturn = FALSE;
	
	if (GetIsShadowHandWeapon(oWeapon) == TRUE)
	{
		switch (nStance)
		{
			case STANCE_ASSNS_STANCE:		nReturn = TRUE; break;
			case STANCE_BALANCE_SKY:		nReturn = TRUE; break;
			case STANCE_CHILD_SHADOW:		nReturn = TRUE; break;
			case STANCE_DANCE_SPIDER:		nReturn = TRUE; break;
			case STANCE_DANCING_MOTH:		nReturn = TRUE; break;
			case STANCE_ISLAND_OF_BLADES:	nReturn = TRUE; break;
			default: 						nReturn = FALSE; break;
		}
	}
	
	if ((nReturn == FALSE) && (GetIsShadowHandWeapon(oWeapon) == TRUE))
	{
		switch (nStance2)
		{
			case STANCE_ASSNS_STANCE:		nReturn = TRUE; break;
			case STANCE_BALANCE_SKY:		nReturn = TRUE; break;
			case STANCE_CHILD_SHADOW:		nReturn = TRUE; break;
			case STANCE_DANCE_SPIDER:		nReturn = TRUE; break;
			case STANCE_DANCING_MOTH:		nReturn = TRUE; break;
			case STANCE_ISLAND_OF_BLADES:	nReturn = TRUE; break;
			default: 						nReturn = FALSE; break;
		}
	}
	return nReturn;
}

// Returns TRUE if oWeapon is vaild for Weapon Finesse and similar feats.
int GetIsLightWeapon(object oWeapon, object oPC)
{
	int nReturn;
	int nWeapon = GetBaseItemType(oWeapon);
	
	if (oWeapon == OBJECT_INVALID)
	{
		nReturn = TRUE; // No base item const for unarmed strikes, but this is a close aproximation.
	}
	else
	{
		switch (nWeapon)
		{
			case BASE_ITEM_RAPIER:			nReturn = TRUE;	break;
			case BASE_ITEM_RAPIER_R:		nReturn = TRUE;	break;
			case BASE_ITEM_WHIP:			nReturn = TRUE;	break;
			case BASE_ITEM_WHIP_R:			nReturn = TRUE;	break;
			case BASE_ITEM_DAGGER:			nReturn = TRUE;	break;
			case BASE_ITEM_DAGGER_R:		nReturn = TRUE;	break;
			case BASE_ITEM_SICKLE:			nReturn = TRUE;	break;
			case BASE_ITEM_SICKLE_R:		nReturn = TRUE;	break;
			case BASE_ITEM_LIGHTHAMMER:		nReturn = TRUE;	break;
			case BASE_ITEM_LIGHTHAMMER_R:	nReturn = TRUE;	break;
			case BASE_ITEM_THROWINGAXE:		nReturn = TRUE;	break;
			case BASE_ITEM_HANDAXE:			nReturn = TRUE;	break;
			case BASE_ITEM_HANDAXE_R:		nReturn = TRUE;	break;
			case BASE_ITEM_KUKRI:			nReturn = TRUE;	break;
			case BASE_ITEM_KUKRI_R:			nReturn = TRUE;	break;
			case BASE_ITEM_SHORTSWORD:		nReturn = TRUE;	break;
			case BASE_ITEM_SHORTSWORD_R:	nReturn = TRUE;	break;
			case BASE_ITEM_KAMA:			nReturn = TRUE;	break;
			case BASE_ITEM_KAMA_R:			nReturn = TRUE;	break;
			case BASE_ITEM_CBLUDGWEAPON:	nReturn = TRUE;	break;
			case BASE_ITEM_CPIERCWEAPON:	nReturn = TRUE;	break;
			case BASE_ITEM_CSLASHWEAPON:	nReturn = TRUE;	break;
			case BASE_ITEM_CSLSHPRCWEAP:	nReturn = TRUE;	break;
			default: 						nReturn = FALSE; break;
		}
	}
	return nReturn;
}

// Returns TRUE if oTarget is a favored enemy of oPC.
int GetIsFavoredEnemy(object oPC, object oTarget)
{
	int nRace = GetRacialType(oTarget);
	int nSubRace = GetSubRace(oTarget);
	int bFEnemy;
	
	switch (nRace)
	{
		case RACIAL_TYPE_DWARF:					bFEnemy = GetHasFeat(261, oPC, TRUE);	break;
		case RACIAL_TYPE_ELF:					bFEnemy = GetHasFeat(262, oPC, TRUE);	break;
		case RACIAL_TYPE_GNOME:					bFEnemy = GetHasFeat(263, oPC, TRUE);	break;
		case RACIAL_TYPE_HALFLING:				bFEnemy = GetHasFeat(264, oPC, TRUE);	break;
		case RACIAL_TYPE_HALFELF:				bFEnemy = GetHasFeat(265, oPC, TRUE);	break;
		case RACIAL_TYPE_HALFORC:				bFEnemy = GetHasFeat(266, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMAN:					bFEnemy = GetHasFeat(267, oPC, TRUE);	break;
		case RACIAL_TYPE_ABERRATION:			bFEnemy = GetHasFeat(268, oPC, TRUE);	break;
		case RACIAL_TYPE_ANIMAL:				bFEnemy = GetHasFeat(269, oPC, TRUE);	break;
		case RACIAL_TYPE_BEAST:					bFEnemy = GetHasFeat(270, oPC, TRUE);	break;
		case RACIAL_TYPE_CONSTRUCT:				bFEnemy = GetHasFeat(271, oPC, TRUE);	break;
		case RACIAL_TYPE_DRAGON:				bFEnemy = GetHasFeat(272, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMANOID_GOBLINOID:	bFEnemy = GetHasFeat(273, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMANOID_MONSTROUS:	bFEnemy = GetHasFeat(274, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMANOID_ORC:			bFEnemy = GetHasFeat(275, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMANOID_REPTILIAN:	bFEnemy = GetHasFeat(276, oPC, TRUE);	break;
		case RACIAL_TYPE_ELEMENTAL:				bFEnemy = GetHasFeat(277, oPC, TRUE);	break;
		case RACIAL_TYPE_FEY:					bFEnemy = GetHasFeat(278, oPC, TRUE);	break;
		case RACIAL_TYPE_GIANT:					bFEnemy = GetHasFeat(279, oPC, TRUE);	break;
		case RACIAL_TYPE_MAGICAL_BEAST:			bFEnemy = GetHasFeat(280, oPC, TRUE);	break;
		case RACIAL_TYPE_OUTSIDER:				bFEnemy = GetHasFeat(281, oPC, TRUE);	break;
		case RACIAL_TYPE_SHAPECHANGER:			bFEnemy = GetHasFeat(284, oPC, TRUE);	break;
		case RACIAL_TYPE_UNDEAD:				bFEnemy = GetHasFeat(285, oPC, TRUE);	break;
		case RACIAL_TYPE_VERMIN:				bFEnemy = GetHasFeat(286, oPC, TRUE);	break;
		default:								bFEnemy = FALSE;						break;
	}
	
	if ((GetHasFeat(282, oPC, TRUE) == TRUE) && (nSubRace == RACIAL_SUBTYPE_PLANT)) // Plants have a subtype but not a race.
	{
		bFEnemy = TRUE;
	}
	return bFEnemy;
}

// Returns TRUE if oPC has Improved Favored Enemy for oTarget.
int GetIsImpFavoredEnemy(object oPC, object oTarget)
{
	int nRace = GetRacialType(oTarget);
	int nSubRace = GetSubRace(oTarget);
	int bFEnemy;
	
	switch (nRace)
	{
		case RACIAL_TYPE_DWARF:					bFEnemy = GetHasFeat(1198, oPC, TRUE);	break;
		case RACIAL_TYPE_ELF:					bFEnemy = GetHasFeat(1199, oPC, TRUE);	break;
		case RACIAL_TYPE_GNOME:					bFEnemy = GetHasFeat(1200, oPC, TRUE);	break;
		case RACIAL_TYPE_HALFLING:				bFEnemy = GetHasFeat(1201, oPC, TRUE);	break;
		case RACIAL_TYPE_HALFELF:				bFEnemy = GetHasFeat(1202, oPC, TRUE);	break;
		case RACIAL_TYPE_HALFORC:				bFEnemy = GetHasFeat(1203, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMAN:					bFEnemy = GetHasFeat(1204, oPC, TRUE);	break;
		case RACIAL_TYPE_ABERRATION:			bFEnemy = GetHasFeat(1205, oPC, TRUE);	break;
		case RACIAL_TYPE_ANIMAL:				bFEnemy = GetHasFeat(1206, oPC, TRUE);	break;
		case RACIAL_TYPE_BEAST:					bFEnemy = GetHasFeat(1207, oPC, TRUE);	break;
		case RACIAL_TYPE_CONSTRUCT:				bFEnemy = GetHasFeat(1208, oPC, TRUE);	break;
		case RACIAL_TYPE_DRAGON:				bFEnemy = GetHasFeat(1209, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMANOID_GOBLINOID:	bFEnemy = GetHasFeat(1210, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMANOID_MONSTROUS:	bFEnemy = GetHasFeat(1211, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMANOID_ORC:			bFEnemy = GetHasFeat(1212, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMANOID_REPTILIAN:	bFEnemy = GetHasFeat(1213, oPC, TRUE);	break;
		case RACIAL_TYPE_ELEMENTAL:				bFEnemy = GetHasFeat(1214, oPC, TRUE);	break;
		case RACIAL_TYPE_FEY:					bFEnemy = GetHasFeat(1215, oPC, TRUE);	break;
		case RACIAL_TYPE_GIANT:					bFEnemy = GetHasFeat(1216, oPC, TRUE);	break;
		case RACIAL_TYPE_MAGICAL_BEAST:			bFEnemy = GetHasFeat(1217, oPC, TRUE);	break;
		case RACIAL_TYPE_OUTSIDER:				bFEnemy = GetHasFeat(1218, oPC, TRUE);	break;
		case RACIAL_TYPE_SHAPECHANGER:			bFEnemy = GetHasFeat(1219, oPC, TRUE);	break;
		case RACIAL_TYPE_UNDEAD:				bFEnemy = GetHasFeat(1220, oPC, TRUE);	break;
		case RACIAL_TYPE_VERMIN:				bFEnemy = GetHasFeat(1221, oPC, TRUE);	break;
		default:								bFEnemy = FALSE;						break;
	}
	
	if ((GetHasFeat(2055, oPC, TRUE) == TRUE) && (nSubRace == RACIAL_SUBTYPE_PLANT)) // Plants have a subtype but not a race.
	{
		bFEnemy = TRUE;
	}
	return bFEnemy;
}

// Returns TRUE if oPC has Power Attack Favored Enemy for oTarget.
int GetIsFavoredEnemyPA(object oPC, object oTarget)
{
	int nRace = GetRacialType(oTarget);
	int nSubRace = GetSubRace(oTarget);
	int bFEnemy;
	
	switch (nRace)
	{
		case RACIAL_TYPE_DWARF:					bFEnemy = GetHasFeat(1222, oPC, TRUE);	break;
		case RACIAL_TYPE_ELF:					bFEnemy = GetHasFeat(1223, oPC, TRUE);	break;
		case RACIAL_TYPE_GNOME:					bFEnemy = GetHasFeat(1223, oPC, TRUE);	break;
		case RACIAL_TYPE_HALFLING:				bFEnemy = GetHasFeat(1224, oPC, TRUE);	break;
		case RACIAL_TYPE_HALFELF:				bFEnemy = GetHasFeat(1225, oPC, TRUE);	break;
		case RACIAL_TYPE_HALFORC:				bFEnemy = GetHasFeat(1226, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMAN:					bFEnemy = GetHasFeat(1227, oPC, TRUE);	break;
		case RACIAL_TYPE_ABERRATION:			bFEnemy = GetHasFeat(1228, oPC, TRUE);	break;
		case RACIAL_TYPE_ANIMAL:				bFEnemy = GetHasFeat(1229, oPC, TRUE);	break;
		case RACIAL_TYPE_BEAST:					bFEnemy = GetHasFeat(1230, oPC, TRUE);	break;
		case RACIAL_TYPE_CONSTRUCT:				bFEnemy = GetHasFeat(1231, oPC, TRUE);	break;
		case RACIAL_TYPE_DRAGON:				bFEnemy = GetHasFeat(1232, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMANOID_GOBLINOID:	bFEnemy = GetHasFeat(1233, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMANOID_MONSTROUS:	bFEnemy = GetHasFeat(1234, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMANOID_ORC:			bFEnemy = GetHasFeat(1235, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMANOID_REPTILIAN:	bFEnemy = GetHasFeat(1236, oPC, TRUE);	break;
		case RACIAL_TYPE_ELEMENTAL:				bFEnemy = GetHasFeat(1237, oPC, TRUE);	break;
		case RACIAL_TYPE_FEY:					bFEnemy = GetHasFeat(1238, oPC, TRUE);	break;
		case RACIAL_TYPE_GIANT:					bFEnemy = GetHasFeat(1239, oPC, TRUE);	break;
		case RACIAL_TYPE_MAGICAL_BEAST:			bFEnemy = GetHasFeat(1240, oPC, TRUE);	break;
		case RACIAL_TYPE_OUTSIDER:				bFEnemy = GetHasFeat(1241, oPC, TRUE);	break;
		case RACIAL_TYPE_SHAPECHANGER:			bFEnemy = GetHasFeat(1242, oPC, TRUE);	break;
		case RACIAL_TYPE_UNDEAD:				bFEnemy = GetHasFeat(1243, oPC, TRUE);	break;
		case RACIAL_TYPE_VERMIN:				bFEnemy = GetHasFeat(1244, oPC, TRUE);	break;
		default:								bFEnemy = FALSE;						break;
	}
	
	if ((GetHasFeat(2089, oPC, TRUE) == TRUE) && (nSubRace == RACIAL_SUBTYPE_PLANT)) // Plants have a subtype but not a race.
	{
		bFEnemy = TRUE;
	}
	return bFEnemy;
}

// Returns a specific ALIGNMENT constant for oTarget.
int GetAlignment(object oTarget)
{
	int nGoodEvil = GetAlignmentGoodEvil(oTarget);
	int nLawChaos = GetAlignmentLawChaos(oTarget);
	int nAlignment;
	
	if ((nGoodEvil == ALIGNMENT_GOOD) && (nLawChaos == ALIGNMENT_LAWFUL))
	{
		nAlignment = TYPE_ALIGNMENT_LG;
	}
	else if ((nGoodEvil == ALIGNMENT_GOOD) && (nLawChaos == ALIGNMENT_NEUTRAL) || (nLawChaos == ALIGNMENT_ALL))
	{
		nAlignment = TYPE_ALIGNMENT_NG;
	}
	else if ((nGoodEvil == ALIGNMENT_GOOD) && (nLawChaos == ALIGNMENT_CHAOTIC))
	{
		nAlignment = TYPE_ALIGNMENT_CG;
	}
	else if ((nGoodEvil == ALIGNMENT_NEUTRAL) || (nGoodEvil == ALIGNMENT_ALL) && (nLawChaos == ALIGNMENT_LAWFUL))
	{
		nAlignment = TYPE_ALIGNMENT_LN;
	}
	else if ((nGoodEvil == ALIGNMENT_NEUTRAL) || (nGoodEvil == ALIGNMENT_ALL) && (nLawChaos == ALIGNMENT_NEUTRAL) || (nLawChaos == ALIGNMENT_ALL))
	{
		nAlignment = TYPE_ALIGNMENT_TN;
	}
	else if ((nGoodEvil == ALIGNMENT_NEUTRAL) || (nGoodEvil == ALIGNMENT_ALL) && (nLawChaos == ALIGNMENT_CHAOTIC))
	{
		nAlignment = TYPE_ALIGNMENT_CN;
	}
	else if ((nGoodEvil == ALIGNMENT_EVIL) && (nLawChaos == ALIGNMENT_LAWFUL))
	{
		nAlignment = TYPE_ALIGNMENT_LE;
	}
	else if ((nGoodEvil == ALIGNMENT_EVIL) && (nLawChaos == ALIGNMENT_NEUTRAL) || (nLawChaos == ALIGNMENT_ALL))
	{
		nAlignment = TYPE_ALIGNMENT_NE;
	}
	else if ((nGoodEvil == ALIGNMENT_EVIL) && (nLawChaos == ALIGNMENT_CHAOTIC))
	{
		nAlignment = TYPE_ALIGNMENT_CE;
	}
	
	return nAlignment;
}

// Returns TRUE if oPC is Raging.
int GetIsRaging(object oPC)
{
	int nReturn = FALSE;
	
	if (GetHasSpellEffect(SPELLABILITY_BARBARIAN_RAGE, oPC) == TRUE)
	{
		return TRUE;
	}
	else if (GetHasSpellEffect(SPELLABILITY_EPIC_MIGHTY_RAGE, oPC) == TRUE)
	{
		return TRUE;
	}
	else if (GetHasSpellEffect(SPELLABILITY_RAGE_3, oPC) == TRUE)
	{
		return TRUE;
	}
	else if (GetHasSpellEffect(SPELLABILITY_RAGE_4, oPC) == TRUE)
	{
		return TRUE;
	}
	else if (GetHasSpellEffect(SPELLABILITY_RAGE_5, oPC) == TRUE)
	{
		return TRUE;
	}
	return nReturn;
}

// Returns the Z position of a vector as a float.
float GetZ(vector vPos)
{
	float fReturn = vPos.z;
	return fReturn;
}

// Returns an integer including and between nLow and nHigh.
// Only works if oToB is a valid object.
void RandomBetween(int nLow, int nHigh)
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	int nReturn;
	int nRandom = Random(nHigh) + 1;

	if (nLow == nHigh)
	{
		nReturn = nLow;
		SetLocalInt(oToB, "RandomNumber", nReturn);
	}
	else if (nRandom < nLow)
	{
		RandomBetween(nLow, nHigh);
	}
	else
	{
		nReturn = nRandom;
		SetLocalInt(oToB, "RandomNumber", nReturn);
	}
}

// Returns the percent remaining of oTarget's hit points.
int GetPercentHP(object oTarget = OBJECT_SELF)
{
	return ((GetCurrentHitPoints(oTarget)*100)/GetMaxHitPoints(oTarget));
}

//Returns the correct amount of damage for IP_CONST_DAMAGEBONUS_*.
//This function is not intended to return the IP_CONST_DAMAGEBONUS_* values as #d#. Only integers.
// -nNumber: The damage bonus we're searching for.
int IPGetConstDamageBonusFromNumber(int nNumber)
{
	switch (nNumber)
	{
		case 1: return IP_CONST_DAMAGEBONUS_1;
		case 2: return IP_CONST_DAMAGEBONUS_2;
		case 3: return IP_CONST_DAMAGEBONUS_3;
		case 4: return IP_CONST_DAMAGEBONUS_4;
		case 5: return IP_CONST_DAMAGEBONUS_5;
		case 6: return IP_CONST_DAMAGEBONUS_6;
		case 7: return IP_CONST_DAMAGEBONUS_7;
		case 8: return IP_CONST_DAMAGEBONUS_8;
		case 9: return IP_CONST_DAMAGEBONUS_9;
		case 10: return IP_CONST_DAMAGEBONUS_10;
		case 11: return IP_CONST_DAMAGEBONUS_11;
		case 12: return IP_CONST_DAMAGEBONUS_12;
		case 13: return IP_CONST_DAMAGEBONUS_13;
		case 14: return IP_CONST_DAMAGEBONUS_14;
		case 15: return IP_CONST_DAMAGEBONUS_15;
		case 16: return IP_CONST_DAMAGEBONUS_16;
		case 17: return IP_CONST_DAMAGEBONUS_17;
		case 18: return IP_CONST_DAMAGEBONUS_18;
		case 19: return IP_CONST_DAMAGEBONUS_19;
		case 20: return IP_CONST_DAMAGEBONUS_20;
		case 21: return IP_CONST_DAMAGEBONUS_21;
		case 22: return IP_CONST_DAMAGEBONUS_22;
		case 23: return IP_CONST_DAMAGEBONUS_23;
		case 24: return IP_CONST_DAMAGEBONUS_24;
		case 25: return IP_CONST_DAMAGEBONUS_25;
		case 26: return IP_CONST_DAMAGEBONUS_26;
		case 27: return IP_CONST_DAMAGEBONUS_27;
		case 28: return IP_CONST_DAMAGEBONUS_28;
		case 29: return IP_CONST_DAMAGEBONUS_29;
		case 30: return IP_CONST_DAMAGEBONUS_30;
		case 31: return IP_CONST_DAMAGEBONUS_31;
		case 32: return IP_CONST_DAMAGEBONUS_32;
		case 33: return IP_CONST_DAMAGEBONUS_33;
		case 34: return IP_CONST_DAMAGEBONUS_34;
		case 35: return IP_CONST_DAMAGEBONUS_35;
		case 36: return IP_CONST_DAMAGEBONUS_36;
		case 37: return IP_CONST_DAMAGEBONUS_37;
		case 38: return IP_CONST_DAMAGEBONUS_38;
		case 39: return IP_CONST_DAMAGEBONUS_39;
		case 40: return IP_CONST_DAMAGEBONUS_40;
	}
		
	if (nNumber > 40)
   	{
       	return IP_CONST_DAMAGEBONUS_40;
   	}
	else
   	{
       	return -1;
   	}
}

//Returns the correct amount of damage for DAMAGE_BONUS_*.
//This function is not intended to return the DAMAGE_BONUS_* values as #d#. Only integers.
// -nNumber: The damage bonus we're searching for. 
int GetConstDamageBonusFromNumber(int nNumber)
{
	switch (nNumber)
	{
		case 1: return DAMAGE_BONUS_1;
		case 2: return DAMAGE_BONUS_2;
		case 3: return DAMAGE_BONUS_3;
		case 4: return DAMAGE_BONUS_4;
		case 5: return DAMAGE_BONUS_5;
		case 6: return DAMAGE_BONUS_6;
		case 7: return DAMAGE_BONUS_7;
		case 8: return DAMAGE_BONUS_8;
		case 9: return DAMAGE_BONUS_9;
		case 10: return DAMAGE_BONUS_10;
		case 11: return DAMAGE_BONUS_11;
		case 12: return DAMAGE_BONUS_12;
		case 13: return DAMAGE_BONUS_13;
		case 14: return DAMAGE_BONUS_14;
		case 15: return DAMAGE_BONUS_15;
		case 16: return DAMAGE_BONUS_16;
		case 17: return DAMAGE_BONUS_17;
		case 18: return DAMAGE_BONUS_18;
		case 19: return DAMAGE_BONUS_19;
		case 20: return DAMAGE_BONUS_20;
		case 21: return DAMAGE_BONUS_21;
		case 22: return DAMAGE_BONUS_22;
		case 23: return DAMAGE_BONUS_23;
		case 24: return DAMAGE_BONUS_24;
		case 25: return DAMAGE_BONUS_25;
		case 26: return DAMAGE_BONUS_26;
		case 27: return DAMAGE_BONUS_27;
		case 28: return DAMAGE_BONUS_28;
		case 29: return DAMAGE_BONUS_29;
		case 30: return DAMAGE_BONUS_30;
		case 31: return DAMAGE_BONUS_31;
		case 32: return DAMAGE_BONUS_32;
		case 33: return DAMAGE_BONUS_33;
		case 34: return DAMAGE_BONUS_34;
		case 35: return DAMAGE_BONUS_35;
		case 36: return DAMAGE_BONUS_36;
		case 37: return DAMAGE_BONUS_37;
		case 38: return DAMAGE_BONUS_38;
		case 39: return DAMAGE_BONUS_39;
		case 40: return DAMAGE_BONUS_40;
	}
		
	if (nNumber > 40)
   	{
       	return DAMAGE_BONUS_40;
   	}
	else
   	{
       	return -1;
   	}
}

// Converts IP_CONST_DAMAGEBONUS_* constants into real numbers.
int GetDamageByIPConstDamageBonus(int nDamageBonus)
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nDamage;

	if (GetIsObjectValid(oToB))
	{
		if ((GetLocalInt(oToB, "Stance") == STANCE_AURA_OF_CHAOS) || (GetLocalInt(oToB, "Stance2") == STANCE_AURA_OF_CHAOS))
		{// Sadly routing for this cannot be done in a loop, since this function is commonly run from within a while loop already.
			if (nDamageBonus == IP_CONST_DAMAGEBONUS_1d10 || nDamageBonus == IP_CONST_DAMAGEBONUS_1d12 || nDamageBonus == IP_CONST_DAMAGEBONUS_1d4
			|| nDamageBonus == IP_CONST_DAMAGEBONUS_1d8 || nDamageBonus == IP_CONST_DAMAGEBONUS_1d6 || nDamageBonus == IP_CONST_DAMAGEBONUS_2d10 
			|| nDamageBonus == IP_CONST_DAMAGEBONUS_2d12 || nDamageBonus == IP_CONST_DAMAGEBONUS_2d4 || nDamageBonus == IP_CONST_DAMAGEBONUS_2d8 
			|| nDamageBonus == IP_CONST_DAMAGEBONUS_2d6 || nDamageBonus == IP_CONST_DAMAGEBONUS_3d6 || nDamageBonus == IP_CONST_DAMAGEBONUS_3d10
			|| nDamageBonus == IP_CONST_DAMAGEBONUS_3d12 || nDamageBonus == IP_CONST_DAMAGEBONUS_4d6 || nDamageBonus == IP_CONST_DAMAGEBONUS_4d8
			|| nDamageBonus == IP_CONST_DAMAGEBONUS_4d10 || nDamageBonus == IP_CONST_DAMAGEBONUS_4d12 || nDamageBonus == IP_CONST_DAMAGEBONUS_5d6
			|| nDamageBonus == IP_CONST_DAMAGEBONUS_5d12 || nDamageBonus == IP_CONST_DAMAGEBONUS_6d6 || nDamageBonus == IP_CONST_DAMAGEBONUS_6d12)
			{
				int nDie, nNum;

				switch (nDamageBonus)
				{
					case IP_CONST_DAMAGEBONUS_1d4:		nDie = 4;	nNum = 1;	break;
					case IP_CONST_DAMAGEBONUS_1d6:		nDie = 6;	nNum = 1;	break;
					case IP_CONST_DAMAGEBONUS_1d8:		nDie = 8;	nNum = 1;	break;
					case IP_CONST_DAMAGEBONUS_1d10:		nDie = 10;	nNum = 1;	break;
					case IP_CONST_DAMAGEBONUS_1d12:		nDie = 12;	nNum = 1;	break;
					case IP_CONST_DAMAGEBONUS_2d4:		nDie = 4;	nNum = 2;	break;
					case IP_CONST_DAMAGEBONUS_2d6:		nDie = 6;	nNum = 2;	break;
					case IP_CONST_DAMAGEBONUS_2d8:		nDie = 8;	nNum = 2;	break;
					case IP_CONST_DAMAGEBONUS_2d10:		nDie = 10;	nNum = 2;	break;
					case IP_CONST_DAMAGEBONUS_2d12:		nDie = 12;	nNum = 2;	break;
					case IP_CONST_DAMAGEBONUS_3d10:		nDie = 10;	nNum = 3;	break;
					case IP_CONST_DAMAGEBONUS_3d12:		nDie = 12;	nNum = 3;	break;
					case IP_CONST_DAMAGEBONUS_3d6:		nDie = 6;	nNum = 3;	break;
					case IP_CONST_DAMAGEBONUS_4d10:		nDie = 10;	nNum = 4;	break;
					case IP_CONST_DAMAGEBONUS_4d12:		nDie = 12;	nNum = 4;	break;
					case IP_CONST_DAMAGEBONUS_4d6:		nDie = 6;	nNum = 4;	break;
					case IP_CONST_DAMAGEBONUS_4d8:		nDie = 8;	nNum = 4;	break;
					case IP_CONST_DAMAGEBONUS_5d12:		nDie = 12;	nNum = 5;	break;
					case IP_CONST_DAMAGEBONUS_5d6:		nDie = 6;	nNum = 5;	break;
					case IP_CONST_DAMAGEBONUS_6d12:		nDie = 12;	nNum = 6;	break;
					case IP_CONST_DAMAGEBONUS_6d6:		nDie = 6;	nNum = 6;	break;
				}

				int nDie1Roll1 = Random(nDie); // Hard cap of 10 extra damage rolls per die.

				if (nDie1Roll1 == 0) //The function "Random" can return a zero which cannot be a damage number.
				{
					nDamage += 1;
				}
				else if (nDie1Roll1 < nDie)
				{
					nDamage += nDie1Roll1;
				}
				else // Max damage die is showing, Aura of Chaos kicks in.
				{
					nDamage += nDie1Roll1;

					int nDie1Roll2 = Random(nDie);

					if (nDie1Roll2 == 0)
					{
						nDamage += 1;
					}
					else if (nDie1Roll2 < nDie)
					{
						nDamage += nDie1Roll2;
					}
					else
					{
						nDamage += nDie1Roll2;

						int nDie1Roll3 = Random(nDie);

						if (nDie1Roll3 == 0)
						{
							nDamage += 1;
						}
						else if (nDie1Roll3 < nDie)
						{
							nDamage += nDie1Roll3;
						}
						else
						{
							nDamage += nDie1Roll3;

							int nDie1Roll4 = Random(nDie);

							if (nDie1Roll4 == 0)
							{
								nDamage += 1;
							}
							else if (nDie1Roll4 < nDie)
							{
								nDamage += nDie1Roll4;
							}
							else
							{
								nDamage += nDie1Roll4;

								int nDie1Roll5 = Random(nDie);

								if (nDie1Roll5 == 0)
								{
									nDamage += 1;
								}
								else if (nDie1Roll5 < nDie)
								{
									nDamage += nDie1Roll5;
								}
								else
								{
									nDamage += nDie1Roll5;

									int nDie1Roll6 = Random(nDie);

									if (nDie1Roll6 == 0)
									{
										nDamage += 1;
									}
									else if (nDie1Roll6 < nDie)
									{
										nDamage += nDie1Roll6;
									}
									else
									{
										nDamage += nDie1Roll6;

										int nDie1Roll7 = Random(nDie);

										if (nDie1Roll7 == 0)
										{
											nDamage += 1;
										}
										else if (nDie1Roll7 < nDie)
										{
											nDamage += nDie1Roll7;
										}
										else
										{
											nDamage += nDie1Roll7;

											int nDie1Roll8 = Random(nDie);

											if (nDie1Roll8 == 0)
											{
												nDamage += 1;
											}
											else if (nDie1Roll8 < nDie)
											{
												nDamage += nDie1Roll8;
											}
											else
											{
												nDamage += nDie1Roll8;

												int nDie1Roll9 = Random(nDie);

												if (nDie1Roll9 == 0)
												{
													nDamage += 1;
												}
												else if (nDie1Roll9 < nDie)
												{
													nDamage += nDie1Roll9;
												}
												else
												{
													int nDie1Roll10 = Random(nDie);
													nDamage += (nDie1Roll9 + nDie1Roll10);
												}
											}
										}
									}
								}
							}
						}
					}
				}

				if (nNum >= 2)
				{
					int nDie2Roll1 = Random(nDie);
	
					if (nDie2Roll1 == 0)
					{
						nDamage += 1;
					}
					else if (nDie2Roll1 < nDie)
					{
						nDamage += nDie2Roll1;
					}
					else
					{
						nDamage += nDie2Roll1;
	
						int nDie2Roll2 = Random(nDie);
	
						if (nDie2Roll2 == 0)
						{
							nDamage += 1;
						}
						else if (nDie2Roll2 < nDie)
						{
							nDamage += nDie2Roll2;
						}
						else
						{
							nDamage += nDie2Roll2;
	
							int nDie2Roll3 = Random(nDie);
	
							if (nDie2Roll3 == 0)
							{
								nDamage += 1;
							}
							else if (nDie2Roll3 < nDie)
							{
								nDamage += nDie2Roll3;
							}
							else
							{
								nDamage += nDie2Roll3;
	
								int nDie2Roll4 = Random(nDie);
	
								if (nDie2Roll4 == 0)
								{
									nDamage += 1;
								}
								else if (nDie2Roll4 < nDie)
								{
									nDamage += nDie2Roll4;
								}
								else
								{
									nDamage += nDie2Roll4;
	
									int nDie2Roll5 = Random(nDie);
	
									if (nDie2Roll5 == 0)
									{
										nDamage += 1;
									}
									else if (nDie2Roll5 < nDie)
									{
										nDamage += nDie2Roll5;
									}
									else
									{
										nDamage += nDie2Roll5;
	
										int nDie2Roll6 = Random(nDie);
	
										if (nDie2Roll6 == 0)
										{
											nDamage += 1;
										}
										else if (nDie2Roll6 < nDie)
										{
											nDamage += nDie2Roll6;
										}
										else
										{
											nDamage += nDie2Roll6;
	
											int nDie2Roll7 = Random(nDie);
	
											if (nDie2Roll7 == 0)
											{
												nDamage += 1;
											}
											else if (nDie2Roll7 < nDie)
											{
												nDamage += nDie2Roll7;
											}
											else
											{
												nDamage += nDie2Roll7;
	
												int nDie2Roll8 = Random(nDie);
	
												if (nDie2Roll8 == 0)
												{
													nDamage += 1;
												}
												else if (nDie2Roll8 < nDie)
												{
													nDamage += nDie2Roll8;
												}
												else
												{
													nDamage += nDie2Roll8;
	
													int nDie2Roll9 = Random(nDie);
	
													if (nDie2Roll9 == 0)
													{
														nDamage += 1;
													}
													else if (nDie2Roll9 < nDie)
													{
														nDamage += nDie2Roll9;
													}
													else
													{
														int nDie2Roll10 = Random(nDie);
														nDamage += (nDie2Roll9 + nDie2Roll10);
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}


				if (nNum >= 3)
				{
					int nDie3Roll1 = Random(nDie);
	
					if (nDie3Roll1 == 0)
					{
						nDamage += 1;
					}
					else if (nDie3Roll1 < nDie)
					{
						nDamage += nDie3Roll1;
					}
					else
					{
						nDamage += nDie3Roll1;
	
						int nDie3Roll2 = Random(nDie);
	
						if (nDie3Roll2 == 0)
						{
							nDamage += 1;
						}
						else if (nDie3Roll2 < nDie)
						{
							nDamage += nDie3Roll2;
						}
						else
						{
							nDamage += nDie3Roll2;
	
							int nDie3Roll3 = Random(nDie);
	
							if (nDie3Roll3 == 0)
							{
								nDamage += 1;
							}
							else if (nDie3Roll3 < nDie)
							{
								nDamage += nDie3Roll3;
							}
							else
							{
								nDamage += nDie3Roll3;
	
								int nDie3Roll4 = Random(nDie);
	
								if (nDie3Roll4 == 0)
								{
									nDamage += 1;
								}
								else if (nDie3Roll4 < nDie)
								{
									nDamage += nDie3Roll4;
								}
								else
								{
									nDamage += nDie3Roll4;
	
									int nDie3Roll5 = Random(nDie);
	
									if (nDie3Roll5 == 0)
									{
										nDamage += 1;
									}
									else if (nDie3Roll5 < nDie)
									{
										nDamage += nDie3Roll5;
									}
									else
									{
										nDamage += nDie3Roll5;
	
										int nDie3Roll6 = Random(nDie);
	
										if (nDie3Roll6 == 0)
										{
											nDamage += 1;
										}
										else if (nDie3Roll6 < nDie)
										{
											nDamage += nDie3Roll6;
										}
										else
										{
											nDamage += nDie3Roll6;
	
											int nDie3Roll7 = Random(nDie);
	
											if (nDie3Roll7 == 0)
											{
												nDamage += 1;
											}
											else if (nDie3Roll7 < nDie)
											{
												nDamage += nDie3Roll7;
											}
											else
											{
												nDamage += nDie3Roll7;
	
												int nDie3Roll8 = Random(nDie);
	
												if (nDie3Roll8 == 0)
												{
													nDamage += 1;
												}
												else if (nDie3Roll8 < nDie)
												{
													nDamage += nDie3Roll8;
												}
												else
												{
													nDamage += nDie3Roll8;
	
													int nDie3Roll9 = Random(nDie);
	
													if (nDie3Roll9 == 0)
													{
														nDamage += 1;
													}
													else if (nDie3Roll9 < nDie)
													{
														nDamage += nDie3Roll9;
													}
													else
													{
														int nDie3Roll10 = Random(nDie);
														nDamage += (nDie3Roll9 + nDie3Roll10);
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}

				if (nNum >= 4)
				{
					int nDie4Roll1 = Random(nDie);
	
					if (nDie4Roll1 == 0)
					{
						nDamage += 1;
					}
					else if (nDie4Roll1 < nDie)
					{
						nDamage += nDie4Roll1;
					}
					else
					{
						nDamage += nDie4Roll1;
	
						int nDie4Roll2 = Random(nDie);
	
						if (nDie4Roll2 == 0)
						{
							nDamage += 1;
						}
						else if (nDie4Roll2 < nDie)
						{
							nDamage += nDie4Roll2;
						}
						else
						{
							nDamage += nDie4Roll2;
	
							int nDie4Roll3 = Random(nDie);
	
							if (nDie4Roll3 == 0)
							{
								nDamage += 1;
							}
							else if (nDie4Roll3 < nDie)
							{
								nDamage += nDie4Roll3;
							}
							else
							{
								nDamage += nDie4Roll3;
	
								int nDie4Roll4 = Random(nDie);
	
								if (nDie4Roll4 == 0)
								{
									nDamage += 1;
								}
								else if (nDie4Roll4 < nDie)
								{
									nDamage += nDie4Roll4;
								}
								else
								{
									nDamage += nDie4Roll4;
	
									int nDie4Roll5 = Random(nDie);
	
									if (nDie4Roll5 == 0)
									{
										nDamage += 1;
									}
									else if (nDie4Roll5 < nDie)
									{
										nDamage += nDie4Roll5;
									}
									else
									{
										nDamage += nDie4Roll5;
	
										int nDie4Roll6 = Random(nDie);
	
										if (nDie4Roll6 == 0)
										{
											nDamage += 1;
										}
										else if (nDie4Roll6 < nDie)
										{
											nDamage += nDie4Roll6;
										}
										else
										{
											nDamage += nDie4Roll6;
	
											int nDie4Roll7 = Random(nDie);
	
											if (nDie4Roll7 == 0)
											{
												nDamage += 1;
											}
											else if (nDie4Roll7 < nDie)
											{
												nDamage += nDie4Roll7;
											}
											else
											{
												nDamage += nDie4Roll7;
	
												int nDie4Roll8 = Random(nDie);
	
												if (nDie4Roll8 == 0)
												{
													nDamage += 1;
												}
												else if (nDie4Roll8 < nDie)
												{
													nDamage += nDie4Roll8;
												}
												else
												{
													nDamage += nDie4Roll8;
	
													int nDie4Roll9 = Random(nDie);
	
													if (nDie4Roll9 == 0)
													{
														nDamage += 1;
													}
													else if (nDie4Roll9 < nDie)
													{
														nDamage += nDie4Roll9;
													}
													else
													{
														int nDie4Roll10 = Random(nDie);
														nDamage += (nDie4Roll9 + nDie4Roll10);
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}

				if (nNum >= 5)
				{
					int nDie5Roll1 = Random(nDie);
	
					if (nDie5Roll1 == 0)
					{
						nDamage += 1;
					}
					else if (nDie5Roll1 < nDie)
					{
						nDamage += nDie5Roll1;
					}
					else
					{
						nDamage += nDie5Roll1;
	
						int nDie5Roll2 = Random(nDie);
	
						if (nDie5Roll2 == 0)
						{
							nDamage += 1;
						}
						else if (nDie5Roll2 < nDie)
						{
							nDamage += nDie5Roll2;
						}
						else
						{
							nDamage += nDie5Roll2;
	
							int nDie5Roll3 = Random(nDie);
	
							if (nDie5Roll3 == 0)
							{
								nDamage += 1;
							}
							else if (nDie5Roll3 < nDie)
							{
								nDamage += nDie5Roll3;
							}
							else
							{
								nDamage += nDie5Roll3;
	
								int nDie5Roll4 = Random(nDie);
	
								if (nDie5Roll4 == 0)
								{
									nDamage += 1;
								}
								else if (nDie5Roll4 < nDie)
								{
									nDamage += nDie5Roll4;
								}
								else
								{
									nDamage += nDie5Roll4;
	
									int nDie5Roll5 = Random(nDie);
	
									if (nDie5Roll5 == 0)
									{
										nDamage += 1;
									}
									else if (nDie5Roll5 < nDie)
									{
										nDamage += nDie5Roll5;
									}
									else
									{
										nDamage += nDie5Roll5;
	
										int nDie5Roll6 = Random(nDie);
	
										if (nDie5Roll6 == 0)
										{
											nDamage += 1;
										}
										else if (nDie5Roll6 < nDie)
										{
											nDamage += nDie5Roll6;
										}
										else
										{
											nDamage += nDie5Roll6;
	
											int nDie5Roll7 = Random(nDie);
	
											if (nDie5Roll7 == 0)
											{
												nDamage += 1;
											}
											else if (nDie5Roll7 < nDie)
											{
												nDamage += nDie5Roll7;
											}
											else
											{
												nDamage += nDie5Roll7;
	
												int nDie5Roll8 = Random(nDie);
	
												if (nDie5Roll8 == 0)
												{
													nDamage += 1;
												}
												else if (nDie5Roll8 < nDie)
												{
													nDamage += nDie5Roll8;
												}
												else
												{
													nDamage += nDie5Roll8;
	
													int nDie5Roll9 = Random(nDie);
	
													if (nDie5Roll9 == 0)
													{
														nDamage += 1;
													}
													else if (nDie5Roll9 < nDie)
													{
														nDamage += nDie5Roll9;
													}
													else
													{
														int nDie5Roll10 = Random(nDie);
														nDamage += (nDie5Roll9 + nDie5Roll10);
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}

				if (nNum >= 6)
				{
					int nDie6Roll1 = Random(nDie);
	
					if (nDie6Roll1 == 0)
					{
						nDamage += 1;
					}
					else if (nDie6Roll1 < nDie)
					{
						nDamage += nDie6Roll1;
					}
					else
					{
						nDamage += nDie6Roll1;
	
						int nDie6Roll2 = Random(nDie);
	
						if (nDie6Roll2 == 0)
						{
							nDamage += 1;
						}
						else if (nDie6Roll2 < nDie)
						{
							nDamage += nDie6Roll2;
						}
						else
						{
							nDamage += nDie6Roll2;
	
							int nDie6Roll3 = Random(nDie);
	
							if (nDie6Roll3 == 0)
							{
								nDamage += 1;
							}
							else if (nDie6Roll3 < nDie)
							{
								nDamage += nDie6Roll3;
							}
							else
							{
								nDamage += nDie6Roll3;
	
								int nDie6Roll4 = Random(nDie);
	
								if (nDie6Roll4 == 0)
								{
									nDamage += 1;
								}
								else if (nDie6Roll4 < nDie)
								{
									nDamage += nDie6Roll4;
								}
								else
								{
									nDamage += nDie6Roll4;
	
									int nDie6Roll5 = Random(nDie);
	
									if (nDie6Roll5 == 0)
									{
										nDamage += 1;
									}
									else if (nDie6Roll5 < nDie)
									{
										nDamage += nDie6Roll5;
									}
									else
									{
										nDamage += nDie6Roll5;
	
										int nDie6Roll6 = Random(nDie);
	
										if (nDie6Roll6 == 0)
										{
											nDamage += 1;
										}
										else if (nDie6Roll6 < nDie)
										{
											nDamage += nDie6Roll6;
										}
										else
										{
											nDamage += nDie6Roll6;
	
											int nDie6Roll7 = Random(nDie);
	
											if (nDie6Roll7 == 0)
											{
												nDamage += 1;
											}
											else if (nDie6Roll7 < nDie)
											{
												nDamage += nDie6Roll7;
											}
											else
											{
												nDamage += nDie6Roll7;
	
												int nDie6Roll8 = Random(nDie);
	
												if (nDie6Roll8 == 0)
												{
													nDamage += 1;
												}
												else if (nDie6Roll8 < nDie)
												{
													nDamage += nDie6Roll8;
												}
												else
												{
													nDamage += nDie6Roll8;
	
													int nDie6Roll9 = Random(nDie);
	
													if (nDie6Roll9 == 0)
													{
														nDamage += 1;
													}
													else if (nDie6Roll9 < nDie)
													{
														nDamage += nDie6Roll9;
													}
													else
													{
														int nDie6Roll10 = Random(nDie);
														nDamage += (nDie6Roll9 + nDie6Roll10);
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
			else
			{
				switch (nDamageBonus)
				{
					case IP_CONST_DAMAGEBONUS_1:	nDamage = 1;		break;
					case IP_CONST_DAMAGEBONUS_10: 	nDamage = 10;		break;
					case IP_CONST_DAMAGEBONUS_11: 	nDamage = 11;		break;
					case IP_CONST_DAMAGEBONUS_12: 	nDamage = 12;		break;
					case IP_CONST_DAMAGEBONUS_13: 	nDamage = 13;		break;
					case IP_CONST_DAMAGEBONUS_14: 	nDamage = 14;		break;
					case IP_CONST_DAMAGEBONUS_15: 	nDamage = 15;		break;
					case IP_CONST_DAMAGEBONUS_16: 	nDamage = 16;		break;
					case IP_CONST_DAMAGEBONUS_17: 	nDamage = 17;		break;
					case IP_CONST_DAMAGEBONUS_18: 	nDamage = 18;		break;
					case IP_CONST_DAMAGEBONUS_19: 	nDamage = 19;		break;
					case IP_CONST_DAMAGEBONUS_2: 	nDamage = 2;		break;
					case IP_CONST_DAMAGEBONUS_20: 	nDamage = 20;		break;
					case IP_CONST_DAMAGEBONUS_21: 	nDamage = 21;		break;
					case IP_CONST_DAMAGEBONUS_22: 	nDamage = 22;		break;
					case IP_CONST_DAMAGEBONUS_23: 	nDamage = 23;		break;
					case IP_CONST_DAMAGEBONUS_24: 	nDamage = 24;		break;
					case IP_CONST_DAMAGEBONUS_25: 	nDamage = 25;		break;
					case IP_CONST_DAMAGEBONUS_26: 	nDamage = 26;		break;
					case IP_CONST_DAMAGEBONUS_27: 	nDamage = 27;		break;
					case IP_CONST_DAMAGEBONUS_28: 	nDamage = 28;		break;
					case IP_CONST_DAMAGEBONUS_29: 	nDamage = 29;		break;
					case IP_CONST_DAMAGEBONUS_3: 	nDamage = 3;		break;
					case IP_CONST_DAMAGEBONUS_30: 	nDamage = 30;		break;
					case IP_CONST_DAMAGEBONUS_31: 	nDamage = 31;		break;
					case IP_CONST_DAMAGEBONUS_32:	nDamage = 32;		break;
					case IP_CONST_DAMAGEBONUS_33:	nDamage = 33;		break;
					case IP_CONST_DAMAGEBONUS_34:	nDamage = 34;		break;
					case IP_CONST_DAMAGEBONUS_35: 	nDamage = 35;		break;
					case IP_CONST_DAMAGEBONUS_36: 	nDamage = 36;		break;
					case IP_CONST_DAMAGEBONUS_37: 	nDamage = 37;		break;
					case IP_CONST_DAMAGEBONUS_38: 	nDamage = 38;		break;
					case IP_CONST_DAMAGEBONUS_39: 	nDamage = 39;		break;
					case IP_CONST_DAMAGEBONUS_4: 	nDamage = 4;		break;
					case IP_CONST_DAMAGEBONUS_40: 	nDamage = 40;		break;
					case IP_CONST_DAMAGEBONUS_5: 	nDamage = 5;		break;
					case IP_CONST_DAMAGEBONUS_6: 	nDamage = 6;		break;
					case IP_CONST_DAMAGEBONUS_7: 	nDamage = 7;		break;
					case IP_CONST_DAMAGEBONUS_8:	nDamage = 8;		break;
					case IP_CONST_DAMAGEBONUS_9: 	nDamage = 9;		break;
					default: 						nDamage = 1;		break;
				}
			}
		}
		else
		{
			switch (nDamageBonus)
			{
				case IP_CONST_DAMAGEBONUS_1:	nDamage = 1;		break;
				case IP_CONST_DAMAGEBONUS_10: 	nDamage = 10;		break;
				case IP_CONST_DAMAGEBONUS_11: 	nDamage = 11;		break;
				case IP_CONST_DAMAGEBONUS_12: 	nDamage = 12;		break;
				case IP_CONST_DAMAGEBONUS_13: 	nDamage = 13;		break;
				case IP_CONST_DAMAGEBONUS_14: 	nDamage = 14;		break;
				case IP_CONST_DAMAGEBONUS_15: 	nDamage = 15;		break;
				case IP_CONST_DAMAGEBONUS_16: 	nDamage = 16;		break;
				case IP_CONST_DAMAGEBONUS_17: 	nDamage = 17;		break;
				case IP_CONST_DAMAGEBONUS_18: 	nDamage = 18;		break;
				case IP_CONST_DAMAGEBONUS_19: 	nDamage = 19;		break;
				case IP_CONST_DAMAGEBONUS_1d10:	nDamage = d10(1);	break;
				case IP_CONST_DAMAGEBONUS_1d12: nDamage = d12(1);	break;
				case IP_CONST_DAMAGEBONUS_1d4: 	nDamage = d4(1);	break;
				case IP_CONST_DAMAGEBONUS_1d6: 	nDamage = d6(1);	break;
				case IP_CONST_DAMAGEBONUS_1d8: 	nDamage = d8(1);	break;
				case IP_CONST_DAMAGEBONUS_2: 	nDamage = 2;		break;
				case IP_CONST_DAMAGEBONUS_20: 	nDamage = 20;		break;
				case IP_CONST_DAMAGEBONUS_21: 	nDamage = 21;		break;
				case IP_CONST_DAMAGEBONUS_22: 	nDamage = 22;		break;
				case IP_CONST_DAMAGEBONUS_23: 	nDamage = 23;		break;
				case IP_CONST_DAMAGEBONUS_24: 	nDamage = 24;		break;
				case IP_CONST_DAMAGEBONUS_25: 	nDamage = 25;		break;
				case IP_CONST_DAMAGEBONUS_26: 	nDamage = 26;		break;
				case IP_CONST_DAMAGEBONUS_27: 	nDamage = 27;		break;
				case IP_CONST_DAMAGEBONUS_28: 	nDamage = 28;		break;
				case IP_CONST_DAMAGEBONUS_29: 	nDamage = 29;		break;
				case IP_CONST_DAMAGEBONUS_2d10: nDamage = d10(2);	break;
				case IP_CONST_DAMAGEBONUS_2d12: nDamage = d12(2);	break;
				case IP_CONST_DAMAGEBONUS_2d4: 	nDamage = d4(2);	break;
				case IP_CONST_DAMAGEBONUS_2d6: 	nDamage = d6(2);	break;
				case IP_CONST_DAMAGEBONUS_2d8: 	nDamage = d8(2);	break;
				case IP_CONST_DAMAGEBONUS_3: 	nDamage = 3;		break;
				case IP_CONST_DAMAGEBONUS_30: 	nDamage = 30;		break;
				case IP_CONST_DAMAGEBONUS_31: 	nDamage = 31;		break;
				case IP_CONST_DAMAGEBONUS_32:	nDamage = 32;		break;
				case IP_CONST_DAMAGEBONUS_33:	nDamage = 33;		break;
				case IP_CONST_DAMAGEBONUS_34:	nDamage = 34;		break;
				case IP_CONST_DAMAGEBONUS_35: 	nDamage = 35;		break;
				case IP_CONST_DAMAGEBONUS_36: 	nDamage = 36;		break;
				case IP_CONST_DAMAGEBONUS_37: 	nDamage = 37;		break;
				case IP_CONST_DAMAGEBONUS_38: 	nDamage = 38;		break;
				case IP_CONST_DAMAGEBONUS_39: 	nDamage = 39;		break;
				case IP_CONST_DAMAGEBONUS_4: 	nDamage = 4;		break;
				case IP_CONST_DAMAGEBONUS_40: 	nDamage = 40;		break;
				case IP_CONST_DAMAGEBONUS_5: 	nDamage = 5;		break;
				case IP_CONST_DAMAGEBONUS_6: 	nDamage = 6;		break;
				case IP_CONST_DAMAGEBONUS_7: 	nDamage = 7;		break;
				case IP_CONST_DAMAGEBONUS_8:	nDamage = 8;		break;
				case IP_CONST_DAMAGEBONUS_9: 	nDamage = 9;		break;
				case IP_CONST_DAMAGEBONUS_3d10:	nDamage = d10(3);	break;
				case IP_CONST_DAMAGEBONUS_3d12:	nDamage = d12(3);	break;
				case IP_CONST_DAMAGEBONUS_3d6:	nDamage = d6(3);	break;
				case IP_CONST_DAMAGEBONUS_4d10:	nDamage = d10(4);	break;
				case IP_CONST_DAMAGEBONUS_4d12:	nDamage = d12(4);	break;
				case IP_CONST_DAMAGEBONUS_4d6: 	nDamage = d6(4);	break;
				case IP_CONST_DAMAGEBONUS_4d8: 	nDamage = d8(4);	break;
				case IP_CONST_DAMAGEBONUS_5d12:	nDamage = d12(5);	break;
				case IP_CONST_DAMAGEBONUS_5d6: 	nDamage = d6(5);	break;
				case IP_CONST_DAMAGEBONUS_6d12:	nDamage = d12(6);	break;
				case IP_CONST_DAMAGEBONUS_6d6: 	nDamage = d6(6);	break;
				default: 						nDamage = 1;		break;
			}
		}
	}
	else
	{
		switch (nDamageBonus)
		{
			case IP_CONST_DAMAGEBONUS_1:	nDamage = 1;		break;
			case IP_CONST_DAMAGEBONUS_10: 	nDamage = 10;		break;
			case IP_CONST_DAMAGEBONUS_11: 	nDamage = 11;		break;
			case IP_CONST_DAMAGEBONUS_12: 	nDamage = 12;		break;
			case IP_CONST_DAMAGEBONUS_13: 	nDamage = 13;		break;
			case IP_CONST_DAMAGEBONUS_14: 	nDamage = 14;		break;
			case IP_CONST_DAMAGEBONUS_15: 	nDamage = 15;		break;
			case IP_CONST_DAMAGEBONUS_16: 	nDamage = 16;		break;
			case IP_CONST_DAMAGEBONUS_17: 	nDamage = 17;		break;
			case IP_CONST_DAMAGEBONUS_18: 	nDamage = 18;		break;
			case IP_CONST_DAMAGEBONUS_19: 	nDamage = 19;		break;
			case IP_CONST_DAMAGEBONUS_1d10:	nDamage = d10(1);	break;
			case IP_CONST_DAMAGEBONUS_1d12: nDamage = d12(1);	break;
			case IP_CONST_DAMAGEBONUS_1d4: 	nDamage = d4(1);	break;
			case IP_CONST_DAMAGEBONUS_1d6: 	nDamage = d6(1);	break;
			case IP_CONST_DAMAGEBONUS_1d8: 	nDamage = d8(1);	break;
			case IP_CONST_DAMAGEBONUS_2: 	nDamage = 2;		break;
			case IP_CONST_DAMAGEBONUS_20: 	nDamage = 20;		break;
			case IP_CONST_DAMAGEBONUS_21: 	nDamage = 21;		break;
			case IP_CONST_DAMAGEBONUS_22: 	nDamage = 22;		break;
			case IP_CONST_DAMAGEBONUS_23: 	nDamage = 23;		break;
			case IP_CONST_DAMAGEBONUS_24: 	nDamage = 24;		break;
			case IP_CONST_DAMAGEBONUS_25: 	nDamage = 25;		break;
			case IP_CONST_DAMAGEBONUS_26: 	nDamage = 26;		break;
			case IP_CONST_DAMAGEBONUS_27: 	nDamage = 27;		break;
			case IP_CONST_DAMAGEBONUS_28: 	nDamage = 28;		break;
			case IP_CONST_DAMAGEBONUS_29: 	nDamage = 29;		break;
			case IP_CONST_DAMAGEBONUS_2d10: nDamage = d10(2);	break;
			case IP_CONST_DAMAGEBONUS_2d12: nDamage = d12(2);	break;
			case IP_CONST_DAMAGEBONUS_2d4: 	nDamage = d4(2);	break;
			case IP_CONST_DAMAGEBONUS_2d6: 	nDamage = d6(2);	break;
			case IP_CONST_DAMAGEBONUS_2d8: 	nDamage = d8(2);	break;
			case IP_CONST_DAMAGEBONUS_3: 	nDamage = 3;		break;
			case IP_CONST_DAMAGEBONUS_30: 	nDamage = 30;		break;
			case IP_CONST_DAMAGEBONUS_31: 	nDamage = 31;		break;
			case IP_CONST_DAMAGEBONUS_32:	nDamage = 32;		break;
			case IP_CONST_DAMAGEBONUS_33:	nDamage = 33;		break;
			case IP_CONST_DAMAGEBONUS_34:	nDamage = 34;		break;
			case IP_CONST_DAMAGEBONUS_35: 	nDamage = 35;		break;
			case IP_CONST_DAMAGEBONUS_36: 	nDamage = 36;		break;
			case IP_CONST_DAMAGEBONUS_37: 	nDamage = 37;		break;
			case IP_CONST_DAMAGEBONUS_38: 	nDamage = 38;		break;
			case IP_CONST_DAMAGEBONUS_39: 	nDamage = 39;		break;
			case IP_CONST_DAMAGEBONUS_4: 	nDamage = 4;		break;
			case IP_CONST_DAMAGEBONUS_40: 	nDamage = 40;		break;
			case IP_CONST_DAMAGEBONUS_5: 	nDamage = 5;		break;
			case IP_CONST_DAMAGEBONUS_6: 	nDamage = 6;		break;
			case IP_CONST_DAMAGEBONUS_7: 	nDamage = 7;		break;
			case IP_CONST_DAMAGEBONUS_8:	nDamage = 8;		break;
			case IP_CONST_DAMAGEBONUS_9: 	nDamage = 9;		break;
			case IP_CONST_DAMAGEBONUS_3d10:	nDamage = d10(3);	break;
			case IP_CONST_DAMAGEBONUS_3d12:	nDamage = d12(3);	break;
			case IP_CONST_DAMAGEBONUS_3d6:	nDamage = d6(3);	break;
			case IP_CONST_DAMAGEBONUS_4d10:	nDamage = d10(4);	break;
			case IP_CONST_DAMAGEBONUS_4d12:	nDamage = d12(4);	break;
			case IP_CONST_DAMAGEBONUS_4d6: 	nDamage = d6(4);	break;
			case IP_CONST_DAMAGEBONUS_4d8: 	nDamage = d8(4);	break;
			case IP_CONST_DAMAGEBONUS_5d12:	nDamage = d12(5);	break;
			case IP_CONST_DAMAGEBONUS_5d6: 	nDamage = d6(5);	break;
			case IP_CONST_DAMAGEBONUS_6d12:	nDamage = d12(6);	break;
			case IP_CONST_DAMAGEBONUS_6d6: 	nDamage = d6(6);	break;
			default: 						nDamage = 1;		break;
		}
	}

	return nDamage;
}

// Converts DAMAGE_BONUS_* constants into real numbers.
int GetDamageByDamageBonus(int nDamageBonus)
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nDamage;

	if (GetIsObjectValid(oToB))
	{
		if ((GetLocalInt(oToB, "Stance") == STANCE_AURA_OF_CHAOS) || (GetLocalInt(oToB, "Stance2") == STANCE_AURA_OF_CHAOS))
		{// Sadly routing for this cannot be done in a loop, since this function is commonly run from within a while loop already.
			if (nDamageBonus == DAMAGE_BONUS_1d10 || nDamageBonus == DAMAGE_BONUS_1d12 || nDamageBonus == DAMAGE_BONUS_1d4
			|| nDamageBonus == DAMAGE_BONUS_1d8 || nDamageBonus == DAMAGE_BONUS_1d6 || nDamageBonus == DAMAGE_BONUS_2d10 
			|| nDamageBonus == DAMAGE_BONUS_2d12 || nDamageBonus == DAMAGE_BONUS_2d4 || nDamageBonus == DAMAGE_BONUS_2d8 
			|| nDamageBonus == DAMAGE_BONUS_2d6)
			{
				int nDie, nNum;

				switch (nDamageBonus)
				{
					case DAMAGE_BONUS_1d4:		nDie = 4;	nNum = 1;	break;
					case DAMAGE_BONUS_1d6:		nDie = 6;	nNum = 1;	break;
					case DAMAGE_BONUS_1d8:		nDie = 8;	nNum = 1;	break;
					case DAMAGE_BONUS_1d10:		nDie = 10;	nNum = 1;	break;
					case DAMAGE_BONUS_1d12:		nDie = 12;	nNum = 1;	break;
					case DAMAGE_BONUS_2d4:		nDie = 4;	nNum = 2;	break;
					case DAMAGE_BONUS_2d6:		nDie = 6;	nNum = 2;	break;
					case DAMAGE_BONUS_2d8:		nDie = 8;	nNum = 2;	break;
					case DAMAGE_BONUS_2d10:		nDie = 10;	nNum = 2;	break;
					case DAMAGE_BONUS_2d12:		nDie = 12;	nNum = 2;	break;
				}

				int nDie1Roll1 = Random(nDie); // Hard cap of 10 extra damage rolls per die.

				if (nDie1Roll1 == 0) //The function "Random" can return a zero which cannot be a damage number.
				{
					nDamage += 1;
				}
				else if (nDie1Roll1 < nDie)
				{
					nDamage += nDie1Roll1;
				}
				else // Max damage die is showing, Aura of Chaos kicks in.
				{
					nDamage += nDie1Roll1;

					int nDie1Roll2 = Random(nDie);

					if (nDie1Roll2 == 0)
					{
						nDamage += 1;
					}
					else if (nDie1Roll2 < nDie)
					{
						nDamage += nDie1Roll2;
					}
					else
					{
						nDamage += nDie1Roll2;

						int nDie1Roll3 = Random(nDie);

						if (nDie1Roll3 == 0)
						{
							nDamage += 1;
						}
						else if (nDie1Roll3 < nDie)
						{
							nDamage += nDie1Roll3;
						}
						else
						{
							nDamage += nDie1Roll3;

							int nDie1Roll4 = Random(nDie);

							if (nDie1Roll4 == 0)
							{
								nDamage += 1;
							}
							else if (nDie1Roll4 < nDie)
							{
								nDamage += nDie1Roll4;
							}
							else
							{
								nDamage += nDie1Roll4;

								int nDie1Roll5 = Random(nDie);

								if (nDie1Roll5 == 0)
								{
									nDamage += 1;
								}
								else if (nDie1Roll5 < nDie)
								{
									nDamage += nDie1Roll5;
								}
								else
								{
									nDamage += nDie1Roll5;

									int nDie1Roll6 = Random(nDie);

									if (nDie1Roll6 == 0)
									{
										nDamage += 1;
									}
									else if (nDie1Roll6 < nDie)
									{
										nDamage += nDie1Roll6;
									}
									else
									{
										nDamage += nDie1Roll6;

										int nDie1Roll7 = Random(nDie);

										if (nDie1Roll7 == 0)
										{
											nDamage += 1;
										}
										else if (nDie1Roll7 < nDie)
										{
											nDamage += nDie1Roll7;
										}
										else
										{
											nDamage += nDie1Roll7;

											int nDie1Roll8 = Random(nDie);

											if (nDie1Roll8 == 0)
											{
												nDamage += 1;
											}
											else if (nDie1Roll8 < nDie)
											{
												nDamage += nDie1Roll8;
											}
											else
											{
												nDamage += nDie1Roll8;

												int nDie1Roll9 = Random(nDie);

												if (nDie1Roll9 == 0)
												{
													nDamage += 1;
												}
												else if (nDie1Roll9 < nDie)
												{
													nDamage += nDie1Roll9;
												}
												else
												{
													int nDie1Roll10 = Random(nDie);
													nDamage += (nDie1Roll9 + nDie1Roll10);
												}
											}
										}
									}
								}
							}
						}
					}
				}

				if (nNum >= 2)
				{
					int nDie2Roll1 = Random(nDie);
	
					if (nDie2Roll1 == 0)
					{
						nDamage += 1;
					}
					else if (nDie2Roll1 < nDie)
					{
						nDamage += nDie2Roll1;
					}
					else
					{
						nDamage += nDie2Roll1;
	
						int nDie2Roll2 = Random(nDie);
	
						if (nDie2Roll2 == 0)
						{
							nDamage += 1;
						}
						else if (nDie2Roll2 < nDie)
						{
							nDamage += nDie2Roll2;
						}
						else
						{
							nDamage += nDie2Roll2;
	
							int nDie2Roll3 = Random(nDie);
	
							if (nDie2Roll3 == 0)
							{
								nDamage += 1;
							}
							else if (nDie2Roll3 < nDie)
							{
								nDamage += nDie2Roll3;
							}
							else
							{
								nDamage += nDie2Roll3;
	
								int nDie2Roll4 = Random(nDie);
	
								if (nDie2Roll4 == 0)
								{
									nDamage += 1;
								}
								else if (nDie2Roll4 < nDie)
								{
									nDamage += nDie2Roll4;
								}
								else
								{
									nDamage += nDie2Roll4;
	
									int nDie2Roll5 = Random(nDie);
	
									if (nDie2Roll5 == 0)
									{
										nDamage += 1;
									}
									else if (nDie2Roll5 < nDie)
									{
										nDamage += nDie2Roll5;
									}
									else
									{
										nDamage += nDie2Roll5;
	
										int nDie2Roll6 = Random(nDie);
	
										if (nDie2Roll6 == 0)
										{
											nDamage += 1;
										}
										else if (nDie2Roll6 < nDie)
										{
											nDamage += nDie2Roll6;
										}
										else
										{
											nDamage += nDie2Roll6;
	
											int nDie2Roll7 = Random(nDie);
	
											if (nDie2Roll7 == 0)
											{
												nDamage += 1;
											}
											else if (nDie2Roll7 < nDie)
											{
												nDamage += nDie2Roll7;
											}
											else
											{
												nDamage += nDie2Roll7;
	
												int nDie2Roll8 = Random(nDie);
	
												if (nDie2Roll8 == 0)
												{
													nDamage += 1;
												}
												else if (nDie2Roll8 < nDie)
												{
													nDamage += nDie2Roll8;
												}
												else
												{
													nDamage += nDie2Roll8;
	
													int nDie2Roll9 = Random(nDie);
	
													if (nDie2Roll9 == 0)
													{
														nDamage += 1;
													}
													else if (nDie2Roll9 < nDie)
													{
														nDamage += nDie2Roll9;
													}
													else
													{
														int nDie2Roll10 = Random(nDie);
														nDamage += (nDie2Roll9 + nDie2Roll10);
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
			else
			{
				switch (nDamageBonus)
				{
					case DAMAGE_BONUS_1:	nDamage = 1;		break;
					case DAMAGE_BONUS_10: 	nDamage = 10;		break;
					case DAMAGE_BONUS_11: 	nDamage = 11;		break;
					case DAMAGE_BONUS_12: 	nDamage = 12;		break;
					case DAMAGE_BONUS_13: 	nDamage = 13;		break;
					case DAMAGE_BONUS_14: 	nDamage = 14;		break;
					case DAMAGE_BONUS_15: 	nDamage = 15;		break;
					case DAMAGE_BONUS_16: 	nDamage = 16;		break;
					case DAMAGE_BONUS_17: 	nDamage = 17;		break;
					case DAMAGE_BONUS_18: 	nDamage = 18;		break;
					case DAMAGE_BONUS_19: 	nDamage = 19;		break;
					case DAMAGE_BONUS_2: 	nDamage = 2;		break;
					case DAMAGE_BONUS_20: 	nDamage = 20;		break;
					case DAMAGE_BONUS_21: 	nDamage = 21;		break;
					case DAMAGE_BONUS_22: 	nDamage = 22;		break;
					case DAMAGE_BONUS_23: 	nDamage = 23;		break;
					case DAMAGE_BONUS_24: 	nDamage = 24;		break;
					case DAMAGE_BONUS_25: 	nDamage = 25;		break;
					case DAMAGE_BONUS_26: 	nDamage = 26;		break;
					case DAMAGE_BONUS_27: 	nDamage = 27;		break;
					case DAMAGE_BONUS_28: 	nDamage = 28;		break;
					case DAMAGE_BONUS_29: 	nDamage = 29;		break;
					case DAMAGE_BONUS_3: 	nDamage = 3;		break;
					case DAMAGE_BONUS_30: 	nDamage = 30;		break;
					case DAMAGE_BONUS_31: 	nDamage = 31;		break;
					case DAMAGE_BONUS_32:	nDamage = 32;		break;
					case DAMAGE_BONUS_33:	nDamage = 33;		break;
					case DAMAGE_BONUS_34:	nDamage = 34;		break;
					case DAMAGE_BONUS_35: 	nDamage = 35;		break;
					case DAMAGE_BONUS_36: 	nDamage = 36;		break;
					case DAMAGE_BONUS_37: 	nDamage = 37;		break;
					case DAMAGE_BONUS_38: 	nDamage = 38;		break;
					case DAMAGE_BONUS_39: 	nDamage = 39;		break;
					case DAMAGE_BONUS_4: 	nDamage = 4;		break;
					case DAMAGE_BONUS_40: 	nDamage = 40;		break;
					case DAMAGE_BONUS_5: 	nDamage = 5;		break;
					case DAMAGE_BONUS_6: 	nDamage = 6;		break;
					case DAMAGE_BONUS_7: 	nDamage = 7;		break;
					case DAMAGE_BONUS_8:	nDamage = 8;		break;
					case DAMAGE_BONUS_9: 	nDamage = 9;		break;
					default: 				nDamage = 1;		break;
				}
			}
		}
		else
		{
			switch (nDamageBonus)
			{
				case DAMAGE_BONUS_1:	nDamage = 1;		break;
				case DAMAGE_BONUS_10: 	nDamage = 10;		break;
				case DAMAGE_BONUS_11: 	nDamage = 11;		break;
				case DAMAGE_BONUS_12: 	nDamage = 12;		break;
				case DAMAGE_BONUS_13: 	nDamage = 13;		break;
				case DAMAGE_BONUS_14: 	nDamage = 14;		break;
				case DAMAGE_BONUS_15: 	nDamage = 15;		break;
				case DAMAGE_BONUS_16: 	nDamage = 16;		break;
				case DAMAGE_BONUS_17: 	nDamage = 17;		break;
				case DAMAGE_BONUS_18: 	nDamage = 18;		break;
				case DAMAGE_BONUS_19: 	nDamage = 19;		break;
				case DAMAGE_BONUS_1d10:	nDamage = d10(1);	break;
				case DAMAGE_BONUS_1d12: nDamage = d12(1);	break;
				case DAMAGE_BONUS_1d4: 	nDamage = d4(1);	break;
				case DAMAGE_BONUS_1d6: 	nDamage = d6(1);	break;
				case DAMAGE_BONUS_1d8: 	nDamage = d8(1);	break;
				case DAMAGE_BONUS_2: 	nDamage = 2;		break;
				case DAMAGE_BONUS_20: 	nDamage = 20;		break;
				case DAMAGE_BONUS_21: 	nDamage = 21;		break;
				case DAMAGE_BONUS_22: 	nDamage = 22;		break;
				case DAMAGE_BONUS_23: 	nDamage = 23;		break;
				case DAMAGE_BONUS_24: 	nDamage = 24;		break;
				case DAMAGE_BONUS_25: 	nDamage = 25;		break;
				case DAMAGE_BONUS_26: 	nDamage = 26;		break;
				case DAMAGE_BONUS_27: 	nDamage = 27;		break;
				case DAMAGE_BONUS_28: 	nDamage = 28;		break;
				case DAMAGE_BONUS_29: 	nDamage = 29;		break;
				case DAMAGE_BONUS_2d10: nDamage = d10(2);	break;
				case DAMAGE_BONUS_2d12: nDamage = d12(2);	break;
				case DAMAGE_BONUS_2d4: 	nDamage = d4(2);	break;
				case DAMAGE_BONUS_2d6: 	nDamage = d6(2);	break;
				case DAMAGE_BONUS_2d8: 	nDamage = d8(2);	break;
				case DAMAGE_BONUS_3: 	nDamage = 3;		break;
				case DAMAGE_BONUS_30: 	nDamage = 30;		break;
				case DAMAGE_BONUS_31: 	nDamage = 31;		break;
				case DAMAGE_BONUS_32:	nDamage = 32;		break;
				case DAMAGE_BONUS_33:	nDamage = 33;		break;
				case DAMAGE_BONUS_34:	nDamage = 34;		break;
				case DAMAGE_BONUS_35: 	nDamage = 35;		break;
				case DAMAGE_BONUS_36: 	nDamage = 36;		break;
				case DAMAGE_BONUS_37: 	nDamage = 37;		break;
				case DAMAGE_BONUS_38: 	nDamage = 38;		break;
				case DAMAGE_BONUS_39: 	nDamage = 39;		break;
				case DAMAGE_BONUS_4: 	nDamage = 4;		break;
				case DAMAGE_BONUS_40: 	nDamage = 40;		break;
				case DAMAGE_BONUS_5: 	nDamage = 5;		break;
				case DAMAGE_BONUS_6: 	nDamage = 6;		break;
				case DAMAGE_BONUS_7: 	nDamage = 7;		break;
				case DAMAGE_BONUS_8:	nDamage = 8;		break;
				case DAMAGE_BONUS_9: 	nDamage = 9;		break;
				default: 				nDamage = 1;		break;
			}
		}
	}
	else
	{
		switch (nDamageBonus)
		{
			case DAMAGE_BONUS_1:	nDamage = 1;		break;
			case DAMAGE_BONUS_10: 	nDamage = 10;		break;
			case DAMAGE_BONUS_11: 	nDamage = 11;		break;
			case DAMAGE_BONUS_12: 	nDamage = 12;		break;
			case DAMAGE_BONUS_13: 	nDamage = 13;		break;
			case DAMAGE_BONUS_14: 	nDamage = 14;		break;
			case DAMAGE_BONUS_15: 	nDamage = 15;		break;
			case DAMAGE_BONUS_16: 	nDamage = 16;		break;
			case DAMAGE_BONUS_17: 	nDamage = 17;		break;
			case DAMAGE_BONUS_18: 	nDamage = 18;		break;
			case DAMAGE_BONUS_19: 	nDamage = 19;		break;
			case DAMAGE_BONUS_1d10:	nDamage = d10(1);	break;
			case DAMAGE_BONUS_1d12: nDamage = d12(1);	break;
			case DAMAGE_BONUS_1d4: 	nDamage = d4(1);	break;
			case DAMAGE_BONUS_1d6: 	nDamage = d6(1);	break;
			case DAMAGE_BONUS_1d8: 	nDamage = d8(1);	break;
			case DAMAGE_BONUS_2: 	nDamage = 2;		break;
			case DAMAGE_BONUS_20: 	nDamage = 20;		break;
			case DAMAGE_BONUS_21: 	nDamage = 21;		break;
			case DAMAGE_BONUS_22: 	nDamage = 22;		break;
			case DAMAGE_BONUS_23: 	nDamage = 23;		break;
			case DAMAGE_BONUS_24: 	nDamage = 24;		break;
			case DAMAGE_BONUS_25: 	nDamage = 25;		break;
			case DAMAGE_BONUS_26: 	nDamage = 26;		break;
			case DAMAGE_BONUS_27: 	nDamage = 27;		break;
			case DAMAGE_BONUS_28: 	nDamage = 28;		break;
			case DAMAGE_BONUS_29: 	nDamage = 29;		break;
			case DAMAGE_BONUS_2d10: nDamage = d10(2);	break;
			case DAMAGE_BONUS_2d12: nDamage = d12(2);	break;
			case DAMAGE_BONUS_2d4: 	nDamage = d4(2);	break;
			case DAMAGE_BONUS_2d6: 	nDamage = d6(2);	break;
			case DAMAGE_BONUS_2d8: 	nDamage = d8(2);	break;
			case DAMAGE_BONUS_3: 	nDamage = 3;		break;
			case DAMAGE_BONUS_30: 	nDamage = 30;		break;
			case DAMAGE_BONUS_31: 	nDamage = 31;		break;
			case DAMAGE_BONUS_32:	nDamage = 32;		break;
			case DAMAGE_BONUS_33:	nDamage = 33;		break;
			case DAMAGE_BONUS_34:	nDamage = 34;		break;
			case DAMAGE_BONUS_35: 	nDamage = 35;		break;
			case DAMAGE_BONUS_36: 	nDamage = 36;		break;
			case DAMAGE_BONUS_37: 	nDamage = 37;		break;
			case DAMAGE_BONUS_38: 	nDamage = 38;		break;
			case DAMAGE_BONUS_39: 	nDamage = 39;		break;
			case DAMAGE_BONUS_4: 	nDamage = 4;		break;
			case DAMAGE_BONUS_40: 	nDamage = 40;		break;
			case DAMAGE_BONUS_5: 	nDamage = 5;		break;
			case DAMAGE_BONUS_6: 	nDamage = 6;		break;
			case DAMAGE_BONUS_7: 	nDamage = 7;		break;
			case DAMAGE_BONUS_8:	nDamage = 8;		break;
			case DAMAGE_BONUS_9: 	nDamage = 9;		break;
			default: 				nDamage = 1;		break;
		}
	}

	return nDamage;
}

// Returns the damage of a die with nDice sides, for nNum amount of Dice.
int GetDamageByDice(int nDice, int nNum)
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nDamage, nCheck;
	effect eMax;

	eMax = GetFirstEffect(oPC);

	while (GetIsEffectValid(eMax))
	{
		int nType = GetEffectType(eMax);

		if (nType == EFFECT_TYPE_MAX_DAMAGE)
		{
			nCheck = 1;
			break;
		}
		eMax = GetNextEffect(oPC);
	}

	if (nCheck == 1) // Max damage effect and Aura of Chaos would crash these functions if stacked.
	{
		nDamage = nDice * nNum;
	}
	else if (GetIsObjectValid(oToB))
	{
		if ((GetLocalInt(oToB, "Stance") == STANCE_AURA_OF_CHAOS) || (GetLocalInt(oToB, "Stance2") == STANCE_AURA_OF_CHAOS))
		{
			int nTotal, n;

			n = 1;

			while (n <= nNum)
			{
				switch (nDice)
				{
					case 2:	nDamage = d2(1);	break;
					case 3:	nDamage = d3(1);	break;
					case 4:	nDamage	= d4(1);	break;
					case 6: nDamage = d6(1);	break;
					case 8: nDamage = d8(1);	break;
					case 10:nDamage = d10(1);	break;
					case 12:nDamage = d12(1);	break;
					case 20:nDamage = d20(1);	break;
					default:nDamage = 1;		break;
				}

				if (nDamage < nDice) // Damage die is not max value.
				{
					nTotal += nDamage;
					n++;
				}
				else nTotal += nDamage;
			}

			nDamage = nTotal;
		}
		else
		{
			switch (nDice)
			{
				case 2:	nDamage = d2(nNum);	break;
				case 3:	nDamage = d3(nNum);	break;
				case 4:	nDamage	= d4(nNum);	break;
				case 6: nDamage = d6(nNum);	break;
				case 8: nDamage = d8(nNum);	break;
				case 10:nDamage = d10(nNum);break;
				case 12:nDamage = d12(nNum);break;
				case 20:nDamage = d20(nNum);break;
				default:nDamage = 1;		break;
			}
		}
	}
	else
	{
		switch (nDice)
		{
			case 2:	nDamage = d2(nNum);	break;
			case 3:	nDamage = d3(nNum);	break;
			case 4:	nDamage	= d4(nNum);	break;
			case 6: nDamage = d6(nNum);	break;
			case 8: nDamage = d8(nNum);	break;
			case 10:nDamage = d10(nNum);break;
			case 12:nDamage = d12(nNum);break;
			case 20:nDamage = d20(nNum);break;
			default:nDamage = 1;		break;
		}
	}
	
	return nDamage;	
}