//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 2/10/2009							//
//	Title: bot9s_include					//
//	Description: Utility functions for the	//
//	Book of the Nine Swords classes.		//
//////////////////////////////////////////////

#include "bot9s_inc_2da"
#include "bot9s_inc_variables"
#include "bot9s_inc_constants"
#include "tob_inc_spells"
#include "tob_i0_generic"
#include "tob_x0_i0_position"
#include "tob_x2_inc_itemprop"

/*	GetIsInMeleeRange, GetFirstEnemyInMeleeRange, GetHasMoved, and 
	GetDistanceMoved are adapted from Selea's works.
	GetWeaponSize, IsWeaponTwoHanded and IsWeaponRanged are Mithdradates's work.
	GetSneakAttackDice, GetSneakLevels, IsTargetConcealed, and 
	IsTargetValidForSneakAttack are adapted from Kaedrin's cmi_inc_sneakattack.
	Credit should therefore be given where it's due, the NWN community and
	I owe them a round of drinks should we ever meet. */

//Prototypes

// Returns the damage type of oWeapon as one of the DAMAGE_TYPE_* constants.
// WEAPON_TYPE_PIERCING_AND_SLASHING is returned as DAMAGE_TYPE_PIERCING.
// OBJECT_INVALID is returned as DAMAGE_TYPE_BLUDGEONING.
int GetWeaponDamageType(object oWeapon);

//Returns the range of a weapon's base item.
// - oPC: oPC's weapon should currently be equipped in the target's right hand.
float GetWeaponRange(object oPC);

// Since calculations of distance start from the center of the creature to the
// edge of area it occupies, range is calculated by the size the creature 
// takes up plus its weapon's range.
float GetMeleeRange(object oCreature);

//Returns if oTarget is in fRange of oCreature
//Returns TRUE or FALSE
int GetIsInMeleeRange(object oTarget, object oCreature);

//Returns the first enemy of oCreature in fRange
// * Returns OBJECT_INVALID if no enemy is found
object GetFirstEnemyInMeleeRange(object oCreature);

// Creates the effect of the PC throwing the target.
// The target is thrown ahead of the PC.
// - oTarget: The creature we want to throw
// - fDistance: How far we want to throw him.
// - bRecordLanding: Store the location that oTarget lands at as 
// "bot9s_landing" on oPC, when this value is set to TRUE.
// - bAhead: When set to true will find a location directly in front of the 
// player, otherwise a random location fDistance away is used.
void ThrowTarget(object oTarget, float fDistance, int bRecordLanding = FALSE, int bAhead = TRUE);

//Function to determine the size of the weapon being used by the creature
int GetWeaponSize(object oCreature=OBJECT_SELF);

//Function to determine whether a creature is using a two-handed weapon
int IsWeaponTwoHanded(object oCreature=OBJECT_SELF);

//Function to determine whether a creature is using a ranged weapon
int IsWeaponRanged(object oCreature=OBJECT_SELF);

// Wrapper function for the PlayCustomAnimation Function (duh)
void WrapperPlayCustomAnimation(object oPC, string sAnimation, int nLoop, float fSpeed = 1.0f);

// Wrapper for CreateObject.
void WrapperCreateObject(int nObjectType, string sTemplate, location lLocation, int bUseAppearAnimation=FALSE, string sNewTag="");

// Wrapper for CreateItemOnObject.
void WrapperCreateItemOnObject(string sItemTemplate, object oTarget=OBJECT_SELF, int nStackSize=1, string sNewTag="", int bDisplayFeedback=1);

// Wrapper for FeatAdd.
void WrapperFeatAdd(object oPC, int nFeat, int bCheckRequirements, int bFeedback=FALSE, int bNotice=FALSE);

// Wrapper for SetWeaponVisibility.
// -nVisible: 0 for invisibile, 1 for visible, and 4 is default engine action.
// -nType: 0 - weapon, 1 - helm, 2 - both.
void WrapperSetWeaponVisibility(object oPC, int nVisable, int nType);

// Wrapper for CopyItem
void WrapperCopyItem(object oItem, object oTargetInventory = OBJECT_INVALID, int bCopyVars = FALSE);

// Checks a Player's current class levels to determine sneak attack and death attack dice.
int GetSneakAttackDice(object oSneakAttacker = OBJECT_SELF);

// Returns the number of levels oTarget has in a class that can sneak attack.
int GetSneakLevels(object oTarget);

// Determines if the SneakAttacker has concealment from the Target.
int IsTargetConcealed(object oTarget, object oSneakAttacker);

// Determines how wide across the target is.
// This is more of a practical way to determine squares than it is real size.
float GetGirth(object oTarget);

// Determines if the PC is flanking the target or not.  Returns TRUE if they are.
int IsFlankValid(object oPC, object oTarget);

// Sneak Attack can't be used against targets with concealment
int IsTargetValidForSneakAttack(object oTarget, object oSneakAttacker);

// Does the same thing as TurnToFaceObject except that it checks for range and if oPC and oTarget are alive.
void WatchOpponent(object oTarget, object oPC = OBJECT_SELF);

// Clears the variables that govern the Quickstrike menu.
// -sClass: Determines which class's menu is cleared.
void ClearBoxes(string sClass);

// Clears all of the data on the Maneuvers Known screen.
// -sClass: Determines which class's screen is cleared.
void ClearManeuversKnown(string sClass);

// Clears all of the data on the Maneuvers Readied screen.
// -sClass: Determines which class's screen is cleared.
void ClearManeuversReadied(string sClass);

// Clears all currently enqueued strikes.
void ClearStrikes();

// Determines if oPC has line of effect to lTarget.
// This function will return false for anything that makes GetIsLocationValid
// return false.  In fact, this function checks the validity of every location
// between oPC and lTarget in small increments.
// -oPC: Object which serves as the source of the line of effect test.
// -lTarget: The location we're determining if oPC blocked to or not.
// -bTriggers: When set to TRUE also checks for triggers and returns FALSE if
// the function detects one in the line of effect.
int LineOfEffect(object oPC, location lTarget, int bTriggers = FALSE);


//Functions

// Returns the damage type of oWeapon as one of the DAMAGE_TYPE_* constants.
// WEAPON_TYPE_PIERCING_AND_SLASHING is returned as DAMAGE_TYPE_PIERCING.
// OBJECT_INVALID is returned as DAMAGE_TYPE_BLUDGEONING.
int GetWeaponDamageType(object oWeapon)
{
	int nWeapon = GetWeaponType(oWeapon);
	int nDamageType;

	if (nWeapon == WEAPON_TYPE_PIERCING_AND_SLASHING || nWeapon == WEAPON_TYPE_PIERCING)
	{
		nDamageType = DAMAGE_TYPE_PIERCING;
	}
	else if (nWeapon == WEAPON_TYPE_SLASHING)
	{
		nDamageType = DAMAGE_TYPE_SLASHING;
	}
	else nDamageType = DAMAGE_TYPE_BLUDGEONING;

	return nDamageType;
}

//Returns the range of a weapon's base item.
// - oPC: oPC's weapon should currently be equipped in the target's right hand.
float GetWeaponRange(object oPC)
{
	object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	float fRange;
	object oWeapon;

	if (!GetIsObjectValid(oRight))
	{
		object oBite = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC);
		object oClaw = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
		object oCrWeapon = GetLastWeaponUsed(oPC);

		if (GetIsObjectValid(oBite))
		{
			oWeapon = oBite;
		}
		else if (GetIsObjectValid(oClaw))
		{
			oWeapon = oClaw;
		}
		else if (GetIsObjectValid(oCrWeapon))
		{
			oWeapon = oCrWeapon;
		}
		else oWeapon = OBJECT_INVALID;
	}
	else oWeapon = oRight;

	int nRow = GetBaseItemType(oWeapon);
	object oToB = GetItemPossessedBy(oPC, "tob");

	if (GetLocalInt(oToB, "bot9s_PrefAttackDist") == 1)
	{
		fRange = GetLocalFloat(oToB, "override_PrefAttackDist");
	}
	else if (oWeapon == OBJECT_INVALID)
	{
		fRange = tob_Get2daFloat("appearance", "PREFATCKDIST", nRow);
	}
	else fRange = tob_Get2daFloat("baseitems", "PrefAttackDist", nRow);

	return fRange;
}

// Since calculations of distance start from the center of the creature to the
// edge of area it occupies, range is calculated by the size the creature 
// takes up plus its weapon's range.
float GetMeleeRange(object oCreature)
{
	int nSizeMod = GetAppearanceType(oCreature);
	object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature);
	object oWeapon;

	if (!GetIsObjectValid(oRight))
	{
		object oBite = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oCreature);
		object oClaw = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oCreature);
		object oCrWeapon = GetLastWeaponUsed(oCreature);

		if (GetIsObjectValid(oBite))
		{
			oWeapon = oBite;
		}
		else if (GetIsObjectValid(oClaw))
		{
			oWeapon = oClaw;
		}
		else if (GetIsObjectValid(oCrWeapon))
		{
			oWeapon = oCrWeapon;
		}
		else oWeapon = OBJECT_INVALID;
	}
	else oWeapon = oRight;

	int nWeapon = GetBaseItemType(oWeapon);
	float fWeapon;

	fWeapon = tob_Get2daFloat("baseitems", "PrefAttackDist", nWeapon);

	if (fWeapon <= 0.0f)
	{
		fWeapon = FeetToMeters(5.0f);
	}

	float fAppearance = tob_Get2daFloat("appearance", "PREFATCKDIST", nSizeMod);
	float fRange = fWeapon + fAppearance;

	return fRange;
}

//Returns if oTarget is in fRange of oCreature
//Returns TRUE or FALSE
int GetIsInMeleeRange(object oTarget, object oCreature)
{
	float fRange = GetMeleeRange(oTarget);
		
	if (GetDistanceBetween(oCreature, oTarget) <= fRange)
	{
		return TRUE;
	}
	else return FALSE;
}

//Returns the first enemy of oCreature in fRange
// * Returns OBJECT_INVALID if no enemy is found
object GetFirstEnemyInMeleeRange(object oCreature)
{
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oCreature));
	while(GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCreature) && !GetIsDead(oTarget))
		{
			if(GetIsInMeleeRange(oTarget, oCreature))
			{
				return oTarget;
				break;
			}
		}
		
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oCreature));
	}
	
	return OBJECT_INVALID;
}

// Creates the effect of the PC throwing the target.
// The target is thrown ahead of the PC.
// - oTarget: The creature we want to throw
// - fDistance: How far we want to throw him.
// - bRecordLanding: Store the location that oTarget lands at as 
// "bot9s_landing" on oPC, when this value is set to TRUE.
// - bAhead: When set to true will find a location directly in front of the 
// player, otherwise a random location fDistance away is used.
void ThrowTarget(object oTarget, float fDistance, int bRecordLanding = FALSE, int bAhead = TRUE)
{
	object oPC = OBJECT_SELF;
	object oArea = GetArea(oPC);
	float fFive = FeetToMeters(5.0f);
	location lThrowLocation;

	if (bAhead == TRUE)
	{
		lThrowLocation = GetAheadLocation(oPC, fDistance);
	}
	else lThrowLocation = GetRandomLocation(oArea, oPC, fDistance);

	if (GetIsLocationValid(lThrowLocation))
	{
		AssignCommand(oTarget, ClearAllActions());
		AssignCommand(oTarget, DelayCommand(0.5f, ActionDoCommand(ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM))));
		AssignCommand(oTarget, JumpToLocation(lThrowLocation));

		if (bRecordLanding == TRUE)
		{
			SetLocalLocation(oPC, "bot9s_landing", lThrowLocation);
		}
	}
	else if ((fDistance - fFive) > 0.0f)
	{
		fDistance -= fFive;
	}
	else return;

	// -5 feet
	if (bAhead == TRUE)
	{
		lThrowLocation = GetAheadLocation(oPC, fDistance);
	}
	else lThrowLocation = GetRandomLocation(oArea, oPC, fDistance);

	if (GetIsLocationValid(lThrowLocation))
	{
		AssignCommand(oTarget, ClearAllActions());
		AssignCommand(oTarget, DelayCommand(0.5f, ActionDoCommand(ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM))));
		AssignCommand(oTarget, JumpToLocation(lThrowLocation));

		if (bRecordLanding == TRUE)
		{
			SetLocalLocation(oPC, "bot9s_landing", lThrowLocation);
		}
	}
	else if ((fDistance - fFive) > 0.0f)
	{
		fDistance -= fFive;
	}
	else return;

	//-10 feet
	if (bAhead == TRUE)
	{
		lThrowLocation = GetAheadLocation(oPC, fDistance);
	}
	else lThrowLocation = GetRandomLocation(oArea, oPC, fDistance);

	if (GetIsLocationValid(lThrowLocation))
	{
		AssignCommand(oTarget, ClearAllActions());
		AssignCommand(oTarget, DelayCommand(0.5f, ActionDoCommand(ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM))));
		AssignCommand(oTarget, JumpToLocation(lThrowLocation));

		if (bRecordLanding == TRUE)
		{
			SetLocalLocation(oPC, "bot9s_landing", lThrowLocation);
		}
	}
	else if ((fDistance - fFive) > 0.0f)
	{
		fDistance -= fFive;
	}
	else return;

	//-15 feet
	if (bAhead == TRUE)
	{
		lThrowLocation = GetAheadLocation(oPC, fDistance);
	}
	else lThrowLocation = GetRandomLocation(oArea, oPC, fDistance);

	if (GetIsLocationValid(lThrowLocation))
	{
		AssignCommand(oTarget, ClearAllActions());
		AssignCommand(oTarget, DelayCommand(0.5f, ActionDoCommand(ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM))));
		AssignCommand(oTarget, JumpToLocation(lThrowLocation));

		if (bRecordLanding == TRUE)
		{
			SetLocalLocation(oPC, "bot9s_landing", lThrowLocation);
		}
	}
	else if ((fDistance - fFive) > 0.0f)
	{
		fDistance -= fFive;
	}
	else return;

	//-20 feet
	if (bAhead == TRUE)
	{
		lThrowLocation = GetAheadLocation(oPC, fDistance);
	}
	else lThrowLocation = GetRandomLocation(oArea, oPC, fDistance);

	if (GetIsLocationValid(lThrowLocation))
	{
		AssignCommand(oTarget, ClearAllActions());
		AssignCommand(oTarget, DelayCommand(0.5f, ActionDoCommand(ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM))));
		AssignCommand(oTarget, JumpToLocation(lThrowLocation));

		if (bRecordLanding == TRUE)
		{
			SetLocalLocation(oPC, "bot9s_landing", lThrowLocation);
		}
	}
	else if ((fDistance - fFive) > 0.0f)
	{
		fDistance -= fFive;
	}
	else return;

	//-25 feet
	if (bAhead == TRUE)
	{
		lThrowLocation = GetAheadLocation(oPC, fDistance);
	}
	else lThrowLocation = GetRandomLocation(oArea, oPC, fDistance);

	if (GetIsLocationValid(lThrowLocation))
	{
		AssignCommand(oTarget, ClearAllActions());
		AssignCommand(oTarget, DelayCommand(0.5f, ActionDoCommand(ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM))));
		AssignCommand(oTarget, JumpToLocation(lThrowLocation));

		if (bRecordLanding == TRUE)
		{
			SetLocalLocation(oPC, "bot9s_landing", lThrowLocation);
		}
	}
	else if ((fDistance - fFive) > 0.0f)
	{
		fDistance -= fFive;
	}
	else return;

	//-30 feet
	if (bAhead == TRUE)
	{
		lThrowLocation = GetAheadLocation(oPC, fDistance);
	}
	else lThrowLocation = GetRandomLocation(oArea, oPC, fDistance);

	if (GetIsLocationValid(lThrowLocation))
	{
		AssignCommand(oTarget, ClearAllActions());
		AssignCommand(oTarget, DelayCommand(0.5f, ActionDoCommand(ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM))));
		AssignCommand(oTarget, JumpToLocation(lThrowLocation));

		if (bRecordLanding == TRUE)
		{
			SetLocalLocation(oPC, "bot9s_landing", lThrowLocation);
		}
	}
	else if ((fDistance - fFive) > 0.0f)
	{
		fDistance -= fFive;
	}
	else return;

	//-35 feet
	if (bAhead == TRUE)
	{
		lThrowLocation = GetAheadLocation(oPC, fDistance);
	}
	else lThrowLocation = GetRandomLocation(oArea, oPC, fDistance);

	if (GetIsLocationValid(lThrowLocation))
	{
		AssignCommand(oTarget, ClearAllActions());
		AssignCommand(oTarget, DelayCommand(0.5f, ActionDoCommand(ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM))));
		AssignCommand(oTarget, JumpToLocation(lThrowLocation));

		if (bRecordLanding == TRUE)
		{
			SetLocalLocation(oPC, "bot9s_landing", lThrowLocation);
		}
	}
	else if ((fDistance - fFive) > 0.0f)
	{
		fDistance -= fFive;
	}
	else return;

	//-40 feet
	if (bAhead == TRUE)
	{
		lThrowLocation = GetAheadLocation(oPC, fDistance);
	}
	else lThrowLocation = GetRandomLocation(oArea, oPC, fDistance);

	if (GetIsLocationValid(lThrowLocation))
	{
		AssignCommand(oTarget, ClearAllActions());
		AssignCommand(oTarget, DelayCommand(0.5f, ActionDoCommand(ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM))));
		AssignCommand(oTarget, JumpToLocation(lThrowLocation));

		if (bRecordLanding == TRUE)
		{
			SetLocalLocation(oPC, "bot9s_landing", lThrowLocation);
		}
	}
	else if ((fDistance - fFive) > 0.0f)
	{
		fDistance -= fFive;
	}
	else return;

	//-45 feet
	if (bAhead == TRUE)
	{
		lThrowLocation = GetAheadLocation(oPC, fDistance);
	}
	else lThrowLocation = GetRandomLocation(oArea, oPC, fDistance);

	if (GetIsLocationValid(lThrowLocation))
	{
		AssignCommand(oTarget, ClearAllActions());
		AssignCommand(oTarget, DelayCommand(0.5f, ActionDoCommand(ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM))));
		AssignCommand(oTarget, JumpToLocation(lThrowLocation));

		if (bRecordLanding == TRUE)
		{
			SetLocalLocation(oPC, "bot9s_landing", lThrowLocation);
		}
	}
	else if ((fDistance - fFive) > 0.0f)
	{
		fDistance -= fFive;
	}
	else return;

	//-50 feet
	if (bAhead == TRUE)
	{
		lThrowLocation = GetAheadLocation(oPC, fDistance);
	}
	else lThrowLocation = GetRandomLocation(oArea, oPC, fDistance);

	if (GetIsLocationValid(lThrowLocation))
	{
		AssignCommand(oTarget, ClearAllActions());
		AssignCommand(oTarget, DelayCommand(0.5f, ActionDoCommand(ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM))));
		AssignCommand(oTarget, JumpToLocation(lThrowLocation));

		if (bRecordLanding == TRUE)
		{
			SetLocalLocation(oPC, "bot9s_landing", lThrowLocation);
		}
	}
	else if ((fDistance - fFive) > 0.0f)
	{
		fDistance -= fFive;
	}
	else return;

	//-55 feet
	if (bAhead == TRUE)
	{
		lThrowLocation = GetAheadLocation(oPC, fDistance);
	}
	else lThrowLocation = GetRandomLocation(oArea, oPC, fDistance);

	if (GetIsLocationValid(lThrowLocation))
	{
		AssignCommand(oTarget, ClearAllActions());
		AssignCommand(oTarget, DelayCommand(0.5f, ActionDoCommand(ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM))));
		AssignCommand(oTarget, JumpToLocation(lThrowLocation));

		if (bRecordLanding == TRUE)
		{
			SetLocalLocation(oPC, "bot9s_landing", lThrowLocation);
		}
	}
	else if ((fDistance - fFive) > 0.0f)
	{
		fDistance -= fFive;
	}
	else return;
}

//Function to determine the size of the weapon being used by the creature
int GetWeaponSize(object oCreature=OBJECT_SELF)
{
	object oWeapon;
	if (GetObjectType(oCreature)==OBJECT_TYPE_CREATURE)
		oWeapon=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oCreature);
	else
		oWeapon=oCreature;
	if (!GetIsObjectValid(oWeapon)) return WEAPON_SIZE_SMALL;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_DAGGER) return WEAPON_SIZE_TINY;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_DAGGER_R) return WEAPON_SIZE_TINY;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_DART) return WEAPON_SIZE_TINY;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_FALCHION) return WEAPON_SIZE_LARGE;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_FALCHION_R) return WEAPON_SIZE_LARGE;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_GREATAXE) return WEAPON_SIZE_LARGE;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_GREATAXE_R) return WEAPON_SIZE_LARGE;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_GREATSWORD) return WEAPON_SIZE_LARGE;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_GREATSWORD_R) return WEAPON_SIZE_LARGE;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_HALBERD) return WEAPON_SIZE_LARGE;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_HALBERD_R) return WEAPON_SIZE_LARGE;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_HANDAXE) return WEAPON_SIZE_SMALL;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_HANDAXE_R) return WEAPON_SIZE_SMALL;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_HEAVYCROSSBOW) return WEAPON_SIZE_LARGE;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_KAMA) return WEAPON_SIZE_TINY;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_KAMA_R) return WEAPON_SIZE_TINY;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_KUKRI) return WEAPON_SIZE_TINY;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_KUKRI_R) return WEAPON_SIZE_TINY;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_LIGHTHAMMER) return WEAPON_SIZE_SMALL;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_LIGHTHAMMER_R) return WEAPON_SIZE_SMALL;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_LONGBOW) return WEAPON_SIZE_LARGE;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_LIGHTMACE) return WEAPON_SIZE_SMALL;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_MAGICSTAFF) return WEAPON_SIZE_LARGE;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_MAGICSTAFF_R) return WEAPON_SIZE_LARGE;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_QUARTERSTAFF) return WEAPON_SIZE_LARGE;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_QUARTERSTAFF_R) return WEAPON_SIZE_LARGE;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_SCYTHE) return WEAPON_SIZE_LARGE;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_SCYTHE_R) return WEAPON_SIZE_LARGE;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_SHORTSWORD) return WEAPON_SIZE_SMALL;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_SHORTSWORD_R) return WEAPON_SIZE_SMALL;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_SHURIKEN) return WEAPON_SIZE_TINY;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_SICKLE) return WEAPON_SIZE_SMALL;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_SICKLE_R) return WEAPON_SIZE_SMALL;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_SLING) return WEAPON_SIZE_SMALL;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_SPEAR) return WEAPON_SIZE_LARGE;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_SPEAR_R) return WEAPON_SIZE_LARGE;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_THROWINGAXE) return WEAPON_SIZE_SMALL;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_WARMACE) return WEAPON_SIZE_LARGE;
	if (GetBaseItemType(oWeapon)==BASE_ITEM_WARMACE_R) return WEAPON_SIZE_LARGE;
	return WEAPON_SIZE_MEDIUM;
}

//Function to determine whether a creature is using a two-handed weapon
int IsWeaponTwoHanded(object oCreature=OBJECT_SELF)
{
	object oWeapon;
	object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature);

	if (oRight == OBJECT_INVALID)
	{
		object oBite = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oCreature);
		object oRClaw = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oCreature);
		object oCrWeapon = GetLastWeaponUsed(oCreature);

		if (GetIsObjectValid(oBite))
		{
			oWeapon = oBite;
		}
		else if (GetIsObjectValid(oRClaw))
		{
			oWeapon = oRClaw;
		}
		else if (GetIsObjectValid(oCrWeapon))
		{
			oWeapon = oCrWeapon;
		}
		else oWeapon = OBJECT_INVALID;
	}
	else oWeapon = oRight;

	object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);
	object oOffhand;

	if (oLeft == OBJECT_INVALID)
	{
		object oLClaw = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCreature);

		if (GetIsObjectValid(oLClaw))
		{
			oOffhand = oLClaw;
		}
		else oOffhand = OBJECT_INVALID;
	}
	else oOffhand = oLeft;

	if ((GetHasFeat(FEAT_MONKEY_GRIP, oCreature) && GetIsObjectValid(oOffhand)))
	{
		return FALSE;
	}
	else if (GetIsLightWeapon(oWeapon, oCreature) && GetWeaponSize(oCreature) >= GetCreatureSize(oCreature) && !GetIsObjectValid(oOffhand))
	{
		return FALSE;
	}
	else if (GetWeaponSize(oCreature) >= GetCreatureSize(oCreature) && !GetIsObjectValid(oOffhand))
	{
		return TRUE;
	}
	else return FALSE;
}

//Function to determine whether a creature is using a ranged weapon
int IsWeaponRanged(object oCreature=OBJECT_SELF)
{
	object oWeapon=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature);
	if (GetWeaponRanged(oWeapon)) return TRUE;
	return FALSE;
}

// Wrapper function for the PlayCustomAnimation Function (duh)
void WrapperPlayCustomAnimation(object oPC, string sAnimation, int nLoop, float fSpeed = 1.0f)
{
	PlayCustomAnimation(oPC, sAnimation, nLoop, fSpeed);
}

// Wrapper for CreateObject.
void WrapperCreateObject(int nObjectType, string sTemplate, location lLocation, int bUseAppearAnimation=FALSE, string sNewTag="")
{
	CreateObject(nObjectType, sTemplate, lLocation, bUseAppearAnimation, sNewTag);
}

// Wrapper for CreateItemOnObject.
void WrapperCreateItemOnObject(string sItemTemplate, object oTarget=OBJECT_SELF, int nStackSize=1, string sNewTag="", int bDisplayFeedback=1)
{
	CreateItemOnObject(sItemTemplate, oTarget, nStackSize, sNewTag, bDisplayFeedback);
}

// Wrapper for FeatAdd.
void WrapperFeatAdd(object oPC, int nFeat, int bCheckRequirements, int bFeedback=FALSE, int bNotice=FALSE)
{
	FeatAdd(oPC, nFeat, bCheckRequirements, bFeedback, bNotice);
}

// Wrapper for SetWeaponVisibility.
// -nVisible: 0 for invisibile, 1 for visible, and 4 is default engine action.
// -nType: 0 - weapon, 1 - helm, 2 - both.
void WrapperSetWeaponVisibility(object oPC, int nVisable, int nType)
{
	SetWeaponVisibility(oPC, nVisable, nType);
}

// Wrapper for CopyItem
void WrapperCopyItem(object oItem, object oTargetInventory = OBJECT_INVALID, int bCopyVars = FALSE)
{
	CopyItem(oItem, oTargetInventory, bCopyVars);
}

// Checks a Player's current class levels to determine sneak attack and death attack dice.
int GetSneakAttackDice(object oSneakAttacker = OBJECT_SELF)
{
/*	Drammel's note: Assassin's Stance runs as a damage bonus effect and therefore should be
	picked up by GenerateAttackEffect.  No need to include it here. */
	
	int nDice = 0;
	int nClassLevel = 0;
	
	nClassLevel = GetLevelByClass(CLASS_TYPE_ARCANETRICKSTER, oSneakAttacker);	
	if (nClassLevel > 1)
	{
		nDice = nDice + nClassLevel / 2;
	}
		
	nClassLevel = GetLevelByClass(CLASS_TYPE_ASSASSIN, oSneakAttacker);
	if (nClassLevel > 0)
	{
		nDice = nDice + (nClassLevel + 1) / 2;
	}

	nClassLevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD, oSneakAttacker);	
	if (nClassLevel > 3)
	{
		nDice = nDice + (nClassLevel - 1) / 3;
	}

	if (GetLevelByClass(CLASS_NWNINE_WARDER, oSneakAttacker) > 2)
	{
		nDice = nDice + 2;
	}		
			
	nClassLevel = GetLevelByClass(CLASS_TYPE_ROGUE, oSneakAttacker);
	if (nClassLevel > 0)
	{
		nDice = nDice + (nClassLevel + 1) / 2;
	}
	
	nClassLevel = GetLevelByClass(CLASS_TYPE_SHADOWTHIEFOFAMN, oSneakAttacker);
	if (nClassLevel > 0)
	{
		nDice = nDice + (nClassLevel + 1) / 2;
	}
	
	if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_10))
	{
		nDice += 10;
	}
	else if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_9))
	{
		nDice += 9;
	}
	else if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_8))
	{
		nDice += 8;
	}
	else if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_7))
	{
		nDice += 7;
	}
	else if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_6))
	{
		nDice += 6;
	}
	else if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_5))
	{
		nDice += 5;
	}
	else if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_4))
	{
		nDice += 4;
	}
	else if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_3))
	{
		nDice += 3;
	}
	else if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_2))
	{
		nDice += 2;
	}
	else if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_1))
	{
		nDice += 1;
	}
	return nDice;
}

// Returns the number of levels oTarget has in a class that can sneak attack.
int GetSneakLevels(object oTarget)
{
	int nClassLevel = 0;
	int nSneakLevels = 0;

	nClassLevel = GetLevelByClass(CLASS_TYPE_ARCANETRICKSTER, oTarget);
	if (nClassLevel > 1)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}
		
	nClassLevel = GetLevelByClass(CLASS_TYPE_ASSASSIN, oTarget);
	if (nClassLevel > 0)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}

	nClassLevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD, oTarget);
	if (nClassLevel > 3)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}

	if (GetLevelByClass(CLASS_NWNINE_WARDER, oTarget) > 2)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}

	nClassLevel = GetLevelByClass(CLASS_TYPE_ROGUE, oTarget);
	if (nClassLevel > 0)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}

	nClassLevel = GetLevelByClass(CLASS_TYPE_SHADOWTHIEFOFAMN, oTarget);
	if (nClassLevel > 0)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}
	return nSneakLevels;
}

// Determines if oTarget has concealment from oSneakAttacker.
int IsTargetConcealed(object oTarget, object oSneakAttacker)
{
	int bIsConcealed = FALSE;

	int bAttackerHasTrueSight = GetHasEffect(EFFECT_TYPE_TRUESEEING, oSneakAttacker);
	int bAttackerCanSeeInvisble = GetHasEffect(EFFECT_TYPE_SEEINVISIBLE, oSneakAttacker);
	int bAttackerUltraVision = GetHasEffect(EFFECT_TYPE_ULTRAVISION, oSneakAttacker);

	if(GetHasFeat(FEAT_EPIC_SELF_CONCEALMENT_50, oTarget))
		bIsConcealed = TRUE;
	else if(GetHasFeat(FEAT_EPIC_SELF_CONCEALMENT_40, oTarget))
		bIsConcealed = TRUE;
	else if(GetHasFeat(FEAT_EPIC_SELF_CONCEALMENT_30, oTarget))
		bIsConcealed = TRUE;
	else if(GetHasFeat(FEAT_EPIC_SELF_CONCEALMENT_20, oTarget))
		bIsConcealed = TRUE;
	else if(GetHasFeat(FEAT_EPIC_SELF_CONCEALMENT_10, oTarget))
		bIsConcealed = TRUE;
	else if(!GetObjectSeen(oTarget, oSneakAttacker)) // Removed the mode check because initiating a strike seems to jump out of Stealth before the check is made.
		bIsConcealed = TRUE;
	else if(GetHasEffect(EFFECT_TYPE_SANCTUARY, oTarget) && !bAttackerHasTrueSight)
		bIsConcealed = TRUE;
	else if(GetHasEffect(EFFECT_TYPE_INVISIBILITY, oTarget) && !bAttackerHasTrueSight && !bAttackerCanSeeInvisble)
		bIsConcealed = TRUE;
	else if(GetHasEffect(EFFECT_TYPE_DARKNESS, oTarget) && !bAttackerHasTrueSight && !bAttackerUltraVision)
		bIsConcealed = TRUE;
	else if(GetHasFeatEffect(FEAT_EMPTY_BODY, oTarget))
		bIsConcealed = TRUE;
	else if(GetHasEffect(EFFECT_TYPE_ETHEREAL, oTarget) && !bAttackerHasTrueSight && !bAttackerCanSeeInvisble)
		bIsConcealed = TRUE;
	else if(GetHasEffect(EFFECT_TYPE_CONCEALMENT, oTarget) && !bAttackerHasTrueSight)
		bIsConcealed = TRUE;

	if (GetHasEffect(EFFECT_TYPE_CONCEALMENT_NEGATED, oTarget))
	{
		bIsConcealed = FALSE;
	}
	else if ((GetHasFeat(2031, oSneakAttacker)) && (GetIsSpirit(oTarget))) // Ghost Warrior
	{
		bIsConcealed = FALSE;
	}

     return bIsConcealed;
}

// Determines how wide across the target is.
// This is more of a practical way to determine squares than it is real size.
float GetGirth(object oTarget)
{
	int nSize = GetAppearanceType(oTarget);
	float fGirth = tob_Get2daFloat("appearance", "PREFATCKDIST", nSize);

	return fGirth;
}

// Determines if the PC is flanking the target or not.  Returns TRUE if they are.
int IsFlankValid(object oPC, object oTarget)
{
	object oFlanker, oWeapon;
	location lPC = GetLocation(oPC);
	float fWeapon = GetMeleeRange(oPC);
	float fFace = GetFacing(oPC); // Doesn't appear to update sometimes.  Possibly the reason that normal sneak attacks can sometimes miss from a perfect flank and hit from odd places.
	float fFoeGirth = GetGirth(oTarget);
	float fRange = FeetToMeters(30.0f) + fFoeGirth;
	float fFoeDist = GetDistanceBetween(oPC, oTarget);
	float fFlankerRange, fDistance, fFlankerFace, fMaxFlankDistance;
	int nFlank, nFlankFace, nDamageType;

	nFlank = FALSE;
	oFlanker = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);

	if ((oFlanker != oPC) && (!GetIsReactionTypeHostile(oFlanker, oPC))) // Don't bother if we don't need to.
	{
		fFlankerRange = GetMeleeRange(oFlanker);
		fMaxFlankDistance = fFoeGirth + fFlankerRange + fWeapon + 0.1f;
		fDistance = GetDistanceBetween(oPC, oFlanker);
		fFlankerFace = GetFacing(oFlanker);
		nFlankFace = IsDirectionWithinTolerance(fFace, fFlankerFace, 135.0f);
	}

	while (GetIsObjectValid(oFlanker))
	{
		if (GetLocalInt(oFlanker, "OverrideFlank") == 1)
		{
			nFlank = TRUE;
			return nFlank;
		}
		else if ((!GetIsReactionTypeHostile(oFlanker, oPC)) && (oFlanker != oPC) && (nFlankFace == FALSE) && (fDistance <= fMaxFlankDistance) && (fDistance > fFoeDist) && (GetIsObjectValid(oTarget)) && (GetAttackTarget(oFlanker) == oTarget))
		{
			nFlank = TRUE;
			return nFlank;
		}
		else oFlanker = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);
		
		if ((oFlanker != oPC) && (!GetIsReactionTypeHostile(oFlanker, oPC))) // Don't bother if we don't need to.
		{
			fFlankerRange = GetMeleeRange(oFlanker);
			fMaxFlankDistance = fFoeGirth + fFlankerRange + fWeapon + 0.1f;
			fDistance = GetDistanceBetween(oPC, oFlanker);
			fFlankerFace = GetFacing(oFlanker);
			nFlankFace = IsDirectionWithinTolerance(fFace, fFlankerFace, 135.0f);
		}
	}
	return nFlank;
}
	
// Sneak Attack can't be used against targets with concealment
int IsTargetValidForSneakAttack(object oTarget, object oSneakAttacker)
{
	float fDist = GetDistanceBetween(oSneakAttacker, oTarget);
	float fThirtysomething = FeetToMeters(30.0f) + GetGirth(oSneakAttacker) - GetGirth(oTarget);

	//Don't bother if the target is out of range
	if (fDist <= fThirtysomething)
	{
		//Don't bother if the target is concealed
		if (IsTargetConcealed(oTarget, oSneakAttacker))
		{
			return FALSE;
		}

		int nSneakLevels = GetSneakLevels(oSneakAttacker);

		if (GetHasFeat(FEAT_IMPROVED_UNCANNY_DODGE, oTarget, TRUE))
		{
			if (nSneakLevels > (GetSneakLevels(oTarget) + 3) ) // Need to be >= Target Dice + 4
			{
				return FALSE;
			}
		}

		if (nSneakLevels < 1)
		{
			return FALSE;
		}

		object oAttackedByTarget = GetAttackTarget(oTarget);

		if (IsTargetConcealed(oSneakAttacker, oTarget) == TRUE)
		{
			return TRUE;
		}
		else if (!GetIsInCombat(oTarget))
		{
			return TRUE; // Flat-footed.
		}
		else if (GetLocalInt(oTarget, "OverrideFlatFootedAC") == 1)
		{
			return TRUE;
		}
		else if (oAttackedByTarget == oSneakAttacker) //Head to Head requires the target be unable to defend themself.
		{
    		if (GetHasEffect(EFFECT_TYPE_STUNNED, oTarget) || GetHasEffect(EFFECT_TYPE_BLINDNESS, oTarget)
   		 	|| GetHasEffect(EFFECT_TYPE_PARALYZE, oTarget) || GetHasEffect(EFFECT_TYPE_SLEEP, oTarget)
   		 	|| GetHasEffect(EFFECT_TYPE_PETRIFY, oTarget) || GetHasEffect(EFFECT_TYPE_CUTSCENE_PARALYZE, oTarget))
			{
				return TRUE;
			}
		}
		else if (IsFlankValid(oSneakAttacker, oTarget) == TRUE) //Listed as 'else if' because if we're already a target the flank doesn't matter.
		{
			return TRUE;
		}
	}
	return FALSE;
}

// Does the same thing as TurnToFaceObject except that it checks for range and if oPC and oTarget are alive.
void WatchOpponent(object oTarget, object oPC = OBJECT_SELF)
{
	if ((GetCurrentHitPoints(oTarget) > 0) && (GetCurrentHitPoints(oPC) > 0))
	{
		// Must add HITDIST to the preload data when I get it sorted out.
		float fRange = GetMeleeRange(oPC) + tob_Get2daFloat("appearance", "HITDIST", GetAppearanceType(oTarget));
		
		if (GetDistanceToObject(oTarget) <= fRange)
		{
			TurnToFaceObject(oTarget, oPC);
		}
	}
}

// Clears the variables that govern the Quickstrike menu.
// -sClass: Determines which class's menu is cleared.
void ClearBoxes(string sClass)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");
	int i;
	string sClassy;

	if (sClass == "")
	{
		sClassy = "___";
	}
	else if (sClass == "CR")
	{
		sClassy = "_CR";
	}
	else if (sClass == "SA")
	{
		sClassy = "_SA";
	}
	else if (sClass == "SS")
	{
		sClassy = "_SS";
	}
	else if (sClass == "WB")
	{
		sClassy = "_WB";
	}

	string sUse;

	if (GetStringLeft(sClass, 1) == "_")
	{
		sUse = sClass;
	}
	else sUse = sClassy;

	// Maneuvers Known variables.

	DeleteLocalInt(oToB, "Known" + sUse + "1Row1" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "1Row2" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "1Row3" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "1Row4" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "1Row5" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "1Row6" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "1Row7" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "1Row8" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "1Row9" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "1Row10" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "2Row1" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "2Row2" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "2Row3" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "2Row4" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "2Row5" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "2Row6" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "2Row7" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "2Row8" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "2Row9" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "2Row10" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "3Row1" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "3Row2" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "3Row3" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "3Row4" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "3Row5" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "3Row6" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "3Row7" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "3Row8" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "3Row9" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "3Row10" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "4Row1" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "4Row2" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "4Row3" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "4Row4" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "4Row5" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "4Row6" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "4Row7" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "4Row8" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "4Row9" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "4Row10" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "5Row1" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "5Row2" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "5Row3" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "5Row4" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "5Row5" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "5Row6" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "5Row7" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "5Row8" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "5Row9" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "5Row10" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "6Row1" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "6Row2" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "6Row3" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "6Row4" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "6Row5" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "6Row6" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "6Row7" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "6Row8" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "6Row9" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "6Row10" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "7Row1" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "7Row2" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "7Row3" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "7Row4" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "7Row5" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "7Row6" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "7Row7" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "7Row8" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "7Row9" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "7Row10" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "8Row1" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "8Row2" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "8Row3" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "8Row4" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "8Row5" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "8Row6" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "8Row7" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "8Row8" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "8Row9" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "8Row10" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "9Row1" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "9Row2" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "9Row3" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "9Row4" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "9Row5" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "9Row6" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "9Row7" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "9Row8" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "9Row9" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "9Row10" + "Disabled");

	i = 1;

	while (i < 18) //RedBoxes
	{
		SetLocalInt(oToB, "RedBox" + IntToString(i) + sUse, 0);
		i++;
	}

	i = 1;

	while (i < 18) //Readied Maneuver values.
	{
		DeleteLocalString(oToB, "Readied" + IntToString(i) + sUse);
		DeleteLocalInt(oToB, "ReadiedRow" + IntToString(i) + sUse);
		DeleteLocalInt(oToB, "Readied" + IntToString(i) + sUse + "Disabled");
		i++;
	}

	i = 1;

	while (i < 11) //GreenBoxes
	{
		SetLocalInt(oToB, "GreenBoxB" + IntToString(i) + sUse, 0);
		i++;
	}

	i = 1;

	while (i < 11)
	{
		SetLocalInt(oToB, "GreenBoxC" + IntToString(i) + sUse, 0);
		i++;
	}

	i = 1;

	while (i < 21)
	{
		SetLocalInt(oToB, "GreenBoxSTR" + IntToString(i) + sUse, 0);
		i++;
	}

	i = 1;

	while (i < 11) //BlueBoxes
	{
		SetLocalInt(oToB, "BlueBoxB" + IntToString(i) + sUse, 0);
		i++;
	}

	i = 1;

	while (i < 11)
	{
		SetLocalInt(oToB, "BlueBoxC" + IntToString(i) + sUse, 0);
		i++;
	}

	i = 1;

	while (i < 21)
	{
		SetLocalInt(oToB, "BlueBoxSTR" + IntToString(i) + sUse, 0);
		i++;
	}
}

// Clears all of the data on the Maneuvers Known screen.
// -sClass: Determines which class's screen is cleared.
void ClearManeuversKnown(string sClass)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);

	if (sClass == "" || sClass == "__")
	{
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN", "STANCE_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN", "LEVEL1_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN", "LEVEL2_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN", "LEVEL3_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN", "LEVEL4_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN", "LEVEL5_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN", "LEVEL6_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN", "LEVEL7_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN", "LEVEL8_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN", "LEVEL9_LIST");
	}
	else
	{
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN" + "_" + sClass, "STANCE_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN" + "_" + sClass, "LEVEL1_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN" + "_" + sClass, "LEVEL2_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN" + "_" + sClass, "LEVEL3_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN" + "_" + sClass, "LEVEL4_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN" + "_" + sClass, "LEVEL5_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN" + "_" + sClass, "LEVEL6_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN" + "_" + sClass, "LEVEL7_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN" + "_" + sClass, "LEVEL8_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN" + "_" + sClass, "LEVEL9_LIST");
	}
}

// Clears all of the data on the Maneuvers Readied screen.
// -sClass: Determines which class's screen is cleared.
void ClearManeuversReadied(string sClass)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);

	if (sClass == "" || sClass == "__")
	{
		if (sClass == "SS")
		{
			ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_17");
		}

		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_1");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_2");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_3");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_4");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_5");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_6");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_7");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_8");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_9");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_10");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_11");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_12");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_13");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_14");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_15");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_16");
	}
	else
	{
		if (sClass == "SS")
		{
			ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_17");
		}

		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_1");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_2");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_3");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_4");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_5");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_6");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_7");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_8");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_9");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_10");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_11");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_12");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_13");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_14");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_15");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_16");
	}
}

// Clears all currently enqueued strikes.
void ClearStrikes()
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");

	int i;

	i = 1;

	while (GetLocalInt(oToB, "Strike" + IntToString(i)) > 0)
	{
		DeleteLocalInt(oToB, "Strike" + IntToString(i));
		i++;
	}
}

// Determines if oPC has line of effect to lTarget.
// This function will return false for anything that makes GetIsLocationValid
// return false.  In fact, this function checks the validity of every location
// between oPC and lTarget in small increments.
// -oPC: Object which serves as the source of the line of effect test.
// -lTarget: The location we're determining if oPC blocked to or not.
// -bTriggers: When set to TRUE also checks for triggers and returns FALSE if
// the function detects one in the line of effect.
int LineOfEffect(object oPC, location lTarget, int bTriggers = FALSE)
{
	object oArea = GetArea(oPC);
	object oSubArea;
	location lPC = GetLocation(oPC);
	vector vPC = GetPosition(oPC);
	vector vTarget = GetPositionFromLocation(lTarget);
	float fMax = GetDistanceBetweenLocations(lPC, lTarget);
	float fDest = GetAngle(vPC, vTarget, fMax);
	float fIncrement = FeetToMeters(0.1f);
	float fDistance;
	location lTest;
	vector vTest;
	int nReturn;

	nReturn = TRUE;
	fDistance = fIncrement;

	while (fDistance <= fMax)
	{
		lTest = GenerateNewLocation(oPC, fDistance, fDest, fDest);

		if (!GetIsLocationValid(lTest))
		{
			nReturn = FALSE;
			break;
		}

		if (bTriggers == TRUE)
		{
			vTest = GetPositionFromLocation(lTest);
			oSubArea = GetFirstSubArea(oArea, vTest);

			if (GetObjectType(oSubArea) == OBJECT_TYPE_TRIGGER)
			{
				if (!GetIsTrapped(oSubArea))
				{
					nReturn = FALSE;
					break;
				}
				else oSubArea = GetNextSubArea(oArea);
			}
			else oSubArea = GetNextSubArea(oArea);

			if (GetObjectType(oSubArea) == OBJECT_TYPE_TRIGGER) //Sometimes there is area overlap.
			{
				if (!GetIsTrapped(oSubArea))
				{
					nReturn = FALSE;
					break;
				}
				else oSubArea = GetNextSubArea(oArea);
			}
			else oSubArea = GetNextSubArea(oArea);

			if (GetObjectType(oSubArea) == OBJECT_TYPE_TRIGGER)
			{
				if (!GetIsTrapped(oSubArea))
				{
					nReturn = FALSE;
					break;
				}
				else oSubArea = GetNextSubArea(oArea);
			}
			else oSubArea = GetNextSubArea(oArea);

			if (GetObjectType(oSubArea) == OBJECT_TYPE_TRIGGER)
			{
				if (!GetIsTrapped(oSubArea))
				{
					nReturn = FALSE;
					break;
				}
				else oSubArea = GetNextSubArea(oArea);
			}
			else oSubArea = GetNextSubArea(oArea);

			if (GetObjectType(oSubArea) == OBJECT_TYPE_TRIGGER)
			{
				if (!GetIsTrapped(oSubArea))
				{
					nReturn = FALSE;
					break;
				}
				else oSubArea = GetNextSubArea(oArea);
			}
			else oSubArea = GetNextSubArea(oArea);
		}

		fDistance += fIncrement;
	}

	return nReturn;
}