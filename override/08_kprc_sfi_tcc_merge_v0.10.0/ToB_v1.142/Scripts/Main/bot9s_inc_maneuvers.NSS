//////////////////////////////////////////////
//	Author: Drammel                         //
//	Date: 2/19/2009                         //
//	Title: bot9s_inc_maneuvers              //
//	Description: Scripts that are used by   //
//	most maneuvers.                         //
//////////////////////////////////////////////

#include "bot9s_inc_2da"
#include "bot9s_inc_variables"
#include "bot9s_include"
#include "bot9s_attack"
#include "bot9s_inc_constants"
#include "bot9s_weapon"
#include "bot9s_inc_fx"
#include "bot9s_cr_recovery"
#include "bot9s_armor"

// Prototypes

// Sets the local Swift variable on the player's martial journal for six seconds and
// Displays the hourglass in Swift Action timer.
// nManeuver: Tells this function which .tga to display.
// sType: Used to specify special actions for certain feats.  Types currently
// used in this system are "B", "C", "STA", and "F".  Boosts, Counters
// Stances, and Swift Feats.
void RunSwiftAction(int nManeuver, string sType, object oPC = OBJECT_SELF);

// Returns the Intiator Level of oPC.
// -oPC: Target of the function.
int GetInitiatorLevel(object oPC);

// Returns the value of a maneuver's DC, following the lines that declare what
// type of strike has been activated.  Used so that we're not 'counting feats'
// every other line in a maneuver.
// -nAbilityMod: The stat modifier for the maneuver.
// -nLevelMod: The modifier based on the PC's level that applies to the maneuver.
// Sometimes it will be 1/2 level of a specific level, sometimes not.
// -nBase: Usually a DC will be 10 + an ability modifier + 1/2 level, but I've
// added the option to edit these just in case.
// -nMisc: Any special modifiers, specific to the maneuver.
int GetManeuverDC(int nAbilityMod, int nLevelMod, int nBase = 10, int nMisc = 0);

// Applies a +2 saving throw bonus for the Swordsage's discipline focus feats.
void DefensiveStance(object oPC, object oToB, int nStance);

// Returns the object stored on the Tome of Battle object when the target was selected for the maneuver.  The
// objects are stored for individual maneuvers so that the action queue doesn't return the wrong object when a
// maneuver is enqueued.
// nManeuver: The 2da index number of the maneuver that this script is run from.
object GetManeuverObject(object oToB, int nManeuver);

// Returns the x vector value of the targeted location of a maneuver.  Only to be used with maneuvers that
// target a location.
float GetManeuverX(object oToB, int nManeuver);

// Returns the y vector value of the targeted location of a maneuver.  Only to be used with maneuvers that
// target a location.
float GetManeuverY(object oToB, int nManeuver);

// Returns the z vector value of the targeted location of a maneuver.  Only to be used with maneuvers that
// target a location.
float GetManeuverZ(object oToB, int nManeuver);

// Prevents the caller of the function from preforming a hostile act on the target.  This happens if the target
// has less than one hit point, is the player, or is in the player's party.  Returns TRUE if we cannot attack
// the target, and the function that calls it should return immeadiately.
// -oTarget: The object that we're checking to see if we can attack or not.
// -bSupressMessage: When set to true this will prevent a message from being sent to the player by
// this function.
int NotMyFoe(object oPC, object oTarget, int bSupressMessage = FALSE);

// Checks if either of the variables on oToB, Stance or Stance2 matches
// nStance.  This script also checks to see if the PC's hit points are above 0.
// If either stance matches the function will return TRUE.  If the PC is a less than
// one hit point it will return FALSE.
int ValidateStance(int nStance, object oPC = OBJECT_SELF);

// Determines if a PC can continue running a counter or not.
int ValidateCounter(int nCounter, object oPC = OBJECT_SELF);

// Matches an executing maneuver with the BlueBox Calling it.  Returns the BlueBox.
// -nManeuver: 2da reference number of the maneuver's script.  If we're going by
// the rules as written, there should only be one of these on any given screen.
// -sType: Valid only for STR, B, and C; Strikes, Boosts, and Counters.
string MatchBlue(int nManeuver, string sType, object oPC = OBJECT_SELF);

// A standard heal effect with routing for the Crusader's Delayed Damage Pool.
effect ManeuverHealing(object oTarget, int nHealAmount);

// Tracks the number of critical hits the player makes for the Stance, Blood in the Water.
void DoBloodInTheWater(object oPC = OBJECT_SELF);

// Handles the healing portion of the stance Martial Spirit.
void DoMartialSpirit(object oPC = OBJECT_SELF);

// Handles the attack penalty for the boost Covering Strike.
void DoCoveringStrike(object oFoe, object oPC = OBJECT_SELF);

// Handles healing for the stance Aura of Triumph.
void DoAuraOfTriumph(object oFoe, object oPC = OBJECT_SELF);

// Enforces the rules about being reduced to zero in any stat automatically
// incapacitating a target since NWN2's engine will not do it.
// -oTarget: The creature who's ability we're checking.
// -nAbility: The ABILITY_* constant of the stat we're checking to see if it
// has reached zero.  If so, oTarget takes damage equal to its total hp value.
void DropDead(object oTarget, int nAbility);

// Expends the maneuver upon it's execution.
// -nManeuver: 2DA reference number of the maneuver.
// -sType: The type of maneuver being executed.  Valid only for B, C, and STR.
// Boosts, Counters, and Strikes respectively.
void ExpendManeuver(int nManeuver, string sType, object oPC = OBJECT_SELF);

// Plays a basic attack animation with oWeapon.
// nHit: Used only in conjunction with bTrail to determine trail effects.
void BasicAttackAnimation(object oWeapon, int nHit, int bTwoWeapon = FALSE, int bTrail = TRUE, object oPC = OBJECT_SELF);

// Determines the result of an attack roll for strikes.
// 0 = Miss, 1 = Hit, 2 = Critical Hit.
// -oWeapon: The weapon to make an attack roll with.
// -oFoe: The the target being attacked with oWeapon.
// -nMisc: Any additional bonus to the attack roll that hasn't been added.
// -bCombatLog: When set to true displays the attack roll data.
// -nConfirmBonus: Bonus to the critical confirmation roll.
// -oPC: Person executing the attack.
int StrikeAttackRoll(object oWeapon, object oFoe, int nMisc = 0, int bCombatLog = TRUE, int nConfirmBonus = 0, object oPC = OBJECT_SELF);

// Plays a sound based on the results of StrikeAttackRoll.
// -oWeapon: Weapon in right or left hand.
// -oTarget: Creature where we want to play the hit or miss sound.
// -nHit: Either a miss, hit, or critical hit. 0, 1, or 2.
// -fDelay: Amount of time to delay the sound effect by.  There is a minimum 0.1 delay while the sound 
// creature is created.
// -nAttackCry: Plays the character's attacking grunt sound while set to TRUE.
// -sOverride: For a valid sound creature's tag, this will use that creature's sfx instead of the normal sfx.
//	Set it to FALSE if you wish to use another sound or none at all when attacking.
void StrikeAttackSound(object oWeapon, object oTarget, int nHit, float fDelay = 0.0f, int bAttackCry = TRUE, string sOverride = "");

// Applies base weapon damage, visual effects and critical hit damage based on
// the results of StrikeAttackRoll.  0 for miss, 1 for hit, 2 for critical hit.
// -oWeapon: The weapon we're generating attack damage for.
// -nHit: The type of hit or miss we're generating a visual effect for.
// nHit also will apply critical hit damage if it equals 2.
// -oFoe: Our target gets chances to defend against certain effects!
// -nMisc: Any misc bonues to damage.
// -bIgnoreResistances: Sets if this attack bypasses DR or not.  Defaults to FALSE.
// -nMult: Number to multiply total damage by.  Defaults to one.
effect BaseStrikeDamage(object oWeapon, int nHit, object oFoe, int nMisc = 0, int bIgnoreResistances = FALSE, int nMult = 1);

// Applies misc permanent effects to a strike and must be applied seperately from BaseStrikeDamage
effect StrikePermanentEffects(object oWeapon, int nHit, object oFoe);

// Applies the results of weapon and feat modifiers on a martial strike.
// -oWeapon: Either right or left hand are vaild. (GetItemInSlot returning
// OBJECT_INVALID should return unarmed damage.
// -nHit: 0 for miss, 1 for hit, 2 for critical hit.
// -oTarget: The target of the strike.
// -nMisc: Any misc bonunes to damage.
// -bIgnoreResistances: Determines if the strike bypasses DR or not.
// -bSupressDamage: When set to TRUE prevents the strike from doing any damage
// but, all other events will occur, such as tracking for counter maneuvers.
// -nMult: Number to multiply total damage by.  Defaults to one.
void StrikeWeaponDamage(object oWeapon, int nHit, object oTarget, int nMisc = 0, int bIgnoreResistances = FALSE, int bSupressDamage = FALSE, int nMult = 1);

//Functions

// Sets the local Swift variable on the player's martial journal for six seconds and
// Displays the hourglass in Swift Action timer.
// nManeuver: Tells this function which .tga to display.
// sType: Used to specify special actions for certain feats.  Types currently
// used in this system are "B", "C", "STA", and "F".  Boosts, Counters
// Stances, and Swift Feats.
void RunSwiftAction(int nManeuver, string sType, object oPC = OBJECT_SELF)
{
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nDualBoost = GetLocalInt(oToB, "DualBoostActive");
	string sTga = tob_Get2daString("maneuvers", "ICON", nManeuver);
	string sIcon = sTga + ".tga";

	if ((nDualBoost == 1) && (sType == "B"))
	{
		SetLocalInt(oToB, "DualBoostActive", 0);

		int nDualUses = GetLocalInt(oToB, "DualBoost");
		int nDecrement = nDualUses - 1;

		SetLocalInt(oToB, "DualBoost", nDecrement);
	}
	else if ((GetLocalInt(oToB, "StanceOfAlacrity") == 1) && (sType == "C") && (GetLocalInt(oToB, "AlacrityCounter") != nManeuver))
	{
		SetLocalInt(oToB, "Counter", 0);
		SetLocalInt(oToB, "StanceOfAlacrity", 0);
		SetLocalInt(oToB, "AlacrityCounter", nManeuver);
	}
	else
	{

		if (sType == "C")
		{
			SetLocalInt(oToB, "Counter", 0);
		}

		if (nManeuver == 69) //Quicksilver Motion
		{
			SetLocalInt(oToB, "Swift", 0);
			SetLocalInt(oPC, "Swift", 0);
			SetLocalInt(oToB, "Quicksilver", 1);
			SetLocalInt(oPC, "Quicksilver", 1);
			DelayCommand(6.0f, SetLocalInt(oToB, "Quicksilver", 0));
			DelayCommand(6.0f, SetLocalInt(oPC, "Quicksilver", 0));
			SetGUITexture(oPC, "SCREEN_SWIFT_ACTION", "SWIFT_ACTION", sIcon);
			DelayCommand(1.0f, SetGUITexture(oPC, "SCREEN_SWIFT_ACTION", "SWIFT_ACTION", "b_empty.tga"));
		}
		else
		{
			SetLocalInt(oToB, "Swift", 1);
			SetLocalInt(oPC, "Swift", 1);
			DelayCommand(6.0f, SetLocalInt(oToB, "Swift", 0));
			DelayCommand(6.0f, SetLocalInt(oPC, "Swift", 0));
			SetGUITexture(oPC, "SCREEN_SWIFT_ACTION", "SWIFT_ACTION", sIcon);
			DelayCommand(6.0f, SetGUITexture(oPC, "SCREEN_SWIFT_ACTION", "SWIFT_ACTION", "b_empty.tga"));
		}
	}
}

// Returns the Intiator Level of oPC.
// -oPC: Target of the function.
int GetInitiatorLevel(object oPC)
{
	object oToB = GetItemPossessedBy(oPC, "tob");
	string sData = GetLocalString(oToB, "BlackBox");
	string sClass = GetStringRight(sData, 3);

	int nMartialAdept;
	int nCrusader = GetLevelByClass(CLASS_TYPE_CRUSADER, oPC);
	int nSaint = GetLevelByClass(CLASS_TYPE_SAINT, oPC);
	int nSwordsage = GetLevelByClass(CLASS_TYPE_SWORDSAGE, oPC);
	int nWarblade = GetLevelByClass(CLASS_TYPE_WARBLADE, oPC);

	if (sClass == "_CR")
	{
		nMartialAdept = nCrusader;
	}
	else if (sClass == "_SA")
	{
		nMartialAdept = nSaint;
	}
	else if (sClass == "_SS")
	{
		nMartialAdept = nSwordsage;
	}
	else if (sClass == "_WB")
	{
		nMartialAdept = nWarblade;
	}
	else // For Martial Study or for when this function is not called from a maneuver.
	{
		if (nCrusader > nSaint || nCrusader > nSwordsage || nCrusader > nWarblade)
		{
			nMartialAdept = nCrusader;
		}
		else if (nSaint > nCrusader || nSaint > nSwordsage || nSaint > nWarblade)
		{
			nMartialAdept = nSaint;
		}
		else if (nSwordsage > nCrusader || nSwordsage > nSaint || nSwordsage > nWarblade)
		{
			nMartialAdept = nSwordsage;
		}
		else if (nWarblade > nCrusader || nWarblade > nSaint || nWarblade > nSwordsage)
		{
			nMartialAdept = nWarblade;
		}
		else if (nCrusader > 0 || nSaint > 0 || nSwordsage > 0 || nWarblade > 0)
		{
			if (nCrusader == nSaint || nCrusader == nSwordsage || nCrusader == nWarblade)
			{
				nMartialAdept = nCrusader; // Fyi, purely an alphabetical preferance.
			}
			else if (nSaint == nSwordsage || nSaint == nWarblade)
			{
				nMartialAdept = nSaint;
			}
			else if (nSwordsage == nWarblade)
			{
				nMartialAdept = nSwordsage;
			}
			else nMartialAdept = 0;
		}
		else nMartialAdept = 0;
	}

	int nNonMartial = ((GetHitDice(oPC) - nMartialAdept) / 2);
	int nReturn = nMartialAdept + nNonMartial;

	if (nReturn < 1)
	{
		nReturn = 1;
	}

	return nReturn;
}

// Returns the value of a maneuver's DC, following the lines that declare what
// type of strike has been activated.  Used so that we're not 'counting feats'
// every other line in a maneuver.
// -nAbilityMod: The stat modifier for the maneuver.
// -nLevelMod: The modifier based on the PC's level that applies to the maneuver.
// Sometimes it will be 1/2 level of a specific level, sometimes not.
// -nBase: Usually a DC will be 10 + an ability modifier + 1/2 level, but I've
// added the option to edit these just in case.
// -nMisc: Any special modifiers, specific to the maneuver.
int GetManeuverDC(int nAbilityMod, int nLevelMod, int nBase = 10, int nMisc = 0)
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	int nFeat;
	
	if (GetLocalInt(oToB, "DesertWindStrike") == 1)
	{
		if (GetHasFeat(FEAT_BLADE_MEDITATION_DW))
		{
			nFeat += 1;
		}
	}
	else if (GetLocalInt(oToB, "DiamondMindStrike") == 1)
	{
		if (GetHasFeat(FEAT_BLADE_MEDITATION_DM))
		{
			nFeat += 1;
		}
	}
	else if (GetLocalInt(oToB, "DevotedSpiritStrike") == 1)
	{
		if (GetHasFeat(FEAT_BLADE_MEDITATION_DS))
		{
			nFeat += 1;
		}
	}
	else if (GetLocalInt(oToB, "IronHeartStrike") == 1)
	{
		if (GetHasFeat(FEAT_BLADE_MEDITATION_IH))
		{
			nFeat += 1;
		}
	}
	else if (GetLocalInt(oToB, "SettingSunStrike") == 1)
	{
		if (GetHasFeat(FEAT_BLADE_MEDITATION_SS))
		{
			nFeat += 1;
		}
		
		if (GetLocalInt(oToB, "FallingSun") == 1)
		{
			nFeat += 1;
		}
	}
	else if (GetLocalInt(oToB, "ShadowHandStrike") == 1)
	{
		if (GetHasFeat(FEAT_BLADE_MEDITATION_DW))
		{
			nFeat += 1;
		}
	}
	else if (GetLocalInt(oToB, "StoneDragonStrike") == 1)
	{
		if (GetHasFeat(FEAT_BLADE_MEDITATION_SD))
		{
			nFeat += 1;
		}
	}
	else if (GetLocalInt(oToB, "TigerClawStrike") == 1)
	{
		if (GetHasFeat(FEAT_BLADE_MEDITATION_TC))
		{
			nFeat += 1;
		}
	}
	else if (GetLocalInt(oToB, "WhiteRavenStrike") == 1)
	{
		if (GetHasFeat(FEAT_BLADE_MEDITATION_WR))
		{
			nFeat += 1;
		}
	}

	int nReturn = nAbilityMod + nLevelMod + nBase + nMisc + nFeat;
	return nReturn;
}

// Applies a +2 saving throw bonus for the Swordsage's discipline focus feats.
void DefensiveStance(object oPC, object oToB, int nStance)
{
	int nCheck = GetLocalInt(oToB, "Stance");
	int nCheck2 = GetLocalInt(oToB, "Stance2");

	if (nCheck == nStance || nCheck2 == nStance) // The function is recursive, so these checks are needed to end the effect properly.
	{
		effect eDefensiveStance = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
		eDefensiveStance = SupernaturalEffect(eDefensiveStance);

		if (GetHasFeat(FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_DW) || GetHasFeat(FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_DW2))
		{
			if (nStance == STANCE_FRYASLT || nStance == STANCE_FLMSBLSS
			|| nStance == STANCE_HOLOSTCLK || nStance == STANCE_RSNPHEONIX)
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDefensiveStance, oPC, 6.0f);
				DelayCommand(6.0f, DefensiveStance(oPC, oToB, nStance));
			}
		}
		else if (GetHasFeat(FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_DM) || GetHasFeat(FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_DM2))
		{
			if (nStance == STANCE_HEARING_THE_AIR || nStance == STANCE_PEARL_OF_BLACK_DOUBT
			|| nStance == STANCE_OF_ALACRITY || nStance == STANCE_OF_CLARITY)
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDefensiveStance, oPC, 6.0f);
				DelayCommand(6.0f, DefensiveStance(oPC, oToB, nStance));
			}
		}
		else if (GetHasFeat(FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_SS) || GetHasFeat(FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_SS2))
		{
			if (nStance == STANCE_GHOSTLY_DEFENSE || nStance == STANCE_GIANT_KILLING_STYLE
			|| nStance == STANCE_SHIFTING_DEFENSE || nStance == STANCE_STEP_OF_THE_WIND)
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDefensiveStance, oPC, 6.0f);
				DelayCommand(6.0f, DefensiveStance(oPC, oToB, nStance));
			}
		}
		else if (GetHasFeat(FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_SH) || GetHasFeat(FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_SH2))
		{
			if (nStance == STANCE_ASSNS_STANCE || nStance == STANCE_BALANCE_SKY
			|| nStance == STANCE_CHILD_SHADOW || nStance == STANCE_DANCE_SPIDER
			|| nStance == STANCE_ISLAND_OF_BLADES || nStance == STANCE_DANCING_MOTH)
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDefensiveStance, oPC, 6.0f);
				DelayCommand(6.0f, DefensiveStance(oPC, oToB, nStance));
			}
		}
		else if (GetHasFeat(FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_SD) || GetHasFeat(FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_SD2))
		{
			if (nStance == STANCE_CRUSHING_WEIGHT_OF_THE_MOUNTAIN || nStance == STANCE_GIANTS_STANCE
			|| nStance == STANCE_ROOTS_OF_THE_MOUNTAIN || nStance == STANCE_STONEFOOT_STANCE
			|| nStance == STANCE_STRENGTH_OF_STONE)
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDefensiveStance, oPC, 6.0f);
				DelayCommand(6.0f, DefensiveStance(oPC, oToB, nStance));
			}
		}
		else if (GetHasFeat(FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_TC) || GetHasFeat(FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_TC2))
		{
			if (nStance == STANCE_BLOOD_IN_THE_WATER || nStance == STANCE_HUNTERS_SENSE
			|| nStance == STANCE_LEAPING_DRAGON_STANCE || nStance == STANCE_PREY_ON_THE_WEAK
			|| nStance == STANCE_WOLF_PACK_TACTICS || nStance == STANCE_WOLVERINE_STANCE)
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDefensiveStance, oPC, 6.0f);
				DelayCommand(6.0f, DefensiveStance(oPC, oToB, nStance));
			}
		}
	}
}

// Returns the object stored on the Tome of Battle object when the target was selected for the maneuver.  The
// objects are stored for individual maneuvers so that the action queue doesn't return the wrong object when a
// maneuver is enqueued.
// nManeuver: The 2da index number of the maneuver that this script is run from.
object GetManeuverObject(object oToB, int nManeuver)
{
	object oTarget = GetLocalObject(oToB, "Target" + IntToString(nManeuver));
	return oTarget;
}

// Returns the x vector value of the targeted location of a maneuver.  Only to be used with maneuvers that
// target a location.
float GetManeuverX(object oToB, int nManeuver)
{
	float fx = GetLocalFloat(oToB, IntToString(nManeuver) + "x");
	return fx;
}

// Returns the y vector value of the targeted location of a maneuver.  Only to be used with maneuvers that
// target a location.
float GetManeuverY(object oToB, int nManeuver)
{
	float fy = GetLocalFloat(oToB, IntToString(nManeuver) + "y");
	return fy;
}

// Returns the y vector value of the targeted location of a maneuver.  Only to be used with maneuvers that
// target a location.
float GetManeuverZ(object oToB, int nManeuver)
{
	float fz = GetLocalFloat(oToB, IntToString(nManeuver) + "z");
	return fz;
}

// Prevents the caller of the function from preforming a hostile act on the target.  This happens if the target
// has less than one hit point, is the player, or is in the player's party.  Returns TRUE if we cannot attack
// the target, and the function that calls it should return immeadiately.
// -oTarget: The object that we're checking to see if we can attack or not.
// -bSupressMessage: When set to true this will prevent a message from being sent to the player by
// this function.
int NotMyFoe(object oPC, object oTarget, int bSupressMessage = FALSE)
{
	if (GetCurrentHitPoints(oTarget) < 1)
	{
		if (bSupressMessage == FALSE)
		{
			SendMessageToPC(oPC, "Your target has less than one hit point.");
		}

		return TRUE;
	}
	else if (oPC == oTarget)
	{
		if (bSupressMessage == FALSE)
		{
			SendMessageToPC(oPC, "You cannot target yourself with this ability.");
		}

		return TRUE;
	}
	else if (GetIsReactionTypeFriendly(oTarget, oPC))
	{
		if (bSupressMessage == FALSE)
		{
			SendMessageToPC(oPC, "You cannot use your ability on this target.");
		}

		return TRUE;
	}
	else if (GetIsReactionTypeNeutral(oTarget, oPC))
	{
		if (bSupressMessage == FALSE)
		{
			SendMessageToPC(oPC, "You cannot use your ability on this target.");
		}

		return TRUE;
	}
	else return FALSE;
}

// Checks if either of the variables on oToB, Stance or Stance2 matches
// nStance.  This script also checks to see if the PC's hit points are above 0.
// If either stance matches the function will return TRUE.  If the PC is a less than
// one hit point it will return FALSE.
int ValidateStance(int nStance, object oPC = OBJECT_SELF)
{
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nStance1 = GetLocalInt(oToB, "Stance");
	int nStance2 = GetLocalInt(oToB, "Stance2");
	int nReturn;

	if (nStance == nStance1 || nStance == nStance2)
	{
		nReturn = TRUE;
	}
	else nReturn = FALSE;

	if (GetCurrentHitPoints(oPC) < 1)
	{
		nReturn = FALSE;
	}

	return nReturn;
}

// Determines if a PC can continue running a counter or not.
int ValidateCounter(int nCounter, object oPC = OBJECT_SELF)
{
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nCounter1 = GetLocalInt(oToB, "Counter");
	int nReturn;

	if (nCounter == nCounter1)
	{
		nReturn = TRUE;
	}
	else nReturn = FALSE;

	if (GetCurrentHitPoints(oPC) < 1)
	{
		nReturn = FALSE;
	}

	return nReturn;
}

// Matches an executing maneuver with the BlueBox Calling it.  Returns the BlueBox.
// -nManeuver: 2da reference number of the maneuver's script.  If we're going by
// the rules as written, there should only be one of these on any given screen.
// -sType: Valid only for STR, B, and C; Strikes, Boosts, and Counters.
string MatchBlue(int nManeuver, string sType, object oPC = OBJECT_SELF)
{
	object oToB = GetItemPossessedBy(oPC, "tob");
	string sReturn;
	int i;

	i = 1;

	while (i < 21)
	{
		if (GetLocalInt(oToB, "BlueBox" + sType + IntToString(i) + "_CR") == nManeuver)
		{
			sReturn = "BlueBox" + sType + IntToString(i) + "_CR";
			SetLocalInt(oToB, "BlueNumber", i);
			break;
		}
		else if (GetLocalInt(oToB, "BlueBox" + sType + IntToString(i) + "_SA") == nManeuver)
		{
			sReturn = "BlueBox" + sType + IntToString(i) + "_SA";
			SetLocalInt(oToB, "BlueNumber", i);
			break;
		}
		else if (GetLocalInt(oToB, "BlueBox" + sType + IntToString(i) + "_SS") == nManeuver)
		{
			sReturn = "BlueBox" + sType + IntToString(i) + "_SS";
			SetLocalInt(oToB, "BlueNumber", i);
			break;
		}
		else if (GetLocalInt(oToB, "BlueBox" + sType + IntToString(i) + "_WB") == nManeuver)
		{
			sReturn = "BlueBox" + sType + IntToString(i) + "_WB";
			SetLocalInt(oToB, "BlueNumber", i);
			break;
		}
		else if (GetLocalInt(oToB, "BlueBox" + sType + IntToString(i) + "___") == nManeuver)
		{
			sReturn = "BlueBox" + sType + IntToString(i) + "___";
			SetLocalInt(oToB, "BlueNumber", i);
			break;
		}
		else i++;
	}
	return sReturn;
}

// A standard heal effect with routing for the Crusader's Delayed Damage Pool.
effect ManeuverHealing(object oTarget, int nHealAmount)
{
	if (GetLevelByClass(CLASS_TYPE_CRUSADER, oTarget) > 0)
	{
		object oToB = GetItemPossessedBy(oTarget, "tob");

		if ((GetIsObjectValid(oToB)) && (GetLocalInt(oToB, "FuriousCounterstrike") == 0))
		{
			int nHp = GetCurrentHitPoints(oTarget);
			int nMaxHp = GetMaxHitPoints(oTarget);
			int nSurplus = nHp + nHealAmount;

			if (nSurplus > nMaxHp)
			{
				int nHeal = nMaxHp - nSurplus;

				SetLocalInt(oToB, "DDPoolCanHeal", 1);
				SetLocalInt(oToB, "DDPoolHealValue", nHeal);
				DelayCommand(6.0f, SetLocalInt(oToB, "DDPoolCanHeal", 1));
				DelayCommand(6.0f, SetLocalInt(oToB, "DDPoolHealValue", 0));
			}
		}
	}
	effect eHeal = EffectHeal(nHealAmount);
	return eHeal;
}

// Tracks the number of critical hits the player makes for the Stance, Blood in the Water.
void DoBloodInTheWater(object oPC = OBJECT_SELF)
{
	if (ValidateStance(165))
	{
		object oToB = GetItemPossessedBy(oPC, "tob");
		int nCritCount = GetLocalInt(oToB, "CritCount");

		SetLocalInt(oToB, "CritCount", nCritCount + 1);
	}
}

// Handles the healing portion of the stance Martial Spirit.
void DoMartialSpirit(object oPC = OBJECT_SELF)
{
	if (ValidateStance(44))
	{
		object oHeal;
		object oWeak = GetFactionWeakestMember(oPC, TRUE);
		effect eHeal = ManeuverHealing(oPC, 2);

		if (GetDistanceBetween(oPC, oWeak) > (FeetToMeters(30.0f) + GetGirth(oPC)))
		{
			oHeal = oPC;
		}
		else oHeal = oWeak;

		ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oHeal);
	}
}

// Handles the attack penalty for the boost Covering Strike.
void DoCoveringStrike(object oFoe, object oPC = OBJECT_SELF)
{
	if ((GetLocalInt(oPC, "CoveringStrike") == 1) && (GetAttackTarget(oFoe) != oPC))
	{
		int nRank = GetSkillRank(SKILL_DIPLOMACY, oPC);
		int nDiplomacy;

		nDiplomacy = (nRank - 4)/4;

		if (nDiplomacy < 1)
		{
			nDiplomacy = 1;
		}

		effect eCover = EffectAttackDecrease(nDiplomacy);
		eCover = ExtraordinaryEffect(eCover);

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCover, oFoe, 6.0f);
	}
}

// Handles healing for the stance Aura of Triumph.
void DoAuraOfTriumph(object oFoe, object oPC = OBJECT_SELF)
{
	object oToB = GetItemPossessedBy(oPC, "tob");

	if ((GetLocalInt(oPC, "ToB_Triumph") == 1) || (GetLocalInt(oPC, "AuraOfTriumph") == 1))
	{
		int nEvil = GetAlignmentGoodEvil(oFoe);

		if (nEvil == ALIGNMENT_EVIL)
		{
			effect eHeal = ManeuverHealing(oPC, 4);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);

			object oParty1 = GetLocalObject(oToB, "TriumphParty1");
			object oParty2 = GetLocalObject(oToB, "TriumphParty2");
			object oParty3 = GetLocalObject(oToB, "TriumphParty3");
			object oParty4 = GetLocalObject(oToB, "TriumphParty4");
			object oParty5 = GetLocalObject(oToB, "TriumphParty5");
			object oParty6 = GetLocalObject(oToB, "TriumphParty6");
			object oParty7 = GetLocalObject(oToB, "TriumphParty7");

			if (GetIsObjectValid(oParty1))
			{
				effect eHeal1 = ManeuverHealing(oParty1, 4);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal1, oParty1);
			}

			if (GetIsObjectValid(oParty2))
			{
				effect eHeal2 = ManeuverHealing(oParty2, 4);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal2, oParty2);
			}

			if (GetIsObjectValid(oParty3))
			{
				effect eHeal3 = ManeuverHealing(oParty3, 4);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal3, oParty3);
			}

			if (GetIsObjectValid(oParty4))
			{
				effect eHeal4 = ManeuverHealing(oParty4, 4);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal4, oParty4);
			}

			if (GetIsObjectValid(oParty5))
			{
				effect eHeal5 = ManeuverHealing(oParty5, 4);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal5, oParty5);
			}

			if (GetIsObjectValid(oParty6))
			{
				effect eHeal6 = ManeuverHealing(oParty6, 4);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal6, oParty6);
			}

			if (GetIsObjectValid(oParty7))
			{
				effect eHeal7 = ManeuverHealing(oParty7, 4);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal7, oParty7);
			}
		}
	}
}

// Enforces the rules about being reduced to zero in any stat automatically
// incapacitating a target since NWN2's engine will not do it.
// -oTarget: The creature who's ability we're checking.
// -nAbility: The ABILITY_* constant of the stat we're checking to see if it
// has reached zero.  If so, oTarget takes damage equal to its total hp value.
void DropDead(object oTarget, int nAbility)
{
	int nStat = GetAbilityScore(oTarget, nAbility);

	if (nStat < 1)
	{
		int nHp = GetCurrentHitPoints(oTarget);
		effect eDamage = EffectDamage(nHp, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL, TRUE);

		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
	}
}

// Expends the maneuver upon it's execution.
// -nManeuver: 2DA reference number of the maneuver.
// -sType: The type of maneuver being executed.  Valid only for B, C, and STR.
// Boosts, Counters, and Strikes respectively.
void ExpendManeuver(int nManeuver, string sType, object oPC = OBJECT_SELF)
{
	object oToB = GetItemPossessedBy(oPC, "tob");
	string sBlueBox = MatchBlue(nManeuver, sType);
	string sClass = GetStringRight(sBlueBox, 3);
	string sScreen;

	if (sClass == "___") // Finding the Screen the maneuver is on.
	{
		sScreen = "SCREEN_QUICK_STRIKE";
	}
	else sScreen = "SCREEN_QUICK_STRIKE" + sClass;

	string sTypeName; // Convert type abbreviation to the name on the listbox.
	
	if (sType == "B")
	{
		sTypeName = "BOOST";
	}
	else if (sType == "C")
	{
		sTypeName = "COUNTER";
	}
	else 
	{
		sTypeName = "STRIKE";
		SetLocalInt(oToB, "Strike", 0);
	}

	int nNumber = GetLocalInt(oToB, "BlueNumber");
	string sNumber;

	switch (nNumber) // Converts the number to written form for the name of the listbox.
	{
		case 1:	sNumber = "ONE";		break;
		case 2:	sNumber = "TWO";		break;
		case 3:	sNumber = "THREE"; 		break;
		case 4:	sNumber = "FOUR";		break;
		case 5:	sNumber = "FIVE";		break;
		case 6:	sNumber = "SIX";		break;
		case 7:	sNumber = "SEVEN";		break;
		case 8:	sNumber = "EIGHT";		break;
		case 9:	sNumber = "NINE";		break;
		case 10:sNumber = "TEN";		break;
		case 11:sNumber = "ELEVEN";		break;
		case 12:sNumber = "TWELVE";		break;
		case 13:sNumber = "THIRTEEN";	break;
		case 14:sNumber = "FOURTEEN";	break;
		case 15:sNumber = "FIFTEEN";	break;
		case 16:sNumber = "SIXTEEN";	break;
		case 17:sNumber = "SEVENTEEN";	break;
		case 18:sNumber = "EIGHTEEN";	break;
		case 19:sNumber = "NINETEEN";	break;
		case 20:sNumber = "TWENTY";		break;
	}

	string sListBox = sTypeName + "_" + sNumber;

	if (sScreen == "SCREEN_QUICK_STRIKE_CR")
	{
		int nTotal = GetLocalInt(oToB, "CrLimit");
		SetDisabledStatus(sListBox, nTotal);
	}

	SetGUIObjectDisabled(oPC, sScreen, sListBox, TRUE);
}

// Plays a basic attack animation with oWeapon.
// nHit: Used only in conjunction with bTrail to determine trail effects.
void BasicAttackAnimation(object oWeapon, int nHit, int bTwoWeapon = FALSE, int bTrail = TRUE, object oPC = OBJECT_SELF)
{
	object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	object oOffhand;

	if (bTrail == TRUE)
	{
		StrikeTrailEffect(oWeapon, nHit);
	}

	if ((oLeft == OBJECT_INVALID) && (!GetIsPlayableRacialType(oPC)))
	{
		oOffhand = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
	}
	else oOffhand = oLeft;

	int nOffHand = GetBaseItemType(oOffhand);
	string sBow;
	string sAttack;

	if (GetWeaponRanged(oWeapon))
	{
		int nD2 = d2(1);

		switch (nD2)
		{
			case 1:	sBow = "*1attack01";	break;
			case 2:	sBow = "*1attack02";	break;
		}

		WrapperPlayCustomAnimation(oPC, sBow, 0);
	}
	else if ((bTwoWeapon == TRUE) && (GetIsObjectValid(oOffhand)) && (nOffHand != BASE_ITEM_LARGESHIELD) && (nOffHand != BASE_ITEM_SMALLSHIELD) && (nOffHand != BASE_ITEM_TOWERSHIELD))
	{
		int nD2 = d2(1);
		
		switch (nD2)
		{
			case 1:	sAttack = "*2attack01";	break;
			case 2:	sAttack = "*2attack02";	break;
		}

		WrapperPlayCustomAnimation(oPC, sAttack, 0);
	}
	else 
	{
		int nD4 = d4(1);

		switch (nD4)
		{
			case 1:	sAttack = "*1attack01";	break;
			case 2:	sAttack = "*1attack02";	break;
			case 3:	sAttack = "*1attack03";	break;
			case 4:	sAttack = "*1attack04";	break;
		}
		
		WrapperPlayCustomAnimation(oPC, sAttack, 0);
	}
}

// Determines the result of an attack roll for strikes.
// 0 = Miss, 1 = Hit, 2 = Critical Hit.
// -oWeapon: The weapon to make an attack roll with.
// -oFoe: The the target being attacked with oWeapon.
// -nMisc: Any additional bonus to the attack roll that hasn't been added.
// -bCombatLog: When set to true displays the attack roll data.
// -nConfirmBonus: Bonus to the critical confirmation roll.
// -oPC: Person executing the attack.
int StrikeAttackRoll(object oWeapon, object oFoe, int nMisc = 0, int bCombatLog = TRUE, int nConfirmBonus = 0, object oPC = OBJECT_SELF)
{
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nFoeAC, nd20, nD20, nAB, nCritRange, nCritConfirmBonus, nHit;

	if (GetLocalInt(oFoe, "OverrideTouchAC") == 1)
	{
		nFoeAC = GetTouchAC(oFoe);
	}
	else if (GetLocalInt(oFoe, "OverrideFlatFootedAC") == 1)
	{
		nFoeAC = GetFlatFootedAC(oFoe);
	}
	else if (GetLocalInt(oFoe, "OverrideAC") > 0)
	{
		nFoeAC = GetLocalInt(oFoe, "OverrideAC");
	}
	else nFoeAC = GetAC(oFoe);

	if (GetLocalInt(oPC, "AuraOfPerfectOrder") == 1)
	{
		nD20 = 11;
		SetLocalInt(oPC, "AuraOfPerfectOrder", 0); // Used only once per round.
	}
	else if (GetLocalInt(oPC, "OverrideD20") == 1)
	{
		nD20 = GetLocalInt(oPC, "D20OverrideNum");
	}
	else nD20 = d20(1);

	if (GetLocalInt(oPC, "OverrideCritConfirm") == 1)
	{
		nd20 = GetLocalInt(oPC, "CCOverrideNum");
	}
	else nd20 = d20(1) + nConfirmBonus;

	if (GetLocalInt(oFoe, "OverrideCritConfirm") == 2)
	{
		nd20 += GetLocalInt(oFoe, "CCOverrideNum");
	}

	if (GetLocalInt(oPC, "OverrideAttackBonus") == 1)
	{
		nAB = GetLocalInt(oPC, "ABOverrideNum");
	}
	else nAB = GetMaxAB(oPC, oWeapon, oFoe) + nMisc;

	if (GetLocalInt(oPC, "OverrideCritRange") == 1)
	{
		nCritRange = GetLocalInt(oPC, "CROverrideNum");
	}
	else nCritRange = GetCriticalRange(oWeapon);

	if (GetLocalInt(oPC, "OverrideCritConfirmBonus") == 1)
	{
		nCritConfirmBonus = GetLocalInt(oPC, "CCBOverrideNum");
	}
	else nCritConfirmBonus = GetCriticalConfirmMod(oWeapon);

	SetLocalInt(oToB, "AttackRollResult", nD20 + nAB);
	SetLocalInt(oPC, "AttackRollConcealed", 0);

	nHit = GetHit(oWeapon, oFoe, nFoeAC, nd20, nD20, nAB, nCritRange, nCritConfirmBonus, oPC);

	if (GetLocalInt(oPC, "LightningRecovery") == 2)
	{
		SetLocalInt(oPC, "LightningRecovery", 0);
		FloatingTextStringOnCreature("<color=cyan>*Lightning Recovery!*</color>", oPC, TRUE, 3.0f, COLOR_CYAN, COLOR_BLUE_DARK);
		RunSwiftAction(86, "C");
	}

	if (bCombatLog == TRUE)
	{
		//Combat log data.
		object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
		object oOffHand;

		if ((oLeft == OBJECT_INVALID) && (!GetIsPlayableRacialType(oPC)))
		{
			oOffHand = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
		}
		else oOffHand = oLeft;

		if ((nHit == 0) && (GetLocalInt(oToB, "AttackRollConcealed") > 0))
		{
			SendMessageToPC(oPC, "<color=chocolate>You missed the target due to concealment!</color>");
		}
		else if ((nHit == 0) && (oWeapon != OBJECT_INVALID) && (oWeapon == oOffHand))
		{
			SendMessageToPC(oPC, "<color=chocolate>Off Hand : </color>" + "<color=paleturquoise>" + GetName(oPC) + "</color>" + "<color=chocolate> attacks " + GetName(oFoe) + " : *miss* : (" + IntToString(nAB) + " + " + IntToString(nD20) + " = " + IntToString(nAB + nD20) + ").</color>");
		}
		else if ((nHit == 1) && (oWeapon != OBJECT_INVALID) && (oWeapon == oOffHand))
		{
			SendMessageToPC(oPC, "<color=chocolate>Off Hand : </color>" + "<color=paleturquoise>" + GetName(oPC) + "</color>" + "<color=chocolate> attacks " + GetName(oFoe) + " : *hit* : (" + IntToString(nAB) + " + " + IntToString(nD20) + " = " + IntToString(nAB + nD20) + ").</color>");
		}
		else if ((nHit == 2) && (oWeapon != OBJECT_INVALID) && (oWeapon == oOffHand))
		{
			FloatingTextStringOnCreature("<color=red>*Critical Hit!*</color>", oPC, TRUE, 3.0f, COLOR_RED, COLOR_RED_DARK);
			SendMessageToPC(oPC, "<color=chocolate>Off Hand : </color>" + "<color=paleturquoise>" + GetName(oPC) + "</color>" + "<color=chocolate> attacks " + GetName(oFoe) + " : *critical hit* : (" + IntToString(nAB) + " + " + IntToString(nD20) + " = " + IntToString(nAB + nD20) + " : Threat Roll: " + IntToString(nAB + nCritConfirmBonus) + " + " + IntToString(nd20) + " = " + IntToString(nAB + nCritConfirmBonus + nd20) + ").</color>");
		}
		else if (nHit == 0)
		{
			SendMessageToPC(oPC, "<color=paleturquoise>" + GetName(oPC) + "</color>" + "<color=chocolate> attacks " + GetName(oFoe) + " : *miss* : (" + IntToString(nAB) + " + " + IntToString(nD20) + " = " + IntToString(nAB + nD20) + ").</color>");
		}
		else if (nHit == 1)
		{
			SendMessageToPC(oPC, "<color=paleturquoise>" + GetName(oPC) + "</color>" + "<color=chocolate> attacks " + GetName(oFoe) + " : *hit* : (" + IntToString(nAB) + " + " + IntToString(nD20) + " = " + IntToString(nAB + nD20) + ").</color>");
		}
		else if (nHit == 2)
		{
			FloatingTextStringOnCreature("<color=red>*Critical Hit!*</color>", oPC, TRUE, 3.0f, COLOR_RED, COLOR_RED_DARK);
			SendMessageToPC(oPC, "<color=paleturquoise>" + GetName(oPC) + "</color>" + "<color=chocolate> attacks " + GetName(oFoe) + " : *critical hit* : (" + IntToString(nAB) + " + " + IntToString(nD20) + " = " + IntToString(nAB + nD20) + " : Threat Roll: " + IntToString(nAB + nCritConfirmBonus) + " + " + IntToString(nd20) + " = " + IntToString(nAB + nCritConfirmBonus + nd20) + ").</color>");
		}
	}

	return nHit;
}

// Plays a sound based on the results of StrikeAttackRoll.
// -oWeapon: Weapon in right or left hand.
// -oTarget: Creature where we want to play the hit or miss sound.
// -nHit: Either a miss, hit, or critical hit. 0, 1, or 2.
// -fDelay: Amount of time to delay the sound effect by.  There is a minimum 0.1 delay while the sound 
// creature is created.
// -nAttackCry: Plays the character's attacking grunt sound while set to TRUE.
// -sOverride: For a valid sound creature's tag, this will use that creature's sfx instead of the normal sfx.
//	Set it to FALSE if you wish to use another sound or none at all when attacking.
void StrikeAttackSound(object oWeapon, object oTarget, int nHit, float fDelay = 0.0f, int bAttackCry = TRUE, string sOverride = "")
{
	object oPC = OBJECT_SELF;
	location lTarget = GetLocation(oTarget);
	string sNinja;// Name of the creature to create, which plays the sound.
	
	if ((bAttackCry == TRUE) && (GetIsPC(oPC)))
	{
		int nD3 = d3(1);
	
		switch (nD3)
		{
			case 1: PlayVoiceChat(VOICE_CHAT_GATTACK1, oPC); break;
			case 2: PlayVoiceChat(VOICE_CHAT_GATTACK2, oPC); break;
			case 3: PlayVoiceChat(VOICE_CHAT_GATTACK3, oPC); break;
		}
	}

	if (nHit > 0)
	{
		DelayCommand(fDelay + 0.1f, StrikeItemPropSound(oWeapon, oTarget));
	}

	if (sOverride != "")
	{
		sNinja = sOverride;
	}
	else sNinja = SoundNinja(oWeapon, oTarget, nHit);

	DelayCommand(fDelay, WrapperCreateObject(OBJECT_TYPE_CREATURE, sNinja, lTarget));
}

// Applies base weapon damage, visual effects and critical hit damage based on
// the results of StrikeAttackRoll.  0 for miss, 1 for hit, 2 for critical hit.
// -oWeapon: The weapon we're generating attack damage for.
// -nHit: The type of hit or miss we're generating a visual effect for.
// nHit also will apply critical hit damage if it equals 2.
// -oFoe: Our target gets chances to defend against certain effects!
// -nMisc: Any misc bonues to damage.
// -bIgnoreResistances: Sets if this attack bypasses DR or not.  Defaults to FALSE.
// -nMult: Number to multiply total damage by.  Defaults to one.
effect BaseStrikeDamage(object oWeapon, int nHit, object oFoe, int nMisc = 0, int bIgnoreResistances = FALSE, int nMult = 1)
{
	object oPC = OBJECT_SELF;
	effect eLink;

	StrikeVFXDamage(oWeapon, nHit, oFoe);

	if (nHit > 0)
	{
		int nSlash, nBlunt, nPierce, nAcid, nCold, nElec, nFire, nSonic, nDivine, nMagic, nPosit, nNegat;

		struct main_damage rDamage = GenerateAttackEffect(oPC, oWeapon, oFoe, nMisc, bIgnoreResistances, nMult);
		struct main_damage rWeapon = GenerateItemProperties(oPC, oWeapon, oFoe, bIgnoreResistances, nMult);

		nSlash += rDamage.nSlash;
		nBlunt += rDamage.nBlunt;
		nPierce += rDamage.nPierce;
		nAcid += rDamage.nAcid;
		nFire += rDamage.nFire;
		nCold += rDamage.nCold;
		nElec += rDamage.nElec;
		nSonic += rDamage.nSonic;
		nDivine += rDamage.nDivine;
		nMagic += rDamage.nMagic;
		nPosit += rDamage.nPosit;
		nNegat += rDamage.nNegat;
		nSlash += rWeapon.nSlash;
		nBlunt += rWeapon.nBlunt;
		nPierce += rWeapon.nPierce;
		nAcid += rWeapon.nAcid;
		nFire += rWeapon.nFire;
		nCold += rWeapon.nCold;
		nElec += rWeapon.nElec;
		nSonic += rWeapon.nSonic;
		nDivine += rWeapon.nDivine;
		nMagic += rWeapon.nMagic;
		nPosit += rWeapon.nPosit;
		nNegat += rWeapon.nNegat;

		int nSneak = GetSneakLevels(oPC);

		if ((nSneak > 0) && (IsTargetValidForSneakAttack(oFoe, oPC)))
		{
			struct main_damage rSneak = SneakAttack(oWeapon, oPC, oFoe, bIgnoreResistances);

			nSlash += rSneak.nSlash;
			nBlunt += rSneak.nBlunt;
			nPierce += rSneak.nPierce;
			nAcid += rSneak.nAcid;
			nFire += rSneak.nFire;
			nCold += rSneak.nCold;
			nElec += rSneak.nElec;
			nSonic += rSneak.nSonic;
			nDivine += rSneak.nDivine;
			nMagic += rSneak.nMagic;
			nPosit += rSneak.nPosit;
			nNegat += rSneak.nNegat;
		}

		if ((nHit == 2) && (!GetIsImmune(oFoe, IMMUNITY_TYPE_CRITICAL_HIT)))
		{
			struct main_damage rCrit = GenerateAttackEffect(oPC, oWeapon, oFoe, nMisc, bIgnoreResistances, nMult);
			struct main_damage rCritEffects = StrikeCriticalEffect(oPC, oWeapon, oFoe, bIgnoreResistances, nMult);

			nSlash += rCrit.nSlash;
			nBlunt += rCrit.nBlunt;
			nPierce += rCrit.nPierce;
			nAcid += rCrit.nAcid;
			nFire += rCrit.nFire;
			nCold += rCrit.nCold;
			nElec += rCrit.nElec;
			nSonic += rCrit.nSonic;
			nDivine += rCrit.nDivine;
			nMagic += rCrit.nMagic;
			nPosit += rCrit.nPosit;
			nNegat += rCrit.nNegat;
			nSlash += rCritEffects.nSlash;
			nBlunt += rCritEffects.nBlunt;
			nPierce += rCritEffects.nPierce;
			nAcid += rCritEffects.nAcid;
			nFire += rCritEffects.nFire;
			nCold += rCritEffects.nCold;
			nElec += rCritEffects.nElec;
			nSonic += rCritEffects.nSonic;
			nDivine += rCritEffects.nDivine;
			nMagic += rCritEffects.nMagic;
			nPosit += rCritEffects.nPosit;
			nNegat += rCritEffects.nNegat;

			if (GetCriticalMultiplier(oWeapon) > 2)
			{
				struct main_damage rCrit3 = GenerateAttackEffect(oPC, oWeapon, oFoe, bIgnoreResistances, nMult);

				nSlash += rCrit3.nSlash;
				nBlunt += rCrit3.nBlunt;
				nPierce += rCrit3.nPierce;
				nAcid += rCrit3.nAcid;
				nFire += rCrit3.nFire;
				nCold += rCrit3.nCold;
				nElec += rCrit3.nElec;
				nSonic += rCrit3.nSonic;
				nDivine += rCrit3.nDivine;
				nMagic += rCrit3.nMagic;
				nPosit += rCrit3.nPosit;
				nNegat += rCrit3.nNegat;
			}
	
			if (GetCriticalMultiplier(oWeapon) > 3)
			{
				struct main_damage rCrit4 = GenerateAttackEffect(oPC, oWeapon, oFoe, bIgnoreResistances, nMult);

				nSlash += rCrit4.nSlash;
				nBlunt += rCrit4.nBlunt;
				nPierce += rCrit4.nPierce;
				nAcid += rCrit4.nAcid;
				nFire += rCrit4.nFire;
				nCold += rCrit4.nCold;
				nElec += rCrit4.nElec;
				nSonic += rCrit4.nSonic;
				nDivine += rCrit4.nDivine;
				nMagic += rCrit4.nMagic;
				nPosit += rCrit4.nPosit;
				nNegat += rCrit4.nNegat;
			}
	
			if (GetCriticalMultiplier(oWeapon) > 4)
			{
				struct main_damage rCrit5 = GenerateAttackEffect(oPC, oWeapon, oFoe, bIgnoreResistances, nMult);

				nSlash += rCrit5.nSlash;
				nBlunt += rCrit5.nBlunt;
				nPierce += rCrit5.nPierce;
				nAcid += rCrit5.nAcid;
				nFire += rCrit5.nFire;
				nCold += rCrit5.nCold;
				nElec += rCrit5.nElec;
				nSonic += rCrit5.nSonic;
				nDivine += rCrit5.nDivine;
				nMagic += rCrit5.nMagic;
				nPosit += rCrit5.nPosit;
				nNegat += rCrit5.nNegat;
			}
		}

		eLink = EffectDamage(nPierce, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL, bIgnoreResistances);

		if (nAcid > 0)
		{
			effect eDmg = EffectDamage(nAcid, DAMAGE_TYPE_ACID, DAMAGE_POWER_NORMAL, bIgnoreResistances);
			eLink = EffectLinkEffects(eDmg, eLink);
		}
		
		if (nSlash > 0)
		{
			effect eDmg = EffectDamage(nSlash, DAMAGE_TYPE_SLASHING, DAMAGE_POWER_NORMAL, bIgnoreResistances);
			eLink = EffectLinkEffects(eDmg, eLink);
		}
	
		if (nBlunt > 0)
		{
			effect eDmg = EffectDamage(nBlunt, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL, bIgnoreResistances);
			eLink = EffectLinkEffects(eDmg, eLink);
		}
	
		if (nCold > 0)
		{
			effect eDmg = EffectDamage(nCold, DAMAGE_TYPE_COLD, DAMAGE_POWER_NORMAL, bIgnoreResistances);
			eLink = EffectLinkEffects(eDmg, eLink);
		}			
	
		if (nElec > 0)
		{
			effect eDmg = EffectDamage(nElec, DAMAGE_TYPE_ELECTRICAL, DAMAGE_POWER_NORMAL, bIgnoreResistances);
			eLink = EffectLinkEffects(eDmg, eLink);
		}
	
		if (nFire > 0)
		{
			effect eDmg = EffectDamage(nFire, DAMAGE_TYPE_FIRE, DAMAGE_POWER_NORMAL, bIgnoreResistances);
			eLink = EffectLinkEffects(eDmg, eLink);
		}
	
		if (nSonic > 0)
		{
			effect eDmg = EffectDamage(nSonic, DAMAGE_TYPE_SONIC, DAMAGE_POWER_NORMAL, bIgnoreResistances);
			eLink = EffectLinkEffects(eDmg, eLink);
		}		
	
		if (nDivine > 0)
		{
			effect eDmg = EffectDamage(nDivine, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_NORMAL, bIgnoreResistances);
			eLink = EffectLinkEffects(eDmg, eLink);
		}			
	
		if (nMagic > 0)
		{
			effect eDmg = EffectDamage(nMagic, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL, bIgnoreResistances);
			eLink = EffectLinkEffects(eDmg, eLink);
		}
	
		if (nPosit > 0)
		{
			effect eDmg = EffectDamage(nPosit, DAMAGE_TYPE_POSITIVE, DAMAGE_POWER_NORMAL, bIgnoreResistances);
			eLink = EffectLinkEffects(eDmg, eLink);
		}
	
		if (nNegat > 0)
		{
			effect eDmg = EffectDamage(nNegat, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_NORMAL, bIgnoreResistances);
			eLink = EffectLinkEffects(eDmg, eLink);
		}
	}

	return eLink;
}

// Applies misc permanent effects to a strike and must be applied seperately from BaseStrikeDamage
effect StrikePermanentEffects(object oWeapon, int nHit, object oFoe)
{
	object oPC = OBJECT_SELF;
	effect eLink;
	
	if (nHit > 0)
	{
		if ((GetHasFeat(FEAT_CRIPPLING_STRIKE, oPC)) && (!GetIsImmune(oFoe, IMMUNITY_TYPE_CRITICAL_HIT)) && (GetLocalInt(oPC, "SneakHasHit") == 1))
		{
			effect eCrippling = EffectAbilityDecrease(ABILITY_STRENGTH, 2);
			eCrippling = ExtraordinaryEffect(eCrippling);
			eCrippling = SetEffectSpellId(eCrippling, -1);
			eLink = EffectLinkEffects(eCrippling, eLink);
		} 
	}
	// Critical Hit only.
	if ((nHit == 2) && (!GetIsImmune(oFoe, IMMUNITY_TYPE_CRITICAL_HIT)))
	{
		if (GetHasFeat(2150, oPC)) //Weakening Critical
		{
			effect eWeakeningCrit = EffectAbilityDecrease(ABILITY_STRENGTH, 2);
			eWeakeningCrit = ExtraordinaryEffect(eWeakeningCrit);
			eWeakeningCrit = SetEffectSpellId(eWeakeningCrit, -1);
			eLink = EffectLinkEffects(eLink, eWeakeningCrit);
		}
		
		if (GetHasFeat(2151, oPC)) //Wounding Critical
		{
			effect eWoundingCrit = EffectAbilityDecrease(ABILITY_CONSTITUTION, 2);
			eWoundingCrit = ExtraordinaryEffect(eWoundingCrit);
			eWoundingCrit = SetEffectSpellId(eWoundingCrit, -1);
			eLink = EffectLinkEffects(eLink, eWoundingCrit);
		}
	}

	return eLink;
}

// Applies the results of weapon and feat modifiers on a martial strike.
// -oWeapon: Either right or left hand are vaild. (GetItemInSlot returning
// OBJECT_INVALID should return unarmed damage.
// -nHit: 0 for miss, 1 for hit, 2 for critical hit.
// -oFoe: The target of the strike.
// -nMisc: Any misc bonunes to damage.
// -bIgnoreResistances: Determines if the strike bypasses DR or not.
// -bSupressDamage: When set to TRUE prevents the strike from doing any damage
// but, all other events will occur, such as tracking for counter maneuvers.
// -nMult: Number to multiply total damage by.  Defaults to one.
void StrikeWeaponDamage(object oWeapon, int nHit, object oTarget, int nMisc = 0, int bIgnoreResistances = FALSE, int bSupressDamage = FALSE, int nMult = 1)
{	
	object oPC = OBJECT_SELF;
	object oFoe;

	// Special Cases

	int nRedirect;

	if ((GetLocalInt(oTarget, "ManticoreParry") == 1) || (GetLocalInt(oTarget, "ScorpionParry") == 1) || (GetLocalInt(oTarget, "ShieldCounter") == 1) || (GetLocalInt(oTarget, "FoolsStrike") == 1) || (GetLocalInt(oTarget, "Ghostly") == 1))
	{
		if (GetLocalInt(oTarget, "Swift") == 0)
		{
			nRedirect = 1;
		}
	}

	if ((nRedirect == 1) && (GetLocalInt(oTarget, "ManticoreParry") == 1) && (GetIsObjectValid(oWeapon)) && (!GetWeaponRanged(oWeapon)))
	{
		nRedirect = 0;
		SetLocalInt(oTarget, "ManticoreParry", 2); // For this maneuver roles are reversed.  The oTarget should be a PC and oPC should be an enemey.

		object oFoeWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
		int nFoeAB = GetMaxAB(oTarget, oFoeWeapon, oPC);
		int nAB = GetMaxAB(oPC, oWeapon, oTarget);
		int nd20 = d20(1);
		int nFoed20 = d20(1);
		int nFoeRoll = nFoeAB + nFoed20;
		int nMyRoll = nAB + nd20;

		SendMessageToPC(oTarget, "<color=chocolate>Manticore Parry: Opposed Attack Roll: " + GetName(oTarget) + " (" + IntToString(nFoeAB) + " + " + IntToString(nFoed20) + " = " + IntToString(nFoeRoll) + ") vs. " + GetName(oPC) + " (" + IntToString(nAB) + " + " + IntToString(nd20) + " = " + IntToString(nMyRoll) + ").</color>");

		if (nFoeRoll > nMyRoll)
		{
			FloatingTextStringOnCreature("<color=cyan>*Manticore Parry!*</color>", oTarget, TRUE, 3.0f, COLOR_CYAN, COLOR_BLUE_DARK);

			float fRange = GetMeleeRange(oTarget);
			location lPC = GetLocation(oTarget);
			object oAlly;

			oAlly = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);

			while (GetIsObjectValid(oAlly))
			{
				if ((oAlly != oPC) && (oAlly != oTarget) && (GetIsReactionTypeHostile(oAlly, oTarget)))
				{
					oFoe = oAlly;
					break;
				}
				else oFoe = OBJECT_INVALID;

				oAlly = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);
			}

			if (GetIsObjectValid(oFoe))
			{
				effect eRedirect = EffectVisualEffect(VFX_TOB_REDIRECT);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRedirect, oTarget, 1.0f);
				SpawnBloodHit(oFoe, OVERRIDE_ATTACK_RESULT_CRITICAL_HIT, oPC);
			}
		}
		else 
		{
			FloatingTextStringOnCreature("<color=red>*Manticore Parry Failed!*</color>", oTarget, TRUE, 3.0f, COLOR_RED, COLOR_RED_DARK);
			oFoe = oTarget;
		}
	}
	else oFoe = oTarget;

	if ((nRedirect == 1) && (GetLocalInt(oTarget, "ScorpionParry") == 1) && (!GetWeaponRanged(oWeapon)))// The only difference between this and Manticore Parry is that this can be used against unarmed attacks.
	{
		nRedirect = 0;
		SetLocalInt(oTarget, "ScorpionParry", 2); // For this maneuver roles are reversed.  The oTarget should be a PC and oPC should be an enemey.

		object oFoeWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
		int nFoeAB = GetMaxAB(oTarget, oFoeWeapon, oPC);
		int nAB = GetMaxAB(oPC, oWeapon, oFoe);
		int nd20 = d20(1);
		int nFoed20 = d20(1);
		int nFoeRoll = nFoeAB + nFoed20;
		int nMyRoll = nAB + nd20;

		SendMessageToPC(oTarget, "<color=chocolate>Scorpion Parry: Opposed Attack Roll: " + GetName(oTarget) + " (" + IntToString(nFoeAB) + " + " + IntToString(nFoed20) + " = " + IntToString(nFoeRoll) + ") vs. " + GetName(oPC) + " (" + IntToString(nAB) + " + " + IntToString(nd20) + " = " + IntToString(nMyRoll) + ").</color>");

		if (nFoeRoll > nMyRoll)
		{
			FloatingTextStringOnCreature("<color=cyan>*Scorpion Parry!*</color>", oTarget, TRUE, 3.0f, COLOR_CYAN, COLOR_BLUE_DARK);

			float fRange = GetMeleeRange(oTarget);
			location lPC = GetLocation(oTarget);
			object oAlly;

			oAlly = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);

			while (GetIsObjectValid(oAlly))
			{
				if ((oAlly != oPC) && (oAlly != oTarget) && (GetIsReactionTypeHostile(oAlly, oTarget)))
				{
					oFoe = oAlly;
					break;
				}
				else oFoe = OBJECT_INVALID;

				oAlly = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);
			}

			if (GetIsObjectValid(oFoe))
			{
				effect eRedirect = EffectVisualEffect(VFX_TOB_REDIRECT);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRedirect, oTarget, 1.0f);
				SpawnBloodHit(oFoe, OVERRIDE_ATTACK_RESULT_CRITICAL_HIT, oPC);
			}
		}
		else 
		{
			FloatingTextStringOnCreature("<color=red>*Scorpion Parry Failed!*</color>", oTarget, TRUE, 3.0f, COLOR_RED, COLOR_RED_DARK);
			oFoe = oTarget;
		}
	}
	else oFoe = oTarget;

	if ((nRedirect == 1) && (GetLocalInt(oTarget, "ShieldCounter") == 1))
	{
		object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
		int nShield = GetBaseItemType(oShield);

		if (nShield == BASE_ITEM_SMALLSHIELD || nShield == BASE_ITEM_TOWERSHIELD || nShield == BASE_ITEM_LARGESHIELD)
		{
			nRedirect = 0;

			SetLocalInt(oTarget, "ShieldCounter", 2);
			WrapperPlayCustomAnimation(oTarget, "shieldbash", 0);
			SendMessageToPC(oTarget, "<color=chocolate>Shield Counter Attack Roll:</color>");

			int nBash = StrikeAttackRoll(oShield, oPC, -2, TRUE, 0, oTarget);

			if (nBash > 0)
			{
				effect eRedirect = EffectVisualEffect(VFX_TOB_REDIRECT);
				oFoe = OBJECT_INVALID;

				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRedirect, oTarget, 1.0f);
				FloatingTextStringOnCreature("<color=cyan>*Shield Counter!*</color>", oTarget, TRUE, 3.0f, COLOR_CYAN, COLOR_BLUE_DARK);
			}
			else 
			{
				FloatingTextStringOnCreature("*Shield Counter Failed!*", oTarget, TRUE, 3.0f, COLOR_RED, COLOR_RED_DARK);
				oFoe = oTarget;
			}
		}
		else oFoe = oTarget;
	}
	else oFoe = oTarget;

	if ((nRedirect == 1) && (GetLocalInt(oTarget, "FoolsStrike") == 1) && (!GetWeaponRanged(oWeapon)))
	{
		nRedirect = 0;
		SetLocalInt(oTarget, "FoolsStrike", 2); // For this maneuver roles are reversed.  The oTarget should be a PC and oPC should be an enemey.

		object oFoeWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
		int nFoeAB = GetMaxAB(oTarget, oFoeWeapon, oPC);
		int nAB = GetMaxAB(oPC, oWeapon, oFoe);
		int nd20 = d20(1);
		int nFoed20 = d20(1);
		int nFoeRoll = nFoeAB + nFoed20;
		int nMyRoll = nAB + nd20;

		SendMessageToPC(oTarget, "<color=chocolate>Fool's Strike: Opposed Attack Roll: " + GetName(oTarget) + " (" + IntToString(nFoeAB) + " + " + IntToString(nFoed20) + " = " + IntToString(nFoeRoll) + ") vs. " + GetName(oPC) + " (" + IntToString(nAB) + " + " + IntToString(nd20) + " = " + IntToString(nMyRoll) + ").</color>");

		if (nFoeRoll > nMyRoll)
		{
			FloatingTextStringOnCreature("<color=cyan>*FoolsStrike!*</color>", oTarget, TRUE, 3.0f, COLOR_CYAN, COLOR_BLUE_DARK);

			oFoe = OBJECT_SELF;
			effect eRedirect = EffectVisualEffect(VFX_TOB_REDIRECT);

			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRedirect, oTarget, 1.0f);
			SpawnBloodHit(oFoe, OVERRIDE_ATTACK_RESULT_CRITICAL_HIT, oPC);
		}
		else 
		{
			FloatingTextStringOnCreature("<color=red>*Fool's Strike Failed!*</color>", oTarget, TRUE, 3.0f, COLOR_RED, COLOR_RED_DARK);
			oFoe = oTarget;
		}
	}
	else oFoe = oTarget;

	if ((nRedirect == 1) && (nHit == 0) && (GetLocalInt(oPC, "AttackRollConcealed") > 0) && (GetLocalInt(oPC, "Ghostly") == 0))
	{
		nRedirect = 0;
		SetLocalInt(oTarget, "Ghostly", 0); // For this maneuver roles are reversed.  The oTarget should be a PC and oPC should be an enemey.

		FloatingTextStringOnCreature("<color=cyan>*Ghostly Defense!*</color>", oTarget, TRUE, 3.0f, COLOR_CYAN, COLOR_BLUE_DARK);

		float fRange = GetMeleeRange(oTarget);
		location lPC = GetLocation(oTarget);
		object oAlly;

		oAlly = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);

		while (GetIsObjectValid(oAlly))
		{
			if ((oAlly != oPC) && (oAlly != oTarget) && (GetIsReactionTypeHostile(oAlly, oTarget)))
			{
				oFoe = oAlly;
				break;
			}
			else oFoe = OBJECT_INVALID;

			oAlly = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);
		}

		if (GetIsObjectValid(oFoe))
		{
			effect eRedirect = EffectVisualEffect(VFX_TOB_REDIRECT);
			nHit = StrikeAttackRoll(oWeapon, oAlly);

			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRedirect, oTarget, 1.0f);
			SpawnBloodHit(oFoe, OVERRIDE_ATTACK_RESULT_CRITICAL_HIT, oPC);
		}
	}
	else oFoe = oTarget;

	if (oFoe == OBJECT_INVALID)
	{
		return; // Cancel everything else if the target has been negated.
	}

	WatchOpponent(oFoe, oPC);
	DelayCommand(0.5f, WatchOpponent(oFoe, oPC));
	DelayCommand(1.5f, WatchOpponent(oFoe, oPC));
	DelayCommand(2.5f, WatchOpponent(oFoe, oPC));
	DelayCommand(3.5f, WatchOpponent(oFoe, oPC));
	DelayCommand(4.5f, WatchOpponent(oFoe, oPC));
	DelayCommand(5.5f, WatchOpponent(oFoe, oPC));

	if (nHit == 0) // Things that happen on a miss.
	{
		if (GetLocalInt(oFoe, "PearlofBlackDoubtActive") == 1)
		{
			int nPearlAC = GetLocalInt(oFoe, "PearlAC");
			SetLocalInt(oFoe, "PearlAC", nPearlAC + 2);
		}
	}

	if (nHit > 0) //Things that happen on hits.
	{
		if (bSupressDamage == FALSE)
		{
			effect eBase = BaseStrikeDamage(oWeapon, nHit, oFoe, nMisc, bIgnoreResistances, nMult);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eBase, oFoe);
		}

		effect ePerm = StrikePermanentEffects(oWeapon, nHit, oFoe);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePerm, oFoe);

		if (GetLocalInt(oPC, "SneakHasHit") == 1)
		{
			FloatingTextStringOnCreature("<color=red>*Sneak Attack!*</color>", oPC, TRUE, 3.0f, COLOR_GREY, COLOR_BLACK);
		}

		if ((GetHasFeat(2054, oPC)) || (GetHasFeat(2053, oPC)) || (GetHasFeat(2052, oPC))) //Bleeding Wound 1-3
		{
			effect eBlW = IBBleedingWound();
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlW, oFoe, 18.0f);
		}

		if ((GetWeaponRanged(oWeapon)) && (GetHasFeat(FEAT_TW_MISSILE_VOLLEYS, oPC)))
		{
			effect eVolley = MissileVolley(oPC, oWeapon);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVolley, oFoe, 6.0f);
		}

		// Needs Testing Still!
		if (GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_REGENERATION_VAMPIRIC))
		{
			itemproperty iVamp = GetFirstItemProperty(oWeapon);
			
			while (GetIsItemPropertyValid(iVamp))
			{
				if (GetItemPropertyType(iVamp) == ITEM_PROPERTY_REGENERATION_VAMPIRIC)
				{
					int nVamp = GetDamageByIPConstDamageBonus(GetItemPropertyCostTableValue(iVamp));
					effect eVamp = ManeuverHealing(oPC, nVamp);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eVamp, oPC);
					break;
				}
				iVamp = GetNextItemProperty(oWeapon);
			}
		}

		if (GetWeaponRanged(oWeapon))
		{
			int nBaseType = GetBaseItemType(oWeapon);

			object oAmmo;
			if (nBaseType == BASE_ITEM_LIGHTCROSSBOW || nBaseType == BASE_ITEM_HEAVYCROSSBOW)
				oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS);
			if (nBaseType == BASE_ITEM_LONGBOW || nBaseType == BASE_ITEM_SHORTBOW)
				oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS);
			if (nBaseType == BASE_ITEM_SLING)
				oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS);						

			itemproperty iVamp = GetFirstItemProperty(oAmmo);
			while (GetIsItemPropertyValid(iVamp))
			{
				if (GetItemPropertyType(iVamp)== ITEM_PROPERTY_REGENERATION_VAMPIRIC)
				{
					int nVamp = GetDamageByIPConstDamageBonus(GetItemPropertyCostTableValue(iVamp));
					effect eVamp = ManeuverHealing(oPC, nVamp);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eVamp, oPC);
					break;
				}
				iVamp = GetNextItemProperty(oWeapon);
			}
		}

		//Maneuver Specific
		DoMartialSpirit();
		DoCoveringStrike(oFoe);
		DoAuraOfTriumph(oFoe);

		if (GetLocalInt(oPC, "Girallon") == 1)
		{
			int g, nGirHits;
			object oTest;

			g = 1;
			oTest = GetLocalObject(oPC, "GirallonFoe" + IntToString(g));

			if (GetIsObjectValid(oTest))
			{
				while (GetIsObjectValid(oTest))
				{
					if (oTest == oFoe)
					{
						nGirHits = GetLocalInt(oPC, "GirallonHits" + IntToString(g));

						SetLocalObject(oPC, "GirallonFoe" + IntToString(g), oTest);
						SetLocalInt(oPC, "GirallonHits" + IntToString(g), nGirHits + 1);
						break;
					}

					g++;
					oTest = GetLocalObject(oPC, "GirallonFoe" +IntToString(g));
				}
			}
			else // Should be only for the first object found.
			{
				nGirHits = GetLocalInt(oPC, "GirallonHits" + IntToString(g));

				SetLocalObject(oPC, "GirallonFoe" + IntToString(g), oTest);
				SetLocalInt(oPC, "GirallonHits" + IntToString(g), nGirHits + 1);
			}
				
		}
	}

	if (nHit == 2) //Things that happen on Critical Hits.
	{
		DoBloodInTheWater();
	}

	// Things that happen if you hit or miss.

	if ((GetLocalInt(oFoe, "BafflingDefenseActive") == 1) && (GetLocalInt(oFoe, "Swift") == 0))
	{
		SetLocalInt(oFoe, "BafflingDefenseActive", 2);
	}

	if ((GetLocalInt(oFoe, "LeapingFlameActive") == 1) && (GetLocalInt(oFoe, "Swift") == 0))
	{
		SetLocalInt(oFoe, "LeapingFlameActive", 2);
		SetLocalObject(oFoe, "LeapingFlameTarget", oPC);
	}

	if ((GetLocalInt(oFoe, "ShieldBlockActive") == 1) && (GetLocalInt(oFoe, "Swift") == 0))
	{
		SetLocalInt(oFoe, "ShieldBlockActive", 2);
	}

	if ((GetLocalInt(oFoe, "WallofBladesActive") == 1) && (GetLocalInt(oFoe, "Swift") == 0))
	{
		SetLocalInt(oFoe, "WallofBladesActive", 2);
	}

	if ((GetLocalInt(oFoe, "ZephyrDanceActive") == 1) && (GetLocalInt(oFoe, "Swift") == 0))
	{
		SetLocalInt(oFoe, "ZephyrDanceActive", 2);
	}
}