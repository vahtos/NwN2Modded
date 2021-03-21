//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 9/12/2009								//
//	Title: st_wr_strike 						//
//	Description: As part of this maneuver, you  //
//  make a single melee attack. If it hits, you //
//  deal an extra 4d6 points of damage, and the //
//  target is considered flat-footed until the  //
//  start of his next turn.	                	//
//////////////////////////////////////////////////

#include "bot9s_armor"
#include "bot9s_combat_overrides"
#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 206);
	
	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "WhiteRavenStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "WhiteRavenStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nRoll = StrikeAttackRoll(oWeapon, oTarget);

	StrikeAttackSound(oWeapon, oTarget, nRoll, 0.3f);
	DelayCommand(0.1f, BasicAttackAnimation(oWeapon, nRoll)); 
	DelayCommand(0.4f, StrikeWeaponDamage(oWeapon, nRoll, oTarget, d6(4)));
	ExpendManeuver(206, "STR"); 

	if (nRoll > 0)
	{
		if (!GetHasFeat(FEAT_UNCANNY_DODGE, oTarget))
		{
			int nAC = GetAC(oTarget);
			int nFlat = GetFlatFootedAC(oTarget);
			int nPenalty = nAC - nFlat;

			OverrideAttackRollAC(oTarget, 2);
			DelayCommand(6.0f, RemoveAttackRollOverride(oTarget, 1));

			if (nPenalty > 0)
			{
				effect eWrStr = EffectACDecrease(nPenalty);
				eWrStr = ExtraordinaryEffect(eWrStr);

				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWrStr, oTarget, 6.0f);
			}
		}
	}			
}