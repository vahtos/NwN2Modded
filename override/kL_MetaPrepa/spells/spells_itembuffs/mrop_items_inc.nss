// 'mrop_items_inc'
//
// kevL 2016 sept 10
// - data from the kPrC Pack to allow re-compiling.
// - helper functions and rewritten functions for buffing items.


// ________________
// ** CONSTANTS ***
// ----------------
const int FEAT_SACREDFIST_SPELLCASTING_PALADIN		= 1551;
const int FEAT_SACREDFIST_SPELLCASTING_RANGER		= 1552;
const int FEAT_HARPER_SPELLCASTING_PALADIN			= 1582;
const int FEAT_HARPER_SPELLCASTING_RANGER			= 1583;
const int FEAT_WARPRIEST_SPELLCASTING_PALADIN		= 1810;
const int FEAT_WARPRIEST_SPELLCASTING_RANGER		= 1811;
const int FEAT_STORMLORD_SPELLCASTING_PALADIN		= 2035;
const int FEAT_STORMLORD_SPELLCASTING_RANGER		= 2036;
const int FEAT_DOOMGUIDE_PALADIN_SPELLCASTING		= 2250;
const int FEAT_DOOMGUIDE_RANGER_SPELLCASTING		= 2254;
const int FEAT_HOSPITALER_SPELLCASTING_PALADIN		= 2996;
const int FEAT_HOSPITALER_SPELLCASTING_RANGER		= 2997;
const int FEAT_SHINING_BLADE_SPELLCASTING_PALADIN	= 3002;
const int FEAT_SHINING_BLADE_SPELLCASTING_RANGER	= 3003;
const int FEAT_BFZ_SPELLCASTING_PALADIN				= 3008;
const int FEAT_BFZ_SPELLCASTING_RANGER				= 3009;
const int FEAT_STORMSINGER_SPELLCASTING_PALADIN		= 3123;
const int FEAT_STORMSINGER_SPELLCASTING_RANGER		= 3124;
const int FEAT_LION_TALISID_SPELLCASTING_PALADIN	= 3150;
const int FEAT_LION_TALISID_SPELLCASTING_RANGER		= 3151;
const int FEAT_MASTER_RADIANCE_SPELLCASTING_PALADIN	= 3181;
const int FEAT_MASTER_RADIANCE_SPELLCASTING_RANGER	= 3182;
const int FEAT_FOREST_MASTER_SPELLCASTING_PALADIN	= 3213;
const int FEAT_FOREST_MASTER_SPELLCASTING_RANGER	= 3214;
const int FEAT_NATWAR_SPELLCASTING_RANGER			= 3253;
const int FEAT_HEARTWARDER_SPELLCASTING_PALADIN		= 3266;
const int FEAT_HEARTWARDER_SPELLCASTING_RANGER		= 3267;
const int FEAT_FROSTMAGE_SPELLCASTING_PALADIN		= 3279;
const int FEAT_FROSTMAGE_SPELLCASTING_RANGER		= 3280;
const int FEAT_CANAITH_SPELLCASTING_PALADIN			= 3324;
const int FEAT_CANAITH_SPELLCASTING_RANGER			= 3325;
const int FEAT_KOT_SPELLCASTING_PALADIN				= 3336;
const int FEAT_KOT_SPELLCASTING_RANGER				= 3337;
const int FEAT_SHDWSTLKR_SPELLCASTING_PALADIN		= 3348;
const int FEAT_SHDWSTLKR_SPELLCASTING_RANGER		= 3349;
const int FEAT_DRSLR_SPELLCASTING_PALADIN			= 3367;
const int FEAT_DRSLR_SPELLCASTING_RANGER			= 3368;
const int FEAT_ELDDISC_SPELLCASTING_PALADIN			= 3383;
const int FEAT_ELDDISC_SPELLCASTING_RANGER			= 3384;
const int FEAT_COTSF_SPELLCASTING_PALADIN			= 3546;
const int FEAT_SWRDNCR_SPELLCASTING_PALADIN			= 3556;
const int FEAT_SWRDNCR_SPELLCASTING_RANGER			= 3557;
const int FEAT_CHLDNIGHT_SPELLCASTING_PALADIN		= 3580;
const int FEAT_CHLDNIGHT_SPELLCASTING_RANGER		= 3581;
const int FEAT_DSHAPE_SPELLCASTING_PALADIN			= 3723;
const int FEAT_DSHAPE_SPELLCASTING_RANGER			= 3724;

const int CLASS_HOSPITALER			= 106;
const int CLASS_STORMSINGER			= 109;
const int CLASS_BLACK_FLAME_ZEALOT	= 111;
const int CLASS_SHINING_BLADE		= 112;
const int CLASS_SWIFTBLADE			= 113;
const int CLASS_FOREST_MASTER		= 114;
const int CLASS_ELDRITCH_DISCIPLE	= 117;
const int CLASS_NATURES_WARRIOR		= 121;
const int CLASS_FROST_MAGE			= 122;
const int CLASS_LION_TALISID		= 123;
const int CLASS_CANAITH_LYRIST		= 124;
const int CLASS_MASTER_RADIANCE		= 130;
const int CLASS_HEARTWARDER			= 131;
const int CLASS_KNIGHT_TIERDRIAL	= 132;
const int CLASS_SHADOWBANE_STALKER	= 133;
const int CLASS_DRAGONSLAYER		= 134;
const int CLASS_CHAMP_SILVER_FLAME	= 137;
const int CLASS_SWORD_DANCER		= 138;
const int CLASS_CHILD_NIGHT			= 140;
const int CLASS_DAGGERSPELL_SHAPER	= 148;

const int SPELL_Lesser_Energized_Shield		= 1747;
//const int SPELL_Lesser_Energized_Shield_F	= 1748;
//const int SPELL_Lesser_Energized_Shield_C	= 1749;
//const int SPELL_Lesser_Energized_Shield_E	= 1750;
//const int SPELL_Lesser_Energized_Shield_A	= 1751;
//const int SPELL_Lesser_Energized_Shield_S	= 1752;
const int SPELL_Energized_Shield			= 1753;
//const int SPELL_Energized_Shield_F		= 1754;
//const int SPELL_Energized_Shield_C		= 1755;
//const int SPELL_Energized_Shield_E		= 1756;
//const int SPELL_Energized_Shield_A		= 1757;
//const int SPELL_Energized_Shield_S		= 1758;
const int SPELL_Weapon_Energy				= 1814;
const int SPELL_Weapon_Energy_F				= 1815;
const int SPELL_Weapon_Energy_A				= 1816;
const int SPELL_Weapon_Energy_C				= 1817;
const int SPELL_Weapon_Energy_E				= 1818;

// public.
const int WEAPTYPE_ALL = 0;
const int WEAPTYPE_MEL = 1;
const int WEAPTYPE_RAN = 2;

const int ARMTYPE_ALL = 0;
const int ARMTYPE_ARM = 1;
const int ARMTYPE_SHD = 2;

// private.
const string BASEITEMS = "baseitems"; // Baseitems.2da


// ___________________
// ** DECLARATIONS ***
// -------------------

// public.
int GetFighterCasterLevel(object oCaster = OBJECT_SELF);

// private.
int GetPaladinCasterLevel(object oCaster);
// private.
int GetRangerCasterLevel(object oCaster);
// private.
int GetPrestigeCasterLevel(int iClass, int iClassLevel, object oTarget);

// public.
object GetTargetWeapon(int iWeapType = WEAPTYPE_ALL);
// public.
object GetTargetArmor(int iArmorType = ARMTYPE_ALL);
// public.
object GetTargetShield();

// private.
int isWeaponType(object oWeapon, int iWeapType);
// private.
int isMelee(object oItem);
// private.
int isRanged(object oItem);

// private.
int isArmorType(object oArmor, int iArmorType);
// private.
int isArmor(object oItem);
// private.
int isShield(object oItem);

// Converts a hexadecimal string to a decimal value.
int kL_HexStringToInt(string sHexString);
// Gets the decimal value of a hexadecimal digit.
int kL_GetHexStringDigitValue(string sHexDigit);

// public.
void ClearEnergizedEffects(object oTarget);
// public.
effect CreateEnergizedEffect(int iType, int bLesser = FALSE);


// __________________
// ** DEFINITIONS ***
// ------------------

// public.
int GetFighterCasterLevel(object oCaster = OBJECT_SELF)
{
	int iLevel;

	switch (GetLastSpellCastClass())
	{
		case CLASS_TYPE_PALADIN:
			iLevel = GetPaladinCasterLevel(oCaster) - 3;
			break;

		case CLASS_TYPE_RANGER:
			iLevel = GetRangerCasterLevel(oCaster) - 3;
			break;

		default:
			iLevel = GetCasterLevel(oCaster);
	}

	return ((iLevel < 1) ? 1 : iLevel); // safety.
}

// private.
int GetPaladinCasterLevel(object oCaster)
{
	int iPal = GetLevelByClass(CLASS_TYPE_PALADIN, oCaster);

	if (GetHasFeat(FEAT_DSHAPE_SPELLCASTING_PALADIN, oCaster))
		iPal += GetLevelByClass(CLASS_DAGGERSPELL_SHAPER, oCaster) - 1;

	if (GetHasFeat(FEAT_COTSF_SPELLCASTING_PALADIN, oCaster))
		iPal += GetLevelByClass(CLASS_CHAMP_SILVER_FLAME, oCaster);

	if (GetHasFeat(FEAT_CHLDNIGHT_SPELLCASTING_PALADIN, oCaster))
		iPal += GetLevelByClass(CLASS_CHILD_NIGHT, oCaster) - 1;

	if (GetHasFeat(FEAT_SWRDNCR_SPELLCASTING_PALADIN, oCaster))
		iPal += GetLevelByClass(CLASS_SWORD_DANCER, oCaster);

	if (GetHasFeat(FEAT_DRSLR_SPELLCASTING_PALADIN, oCaster))
		iPal += (GetLevelByClass(CLASS_DRAGONSLAYER, oCaster) + 1) / 2;

	if (GetHasFeat(FEAT_ELDDISC_SPELLCASTING_PALADIN, oCaster))
		iPal += GetLevelByClass(CLASS_ELDRITCH_DISCIPLE, oCaster);

	if (GetHasFeat(FEAT_KOT_SPELLCASTING_PALADIN, oCaster))
		iPal += GetLevelByClass(CLASS_KNIGHT_TIERDRIAL, oCaster);

	if (GetHasFeat(FEAT_SHDWSTLKR_SPELLCASTING_PALADIN, oCaster))
		iPal += (GetLevelByClass(CLASS_SHADOWBANE_STALKER, oCaster) + 1) * 3 / 4;

	if (GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_PALADIN, oCaster))
		iPal += GetLevelByClass(CLASS_FROST_MAGE, oCaster);

	if (GetHasFeat(FEAT_CANAITH_SPELLCASTING_PALADIN, oCaster))
		iPal += GetLevelByClass(CLASS_CANAITH_LYRIST, oCaster);

	if (GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_PALADIN, oCaster))
		iPal += GetLevelByClass(CLASS_HEARTWARDER, oCaster);

	if (GetHasFeat(FEAT_FOREST_MASTER_SPELLCASTING_PALADIN, oCaster))
		iPal += (GetLevelByClass(CLASS_FOREST_MASTER, oCaster) + 1) * 3 / 4;

	if (GetHasFeat(FEAT_MASTER_RADIANCE_SPELLCASTING_PALADIN, oCaster))
		iPal += GetLevelByClass(CLASS_MASTER_RADIANCE, oCaster) - 1;

	if (GetHasFeat(FEAT_LION_TALISID_SPELLCASTING_PALADIN, oCaster))
		iPal += GetLevelByClass(CLASS_LION_TALISID, oCaster);

	if (GetHasFeat(FEAT_STORMSINGER_SPELLCASTING_PALADIN, oCaster))
		iPal += GetLevelByClass(CLASS_STORMSINGER, oCaster);

	if (GetHasFeat(FEAT_BFZ_SPELLCASTING_PALADIN, oCaster))
		iPal += GetLevelByClass(CLASS_BLACK_FLAME_ZEALOT, oCaster) / 2;

	if (GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_PALADIN, oCaster))
	{
		int iLevel = GetLevelByClass(CLASS_HOSPITALER, oCaster);
		iPal += GetPrestigeCasterLevel(CLASS_HOSPITALER, iLevel, oCaster);
	}

	if (GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_PALADIN, oCaster))
		iPal += GetLevelByClass(CLASS_SHINING_BLADE, oCaster) / 2;

	if (GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_PALADIN, oCaster))
		iPal += (GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster) + 1) * 3 / 4;

	if (GetHasFeat(FEAT_HARPER_SPELLCASTING_PALADIN, oCaster))
		iPal += GetLevelByClass(CLASS_TYPE_HARPER, oCaster) - 1;

	if (GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_PALADIN, oCaster))
		iPal += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster) / 2;

	if (GetHasFeat(FEAT_STORMLORD_SPELLCASTING_PALADIN, oCaster))
		iPal += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster);

	if (GetHasFeat(FEAT_DOOMGUIDE_PALADIN_SPELLCASTING, oCaster))
		iPal += GetLevelByClass(CLASS_TYPE_DOOMGUIDE, oCaster);

	int iHD = GetHitDice(oCaster);
	if (iHD > iPal)
	{
		if (GetHasFeat(FEAT_PRACTICED_SPELLCASTER_PALADIN, oCaster))
			iPal += 4;

		if (iPal > iHD) iPal = iHD;

		return iPal;
	}

	return iHD; // Full Paladin
}

// private.
int GetRangerCasterLevel(object oCaster)
{
	int iRan = GetLevelByClass(CLASS_TYPE_RANGER, oCaster);

	if (GetHasFeat(FEAT_NATWAR_SPELLCASTING_RANGER, oCaster))
		iRan += GetLevelByClass(CLASS_NATURES_WARRIOR, oCaster) / 2;

	if (GetHasFeat(FEAT_DSHAPE_SPELLCASTING_RANGER, oCaster))
		iRan += GetLevelByClass(CLASS_DAGGERSPELL_SHAPER, oCaster) - 1;

	if (GetHasFeat(FEAT_CHLDNIGHT_SPELLCASTING_RANGER, oCaster))
		iRan += GetLevelByClass(CLASS_CHILD_NIGHT, oCaster) - 1;

	if (GetHasFeat(FEAT_SWRDNCR_SPELLCASTING_RANGER, oCaster))
		iRan += GetLevelByClass(CLASS_SWORD_DANCER, oCaster);

	if (GetHasFeat(FEAT_DRSLR_SPELLCASTING_RANGER, oCaster))
		iRan += (GetLevelByClass(CLASS_DRAGONSLAYER, oCaster) + 1) / 2;

	if (GetHasFeat(FEAT_ELDDISC_SPELLCASTING_RANGER, oCaster))
		iRan += GetLevelByClass(CLASS_ELDRITCH_DISCIPLE, oCaster);

	if (GetHasFeat(FEAT_KOT_SPELLCASTING_RANGER, oCaster))
		iRan += GetLevelByClass(CLASS_KNIGHT_TIERDRIAL, oCaster);

	if (GetHasFeat(FEAT_SHDWSTLKR_SPELLCASTING_RANGER, oCaster))
		iRan += (GetLevelByClass(CLASS_SHADOWBANE_STALKER, oCaster) + 1) * 3 / 4;

	if (GetHasFeat(FEAT_FROSTMAGE_SPELLCASTING_RANGER, oCaster))
		iRan += GetLevelByClass(CLASS_FROST_MAGE, oCaster);

	if (GetHasFeat(FEAT_CANAITH_SPELLCASTING_RANGER, oCaster))
		iRan += GetLevelByClass(CLASS_CANAITH_LYRIST, oCaster);

	if (GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_RANGER, oCaster))
		iRan += GetLevelByClass(CLASS_HEARTWARDER, oCaster);

	if (GetHasFeat(FEAT_FOREST_MASTER_SPELLCASTING_RANGER, oCaster))
		iRan += (GetLevelByClass(CLASS_FOREST_MASTER, oCaster) + 1) * 3 / 4;

	if (GetHasFeat(FEAT_MASTER_RADIANCE_SPELLCASTING_RANGER, oCaster))
		iRan += GetLevelByClass(CLASS_MASTER_RADIANCE, oCaster) - 1;

	if (GetHasFeat(FEAT_LION_TALISID_SPELLCASTING_RANGER, oCaster))
		iRan += GetLevelByClass(CLASS_LION_TALISID, oCaster);

	if (GetHasFeat(FEAT_STORMSINGER_SPELLCASTING_RANGER, oCaster))
		iRan += GetLevelByClass(CLASS_STORMSINGER, oCaster);

	if (GetHasFeat(FEAT_BFZ_SPELLCASTING_RANGER, oCaster))
		iRan += GetLevelByClass(CLASS_BLACK_FLAME_ZEALOT, oCaster) / 2;

	if (GetHasFeat(FEAT_HOSPITALER_SPELLCASTING_RANGER, oCaster))
	{
		int iLevel = GetLevelByClass(CLASS_HOSPITALER, oCaster);
		iRan += GetPrestigeCasterLevel(CLASS_HOSPITALER, iLevel, oCaster);
	}

	if (GetHasFeat(FEAT_SHINING_BLADE_SPELLCASTING_RANGER, oCaster))
		iRan += GetLevelByClass(CLASS_SHINING_BLADE, oCaster) / 2;

	if (GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_RANGER, oCaster))
		iRan += (GetLevelByClass(CLASS_TYPE_SACREDFIST, oCaster) + 1) * 3 / 4;

	if (GetHasFeat(FEAT_HARPER_SPELLCASTING_RANGER, oCaster))
		iRan += GetLevelByClass(CLASS_TYPE_HARPER, oCaster) - 1;

	if (GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_RANGER, oCaster))
		iRan += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster) / 2;

	if (GetHasFeat(FEAT_STORMLORD_SPELLCASTING_RANGER, oCaster))
		iRan += GetLevelByClass(CLASS_TYPE_STORMLORD, oCaster);

	if (GetHasFeat(FEAT_DOOMGUIDE_RANGER_SPELLCASTING, oCaster))
		iRan += GetLevelByClass(CLASS_TYPE_DOOMGUIDE, oCaster);

	int iHD = GetHitDice(oCaster);
	if (iHD > iRan)
	{
		if (GetHasFeat(FEAT_PRACTICED_SPELLCASTER_RANGER, oCaster))
			iRan += 4;

		if (iRan > iHD) iRan = iHD;

		return iRan;
	}

	return iHD; // Full Ranger
}

// private.
int GetPrestigeCasterLevel(int iClass, int iClassLevel, object oTarget)
{
	switch (iClass)
	{
		case CLASS_BLACK_FLAME_ZEALOT:
			return iClassLevel / 2;

		case CLASS_FOREST_MASTER:	// 1,2,3,5,6,7,9,10
		case CLASS_TYPE_SACREDFIST:
		case CLASS_SHADOWBANE_STALKER:
			return (iClassLevel + 1) * 3 / 4;

		case CLASS_SWIFTBLADE:		// 2,3,5,6,8,9
			if (iClassLevel <  4)	return iClassLevel - 1;
			if (iClassLevel <  7)	return iClassLevel - 2;
			if (iClassLevel < 10)	return iClassLevel - 3;

			return iClassLevel - 4;

		case CLASS_HOSPITALER:		// 2,3,4,6,7,8,10
		{
			if (iClassLevel < 5)	return iClassLevel - 1;
			if (iClassLevel < 9)	return iClassLevel - 2;

			return iClassLevel - 3;
		}
	}

	return 0;
}


// public.
object GetTargetWeapon(int iWeapType = WEAPTYPE_ALL)
{
	object oTarget = GetSpellTargetObject();
	if (GetIsObjectValid(oTarget))
	{
		switch (GetObjectType(oTarget))
		{
			case OBJECT_TYPE_CREATURE:
			{
				object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
				if (!GetIsObjectValid(oWeapon) || !isWeaponType(oWeapon, iWeapType))
				{
					oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
					if (!GetIsObjectValid(oWeapon) || !isWeaponType(oWeapon, iWeapType)) // NOTE: lefthand won't have a Ranged weapontype.
					{
						switch (iWeapType)
						{
							case WEAPTYPE_ALL:
							case WEAPTYPE_MEL:
							{
								oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget); // creature bite
								if (!GetIsObjectValid(oWeapon))
								{
									oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget); // creature right
									if (!GetIsObjectValid(oWeapon))
									{
										oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget); // creature left
										if (!GetIsObjectValid(oWeapon))
											oWeapon = GetItemInSlot(INVENTORY_SLOT_ARMS, oTarget);
									}
								}
								break;
							}

							case WEAPTYPE_RAN:
								oWeapon = OBJECT_INVALID;
						}
					}
				}
				return oWeapon; // can be OBJECT_INVALID.
			}

			case OBJECT_TYPE_ITEM:
				if (isWeaponType(oTarget, iWeapType))
					return oTarget;
		}
	}

	return OBJECT_INVALID;
}

// public.
object GetTargetArmor(int iArmorType = ARMTYPE_ALL)
{
	object oTarget = GetSpellTargetObject();
	if (GetIsObjectValid(oTarget))
	{
		switch (GetObjectType(oTarget))
		{
			case OBJECT_TYPE_CREATURE:
			{
				object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
				if (!GetIsObjectValid(oArmor) || iArmorType == ARMTYPE_SHD) // assumes all chest-items are Armor.
				{
					oArmor = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
					if (!GetIsObjectValid(oArmor) || iArmorType == ARMTYPE_ARM || !isShield(oArmor))
						oArmor = OBJECT_INVALID;
				}
				return oArmor; // can be OBJECT_INVALID.
			}

			case OBJECT_TYPE_ITEM:
				if (isArmorType(oTarget, iArmorType))
					return oTarget;
		}
	}

	return OBJECT_INVALID;
}

// public.
// TODO: Use GetTargetArmor(ARMTYPE_SHD).
object GetTargetShield()
{
	object oTarget = GetSpellTargetObject();
	if (GetIsObjectValid(oTarget))
	{
		switch (GetObjectType(oTarget))
		{
			case OBJECT_TYPE_CREATURE:
				oTarget = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
				if (!GetIsObjectValid(oTarget))
					break;
				// no break;

			case OBJECT_TYPE_ITEM:
				if (isShield(oTarget))
					return oTarget;
		}
	}

	return OBJECT_INVALID;
}

// private.
int isWeaponType(object oWeapon, int iWeapType)
{
	switch (iWeapType)
	{
		case WEAPTYPE_ALL:
			if (isRanged(oWeapon) || isMelee(oWeapon))
				return TRUE;
			break;

		case WEAPTYPE_MEL:
			if (isMelee(oWeapon))
				return TRUE;
			break;

		case WEAPTYPE_RAN:
			if (isRanged(oWeapon))
				return TRUE;
	}

	return FALSE;
}

// private.
int isArmorType(object oArmor, int iArmorType)
{
	switch (iArmorType)
	{
		case ARMTYPE_ALL:
			if (isArmor(oArmor) || isShield(oArmor))
				return TRUE;
			break;

		case ARMTYPE_ARM:
			if (isArmor(oArmor))
				return TRUE;
			break;

		case ARMTYPE_SHD:
			if (isShield(oArmor))
				return TRUE;
	}

	return FALSE;
}

// NOTE: When referencing .2da's to check for "" it's a good idea to check
// instead for (int)0 - people will put "****" when they mean "0" and "0" when
// they mean "****". Not to mention "0x*".

// private.
// Note that creature-slot items have 0 DieToRoll. Could use WeaponType instead
// ( which should really be named DamageType ) except that there are items that
// have WeaponType set but their DieToRoll is 0 - like gloves and fishing rods.
//
// So use "DieToRoll" and ponder the inner workings of creature-slot attacks.
int isMelee(object oItem)
{
	int iType = GetBaseItemType(oItem);
	return StringToInt(Get2DAString(BASEITEMS, "DieToRoll", iType)) != 0
		&& StringToInt(Get2DAString(BASEITEMS, "RangedWeapon", iType)) == 0; // isRanged()=FALSE.
}

// private.
// Note there is a stock function: int GetWeaponRanged(object oItem);
// TODO: Think through any required differences between hand-held self-loaded
// weapons like darts/shurikens/throwing-axes and hand-held ranged weapons
// like shortbow/longbow/light x-bow/heavy x-bow/slings.
int isRanged(object oItem)
{
	int iType = GetBaseItemType(oItem);
	return StringToInt(Get2DAString(BASEITEMS, "RangedWeapon", iType)) != 0;
}

// private.
int isArmor(object oItem)
{
	int iType = GetBaseItemType(oItem);
	string sSlots = Get2DAString(BASEITEMS, "EquipableSlots", iType);
	int iSlots = kL_HexStringToInt(sSlots);
	if (iSlots != -1) return (iSlots & 2); // 0x2 (2) is chest-slot.

	return FALSE;
}

// private.
int isShield(object oItem)
{
	int iType = GetBaseItemType(oItem);
	if (StringToInt(Get2DAString(BASEITEMS, "BaseAC", iType)) != 0)
	{
		string sSlots = Get2DAString(BASEITEMS, "EquipableSlots", iType);
		int iSlots = kL_HexStringToInt(sSlots);
		if (iSlots != -1) return (iSlots & 32); // 0x20 (32) is lefthand-slot.
	}

	return FALSE;
}


// Converts a hexadecimal string to a decimal value.
// Based on HexStringToInt() in 'ginc_math'.
// @note -1 if sHexString is not valid hex (0-aA)
// @note can convert both "0x*" and "*" where "*" is a hexadecimal value
int kL_HexStringToInt(string sHexString)
{
	int iRet = 0;

	int iLength = GetStringLength(sHexString);
	if (iLength != 0)
	{
		int i = 0;

		if (iLength > 1 && GetSubString(sHexString, 0, 2) == "0x")
			i = 2;

		int iDigit;
		while (i != iLength)
		{
			iDigit = kL_GetHexStringDigitValue(GetSubString(sHexString, i, 1));
			switch (iDigit)
			{
				case -1: return -1;
				default:
					iRet = (iRet << 4) | iDigit; // who's the clever nut who figured that out.
			}
			++i;
		}
	}

	return iRet;
}

// Gets the decimal value of a hexadecimal digit.
// Based on GetHexStringDigitValue() in 'ginc_math'.
// @note -1 if sHexDigit is not valid hex (0-aA)
int kL_GetHexStringDigitValue(string sHexDigit)
{
	int iVal = CharToASCII(sHexDigit);
	switch (iVal)
	{
		case  48: // 0-9 [0x30-0x39]
		case  49:
		case  50:
		case  51:
		case  52:
		case  53:
		case  54:
		case  55:
		case  56:
		case  57:
			return iVal - 48;

		case  65: // A-F [0x41-0x46]
		case  66:
		case  67:
		case  68:
		case  69:
		case  70:
			return iVal - 55;

		case  97: // a-f [0x61-0x66]
		case  98:
		case  99:
		case 100:
		case 101:
		case 102:
			return iVal - 87;
	}

	return -1;
}


// public.
void ClearEnergizedEffects(object oTarget)
{
	if (   GetHasSpellEffect(SPELL_Lesser_Energized_Shield, oTarget)
		|| GetHasSpellEffect(SPELL_Energized_Shield, oTarget))
	{
		effect eEffect = GetFirstEffect(oTarget);
		while (GetIsEffectValid(eEffect))
		{
			switch (GetEffectSpellId(eEffect))
			{
				case SPELL_Lesser_Energized_Shield:
				case SPELL_Energized_Shield:
					RemoveEffect(oTarget, eEffect);
					eEffect = GetFirstEffect(oTarget);
					break;

				default:
					eEffect = GetNextEffect(oTarget);
			}
		}
	}
}

// public.
effect CreateEnergizedEffect(int iType, int bLesser = FALSE)
{
	int iBonus, iResist, iSpellId;
	if (bLesser)
	{
		iBonus = DAMAGE_BONUS_1d4; // note: .Tlk descriptions say 1d6 ...
		iResist = 5;
		iSpellId = SPELL_Lesser_Energized_Shield;
	}
	else
	{
		iBonus = DAMAGE_BONUS_2d4; // note: .Tlk descriptions say 2d6 ...
		iResist = 10;
		iSpellId = SPELL_Energized_Shield;
	}

	effect eShield	= EffectDamageShield(0, iBonus, iType);
	effect eResist	= EffectDamageResistance(iType, iResist);
	effect eVis		= EffectVisualEffect(VFX_DUR_SHINING_SHIELD);
	eShield			= EffectLinkEffects(eShield, eResist);
	eShield			= EffectLinkEffects(eShield, eVis);

	return SetEffectSpellId(eShield, iSpellId);
}
