//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: April Fool's Day 2009						//
//	Title: feat_wr_defense							//
//	Description: While in a White Raven stance if at//
//	least one ally is within 5 feet, gain +1 AC.	//
//	Additionally, while you wield a White Raven		//
//	weapon, they gain +1 AC.						//
//////////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_feats"
#include "bot9s_inc_variables"
#include "bot9s_include"

void WhiteRavenDefense()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6513);
	
	int nStance = GetLocalInt(oToB, "Stance");
	int nStance2 = GetLocalInt(oToB, "Stance2");
	
	if (nStance == STANCE_BOLSTERING_VOICE || nStance2 == STANCE_BOLSTERING_VOICE
	|| nStance == STANCE_LEADING_THE_CHARGE || nStance2 == STANCE_LEADING_THE_CHARGE
	|| nStance == STANCE_PRESS_THE_ADVANTAGE || nStance2 == STANCE_PRESS_THE_ADVANTAGE
	|| nStance == STANCE_SWARM_TACTICS || nStance2 == STANCE_SWARM_TACTICS
	|| nStance == STANCE_TACTICS_OF_THE_WOLF || nStance2 == STANCE_TACTICS_OF_THE_WOLF)
	{
		float f8 = GetGirth(oPC) + FeetToMeters(5.0f); 
		float fRange = FeetToMeters(60.0f);
		float fDist;
		location lPC = GetLocation(oPC);
		object oFriend;

		oFriend = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);
		
		while (GetIsObjectValid(oFriend))
		{
			fDist = GetDistanceBetween(oPC, oFriend);

			if ((fDist <= f8) && (!GetIsReactionTypeHostile(oFriend, oPC)) && (oFriend != oPC))
			{
				object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
				
				if (GetIsWhiteRavenWeapon(oWeapon) == TRUE)
				{
					effect eBuddyAC = EffectACIncrease(1);
					eBuddyAC = ExtraordinaryEffect(eBuddyAC);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuddyAC, oFriend, 6.0f);
				}
				
				if (GetLocalInt(oToB, "WhiteRavenDefense") == 0) //Needed because there's often more than one party member.
				{
					SetLocalInt(oToB, "WhiteRavenDefense", 1);
					DelayCommand(5.99f, SetLocalInt(oToB, "WhiteRavenDefense", 0));
					
					effect eAC = EffectACIncrease(1);
					eAC = ExtraordinaryEffect(eAC);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, 6.0f);
				}
			}
			oFriend = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);
		}
	}

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
	DelayCommand(6.0f, WhiteRavenDefense());
}

void CheckLoopEffect()
{
	if(!CheckRecursive(6513))
	{
		WhiteRavenDefense(); //Only runs if the effect is no longer on the player.
	}
}

void main()
{
	DelayCommand(6.0f, CheckLoopEffect()); // Needs to be delayed because when the feat fires after resting the engine doesn't detect effects immeadiately.
}