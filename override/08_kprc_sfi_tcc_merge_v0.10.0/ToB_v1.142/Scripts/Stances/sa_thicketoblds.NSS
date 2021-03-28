//////////////////////////////////////////////////////
//  Author: Drammel									//
//  Date: 8/28/2009									//
//  Title: sa_thicketoblds							//
//  Description: While you are in this stance, any  //
//  opponent you threaten that takes any sort of 	//
//  movement provokes an attack of opportunity from //
//  you. Your foes provoke this attack before  		//
//  leaving the area you threaten.					//
//////////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void ThicketLocations()
{
	if (ValidateStance(51))
	{
		object oPC = OBJECT_SELF;
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

		if ((!GetWeaponRanged(oWeapon)) && (!GetStealthMode(oPC)))
		{
			float fReach = GetMeleeRange(oPC);
			object oFoe;
			location lFoe, lPC;

			lPC = GetLocation(oPC);
			oFoe = GetFirstObjectInShape(SHAPE_SPHERE, fReach, lPC, TRUE);

			while (GetIsObjectValid(oFoe))
			{
				if (GetIsReactionTypeHostile(oFoe, oPC))
				{
					lFoe = GetLocation(oFoe);
					SetLocalLocation(oFoe, "ThicketOfBlades_loc", lFoe);
				}

				oFoe = GetNextObjectInShape(SHAPE_SPHERE, fReach, lPC, TRUE);
			}
			SetLocalLocation(oPC, "ThicketOfBlades_loc_PC", lPC);
		}
		DelayCommand(1.0f, ThicketLocations());
	}
}

void ThicketOfBlades()
{
	object oPC = OBJECT_SELF;

	if (ValidateStance(51))
	{
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		location lPC = GetLocation(oPC);
		location lLast = GetLocalLocation(oPC, "ThicketOfBlades_loc_PC");
		float fDist = GetDistanceBetweenLocations(lPC, lLast);
		float fShort = 0.1f; // Any movement provokes, but a stationary creature can sometimes accidentlly change its location vector while turning on a spot.
		// It helps to allow for a small distance to prevent this ability from triggering when it really shouldn't.

		if ((!GetWeaponRanged(oWeapon)) && (fDist <= fShort) && (!GetStealthMode(oPC)))
		{
			float fReach = GetMeleeRange(oPC);
			object oFoe;
			location lOld, lFoe;
	
			oFoe = GetFirstObjectInShape(SHAPE_SPHERE, fReach, lPC, TRUE);
	
			while (GetIsObjectValid(oFoe))
			{
				if (GetIsReactionTypeHostile(oFoe, oPC))
				{
					lOld = GetLocalLocation(oFoe, "ThicketOfBlades_loc");
					lFoe = GetLocation(oFoe);
	
					float fThicket = GetDistanceBetweenLocations(lFoe, lOld);
	
					if (fThicket > fShort) // Or in other words: if the target has moved.
					{
						int nBonusHit = GetLocalInt(oPC, "OverrideAoOHitBonus");
						int nBonusDamage = GetLocalInt(oPC, "OverrideAoODamageBonus");
						int nHit = StrikeAttackRoll(oWeapon, oFoe, nBonusHit);
	
						StrikeWeaponDamage(oWeapon, nHit, oFoe, nBonusDamage);
						SetLocalInt(oPC, "Halt_AoO_override_loc", 1); // In case there's an override running, this prevents extra damage.
						SetLocalInt(oPC, "bot9s_AoO_overridestate", 0);
					}
				}
				oFoe = GetNextObjectInShape(SHAPE_SPHERE, fReach, lPC, TRUE);
			}
		}
		DelayCommand(1.0f, ThicketOfBlades());
	}
	else
	{
		DeleteLocalLocation(oPC, "ThicketOfBlades_loc_PC");
	}
}

void main()
{
	object oPC = OBJECT_SELF;

	SetLocalLocation(oPC, "ThicketOfBlades_loc_PC", GetLocation(oPC));
	AssignCommand(oPC, ThicketLocations());
	DelayCommand(0.5f, ThicketOfBlades());
}