//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 3/28/2009									//
//	Title: feat_desert_fire							//
//	Description: If you move at least 10 feet from	//
//	your original position, you deal an extra 1d6	//
//	points of fire damage with any attack you make	//
//	with a Desert Wind weapon.						//
//////////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_feats"

void RunDesertFire()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	location lPC = GetLocation(oPC);
	location lLast = GetLocalLocation(oPC, "DesertFireLoc");

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6536);

	if ((GetLocalInt(oToB, "DesertWindStrike") == 1) && (GetDistanceBetweenLocations(lPC, lLast) >= FeetToMeters(10.0f)))
	{
		effect eFire = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE);
		eFire = SupernaturalEffect(eFire);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFire, oPC, 5.5f);
	}

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
	DelayCommand(6.0f, RunDesertFire());
}

void RunDesertFireLocation()
{
	object oPC = OBJECT_SELF;

	SetLocalLocation(oPC, "DesertFireLoc", GetLocation(oPC));
	DelayCommand(6.0f, RunDesertFireLocation());
}

void CheckLoopEffect()
{
	if(!CheckRecursive(6506))
	{
		RunDesertFire(); //Only runs if the effect is no longer on the player.
		DelayCommand(5.8f, RunDesertFireLocation());
	}
}

void main()
{
	DelayCommand(6.0f, CheckLoopEffect()); // Needs to be delayed because when the feat fires after resting the engine doesn't detect effects immeadiately.
}