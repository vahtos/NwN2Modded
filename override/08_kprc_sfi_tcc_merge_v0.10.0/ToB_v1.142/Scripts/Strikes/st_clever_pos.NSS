//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 7/22/2009	 						//
//	Title: st_clever_pos					//
//	Description: As part of this maneuver,  //
//	you make a single melee attack against a//
//	target. If your attack hits, the target //
//	takes damage normally and must make a   //
//	Reflex save (DC 12 + your Dex modifier).//
//	If this save fails, you swap positions  //
//	with the target.						//
//////////////////////////////////////////////

#include "tob_i0_spells"
#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 99);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "SettingSunStrike", 1);
	DelayCommand(RoundsToSeconds(1), SetLocalInt(oToB, "SettingSunStrike", 0));
	
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);

	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	BasicAttackAnimation(oWeapon, nHit); 
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));
	ExpendManeuver(99, "STR");

	if (nHit > 0)
	{
		int nDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
		int nDC = GetManeuverDC(nDex, 0, 12);
		int nReflex = MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC);

		if (nReflex == 0)
		{
			location lPC = GetLocation(oPC);
			location lTarget = GetLocation(oTarget);

			AssignCommand(oTarget, DelayCommand(0.31, JumpToLocation(lPC)));
			DelayCommand(0.31, JumpToLocation(lTarget));
		}
	}
}