//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 10/6/2009							//
//	Title: bo_order_forged					//
//	Description: When you initiate this     //
//  maneuver, all allies within 30 feet of  //
//  you immediately come to your aid agaisnt//
//  the target of this maneuver.  Initiating//
//  this maneuver automatically places      //
//  allies that are not equipped with a     //
//  ranged weapon or that are considered    //
//  spellcasters in a position around the   //
//  target.  Classes with sneak attack dice //
//  are placed as close to a flanking       //
//  position as possible.			        //
//////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_include"
#include "tob_x0_i0_position"

void OrderForgedFromChaos(object oAlly, location lAlly)
{
	if (GetIsObjectValid(oAlly))
	{
		AssignCommand(oAlly, ClearStrikes());
		AssignCommand(oAlly, ClearAllActions());

		if (GetIsLocationValid(lAlly))
		{
			AssignCommand(oAlly, JumpToLocation(lAlly));
		}
		else
		{
			location lNew = CalcSafeLocation(oAlly, lAlly, FeetToMeters(5.0f), FALSE, TRUE);
			AssignCommand(oAlly, JumpToLocation(lNew));
		}
	}
}

void CleanUp(object oPC, object oToB)
{
	DeleteLocalObject(oToB, "OrderForgedAlly1");
	DeleteLocalObject(oToB, "OrderForgedAlly2");
	DeleteLocalObject(oToB, "OrderForgedAlly3");
	DeleteLocalObject(oToB, "OrderForgedAlly4");
	DeleteLocalObject(oToB, "OrderForgedAlly5");
	DeleteLocalObject(oToB, "OrderForgedAlly6");
}

void GenerateFriends(object oPC, object oToB)
{
	location lPC = GetLocation(oPC);
	float fRange = FeetToMeters(30.0f);
	object oFriend, oWeapon, oArmor;
	int n, nBase, nClothy, nAction;

	oFriend = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);
	n = 1;

	while (GetIsObjectValid(oFriend))
	{
		oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oFriend);
		oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oFriend);
		nBase = GetBaseItemType(oWeapon);
		nAction = GetCurrentAction(oFriend);

		if ((GetArmorRank(oArmor) == ARMOR_RANK_NONE) && (GetLevelByClass(CLASS_TYPE_MONK, oFriend) < 1))
		{
			nClothy = 1;
		}
		else if ((GetLevelByClass(CLASS_TYPE_BARD, oFriend) > 0) || (GetLevelByClass(CLASS_TYPE_WARLOCK, oFriend) > 0))
		{
			nClothy = 1;
		}
		else nClothy = 0;

		//Filter out people that don't want to be close to the target.
		if ((oPC != oFriend) && (!GetIsReactionTypeHostile(oFriend, oPC)) && (!GetWeaponRanged(oWeapon)) && (nClothy == 0) && (nBase != BASE_ITEM_MAGICSTAFF) && (nBase != BASE_ITEM_MAGICROD) && (nBase != BASE_ITEM_MAGICWAND) && (nAction != ACTION_CASTSPELL) && (nAction != ACTION_ITEMCASTSPELL) && (nAction != ACTION_USEOBJECT))
		{
			SetLocalObject(oToB, "OrderForgedAlly" + IntToString(n), oFriend);
			n++;
		}

		oFriend = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);

		if (n > 6)
		{
			break;
		}
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = IntToObject(GetLocalInt(oToB, "Target"));
	float fGirth = GetGirth(oTarget) + 0.1f; //Adding the extra .01 because the edge counts as part of the creature's collision box, which in turn jumps the target to a random location.
	
	if (NotMyFoe(oPC, oTarget))
	{
		SendMessageToPC(oPC, "<color=red>You can only target an enemy with Order Forged From Chaos.</color>");
		return;
	}
	else if (GetDistanceBetween(oPC, oTarget) > (GetMeleeRange(oPC) + fGirth))
	{
		SendMessageToPC(oPC, "<color=red>This target is not within melee range.</color>");
		return;
	}

	if (GetLocalInt(oToB, "Swift") == 0)	
	{
		GenerateFriends(oPC, oToB);

		float fDist = GetDistanceBetween(oPC, oTarget);
		float fFive = FeetToMeters(5.0f);
		float fFacing = GetFacing(oPC);
		float fOpposite = GetOppositeDirection(fFacing);
		location lPC = GetLocation(oPC);
		location lFlank = GetOppositeLocation(oPC, fGirth + fDist + 1.4f); //Includes a little larger than the standard PC sized square.
		location lLeft = GetLeftLocation(oPC, fFive);
		location lRight = GetRightLocation(oPC, fFive);
		location lFlankLeft = GenerateNewLocationFromLocation(lLeft, fGirth, fFacing, fOpposite);
		location lFlankRight = GenerateNewLocationFromLocation(lRight, fGirth, fFacing, fOpposite);
		object oFriend1 = GetLocalObject(oToB, "OrderForgedAlly1");
		object oFriend2 = GetLocalObject(oToB, "OrderForgedAlly2");
		object oFriend3 = GetLocalObject(oToB, "OrderForgedAlly3");
		object oFriend4 = GetLocalObject(oToB, "OrderForgedAlly4");
		object oFriend5 = GetLocalObject(oToB, "OrderForgedAlly5");
		object oFriend6 = GetLocalObject(oToB, "OrderForgedAlly6");
		object oSneak;

		if (GetIsObjectValid(oFriend1) && (GetSneakAttackDice(oFriend1) > 0))// Move a Sneak attacker into a flanking position with the PC.
		{
			oSneak = oFriend1;
		}
		else if (GetIsObjectValid(oFriend2) && (GetSneakAttackDice(oFriend2) > 0))
		{
			oSneak = oFriend2;
		}
		else if (GetIsObjectValid(oFriend3) && (GetSneakAttackDice(oFriend3) > 0))
		{
			oSneak = oFriend3;
		}
		else if (GetIsObjectValid(oFriend4) && (GetSneakAttackDice(oFriend4) > 0))
		{
			oSneak = oFriend4;
		}
		else if (GetIsObjectValid(oFriend5) && (GetSneakAttackDice(oFriend5) > 0))
		{
			oSneak = oFriend5;
		}
		else if (GetIsObjectValid(oFriend6) && (GetSneakAttackDice(oFriend6) > 0))
		{
			oSneak = oFriend6;
		}

		OrderForgedFromChaos(oFriend1, lRight);
		OrderForgedFromChaos(oFriend2, lFlankRight);
		OrderForgedFromChaos(oFriend3, lLeft);
		OrderForgedFromChaos(oFriend4, lFlankLeft);
		OrderForgedFromChaos(oFriend5, lFlank);
		OrderForgedFromChaos(oFriend6, lPC);
		DelayCommand(0.1f, OrderForgedFromChaos(oSneak, lFlank));

		DelayCommand(3.0f, CleanUp(oPC, oToB));
		ExpendManeuver(197, "B");
		RunSwiftAction(197, "B");
	}
}