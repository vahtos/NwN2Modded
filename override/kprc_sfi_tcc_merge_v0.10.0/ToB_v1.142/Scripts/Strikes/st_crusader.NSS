//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 6/19/2009							//
//	Title: st_crusader						//
//	Description: Standard Action; On a		//
//	successful hit the player or an ally	//
//	within ten feet heals 1d6+1 per 		//
//	intitiator level of damage (max +5).	//
//////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_inc_variables"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 33);

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
	ExpendManeuver(33, "STR");

	if (nHit > 0)
	{
		int nMyAlign = GetAlignment(oPC);
		int nFoeAlign = GetAlignment(oTarget);

		if ((nMyAlign != nFoeAlign) && (GetIsReactionTypeHostile(oTarget, oPC)) && (GetIsInCombat(oTarget)))
		{
			int nInitiator;
	
			if (GetInitiatorLevel(oPC) < 5)
			{
				nInitiator = GetInitiatorLevel(oPC);
			}
			else nInitiator = 5;

			object oHeal;
	
			oHeal = GetFactionMostDamagedMember(oPC);
	
			if ((oHeal != oPC) && (GetDistanceBetween(oPC, oHeal) > FeetToMeters(10.0f)))
			{
				oHeal = oPC;
			}

			int nHeal = d6(1) + nInitiator;
			effect eHeal = ManeuverHealing(oHeal, nHeal);
	
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oHeal);
		}
	}
}