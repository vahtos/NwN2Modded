//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 10/30/2009						//
//	Title: st_righteous						//
//	Description: When you make this strike, //
//  you or one ally within 10 feet of you   //
//  gains the benefit of a heal spell cast  //
//  as a cleric of your character level. To //
//  gain the benefit of this maneuver, you  //
//  must strike an enemy creature whose     //
//  alignment has at least one component    //
//  different from yours. This foe must pose//
//  a threat to you or your allies in some  //
//  direct, immediate way.                  //
//////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_inc_variables"
#include "tob_inc_spells"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 50);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DevotedSpiritStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DevotedSpiritStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);

	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	BasicAttackAnimation(oWeapon, nHit);
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));
	ExpendManeuver(50, "STR");

	if (nHit > 0)
	{
		int nMyAlign = GetAlignment(oPC);
		int nFoeAlign = GetAlignment(oTarget);

		if ((nMyAlign != nFoeAlign) && (GetIsReactionTypeHostile(oTarget, oPC)) && (GetIsInCombat(oTarget)))
		{
			int nInitiator = GetInitiatorLevel(oPC);

			object oHeal;

			oHeal = GetFactionMostDamagedMember(oPC);

			if ((oHeal != oPC) && (GetDistanceBetween(oPC, oHeal) > FeetToMeters(10.0f)))
			{
				oHeal = oPC;
			}

			// Heal target will figure out if whether it needs to heal or harm.
			HealHarmTarget(oHeal, nInitiator, SPELL_HEAL, TRUE);
		}
	}
}