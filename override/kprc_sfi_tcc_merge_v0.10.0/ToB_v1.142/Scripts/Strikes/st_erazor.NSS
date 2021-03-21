//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 7/22/2009								//
//	Title: st_erazor							//
//	Description: As part of this maneuver, make //
//	a single melee attack against an opponent.	//
//	This is a touch attack rather than a 		//
//	standard melee attack. If you hit, you deal //
//	normal melee damage.						//
//////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_inc_constants"

void EmeraldRazor(object oTarget)
{
	object oPC = OBJECT_SELF;
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = TouchAttackMelee(oTarget, TRUE);

	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	BasicAttackAnimation(oWeapon, nHit, FALSE, FALSE); 
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 60);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DiamondMindStrike", 1);
	DelayCommand(RoundsToSeconds(1), SetLocalInt(oToB, "DiamondMindStrike", 0));
	
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	effect eRazor = EffectVisualEffect(VFX_TOB_ERAZOR);

	DelayCommand(1.0f, EmeraldRazor(oTarget));
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRazor, oPC, 6.0f);
	ExpendManeuver(60, "STR");
}