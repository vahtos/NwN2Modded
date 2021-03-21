//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 8/24/2009								//
//	Title: bo_burningbrand						//
//	Description: When you initiate this maneuver//
//  your weapon turns into a burning brand for  //
//  the rest of your turn. The brand increases  //
//  your reach by 5 feet, and your melee attacks//
//  made with the brand deal fire damage equal  //
//  to your normal melee damage. You still gain //
//  all the normal benefits from a high Strength//
//  score, feats, and other effects that 		//
//  increase your melee damage. For example, an //
//  attack with a longsword that normally deals //
//  1d8+4 points of slashing damage would 		//
//  instead deal 1d8+4 points of fire damage. 	//
//  You otherwise attack with your weapon as 	//
//  normal.										//
//////////////////////////////////////////////////

#include "bot9s_combat_overrides"
#include "bot9s_inc_constants"
#include "bot9s_inc_fx"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"

/* 12/21/2009: Discovered that the toolset will sometimes use the 2da entries 
   for reach weapons and sometimes will not.  The script has been updated to
   prevent this issue.  All in all it runs a bit more smoothly than the previous
   incarnation as it doesn't involve swapping weapons.

void CheckEquipped(object oWeapon, object oReach)
{
	object oPC = OBJECT_SELF;
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	string sCheck = GetStringRight(GetTag(oWeapon), 2);

	if ((oWeapon == oReach) || (sCheck == "_r"))
	{
		WrapperSetWeaponVisibility(oPC, 0, 0);
		DelayCommand(6.0f, WrapperSetWeaponVisibility(oPC, 1, 0));
		DelayCommand(6.0f, DeleteLocalInt(oPC, "BurningBrand"));
		StrikeTrailEffect(oReach, 1, 4.67f); // Contains routing for weapon type and makes the fire vfx.

		if (GetIsObjectValid(oReach))
		{
			DelayCommand(6.0f, ActionEquipItem(oWeapon, INVENTORY_SLOT_RIGHTHAND));
			DestroyObject(oReach, 6.0f, FALSE);
		}

		if (GetLocalInt(oPC, "bot9s_overridestate") > 0)
		{
			//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
			//2 = Combat round is pending and the command has already been sent, do nothing.
		}
		else 
		{
			ManageCombatOverrides(TRUE);
			DelayCommand(6.0f, ProtectedClearCombatOverrides(oPC)); // Safe to use because it takes a swift action to initiate a stance or another boost.
		}
	}
	else DelayCommand(0.1f, CheckEquipped(oWeapon, oReach));
}

void CopyProperties(object oSource, object oTarget)
{
	itemproperty iProp;

	iProp = GetFirstItemProperty(oSource);

	while (GetIsItemPropertyValid(iProp))
	{
		AddItemProperty(DURATION_TYPE_PERMANENT, iProp, oTarget);
		iProp = GetNextItemProperty(oSource);
	}

	int nMaterial = GetItemBaseMaterialType(oSource);
	SetItemBaseMaterialType(oTarget, nMaterial);
}*/

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	
	if (GetLocalInt(oToB, "Swift") == 0)
	{
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	
		if ((GetIsObjectValid(oWeapon)) && (GetLocalInt(oPC, "DancingBladeForm") != 1))
		{
			SetLocalInt(oPC, "BurningBrand", 1);
			SetLocalInt(oToB, "bot9s_PrefAttackDist", 1);

			int nWeapon = GetBaseItemType(oWeapon);

			switch (nWeapon)
			{
				case BASE_ITEM_BASTARDSWORD:	SetLocalFloat(oToB, "override_PrefAttackDist", 3.1f);	break;
				case BASE_ITEM_BATTLEAXE:		SetLocalFloat(oToB, "override_PrefAttackDist", 2.7f);	break;
				case BASE_ITEM_CLUB:			SetLocalFloat(oToB, "override_PrefAttackDist", 2.6f);	break;
				case BASE_ITEM_DAGGER:			SetLocalFloat(oToB, "override_PrefAttackDist", 2.6f);	break;
				case BASE_ITEM_DWARVENWARAXE:	SetLocalFloat(oToB, "override_PrefAttackDist", 2.7f);	break;
				case BASE_ITEM_FALCHION:		SetLocalFloat(oToB, "override_PrefAttackDist", 2.7f);	break;
				case BASE_ITEM_FLAIL:			SetLocalFloat(oToB, "override_PrefAttackDist", 2.7f);	break;
				case BASE_ITEM_GREATAXE:		SetLocalFloat(oToB, "override_PrefAttackDist", 2.9f);	break;
				case BASE_ITEM_GREATCLUB:		SetLocalFloat(oToB, "override_PrefAttackDist", 2.7f);	break;
				case BASE_ITEM_GREATSWORD:		SetLocalFloat(oToB, "override_PrefAttackDist", 3.3f);	break;
				case BASE_ITEM_HALBERD:			SetLocalFloat(oToB, "override_PrefAttackDist", 3.2f);	break;
				case BASE_ITEM_HANDAXE:			SetLocalFloat(oToB, "override_PrefAttackDist", 2.6f);	break;
				case BASE_ITEM_KAMA:			SetLocalFloat(oToB, "override_PrefAttackDist", 2.6f);	break;
				case BASE_ITEM_KATANA:			SetLocalFloat(oToB, "override_PrefAttackDist", 2.8f);	break;
				case BASE_ITEM_KUKRI:			SetLocalFloat(oToB, "override_PrefAttackDist", 2.7f);	break;
				case BASE_ITEM_LIGHTHAMMER:		SetLocalFloat(oToB, "override_PrefAttackDist", 2.6f);	break;
				case BASE_ITEM_LONGSWORD:		SetLocalFloat(oToB, "override_PrefAttackDist", 3.0f);	break;
				case BASE_ITEM_MACE:			SetLocalFloat(oToB, "override_PrefAttackDist", 2.7f);	break;
				case BASE_ITEM_MORNINGSTAR:		SetLocalFloat(oToB, "override_PrefAttackDist", 2.9f);	break;
				case BASE_ITEM_QUARTERSTAFF:	SetLocalFloat(oToB, "override_PrefAttackDist", 3.1f);	break;
				case BASE_ITEM_RAPIER:			SetLocalFloat(oToB, "override_PrefAttackDist", 2.9f);	break;
				case BASE_ITEM_SCIMITAR:		SetLocalFloat(oToB, "override_PrefAttackDist", 2.8f);	break;
				case BASE_ITEM_SCYTHE:			SetLocalFloat(oToB, "override_PrefAttackDist", 3.0f);	break;
				case BASE_ITEM_SHORTSWORD:		SetLocalFloat(oToB, "override_PrefAttackDist", 2.7f);	break;
				case BASE_ITEM_SICKLE:			SetLocalFloat(oToB, "override_PrefAttackDist", 2.6f);	break;
				case BASE_ITEM_SPEAR:			SetLocalFloat(oToB, "override_PrefAttackDist", 3.0f);	break;
				case BASE_ITEM_TRAINING_CLUB:	SetLocalFloat(oToB, "override_PrefAttackDist", 2.6f);	break;
				case BASE_ITEM_WARHAMMER:		SetLocalFloat(oToB, "override_PrefAttackDist", 2.7f);	break;
				case BASE_ITEM_WARMACE:			SetLocalFloat(oToB, "override_PrefAttackDist", 3.3f);	break;
				default:						SetLocalFloat(oToB, "override_PrefAttackDist", 2.6f);	break;
			}

		/*	if (oWeapon != oReach)
			{
				AssignCommand(oPC, CopyProperties(oWeapon, oReach));
			}

			if (GetIsObjectValid(oReach))
			{
				AssignCommand(oPC, ActionEquipItem(oReach, INVENTORY_SLOT_RIGHTHAND));
			}

			CheckEquipped(oWeapon, oReach);*/

			WrapperSetWeaponVisibility(oPC, 0, 0);
			DelayCommand(6.0f, WrapperSetWeaponVisibility(oPC, 1, 0));
			DelayCommand(6.0f, DeleteLocalInt(oPC, "BurningBrand"));
			DelayCommand(6.0f, DeleteLocalInt(oToB, "bot9s_PrefAttackDist"));
			StrikeTrailEffect(oWeapon, 1, 4.67f); // Contains routing for weapon type and makes the fire vfx.

			if (GetLocalInt(oPC, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else 
			{
				ManageCombatOverrides(TRUE);
				DelayCommand(6.0f, ProtectedClearCombatOverrides(oPC)); // Safe to use because it takes a swift action to initiate a stance or another boost.
			}

			RunSwiftAction(3, "B");
			ExpendManeuver(3, "B");
		}
		else SendMessageToPC(oPC, "<color=red>You must have a weapon equipped to initiate this maneuver.</color>");
	}
}