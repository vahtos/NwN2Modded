//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 9/19/2009								//
//	Title: sa_giant_stance  					//
//	Description: While you are in this stance,  //
//  you deal damage as if you were one size     //
//  larger than normal, to a maximum of Large.  //
//  This benefit improves your weapon and       //
//  unarmed strike damage. It does not confer   //
//  any of the other benefits or drawbacks of a //
//  change in size, such as a modifier to       //
//  ability scores or AC, or an improved reach. //
//  This stance immediately ends if you move    //
//  more than 5 feet for any reason.			//
//////////////////////////////////////////////////

/*	Drammel's Note: The phrase "as if you were one size larger than normal"
	has no signifigance whatsoever in any 3.5 rulebook.  The Sage has ruled this
	as a pure DM's call.  I'm the DM!*/

#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void GiantsStance()
{
	object oPC = OBJECT_SELF;

	if (ValidateStance(152))
	{
		location lGiants = GetLocalLocation(oPC, "GiantsStance");
		location lPC = GetLocation(oPC);
		float fDist = GetDistanceBetweenLocations(lPC, lGiants);

		if (fDist <= FeetToMeters(5.0f))
		{
			object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
			int nDamageType = GetWeaponDamageType(oWeapon);
			int nSize = GetCreatureSize(oPC) + 1;
			effect eDamage;

			switch (nSize)
			{
				case CREATURE_SIZE_SMALL: eDamage = EffectDamageIncrease(DAMAGE_BONUS_1d4, nDamageType);	break;
				case CREATURE_SIZE_MEDIUM:eDamage = EffectDamageIncrease(DAMAGE_BONUS_1d6, nDamageType);	break;
				default: 				  eDamage = EffectDamageIncrease(DAMAGE_BONUS_1d8, nDamageType);	break;
			}

			effect eSize = EffectSetScale(1.5);
			effect eGiant = EffectLinkEffects(eSize, eDamage);
			eGiant = ExtraordinaryEffect(eGiant);

			DelayCommand(6.0f, GiantsStance());
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGiant, oPC, 6.0f);
		}
		else
		{
			DeleteLocalLocation(oPC, "GiantsStance");

			object oToB = GetItemPossessedBy(oPC, "tob");

			if (GetLocalInt(oToB, "Stance") == 152)
			{
				SetLocalInt(oToB, "Stance", 0);
				SendMessageToPC(oPC, "<color=red>You have moved more than five feet from where you initiated Giant's Stance.  Giant's Stance has ended.</color>");
			}
			else if (GetLocalInt(oToB, "Stance2") == 152)
			{
				SetLocalInt(oToB, "Stance2", 0);
				SendMessageToPC(oPC, "<color=red>You have moved more than five feet from where you initiated Giant's Stance.  Giant's Stance has ended.</color>");
			}
		}
	}
	else DeleteLocalLocation(oPC, "GiantsStance");
}

void main()
{
	object oPC = OBJECT_SELF;

	SetLocalLocation(oPC, "GiantsStance", GetLocation(oPC));
	GiantsStance();
}