//////////////////////////////////////////////////
//  Author: Drammel								//
//  Date: 9/15/2009								//
//  Title: sa_dancing_blade						//
//  Description: While you are in this stance,  //
//  you gain a bonus to your reach during your  //
//  turn. When you make a melee attack, your    //
//  reach increases by 5 feet. Your reach is not//
//  improved when it is not your turn, such as  //
//  when you make an attack of opportunity. You //
//  cannot improve your reach by more than 5    //
//  feet by using this ability in conjunction   //
//  with other maneuvers.  					    //
//////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_combat_overrides"

/*void CopyProperties(object oSource, object oTarget)
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
}

void CheckItems()
{
	object oPC = OBJECT_SELF;
	string sToB = GetFirstName(oPC) + "tob";
	object oToB = GetObjectByTag(sToB);
	object oDancing = GetLocalObject(oToB, "DancingBlade");
	object oCheck;
	string sCheck;

	oCheck = GetFirstItemInInventory(oPC);
	sCheck = GetStringRight(GetTag(oCheck), 2);

	while (GetIsObjectValid(oCheck))
	{
		if ((oCheck == oDancing) || (sCheck == "_r"))
		{
			DestroyObject(oCheck, 0.0f, FALSE);
		}
		oCheck = GetNextItemInInventory(oPC);
		sCheck = GetStringRight(GetTag(oCheck), 2);
	}
}*/

void DancingBladeForm()
{
	object oPC = OBJECT_SELF;

	if (ValidateStance(78))
	{
		SetLocalInt(oPC, "DancingBladeForm", 1); // Status check to prevent extra callbacks of this function from running.

		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

		if ((GetIsObjectValid(oWeapon)) && (GetLocalInt(oPC, "BurningBrand") != 1))
		{
			object oToB = GetItemPossessedBy(oPC, "tob");

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
		}

		if (GetLocalInt(oPC, "bot9s_overridestate") > 0)
		{
			//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
			//2 = Combat round is pending and the command has already been sent, do nothing.
		}
		else ManageCombatOverrides(TRUE);

		DelayCommand(6.0f, DancingBladeForm());
	}
	else
	{
		ProtectedClearCombatOverrides(oPC);
		DeleteLocalInt(oPC, "DancingBladeForm");
	}
}

void main()
{
	object oPC = OBJECT_SELF;

	if (GetLocalInt(oPC, "DancingBladeForm") == 0)
	{
		DancingBladeForm();
	}
}