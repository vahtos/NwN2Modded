//////////////////////////////////////////
//  Author: Drammel						//
//  Date: 10/27/2009					//
//  Title: sa_supreme					//
//  Description: While you are in this  //
//  stance, you gain damage reduction   //
//  5/- against any opponent that does  //
//  not catch you flat-footed. To gain  //
//  this benefit, you must be proficient//
//  with the weapon you carry. You gain //
//  this benefit while unarmed only if  //
//  you have the Improved Unarmed Strike//
//  feat.                               //
//////////////////////////////////////////

#include "bot9s_armor"
#include "bot9s_inc_maneuvers"

void SupremeBladeParry()
{
	if (ValidateStance(95))
	{
		object oPC = OBJECT_SELF;

		if (!GetIsFlatFooted(oPC))
		{
			object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

			if ((GetIsObjectValid(oWeapon)) || ((!GetIsObjectValid(oWeapon)) && (GetHasFeat(FEAT_IMPROVED_UNARMED_STRIKE, oPC))))
			{
				effect eSupreme = EffectDamageReduction(5, DAMAGE_POWER_NORMAL, 0, DR_TYPE_NONE);
				eSupreme = ExtraordinaryEffect(eSupreme);

				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSupreme, oPC, 6.0f);
			}
		}

		DelayCommand(6.0f, SupremeBladeParry());
	}
}

void main()
{
	SupremeBladeParry();
}