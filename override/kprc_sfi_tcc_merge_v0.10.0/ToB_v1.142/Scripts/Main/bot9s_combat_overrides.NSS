//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 6/22/2009								//
//	Title:	bot9s_combat_overrides				//
//	Description: Scripts which manipulate and	//
//	govern the use of the functions	that bypass //
//	the default combat engine.					//
//////////////////////////////////////////////////

#include "bot9s_armor"
#include "bot9s_attack"
#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"

// Prototypes

// Overrides the number used in the calculation of the Target's AC value.
// -oTarget: The creature that we're determining AC for.
// -nType: 1 = Touch AC, 2 = Flat Footed AC, 3 = Specific AC.
// -nAC: Only valid when nType is equal to 3.  Allows you to set the AC to any number.
void OverrideAttackRollAC(object oTarget, int nType, int nAC = 0);

// Overrides the D20 roll component of the attack roll.
// -nNumber: Value of the roll.  Can actually be above 20 if you really want to.
void OverrideD20Roll(object oTarget, int nNumber);

// Overrides the critical confirmantion roll's result.
// -nNumber: Value of the roll.  Can actually be above 20 if you really want to.
// -bVS: When set to true a creature using a strike against oTarget will gain a
// bonus of nNumber to the critical confirmation roll.  Otherwise, this function
// treats nNumber as the exact number of the critical confirmation roll that
// oTarget makes.
void OverrideCritConfirmRoll(object oTarget, int nNumber, int bVS = FALSE);

// Overrides the player's attack bonus.
// -nNumber: Value of the bonus.
void OverrideAttackBonus(object oTarget, int nNumber);

// Overrides the player's weapon's critical range.
// -nNumber: Value of the minimum range.
void OverrideCritRange(object oTarget, int nNumber);

// Overrides the player's bonus to the critical confirmation roll.
// -nNumber: Value of the bonus.
void OverrideCritConfirmationBonus(object oTarget, int nNumber);

// Removes the override flags and variables for the combat overrides.
// -nType: Which kind of override we're clearing, if not all of them.
// 0 = all, 1 = Armor Class, 2 = d20 roll, 3 = Critical Confirmation Roll,
// 4 = Attack Bonus, 5 = Critical Range, 6 = Critical Confirmation Bonus,
// 7 = Hit Result, 8 = Flank.
void RemoveAttackRollOverride(object oTarget, int nType);

// Sets a bonus to hit for attacks of opportunity made while
// ManageCombatOverrides is active.
// -int nBonus: The bonus to the attack roll.
void OverrideAoOHitBonus(object oTarget, int nBonus);

// Sets a bonus to damage for attacks of opportunity made while
// ManageCombatOverrides is active.
// -int nBonus: The bonus to damage.
void OverrideAoODamageBonus(object oTarget, int nBonus);

// Flags oTarget as qualifying for a flank.
void OverrideFlank(object oTarget);

// Manages a basic attack for the main override function.
// -oCreature: The creature calling the function.  Should not be a monster.
// -oTarget: The creature an attack is being made against.  Should be a monster.
// -nBonus: Misc modifier to the attack roll.
// -oWeapon: Weapon used to make this attack.
// -bWarcry: Determines if the person calling the function uses their attack grunt.
// -bAnimation: Set to TRUE to play an attack animation.
// -bSwing: Plays the sound of the weapon being swung when set to TRUE.
void ManageAttack(object oCreature, object oTarget, int nBonus, object oWeapon, int bWarcry = TRUE, int bAnimation = FALSE, int bSwing = FALSE);

// Sets the location of oFoe once a second for the attacks of opportunity override.
void ManageAoOLocations(object oCreature, object oWeapon);

// Simulates attacks of opportunity while ManageCombatOverrides is running.
void ManageAttacksOfOpportunity(object oCreature, object oWeapon);

// Uses the function ClearCombatOverrides when the person using the function
// is not currently engaged in a conversation.  If they are, this function will
// repeat itself until the person is out of a conversation.  This has been
// implemented to prevent issues with cutscenes.
void ProtectedClearCombatOverrides(object oCreature);

// Manages the use of the function SetCombatOverrides so that it can be used 
// by multiple maneuvers and allow the correct results of a combat round to be 
// determined with the combined data.  Precautions are taken so that this will 
// not interfere with a cutscene.  oCreature's default combat information is 
// normally used when -1 is entered as a parameter.
// -bModifyRounds: With a certain degree of timing, allows the PC to modify the
// results of indvidual attacks in the round.  Must be set to TRUE to fuction.
// -oCreature: The creature to set the overrides on.
// -oTarget: This should be a creature, door, or placeable. Setting this to
// OBJECT_INVALID will set oTarget to the current target oCreature has an action
// queued against.
// -nOnHandAttacks, nOffHandAttacks: Vaild for only 1-6.
// -nAttackResult: Uses the constants OVERRIDE_ATTACK_RESULT_* to set and attack's
// result as a Miss, Hit, Critical, Parry, or Defualt roll.
// -nMinDamage, nMaxDamage: Random damage range of the attack on a hit.
// -bSuppressBroadcastAOO: If TRUE then this creature can potentially cause an 
// attack of opportunity from nearby creatures. If FALSE, this will be supressed.
// -bSuppressMakeAOO: If TRUE then this creature will make attacks of opportunity
// when they are available. If FALSE, this will be supressed.  Testing shows that
// a PC's Plot flag must also be set to TRUE for this to work.
void ManageCombatOverrides(int bModifyRounds = FALSE, object oCreature = OBJECT_SELF, object oTarget = OBJECT_INVALID, int nOnHandAttacks = -1, int nOffHandAttacks = -1, int nAttackResult = OVERRIDE_ATTACK_RESULT_DEFAULT, int nMinDamage = -1, int nMaxDamage = -1, int bSuppressBroadcastAOO = TRUE, int bSuppressMakeAOO = TRUE);

// Functions

// Overrides the number used in the calculation of the Target's AC value.
// -oTarget: The creature that we're determining AC for.
// -nType: 1 = Touch AC, 2 = Flat Footed AC, 3 = Specific AC.
// -nAC: Only valid when nType is equal to 3.  Allows you to set the AC to any number.
void OverrideAttackRollAC(object oTarget, int nType, int nAC = 0)
{
	if (nType == 1)
	{
		SetLocalInt(oTarget, "OverrideTouchAC", 1);
	}
	else if (nType == 2)
	{
		SetLocalInt(oTarget, "OverrideFlatFootedAC", 1);
	}
	else if (nType == 3)
	{
		SetLocalInt(oTarget, "OverrideAC", nAC);
	}
}

// Overrides the D20 roll component of the attack roll.
// -nNumber: Value of the roll.  Can actually be above 20 if you really want to.
void OverrideD20Roll(object oTarget, int nNumber)
{
	SetLocalInt(oTarget, "OverrideD20", 1);
	SetLocalInt(oTarget, "D20OverrideNum", nNumber);
}

// Overrides the critical confirmantion roll's result.
// -nNumber: Value of the roll.  Can actually be above 20 if you really want to.
// -bVS: When set to true a creature using a strike against oTarget will gain a
// bonus of nNumber to the critical confirmation roll.  Otherwise, this function
// treats nNumber as the exact number of the critical confirmation roll that
// oTarget makes.
void OverrideCritConfirmRoll(object oTarget, int nNumber, int bVS = FALSE)
{
	if (bVS == FALSE)
	{
		SetLocalInt(oTarget, "OverrideCritConfirm", 1);
	}
	else SetLocalInt(oTarget, "OverrideCritConfirm", 2);

	SetLocalInt(oTarget, "CCOverrideNum", nNumber);
}

// Overrides the player's attack bonus.
// -nNumber: Value of the bonus.
void OverrideAttackBonus(object oTarget, int nNumber)
{
	SetLocalInt(oTarget, "OverrideAttackBonus", 1);
	SetLocalInt(oTarget, "ABOverrideNum", nNumber);
}

// Overrides the player's weapon's critical range.
// -nNumber: Value of the minimum range.
void OverrideCritRange(object oTarget, int nNumber)
{
	SetLocalInt(oTarget, "OverrideCritRange", 1);
	SetLocalInt(oTarget, "CROverrideNum", nNumber);
}

// Overrides the player's bonus to the critical confirmation roll.
// -nNumber: Value of the bonus.
void OverrideCritConfirmationBonus(object oTarget, int nNumber)
{
	SetLocalInt(oTarget, "OverrideCritConfirmBonus", 1);
	SetLocalInt(oTarget, "CCBOverrideNum", nNumber);
}

// Overrides the result of the attack roll.
// -nNumber: 0 = Miss, 1 = Hit, 2 = Critical Hit.
void OverrideHit(object oTarget, int nNumber)
{
	SetLocalInt(oTarget, "OverrideHit", 1);
	SetLocalInt(oTarget, "HitOverrideNum", nNumber);
}

// Removes the override flags and variables for the combat overrides.
// -nType: Which kind of override we're clearing, if not all of them.
// 0 = all, 1 = Armor Class, 2 = d20 roll, 3 = Critical Confirmation Roll,
// 4 = Attack Bonus, 5 = Critical Range, 6 = Critical Confirmation Bonus,
// 7 = Hit Result, 8 = Flank.
void RemoveAttackRollOverride(object oTarget, int nType)
{
	if (nType == 0 || nType == 1)
	{
		DeleteLocalInt(oTarget, "OverrideTouchAC");
		DeleteLocalInt(oTarget, "OverrideFlatFootedAC");
		DeleteLocalInt(oTarget, "OverrideAC");
	}

	if (nType == 0 || nType == 2)
	{
		DeleteLocalInt(oTarget, "OverrideD20");
		DeleteLocalInt(oTarget, "D20OverrideNum");
	}

	if (nType == 0 || nType == 3)
	{
		DeleteLocalInt(oTarget, "OverrideCritConfirm");
		DeleteLocalInt(oTarget, "CCOverrideNum");
	}

	if (nType == 0 || nType == 4)
	{
		DeleteLocalInt(oTarget, "OverrideAttackBonus");
		DeleteLocalInt(oTarget, "ABOverrideNum");
	}

	if (nType == 0 || nType == 5)
	{
		DeleteLocalInt(oTarget, "OverrideCritRange");
		DeleteLocalInt(oTarget, "CROverrideNum");
	}

	if (nType == 0 || nType == 6)
	{
		DeleteLocalInt(oTarget, "OverrideCritConfirmBonus");
		DeleteLocalInt(oTarget, "CCBOverrideNum");
	}

	if (nType == 0 || nType == 7)
	{
		DeleteLocalInt(oTarget, "OverrideHit");
		DeleteLocalInt(oTarget, "HitOverrideNum");
	}

	if (nType == 0 || nType == 8)
	{
		DeleteLocalInt(oTarget, "OverrideFlank");
	}
}

// Sets a bonus to hit for attacks of opportunity made while
// ManageCombatOverrides is active.
// -int nBonus: The bonus to the attack roll.
void OverrideAoOHitBonus(object oTarget, int nBonus)
{
	SetLocalInt(oTarget, "OverrideAoOHitBonus", nBonus);
}

// Sets a bonus to damage for attacks of opportunity made while
// ManageCombatOverrides is active.
// -int nBonus: The bonus to damage.
void OverrideAoODamageBonus(object oTarget, int nBonus)
{
	SetLocalInt(oTarget, "OverrideAoODamageBonus", nBonus);
}

// Flags oTarget as qualifying for a flank.
void OverrideFlank(object oTarget)
{
	SetLocalInt(oTarget, "OverrideFlank", 1);
}

// Manages a basic attack for the main override function.
// -oCreature: The creature calling the function.  Should not be a monster.
// -oTarget: The creature an attack is being made against.  Should be a monster.
// -nBonus: Misc modifier to the attack roll.
// -oWeapon: Weapon used to make this attack.
// -bWarcry: Determines if the person calling the function uses their attack grunt.
// -bAnimation: Set to TRUE to play an attack animation.
// -bSwing: Plays the sound of the weapon being swung when set to TRUE.
void ManageAttack(object oCreature, object oTarget, int nBonus, object oWeapon, int bWarcry = TRUE, int bAnimation = FALSE, int bSwing = FALSE)
{
	float fDist = GetDistanceBetween(oCreature, oTarget);
	float fRange = GetMeleeRange(oCreature);

	if ((GetCurrentAction(oCreature) == ACTION_ATTACKOBJECT) && (fDist <= fRange) && (GetCurrentHitPoints(oTarget) > 0))
	{
		if ((oWeapon == OBJECT_INVALID) && (oWeapon != GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature)))
		{
			oWeapon = GetItemInSlot(INVENTORY_SLOT_ARMS, oCreature); //Love for monks.
		}

		int nHit = StrikeAttackRoll(oWeapon, oTarget, nBonus);

		if (bAnimation == TRUE)
		{
			BasicAttackAnimation(oWeapon, nHit, TRUE);
		}

		if (bSwing == TRUE)
		{
			StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f, bWarcry);
		}

		DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));

		if ((GetHasFeat(FEAT_CIRCLE_KICK, oCreature)) && (GetLocalInt(oCreature, "mimic_circle_k") == 0) && (nHit > 0))
		{
			if ((oWeapon == OBJECT_INVALID) || (oWeapon == GetItemInSlot(INVENTORY_SLOT_ARMS, oCreature)))
			{
				SetLocalInt(oCreature, "mimic_circle_k", 1);// One per round.
				DelayCommand(6.0f, SetLocalInt(oCreature, "mimic_circle_k", 0));

				location lCreature = GetLocation(oCreature);
				object oCircle;

				oCircle = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lCreature);
	
				while (GetIsObjectValid(oCircle))
				{
					if ((oCircle != oTarget) && (GetIsReactionTypeHostile(oCircle, oCreature)))
					{
						int nCircle = StrikeAttackRoll(oWeapon, oCircle);

						DelayCommand(0.7f, StrikeWeaponDamage(oWeapon, nCircle, oCircle));
						DelayCommand(0.7f, WrapperPlayCustomAnimation(oCreature, "*kickcircle", 0));
						break;
					}

					oCircle = GetNextObjectInShape(SHAPE_SPHERE, fRange, lCreature);
				}
			}
		}
	}
	else if ((GetIsInCombat(oCreature)) && (GetCurrentHitPoints(oTarget) > 0))
	{
		DelayCommand(0.01f, ManageAttack(oCreature, oTarget, nBonus, oWeapon, bWarcry, bAnimation, bSwing));
	}
}

// Sets the location of oFoe once a second for the attacks of opportunity override.
void ManageAoOLocations(object oCreature, object oWeapon)
{
	location lCreature = GetLocation(oCreature);
	int nHalt = GetLocalInt(oCreature, "Halt_AoO_override_loc");

	if ((nHalt == 0) && (GetLocalInt(oCreature, "bot9s_overridestate") == 1) && (!GetWeaponRanged(oWeapon)) && (lCreature == (GetLocalLocation(oCreature, "bot9s_pc_pos_per_sec"))) && (!GetStealthMode(oCreature)))
	{
		float fReach = GetMeleeRange(oCreature);
		object oFoe;
		location lFoe;

		if ((GetLocalInt(oCreature, "DancingBladeForm") == 1) && (GetLocalInt(oCreature, "BurningBrand") != 1))
		{
			fReach -= FeetToMeters(5.0f); // This stance doesn't apply its reach to AoO.
		}

		oFoe = GetFirstObjectInShape(SHAPE_SPHERE, fReach, lCreature, TRUE);

		while (GetIsObjectValid(oFoe))
		{
			if (GetIsReactionTypeHostile(oFoe, oCreature))
			{
				lFoe = GetLocation(oFoe);
				SetLocalLocation(oFoe, "bot9s_override_AoO_loc", lFoe);
			}

			oFoe = GetNextObjectInShape(SHAPE_SPHERE, fReach, lCreature, TRUE);
		}

		DelayCommand(1.0f, ManageAoOLocations(oCreature, oWeapon));
	}
	else DeleteLocalInt(oCreature, "Halt_AoO_override_loc");
}

// Simulates attacks of opportunity while ManageCombatOverrides is running.
void ManageAttacksOfOpportunity(object oCreature, object oWeapon)
{
	location lCreature = GetLocation(oCreature);

	if ((GetLocalInt(oCreature, "bot9s_overridestate") == 1) && (!GetWeaponRanged(oWeapon)) && (lCreature == (GetLocalLocation(oCreature, "bot9s_pc_pos_per_sec"))) && (!GetStealthMode(oCreature)))
	{
		SetLocalInt(oCreature, "bot9s_AoO_overridestate", 1);

		float fReach = GetMeleeRange(oCreature);
		object oFoe;
		location lOld;

		if ((GetLocalInt(oCreature, "DancingBladeForm") == 1) && (GetLocalInt(oCreature, "BurningBrand") != 1))
		{
			fReach -= FeetToMeters(5.0f); // This stance doesn't apply its reach to AoO.
		}

		oFoe = GetFirstObjectInShape(SHAPE_SPHERE, fReach, lCreature, TRUE);

		while (GetIsObjectValid(oFoe))
		{
			if (GetIsReactionTypeHostile(oFoe, oCreature))
			{
				if ((GetCurrentAction(oFoe) == ACTION_MOVETOPOINT) || ((GetCurrentAction(oFoe) == ACTION_ATTACKOBJECT) && (GetAttackTarget(oFoe) != oCreature)))
				{
					lOld = GetLocalLocation(oFoe, "bot9s_override_AoO_loc");

					float fFoe = GetDistanceBetween(oFoe, oCreature);
					float fOld = GetDistanceBetweenLocations(lCreature, lOld);

					if ((fOld <= fReach) && (fFoe > fReach))
					{
						int nBonusHit = GetLocalInt(oCreature, "OverrideAoOHitBonus");
						int nBonusDamage = GetLocalInt(oCreature, "OverrideAoODamageBonus");
						int nHit = StrikeAttackRoll(oWeapon, oFoe, nBonusHit, TRUE);

						StrikeWeaponDamage(oWeapon, nHit, oFoe, nBonusDamage);
						SetLocalInt(oCreature, "Halt_AoO_override_loc", 1);
						SetLocalInt(oCreature, "bot9s_AoO_overridestate", 0);
						return; //One per round.
					}
				}
				else if ((GetCurrentAction(oFoe) == ACTION_CASTSPELL) && (GetLocalInt(oFoe, "bot9s_maneuver_running") < 1))
				{
					int nBonusHit = GetLocalInt(oCreature, "OverrideAoOHitBonus");
					int nBonusDamage = GetLocalInt(oCreature, "OverrideAoODamageBonus");
					int nHit = StrikeAttackRoll(oWeapon, oFoe, nBonusHit, TRUE);

					StrikeWeaponDamage(oWeapon, nHit, oFoe, nBonusDamage);
					SetLocalInt(oCreature, "Halt_AoO_override_loc", 1);
					SetLocalInt(oCreature, "bot9s_AoO_overridestate", 0);
					return; //One per round.
				}
				else if (GetCurrentAction(oFoe) == ACTION_TAUNT)
				{
					int nBonusHit = GetLocalInt(oCreature, "OverrideAoOHitBonus");
					int nBonusDamage = GetLocalInt(oCreature, "OverrideAoODamageBonus");
					int nHit = StrikeAttackRoll(oWeapon, oFoe, nBonusHit, TRUE);

					StrikeWeaponDamage(oWeapon, nHit, oFoe, nBonusDamage);
					SetLocalInt(oCreature, "Halt_AoO_override_loc", 1);
					SetLocalInt(oCreature, "bot9s_AoO_overridestate", 0);
					return; //One per round.
				}
			}

			oFoe = GetNextObjectInShape(SHAPE_SPHERE, fReach, lCreature, TRUE);
		}

		DelayCommand(1.0f, ManageAttacksOfOpportunity(oCreature, oWeapon));
	}
	else DeleteLocalInt(oCreature, "bot9s_AoO_overridestate");
}

// Uses the function ClearCombatOverrides when the person using the function
// is not currently engaged in a conversation.  If they are, this function will
// repeat itself until the person is out of a conversation.  This has been
// implemented to prevent issues with cutscenes.
void ProtectedClearCombatOverrides(object oCreature)
{
	DeleteLocalInt(oCreature, "bot9s_overridestate");
	DeleteLocalInt(oCreature, "bot9s_AoO_overridestate");
	DeleteLocalInt(oCreature, "Halt_AoO_override_loc");
	DeleteLocalObject(oCreature, "LastFoe");

	if ((!IsInConversation(oCreature)) && (GetNumCutsceneActionsPending() == 0))
	{
		ClearCombatOverrides(oCreature);
	}
	else DelayCommand(0.1f, ProtectedClearCombatOverrides(oCreature));
}

// Manages the use of the function SetCombatOverrides so that it can be used 
// by multiple maneuvers and allow the correct results of a combat round to be 
// determined with the combined data.  Precautions are taken so that this will 
// not interfere with a cutscene.  oCreature's default combat information is 
// normally used when -1 is entered as a parameter.
// -bModifyRounds: With a certain degree of timing, allows the PC to modify the
// results of indvidual attacks in the round.  Must be set to TRUE to fuction.
// -oCreature: The creature to set the overrides on.
// -oTarget: This should be a creature, door, or placeable. Setting this to
// OBJECT_INVALID will set oTarget to the current target oCreature has an action
// queued against.
// -nOnHandAttacks, nOffHandAttacks: Vaild for only 1-6.
// -nAttackResult: Uses the constants OVERRIDE_ATTACK_RESULT_* to set and attack's
// result as a Miss, Hit, Critical, Parry, or Defualt roll.
// -nMinDamage, nMaxDamage: Random damage range of the attack on a hit.
// -bSuppressBroadcastAOO: If TRUE then this creature can potentially cause an 
// attack of opportunity from nearby creatures. If FALSE, this will be supressed.
// -bSuppressMakeAOO: If TRUE then this creature will make attacks of opportunity
// when they are available. If FALSE, this will be supressed.  Testing shows that
// a PC's Plot flag must also be set to TRUE for this to work.
void ManageCombatOverrides(int bModifyRounds = FALSE, object oCreature = OBJECT_SELF, object oTarget = OBJECT_INVALID, int nOnHandAttacks = -1, int nOffHandAttacks = -1, int nAttackResult = OVERRIDE_ATTACK_RESULT_DEFAULT, int nMinDamage = -1, int nMaxDamage = -1, int bSuppressBroadcastAOO = TRUE, int bSuppressMakeAOO = TRUE)
{
	object oFoe; // oTarget only returns a valid target after it has been passed into SetCombatOverrides.

	oFoe = GetAttackTarget(oCreature);

	if (GetIsObjectValid(oFoe)) // GetAttackTarget clears at the end of combat rounds.  This is to fill in the gaps.
	{
		SetLocalObject(oCreature, "LastFoe", oFoe);
	}
	else if ((!GetIsObjectValid(oFoe)) && (!GetIsObjectValid(GetLocalObject(oCreature, "LastFoe"))))
	{
		DelayCommand(0.01f, ManageCombatOverrides(TRUE));
		SetLocalInt(oCreature, "bot9s_overridestate", 2);
		return; //Should help pinpoint the beginning of the combat round a little more.
	}
	else oFoe = GetLocalObject(oCreature, "LastFoe");

	float fEight = FeetToMeters(8.0f); // Maximum range the engine allows a melee attack to be made at.
	float fMelee = GetMeleeRange(oCreature);
	float fRange;

	if (fMelee > fEight)
	{
		fRange = fMelee;
	}
	else fRange = fEight;

	float fDist = GetDistanceBetween(oCreature, oFoe);
	int nRangeCheck;

	if (fDist <= fRange)
	{
		nRangeCheck = 1;
	}
	else if (IsWeaponRanged(oCreature))
	{
		float fArrow = GetWeaponRange(oCreature);

		if (fDist <= fArrow)
		{
			nRangeCheck = 1;
		}
		else nRangeCheck = 0;
	}
	else nRangeCheck = 0;

	if ((IsInConversation(oCreature)) || (GetNumCutsceneActionsPending() > 0))
	{
		return; // Prevent massive bugs if there's a cutscene in progress.
	}
	else if ((GetIsInCombat(oCreature)) && (GetCurrentAction(oCreature) == ACTION_ATTACKOBJECT) && (nRangeCheck == 1) && (GetCurrentHitPoints(oFoe) > 0))
	{
		SetLocalInt(oCreature, "bot9s_overridestate", 1);
		DelayCommand(5.99f, SetLocalInt(oCreature, "bot9s_overridestate", 0));
		DelayCommand(5.99f, DeleteLocalInt(oCreature, "OverrideAoOHitBonus"));
		DelayCommand(5.99f, DeleteLocalInt(oCreature, "OverrideAoODamageBonus"));

		if (bModifyRounds == TRUE)
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
			int nLeft = GetBaseItemType(oLeft);
			object oOffhand;
		
			if (oLeft == OBJECT_INVALID || nLeft == BASE_ITEM_LARGESHIELD || nLeft == BASE_ITEM_SMALLSHIELD || nLeft == BASE_ITEM_TOWERSHIELD)
			{
				object oLClaw = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCreature);
			
				if (GetIsObjectValid(oLClaw))
				{
					oOffhand = oLClaw;
				}
				else oOffhand = OBJECT_INVALID;
			}
			else oOffhand = oLeft;

			if ((fDist <= fRange) || GetWeaponRanged(oWeapon))
			{
				int nRHandAttacks, nLHandAttacks, nPenalty;
				int nFlurry;

				nFlurry = 0;

				if ((GetActionMode(oCreature, ACTION_MODE_FLURRY_OF_BLOWS)) && (GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature)) == ARMOR_RANK_NONE))
				{
					object oRanged = GetItemInSlot(INVENTORY_SLOT_ARROWS, oCreature);
					int nType = GetBaseItemType(oWeapon);
					int nRangedType = GetBaseItemType(oRanged);
					int nMonk = GetLevelByClass(CLASS_TYPE_MONK, oCreature) + GetLevelByClass(CLASS_TYPE_SACREDFIST, oCreature);

					if (((!GetIsObjectValid(oWeapon)) && (!GetIsObjectValid(oOffhand))) || nType == BASE_ITEM_KAMA || nType == BASE_ITEM_QUARTERSTAFF || nRangedType == BASE_ITEM_SHURIKEN)
					{
						nFlurry += 1;

						if (nMonk > 10)
						{
							nFlurry += 1;
						}
					}

					if (nMonk < 5)
					{
						nPenalty -= 2;
					}
					else if (nMonk < 9)
					{
						nPenalty -= 1;
					}
				}

				int nSnap;

				nSnap = 0;

				object oToB = GetItemPossessedBy(oCreature, "tob");

				if (GetLocalInt(oToB, "SnapKick") == 1)
				{
					nSnap = 1;
					nPenalty -= 2;
				}

				if (nOnHandAttacks == -1)
				{
					int nBAB = GetTRUEBaseAttackBonus(oCreature);

					switch (nBAB)
					{
						case 0:	nRHandAttacks = 1; break;
						case 1:	nRHandAttacks = 1; break;
						case 2:	nRHandAttacks = 1; break;
						case 3:	nRHandAttacks = 1; break;
						case 4:	nRHandAttacks = 1; break;
						case 5:	nRHandAttacks = 1; break;
						case 6:	nRHandAttacks = 2; break;
						case 7:	nRHandAttacks = 2; break;
						case 8:	nRHandAttacks = 2; break;
						case 9:	nRHandAttacks = 2; break;
						case 10:nRHandAttacks = 2; break;
						case 11:nRHandAttacks = 3; break;
						case 12:nRHandAttacks = 3; break;
						case 13:nRHandAttacks = 3; break;
						case 14:nRHandAttacks = 3; break;
						case 15:nRHandAttacks = 3; break;
						case 16:nRHandAttacks = 4; break;
						case 17:nRHandAttacks = 4; break;
						case 18:nRHandAttacks = 4; break;
						case 19:nRHandAttacks = 4; break;
						case 20:nRHandAttacks = 5; break;
						case 21:nRHandAttacks = 5; break;
						case 22:nRHandAttacks = 5; break;
						case 23:nRHandAttacks = 5; break;
						case 24:nRHandAttacks = 5; break;
						default:nRHandAttacks = 6; break;
					}
				}
				else nRHandAttacks = nOnHandAttacks;

				if ((nOffHandAttacks == -1) && (GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature))))
				{
					if (GetHasFeat(FEAT_EPIC_PERFECT_TWO_WEAPON_FIGHTING, oCreature) || GetHasFeat(FEAT_COMBATSTYLE_RANGER_DUAL_WIELD_PERFECT_TWO_WEAPON_FIGHTING, oCreature, TRUE))
					{
						int nBAB2 = GetTRUEBaseAttackBonus(oCreature);

						switch (nBAB2)
						{
							case 0:	nLHandAttacks = 1; break;
							case 1:	nLHandAttacks = 1; break;
							case 2:	nLHandAttacks = 1; break;
							case 3:	nLHandAttacks = 1; break;
							case 4:	nLHandAttacks = 1; break;
							case 5:	nLHandAttacks = 1; break;
							case 6:	nLHandAttacks = 2; break;
							case 7:	nLHandAttacks = 2; break;
							case 8:	nLHandAttacks = 2; break;
							case 9:	nLHandAttacks = 2; break;
							case 10:nLHandAttacks = 2; break;
							case 11:nLHandAttacks = 3; break;
							case 12:nLHandAttacks = 3; break;
							case 13:nLHandAttacks = 3; break;
							case 14:nLHandAttacks = 3; break;
							case 15:nLHandAttacks = 3; break;
							case 16:nLHandAttacks = 4; break;
							case 17:nLHandAttacks = 4; break;
							case 18:nLHandAttacks = 4; break;
							case 19:nLHandAttacks = 4; break;
							case 20:nLHandAttacks = 5; break;
							case 21:nLHandAttacks = 5; break;
							case 22:nLHandAttacks = 5; break;
							case 23:nLHandAttacks = 5; break;
							case 24:nLHandAttacks = 5; break;
							default:nLHandAttacks = 6; break;
						}
					}
					else if (GetHasFeat(FEAT_GREATER_TWO_WEAPON_FIGHTING, oCreature) || GetHasFeat(FEAT_COMBATSTYLE_RANGER_DUAL_WIELD_GREATER_TWO_WEAPON_FIGHTING, oCreature))
					{
						nLHandAttacks = 3;
					}
					else if (GetHasFeat(FEAT_IMPROVED_TWO_WEAPON_FIGHTING, oCreature) || GetHasFeat(FEAT_COMBATSTYLE_RANGER_DUAL_WIELD_IMPROVED_TWO_WEAPON_FIGHTING, oCreature))
					{
						nLHandAttacks = 2;
					}
					else nLHandAttacks = 1;
				}
				else if (GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature)))
				{
					nLHandAttacks = 1;
				}
				else nLHandAttacks = 0;

				// Can't stop the first attack from going off, so we have to nullify it as best as is possible.
				SetCombatOverrides(oCreature, oTarget, -1, -1, OVERRIDE_ATTACK_RESULT_MISS, 0, 0, bSuppressBroadcastAOO, bSuppressMakeAOO, FALSE, FALSE);

				// After this point we're using the "Strike" brand functions to determine hits or misses.
				// Timing is crucial to land just the right modification to the correct attack.
				// These mods should be implemented via the "Override" brand of functions above.
				// For instance, to set an override on the second attack only, Delay the command by at most
				// 0.9f and use the Remove function after the roll function has been executed at about 1.1f.

				if (GetLocalInt(oCreature, "bot9s_AoO_overridestate") == 0)
				{
					ManageAoOLocations(oCreature, oWeapon);
					DelayCommand(0.5f, ManageAttacksOfOpportunity(oCreature, oWeapon));
				}

				ManageAttack(oCreature, oFoe, 0 + nPenalty, oWeapon, FALSE, FALSE, TRUE);

				if (nFlurry > 0)
				{
					ManageAttack(oCreature, oFoe, 0 + nPenalty, oWeapon, FALSE);
				}

				if (nFlurry > 1)
				{
					ManageAttack(oCreature, oFoe, 0 + nPenalty, oWeapon, FALSE);
				}

				if (nSnap > 0)
				{
					ManageAttack(oCreature, oFoe, 0 + nPenalty, oWeapon, FALSE);
				}

				if (nLHandAttacks > 0)
				{
					DelayCommand(0.1f, ManageAttack(oCreature, oFoe, 0 + nPenalty, oOffhand, FALSE, FALSE, TRUE));
				}

				if (nRHandAttacks > 1) // Two attacks.
				{
					DelayCommand(1.0f, ManageAttack(oCreature, oFoe, -5 + nPenalty, oWeapon, FALSE));
				}

				if (nLHandAttacks > 1)
				{
					DelayCommand(1.1f, ManageAttack(oCreature, oFoe, -5 + nPenalty, oOffhand, FALSE));
				}
	
				if (nRHandAttacks > 2) // Three attacks.
				{
					DelayCommand(2.0f, ManageAttack(oCreature, oFoe, -10 + nPenalty, oWeapon, TRUE, FALSE, TRUE));
				}

				if (nLHandAttacks > 2)
				{
					DelayCommand(2.1f, ManageAttack(oCreature, oFoe, -10 + nPenalty, oOffhand, FALSE, FALSE, TRUE));
				}

				if (nRHandAttacks > 3) // Four attacks.
				{
					DelayCommand(3.0f, ManageAttack(oCreature, oFoe, -15 + nPenalty, oWeapon, FALSE));
				}
	
				if (nLHandAttacks > 3)
				{
					DelayCommand(3.1f, ManageAttack(oCreature, oFoe, -15 + nPenalty, oOffhand, FALSE));
				}

				if (nRHandAttacks > 4) // Five attacks.
				{
					DelayCommand(4.0f, ManageAttack(oCreature, oFoe, -20 + nPenalty, oWeapon, FALSE));
				}

				if (nLHandAttacks > 4)
				{
					DelayCommand(4.1f, ManageAttack(oCreature, oFoe, -20 + nPenalty, oOffhand, FALSE));
				}
	
				if (nRHandAttacks > 5) // Six attacks.
				{
					DelayCommand(5.0f, ManageAttack(oCreature, oFoe, -25 + nPenalty, oWeapon, TRUE, FALSE, TRUE));
				}

				if (nLHandAttacks > 5)
				{
					DelayCommand(5.1f, ManageAttack(oCreature, oFoe, -25 + nPenalty, oOffhand, FALSE, FALSE, TRUE));
				}
			}
		}
	}
	else 
	{
		if (GetArea(oFoe) == GetArea(oCreature))
		{
			DelayCommand(0.01f, ManageCombatOverrides(TRUE));
			SetLocalInt(oCreature, "bot9s_overridestate", 2);
		}
		else ProtectedClearCombatOverrides(oCreature); //Cleanup when we're not in the same area.
	}
}