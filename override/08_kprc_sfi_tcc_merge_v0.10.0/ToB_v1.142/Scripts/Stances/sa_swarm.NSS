//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 10/30/2009							//
//	Title: sa_swarm								//
//	Description: While you are in this stance,  //
//  you use your tactical knowledge and mastery //
//  to improve your allies' teamwork. If you are//
//  adjacent to one or more opponents, your     //
//  allies gain a +5 bonus on attack rolls made //
//  against the opponent you are currently      //
//  attacking.                                  //
//////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void SwarmTactics()
{
	if (ValidateStance(199))
	{
		object oPC = OBJECT_SELF;
		object oTarget = GetAttackTarget(oPC);
		float fGirth = GetGirth(oTarget);
		float fDist = fGirth + GetMeleeRange(oPC);

		if (GetDistanceBetween(oPC, oTarget) <= fDist)
		{
			location lPC = GetLocation(oPC);
			float fRange = FeetToMeters(60.0f);
			effect eAttack = EffectAttackIncrease(5);
			eAttack = ExtraordinaryEffect(eAttack);

			object oFriend, oFoe;

			oFriend = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);

			while (GetIsObjectValid(oFriend))
			{
				oFoe = GetAttackTarget(oFriend);
	
				if ((oFriend != oPC) && (oTarget == oFoe) && (!GetIsReactionTypeHostile(oFriend, oPC)))
				{
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAttack, oFriend, 6.0f);
				}

				oFriend = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);
			}
		}

		DelayCommand(6.0f, SwarmTactics());
	}
}

void main()
{
	SwarmTactics();
}