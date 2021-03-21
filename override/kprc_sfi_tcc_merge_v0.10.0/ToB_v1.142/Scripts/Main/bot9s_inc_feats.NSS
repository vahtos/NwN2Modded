//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 2/28/2009								//
//	Title: bot9s_inc_feats						//
//	Description: Scripts that control how feats	//
//	function. Many of these are intended for use//
//	in strikes where they are not normally		//
//	accounted, due to engine constraints.		//
//////////////////////////////////////////////////

#include "bot9s_inc_2da"
#include "bot9s_inc_constants"
#include "bot9s_inc_variables"
#include "bot9s_include"
#include "tob_i0_spells"

// Prototypes

// Applies a knockback effect while wildshaped or raging.
// This feat is not used outside of Tiger Claw strikes.
void TigerBlooded(object oPC, object oWeapon, object oTarget);

// Adds damage from unarmed attacks from Superior Unarmed Strike.
effect SuperiorUnarmedStrikeForWeapon(object oPC = OBJECT_SELF);

// Applies the damage from Snap Kick if it is active, but not the attack penalty.
effect SnapKickDamage(object oPC = OBJECT_SELF);

// Applies a stun effect to a Setting Sun maneuver when called.
effect FallingSunAttack(object oFoe, object oPC = OBJECT_SELF);

// Not a feat per se, but this is a good place to put this function because all
// of the Tiger Claw maneuvers call this library.  Jump skill in the Tome of 
// Battle is determined by the PC's Str mod plus their ranks in Taunt.
// nBonus: Any misc bonuses to the skill that might be included.
int GetJumpSkill(object oPC = OBJECT_SELF, int nBonus = 0);

// All of the Tome of Battle's persistent feats are linked to an effect which uses an
// ID number in spells.2da.  Sometimes this number will be marked by a placeholder when no
// actual spellscript is needed.  Sometimes the effect itself isn't needed for anything more
// than a placeholder to indicate that a recursive script is running (in this case a blank VFX).
// The idea is that when a recursive function is used, in order to prevent a duplicate from
// running (and causing a stack overflow error or other bugs) this function checks for the effect
// applied by the recursive loop.  If it finds the effect then another recursive isn't executed.
// If the effect isn't there it means that it is okay to start the recursive loop for the feat.
// Care must be taken as some events in the game can supress the detection of an effect, such as
// right after resting.  If the effect is found on the player this function returns TRUE.
int CheckRecursive(int nId);

// Functions

// Applies a knockback effect while wildshaped or raging.
// This feat is not used outside of Tiger Claw strikes.
void TigerBlooded(object oPC, object oWeapon, object oTarget)
{
	int nStrMod = GetAbilityModifier(ABILITY_STRENGTH, oPC);
	int nMyDC = 10 + (GetHitDice(oPC) / 2) + nStrMod;
	int nMySize = GetCreatureSize(oPC);
	int nTargetSize = GetCreatureSize(oTarget);
	
	if (nMySize >= nTargetSize)
	{
		float fDistance = FeetToMeters(5.0f);

		if ((GetHasFeat(FEAT_BLADE_MEDITATION_TC, oPC)) && (GetIsTigerClawWeapon(oWeapon)))
		{
			nMyDC += 1;
		}
		
		effect eEffect = GetFirstEffect(oPC);
		
		while(GetIsEffectValid(eEffect))
		{
			int nType = GetEffectType(eEffect);

			if (nType == EFFECT_TYPE_POLYMORPH)
			{
				if (MySavingThrow(SAVING_THROW_FORT, oTarget, nMyDC) == 0)
				{
					ThrowTarget(oTarget, fDistance);
				}
			}
			else if (nType == EFFECT_TYPE_WILDSHAPE)
			{
				if (MySavingThrow(SAVING_THROW_FORT, oTarget, nMyDC) == 0)
				{
					ThrowTarget(oTarget, fDistance);
				}
			}

			eEffect = GetNextEffect(oPC);
		}
		
		if (GetIsRaging(oPC))
		{
			if (MySavingThrow(SAVING_THROW_FORT, oTarget, nMyDC) == 0)
			{
				ThrowTarget(oTarget, fDistance);
			}
		}
	}
}

// Adds damage from unarmed attacks from Superior Unarmed Strike.
effect SuperiorUnarmedStrikeForWeapon(object oPC = OBJECT_SELF)
{
	int nMonk  = GetLevelByClass(CLASS_TYPE_MONK, oPC) + GetLevelByClass(CLASS_TYPE_SACREDFIST, oPC);
	int nNotMonk = GetHitDice(oPC) - nMonk;
	int nMySize = GetCreatureSize(oPC);
	int nFists;
	int nMonkFists;
	
	effect eDamage;
	
	if (GetHasFeat(FEAT_SUPERIOR_UNARMED_STRIKE, oPC)) // Applies to all sizes oddly enough.
	{
		switch (nNotMonk)
		{
			case 1:	 nFists = nFists + d2();	break;
			case 2:	 nFists = nFists + d2();	break;
			case 3:	 nFists = nFists + d4();	break;
			case 4:	 nFists = nFists + d6();	break;
			case 5:	 nFists = nFists + d6();	break;
			case 6:	 nFists = nFists + d6();	break;
			case 7:	 nFists = nFists + d6();	break;
			case 8:	 nFists = nFists + d8();	break;
			case 9:	 nFists = nFists + d8();	break;
			case 10: nFists = nFists + d8();	break;
			case 11: nFists = nFists + d8();	break;
			case 12: nFists = nFists + d10();	break;
			case 13: nFists = nFists + d10();	break;
			case 14: nFists = nFists + d10();	break;
			case 15: nFists = nFists + d10();	break;
			case 16: nFists = nFists + d6(2);	break;
			case 17: nFists = nFists + d6(2);	break;
			case 18: nFists = nFists + d6(2);	break;
			case 19: nFists = nFists + d6(2);	break;
			case 20: nFists = nFists + d6(2);	break;
			case 21: nFists = nFists + d8(2);	break;
			case 22: nFists = nFists + d8(2);	break;
			case 23: nFists = nFists + d8(2);	break;
			case 24: nFists = nFists + d8(2);	break;
			case 25: nFists = nFists + d10(2);	break;
			case 26: nFists = nFists + d10(2);	break;
			case 27: nFists = nFists + d10(2);	break;
			case 28: nFists = nFists + d10(2);	break;
			case 29: nFists = nFists + d6(4);	break;
			case 30: nFists = nFists + d6(4);	break;
		}
		
		if (nMySize == CREATURE_SIZE_TINY || nMySize == CREATURE_SIZE_SMALL)
		{
			switch (nMonk)
			{
				case 1: nMonkFists = nMonkFists + d6();		break;
				case 2: nMonkFists = nMonkFists + d6();		break;
				case 3: nMonkFists = nMonkFists + d6();		break;
				case 4: nMonkFists = nMonkFists + d8();		break;
				case 5: nMonkFists = nMonkFists + d8();		break;
				case 6: nMonkFists = nMonkFists + d8();		break;
				case 7: nMonkFists = nMonkFists + d8();		break;
				case 8: nMonkFists = nMonkFists + d10();	break;
				case 9: nMonkFists = nMonkFists + d10();	break;
				case 10:nMonkFists = nMonkFists + d10();	break;
				case 11:nMonkFists = nMonkFists + d10();	break;
				case 12:nMonkFists = nMonkFists + d6(2);	break;
				case 13:nMonkFists = nMonkFists + d6(2);	break;
				case 14:nMonkFists = nMonkFists + d6(2);	break;
				case 15:nMonkFists = nMonkFists + d6(2);	break;
				case 16:nMonkFists = nMonkFists + d8(2);	break;
				case 17:nMonkFists = nMonkFists + d8(2);	break;
				case 18:nMonkFists = nMonkFists + d8(2);	break;
				case 19:nMonkFists = nMonkFists + d8(2);	break;
				case 20:nMonkFists = nMonkFists + d10(2);	break;
				case 21:nMonkFists = nMonkFists + d10(2);	break;
				case 22:nMonkFists = nMonkFists + d10(2);	break;
				case 23:nMonkFists = nMonkFists + d10(2);	break;
				case 24:nMonkFists = nMonkFists + d6(4);	break;
				case 25:nMonkFists = nMonkFists + d6(4);	break;
				case 26:nMonkFists = nMonkFists + d6(4);	break;
				case 27:nMonkFists = nMonkFists + d6(4);	break;
				case 28:nMonkFists = nMonkFists + d8(4);	break;
				case 29:nMonkFists = nMonkFists + d8(4);	break;
				case 30:nMonkFists = nMonkFists + d8(4);	break;
			}
		}
		else if (nMySize == CREATURE_SIZE_MEDIUM)
		{
			switch (nMonk)
			{
				case 1: nMonkFists = nMonkFists + d8();		break;
				case 2: nMonkFists = nMonkFists + d8();		break;
				case 3: nMonkFists = nMonkFists + d8();		break;
				case 4: nMonkFists = nMonkFists + d10();	break;
				case 5: nMonkFists = nMonkFists + d10();	break;
				case 6: nMonkFists = nMonkFists + d10();	break;
				case 7: nMonkFists = nMonkFists + d10();	break;
				case 8: nMonkFists = nMonkFists + d6(2);	break;
				case 9: nMonkFists = nMonkFists + d6(2);	break;
				case 10:nMonkFists = nMonkFists + d6(2);	break;
				case 11:nMonkFists = nMonkFists + d6(2);	break;
				case 12:nMonkFists = nMonkFists + d8(2);	break;
				case 13:nMonkFists = nMonkFists + d8(2);	break;
				case 14:nMonkFists = nMonkFists + d8(2);	break;
				case 15:nMonkFists = nMonkFists + d8(2);	break;
				case 16:nMonkFists = nMonkFists + d10(2);	break;
				case 17:nMonkFists = nMonkFists + d10(2);	break;
				case 18:nMonkFists = nMonkFists + d10(2);	break;
				case 19:nMonkFists = nMonkFists + d10(2);	break;
				case 20:nMonkFists = nMonkFists + d6(4);	break;
				case 21:nMonkFists = nMonkFists + d6(4);	break;
				case 22:nMonkFists = nMonkFists + d6(4);	break;
				case 23:nMonkFists = nMonkFists + d6(4);	break;
				case 24:nMonkFists = nMonkFists + d8(4);	break;
				case 25:nMonkFists = nMonkFists + d8(4);	break;
				case 26:nMonkFists = nMonkFists + d8(4);	break;
				case 27:nMonkFists = nMonkFists + d10(4);	break;
				case 28:nMonkFists = nMonkFists + d10(4);	break;
				case 29:nMonkFists = nMonkFists + d10(4);	break;
				case 30:nMonkFists = nMonkFists + d10(4);	break;
			}
		}
		else if (nMySize > CREATURE_SIZE_MEDIUM)
		{
			switch (nMonk)
			{
				case 1: nMonkFists = nMonkFists + d6(2);	break;
				case 2: nMonkFists = nMonkFists + d6(2);	break;
				case 3: nMonkFists = nMonkFists + d6(2);	break;
				case 4: nMonkFists = nMonkFists + d8(2);	break;
				case 5: nMonkFists = nMonkFists + d8(2);	break;
				case 6: nMonkFists = nMonkFists + d8(2);	break;
				case 7: nMonkFists = nMonkFists + d8(2);	break;
				case 8: nMonkFists = nMonkFists + d6(3);	break;
				case 9: nMonkFists = nMonkFists + d6(3);	break;
				case 10:nMonkFists = nMonkFists + d6(3);	break;
				case 11:nMonkFists = nMonkFists + d6(3);	break;
				case 12:nMonkFists = nMonkFists + d8(3);	break;
				case 13:nMonkFists = nMonkFists + d8(3);	break;
				case 14:nMonkFists = nMonkFists + d8(3);	break;
				case 15:nMonkFists = nMonkFists + d8(3);	break;
				case 16:nMonkFists = nMonkFists + d8(4);	break;
				case 17:nMonkFists = nMonkFists + d8(4);	break;
				case 18:nMonkFists = nMonkFists + d8(4);	break;
				case 19:nMonkFists = nMonkFists + d8(4);	break;
				case 20:nMonkFists = nMonkFists + d6(5);	break;
				case 21:nMonkFists = nMonkFists + d6(5);	break;
				case 22:nMonkFists = nMonkFists + d6(5);	break;
				case 23:nMonkFists = nMonkFists + d6(5);	break;
				case 24:nMonkFists = nMonkFists + d8(5);	break;
				case 25:nMonkFists = nMonkFists + d8(5);	break;
				case 26:nMonkFists = nMonkFists + d8(5);	break;
				case 27:nMonkFists = nMonkFists + d8(5);	break;
				case 28:nMonkFists = nMonkFists + d4(12);	break;
				case 29:nMonkFists = nMonkFists + d4(12);	break;
				case 30:nMonkFists = nMonkFists + d4(12);	break;
			}
		}
	}

	if (nMonk > 15)
	{
		eDamage = EffectDamage((nMonkFists + nFists), DAMAGE_TYPE_MAGICAL);
	}
	else eDamage = EffectDamage((nMonkFists + nFists), DAMAGE_TYPE_BLUDGEONING);

	return eDamage;
}
			
// Applies the damage from Snap Kick if it is active, but not the attack penalty.
effect SnapKickDamage(object oPC = OBJECT_SELF)
{
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oRightHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
	int nMonk  = GetLevelByClass(CLASS_TYPE_MONK, oPC) + GetLevelByClass(CLASS_TYPE_SACREDFIST, oPC);
	int nNotMonk = GetHitDice(oPC) - nMonk;
	int nMySize = GetCreatureSize(oPC);
	int nFists, nMonkFists, nStrMod, nUnarmedDamage;
	effect eUnarmedDamage;

	if (GetAbilityModifier(ABILITY_STRENGTH, oPC) < 2)
	{
		nStrMod = 0;
	}
	else nStrMod = GetAbilityModifier(ABILITY_STRENGTH, oPC) / 2;

	if ((GetLocalInt(oToB, "SnapKick") == 1) && GetHasFeat(FEAT_SUPERIOR_UNARMED_STRIKE, oPC))
	{
		eUnarmedDamage = SuperiorUnarmedStrikeForWeapon();
	}
	else if (GetLocalInt(oToB, "SnapKick") == 1)
	{
		switch (nMySize)
		{	
			case CREATURE_SIZE_TINY:	 nFists = 1;	break;
			case CREATURE_SIZE_SMALL:	 nFists = d2();	break;
			case CREATURE_SIZE_MEDIUM:	 nFists = d3();	break;
			case CREATURE_SIZE_LARGE:	 nFists = d4();	break;
			case CREATURE_SIZE_HUGE:	 nFists = d6();	break;
			default:					 nFists = 2;	break;
		}		
		
		if (nMonk > 0)
		{
			if (nMySize == CREATURE_SIZE_TINY || nMySize == CREATURE_SIZE_SMALL)
			{
				switch (nMonk)
				{
					case 1: nMonkFists = nMonkFists + d4();		break;
					case 2: nMonkFists = nMonkFists + d4();		break;
					case 3: nMonkFists = nMonkFists + d4();		break;
					case 4: nMonkFists = nMonkFists + d6();		break;
					case 5: nMonkFists = nMonkFists + d6();		break;
					case 6: nMonkFists = nMonkFists + d6();		break;
					case 7: nMonkFists = nMonkFists + d6();		break;
					case 8: nMonkFists = nMonkFists + d8();		break;
					case 9: nMonkFists = nMonkFists + d8();		break;
					case 10:nMonkFists = nMonkFists + d8();		break;
					case 11:nMonkFists = nMonkFists + d8();		break;
					case 12:nMonkFists = nMonkFists + d10();	break;
					case 13:nMonkFists = nMonkFists + d10();	break;
					case 14:nMonkFists = nMonkFists + d10();	break;
					case 15:nMonkFists = nMonkFists + d10();	break;
					case 16:nMonkFists = nMonkFists + d6(2);	break;
					case 17:nMonkFists = nMonkFists + d6(2);	break;
					case 18:nMonkFists = nMonkFists + d6(2);	break;
					case 19:nMonkFists = nMonkFists + d6(2);	break;
					case 20:nMonkFists = nMonkFists + d8(2);	break;
					case 21:nMonkFists = nMonkFists + d8(2);	break;
					case 22:nMonkFists = nMonkFists + d8(2);	break;
					case 23:nMonkFists = nMonkFists + d8(2);	break;
					case 24:nMonkFists = nMonkFists + d10(2);	break;
					case 25:nMonkFists = nMonkFists + d10(2);	break;
					case 26:nMonkFists = nMonkFists + d10(2);	break;
					case 27:nMonkFists = nMonkFists + d10(2);	break;
					case 28:nMonkFists = nMonkFists + d6(4);	break;
					case 29:nMonkFists = nMonkFists + d6(4);	break;
					case 30:nMonkFists = nMonkFists + d6(4);	break;
				}
			}
			else if (nMySize == CREATURE_SIZE_MEDIUM)
			{
				switch (nMonk)
				{
					case 1: nMonkFists = nMonkFists + d6();		break;
					case 2: nMonkFists = nMonkFists + d6();		break;
					case 3: nMonkFists = nMonkFists + d6();		break;
					case 4: nMonkFists = nMonkFists + d8();		break;
					case 5: nMonkFists = nMonkFists + d8();		break;
					case 6: nMonkFists = nMonkFists + d8();		break;
					case 7: nMonkFists = nMonkFists + d8();		break;
					case 8: nMonkFists = nMonkFists + d10();	break;
					case 9: nMonkFists = nMonkFists + d10();	break;
					case 10:nMonkFists = nMonkFists + d10();	break;
					case 11:nMonkFists = nMonkFists + d10();	break;
					case 12:nMonkFists = nMonkFists + d6(2);	break;
					case 13:nMonkFists = nMonkFists + d6(2);	break;
					case 14:nMonkFists = nMonkFists + d6(2);	break;
					case 15:nMonkFists = nMonkFists + d6(2);	break;
					case 16:nMonkFists = nMonkFists + d8(2);	break;
					case 17:nMonkFists = nMonkFists + d8(2);	break;
					case 18:nMonkFists = nMonkFists + d8(2);	break;
					case 19:nMonkFists = nMonkFists + d8(2);	break;
					case 20:nMonkFists = nMonkFists + d10(2);	break;
					case 21:nMonkFists = nMonkFists + d10(2);	break;
					case 22:nMonkFists = nMonkFists + d10(2);	break;
					case 23:nMonkFists = nMonkFists + d10(2);	break;
					case 24:nMonkFists = nMonkFists + d6(4);	break;
					case 25:nMonkFists = nMonkFists + d6(4);	break;
					case 26:nMonkFists = nMonkFists + d6(4);	break;
					case 27:nMonkFists = nMonkFists + d6(4);	break;
					case 28:nMonkFists = nMonkFists + d8(4);	break;
					case 29:nMonkFists = nMonkFists + d8(4);	break;
					case 30:nMonkFists = nMonkFists + d8(4);	break;
				}
			}
			else if (nMySize > CREATURE_SIZE_MEDIUM)
			{
				switch (nMonk)
				{
					case 1: nMonkFists = nMonkFists + d8();		break;
					case 2: nMonkFists = nMonkFists + d8();		break;
					case 3: nMonkFists = nMonkFists + d8();		break;
					case 4: nMonkFists = nMonkFists + d6(2);	break;
					case 5: nMonkFists = nMonkFists + d6(2);	break;
					case 6: nMonkFists = nMonkFists + d6(2);	break;
					case 7: nMonkFists = nMonkFists + d6(2);	break;
					case 8: nMonkFists = nMonkFists + d8(2);	break;
					case 9: nMonkFists = nMonkFists + d8(2);	break;
					case 10:nMonkFists = nMonkFists + d8(2);	break;
					case 11:nMonkFists = nMonkFists + d8(2);	break;
					case 12:nMonkFists = nMonkFists + d6(3);	break;
					case 13:nMonkFists = nMonkFists + d6(3);	break;
					case 14:nMonkFists = nMonkFists + d6(3);	break;
					case 15:nMonkFists = nMonkFists + d6(3);	break;
					case 16:nMonkFists = nMonkFists + d8(3);	break;
					case 17:nMonkFists = nMonkFists + d8(3);	break;
					case 18:nMonkFists = nMonkFists + d8(3);	break;
					case 19:nMonkFists = nMonkFists + d8(3);	break;
					case 20:nMonkFists = nMonkFists + d8(4);	break;
					case 21:nMonkFists = nMonkFists + d8(4);	break;
					case 22:nMonkFists = nMonkFists + d8(4);	break;
					case 23:nMonkFists = nMonkFists + d8(4);	break;
					case 24:nMonkFists = nMonkFists + d6(5);	break;
					case 25:nMonkFists = nMonkFists + d6(5);	break;
					case 26:nMonkFists = nMonkFists + d6(5);	break;
					case 27:nMonkFists = nMonkFists + d6(5);	break;
					case 28:nMonkFists = nMonkFists + d8(5);	break;
					case 29:nMonkFists = nMonkFists + d8(5);	break;
					case 30:nMonkFists = nMonkFists + d8(5);	break;
				}
			}
		}
		if (nMonk > 15)
		{
			nUnarmedDamage = nMonkFists + nFists + nStrMod;
			eUnarmedDamage = EffectDamage(nUnarmedDamage, DAMAGE_TYPE_MAGICAL);
			SetLocalInt(oToB, "SnapKickStoredDam", nUnarmedDamage);
			SetLocalInt(oToB, "SnapKickType", DAMAGE_TYPE_MAGICAL);
		}
		else 
		{
			nUnarmedDamage = nMonkFists + nFists + nStrMod;
			eUnarmedDamage = EffectDamage(nUnarmedDamage, DAMAGE_TYPE_BLUDGEONING);
			SetLocalInt(oPC, "SnapKickStoredDam", nUnarmedDamage);
			SetLocalInt(oPC, "SnapKickType", DAMAGE_TYPE_BLUDGEONING);
		}
	}
	return eUnarmedDamage;
}

// Applies a stun effect to a Setting Sun maneuver when called.
effect FallingSunAttack(object oFoe, object oPC = OBJECT_SELF)
{
	int nStunDC = 11 + (GetHitDice(oPC) / 2) + GetAbilityModifier(ABILITY_WISDOM, oPC);
	int nSub = GetSubRace(oFoe);
	effect eStun;
	
	if (GetHasFeat(FEAT_BLADE_MEDITATION_SS, oPC))
	{
		nStunDC += 1;
	}
	
	DecrementRemainingFeatUses(oPC, FEAT_STUNNING_FIST);
	
	if (nSub == RACIAL_SUBTYPE_CONSTRUCT || nSub == RACIAL_SUBTYPE_INCORPOREAL 
	|| nSub == RACIAL_SUBTYPE_OOZE || nSub == RACIAL_SUBTYPE_PLANT || nSub == RACIAL_SUBTYPE_UNDEAD)
	{
		return eStun;
	}
	else if (GetIsImmune(oFoe, IMMUNITY_TYPE_SNEAK_ATTACK))
	{
		return eStun;
	}
	else if (GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) != OBJECT_INVALID)
	{
		return eStun;
	}
	else if (MySavingThrow(SAVING_THROW_FORT, oFoe, nStunDC) == 0)
	{
		eStun = EffectStunned();
		eStun = ExtraordinaryEffect(eStun);
	}

	return eStun;
}

// Not a feat per se, but this is a good place to put this function because all
// of the Tiger Claw maneuvers call this library.  Jump skill in the Tome of 
// Battle is determined by the PC's Str mod plus their ranks in Taunt.
// nBonus: Any misc bonuses to the skill that might be included.
int GetJumpSkill(object oPC = OBJECT_SELF, int nBonus = 0)
{
	int nTaunt;

	nTaunt += GetSkillRank(SKILL_TAUNT, oPC, TRUE);
	nTaunt += nBonus;

	int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);

	nTaunt += nStr;

	if ((GetCurrentAction(oPC) == ACTION_MOVETOPOINT) || (GetLocalInt(oPC, "LeapingDragonStance") == 1))
	{
		if (GetHasFeat(FEAT_DASH)) // Using this instead of the "Run" feat.
		{
			nTaunt += 4;
		}
	}

	effect eSpeed;

	eSpeed = GetFirstEffect(oPC);

	while (GetIsEffectValid(eSpeed))
	{
		int nType = GetEffectType(eSpeed);

		if (nType == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE)
		{
			int nSpeed = GetEffectInteger(eSpeed, 0);
			float fCheck = IntToFloat(nSpeed) / (5.0f/3.0f);

			if (fCheck >= 59.0f) //Double Speed. Max value of the movement increase % is 99.
			{
				nTaunt += 12;
			}
			else if (fCheck >= 50.0f)
			{
				nTaunt += 8;
			}
			else if (fCheck >= 40.0f)
			{
				nTaunt += 4;
			}
		}
		else if (nType == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
		{
			int nSpeed = GetEffectInteger(eSpeed, 0);
			float fCheck = IntToFloat(nSpeed) / (5.0f/3.0f);

			if (fCheck >= 59.0f) //Immobile. Max value of the movement decrease % is 99.
			{
				nTaunt -= 18;
			}
			else if (fCheck >= 50.0f)
			{
				nTaunt -= 12;
			}
			else if (fCheck >= 40.0f)
			{
				nTaunt -= 6;
			}
		}

		eSpeed = GetNextEffect(oPC);
	}

	if (GetHasFeat(FEAT_SKILL_FOCUS_TAUNT, oPC))
	{
		nTaunt += 3;
	}

	if (GetHasFeat(FEAT_EPIC_SKILL_FOCUS_TAUNT, oPC))
	{
		nTaunt += 10;
	}

	if (GetSkillRank(SKILL_TUMBLE, oPC, TRUE) > 4)
	{
		nTaunt += 2; //Synergy
	}

	if (GetRacialType(oPC) == RACIAL_TYPE_HALFLING)
	{
		nTaunt += 2; //Racial Bonus
	}

	if (GetHasFeat(6913, oPC)) //Blade Meditation: Tiger Claw
	{
		nTaunt += 2;
	}

	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
	int nArmor, nShield;

	if (oArmor == OBJECT_INVALID)
	{
		nArmor = 0; //Prevents the function from shutting down.
	}
	else nArmor = GetArmorRulesType(oArmor);

	int nArmorPenalty = abs(tob_Get2daInt("armorrulestats", "ACCHECK", nArmor));
	object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

	if (oShield == OBJECT_INVALID)
	{
		nShield = 0; //Prevents the function from shutting down.
	}
	else nShield = GetArmorRulesType(oShield);

	int nShieldPenalty = abs(tob_Get2daInt("armorrulestats", "ACCHECK", nShield));
	int nArmorCheckPenalty = nArmorPenalty + nShieldPenalty;

	nTaunt -= nArmorCheckPenalty;

	return nTaunt;
}

// All of the Tome of Battle's persistent feats are linked to an effect which uses an
// ID number in spells.2da.  Sometimes this number will be marked by a placeholder when no
// actual spellscript is needed.  Sometimes the effect itself isn't needed for anything more
// than a placeholder to indicate that a recursive script is running (in this case a blank VFX).
// The idea is that when a recursive function is used, in order to prevent a duplicate from
// running (and causing a stack overflow error or other bugs) this function checks for the effect
// applied by the recursive loop.  If it finds the effect then another recursive isn't executed.
// If the effect isn't there it means that it is okay to start the recursive loop for the feat.
// Care must be taken as some events in the game can supress the detection of an effect, such as
// right after resting.  If the effect is found on the player this function returns TRUE.
int CheckRecursive(int nId)
{
	object oPC = OBJECT_SELF;

	effect eTest;
	int nEffectId, nReturn;

	nReturn = FALSE;
	eTest = GetFirstEffect(oPC);

	while (GetIsEffectValid(eTest))
	{
		nEffectId = GetEffectSpellId(eTest);

		if (nId == nEffectId)
		{
			nReturn = TRUE;
			break;
		}
		eTest = GetNextEffect(oPC);
	}

	return nReturn;
}