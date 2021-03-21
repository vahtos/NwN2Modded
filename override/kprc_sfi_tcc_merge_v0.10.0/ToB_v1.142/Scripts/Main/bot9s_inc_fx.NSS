//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 4/16/2009							//
//	Title: bot9s_inc_fx						//
//	Description: Functions used to determine//
//	sound and visual effects.				//
//////////////////////////////////////////////

	/* As of yet there is an issue with the visual effects editor accurately 
	allowing trail effects (.tfx) to be attached to non-nodes.  Thus, while the 
	trail effects seen in the visual effects editor are good reproductions of
	the effects used by the combat engine, any custom content .tfx and .sef
	which attempts to reproduce them will only appear as an effect attached to
	the hands rather than the weapon.  I've spent much more time than I would
	have liked attemtping to resolve this issue (more than I should have given
	its actual importance), even crashing the game on more than one occassion
	searching for a better workaround.  It is my conclusion that there is no
	coding in the toolset, visual effects editor, or the game itself, that will
	allow a trail effect to be attached to a weapon.  As such, I use particle
	meshes, which fortunetaly can be attached to an invisible weapon model.
	The routing system below determines the shape of that model. */

#include "bot9s_inc_constants"
#include "bot9s_include"

// Sound Type Constants

const int SOUND_TYPE_INVALID	=	0;
const int SOUND_TYPE_BLADE		=	1;
const int SOUND_TYPE_BLUNT		=	2;
const int SOUND_TYPE_METAL		=	3;
const int SOUND_TYPE_WOOD		=	4;
const int SOUND_TYPE_RANGED		=	5;
const int SOUND_TYPE_DAGGER		=	6;
const int SOUND_TYPE_WHIP		=	7;

// Trail Categories

const int TRAIL_TYPE_1HSS		=	1;
const int TRAIL_TYPE_1HMR		=	2;
const int TRAIL_TYPE_BLADE		=	3;
const int TRAIL_TYPE_2AXE		=	4;
const int TRAIL_TYPE_MACE		=	5;
const int TRAIL_TYPE_SCYTH		=	6;
const int TRAIL_TYPE_SPEAR		=	7;

// Trail Effect Constants

const int TRAIL_UNA_ACID_LH		=	2201;
const int TRAIL_UNA_ACID_RH		=	2202;
const int TRAIL_UNA_CRIT_LH		=	2203;
const int TRAIL_UNA_CRIT_RH		=	2204;
const int TRAIL_UNA_ELEC_LH		=	2205;
const int TRAIL_UNA_ELEC_RH		=	2206;
const int TRAIL_UNA_FIRE_LH		=	2207;
const int TRAIL_UNA_FIRE_RH		=	2208;
const int TRAIL_UNA_ICE_LH		=	2209;
const int TRAIL_UNA_ICE_RH		=	2210;
const int TRAIL_UNA_HOLY_LH		=	2211;
const int TRAIL_UNA_HOLY_RH		=	2212;
const int TRAIL_UNA_NEGA_LH		=	2213;
const int TRAIL_UNA_NEGA_RH		=	2214;
const int TRAIL_UNA_SONIC_LH	=	2215;
const int TRAIL_UNA_SONIC_RH	=	2216;
const int TRAIL_UNA_DEFAULT_LH	=	2217;
const int TRAIL_UNA_DEFAULT_RH	=	2218;
const int TRAIL_1HSS_ACID_LH	=	2219;
const int TRAIL_1HSS_ACID_RH	=	2220;
const int TRAIL_1HSS_CRIT_LH	=	2221;
const int TRAIL_1HSS_CRIT_RH	=	2222;
const int TRAIL_1HSS_ELEC_LH	=	2223;
const int TRAIL_1HSS_ELEC_RH	=	2224;
const int TRAIL_1HSS_FIRE_LH	=	2225;
const int TRAIL_1HSS_FIRE_RH	=	2226;
const int TRAIL_1HSS_ICE_LH		=	2227;
const int TRAIL_1HSS_ICE_RH		=	2228;
const int TRAIL_1HSS_NEGA_LH	=	2229;
const int TRAIL_1HSS_NEGA_RH	=	2230;
const int TRAIL_1HSS_DEFAULT_LH	=	2231;
const int TRAIL_1HSS_DEFAULT_RH	=	2232;
const int TRAIL_1HSS_HOLY_LH	=	2233;
const int TRAIL_1HSS_HOLY_RH	=	2234;
const int TRAIL_1HSS_SONIC_LH	=	2235;
const int TRAIL_1HSS_SONIC_RH	=	2236;
const int TRAIL_1HMR_ACID_LH	=	2237;
const int TRAIL_1HMR_ACID_RH	=	2238;
const int TRAIL_1HMR_CRIT_LH	=	2239;
const int TRAIL_1HMR_CRIT_RH	=	2240;
const int TRAIL_1HMR_ELEC_LH	=	2241;
const int TRAIL_1HMR_ELEC_RH	=	2242;
const int TRAIL_1HMR_FIRE_LH	=	2243;
const int TRAIL_1HMR_FIRE_RH	=	2244;
const int TRAIL_1HMR_ICE_LH		=	2245;
const int TRAIL_1HMR_ICE_RH		=	2246;
const int TRAIL_1HMR_NEGA_LH	=	2247;
const int TRAIL_1HMR_NEGA_RH	=	2248;
const int TRAIL_1HMR_DEFAULT_LH	=	2249;
const int TRAIL_1HMR_DEFAULT_RH	=	2250;
const int TRAIL_1HMR_HOLY_LH	=	2251;
const int TRAIL_1HMR_HOLY_RH	=	2252;
const int TRAIL_1HMR_SONIC_LH	=	2253;
const int TRAIL_1HMR_SONIC_RH	=	2254;
const int TRAIL_BLADE_ACID_LH	=	2255;
const int TRAIL_BLADE_ACID_RH	=	2256;
const int TRAIL_BLADE_CRIT_LH	=	2257;
const int TRAIL_BLADE_CRIT_RH	=	2258;
const int TRAIL_BLADE_ELEC_LH	=	2259;
const int TRAIL_BLADE_ELEC_RH	=	2260;
const int TRAIL_BLADE_FIRE_LH	=	2261;
const int TRAIL_BLADE_FIRE_RH	=	2262;
const int TRAIL_BLADE_ICE_LH	=	2263;
const int TRAIL_BLADE_ICE_RH	=	2264;
const int TRAIL_BLADE_NEGA_LH	=	2265;
const int TRAIL_BLADE_NEGA_RH	=	2266;
const int TRAIL_BLADE_DEFAULT_LH=	2267;
const int TRAIL_BLADE_DEFAULT_RH=	2268;
const int TRAIL_BLADE_HOLY_LH	=	2269;
const int TRAIL_BLADE_HOLY_RH	=	2270;
const int TRAIL_BLADE_SONIC_LH	=	2271;
const int TRAIL_BLADE_SONIC_RH	=	2272;
const int TRAIL_2AXE_ACID_RH	=	2273;
const int TRAIL_2AXE_CRIT_RH	=	2274;
const int TRAIL_2AXE_ELEC_RH	=	2275;
const int TRAIL_2AXE_FIRE_RH	=	2276;
const int TRAIL_2AXE_ICE_RH		=	2277;
const int TRAIL_2AXE_NEGA_RH	=	2278;
const int TRAIL_2AXE_DEFAULT_RH	=	2279;
const int TRAIL_2AXE_HOLY_RH	=	2280;
const int TRAIL_2AXE_SONIC_RH	=	2281;
const int TRAIL_MACE_ACID_RH	=	2282;
const int TRAIL_MACE_CRIT_RH	=	2283;
const int TRAIL_MACE_ELEC_RH	=	2284;
const int TRAIL_MACE_FIRE_RH	=	2285;
const int TRAIL_MACE_ICE_RH		=	2286;
const int TRAIL_MACE_NEGA_RH	=	2287;
const int TRAIL_MACE_DEFAULT_RH	=	2288;
const int TRAIL_MACE_HOLY_RH	=	2289;
const int TRAIL_MACE_SONIC_RH	=	2290;
const int TRAIL_SCYTH_ACID_RH	=	2291;
const int TRAIL_SCYTH_CRIT_RH	=	2292;
const int TRAIL_SCYTH_ELEC_RH	=	2293;
const int TRAIL_SCYTH_FIRE_RH	=	2294;
const int TRAIL_SCYTH_ICE_RH	=	2295;
const int TRAIL_SCYTH_NEGA_RH	=	2296;
const int TRAIL_SCYTH_DEFAULT_RH=	2297;
const int TRAIL_SCYTH_HOLY_RH	=	2298;
const int TRAIL_SCYTH_SONIC_RH	=	2299;
const int TRAIL_SPEAR_ACID_RH	=	2300;
const int TRAIL_SPEAR_CRIT_RH	=	2301;
const int TRAIL_SPEAR_ELEC_RH	=	2302;
const int TRAIL_SPEAR_FIRE_RH	=	2303;
const int TRAIL_SPEAR_ICE_RH	=	2304;
const int TRAIL_SPEAR_NEGA_RH	=	2305;
const int TRAIL_SPEAR_DEFAULT_RH=	2306;
const int TRAIL_SPEAR_HOLY_RH	=	2307;
const int TRAIL_SPEAR_SONIC_RH	=	2308;

// Prototypes

// Returns an interger for oWeapon coresponding to the sound type it makes.
int GetWeaponSoundType(object oWeapon);

// Returns the material sound of oWeapon if GetWeaponSoundType returns SOUND_TYPE_BLUNT.
int GetBluntWeaponSound(object oWeapon);

// Plays an OnHit sound corresponding to the appropriate item property.
// Unlike weapon damage sounds these can be played simultaneously.
// -oWeapon: The item we're getting properties from.
// -oFoe: Deterimines where the sound will be played.
void StrikeItemPropSound(object oWeapon, object oFoe);

// Returns the string of the name of a creature that produces a sound effect.  This is a workaround for PlaySound
// since that function will not work while anything is on the action queue.  The creatures are invisible, when 
// created, play a sound associated with their name, and then destroy themselves without anyone ever being the 
// wiser.  Just like good little ninjas.
// -oWeapon: Weapon in right or left hand.
// -oTarget: What the target wears when it is hit determines the type of sound that returns.
// -nHit: Either a miss, hit, or critical hit. 0, 1, or 2.
string SoundNinja(object oWeapon, object oTarget, int nHit);

// Returns the visual effect of the strike connecting with the target.
// -oWeapon: Used to determine which item property effects will influence the hit.
// -nHit: Only valid for 1 and 2; hit and critical hit.
// -oFoe: Our target, to which it is assumed we are attacking.
void StrikeVFXDamage(object oWeapon, int nHit, object oFoe, object oPC = OBJECT_SELF);

// Returns the appropriate trail effect for the properties of oWeapon.
// Also overrides item visuals in the event of a critical hit (nHit == 2).
// These effects do not stack, so if there is more than one elemental property
// on an item, the last property will be the trail effect for the strike.
// -fExtend: Amount of time to extend the effect by.  Standard is 1.33 seconds.
void StrikeTrailEffect(object oWeapon, int nHit, float fExtend = 0.0f, object oPC = OBJECT_SELF);

// Functions

// Returns an interger for oWeapon coresponding to the sound type it makes.
int GetWeaponSoundType(object oWeapon)
{
	int nWeapon = GetBaseItemType(oWeapon);
	int nSound;
	
	switch (nWeapon)
	{
		case BASE_ITEM_ALLUSE_SWORD:	nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_BASTARDSWORD:	nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_BASTARDSWORD_R:	nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_BATTLEAXE:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_BATTLEAXE_R:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_DOUBLEAXE:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_DWARVENWARAXE:	nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_DWARVENWARAXE_R:	nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_FALCHION:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_FALCHION_R:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_GREATAXE:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_GREATAXE_R:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_GREATSWORD:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_GREATSWORD_R:	nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_HALBERD:			nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_HALBERD_R:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_HANDAXE:			nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_HANDAXE_R:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_KAMA:			nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_KAMA_R:			nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_KATANA:			nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_KATANA_R:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_LONGSWORD:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_LONGSWORD_R:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_RAPIER:			nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_RAPIER_R:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_SCIMITAR:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_SCIMITAR_R:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_SCYTHE:			nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_SCYTHE_R:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_SHORTSPEAR:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_SHORTSWORD:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_SHORTSWORD_R:	nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_SICKLE:			nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_SICKLE_R:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_SPEAR:			nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_SPEAR_R:			nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_TWOBLADEDSWORD:	nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_CLUB:			nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_CLUB_R:			nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_DIREMACE:		nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_GREATCLUB:		nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_GREATCLUB_R:		nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_LIGHTHAMMER:		nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_LIGHTHAMMER_R:	nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_LIGHTMACE:		nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_MACE:			nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_MACE_R:			nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_MAGICROD:		nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_MAGICSTAFF:		nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_MAGICSTAFF_R:	nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_MORNINGSTAR:		nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_MORNINGSTAR_R:	nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_QUARTERSTAFF:	nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_QUARTERSTAFF_R:	nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_TRAINING_CLUB:	nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_TRAINING_CLUB_R:	nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_WARHAMMER:		nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_WARHAMMER_R:		nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_WARMACE:			nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_WARMACE_R:		nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_DART:			nSound = SOUND_TYPE_RANGED;	break;
		case BASE_ITEM_GRENADE:			nSound = SOUND_TYPE_RANGED;	break;
		case BASE_ITEM_HEAVYCROSSBOW:	nSound = SOUND_TYPE_RANGED;	break;
		case BASE_ITEM_LIGHTCROSSBOW:	nSound = SOUND_TYPE_RANGED;	break;
		case BASE_ITEM_LONGBOW:			nSound = SOUND_TYPE_RANGED;	break;
		case BASE_ITEM_SHORTBOW:		nSound = SOUND_TYPE_RANGED;	break;
		case BASE_ITEM_SHURIKEN:		nSound = SOUND_TYPE_RANGED;	break;
		case BASE_ITEM_SLING:			nSound = SOUND_TYPE_RANGED;	break;
		case BASE_ITEM_THROWINGAXE:		nSound = SOUND_TYPE_RANGED;	break;
		case BASE_ITEM_DAGGER:			nSound = SOUND_TYPE_DAGGER;	break;
		case BASE_ITEM_DAGGER_R:		nSound = SOUND_TYPE_DAGGER;	break;
		case BASE_ITEM_KUKRI:			nSound = SOUND_TYPE_DAGGER;	break;
		case BASE_ITEM_KUKRI_R:			nSound = SOUND_TYPE_DAGGER;	break;
		case BASE_ITEM_WHIP:			nSound = SOUND_TYPE_WHIP;	break; //Just in case anyone ever adds them, the sound file does actually exist.
		case BASE_ITEM_WHIP_R:			nSound = SOUND_TYPE_WHIP;	break;
		default:						nSound = SOUND_TYPE_INVALID;break;
	}
	
	return nSound;
}

// Returns the material sound of oWeapon if GetWeaponSoundType returns SOUND_TYPE_BLUNT.
int GetBluntWeaponSound(object oWeapon)
{
	int nWeapon = GetBaseItemType(oWeapon);
	int nSound;
	
	switch (nWeapon)
	{
		case BASE_ITEM_DIREMACE:		nSound = SOUND_TYPE_METAL;	break;
		case BASE_ITEM_LIGHTHAMMER:		nSound = SOUND_TYPE_METAL;	break;
		case BASE_ITEM_LIGHTHAMMER_R:	nSound = SOUND_TYPE_METAL;	break;
		case BASE_ITEM_LIGHTMACE:		nSound = SOUND_TYPE_METAL;	break;
		case BASE_ITEM_MACE:			nSound = SOUND_TYPE_METAL;	break;
		case BASE_ITEM_MACE_R:			nSound = SOUND_TYPE_METAL;	break;
		case BASE_ITEM_MAGICROD:		nSound = SOUND_TYPE_METAL;	break;
		case BASE_ITEM_MORNINGSTAR:		nSound = SOUND_TYPE_METAL;	break;
		case BASE_ITEM_MORNINGSTAR_R:	nSound = SOUND_TYPE_METAL;	break;
		case BASE_ITEM_WARHAMMER:		nSound = SOUND_TYPE_METAL;	break;
		case BASE_ITEM_WARHAMMER_R:		nSound = SOUND_TYPE_METAL;	break;
		case BASE_ITEM_WARMACE:			nSound = SOUND_TYPE_METAL;	break;
		case BASE_ITEM_WARMACE_R:		nSound = SOUND_TYPE_METAL;	break;
		case BASE_ITEM_CLUB:			nSound = SOUND_TYPE_WOOD;	break;
		case BASE_ITEM_CLUB_R:			nSound = SOUND_TYPE_WOOD;	break;
		case BASE_ITEM_GREATCLUB:		nSound = SOUND_TYPE_WOOD;	break;
		case BASE_ITEM_GREATCLUB_R:		nSound = SOUND_TYPE_WOOD;	break;
		case BASE_ITEM_MAGICSTAFF:		nSound = SOUND_TYPE_WOOD;	break;
		case BASE_ITEM_MAGICSTAFF_R:	nSound = SOUND_TYPE_WOOD;	break;
		case BASE_ITEM_QUARTERSTAFF:	nSound = SOUND_TYPE_WOOD;	break;
		case BASE_ITEM_QUARTERSTAFF_R:	nSound = SOUND_TYPE_WOOD;	break;
		case BASE_ITEM_TRAINING_CLUB:	nSound = SOUND_TYPE_WOOD;	break;
		case BASE_ITEM_TRAINING_CLUB_R:	nSound = SOUND_TYPE_WOOD;	break;
		default:						nSound = SOUND_TYPE_INVALID;break;
	}
	
	return nSound;
}

// Plays an OnHit sound corresponding to the appropriate item property.
// Unlike weapon damage sounds these can be played simultaneously.
// -oWeapon: The item we're getting properties from.
// -oFoe: Deterimines where the sound will be played.
void StrikeItemPropSound(object oWeapon, object oFoe)
{
	object oPC = OBJECT_SELF;
	location lFoe = GetLocation(oFoe);
	itemproperty iProp = GetFirstItemProperty(oWeapon);
	
	while (GetIsItemPropertyValid(iProp))
	{
		if (GetItemPropertyType(iProp) == ITEM_PROPERTY_DAMAGE_BONUS)
		{	
			switch (GetItemPropertySubType(iProp))
			{
				case IP_CONST_DAMAGETYPE_ACID:			WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_acid", lFoe); break;
				case IP_CONST_DAMAGETYPE_COLD:			WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_cold", lFoe); break;
				case IP_CONST_DAMAGETYPE_DIVINE:		WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_holy", lFoe); break;
				case IP_CONST_DAMAGETYPE_ELECTRICAL:	WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_elec", lFoe); break;
				case IP_CONST_DAMAGETYPE_FIRE:			WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_fire", lFoe); break;							
				case IP_CONST_DAMAGETYPE_NEGATIVE:		WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_DAMAGETYPE_POSITIVE:		WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_holy", lFoe); break;
				case IP_CONST_DAMAGETYPE_SONIC:			WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_holy", lFoe); break;
			}
		}		
/*		else if (GetItemPropertyType(iProp) == ITEM_PROPERTY_ON_HIT_PROPERTIES) //Commented out until I can make these sounds only active when the effect beats the DC.
		{
			switch (GetItemPropertySubType(iProp))
			{
				case IP_CONST_ONHIT_ABILITYDRAIN:		WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_ONHIT_BLINDNESS:			WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_ONHIT_CONFUSION:			WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_ONHIT_DAZE:				WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_ONHIT_DEAFNESS:			WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_ONHIT_DISEASE:			WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_acid", lFoe); break;
				case IP_CONST_ONHIT_DISPELMAGIC:		WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dis", lFoe);  break;
				case IP_CONST_ONHIT_DOOM:				WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_ONHIT_FEAR:				WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_ONHIT_GREATERDISPEL:		WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dis", lFoe);  break;
				case IP_CONST_ONHIT_HOLD:				WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_ONHIT_ITEMPOISON:			WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_acid", lFoe); break;
				case IP_CONST_ONHIT_KNOCK:				WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dis", lFoe);  break;
				case IP_CONST_ONHIT_LESSERDISPEL:		WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dis", lFoe);	 break;
				case IP_CONST_ONHIT_LEVELDRAIN:			WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_ONHIT_MORDSDISJUNCTION:	WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dis", lFoe);  break;
				case IP_CONST_ONHIT_SILENCE:			WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_ONHIT_SLEEP:				WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_ONHIT_SLOW:				WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_ONHIT_STUN:				WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_ONHIT_VORPAL:				WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_ONHIT_WOUNDING:			WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
			}
		}*/
		
		if (GetItemPropertyType(iProp) == ITEM_PROPERTY_HOLY_AVENGER)
		{
			WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_holy", lFoe);
		}

		if (GetItemPropertyType(iProp) == ITEM_PROPERTY_REGENERATION_VAMPIRIC)
		{
		 	WrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); 
		}

		iProp = GetNextItemProperty(oWeapon);
	}
}

// Returns the string of the name of a creature that produces a sound effect.  This is a workaround for PlaySound
// since that function will not work while anything is on the action queue.  The creatures are invisible, when 
// created, play a sound associated with their name, and then destroy themselves without anyone ever being the 
// wiser.  Just like good little ninjas.
// -oWeapon: Weapon in right or left hand.
// -oTarget: What the target wears when it is hit determines the type of sound that returns.
// -nHit: Either a miss, hit, or critical hit. 0, 1, or 2.
string SoundNinja(object oWeapon, object oTarget, int nHit)
{
	string sNinja; // Value to return.
	int nWeapon = GetBaseItemType(oWeapon);
	int nSoundCategory = GetWeaponSoundType(oWeapon);
	int nWooden = GetBluntWeaponSound(oWeapon);
	int nFoe = GetObjectType(oTarget);
	int nFoeSkin = GetSubRace(oTarget);
	int nFoeArmor = GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget));

	if (nHit == 2)
	{
		sNinja = "c_soundfx_crit";
	}
	else if (nHit == 0)
	{
		if (nWeapon == BASE_ITEM_FLAIL)
		{
			sNinja = "c_soundfx_missflail";
		}
		else if (nWeapon == BASE_ITEM_HEAVYFLAIL)
		{
			sNinja = "c_soundfx_missflail";
		}
		else if (nWeapon == BASE_ITEM_LIGHTFLAIL)
		{
			sNinja = "c_soundfx_missflail";
		}
		else if (nWeapon == BASE_ITEM_WHIP)
		{
			sNinja = "c_soundfx_misswhip";
		}
		else if (nSoundCategory == SOUND_TYPE_BLADE)
		{
			sNinja = "c_soundfx_missbld";
		}
		else if (nSoundCategory == SOUND_TYPE_BLUNT)
		{	
			if (nWooden == SOUND_TYPE_WOOD)
			{
				sNinja = "c_soundfx_misswood";
			}
			else sNinja = "c_soundfx_missblnt";
		}
		else if (nSoundCategory == SOUND_TYPE_RANGED)
		{
			if (nWeapon == BASE_ITEM_HEAVYCROSSBOW)
			{
				sNinja = "c_soundfx_missxbow";
			}
			else if (nWeapon == BASE_ITEM_LIGHTCROSSBOW)
			{
				sNinja = "c_soundfx_missxbow";
			}
			else sNinja = "c_soundfx_missbow";
		}
		else if (nSoundCategory == SOUND_TYPE_DAGGER)
		{
			sNinja = "c_soundfx_missdgr";
		}
		else sNinja = "c_soundfx_missua";
	}
	else if (nHit == 1)
	{	
		if (nFoe != OBJECT_TYPE_CREATURE)
		{
			if (nSoundCategory != SOUND_TYPE_BLUNT)
			{
				switch (nSoundCategory)
				{
					case SOUND_TYPE_BLADE:	sNinja = "c_soundfx_bld2st";	break;
					case SOUND_TYPE_DAGGER:	sNinja = "c_soundfx_d2st";		break;
					case SOUND_TYPE_RANGED: sNinja = "c_soundfx_arrow";		break;
					case SOUND_TYPE_WHIP:	sNinja = "c_soundfx_wp2st";		break;
					case SOUND_TYPE_INVALID:sNinja = "c_soundfx_f2st";		break;
				}
			}
			else if (nSoundCategory == SOUND_TYPE_BLUNT)
			{
				if (nWooden == SOUND_TYPE_WOOD)
				{
					sNinja = "c_soundfx_w2st";
				}
				else sNinja = "c_soundfx_m2st";
			}
		}
		else if (nFoeSkin == RACIAL_SUBTYPE_OOZE || nFoeSkin == RACIAL_SUBTYPE_INCORPOREAL)
		{
			sNinja = "c_soundfx_eth";
		}
		else if (nFoeSkin == RACIAL_SUBTYPE_DRAGON || nFoeSkin == RACIAL_SUBTYPE_HUMANOID_REPTILIAN || nFoeSkin == RACIAL_SUBTYPE_YUANTI)
		{
			sNinja = "c_soundfx_f2sc";
		}
		else if (nFoeSkin == RACIAL_SUBTYPE_PLANT)
		{
			if (nSoundCategory != SOUND_TYPE_BLUNT)
			{
				switch (nSoundCategory)
				{
					case SOUND_TYPE_BLADE:	sNinja = "c_soundfx_bld2w";		break;
					case SOUND_TYPE_DAGGER:	sNinja = "c_soundfx_d2w";		break;
					case SOUND_TYPE_RANGED: sNinja = "c_soundfx_arrow";		break;
					case SOUND_TYPE_WHIP:	sNinja = "c_soundfx_wp2w";		break;
					case SOUND_TYPE_INVALID:sNinja = "c_soundfx_f2w";		break;
				}
			}
			else if (nSoundCategory == SOUND_TYPE_BLUNT)
			{
				if (nWooden == SOUND_TYPE_WOOD)
				{
					sNinja = "c_soundfx_w2w";
				}
				else sNinja = "c_soundfx_m2w";
			}
		}
		else if (nFoeSkin == RACIAL_SUBTYPE_CONSTRUCT)
		{
			if (nSoundCategory != SOUND_TYPE_BLUNT)
			{
				switch (nSoundCategory)
				{
					case SOUND_TYPE_BLADE:	sNinja = "c_soundfx_bld2st";	break;
					case SOUND_TYPE_DAGGER:	sNinja = "c_soundfx_d2st";		break;
					case SOUND_TYPE_RANGED: sNinja = "c_soundfx_arrow";		break;
					case SOUND_TYPE_WHIP:	sNinja = "c_soundfx_wp2st";		break;
					case SOUND_TYPE_INVALID:sNinja = "c_soundfx_f2st";		break;
				}
			}
			else if (nSoundCategory == SOUND_TYPE_BLUNT)
			{
				if (nWooden == SOUND_TYPE_WOOD)
				{
					sNinja = "c_soundfx_w2st";
				}
				else sNinja = "c_soundfx_m2st";
			}
		}
		else if (nFoeArmor == ARMOR_RANK_LIGHT)
		{
			if (nSoundCategory != SOUND_TYPE_BLUNT)
			{
				switch (nSoundCategory)
				{
					case SOUND_TYPE_BLADE:	sNinja = "c_soundfx_bld2l";		break;
					case SOUND_TYPE_DAGGER:	sNinja = "c_soundfx_d2l";		break;
					case SOUND_TYPE_RANGED: sNinja = "c_soundfx_arrow";		break;
					case SOUND_TYPE_WHIP:	sNinja = "c_soundfx_wp2l";		break;
					case SOUND_TYPE_INVALID:sNinja = "c_soundfx_f2l";		break;
				}
			}
			else if (nSoundCategory == SOUND_TYPE_BLUNT)
			{
				if (nWooden == SOUND_TYPE_WOOD)
				{
					sNinja = "c_soundfx_w2l";
				}
				else sNinja = "c_soundfx_m2l";
			}
		}
		else if (nFoeArmor == ARMOR_RANK_MEDIUM)
		{
			if (nSoundCategory != SOUND_TYPE_BLUNT)
			{
				switch (nSoundCategory)
				{
					case SOUND_TYPE_BLADE:	sNinja = "c_soundfx_bld2ch";	break;
					case SOUND_TYPE_DAGGER:	sNinja = "c_soundfx_d2ch";		break;
					case SOUND_TYPE_RANGED: sNinja = "c_soundfx_arrow";		break;
					case SOUND_TYPE_WHIP:	sNinja = "c_soundfx_wp2ch";		break;
					case SOUND_TYPE_INVALID:sNinja = "c_soundfx_f2ch";		break;
				}
			}
			else if (nSoundCategory == SOUND_TYPE_BLUNT)
			{
				if (nWooden == SOUND_TYPE_WOOD)
				{
					sNinja = "c_soundfx_w2ch";
				}
				else sNinja = "c_soundfx_m2ch";
			}
		}
		else if (nFoeArmor == ARMOR_RANK_HEAVY)
		{
			if (nSoundCategory != SOUND_TYPE_BLUNT)
			{
				switch (nSoundCategory)
				{
					case SOUND_TYPE_BLADE:	sNinja = "c_soundfx_bld2p";		break;
					case SOUND_TYPE_DAGGER:	sNinja = "c_soundfx_d2p";		break;
					case SOUND_TYPE_RANGED: sNinja = "c_soundfx_arrow";		break;
					case SOUND_TYPE_WHIP:	sNinja = "c_soundfx_wp2p";		break;
					case SOUND_TYPE_INVALID:sNinja = "c_soundfx_f2p";		break;
				}
			}
			else if (nSoundCategory == SOUND_TYPE_BLUNT)
			{
				if (nWooden == SOUND_TYPE_WOOD)
				{
					sNinja = "c_soundfx_w2p";
				}
				else sNinja = "c_soundfx_m2p";
			}
		}
		else if (nFoeArmor == ARMOR_RANK_NONE)
		{
			if (nSoundCategory != SOUND_TYPE_BLUNT)
			{
				switch (nSoundCategory)
				{
					case SOUND_TYPE_BLADE:	sNinja = "c_soundfx_bld2l";		break;
					case SOUND_TYPE_DAGGER:	sNinja = "c_soundfx_d2l";		break;
					case SOUND_TYPE_RANGED: sNinja = "c_soundfx_arrow";		break;
					case SOUND_TYPE_WHIP:	sNinja = "c_soundfx_wp2l";		break;
					case SOUND_TYPE_INVALID:sNinja = "c_soundfx_f2l";		break;
				}
			}
			else if (nSoundCategory == SOUND_TYPE_BLUNT)
			{
				if (nWooden == SOUND_TYPE_WOOD)
				{
					sNinja = "c_soundfx_w2l";
				}
				else sNinja = "c_soundfx_m2l";
			}
		}
	}

	return sNinja;
}

// Returns the visual effect of the strike connecting with the target.
// -oWeapon: Used to determine which item property effects will influence the hit.
// -nHit: Only valid for 1 and 2; hit and critical hit.
// -oFoe: Our target, to which it is assumed we are attacking.
void StrikeVFXDamage(object oWeapon, int nHit, object oFoe, object oPC = OBJECT_SELF)
{
	int nArrowFx = DAMAGE_TYPE_SONIC;
	effect eAcid, eCold, eHoly, eElec, eFire, eDark, eSonic;
	effect eLink;

	effect eEffect = GetFirstEffect(oPC);
	while (GetIsEffectValid(eEffect))
	{
		int nType = GetEffectType(eEffect);
		if (nType == EFFECT_TYPE_DAMAGE_INCREASE)
		{
			switch (GetEffectInteger(eEffect, 1))  //DamageType
			{
				case DAMAGE_TYPE_ACID:			eAcid = EffectVisualEffect(VFX_HIT_SPELL_ACID);		nArrowFx = DAMAGE_TYPE_ACID;		break;		
				case DAMAGE_TYPE_COLD:			eCold = EffectVisualEffect(VFX_HIT_SPELL_ICE);		nArrowFx = DAMAGE_TYPE_COLD;		break;
				case DAMAGE_TYPE_DIVINE:		eHoly = EffectVisualEffect(VFX_HIT_SPELL_HOLY);		nArrowFx = DAMAGE_TYPE_DIVINE;		break;
				case DAMAGE_TYPE_ELECTRICAL:	eElec = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);nArrowFx = DAMAGE_TYPE_ELECTRICAL;	break;
				case DAMAGE_TYPE_FIRE:			eFire = EffectVisualEffect(VFX_HIT_SPELL_FIRE);		nArrowFx = DAMAGE_TYPE_FIRE;		break;
				case DAMAGE_TYPE_NEGATIVE:		eDark = EffectVisualEffect(VFX_HIT_SPELL_EVIL);		nArrowFx = DAMAGE_TYPE_SONIC;		break;
				case DAMAGE_TYPE_POSITIVE:		eHoly = EffectVisualEffect(VFX_HIT_SPELL_HOLY);		nArrowFx = DAMAGE_TYPE_DIVINE;		break;
				case DAMAGE_TYPE_SONIC:			eSonic = EffectVisualEffect(VFX_HIT_SPELL_SONIC);	nArrowFx = DAMAGE_TYPE_SONIC;		break;
			}											
		}
		eEffect = GetNextEffect(oPC);
	}

	itemproperty eVis;
	eVis = GetFirstItemProperty(oWeapon);

	while (GetIsItemPropertyValid(eVis))
	{
		if (GetItemPropertyType(eVis) == ITEM_PROPERTY_DAMAGE_BONUS)
		{	
			switch (GetItemPropertySubType(eVis))
			{
				case IP_CONST_DAMAGETYPE_ACID:			eAcid = EffectVisualEffect(VFX_HIT_SPELL_ACID);		nArrowFx = DAMAGE_TYPE_ACID;		break;
				case IP_CONST_DAMAGETYPE_COLD:			eCold = EffectVisualEffect(VFX_HIT_SPELL_ICE);		nArrowFx = DAMAGE_TYPE_COLD;		break;
				case IP_CONST_DAMAGETYPE_DIVINE:		eHoly = EffectVisualEffect(VFX_HIT_SPELL_HOLY);		nArrowFx = DAMAGE_TYPE_DIVINE;		break;
				case IP_CONST_DAMAGETYPE_ELECTRICAL:	eElec = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);nArrowFx = DAMAGE_TYPE_ELECTRICAL;	break;
				case IP_CONST_DAMAGETYPE_FIRE:			eFire = EffectVisualEffect(VFX_HIT_SPELL_FIRE);		nArrowFx = DAMAGE_TYPE_FIRE;		break;
				case IP_CONST_DAMAGETYPE_NEGATIVE:		eDark = EffectVisualEffect(VFX_HIT_SPELL_EVIL);		nArrowFx = DAMAGE_TYPE_SONIC;		break;
				case IP_CONST_DAMAGETYPE_POSITIVE:		eHoly = EffectVisualEffect(VFX_HIT_SPELL_HOLY);		nArrowFx = DAMAGE_TYPE_DIVINE;		break;
				case IP_CONST_DAMAGETYPE_SONIC:			eSonic = EffectVisualEffect(VFX_HIT_SPELL_SONIC);	nArrowFx = DAMAGE_TYPE_SONIC;		break;
			}
		}
		else if (GetItemPropertyType(eVis) == ITEM_PROPERTY_VISUALEFFECT)
		{	
			switch (GetItemPropertySubType(eVis))
			{
				case ITEM_VISUAL_ACID:			eAcid = EffectVisualEffect(VFX_HIT_SPELL_ACID);		nArrowFx = DAMAGE_TYPE_ACID;		break;
				case ITEM_VISUAL_COLD:			eCold = EffectVisualEffect(VFX_HIT_SPELL_ICE);		nArrowFx = DAMAGE_TYPE_COLD;		break;
				case ITEM_VISUAL_HOLY:			eHoly = EffectVisualEffect(VFX_HIT_SPELL_HOLY);		nArrowFx = DAMAGE_TYPE_DIVINE;		break;
				case ITEM_VISUAL_ELECTRICAL:	eElec = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);nArrowFx = DAMAGE_TYPE_ELECTRICAL;	break;
				case ITEM_VISUAL_FIRE:			eFire = EffectVisualEffect(VFX_HIT_SPELL_FIRE);		nArrowFx = DAMAGE_TYPE_FIRE;		break;
				case ITEM_VISUAL_EVIL:			eDark = EffectVisualEffect(VFX_HIT_SPELL_EVIL);		nArrowFx = DAMAGE_TYPE_SONIC;		break;
				case ITEM_VISUAL_SONIC:			eSonic = EffectVisualEffect(VFX_HIT_SPELL_SONIC);	nArrowFx = DAMAGE_TYPE_SONIC;		break;
			}
		}
		eVis = GetNextItemProperty(oWeapon);
	}

	if (nHit == 1)
	{
		effect eStandard = EffectNWN2SpecialEffectFile("fx_hit_spark_stand", oFoe);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eStandard, oFoe);
	
		eLink = EffectLinkEffects(eCold, eAcid);
		eLink = EffectLinkEffects(eLink, eHoly);
		eLink = EffectLinkEffects(eLink, eElec);
		eLink = EffectLinkEffects(eLink, eFire);
		eLink = EffectLinkEffects(eLink, eDark);
		eLink = EffectLinkEffects(eLink, eSonic);

		if ((GetSneakLevels(oPC) > 0) && (IsTargetValidForSneakAttack(oFoe, oPC) == TRUE))
		{
			effect eSneak = EffectNWN2SpecialEffectFile("fx_hit_spark_sneak", oFoe);
			eLink = EffectLinkEffects(eLink, eSneak);
		}

		if (GetWeaponRanged(oWeapon))
		{
			int nWeapon = GetBaseItemType(oWeapon);
			location lPC = GetLocation(oPC);
			location lFoe = GetLocation(oFoe);
			float fArrow = GetProjectileTravelTime(lPC, lFoe, PROJECTILE_PATH_TYPE_DEFAULT);
			
			SpawnItemProjectile(oPC, oFoe, lPC, lFoe, nWeapon, PROJECTILE_PATH_TYPE_DEFAULT, OVERRIDE_ATTACK_RESULT_HIT_SUCCESSFUL, nArrowFx);
			DelayCommand(fArrow, SpawnBloodHit(oFoe, FALSE, oPC));
		}
		else SpawnBloodHit(oFoe, FALSE, oPC);
	}
	else if (nHit == 2)
	{
		effect eCrit = EffectNWN2SpecialEffectFile("fx_hit_spark_crit", oFoe);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eCrit, oFoe);
		
		eLink = EffectLinkEffects(eCold, eAcid); // If none of these effects are valid no other linked effects will run.
		eLink = EffectLinkEffects(eLink, eHoly);
		eLink = EffectLinkEffects(eLink, eElec);
		eLink = EffectLinkEffects(eLink, eFire);
		eLink = EffectLinkEffects(eLink, eDark);
		eLink = EffectLinkEffects(eLink, eSonic);

		if ((GetSneakLevels(oPC) > 0) && (IsTargetValidForSneakAttack(oFoe, oPC) == TRUE))
		{
			effect eSneak = EffectNWN2SpecialEffectFile("fx_hit_spark_sneak", oFoe);
			eLink = EffectLinkEffects(eLink, eSneak);
		}

		if (GetWeaponRanged(oWeapon))
		{
			int nWeapon = GetBaseItemType(oWeapon);
			location lPC = GetLocation(oPC);
			location lFoe = GetLocation(oFoe);
			float fArrow = GetProjectileTravelTime(lPC, lFoe, PROJECTILE_PATH_TYPE_DEFAULT);
			
			SpawnItemProjectile(oPC, oFoe, lPC, lFoe, nWeapon, PROJECTILE_PATH_TYPE_DEFAULT, OVERRIDE_ATTACK_RESULT_CRITICAL_HIT, nArrowFx);
			DelayCommand(fArrow, SpawnBloodHit(oFoe, TRUE, oPC));
		}
		else SpawnBloodHit(oFoe, TRUE, oPC);
	}
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oFoe);
}

// Returns the appropriate trail effect for the properties of oWeapon.
// Also overrides item visuals in the event of a critical hit (nHit == 2).
// These effects do not stack, so if there is more than one elemental property
// on an item, the last property will be the trail effect for the strike.
// -fExtend: Amount of time to extend the effect by.  Standard is 1.33 seconds.
void StrikeTrailEffect(object oWeapon, int nHit, float fExtend = 0.0f, object oPC = OBJECT_SELF)
{
	if (!GetIsObjectValid(oWeapon)) //Unarmed effects.
	{
		object oArms = GetItemInSlot(INVENTORY_SLOT_ARMS);
		effect eReturn;
		effect eLeft;

		if (nHit == 2)
		{
			eReturn = EffectNWN2SpecialEffectFile("rh_trail_crit", oPC);
			eLeft = EffectNWN2SpecialEffectFile("lh_trail_crit", oPC);
		}
		else if (GetItemHasItemProperty(oArms, ITEM_PROPERTY_HOLY_AVENGER))
		{
			eReturn = EffectNWN2SpecialEffectFile("rh_trail_holy", oPC);
			eLeft = EffectNWN2SpecialEffectFile("lh_trail_holy", oPC);
		}
		else if (GetItemHasItemProperty(oArms, ITEM_PROPERTY_REGENERATION_VAMPIRIC))
		{
			eReturn = EffectNWN2SpecialEffectFile("rh_trail_neg", oPC);
			eLeft = EffectNWN2SpecialEffectFile("lh_trail_neg", oPC);
		}
		else if (GetItemHasItemProperty(oArms, ITEM_PROPERTY_DAMAGE_BONUS) || GetItemHasItemProperty(oArms, ITEM_PROPERTY_VISUALEFFECT))
		{
			itemproperty iArms;
			iArms = GetFirstItemProperty(oArms);

			while (GetIsItemPropertyValid(iArms))
			{
				if (GetItemPropertyType(iArms) == ITEM_PROPERTY_DAMAGE_BONUS)
				{	
					switch (GetItemPropertySubType(iArms))
					{
						case IP_CONST_DAMAGETYPE_ACID:			eReturn = EffectNWN2SpecialEffectFile("rh_trail_acid", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_acid", oPC);	break;
						case IP_CONST_DAMAGETYPE_COLD:			eReturn = EffectNWN2SpecialEffectFile("rh_trail_frost", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_frost", oPC);	break;
						case IP_CONST_DAMAGETYPE_DIVINE:		eReturn = EffectNWN2SpecialEffectFile("rh_trail_holy", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_holy", oPC);	break;
						case IP_CONST_DAMAGETYPE_ELECTRICAL:	eReturn = EffectNWN2SpecialEffectFile("rh_trail_elect", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_elect", oPC);	break;
						case IP_CONST_DAMAGETYPE_FIRE:			eReturn = EffectNWN2SpecialEffectFile("rh_trail_fire", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_fire", oPC);	break;
						case IP_CONST_DAMAGETYPE_NEGATIVE:		eReturn = EffectNWN2SpecialEffectFile("rh_trail_neg", oPC);		eLeft = EffectNWN2SpecialEffectFile("lh_trail_neg", oPC);	break;
						case IP_CONST_DAMAGETYPE_POSITIVE:		eReturn = EffectNWN2SpecialEffectFile("rh_trail_holy", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_holy", oPC);	break;
						case IP_CONST_DAMAGETYPE_SONIC:			eReturn = EffectNWN2SpecialEffectFile("rh_trail_sonic", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_sonic", oPC);	break;
					}
				}
				else if (GetItemPropertyType(iArms) == ITEM_PROPERTY_VISUALEFFECT)
				{	
					switch (GetItemPropertySubType(iArms))
					{
						case ITEM_VISUAL_ACID:			eReturn = EffectNWN2SpecialEffectFile("rh_trail_acid", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_acid", oPC);	break;
						case ITEM_VISUAL_COLD:			eReturn = EffectNWN2SpecialEffectFile("rh_trail_frost", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_frost", oPC);	break;
						case ITEM_VISUAL_HOLY:			eReturn = EffectNWN2SpecialEffectFile("rh_trail_holy", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_holy", oPC);	break;
						case ITEM_VISUAL_ELECTRICAL:	eReturn = EffectNWN2SpecialEffectFile("rh_trail_elect", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_elect", oPC);	break;
						case ITEM_VISUAL_FIRE:			eReturn = EffectNWN2SpecialEffectFile("rh_trail_fire", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_fire", oPC);	break;
						case ITEM_VISUAL_EVIL:			eReturn = EffectNWN2SpecialEffectFile("rh_trail_neg", oPC);		eLeft = EffectNWN2SpecialEffectFile("lh_trail_neg", oPC);	break;
						case ITEM_VISUAL_SONIC:			eReturn = EffectNWN2SpecialEffectFile("rh_trail_sonic", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_sonic", oPC);	break;
					}
				}
				iArms = GetNextItemProperty(oArms);
			}
		}
		else
		{
			eReturn = EffectNWN2SpecialEffectFile("rh_trail_standard", oPC);
			eLeft = EffectNWN2SpecialEffectFile("lh_trail_standard", oPC);
		}

		effect eVis;

		eVis = GetFirstEffect(oPC);

		if (nHit == 2)
		{
			eReturn = EffectNWN2SpecialEffectFile("rh_trail_crit", oPC);
			eLeft = EffectNWN2SpecialEffectFile("lh_trail_crit", oPC);
		}
		else if (GetIsEffectValid(eVis))
		{
			while (GetIsEffectValid(eVis))
			{
				if (GetEffectType(eVis) == EFFECT_TYPE_DAMAGE_INCREASE)
				{	
					switch (GetEffectInteger(eVis, 1))  //DamageType
					{
						case DAMAGE_TYPE_ACID:			eReturn = EffectNWN2SpecialEffectFile("rh_trail_acid", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_acid", oPC);	break;
						case DAMAGE_TYPE_COLD:			eReturn = EffectNWN2SpecialEffectFile("rh_trail_frost", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_frost", oPC);	break;
						case DAMAGE_TYPE_DIVINE:		eReturn = EffectNWN2SpecialEffectFile("rh_trail_holy", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_holy", oPC);	break;
						case DAMAGE_TYPE_ELECTRICAL:	eReturn = EffectNWN2SpecialEffectFile("rh_trail_elect", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_elect", oPC);	break;
						case DAMAGE_TYPE_FIRE:			eReturn = EffectNWN2SpecialEffectFile("rh_trail_fire", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_fire", oPC);	break;
						case DAMAGE_TYPE_NEGATIVE:		eReturn = EffectNWN2SpecialEffectFile("rh_trail_neg", oPC);		eLeft = EffectNWN2SpecialEffectFile("lh_trail_neg", oPC);	break;
						case DAMAGE_TYPE_POSITIVE:		eReturn = EffectNWN2SpecialEffectFile("rh_trail_holy", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_holy", oPC);	break;
						case DAMAGE_TYPE_SONIC:			eReturn = EffectNWN2SpecialEffectFile("rh_trail_sonic", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_sonic", oPC);	break;
					}
				}
				eVis = GetNextEffect(oPC);
			}
		}
		else
		{
			eReturn = EffectNWN2SpecialEffectFile("rh_trail_standard", oPC);
			eLeft = EffectNWN2SpecialEffectFile("lh_trail_standard", oPC);
		}

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eReturn, oPC, 0.3f);
		DelayCommand(0.2f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLeft, oPC, 0.3f)); //The second hand usually attacks a little after the first.
	}
	else
	{
		int nVis;

		if (nHit == 2)
		{
			nVis = DAMAGE_TYPE_MAGICAL; //Placeholder for crit visual.
		}
		else if (GetLocalInt(oPC, "BurningBrand") == 1)
		{
			nVis = DAMAGE_TYPE_FIRE;
		}
		else if (GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_HOLY_AVENGER))
		{
			nVis = DAMAGE_TYPE_DIVINE;
		}
		else if (GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_REGENERATION_VAMPIRIC))
		{
			nVis = DAMAGE_TYPE_NEGATIVE;
		}
		else if (GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_DAMAGE_BONUS) || GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_VISUALEFFECT))
		{
			itemproperty iWeapon;
			iWeapon = GetFirstItemProperty(oWeapon);
	
			while (GetIsItemPropertyValid(iWeapon))
			{
				if (GetItemPropertyType(iWeapon) == ITEM_PROPERTY_DAMAGE_BONUS)
				{	
					switch (GetItemPropertySubType(iWeapon))
					{
						case IP_CONST_DAMAGETYPE_ACID:			nVis = DAMAGE_TYPE_ACID;		break;
						case IP_CONST_DAMAGETYPE_COLD:			nVis = DAMAGE_TYPE_COLD;		break;
						case IP_CONST_DAMAGETYPE_DIVINE:		nVis = DAMAGE_TYPE_DIVINE;		break;
						case IP_CONST_DAMAGETYPE_ELECTRICAL:	nVis = DAMAGE_TYPE_ELECTRICAL;	break;
						case IP_CONST_DAMAGETYPE_FIRE:			nVis = DAMAGE_TYPE_FIRE;		break;
						case IP_CONST_DAMAGETYPE_NEGATIVE:		nVis = DAMAGE_TYPE_NEGATIVE;	break;
						case IP_CONST_DAMAGETYPE_POSITIVE:		nVis = DAMAGE_TYPE_DIVINE;		break;
						case IP_CONST_DAMAGETYPE_SONIC:			nVis = DAMAGE_TYPE_SONIC;		break;
					}
				}
				else if (GetItemPropertyType(iWeapon) == ITEM_PROPERTY_VISUALEFFECT)
				{	
					switch (GetItemPropertySubType(iWeapon))
					{
						case ITEM_VISUAL_ACID:			nVis = DAMAGE_TYPE_ACID;		break;
						case ITEM_VISUAL_COLD:			nVis = DAMAGE_TYPE_COLD;		break;
						case ITEM_VISUAL_HOLY:			nVis = DAMAGE_TYPE_DIVINE;		break;
						case ITEM_VISUAL_ELECTRICAL:	nVis = DAMAGE_TYPE_ELECTRICAL;	break;
						case ITEM_VISUAL_FIRE:			nVis = DAMAGE_TYPE_FIRE;		break;
						case ITEM_VISUAL_EVIL:			nVis = DAMAGE_TYPE_NEGATIVE;	break;
						case ITEM_VISUAL_SONIC:			nVis = DAMAGE_TYPE_SONIC;		break;
					}
				}
				iWeapon = GetNextItemProperty(oWeapon);
			}
		}
		else nVis = DAMAGE_TYPE_ALL; // Placeholder for normal trail effects.

		effect eElement;

		eElement = GetFirstEffect(oPC);

		if (nHit == 2)
		{
			nVis = DAMAGE_TYPE_MAGICAL; //Placeholder for crit visual.
		}
		else if (GetLocalInt(oPC, "BurningBrand") == 1)
		{
			nVis = DAMAGE_TYPE_FIRE;
		}
		else if (GetIsEffectValid(eElement))
		{
			while (GetIsEffectValid(eElement))
			{
				if (GetEffectType(eElement) == EFFECT_TYPE_DAMAGE_INCREASE)
				{	
					switch (GetEffectInteger(eElement, 1))  //DamageType
					{
						case DAMAGE_TYPE_ACID:			nVis = DAMAGE_TYPE_ACID;		break;
						case DAMAGE_TYPE_COLD:			nVis = DAMAGE_TYPE_COLD;		break;
						case DAMAGE_TYPE_DIVINE:		nVis = DAMAGE_TYPE_DIVINE;		break;
						case DAMAGE_TYPE_ELECTRICAL:	nVis = DAMAGE_TYPE_ELECTRICAL;	break;
						case DAMAGE_TYPE_FIRE:			nVis = DAMAGE_TYPE_FIRE;		break;
						case DAMAGE_TYPE_NEGATIVE:		nVis = DAMAGE_TYPE_NEGATIVE;	break;
						case DAMAGE_TYPE_POSITIVE:		nVis = DAMAGE_TYPE_DIVINE;		break;
						case DAMAGE_TYPE_SONIC:			nVis = DAMAGE_TYPE_SONIC;		break;
					}
				}
				eElement = GetNextEffect(oPC);
			}
		}
		else nVis = DAMAGE_TYPE_ALL; // Placeholder for normal trail effects.

		int nWeapon = GetBaseItemType(oWeapon);
		int nTrail;

		if (nWeapon == BASE_ITEM_SHORTSWORD || nWeapon == BASE_ITEM_SHORTSWORD_R
		|| nWeapon == BASE_ITEM_DAGGER || nWeapon == BASE_ITEM_DAGGER_R
		|| nWeapon == BASE_ITEM_HANDAXE || nWeapon == BASE_ITEM_HANDAXE_R || nWeapon == BASE_ITEM_KAMA_R
		|| nWeapon == BASE_ITEM_KAMA || nWeapon == BASE_ITEM_KUKRI || nWeapon == BASE_ITEM_KUKRI_R
		|| nWeapon == BASE_ITEM_SICKLE || nWeapon == BASE_ITEM_SICKLE_R || nWeapon == BASE_ITEM_LIGHTHAMMER_R
		|| nWeapon == BASE_ITEM_LIGHTHAMMER || nWeapon == BASE_ITEM_LIGHTFLAIL || nWeapon == BASE_ITEM_LIGHTFLAIL_R)
		{
			nTrail = TRAIL_TYPE_1HSS;
		}
		else if (nWeapon == BASE_ITEM_SCYTHE || nWeapon == BASE_ITEM_SCYTHE_R)
		{
			nTrail = TRAIL_TYPE_SCYTH;
		}
		else if (nWeapon == BASE_ITEM_WARMACE || nWeapon == BASE_ITEM_WARMACE_R
		|| nWeapon == BASE_ITEM_GREATCLUB || nWeapon == BASE_ITEM_GREATCLUB_R)
		{
			nTrail = TRAIL_TYPE_MACE;
		}
		else if (nWeapon == BASE_ITEM_BATTLEAXE || nWeapon == BASE_ITEM_BATTLEAXE_R
		|| nWeapon == BASE_ITEM_GREATAXE || nWeapon == BASE_ITEM_GREATAXE_R)
		{
			nTrail = TRAIL_TYPE_2AXE;
		}
		else if (nWeapon == BASE_ITEM_DWARVENWARAXE || nWeapon == BASE_ITEM_DWARVENWARAXE_R
		|| nWeapon == BASE_ITEM_FLAIL || nWeapon == BASE_ITEM_FLAIL_R 
		|| nWeapon == BASE_ITEM_WARHAMMER || nWeapon == BASE_ITEM_WARHAMMER_R)
		{
			nTrail = TRAIL_TYPE_1HMR;
		}
		else if (nWeapon == BASE_ITEM_SPEAR || nWeapon == BASE_ITEM_SPEAR_R
		|| nWeapon == BASE_ITEM_QUARTERSTAFF || nWeapon == BASE_ITEM_QUARTERSTAFF_R
		|| nWeapon == BASE_ITEM_MAGICSTAFF || nWeapon == BASE_ITEM_MAGICSTAFF_R
		|| nWeapon == BASE_ITEM_HALBERD || nWeapon == BASE_ITEM_HALBERD_R)
		{
			nTrail = TRAIL_TYPE_SPEAR;
		}
		else if (!GetWeaponRanged(oWeapon))
		{
			nTrail = TRAIL_TYPE_BLADE;
		}

		effect eVis;

		if (oWeapon == GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC))
		{
			if (nTrail == TRAIL_TYPE_BLADE)
			{
				switch (nVis)
				{
					case DAMAGE_TYPE_ALL:		eVis = EffectVisualEffect(TRAIL_BLADE_DEFAULT_LH);	break;
					case DAMAGE_TYPE_MAGICAL:	eVis = EffectVisualEffect(TRAIL_BLADE_CRIT_LH);		break;
					case DAMAGE_TYPE_ACID:		eVis = EffectVisualEffect(TRAIL_BLADE_ACID_LH);		break;
					case DAMAGE_TYPE_COLD:		eVis = EffectVisualEffect(TRAIL_BLADE_ICE_LH);		break;
					case DAMAGE_TYPE_DIVINE:	eVis = EffectVisualEffect(TRAIL_BLADE_HOLY_LH);		break;
					case DAMAGE_TYPE_ELECTRICAL:eVis = EffectVisualEffect(TRAIL_BLADE_ELEC_LH);		break;
					case DAMAGE_TYPE_FIRE:		eVis = EffectVisualEffect(TRAIL_BLADE_FIRE_LH);		break;
					case DAMAGE_TYPE_NEGATIVE:	eVis = EffectVisualEffect(TRAIL_BLADE_NEGA_LH);		break;
					case DAMAGE_TYPE_SONIC:		eVis = EffectVisualEffect(TRAIL_BLADE_SONIC_LH);	break;
				}
			}
			else if (nTrail == TRAIL_TYPE_1HSS)
			{
				switch (nVis)
				{
					case DAMAGE_TYPE_ALL:		eVis = EffectVisualEffect(TRAIL_1HSS_DEFAULT_LH);	break;
					case DAMAGE_TYPE_MAGICAL:	eVis = EffectVisualEffect(TRAIL_1HSS_CRIT_LH);		break;
					case DAMAGE_TYPE_ACID:		eVis = EffectVisualEffect(TRAIL_1HSS_ACID_LH);		break;
					case DAMAGE_TYPE_COLD:		eVis = EffectVisualEffect(TRAIL_1HSS_ICE_LH);		break;
					case DAMAGE_TYPE_DIVINE:	eVis = EffectVisualEffect(TRAIL_1HSS_HOLY_LH);		break;
					case DAMAGE_TYPE_ELECTRICAL:eVis = EffectVisualEffect(TRAIL_1HSS_ELEC_LH);		break;
					case DAMAGE_TYPE_FIRE:		eVis = EffectVisualEffect(TRAIL_1HSS_FIRE_LH);		break;
					case DAMAGE_TYPE_NEGATIVE:	eVis = EffectVisualEffect(TRAIL_1HSS_NEGA_LH);		break;
					case DAMAGE_TYPE_SONIC:		eVis = EffectVisualEffect(TRAIL_1HSS_SONIC_LH);		break;
				}
			}
			else if (nTrail == TRAIL_TYPE_1HMR)
			{
				switch (nVis)
				{
					case DAMAGE_TYPE_ALL:		eVis = EffectVisualEffect(TRAIL_1HMR_DEFAULT_LH);	break;
					case DAMAGE_TYPE_MAGICAL:	eVis = EffectVisualEffect(TRAIL_1HMR_CRIT_LH);		break;
					case DAMAGE_TYPE_ACID:		eVis = EffectVisualEffect(TRAIL_1HMR_ACID_LH);		break;
					case DAMAGE_TYPE_COLD:		eVis = EffectVisualEffect(TRAIL_1HMR_ICE_LH);		break;
					case DAMAGE_TYPE_DIVINE:	eVis = EffectVisualEffect(TRAIL_1HMR_HOLY_LH);		break;
					case DAMAGE_TYPE_ELECTRICAL:eVis = EffectVisualEffect(TRAIL_1HMR_ELEC_LH);		break;
					case DAMAGE_TYPE_FIRE:		eVis = EffectVisualEffect(TRAIL_1HMR_FIRE_LH);		break;
					case DAMAGE_TYPE_NEGATIVE:	eVis = EffectVisualEffect(TRAIL_1HMR_NEGA_LH);		break;
					case DAMAGE_TYPE_SONIC:		eVis = EffectVisualEffect(TRAIL_1HMR_SONIC_LH);		break;
				}
			}
		}
		else
		{
			if (nTrail == TRAIL_TYPE_BLADE)
			{
				switch (nVis)
				{
					case DAMAGE_TYPE_ALL:		eVis = EffectVisualEffect(TRAIL_BLADE_DEFAULT_RH);	break;
					case DAMAGE_TYPE_MAGICAL:	eVis = EffectVisualEffect(TRAIL_BLADE_CRIT_RH);		break;
					case DAMAGE_TYPE_ACID:		eVis = EffectVisualEffect(TRAIL_BLADE_ACID_RH);		break;
					case DAMAGE_TYPE_COLD:		eVis = EffectVisualEffect(TRAIL_BLADE_ICE_RH);		break;
					case DAMAGE_TYPE_DIVINE:	eVis = EffectVisualEffect(TRAIL_BLADE_HOLY_RH);		break;
					case DAMAGE_TYPE_ELECTRICAL:eVis = EffectVisualEffect(TRAIL_BLADE_ELEC_RH);		break;
					case DAMAGE_TYPE_FIRE:		eVis = EffectVisualEffect(TRAIL_BLADE_FIRE_RH);		break;
					case DAMAGE_TYPE_NEGATIVE:	eVis = EffectVisualEffect(TRAIL_BLADE_NEGA_RH);		break;
					case DAMAGE_TYPE_SONIC:		eVis = EffectVisualEffect(TRAIL_BLADE_SONIC_RH);	break;
				}
			}
			else if (nTrail == TRAIL_TYPE_1HSS)
			{
				switch (nVis)
				{
					case DAMAGE_TYPE_ALL:		eVis = EffectVisualEffect(TRAIL_1HSS_DEFAULT_RH);	break;
					case DAMAGE_TYPE_MAGICAL:	eVis = EffectVisualEffect(TRAIL_1HSS_CRIT_RH);		break;
					case DAMAGE_TYPE_ACID:		eVis = EffectVisualEffect(TRAIL_1HSS_ACID_RH);		break;
					case DAMAGE_TYPE_COLD:		eVis = EffectVisualEffect(TRAIL_1HSS_ICE_RH);		break;
					case DAMAGE_TYPE_DIVINE:	eVis = EffectVisualEffect(TRAIL_1HSS_HOLY_RH);		break;
					case DAMAGE_TYPE_ELECTRICAL:eVis = EffectVisualEffect(TRAIL_1HSS_ELEC_RH);		break;
					case DAMAGE_TYPE_FIRE:		eVis = EffectVisualEffect(TRAIL_1HSS_FIRE_RH);		break;
					case DAMAGE_TYPE_NEGATIVE:	eVis = EffectVisualEffect(TRAIL_1HSS_NEGA_RH);		break;
					case DAMAGE_TYPE_SONIC:		eVis = EffectVisualEffect(TRAIL_1HSS_SONIC_RH);		break;
				}
			}
			else if (nTrail == TRAIL_TYPE_1HMR)
			{
				switch (nVis)
				{
					case DAMAGE_TYPE_ALL:		eVis = EffectVisualEffect(TRAIL_1HMR_DEFAULT_RH);	break;
					case DAMAGE_TYPE_MAGICAL:	eVis = EffectVisualEffect(TRAIL_1HMR_CRIT_RH);		break;
					case DAMAGE_TYPE_ACID:		eVis = EffectVisualEffect(TRAIL_1HMR_ACID_RH);		break;
					case DAMAGE_TYPE_COLD:		eVis = EffectVisualEffect(TRAIL_1HMR_ICE_RH);		break;
					case DAMAGE_TYPE_DIVINE:	eVis = EffectVisualEffect(TRAIL_1HMR_HOLY_RH);		break;
					case DAMAGE_TYPE_ELECTRICAL:eVis = EffectVisualEffect(TRAIL_1HMR_ELEC_RH);		break;
					case DAMAGE_TYPE_FIRE:		eVis = EffectVisualEffect(TRAIL_1HMR_FIRE_RH);		break;
					case DAMAGE_TYPE_NEGATIVE:	eVis = EffectVisualEffect(TRAIL_1HMR_NEGA_RH);		break;
					case DAMAGE_TYPE_SONIC:		eVis = EffectVisualEffect(TRAIL_1HMR_SONIC_RH);		break;
				}
			}
			else if (nTrail == TRAIL_TYPE_SPEAR)
			{
				switch (nVis)
				{
					case DAMAGE_TYPE_ALL:		eVis = EffectVisualEffect(TRAIL_SPEAR_DEFAULT_RH);	break;
					case DAMAGE_TYPE_MAGICAL:	eVis = EffectVisualEffect(TRAIL_SPEAR_CRIT_RH);		break;
					case DAMAGE_TYPE_ACID:		eVis = EffectVisualEffect(TRAIL_SPEAR_ACID_RH);		break;
					case DAMAGE_TYPE_COLD:		eVis = EffectVisualEffect(TRAIL_SPEAR_ICE_RH);		break;
					case DAMAGE_TYPE_DIVINE:	eVis = EffectVisualEffect(TRAIL_SPEAR_HOLY_RH);		break;
					case DAMAGE_TYPE_ELECTRICAL:eVis = EffectVisualEffect(TRAIL_SPEAR_ELEC_RH);		break;
					case DAMAGE_TYPE_FIRE:		eVis = EffectVisualEffect(TRAIL_SPEAR_FIRE_RH);		break;
					case DAMAGE_TYPE_NEGATIVE:	eVis = EffectVisualEffect(TRAIL_SPEAR_NEGA_RH);		break;
					case DAMAGE_TYPE_SONIC:		eVis = EffectVisualEffect(TRAIL_SPEAR_SONIC_RH);	break;
				}
			}
			else if (nTrail == TRAIL_TYPE_2AXE)
			{
				switch (nVis)
				{
					case DAMAGE_TYPE_ALL:		eVis = EffectVisualEffect(TRAIL_2AXE_DEFAULT_RH);	break;
					case DAMAGE_TYPE_MAGICAL:	eVis = EffectVisualEffect(TRAIL_2AXE_CRIT_RH);		break;
					case DAMAGE_TYPE_ACID:		eVis = EffectVisualEffect(TRAIL_2AXE_ACID_RH);		break;
					case DAMAGE_TYPE_COLD:		eVis = EffectVisualEffect(TRAIL_2AXE_ICE_RH);		break;
					case DAMAGE_TYPE_DIVINE:	eVis = EffectVisualEffect(TRAIL_2AXE_HOLY_RH);		break;
					case DAMAGE_TYPE_ELECTRICAL:eVis = EffectVisualEffect(TRAIL_2AXE_ELEC_RH);		break;
					case DAMAGE_TYPE_FIRE:		eVis = EffectVisualEffect(TRAIL_2AXE_FIRE_RH);		break;
					case DAMAGE_TYPE_NEGATIVE:	eVis = EffectVisualEffect(TRAIL_2AXE_NEGA_RH);		break;
					case DAMAGE_TYPE_SONIC:		eVis = EffectVisualEffect(TRAIL_2AXE_SONIC_RH);		break;
				}
			}
			else if (nTrail == TRAIL_TYPE_MACE)
			{
				switch (nVis)
				{
					case DAMAGE_TYPE_ALL:		eVis = EffectVisualEffect(TRAIL_MACE_DEFAULT_RH);	break;
					case DAMAGE_TYPE_MAGICAL:	eVis = EffectVisualEffect(TRAIL_MACE_CRIT_RH);		break;
					case DAMAGE_TYPE_ACID:		eVis = EffectVisualEffect(TRAIL_MACE_ACID_RH);		break;
					case DAMAGE_TYPE_COLD:		eVis = EffectVisualEffect(TRAIL_MACE_ICE_RH);		break;
					case DAMAGE_TYPE_DIVINE:	eVis = EffectVisualEffect(TRAIL_MACE_HOLY_RH);		break;
					case DAMAGE_TYPE_ELECTRICAL:eVis = EffectVisualEffect(TRAIL_MACE_ELEC_RH);		break;
					case DAMAGE_TYPE_FIRE:		eVis = EffectVisualEffect(TRAIL_MACE_FIRE_RH);		break;
					case DAMAGE_TYPE_NEGATIVE:	eVis = EffectVisualEffect(TRAIL_MACE_NEGA_RH);		break;
					case DAMAGE_TYPE_SONIC:		eVis = EffectVisualEffect(TRAIL_MACE_SONIC_RH);		break;
				}
			}
			else if (nTrail == TRAIL_TYPE_SCYTH)
			{
				switch (nVis)
				{
					case DAMAGE_TYPE_ALL:		eVis = EffectVisualEffect(TRAIL_SCYTH_DEFAULT_RH);	break;
					case DAMAGE_TYPE_MAGICAL:	eVis = EffectVisualEffect(TRAIL_SCYTH_CRIT_RH);		break;
					case DAMAGE_TYPE_ACID:		eVis = EffectVisualEffect(TRAIL_SCYTH_ACID_RH);		break;
					case DAMAGE_TYPE_COLD:		eVis = EffectVisualEffect(TRAIL_SCYTH_ICE_RH);		break;
					case DAMAGE_TYPE_DIVINE:	eVis = EffectVisualEffect(TRAIL_SCYTH_HOLY_RH);		break;
					case DAMAGE_TYPE_ELECTRICAL:eVis = EffectVisualEffect(TRAIL_SCYTH_ELEC_RH);		break;
					case DAMAGE_TYPE_FIRE:		eVis = EffectVisualEffect(TRAIL_SCYTH_FIRE_RH);		break;
					case DAMAGE_TYPE_NEGATIVE:	eVis = EffectVisualEffect(TRAIL_SCYTH_NEGA_RH);		break;
					case DAMAGE_TYPE_SONIC:		eVis = EffectVisualEffect(TRAIL_SCYTH_SONIC_RH);	break;
				}
			}
		}
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPC, 1.33f + fExtend);
	}
}
/*
// !--Work in Progress--!
// Routes specific instances of an effect to the type of weapon that the player
// has equipped.  Used to shape the effect to the weapon model to create custom
// pseudo-trail effects.
// -nManeuver: 2da reference of the strike that we want to produce the effect of.
// -oWeapon: Used to determine the weapon model shape of the effect.
void ApplyWeaponTypeVFX(int nManeuver, object oWeapon)
{
	if (GetIsObjectValid(oWeapon))
	{
		int nWeapon = GetBaseItemType(oWeapon);
		int nTrail;

		if (nWeapon == BASE_ITEM_SHORTSWORD || nWeapon == BASE_ITEM_SHORTSWORD_R
		|| nWeapon == BASE_ITEM_DAGGER || nWeapon == BASE_ITEM_DAGGER_R
		|| nWeapon == BASE_ITEM_HANDAXE || nWeapon == BASE_ITEM_HANDAXE_R || nWeapon == BASE_ITEM_KAMA_R
		|| nWeapon == BASE_ITEM_KAMA || nWeapon == BASE_ITEM_KUKRI || nWeapon == BASE_ITEM_KUKRI_R
		|| nWeapon == BASE_ITEM_SICKLE || nWeapon == BASE_ITEM_SICKLE_R || nWeapon == BASE_ITEM_LIGHTHAMMER_R
		|| nWeapon == BASE_ITEM_LIGHTHAMMER || nWeapon == BASE_ITEM_LIGHTFLAIL || nWeapon == BASE_ITEM_LIGHTFLAIL_R)
		{
			nTrail = TRAIL_TYPE_1HSS;
		}
		else if (nWeapon == BASE_ITEM_SCYTHE || nWeapon == BASE_ITEM_SCYTHE_R)
		{
			nTrail = TRAIL_TYPE_SCYTH;
		}
		else if (nWeapon == BASE_ITEM_WARMACE || nWeapon == BASE_ITEM_WARMACE_R
		|| nWeapon == BASE_ITEM_GREATCLUB || nWeapon == BASE_ITEM_GREATCLUB_R)
		{
			nTrail = TRAIL_TYPE_MACE;
		}
		else if (nWeapon == BASE_ITEM_BATTLEAXE || nWeapon == BASE_ITEM_BATTLEAXE_R
		|| nWeapon == BASE_ITEM_GREATAXE || nWeapon == BASE_ITEM_GREATAXE_R)
		{
			nTrail = TRAIL_TYPE_2AXE;
		}
		else if (nWeapon == BASE_ITEM_DWARVENWARAXE || nWeapon == BASE_ITEM_DWARVENWARAXE_R
		|| nWeapon == BASE_ITEM_FLAIL || nWeapon == BASE_ITEM_FLAIL_R 
		|| nWeapon == BASE_ITEM_WARHAMMER || nWeapon == BASE_ITEM_WARHAMMER_R)
		{
			nTrail = TRAIL_TYPE_1HMR;
		}
		else if (nWeapon == BASE_ITEM_SPEAR || nWeapon == BASE_ITEM_SPEAR_R
		|| nWeapon == BASE_ITEM_QUARTERSTAFF || nWeapon == BASE_ITEM_QUARTERSTAFF_R
		|| nWeapon == BASE_ITEM_MAGICSTAFF || nWeapon == BASE_ITEM_MAGICSTAFF_R
		|| nWeapon == BASE_ITEM_HALBERD || nWeapon == BASE_ITEM_HALBERD_R)
		{
			nTrail = TRAIL_TYPE_SPEAR;
		}
		else if (!GetWeaponRanged(oWeapon))
		{
			nTrail = TRAIL_TYPE_BLADE;
		}

		effect eVis;

		if (nManeuver == STANCE_DANCING_BLADE_FORM)
		{
		}
	}
}*/