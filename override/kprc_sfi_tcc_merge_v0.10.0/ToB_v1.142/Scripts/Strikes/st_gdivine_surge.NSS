//////////////////////////////////////////////////////////////////
//	Author: Drammel												//
//	Date: 10/26/2009											//
//	Title: st_gdivine_surge										//
//	Description: As part of this maneuver, you make a single    //
//  melee attack that deals an extra 6d8 points of damage. In   //
//  addition, before making this melee attack, you can also     //
//  decide to take a number of points of Constitution damage    //
//  equal to your initiator level or lower. For each point of   //
//  Constitution damage you take, you gain a +1 bonus on your   //
//  attack roll and deal an extra 2d8 points of damage. After   //
//  using this maneuver, you are considered flat-footed until   //
//  the beginning of your next turn.                            //
//////////////////////////////////////////////////////////////////

#include "bot9s_armor"
#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 37);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	if (GetAbilityScore(oPC, ABILITY_CONSTITUTION) < 1)
	{
		SendMessageToPC(oPC, "<color=red>You do not have enough constitution to preform this maneuver.</color>");
		return;
	}

	SetLocalInt(oToB, "DevotedSpiritStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DevotedSpiritStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nCon = GetLocalInt(oToB, "GDivineCon");
	int nHit = StrikeAttackRoll(oWeapon, oTarget, nCon);
	int nDamage = d8(2 * nCon);
	effect eVis = EffectVisualEffect(VFX_GDIVINE_SURGE);

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPC, 6.0f);
	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	BasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget, nDamage));
	DelayCommand(0.4f, DropDead(oPC, ABILITY_CONSTITUTION));
	DelayCommand(6.0f, SetLocalInt(oPC, "OverrideFlatFootedAC", 1));
	DelayCommand(12.0f, SetLocalInt(oPC, "OverrideFlatFootedAC", 0));
	ExpendManeuver(37, "STR");

	int nAC = GetAC(oPC) - GetFlatFootedAC(oPC);

	if (nAC > 0)
	{
		effect eFlat = EffectACDecrease(nAC);

		DelayCommand(6.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFlat, oPC, 6.0f));
	}

	if (nCon > 0)
	{
		effect eDamage = EffectAbilityDecrease(ABILITY_CONSTITUTION, nCon);
		eDamage = ExtraordinaryEffect(eDamage);
		eDamage = SetEffectSpellId(eDamage, -1);

		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oPC);
	}
}