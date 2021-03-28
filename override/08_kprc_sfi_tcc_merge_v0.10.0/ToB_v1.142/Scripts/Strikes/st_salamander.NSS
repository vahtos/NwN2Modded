//////////////////////////////////////////////////////////////////////////
//	Author: Drammel                                                     //
//	Date: 10/15/2009                                                    //
//	Title: st_salamander                                                //
//	Description: You initiate this maneuver as part of a charge attack. //
//  As with a charge, you can move up to double your speed and make a   //
//  single attack, gaining a +2 bonus on the attack roll and a -2       //
//  penalty to your Armor Class while you move and until your next turn.//
//  Unlike a normal charge, however, your salamander charge is not      //
//  impeded by difficult terrain and you can change direction as much as//
//  you want during your movement.  When you initiate a Salamander      //
//  Charge, a wall of shimmering, spectral fire appears in each of the  //
//  squares along the path you take. A creature standing in the wall    //
//  takes 6d6 points of fire damage. A creature occupying a square      //
//  adjacent to the wall takes 3d6 points of fire damage. Creatures that//
//  move into or through the wall also take 6d6 points of fire damage.  //
//  The wall lasts up to 5 rounds. You can automatically dispel the wall//
//  with a wave of your hand (a swift action), and the wall is          //
//  automatically dispelled if you initiate another salamander charge.  //
//  The wall does not block line of sight or line of effect.  This      //
//  maneuver is a supernatural ability.                                 //
//////////////////////////////////////////////////////////////////////////

	/*This script handles the end attack of the charge.  The actual wall
	effect, its location tracking and damage implementation, are handled
	in the script salamander_charge.*/

#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 22);

	DeleteLocalInt(oPC, "SalamanderActive");

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DesertWindStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DesertWindStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nRoll = StrikeAttackRoll(oWeapon, oTarget, 2);

	StrikeAttackSound(oWeapon, oTarget, nRoll, 0.3f);
	DelayCommand(0.1f, BasicAttackAnimation(oWeapon, nRoll)); 
	DelayCommand(0.4f, StrikeWeaponDamage(oWeapon, nRoll, oTarget));
	ExpendManeuver(22, "STR");
}