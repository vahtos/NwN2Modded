//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 4/14/2009									//
//	Name: sf_snap_kick								//
//	Description: Activates Snap Kick mode.  While in//
//	this mode, all attack rolls take a -2 penalty	//
//	and you deal an extra unarmed attack that deals //
//	your base unarmed damage + 1/2 STR.				//
//////////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_include"
#include "bot9s_inc_feats"

void SnapKick(object oWeapon, object oTarget)
{
	if (GetCurrentHitPoints(oTarget) > 0)
	{
		object oPC = OBJECT_SELF;
		effect eDamage = SnapKickDamage();
		int nRoll = StrikeAttackRoll(oWeapon, oTarget);

		StrikeAttackSound(oWeapon, oTarget, nRoll, 0.17f, FALSE);
		WrapperPlayCustomAnimation(oPC, "snapkick", 0);

		if (nRoll > 0)
		{
			DelayCommand(0.17f, SpawnBloodHit(oTarget, nRoll, oPC));
			DelayCommand(0.17f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC));
		}
	}
}

void SnapKickMode(object oPC, object oToB)
{
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

	if (GetWeaponRanged(oWeapon))
	{
		ActionUnequipItem(oWeapon);
	}

	if (GetLocalInt(oToB, "SnapKick") == 1)
	{
		object oTarget = GetAttemptedAttackTarget();

		if (GetIsInCombat(oPC) && (GetIsObjectValid(oTarget)) && (GetDistanceToObject(oTarget) <= FeetToMeters(8.0f)) && (GetCurrentAction(oPC) == ACTION_ATTACKOBJECT))
		{
			effect eDecrease = EffectAttackDecrease(2);
			eDecrease = ExtraordinaryEffect(eDecrease);
			
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDecrease, oPC, 6.0f);
			DelayCommand(5.2, SnapKick(oWeapon, oTarget));
			DelayCommand(6.0f, SnapKickMode(oPC, oToB));
		}
		else DelayCommand(0.1f, SnapKickMode(oPC, oToB));
		//SendMessageToPC(oPC, "<color=red>Snap Kick mode was canceled.</color>");
	}
	else FloatingTextStringOnCreature("<color=cyan>*Snap Kick mode was deactivated.*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	if (GetIsObjectValid(oToB))
	{
		if (GetLocalInt(oToB, "SnapKick") == 0)
		{
			FloatingTextStringOnCreature("<color=cyan>*Snap Kick mode activated*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
			SetLocalInt(oToB, "SnapKick", 1);
			SnapKickMode(oPC, oToB);
		}
		else if (GetLocalInt(oToB, "SnapKick") == 1)
		{
			SetLocalInt(oToB, "SnapKick", 0);
		}
	}
	else CreateItemOnObject("tob", oPC, 1);
}