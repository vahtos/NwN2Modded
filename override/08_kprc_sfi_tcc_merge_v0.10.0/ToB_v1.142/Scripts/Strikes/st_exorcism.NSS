//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 8/28/2009								//
//	Title: st_exorcism							//
//	Description: As part of this maneuver, make //
//	a single melee attack against an opponent.	//
//	This is a touch attack rather than a 		//
//	standard melee attack. If you hit, you deal //
//	normal melee damage.						//
//////////////////////////////////////////////////

#include "tob_i0_spells"
#include "bot9s_attack"
#include "bot9s_inc_maneuvers"
#include "bot9s_inc_variables"
#include "bot9s_include"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 81);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "IronHeartStrike", 1);
	DelayCommand(RoundsToSeconds(1), SetLocalInt(oToB, "IronHeartStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);

	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	BasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));
	ExpendManeuver(81, "STR");

	object oFoeWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);

	if ((GetIsObjectValid(oFoeWeapon)) && (nHit > 0 ))
	{
		int nBonus;
		int nFoeBonus;

		if (IsWeaponTwoHanded(oPC))
		{
			nBonus += 4;
		}

		if (GetIsLightWeapon(oWeapon, oPC))
		{
			nBonus -= 4;
		}

		int nMySize = GetCreatureSize(oPC);
		int nFoeSize = GetCreatureSize(oTarget);
		int nBig = abs(nMySize - nFoeSize);

		if (nMySize > nFoeSize)
		{
			nBonus += 4 * nBig;
		}
		else if (nFoeSize > nMySize)
		{
			nFoeBonus += 4 * nBig;
		}

		int nAB = GetMaxAB(oPC, oWeapon, oTarget);
		int nFoeAB = GetMaxAB(oTarget, oFoeWeapon, oPC);
		int nd20 = d20();
		int nFoed20 = d20();
		int nRoll = nd20 + nAB + nBonus;
		int nFoeRoll = nFoed20 + nFoeAB + nFoeBonus;

		SendMessageToPC(oPC, "<color=chocolate>Exorcism of Steel: Sunder: (" + IntToString(nd20) + " + " + IntToString(nAB) + " + " + IntToString(nBonus) + " = " + IntToString(nRoll) + ") vs. " + GetName(oTarget) + "'s opposed roll: (" + IntToString(nFoed20) + " + " + IntToString(nFoeAB) + " + " + IntToString(nFoeBonus) + " = " + IntToString(nFoeRoll) + ").</color>");

		if (nRoll >= nFoeRoll)
		{
			int nDamageType = GetWeaponDamageType(oFoeWeapon);
			int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
			int nDC = GetManeuverDC(nStr, 0, 13);
			int nWill = MySavingThrow(SAVING_THROW_WILL, oTarget, nDC);
			int nPenalty;

			if (nWill == 0)
			{
				nPenalty = 4;
			}
			else if (GetHasFeat(6818, oTarget)) // Mettle
			{
				nPenalty = 0;
			}
			else nPenalty = 2;

			effect eExorcism = EffectDamageDecrease(nPenalty, nDamageType);
			eExorcism = ExtraordinaryEffect(eExorcism);

			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eExorcism, oTarget, 60.0f);
		}
	}
}