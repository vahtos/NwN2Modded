//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 8/25/2009							//
//	Title: st_revitalizing					//
//	Description: Standard Action; On a		//
//	successful hit the player or an ally	//
//	within ten feet heals 3d6+1 per 		//
//	intitiator level of damage (max +10).	//
//////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_inc_variables"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 47);

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
	ExpendManeuver(47, "STR");

	if (nHit > 0)
	{
		int nMyAlign = GetAlignment(oPC);
		int nFoeAlign = GetAlignment(oTarget);

		if ((nMyAlign != nFoeAlign) && (GetIsReactionTypeHostile(oTarget, oPC)) && (GetIsInCombat(oTarget)))
		{
			int nInitiator;
	
			if (GetInitiatorLevel(oPC) < 10)
			{
				nInitiator = GetInitiatorLevel(oPC);
			}
			else nInitiator = 10;

			object oHeal;
	
			oHeal = GetFactionMostDamagedMember(oPC);
	
			if (GetDistanceBetween(oPC, oHeal) > FeetToMeters(10.0f))
			{
				oHeal = oPC;
			}

			int nHeal = d6(3) + nInitiator;
			effect eHeal = ManeuverHealing(oHeal, nHeal);
	
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oHeal);
		}
	}
}