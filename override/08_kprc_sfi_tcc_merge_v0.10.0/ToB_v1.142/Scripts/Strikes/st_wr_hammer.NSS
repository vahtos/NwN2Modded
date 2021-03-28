//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 10/30/2009							//
//	Title: st_wr_hammer 						//
//	Description: As part of this maneuver, you  //
//  make a single, devastating strike against an//
//  opponent. The raw force of this blow knocks //
//  him senseless. Your attack deals an extra   //
//  6d6 points of damage and stuns your opponent//
//  for six seconds.                        	//
//////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 205);
	
	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "WhiteRavenHammerike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "WhiteRavenHammerike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nRoll = StrikeAttackRoll(oWeapon, oTarget);

	StrikeAttackSound(oWeapon, oTarget, nRoll, 0.3f);
	DelayCommand(0.1f, BasicAttackAnimation(oWeapon, nRoll)); 
	DelayCommand(0.4f, StrikeWeaponDamage(oWeapon, nRoll, oTarget, d6(6)));
	ExpendManeuver(205, "STR"); 

	if ((nRoll > 0) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_STUN)))
	{
		effect eVis = EffectVisualEffect(VFX_TOB_STARS);
		effect eHammer = EffectStunned();
		eHammer = ExtraordinaryEffect(eHammer);

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 6.0f);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHammer, oTarget, 6.0f);
	}			
}