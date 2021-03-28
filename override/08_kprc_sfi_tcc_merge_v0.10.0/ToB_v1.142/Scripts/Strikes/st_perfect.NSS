//////////////////////////////////////////////////////////////////
//	Author: Drammel												//
//	Date: 10/30/2009											//
//	Title: st_perfect											//
//	Description: You make a single melee attack as part of this //
//  strike. If your attack hits, it deals an extra 100 points of//
//  damage (in addition to your normal melee damage).	    	//
//////////////////////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_fx"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 94);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "IronHeartStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "IronHeartStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);
	effect eVis = EffectVisualEffect(VFX_TOB_PERFECT);

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 2.0f);
	StrikeAttackSound(oWeapon, oTarget, nHit, 0.7f);
	StrikeTrailEffect(oWeapon, nHit, 0.34f);
	WrapperPlayCustomAnimation(oPC, "*cleave", 0);
	DelayCommand(0.8f, StrikeWeaponDamage(oWeapon, nHit, oTarget, 100));
	ExpendManeuver(94, "STR");
}