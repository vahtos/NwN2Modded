//////////////////////////////////////////////////////
//  Author: Drammel									//
//  Date: 9/1/2009									//
//  Title: sa_wolverine								//
//  Description: You heal hit points each round 	//
//  equal to the number of attacks you can make.	//
//  This ability stacks with normal regeneration.	//
//////////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void WolverineStance()
{
	object oPC = OBJECT_SELF;

	if (ValidateStance(187))
	{
		int nRHandAttacks, nLHandAttacks;
		int nBAB = GetTRUEBaseAttackBonus(oPC);

		switch (nBAB)
		{
			case 0:	nRHandAttacks = 1; break;
			case 1:	nRHandAttacks = 1; break;
			case 2:	nRHandAttacks = 1; break;
			case 3:	nRHandAttacks = 1; break;
			case 4:	nRHandAttacks = 1; break;
			case 5:	nRHandAttacks = 1; break;
			case 6:	nRHandAttacks = 2; break;
			case 7:	nRHandAttacks = 2; break;
			case 8:	nRHandAttacks = 2; break;
			case 9:	nRHandAttacks = 2; break;
			case 10:nRHandAttacks = 2; break;
			case 11:nRHandAttacks = 3; break;
			case 12:nRHandAttacks = 3; break;
			case 13:nRHandAttacks = 3; break;
			case 14:nRHandAttacks = 3; break;
			case 15:nRHandAttacks = 3; break;
			case 16:nRHandAttacks = 4; break;
			case 17:nRHandAttacks = 4; break;
			case 18:nRHandAttacks = 4; break;
			case 19:nRHandAttacks = 4; break;
			case 20:nRHandAttacks = 5; break;
			case 21:nRHandAttacks = 5; break;
			case 22:nRHandAttacks = 5; break;
			case 23:nRHandAttacks = 5; break;
			case 24:nRHandAttacks = 5; break;
			default:nRHandAttacks = 6; break;
		}

		object oOffHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

		if ((GetIsObjectValid(oOffHand)) && (GetWeaponType(oOffHand) != WEAPON_TYPE_NONE))
		{
			if (GetHasFeat(FEAT_EPIC_PERFECT_TWO_WEAPON_FIGHTING, oPC) || GetHasFeat(FEAT_COMBATSTYLE_RANGER_DUAL_WIELD_PERFECT_TWO_WEAPON_FIGHTING, oPC, TRUE))
			{
				int nBAB2 = GetTRUEBaseAttackBonus(oPC);

				switch (nBAB2)
				{
					case 0:	nLHandAttacks = 1; break;
					case 1:	nLHandAttacks = 1; break;
					case 2:	nLHandAttacks = 1; break;
					case 3:	nLHandAttacks = 1; break;
					case 4:	nLHandAttacks = 1; break;
					case 5:	nLHandAttacks = 1; break;
					case 6:	nLHandAttacks = 2; break;
					case 7:	nLHandAttacks = 2; break;
					case 8:	nLHandAttacks = 2; break;
					case 9:	nLHandAttacks = 2; break;
					case 10:nLHandAttacks = 2; break;
					case 11:nLHandAttacks = 3; break;
					case 12:nLHandAttacks = 3; break;
					case 13:nLHandAttacks = 3; break;
					case 14:nLHandAttacks = 3; break;
					case 15:nLHandAttacks = 3; break;
					case 16:nLHandAttacks = 4; break;
					case 17:nLHandAttacks = 4; break;
					case 18:nLHandAttacks = 4; break;
					case 19:nLHandAttacks = 4; break;
					case 20:nLHandAttacks = 5; break;
					case 21:nLHandAttacks = 5; break;
					case 22:nLHandAttacks = 5; break;
					case 23:nLHandAttacks = 5; break;
					case 24:nLHandAttacks = 5; break;
					default:nLHandAttacks = 6; break;
				}
			}
			else if (GetHasFeat(FEAT_GREATER_TWO_WEAPON_FIGHTING, oPC) || GetHasFeat(FEAT_COMBATSTYLE_RANGER_DUAL_WIELD_GREATER_TWO_WEAPON_FIGHTING, oPC))
			{
				nLHandAttacks = 3;
			}
			else if (GetHasFeat(FEAT_IMPROVED_TWO_WEAPON_FIGHTING, oPC) || GetHasFeat(FEAT_COMBATSTYLE_RANGER_DUAL_WIELD_IMPROVED_TWO_WEAPON_FIGHTING, oPC))
			{
				nLHandAttacks = 2;
			}
			else nLHandAttacks = 1;
		}
		else nLHandAttacks = 0;

		if (GetActionMode(oPC, ACTION_MODE_FLURRY_OF_BLOWS))
		{
			object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

			if ((!GetIsObjectValid(oWeapon)) && (!GetIsObjectValid(oOffHand)))
			{
				nLHandAttacks += 1;
			}
		}

		object oToB = GetItemPossessedBy(oPC, "tob");

		if (GetLocalInt(oToB, "SnapKick") == 1)
		{
			nLHandAttacks += 1;
		}

		int nHeal = nRHandAttacks + nLHandAttacks;
		effect eHeal = ManeuverHealing(oPC, nHeal);

		ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
		DelayCommand(6.0f, WolverineStance());
	}
}

void main()
{
	WolverineStance();
}