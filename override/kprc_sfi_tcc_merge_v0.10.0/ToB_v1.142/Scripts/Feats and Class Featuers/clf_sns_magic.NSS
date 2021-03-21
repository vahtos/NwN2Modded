//////////////////////////////////////////////
//	Author: Drammel          	       		//
//	Date: 4/15/2009                    		//
//	Title: clf_sns_magic		   			//
//	Description: Identifies an item based on//
//	the player's swordsage level.			//
//////////////////////////////////////////////

#include "bot9s_inc_constants"

void main()
{
	object oPC = OBJECT_SELF;
	
	int nLevel = GetLevelByClass(CLASS_TYPE_SWORDSAGE, oPC) / 2;
	effect eVis = EffectNWN2SpecialEffectFile("ror_blue_eyes1", oPC);
	effect eSenseMagic = EffectSkillIncrease(SKILL_LORE, nLevel);
	eVis = SupernaturalEffect(eVis);
	eSenseMagic = SupernaturalEffect(eSenseMagic);
	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPC, 3.0f);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSenseMagic, oPC, 18.0f);
	DelayCommand(16.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPC, 3.0f));
}