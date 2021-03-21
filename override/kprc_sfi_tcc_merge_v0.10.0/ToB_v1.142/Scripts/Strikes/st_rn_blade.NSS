//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 9/7/2009								//
//	Title: st_rn_blade							//
//	Description: You attempt a Concentration	//
//  check as part of this maneuver, using the   //
//  target creature's AC as the DC of the check.//
//  You then make a single melee attack against //
//  your target. This attack is also made as 	//
//  part of this maneuver. If your Concentration//
//  check succeeds, this melee attack deals 	//
//  double normal melee damage. If your check	//
//  fails, your attack is made with a -2 penalty//
//  and deals only normal melee damage. 		//
//  If your strike is a critical hit, you stack //
//  the multipliers as normal.					//
//////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_inc_constants"

void RubyNightmareBlade(object oTarget)
{
	object oPC = OBJECT_SELF;
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);

	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	BasicAttackAnimation(oWeapon, nHit, FALSE, FALSE); 
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget, 0, FALSE, FALSE, 2));
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 71);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DiamondMindStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DiamondMindStrike", 0));
	
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

	int nRanks = GetSkillRank(SKILL_CONCENTRATION);
	int nFoeAC = GetAC(oTarget);
	int nD20 = d20(1);
	int nConcentration = nD20 + nRanks;

	SendMessageToPC(oPC, "<color=chocolate>Ruby Nightmare Blade: Concentration : " + "(" + IntToString(nRanks) + " + " + IntToString(nD20) + " = " + IntToString(nConcentration) + ") vs. " + GetName(oTarget) + "'s AC : (" + IntToString(nFoeAC) + ").</color>");

	if (nConcentration >= nFoeAC)
	{
		effect eRNB = EffectVisualEffect(VFX_TOB_RNBLADE);

		DelayCommand(1.0f, RubyNightmareBlade(oTarget));
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRNB, oPC, 6.0f);
		ExpendManeuver(71, "STR");
	}
	else
	{
		int nHit = StrikeAttackRoll(oWeapon, oTarget, -2);

		StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
		BasicAttackAnimation(oWeapon, nHit); 
		DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));
		ExpendManeuver(71, "STR");
	}
}