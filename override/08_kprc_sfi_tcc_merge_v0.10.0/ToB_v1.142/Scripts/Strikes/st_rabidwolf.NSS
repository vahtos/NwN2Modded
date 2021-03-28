//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 7/23/2009								//
//	Title: st_rabidwolf							//
//	Description: As part of this maneuver, you  //
//  make a single melee attack. You gain a +4   //
//	bonus on this attack roll and deal an extra //
//	2d6 points of damage. You take a –4 penalty //
//  to AC until the start of your next turn.	//
//////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_feats"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 179);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "TigerClawStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "TigerClawStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget, 4);
		
	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	WrapperPlayCustomAnimation(oPC, "*powerattack", 0);
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget, d6(2)));
	ExpendManeuver(179, "STR");

	if ((nHit > 0) && (GetHasFeat(FEAT_TIGER_BLOODED, oPC)))
	{
		DelayCommand(0.3f, TigerBlooded(oPC, oWeapon, oTarget));
	}

	effect eAC = EffectACDecrease(4);
	eAC = ExtraordinaryEffect(eAC);

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, 6.0f);
}