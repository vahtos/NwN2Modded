//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 6/19/2009							//
//	Title: st_wolffang						//
//	Description: Standard Action; Allow the //
//	player to make an attack with each		//
//	weapon they have equipped.  Will not	//
//	function if the player has a two-handed //
//	weapon.									//
//////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_feats"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 185);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	object oOffhand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

	if (!IsWeaponTwoHanded(oPC))
	{
		SetLocalInt(oToB, "TigerClawStrike", 1);
		DelayCommand(6.0f, SetLocalInt(oToB, "TigerClawStrike", 0));

		int nHit1 = StrikeAttackRoll(oWeapon, oTarget);
		int nHit2 = StrikeAttackRoll(oOffhand, oTarget);
		
		StrikeAttackSound(oWeapon, oTarget, nHit1, 0.2f);
		StrikeAttackSound(oOffhand, oTarget, nHit2, 0.3f);
	 	BasicAttackAnimation(oWeapon, nHit1, TRUE);

		if (GetHasFeat(FEAT_TIGER_BLOODED, oPC))
		{
			DelayCommand(0.3f, TigerBlooded(oPC, oWeapon, oTarget));
		}

		DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit1, oTarget));
		DelayCommand(0.4f, StrikeWeaponDamage(oOffhand, nHit2, oTarget));
		ExpendManeuver(185, "STR");
	}
	else SendMessageToPC(oPC, "<color=red>You cannot use a two-haned grip on your weapon with this maneuver.</color>");
}