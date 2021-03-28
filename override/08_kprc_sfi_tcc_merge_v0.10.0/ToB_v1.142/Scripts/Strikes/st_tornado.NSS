//////////////////////////////////////////////////////////////////////////////
//	Author: Drammel															//
//	Date: 10/30/2009														//
//	Title: st_tornado														//
//	Description: As part of initiating this maneuver, you move up to your   //
//  opponent, throw her aside, and move again. You must move at least 10    //
//  feet before making your throw. This movement and your movement after    //
//  your throw provoke attacks of opportunity as normal. You can move up to //
//  double your speed as part of this maneuver. If you fail in your throw   //
//  attempt, you can still move afterward. After every 10 feet you move, you//
//  can attempt another throw against the same opponent or a different foe. //
//  To make your throw attempt, you must succeed on a melee touch attack.   //
//  Resolve the throw as a trip attempt, but you do not provoke attacks of  //
//  opportunity, and your opponent cannot try to trip you if you lose the   //
//  opposed check. You can use your Dexterity or Strength modifier on this  //
//  check, whichever is better. You gain a +2 bonus on this check for every //
//  5 feet that you have moved during your turn.  If you succeed in tripping//
//  your foe, you throw him up to 10 feet away from you. The target falls   //
//  prone in the destination space and takes 2d6 points of damage. He lands //
//  in a random direction away from you. For every 5 points by which you win//
//  the opposed check, you gain an additional 5 feet of throw distance and  //
//  the target takes an additional 1d6 points of damage. For example, if you//
//  win by 10, you can place your foe in any space within 20 feet of you,   //
//  and he takes a total of 4d6 points of damage.  An enemy you throw with  //
//  this maneuver does not provoke attacks of opportunity for passing       //
//  through enemies' threatened areas as part of the throw, and you can     //
//  throw an enemy through occupied squares.                                //
//////////////////////////////////////////////////////////////////////////////

#include "bot9s_inc_feats"
#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"
#include "tob_x0_i0_position"

void TornadoThrow(object oPC, object oToB, location lPC)
{
	float fRange = GetMeleeRange(oPC);
	object oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oPC);

	if (GetLocalInt(oPC, "TornadoThrowActive") == 1)
	{
		DelayCommand(0.1f, TornadoThrow(oPC, oToB, lPC));
	}

	if ((GetLocalInt(oPC, "TornadoGate") == 0) && (GetIsObjectValid(oTarget)) && (GetDistanceBetween(oPC, oTarget) - GetGirth(oTarget) <= fRange))
	{
		SetLocalInt(oPC, "TornadoGate", 1);

		int nTouch = TouchAttackMelee(oTarget);

		if (nTouch > 0)
		{
			int nMyStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
			int nFoeStr = GetAbilityModifier(ABILITY_STRENGTH, oTarget);
			int nMyDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
			int nFoeDex = GetAbilityModifier(ABILITY_DEXTERITY, oTarget);
			int nBonus, nFoeBonus, nAbility, nFoeAbility;
	
			if (nMyStr >= nMyDex)
			{
				nAbility = nMyStr;
			}
			else nAbility = nMyDex;
	
			if (nFoeStr >= nFoeDex)
			{
				nFoeAbility = nFoeStr;
			}
			else nFoeAbility = nFoeDex;
	
			nBonus += GetLocalInt(oPC, "TornadoBonus");
	
			int nMySize = GetCreatureSize(oPC);
			int nFoeSize = GetCreatureSize(oTarget);
	
			if (GetRacialType(oTarget) == RACIAL_TYPE_DWARF) // Dwarven Stability in all its stockiness!
			{
				nFoeBonus += 4;
			}
		
			if (nMySize > CREATURE_SIZE_MEDIUM)
			{
				nBonus += (nMySize - CREATURE_SIZE_MEDIUM) * 4;
			}
			else if (nMySize < CREATURE_SIZE_MEDIUM)
			{
				nBonus -= (CREATURE_SIZE_MEDIUM - nMySize) * 4;
			}
	
			if (nFoeSize > CREATURE_SIZE_MEDIUM)
			{
				nFoeBonus += (nFoeSize - CREATURE_SIZE_MEDIUM) * 4;
			}
			else if (nFoeSize < CREATURE_SIZE_MEDIUM)
			{
				nFoeBonus -= (CREATURE_SIZE_MEDIUM - nFoeSize) * 4;
			}
	
			int nMyd20 = d20(1);
			int nFoed20 = d20(1);
			int nMyRoll = nAbility + nBonus + nMyd20;
			int nFoeRoll = nFoeAbility + nFoeBonus + nFoed20;
	
			SendMessageToPC(oPC, "<color=chocolate>Trip: " + GetName(oPC) + " : (" + IntToString(nAbility) + " + " + IntToString(nBonus) + " + " + IntToString(nMyd20) + " = " + IntToString(nMyRoll) + ") vs. " + GetName(oTarget) + " : (" + IntToString(nFoeAbility) + " + " + IntToString(nFoeBonus) + " + " + IntToString(nFoed20) + " = " + IntToString(nFoeRoll) + ")</color>");
	
			if (nMyRoll >= nFoeRoll)
			{
				float fDiff = IntToFloat(nMyRoll - nFoeRoll);
				int nExtra = FloatToInt(fDiff / 5.0f);
				float fDistMod = fDiff;
				float fSpace = GetDistanceBetween(oPC, oTarget);
				location lLand = GetRandomLocation(GetArea(oPC), oPC, fSpace + fDistMod + FeetToMeters(10.0f));
				effect eKnockdown = EffectKnockdown();
				effect eDamage = EffectDamage(d6(2 + nExtra), DAMAGE_TYPE_BLUDGEONING); // I don't think it's a far cry to assume this is bludgeoning damage.

				ThrowTarget(oTarget, fSpace + fDistMod + FeetToMeters(10.0f), FALSE, FALSE);
				DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, 3.0f));
				DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));

				if (GetLocalInt(oToB, "FallingSun") == 1) //Falling Sun Feat Support
				{
					effect eFallingSun = FallingSunAttack(oTarget);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFallingSun, oTarget, 6.0f);
				}
			}
		}
	}
}

void TrackLocations(object oPC, location lOrigin)
{
	location lCurrent = GetLocation(oPC);
	location lLast = GetLocalLocation(oPC, "TornadoThrowLast");
	float fMoved = GetDistanceBetweenLocations(lCurrent, lLast);

	if (fMoved >= 0.01f)
	{
		SetLocalLocation(oPC, "TornadoThrowLast", lCurrent);

		location lMarker = GetLocalLocation(oPC, "TornadoThrowMarker");

		if (GetDistanceBetweenLocations(lMarker, lCurrent) >= FeetToMeters(10.0f))
		{
			SetLocalLocation(oPC, "TornadoThrowMarker", lCurrent);
			SetLocalInt(oPC, "TornadoGate", 0);
		}

		float fDist = GetDistanceBetweenLocations(lOrigin, lCurrent);

		if (fDist >= FeetToMeters(5.0f))
		{
			int nBonus = FloatToInt(fDist / 2.5f);

			SetLocalInt(oPC, "TornadoBonus", nBonus);
		}

		DelayCommand(1.01, TrackLocations(oPC, lOrigin));
	}
	else
	{
		DeleteLocalInt(oPC, "TornadoBonus");
		DeleteLocalInt(oPC, "TornadoGate");
		DeleteLocalInt(oPC, "TornadoThrowActive");
		DeleteLocalLocation(oPC, "TornadoThrowLast");
		DeleteLocalLocation(oPC, "TornadoThrowMarker");
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	float fx = GetManeuverX(oToB, 115);
	float fy = GetManeuverY(oToB, 115);
	float fz = GetManeuverZ(oToB, 115);
	vector vTarget = Vector(fx, fy, fz);
	location lTarget = Location(GetArea(oPC), vTarget, GetFacing(oPC));
	location lPC = GetLocation(oPC);

	if (!GetIsLocationValid(lTarget))
	{
		SendMessageToPC(oPC, "<color=red>You have not selected a valid location as your destination.</color>");
		return;
	}
	else if (GetDistanceBetweenLocations(lPC, lTarget) < FeetToMeters(10.0f))
	{
		SendMessageToPC(oPC, "<color=red>You must be at least 10 feet away from your target location to initiate a Tornado Throw.</color>");
		return;
	}

	SetLocalInt(oToB, "SettingSunStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "SettingSunStrike", 0));

	effect eTornado = EffectVisualEffect(VFX_TOB_TORNADO);
	effect eSpeed = EffectMovementSpeedIncrease(99);

	ClearAllActions();
	ClearStrikes();
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpeed, oPC, 6.0f);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTornado, oPC, 6.0f);
	SetLocalInt(oPC, "TornadoThrowActive", 1);
	SetLocalLocation(oPC, "TornadoThrowMarker", lPC);
	SetLocalLocation(oPC, "TornadoThrowLast", lPC);
	WrapperPlayCustomAnimation(oPC, "*whirlwind", 0);
	ExpendManeuver(115, "STR");
	DelayCommand(1.05, TrackLocations(oPC, lPC));
	DelayCommand(0.1, TornadoThrow(oPC, oToB, lPC));
	AssignCommand(oPC, ActionMoveToLocation(lTarget, TRUE));
}