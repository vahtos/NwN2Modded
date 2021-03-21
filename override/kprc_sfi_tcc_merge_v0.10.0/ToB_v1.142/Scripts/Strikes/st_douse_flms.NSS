//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 7/10/2009								//
//	Title: st_douse_flms						//
//	Description: If this strike hits, both you	//
//	and your target take a penalty to attack 	//
//	rolls equal to your ranks in Diplomacy minus//
//	four, divided by four, to a minimum of a 	//
//	minus one penalty to attack rolls.			//
//////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 192);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "WhiteRavenStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "WhiteRavenStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);
	
	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	BasicAttackAnimation(oWeapon, nHit); 
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));
	ExpendManeuver(192, "STR");

	if (nHit > 0)
	{
		int nRank = GetSkillRank(SKILL_DIPLOMACY, oPC);
		int nDiplomacy;

		nDiplomacy = (nRank - 4)/4;

		if (nDiplomacy < 1)
		{
			nDiplomacy = 1;
		}

		effect eDouse = EffectAttackDecrease(nDiplomacy);
		eDouse = ExtraordinaryEffect(eDouse);
		effect eVisual = EffectVisualEffect(VFX_TOB_CIRCLE_BLUEFIRE);

		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oPC);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDouse, oPC, 6.0f);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDouse, oTarget, 6.0f);
	}
}