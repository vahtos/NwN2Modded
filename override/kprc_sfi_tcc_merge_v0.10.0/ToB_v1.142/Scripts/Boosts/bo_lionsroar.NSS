//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 9/1/2009								//
//	Title: bo_lionsroar							//
//	Description: As a swift action, you initiate//
//  this boost before you have reduced an 		//
//  opponent to fewer than 0 hit points. If the //
//  target is reduced to 0 or few hit points 	//
//  during the next six seconds you and allies  //
//  within range gain a +5 bonus on damage rolls//
//  for six seconds.							//
//////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void LionsRoar(object oPC, object oToB)
{
	object oTarget = GetLocalObject(oToB, "LionsRoar");

	if (!GetIsObjectValid(oTarget) || (GetCurrentHitPoints(oTarget) < 1))
	{
		effect eRoar = EffectVisualEffect(SFX_TOB_LIONSROAR); //Funny, using the vfx function for a sfx.
		float fSixty = FeetToMeters(60.0f);
		location lPC = GetLocation(oPC);
		object oAlly, oWeapon;
		int nDamageType;

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRoar, oPC, 1.0f);

		oAlly = GetFirstObjectInShape(SHAPE_SPHERE, fSixty, lPC);

		while (GetIsObjectValid(oAlly))
		{
			if (!GetIsReactionTypeHostile(oAlly, oPC))
			{
				oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oAlly);
				nDamageType = GetWeaponDamageType(oWeapon);
				effect eLion = EffectDamageIncrease(DAMAGE_BONUS_5, nDamageType);
				eLion = ExtraordinaryEffect(eLion);

				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLion, oAlly, 6.0f);
			}

			oAlly = GetNextObjectInShape(SHAPE_SPHERE, fSixty, lPC);
		}
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = IntToObject(GetLocalInt(oToB, "Target"));
	
	if (NotMyFoe(oPC, oTarget))
	{
		SendMessageToPC(oPC, "<color=red>You must target an opponent with this ability.</color>");
		return;
	}
	
	if (GetLocalInt(oToB, "Swift") == 0)	
	{
		RunSwiftAction(196, "B");
		ExpendManeuver(196, "B");
		SetLocalObject(oToB, "LionsRoar", oTarget);
		DelayCommand(6.0f, LionsRoar(oPC, oToB));
	}
}