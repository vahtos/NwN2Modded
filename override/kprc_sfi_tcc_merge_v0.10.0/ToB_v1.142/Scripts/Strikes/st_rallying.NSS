//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 10/6/2009							//
//	Title: st_rallying						//
//	Description: As part of initiating this //
//  strike, you must make a successful melee//
//  attack against an enemy whose alignment //
//  has at least one component different    //
//  from yours. This foe must pose a threat //
//  to you or your allies in some direct,   //
//  immediate way. If your attack hits, you //
//  and all allies within 30 feet of you    //
//  heal 3d6 points of damage + 1 point per //
//  initiator level (maximum +15).	        //
//////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_inc_variables"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 46);

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
	ExpendManeuver(46, "STR");

	if (nHit > 0)
	{
		int nMyAlign = GetAlignment(oPC);
		int nFoeAlign = GetAlignment(oTarget);

		if ((nMyAlign != nFoeAlign) && (GetIsReactionTypeHostile(oTarget, oPC)) && (GetIsInCombat(oTarget)))
		{
			int nInitiator;
	
			if (GetInitiatorLevel(oPC) < 15)
			{
				nInitiator = GetInitiatorLevel(oPC);
			}
			else nInitiator = 15;

			float fRange = FeetToMeters(30.0f);
			location lPC = GetLocation(oPC);
			int nHeal;
			object oHeal;
			effect eHeal;
	
			oHeal = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);
	
			while (GetIsObjectValid(oHeal))
			{
				if (!GetIsReactionTypeHostile(oHeal, oPC))
				{
					nHeal = d6(3) + nInitiator;
					eHeal = ManeuverHealing(oHeal, nHeal);

					ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oHeal);
				}

				oHeal = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);
			}
		}
	}
}