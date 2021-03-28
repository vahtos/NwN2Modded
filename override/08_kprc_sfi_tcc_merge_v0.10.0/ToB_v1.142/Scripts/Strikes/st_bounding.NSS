//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 9/7/2009								//
//	Title: st_bounding							//
//	Description: As part of this maneuver, make //
//  a double move. After you move, you can also //
//  make a melee attack. You gain a +2 bonus on //
//  this attack. This maneuver is considered a  //
//  charge attack when determining if feats and //
//  other abilities apply to your attack.		//
//////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 56);
	
	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DiamondMindStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DiamondMindStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nRoll = StrikeAttackRoll(oWeapon, oTarget, 2);

	StrikeAttackSound(oWeapon, oTarget, nRoll, 0.3f);
	DelayCommand(0.1f, BasicAttackAnimation(oWeapon, nRoll)); 
	DelayCommand(0.4f, StrikeWeaponDamage(oWeapon, nRoll, oTarget));
	ExpendManeuver(56, "STR"); 
}