//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 7/11/2009							//
//	Title: st_steely_strike					//
//	Description: Gain a +4 on your attack	//
//	roll for this strike, but all enemies	//
//	except the target gain +4 to attack vs	//
//	you.									//
//////////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 93);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "IronHeartStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "IronHeartStrike", 0));
	
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget, 4);
	
	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	BasicAttackAnimation(oWeapon, nHit); 
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));
	ExpendManeuver(93, "STR");

	// Cheap way of giving everyone else +4 to attack me.
	effect eAC = EffectACDecrease(4);
	eAC = ExtraordinaryEffect(eAC);

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, 6.0f);

	if (GetAttackTarget(oTarget) == oPC)
	{
		effect eAttack = EffectAttackDecrease(4);
		eAttack = ExtraordinaryEffect(eAttack);

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAttack, oTarget, 6.0f);
	}
}