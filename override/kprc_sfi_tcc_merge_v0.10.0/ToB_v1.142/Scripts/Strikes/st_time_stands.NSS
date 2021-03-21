//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 10/30/2009								//
//	Title: st_time_stands						    //
//	Description: As part of this maneuver, you can  //
//  use a full attack action two times in           //
//  succession. Take your first full attack as      //
//  normal. Once you have resolved those attacks,   //
//  you can then take another full attack action.   //
//  You must resolve these actions separately. You  //
//  cannot combine the attacks provided by both     //
//  actions as you wish. Instead, you must take them//
//  separately and in order as normal for a full    //
//  attack.	                                        //
//////////////////////////////////////////////////////

#include "bot9s_inc_fx"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void TimeStandsStill(object oWeapon, object oTarget, int nHit, float fDelay = 0.0f)
{
	object oPC = OBJECT_SELF;

	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f + fDelay);
	DelayCommand(0.3f + fDelay, StrikeWeaponDamage(oWeapon, nHit, oTarget));

	if ((GetHasFeat(FEAT_CIRCLE_KICK, oPC)) && (GetLocalInt(oPC, "mimic_circle_k") == 0) && (nHit > 0)) // Circle Kick Support.
	{
		if ((oWeapon == OBJECT_INVALID) || (oWeapon == GetItemInSlot(INVENTORY_SLOT_ARMS, oPC)))
		{
			SetLocalInt(oPC, "mimic_circle_k", 1);// One per round.
			DelayCommand(6.0f, SetLocalInt(oPC, "mimic_circle_k", 0));

			float fRange = GetMeleeRange(oPC);
			location lPC = GetLocation(oPC);
			object oCircle;

			oCircle = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);

			while (GetIsObjectValid(oCircle))
			{
				if ((oCircle != oTarget) && (GetIsReactionTypeHostile(oCircle, oPC)))
				{
					int nCircle = StrikeAttackRoll(oWeapon, oCircle);

					DelayCommand(0.7f, StrikeWeaponDamage(oWeapon, nCircle, oCircle));
					DelayCommand(0.7f, WrapperPlayCustomAnimation(oPC, "*kickcircle", 0));
					break;
				}

				oCircle = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);
			}
		}
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 75);
	
	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DiamondMindStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DiamondMindStrike", 0));
	SetLocalInt(oToB, "TimeStandsActive", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "TimeStandsActive", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	object oOffHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

	StrikeTrailEffect(oWeapon, 1, 4.66f);
	WrapperPlayCustomAnimation(oPC, "*2attack01", 0);
	DelayCommand(3.0f, WrapperPlayCustomAnimation(oPC, "*2attack02", 0));
	ExpendManeuver(75, "STR");

	int nRHandAttacks, nLHandAttacks, nPenalty;
	int nBAB = GetTRUEBaseAttackBonus(oPC);
	int nFlurry;

	nFlurry = 0;

	if ((GetActionMode(oPC, ACTION_MODE_FLURRY_OF_BLOWS)) && (GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC)) == ARMOR_RANK_NONE))
	{
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		object oRanged = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
		int nType = GetBaseItemType(oWeapon);
		int nRangedType = GetBaseItemType(oRanged);
		int nMonk = GetLevelByClass(CLASS_TYPE_MONK, oPC) + GetLevelByClass(CLASS_TYPE_SACREDFIST, oPC);

		if (((!GetIsObjectValid(oWeapon)) && (!GetIsObjectValid(oOffHand))) || nType == BASE_ITEM_KAMA || nType == BASE_ITEM_QUARTERSTAFF || nRangedType == BASE_ITEM_SHURIKEN)
		{
			nFlurry += 1;

			if (nMonk > 10)
			{
				nFlurry += 1;
			}
		}

		if (nMonk < 5)
		{
			nPenalty -= 2;
		}
		else if (nMonk < 9)
		{
			nPenalty -= 1;
		}
	}

	int nSnap;

	nSnap = 0;

	if (GetLocalInt(oToB, "SnapKick") == 1)
	{
		nSnap = 1;
		nPenalty -= 2;
	}

	int nHit = StrikeAttackRoll(oWeapon, oTarget, nPenalty);

	TimeStandsStill(oWeapon, oTarget, nHit);

	if (nFlurry > 0)
	{
		int nBlows = StrikeAttackRoll(oWeapon, oTarget, nPenalty);

		TimeStandsStill(oWeapon, oTarget, nBlows);
	}

	if (nFlurry > 1)
	{
		int nBlows1 = StrikeAttackRoll(oWeapon, oTarget, nPenalty);

		TimeStandsStill(oWeapon, oTarget, nBlows1);
	}

	if (nSnap > 0)
	{
		int nKick = StrikeAttackRoll(oWeapon, oTarget, nPenalty);

		TimeStandsStill(oWeapon, oTarget, nKick);
	}

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

	if (GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)))
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

	if (nLHandAttacks > 0)
	{
		int nLeft1 = StrikeAttackRoll(oOffHand, oTarget, nPenalty);
		TimeStandsStill(oOffHand, oTarget, nLeft1, 0.1f);
	}

	if (nRHandAttacks > 1) // Two attacks.
	{
		int nHit2 = StrikeAttackRoll(oWeapon, oTarget, -5  + nPenalty);
		TimeStandsStill(oWeapon, oTarget, nHit2, 0.5f);
	}

	if (nLHandAttacks > 1)
	{
		int nLeft2 = StrikeAttackRoll(oOffHand, oTarget, -5  + nPenalty);
		TimeStandsStill(oOffHand, oTarget, nLeft2, 0.6f);
	}
	
	if (nRHandAttacks > 2) // Three attacks.
	{
		int nHit3 = StrikeAttackRoll(oWeapon, oTarget, -10 + nPenalty);
		TimeStandsStill(oWeapon, oTarget, nHit3, 1.0f);
	}

	if (nLHandAttacks > 2)
	{
		int nLeft3 = StrikeAttackRoll(oOffHand, oTarget, -10 + nPenalty);
		TimeStandsStill(oOffHand, oTarget, nLeft3, 1.1f);
	}

	if (nRHandAttacks > 3) // Four attacks.
	{
		int nHit4 = StrikeAttackRoll(oWeapon, oTarget, -15 + nPenalty);
		TimeStandsStill(oWeapon, oTarget, nHit4, 1.5f);
	}
	
	if (nLHandAttacks > 3)
	{
		int nLeft4 = StrikeAttackRoll(oOffHand, oTarget, -15 + nPenalty);
		TimeStandsStill(oOffHand, oTarget, nLeft4, 1.6f);
	}

	if (nRHandAttacks > 4) // Five attacks.
	{
		int nHit5 = StrikeAttackRoll(oWeapon, oTarget, -20 + nPenalty);
		TimeStandsStill(oWeapon, oTarget, nHit5, 2.0f);
	}

	if (nLHandAttacks > 4)
	{
		int nLeft5 = StrikeAttackRoll(oOffHand, oTarget, -20 + nPenalty);
		TimeStandsStill(oOffHand, oTarget, nLeft5, 2.1f);
	}
	
	if (nRHandAttacks > 5) // Six attacks.
	{
		int nHit6 = StrikeAttackRoll(oWeapon, oTarget, -25 + nPenalty);
		TimeStandsStill(oWeapon, oTarget, nHit6, 2.5f);
	}

	if (nLHandAttacks > 5)
	{
		int nLeft6 = StrikeAttackRoll(oOffHand, oTarget, -25 + nPenalty);
		TimeStandsStill(oOffHand, oTarget, nLeft6, 2.6f);
	}

	// New Full attack action starts here.
	if (GetCurrentHitPoints(oTarget) < 1)
	{
		float fMelee = GetMeleeRange(oPC);
		object oCreature = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oPC, CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE);

		if (GetDistanceBetween(oPC, oCreature) <= fMelee)
		{
			oTarget = oCreature;

			WatchOpponent(oTarget);
		}
	}

	int nRoll = StrikeAttackRoll(oWeapon, oTarget, nPenalty);

	TimeStandsStill(oWeapon, oTarget, nRoll, 2.6f);

	if (nFlurry > 0)
	{
		int nBlows2 = StrikeAttackRoll(oWeapon, oTarget, nPenalty);

		TimeStandsStill(oWeapon, oTarget, nBlows2);
	}

	if (nFlurry > 1)
	{
		int nBlows21 = StrikeAttackRoll(oWeapon, oTarget, nPenalty);

		TimeStandsStill(oWeapon, oTarget, nBlows21);
	}

	if (nSnap > 0)
	{
		int nKick2 = StrikeAttackRoll(oWeapon, oTarget, nPenalty);

		TimeStandsStill(oWeapon, oTarget, nKick2);
	}

	if (nLHandAttacks > 0)
	{
		int nOffHand1 = StrikeAttackRoll(oOffHand, oTarget, nPenalty);
		TimeStandsStill(oOffHand, oTarget, nOffHand1, 2.7f);
	}

	if (nRHandAttacks > 1) // Two attacks.
	{
		int nRoll2 = StrikeAttackRoll(oWeapon, oTarget, -5  + nPenalty);
		TimeStandsStill(oWeapon, oTarget, nRoll2, 3.2f);
	}

	if (nLHandAttacks > 1)
	{
		int nOffHand2 = StrikeAttackRoll(oOffHand, oTarget, -5  + nPenalty);
		TimeStandsStill(oOffHand, oTarget, nOffHand2, 3.3f);
	}
	
	if (nRHandAttacks > 2) // Three attacks.
	{
		int nRoll3 = StrikeAttackRoll(oWeapon, oTarget, -10 + nPenalty);
		TimeStandsStill(oWeapon, oTarget, nRoll3, 3.6f);
	}

	if (nLHandAttacks > 2)
	{
		int nOffHand3 = StrikeAttackRoll(oOffHand, oTarget, -10 + nPenalty);
		TimeStandsStill(oOffHand, oTarget, nOffHand3, 3.7f);
	}

	if (nRHandAttacks > 3) // Four attacks.
	{
		int nRoll4 = StrikeAttackRoll(oWeapon, oTarget, -15 + nPenalty);
		TimeStandsStill(oWeapon, oTarget, nRoll4, 4.2f);
	}
	
	if (nLHandAttacks > 3)
	{
		int nOffHand4 = StrikeAttackRoll(oOffHand, oTarget, -15 + nPenalty);
		TimeStandsStill(oOffHand, oTarget, nOffHand4, 4.3f);
	}

	if (nRHandAttacks > 4) // Five attacks.
	{
		int nRoll5 = StrikeAttackRoll(oWeapon, oTarget, -20 + nPenalty);
		TimeStandsStill(oWeapon, oTarget, nRoll5, 4.6f);
	}

	if (nLHandAttacks > 4)
	{
		int nOffHand5 = StrikeAttackRoll(oOffHand, oTarget, -20 + nPenalty);
		TimeStandsStill(oOffHand, oTarget, nOffHand5, 4.7f);
	}
	
	if (nRHandAttacks > 5) // Six attacks.
	{
		int nRoll6 = StrikeAttackRoll(oWeapon, oTarget, -25 + nPenalty);
		TimeStandsStill(oWeapon, oTarget, nRoll6, 5.2f);
	}

	if (nLHandAttacks > 5)
	{
		int nOffHand6 = StrikeAttackRoll(oOffHand, oTarget, -25 + nPenalty);
		TimeStandsStill(oOffHand, oTarget, nOffHand6, 5.3f);
	}
}