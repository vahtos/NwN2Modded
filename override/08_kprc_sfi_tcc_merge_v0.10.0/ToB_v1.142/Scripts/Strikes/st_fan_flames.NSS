//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 8/28/2009									//
//	Title: st_fan_flames							//
//	Description: If you make a successful ranged    //
//  touch attack, your target takes 6d6 points of   //
//  fire damage.									//
//////////////////////////////////////////////////////

#include "bot9s_inc_2da"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 8);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DesertWindStrike", 1);
	DelayCommand(RoundsToSeconds(1), SetLocalInt(oToB, "DesertWindStrike", 0));

	int nHit = TouchAttackRanged(oTarget);
	float fHitDist = tob_Get2daFloat("appearance", "PREFATCKDIST", GetAppearanceType(oTarget));
	float fDist = GetDistanceBetween(oPC, oTarget);

	if (fDist <= ((FeetToMeters(30.0f) + fHitDist)))
	{
		location lPC = GetLocation(oPC);

		if (nHit > 0)
		{
			int nDamage;
	
			if (nHit == 1)
			{
				nDamage = d6(6);
			}
			else nDamage = d6(12);
	
			effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
			float fDelay = GetSpellEffectDelay(lPC, oTarget);
	
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
		}
	
		WatchOpponent(oTarget, oPC);
		WrapperPlayCustomAnimation(oPC, "Throw", 0);
		SpawnSpellProjectile(oPC, oTarget, lPC, GetLocation(oTarget), SPELL_FIREBALL, PROJECTILE_PATH_TYPE_DEFAULT);
		ExpendManeuver(8, "STR");
	}
	else SendMessageToPC(oPC, "<color=red>You must be within 30 feet of your target to use this maneuver.</color>");
}