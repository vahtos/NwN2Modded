//////////////////////////////////////////////////////////////
//	Author: Drammel											//
//	Date: 10/17/2009										//
//	Title: st_swooping_drg									//
//	Description: As part of this maneuver, you  attempt a   //
//  Jump check to leap over your target.  If your check is  //
//  insufficient to jump over your target, you make a single//
//  attack against your foe with no special benefits or     //
//  penalties, as long as your target is within reach.  If  //
//  the check succeeds, you do not provoke attacks of       //
//  opportunity for leaving threatened squares as you jump  //
//  over your foe. Your foe loses her Dexterity bonus to AC //
//  against your melee attack. This attack deals an extra   //
//  10d6 points of damage, and the target must succeed on a //
//  Fortitude save (DC equal to your Jump check result) or  //
//  be stunned for 1 round.                                 //
//////////////////////////////////////////////////////////////

#include "tob_i0_spells"
#include "bot9s_combat_overrides"
#include "bot9s_inc_feats"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"
#include "tob_x0_i0_position"

void SwoopingDragonStrike(object oWeapon, object oTarget, int nTaunt)
{
	object oPC = OBJECT_SELF;
	int nHit = StrikeAttackRoll(oWeapon, oTarget);
	float fSpace = GetDistanceBetween(oPC, oTarget);
	float fDist = GetGirth(oTarget) + fSpace + 0.01f;
	location lTest = GetOppositeLocation(oPC, fDist);
	location lLand;

	if (GetIsLocationValid(lTest))
	{
		lLand = lTest;
	}
	else lLand = CalcSafeLocation(oPC, lTest, FeetToMeters(5.0f), TRUE, FALSE);

	if (GetIsLocationValid(lLand))
	{
		DelayCommand(1.01f, JumpToLocation(lLand));
	}

	StrikeAttackSound(oWeapon, oTarget, nHit, 1.43f);
	WrapperPlayCustomAnimation(oPC, "leapup", 0);
	DelayCommand(1.02f, WrapperPlayCustomAnimation(oPC, "*leapattack", 0));
	DelayCommand(1.53f, StrikeWeaponDamage(oWeapon, nHit, oTarget, d6(10)));

	if (!GetIsImmune(oTarget, IMMUNITY_TYPE_STUN))
	{
		int nFort = MySavingThrow(SAVING_THROW_FORT, oTarget, nTaunt);

		if (nFort == 0)
		{
			effect eSwoop = EffectStunned();
			eSwoop = ExtraordinaryEffect(eSwoop);

			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSwoop, oTarget, 6.0f);
		}
	}

	if ((nHit > 0) && (GetHasFeat(FEAT_TIGER_BLOODED, oPC)))
	{
		DelayCommand(1.53f, TigerBlooded(oPC, oWeapon, oTarget));
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 183);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "TigerClawStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "TigerClawStrike", 0));
	
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nd20 = d20(1);
	int nJump = GetJumpSkill();
	int nRoll = nd20 + nJump;

	/* Treating this as a High Jump since the intent is to get over the target 
	rather than through.  I'm also treating this as a "Hop Up", since the example
	in the Rules Compendium on page 93 better fits the situation.  However, 
	since "Hop Up" is only used for objects "of waist height" I'm adding half of
	of the target's height to the final number that determines the DC since we
	still need to actually jump over the target, rather than just enough to kick
	his head. This keeps the DC reasonable.  That is to say, a "Hop Up" doesn't 
	require the player making the Jump check to double the DC if they didn't get
	a running start, which is certainly the case when initiating this maneuver. 
	It only adds a small amount to the clearance distance. The DC is equal to the
	distance we want to clear (the height of the target in feet) multiplied by 
	four.  Even without doubling the DC it's still fairly tricky to Jump over
	your average human. */

	int nAppearance = GetAppearanceType(oTarget);
	string sHeight = Get2DAString("appearance", "HEIGHT", nAppearance);
	float fMeters = StringToFloat(sHeight);
	float fHalf = fMeters / 2;
	float fFeet = (fMeters + fHalf) * 3.28083989501312f; // Meters to Feet conversion.
	float fDC = fFeet * 4;
	int nDC = FloatToInt(fDC);

	SendMessageToPC(oPC, "<color=chocolate>" + GetName(oPC) + ": Taunt: (" + IntToString(nd20) + " + " + IntToString(nJump) + " = " + IntToString(nRoll) + ") vs. DC: " + IntToString(nDC) + "</color>");
	ExpendManeuver(183, "STR");

	if (nRoll >= nDC)
	{
		OverrideAttackRollAC(oTarget, 2);
		DelayCommand(0.2f, RemoveAttackRollOverride(oPC, 1));
		DelayCommand(0.1f, SwoopingDragonStrike(oWeapon, oTarget, nRoll));
	}
	else
	{
		int nHit = StrikeAttackRoll(oWeapon, oTarget);

		StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
		BasicAttackAnimation(oWeapon, nHit); 
		DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));

		if ((nHit > 0) && (GetHasFeat(FEAT_TIGER_BLOODED, oPC)))
		{
			DelayCommand(0.3f, TigerBlooded(oPC, oWeapon, oTarget));
		}
	}	
}