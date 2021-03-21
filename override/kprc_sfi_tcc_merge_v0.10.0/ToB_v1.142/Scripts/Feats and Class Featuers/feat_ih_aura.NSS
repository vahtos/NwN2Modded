//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 3/31/2009									//
//	Title: feat_ih_aura								//
//	Description: While in an ironheart stance all	//
//	adjacent allies gain +2 saves.					//
//////////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_feats"
#include "bot9s_include"

void IronHeartAura()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6510);

	int nStance = GetLocalInt(oToB, "Stance");
	int nStance2 = GetLocalInt(oToB, "Stance2");
	
	if (nStance == STANCE_ABSOLUTE_STEEL || nStance2 == STANCE_ABSOLUTE_STEEL
	|| nStance == STANCE_DANCING_BLADE_FORM || nStance2 == STANCE_DANCING_BLADE_FORM
	|| nStance == STANCE_PUNISHING_STANCE || nStance2 == STANCE_PUNISHING_STANCE
	|| nStance == STANCE_SUPREME_BLADE_PARRY || nStance2 == STANCE_SUPREME_BLADE_PARRY)
	{
		location lPC = GetLocation(oPC);
		float fRange = GetGirth(oPC) + FeetToMeters(5.0f);
		
		object oFriend;
		float fDist;

		oFriend = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);

		while (GetIsObjectValid(oFriend))
		{
			fDist = GetDistanceBetween(oPC, oFriend);

			if ((fDist <= fRange) && (!GetIsReactionTypeHostile(oFriend, oPC)))
			{
				effect eSaves = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
				eSaves = ExtraordinaryEffect(eSaves);

				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSaves, oFriend, 6.0f);
			}

			oFriend = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);
		}
	}

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
	DelayCommand(6.0f, IronHeartAura());
}

void CheckLoopEffect()
{
	if(!CheckRecursive(6510))
	{
		IronHeartAura(); //Only runs if the effect is no longer on the player.
	}
}

void main()
{
	DelayCommand(6.0f, CheckLoopEffect()); // Needs to be delayed because when the feat fires after resting the engine doesn't detect effects immeadiately.
}