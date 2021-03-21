//////////////////////////////////////////////////////////
//	Author: Drammel										//
//	Date: 10/6/2009										//
//	Title: st_g_insightful								//
//	Description: This maneuver functions like insightful//
//  strike, except that you deal damage equal to 2 ×    //
//  your Concentration check result.					//
//////////////////////////////////////////////////////////

#include "bot9s_inc_fx"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 63);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DiamondMindStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DiamondMindStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);

	ExpendManeuver(63, "STR");
	StrikeAttackSound(oWeapon, oTarget, nHit, 1.2f);
	WrapperPlayCustomAnimation(oPC, "*sneakattack", 0);
	StrikeTrailEffect(oWeapon, nHit, 2.0f);
	StrikeWeaponDamage(oWeapon, nHit, oTarget, 0, FALSE, TRUE); //Damage is supressed, but all other relavent events fire.

	if (nHit > 0)
	{
		int nd20 = d20();
		int nConcentration;

		if (GetHasFeat(6908, oPC)) // Blade Meditation adds to the skill, but is not included in GetSkillRank.
		{
			nConcentration += 1;
		}

		nConcentration += GetSkillRank(SKILL_CONCENTRATION, oPC);

		if ((nHit == 2) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)))
		{
			nConcentration = nConcentration * 2;
			nd20 = nd20 * 2;
		}

		if (nConcentration < 1)
		{
			nConcentration = 1;
		}

		int nDamage = (nConcentration + nd20) * 2;
		int nDamageType = GetWeaponDamageType(oWeapon);
		effect eDamage = EffectDamage(nDamage, nDamageType);

		SendMessageToPC(oPC, "<color=chocolate>Greater Insightful Strike: Concentration : " + "(" + IntToString(nConcentration) + " + " + IntToString(nd20) + " x 2 " + " = " + IntToString(nDamage)  + ").</color>");
		DelayCommand(1.34f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
		DelayCommand(1.34f, SpawnBloodHit(oTarget, OVERRIDE_ATTACK_RESULT_PARRIED, oPC));
	}
}