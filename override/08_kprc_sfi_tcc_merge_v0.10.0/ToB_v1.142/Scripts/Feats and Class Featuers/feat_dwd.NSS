//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 3/2/2009									//
//	Title: feat_dwd									//
//	Description: If you move at least 10 feet from	//
//	your original position, you gain a +1 dodge 	//
//	bonus to AC and deal an extra 1 point of fire 	//
//	damage with any attack you make with a Desert	//
//	Wind weapon.									//
//////////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_feats"
#include "bot9s_inc_variables"

void RunDWD()
{
	object oPC = OBJECT_SELF;
	location lPC = GetLocation(oPC);
	location lLast = GetLocalLocation(oPC, "DWDLoc");

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6504);

	if (GetDistanceBetweenLocations(lPC, lLast) >= FeetToMeters(10.0f))
	{
		object oMyWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		effect eAC = EffectACIncrease(1, AC_DODGE_BONUS);
		eAC = SupernaturalEffect(eAC);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, 6.0f);

		if (GetIsDesertWindWeapon(oMyWeapon) == TRUE)
		{
			effect eFire = EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_FIRE);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFire, oPC, 6.0f);
		}
	}

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
	DelayCommand(6.0f, RunDWD());
}

void RunDWDLocation()
{
	object oPC = OBJECT_SELF;

	SetLocalLocation(oPC, "DWDLoc", GetLocation(oPC));
	DelayCommand(6.0f, RunDWDLocation());
}


void CheckLoopEffect()
{
	if(!CheckRecursive(6504))
	{
		RunDWD(); //Only runs if the effect is no longer on the player.
		DelayCommand(5.8f, RunDWDLocation());
	}
}

void main()
{
	DelayCommand(6.0f, CheckLoopEffect()); // Needs to be delayed because when the feat fires after resting the engine doesn't detect effects immeadiately.
}