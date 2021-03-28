//////////////////////////////////////////
//  Author: Drammel						//
//  Date: 6/19/2009						//
//  Title: sa_huntersns					//
//  Description: Grants the feat Scent	//
//	while the Stance is active.			//
//////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void HuntersSense()
{
	object oPC = OBJECT_SELF;

	if (ValidateStance(174))
	{
		if (!GetHasFeat(FEAT_SCENT, oPC))
		{
			WrapperFeatAdd(oPC, FEAT_SCENT, FALSE);
		}
		DelayCommand(6.0f, HuntersSense());
	}
	else FeatRemove(oPC, FEAT_SCENT);
}

void main()
{
	object oPC = OBJECT_SELF;

	if (!GetHasFeat(FEAT_SCENT, oPC))
	{
		HuntersSense();
	}
}