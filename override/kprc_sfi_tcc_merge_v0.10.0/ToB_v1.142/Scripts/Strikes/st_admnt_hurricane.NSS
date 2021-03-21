//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 10/27/2009							//
//	Title: st_admnt_hurricane					//
//	Description: You make two melee attacks     //
//  against each adjacent opponent you threaten //
//  when you initiate this maneuver. You receive//
//  a +4 bonus on each of these attacks, which  //
//  are otherwise made with your highest attack //
//  bonus.                                      //
//////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_inc_fx"
#include "bot9s_include"

void GenerateFoes(object oPC, object oToB, object oTarget)
{
	float fRange = GetMeleeRange(oPC);
	location lPC = GetLocation(oPC);

	int n;
	object oFoe;

	n = 1;
	oFoe = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);

	while (GetIsObjectValid(oFoe))
	{
		if ((oFoe != oPC) && (oTarget != oFoe) && (GetIsReactionTypeHostile(oFoe, oPC)))
		{
			if (GetObjectSeen(oFoe, oPC) || GetObjectHeard(oFoe, oPC))
			{
				SetLocalObject(oToB, "AdamantineHurricaneFoe" + IntToString(n), oFoe);
				n++;

				if (n > 10)//Only so many that I can manually keep track of.
				{
					break;
				}
			}
		}
		oFoe = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 77);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "IronHeartStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "IronHeartStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget, 4);
	int nHit0 = StrikeAttackRoll(oWeapon, oTarget, 4);

	GenerateFoes(oPC, oToB, oTarget);
	StrikeAttackSound(oWeapon, oTarget, nHit0, 0.2f);
	StrikeAttackSound(oWeapon, oTarget, nHit, 1.2f);
	StrikeTrailEffect(oWeapon, nHit, 2.0f);
	WrapperPlayCustomAnimation(oPC, "*whirlwind", 0); 
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));
	DelayCommand(1.3f, StrikeWeaponDamage(oWeapon, nHit0, oTarget));
	ExpendManeuver(77, "STR");

	object oFoe1 = GetLocalObject(oToB, "AdamantineHurricaneFoe1");

	if (GetIsObjectValid(oFoe1))
	{
		int nHit1 = StrikeAttackRoll(oWeapon, oFoe1, 4);
		int nHit11 = StrikeAttackRoll(oWeapon, oFoe1, 4);

		StrikeAttackSound(oWeapon, oFoe1, nHit1, 0.3f);
		StrikeAttackSound(oWeapon, oFoe1, nHit11, 1.3f);
		DelayCommand(0.4f, StrikeWeaponDamage(oWeapon, nHit1, oFoe1));
		DelayCommand(1.4f, StrikeWeaponDamage(oWeapon, nHit11, oFoe1));
	}

	object oFoe2 = GetLocalObject(oToB, "AdamantineHurricaneFoe2");

	if (GetIsObjectValid(oFoe2))
	{
		int nHit2 = StrikeAttackRoll(oWeapon, oFoe2, 4);
		int nHit12 = StrikeAttackRoll(oWeapon, oFoe2, 4);

		StrikeAttackSound(oWeapon, oFoe2, nHit2, 0.4f);
		StrikeAttackSound(oWeapon, oFoe2, nHit12, 1.4f);
		DelayCommand(0.5f, StrikeWeaponDamage(oWeapon, nHit2, oFoe2));
		DelayCommand(1.5f, StrikeWeaponDamage(oWeapon, nHit12, oFoe2));
	}

	object oFoe3 = GetLocalObject(oToB, "AdamantineHurricaneFoe3");

	if (GetIsObjectValid(oFoe3))
	{
		int nHit3 = StrikeAttackRoll(oWeapon, oFoe3, 4);
		int nHit13 = StrikeAttackRoll(oWeapon, oFoe3, 4);

		StrikeAttackSound(oWeapon, oFoe3, nHit3, 0.5f);
		StrikeAttackSound(oWeapon, oFoe3, nHit13, 1.5f);
		DelayCommand(0.6f, StrikeWeaponDamage(oWeapon, nHit3, oFoe3));
		DelayCommand(1.6f, StrikeWeaponDamage(oWeapon, nHit13, oFoe3));
	}

	object oFoe4 = GetLocalObject(oToB, "AdamantineHurricaneFoe4");

	if (GetIsObjectValid(oFoe4))
	{
		int nHit4 = StrikeAttackRoll(oWeapon, oFoe4, 4);
		int nHit14 = StrikeAttackRoll(oWeapon, oFoe4, 4);

		StrikeAttackSound(oWeapon, oFoe4, nHit14, 1.6f);
		StrikeAttackSound(oWeapon, oFoe4, nHit4, 0.6f);
		DelayCommand(1.7f, StrikeWeaponDamage(oWeapon, nHit14, oFoe4));
		DelayCommand(0.7f, StrikeWeaponDamage(oWeapon, nHit4, oFoe4));
	}

	object oFoe5 = GetLocalObject(oToB, "AdamantineHurricaneFoe5");

	if (GetIsObjectValid(oFoe5))
	{
		int nHit5 = StrikeAttackRoll(oWeapon, oFoe5, 4);
		int nHit15 = StrikeAttackRoll(oWeapon, oFoe5, 4);

		StrikeAttackSound(oWeapon, oFoe5, nHit15, 1.7f);
		StrikeAttackSound(oWeapon, oFoe5, nHit5, 0.7f);
		DelayCommand(1.8f, StrikeWeaponDamage(oWeapon, nHit15, oFoe5));
		DelayCommand(0.8f, StrikeWeaponDamage(oWeapon, nHit5, oFoe5));
	}

	object oFoe6 = GetLocalObject(oToB, "AdamantineHurricaneFoe6");

	if (GetIsObjectValid(oFoe6))
	{
		int nHit6 = StrikeAttackRoll(oWeapon, oFoe6, 4);
		int nHit16 = StrikeAttackRoll(oWeapon, oFoe6, 4);

		StrikeAttackSound(oWeapon, oFoe6, nHit6, 0.8f);
		StrikeAttackSound(oWeapon, oFoe6, nHit16, 1.8f);
		DelayCommand(1.9f, StrikeWeaponDamage(oWeapon, nHit16, oFoe6));
		DelayCommand(0.9f, StrikeWeaponDamage(oWeapon, nHit6, oFoe6));
	}

	object oFoe7 = GetLocalObject(oToB, "AdamantineHurricaneFoe7");

	if (GetIsObjectValid(oFoe7))
	{
		int nHit7 = StrikeAttackRoll(oWeapon, oFoe7, 4);
		int nHit17 = StrikeAttackRoll(oWeapon, oFoe7, 4);

		StrikeAttackSound(oWeapon, oFoe7, nHit7, 0.9f);
		StrikeAttackSound(oWeapon, oFoe7, nHit17, 1.9f);
		DelayCommand(1.0f, StrikeWeaponDamage(oWeapon, nHit7, oFoe7));
		DelayCommand(2.0f, StrikeWeaponDamage(oWeapon, nHit17, oFoe7));
	}

	object oFoe8 = GetLocalObject(oToB, "AdamantineHurricaneFoe7");

	if (GetIsObjectValid(oFoe8))
	{
		int nHit8 = StrikeAttackRoll(oWeapon, oFoe8, 4);
		int nHit18 = StrikeAttackRoll(oWeapon, oFoe8, 4);

		StrikeAttackSound(oWeapon, oFoe8, nHit8, 1.0f);
		StrikeAttackSound(oWeapon, oFoe8, nHit18, 2.0f);
		DelayCommand(1.1f, StrikeWeaponDamage(oWeapon, nHit8, oFoe8));
		DelayCommand(2.1f, StrikeWeaponDamage(oWeapon, nHit18, oFoe8));
	}

	object oFoe9 = GetLocalObject(oToB, "AdamantineHurricaneFoe9");

	if (GetIsObjectValid(oFoe9))
	{
		int nHit9 = StrikeAttackRoll(oWeapon, oFoe9, 4);
		int nHit19 = StrikeAttackRoll(oWeapon, oFoe9, 4);

		StrikeAttackSound(oWeapon, oFoe9, nHit9, 1.1f);
		StrikeAttackSound(oWeapon, oFoe9, nHit19, 2.1f);
		DelayCommand(1.2f, StrikeWeaponDamage(oWeapon, nHit9, oFoe9));
		DelayCommand(2.2f, StrikeWeaponDamage(oWeapon, nHit19, oFoe9));
	}

	object oFoe10 = GetLocalObject(oToB, "AdamantineHurricaneFoe10");

	if (GetIsObjectValid(oFoe10))
	{
		int nHit10 = StrikeAttackRoll(oWeapon, oFoe10, 4);
		int nHit20 = StrikeAttackRoll(oWeapon, oFoe10, 4);

		StrikeAttackSound(oWeapon, oFoe10, nHit10, 1.2f);
		StrikeAttackSound(oWeapon, oFoe10, nHit20, 2.2f);
		DelayCommand(1.3f, StrikeWeaponDamage(oWeapon, nHit10, oFoe10));
		DelayCommand(2.3f, StrikeWeaponDamage(oWeapon, nHit20, oFoe10));
	}

	DeleteLocalObject(oToB, "AdamantineHurricaneFoe1");
	DeleteLocalObject(oToB, "AdamantineHurricaneFoe2");
	DeleteLocalObject(oToB, "AdamantineHurricaneFoe3");
	DeleteLocalObject(oToB, "AdamantineHurricaneFoe4");
	DeleteLocalObject(oToB, "AdamantineHurricaneFoe5");
	DeleteLocalObject(oToB, "AdamantineHurricaneFoe6");
	DeleteLocalObject(oToB, "AdamantineHurricaneFoe7");
	DeleteLocalObject(oToB, "AdamantineHurricaneFoe8");
	DeleteLocalObject(oToB, "AdamantineHurricaneFoe9");
	DeleteLocalObject(oToB, "AdamantineHurricaneFoe10");
}