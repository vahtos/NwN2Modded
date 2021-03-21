//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 10/17/2009								//
//	Title: st_colossus								//
//	Description: As part of this maneuver, you make //
//  a melee attack against your foe. This attack    //
//  deals an extra 6d6 points of damage, and the    //
//  creature struck must succeed on a Fortitude save//
//  (DC 17 + your Str modifi er) or be hurled 1d4   //
//  squares away from you, falling prone in that    //
//  square. A creature of a smaller size category   //
//  than yours gets a –2 penalty on this save; a    //
//  creature of a larger size category than yours   //
//  gets a +2 bonus on the save. The enemy’s        //
//  movement doesn’t provoke attacks of opportunity.//
//  If an obstacle blocks the creature’s movement,  //
//  it instead stops in the first unoccupied square //
//////////////////////////////////////////////////////

#include "tob_i0_spells"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 147);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "StoneDragonStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "StoneDragonStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);

	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	BasicAttackAnimation(oWeapon, nHit); 
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget, d6(6)));
	ExpendManeuver(147, "STR");

	if (nHit > 0)
	{
		int nMySize = GetCreatureSize(oPC);
		int nFoeSize = GetCreatureSize(oTarget);
		int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
		int nDC;

		nDC = GetManeuverDC(nStr, 0, 17);

		if (nMySize > nFoeSize)
		{
			nDC += 2;
		}
		else if (nMySize < nFoeSize)
		{
			nDC -= 2;
		}

		int nFort = MySavingThrow(SAVING_THROW_FORT, oTarget, nDC);

		if (nFort == 0)
		{
			float fSpace = GetDistanceBetween(oPC, oTarget);
			float fDist = fSpace + (5.0f * IntToFloat(d4(1)));
			effect eHit = EffectVisualEffect(VFX_COM_SPARKS_PARRY);
			effect eKnockdown = EffectKnockdown();

			DelayCommand(0.3f, ThrowTarget(oTarget, fDist));
			DelayCommand(0.29f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget));
			DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, 3.0f));
		}
	}
}