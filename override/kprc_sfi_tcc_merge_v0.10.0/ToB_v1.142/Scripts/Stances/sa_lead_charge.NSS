//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 6/20/2009	Happy Birthday Josh!	//
//	Title: sa_lead_charge					//
//	Description: Stance; Grants allies +2 vs//
//	will saves and +4 vs fear effects.		//
//////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"
#include "bot9s_inc_variables"
#include "bot9s_include"
#include "tob_x2_inc_itemprop"

void LeadingtheCharge()
{
	if (ValidateStance(195))
	{
		object oPC = OBJECT_SELF;
		float fRange = FeetToMeters(60.0f);
		location lPC = GetLocation(oPC);
		location lFriend, lCurrent;
		object oFriend, oWeapon;
		itemproperty iWeapon;

		oFriend = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);
		lFriend = GetLocalLocation(oFriend, "LeadingTheCharge");
		lCurrent = GetLocation(oFriend);

		while (GetIsObjectValid(oFriend))
		{
			if ((!GetIsReactionTypeHostile(oFriend, oPC)) && (oFriend != oPC) && (GetObjectHeard(oPC, oFriend)) && (lFriend != lCurrent) && (GetIsInCombat(oFriend)) && (!GetIsDead(oFriend)))
			{
				object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

				if (oRight == OBJECT_INVALID)
				{
					object oBite = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC);
					object oRClaw = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
					object oCrWeapon = GetLastWeaponUsed(oPC);
					object oArms = GetItemInSlot(INVENTORY_SLOT_ARMS, oFriend); //Love for monks.

					if (GetIsObjectValid(oBite))
					{
						oWeapon = oBite;
					}
					else if (GetIsObjectValid(oRClaw))
					{
						oWeapon = oRClaw;
					}
					else if (GetIsObjectValid(oCrWeapon))
					{
						oWeapon = oCrWeapon;
					}
					else oWeapon = oArms;
				}
				else oWeapon = oRight;

				int nInitiator = GetInitiatorLevel(oPC);
				int nDamage = IPGetConstDamageBonusFromNumber(nInitiator);
				int nDamageType = GetWeaponDamageType(oWeapon);

				iWeapon = ItemPropertyDamageBonus(nDamageType, nDamage);
				IPSafeAddItemProperty(oWeapon, iWeapon, 6.0f);
				SetLocalLocation(oFriend, "LeadingTheCharge", lCurrent);
			}
			oFriend = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);
			lFriend = GetLocalLocation(oFriend, "LeadingTheCharge");
			lCurrent = GetLocation(oFriend);
		}
		DelayCommand(6.0f, LeadingtheCharge());
	}
}

void main()
{
	LeadingtheCharge();
}