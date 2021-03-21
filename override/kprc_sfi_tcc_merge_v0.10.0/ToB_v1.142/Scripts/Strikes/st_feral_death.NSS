//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: Halloween 2009						//
//	Title: st_feral_death						//
//	Description: To use this maneuver, you must //
//  be adjacent to your intended target. As part//
//  of this maneuver, make a Jump check with a  //
//  DC equal to your opponent's AC. If the check//
//  succeeds, you can then make a single melee  //
//  attack against your foe, also as part of    //
//  this maneuver. The target is considered     //
//  flat-footed against this attack. If your    //
//  attack deals damage, your target must       //
//  attempt a Fortitude save (DC 19 + your Str  //
//  modifier). If this save fails, your target  //
//  is instantly slain. If the save is          //
//  successful, you deal an extra 20d6 points of//
//  damage to the target in addition to your    //
//  normal weapon damage. Creatures immune to   //
//  critical hits are immune to the death effect//
//  of this strike.                             //
//////////////////////////////////////////////////

#include "bot9s_combat_overrides"
#include "bot9s_inc_feats"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"
#include "tob_i0_spells"

void FeralDeathBlow(object oWeapon, object oTarget, int nExtraDamage)
{
	object oPC = OBJECT_SELF;
	int nHit = StrikeAttackRoll(oWeapon, oTarget);
	int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
	int nDC = GetManeuverDC(nStr, 0, 19);
	int nFort = MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DEATH);

	StrikeAttackSound(oWeapon, oTarget, nHit, 0.0f);
	
	if ((nFort == 0) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH)) && (GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD) && (GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT) && (GetRacialType(oTarget) != RACIAL_TYPE_ELEMENTAL))
	{
		effect eDeath = EffectDeath(TRUE);

		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
	}
	else if (GetHasFeat(6818, oTarget)) //Mettle
	{
		StrikeWeaponDamage(oWeapon, nHit, oTarget);
	}
	else StrikeWeaponDamage(oWeapon, nHit, oTarget, nExtraDamage);

	if ((nHit > 0) && (GetHasFeat(FEAT_TIGER_BLOODED, oPC)))
	{
		TigerBlooded(oPC, oWeapon, oTarget);
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 169);

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
	int nDC = GetAC(oTarget);

	SendMessageToPC(oPC, "<color=chocolate>" + GetName(oPC) + ": Taunt: (" + IntToString(nd20) + " + " + IntToString(nJump) + " = " + IntToString(nRoll) + ") vs. DC: " + IntToString(nDC) + "</color>");
	ExpendManeuver(169, "STR");

	if (nRoll >= nDC)
	{
		OverrideAttackRollAC(oTarget, 2);
		DelayCommand(0.2f, RemoveAttackRollOverride(oTarget, 1));
		WrapperPlayCustomAnimation(oPC, "leapup", 0);
		DelayCommand(1.02f, WrapperPlayCustomAnimation(oPC, "*leapattack", 0));
		DelayCommand(1.63f, FeralDeathBlow(oWeapon, oTarget, d6(20)));
	}
	else 
	{
		int nHit = StrikeAttackRoll(oWeapon, oTarget);

		StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
		BasicAttackAnimation(oWeapon, nHit, TRUE);
		DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));

		if ((nHit > 0) && (GetHasFeat(FEAT_TIGER_BLOODED, oPC)))
		{
			DelayCommand(0.4f, TigerBlooded(oPC, oWeapon, oTarget));
		}
	}
}