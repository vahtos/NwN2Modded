//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 8/7/2009								//
//	Title: st_clawatm							//
//	Description: As part of this maneuver, you  //
//  attempt a Jump check to leap into the air   //
//  and make a melee attack that targets your   //
//  foe’s upper body, face, and neck. The Jump  //
//  check’s DC is equal to your target’s AC. If //
//  this check succeeds, your attack deals an	//
//  extra 2d6 points of damage. If this attack	//
//  threatens a critical hit, you gain a +4 	//
//  bonus on your roll to confi rm the critical //
//  hit.										//
//////////////////////////////////////////////////

#include "bot9s_combat_overrides"
#include "bot9s_inc_feats"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void ClawAtTheMoon(object oWeapon, object oTarget, int nExtraDamage)
{
	object oPC = OBJECT_SELF;
	int nHit = StrikeAttackRoll(oWeapon, oTarget);

	StrikeAttackSound(oWeapon, oTarget, nHit, 1.43f);
	WrapperPlayCustomAnimation(oPC, "leapup", 0);
	DelayCommand(1.02f, WrapperPlayCustomAnimation(oPC, "*leapattack", 0));
	DelayCommand(1.53f, StrikeWeaponDamage(oWeapon, nHit, oTarget, nExtraDamage));

	if ((nHit > 0) && (GetHasFeat(FEAT_TIGER_BLOODED, oPC)))
	{
		DelayCommand(1.53f, TigerBlooded(oPC, oWeapon, oTarget));
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 166);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "TigerClawStrike", 1);
	DelayCommand(RoundsToSeconds(1), SetLocalInt(oToB, "TigerClawStrike", 0));
	
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nd20 = d20(1);
	int nJump = GetJumpSkill();
	int nRoll = nd20 + nJump;
	int nDC = GetAC(oTarget);

	SendMessageToPC(oPC, "<color=chocolate>" + GetName(oPC) + ": Taunt: (" + IntToString(nd20) + " + " + IntToString(nJump) + " = " + IntToString(nRoll) + ") vs. DC: " + IntToString(nDC) + "</color>");
	ExpendManeuver(166, "STR");

	if (nRoll >= nDC)
	{
		int nCritConfirmBonus = GetCriticalConfirmMod(oWeapon) + 4;

		OverrideCritConfirmationBonus(oPC, nCritConfirmBonus);
		DelayCommand(0.2f, RemoveAttackRollOverride(oPC, 6));
		DelayCommand(0.1f, ClawAtTheMoon(oWeapon, oTarget, d6(2)));
	}
	else ClawAtTheMoon(oWeapon, oTarget, 0);
}