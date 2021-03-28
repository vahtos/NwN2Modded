//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 7/23/2009									//
//	Title: st_flashn_sun							//
//	Description: Flashing sun allows you to make an //
//	additional melee attack during this round. As 	//
//	part of this maneuver, you take a full attack 	//
//  action and make your normal melee attacks. 		//
// 	However, you can make one additional attack this//
//	round at your highest attack bonus. All the 	//
//	attacks you make this round, including the extra//
//  attack granted by this maneuver, are made with a//
//  –2 penalty.										//
//////////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void FlashingSun(object oWeapon, object oTarget, int nHit, float fDelay = 0.0f, int bAnimate = TRUE)
{
	object oPC = OBJECT_SELF;

	if (bAnimate == TRUE)
	{
		StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f + fDelay);
		DelayCommand(fDelay, BasicAttackAnimation(oWeapon, nHit, TRUE));
	}

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

	DelayCommand(0.3f + fDelay, StrikeWeaponDamage(oWeapon, nHit, oTarget));
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 13);
	
	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DesertWindStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DesertWindStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	object oOffHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

	ExpendManeuver(13, "STR");

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

	int nHit = StrikeAttackRoll(oWeapon, oTarget, -2 + nPenalty);
	int nHit1 = StrikeAttackRoll(oWeapon, oTarget, -2 + nPenalty);

	FlashingSun(oWeapon, oTarget, nHit);
	FlashingSun(oWeapon, oTarget, nHit1, 0.0f, FALSE);

	if (nFlurry > 0)
	{
		int nBlows = StrikeAttackRoll(oWeapon, oTarget, -2 + nPenalty);

		FlashingSun(oWeapon, oTarget, nBlows);
	}

	if (nFlurry > 1)
	{
		int nBlows1 = StrikeAttackRoll(oWeapon, oTarget, -2 + nPenalty);

		FlashingSun(oWeapon, oTarget, nBlows1);
	}

	if (nSnap > 0)
	{
		int nKick = StrikeAttackRoll(oWeapon, oTarget, -2 + nPenalty);

		FlashingSun(oWeapon, oTarget, nKick);
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
		int nLeft1 = StrikeAttackRoll(oOffHand, oTarget, -2 + nPenalty);
		FlashingSun(oOffHand, oTarget, nLeft1, 0.1f, FALSE);
	}

	if (nRHandAttacks > 1) // Two attacks.
	{
		int nHit2 = StrikeAttackRoll(oWeapon, oTarget, -7  + nPenalty);
		FlashingSun(oWeapon, oTarget, nHit2, 1.0f, FALSE);
	}

	if (nLHandAttacks > 1)
	{
		int nLeft2 = StrikeAttackRoll(oOffHand, oTarget, -7  + nPenalty);
		FlashingSun(oOffHand, oTarget, nLeft2, 1.1f, FALSE);
	}
	
	if (nRHandAttacks > 2) // Three attacks.
	{
		int nHit3 = StrikeAttackRoll(oWeapon, oTarget, -12 + nPenalty);
		FlashingSun(oWeapon, oTarget, nHit3, 2.0f);
	}

	if (nLHandAttacks > 2)
	{
		int nLeft3 = StrikeAttackRoll(oOffHand, oTarget, -12 + nPenalty);
		FlashingSun(oOffHand, oTarget, nLeft3, 2.1f, FALSE);
	}

	if (nRHandAttacks > 3) // Four attacks.
	{
		int nHit4 = StrikeAttackRoll(oWeapon, oTarget, -17 + nPenalty);
		FlashingSun(oWeapon, oTarget, nHit4, 3.0f, FALSE);
	}
	
	if (nLHandAttacks > 3)
	{
		int nLeft4 = StrikeAttackRoll(oOffHand, oTarget, -17 + nPenalty);
		FlashingSun(oOffHand, oTarget, nLeft4, 3.1f, FALSE);
	}

	if (nRHandAttacks > 4) // Five attacks.
	{
		int nHit5 = StrikeAttackRoll(oWeapon, oTarget, -22 + nPenalty);
		FlashingSun(oWeapon, oTarget, nHit5, 4.0f, FALSE);
	}

	if (nLHandAttacks > 4)
	{
		int nLeft5 = StrikeAttackRoll(oOffHand, oTarget, -22 + nPenalty);
		FlashingSun(oOffHand, oTarget, nLeft5, 4.1f, FALSE);
	}
	
	if (nRHandAttacks > 5) // Six attacks.
	{
		int nHit6 = StrikeAttackRoll(oWeapon, oTarget, -27 + nPenalty);
		FlashingSun(oWeapon, oTarget, nHit6, 5.0f);
	}

	if (nLHandAttacks > 5)
	{
		int nLeft6 = StrikeAttackRoll(oOffHand, oTarget, -27 + nPenalty);
		FlashingSun(oOffHand, oTarget, nLeft6, 5.1f, FALSE);
	}
}