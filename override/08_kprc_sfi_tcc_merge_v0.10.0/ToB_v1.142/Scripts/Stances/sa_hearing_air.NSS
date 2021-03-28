//////////////////////////////////////////
//  Author: Drammel						//
//  Date: 9/15/2009						//
//  Title: sa_hearing_air				//
//  Description: Grants the feat Keen	//
//	Senses while the Stance is active.	//
//////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void HearingTheAir()
{
	object oPC = OBJECT_SELF;

	if (ValidateStance(61))
	{
		if (!GetHasFeat(FEAT_KEEN_SENSE, oPC))
		{
			WrapperFeatAdd(oPC, FEAT_KEEN_SENSE, FALSE);
		}

		effect eAir = EffectSkillIncrease(SKILL_LISTEN, 5);
		eAir = ExtraordinaryEffect(eAir);

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAir, oPC, 6.0f);
		DelayCommand(6.0f, HearingTheAir());
	}
	else if (GetRacialType(oPC) != RACIAL_TYPE_ELF)
	{
		FeatRemove(oPC, FEAT_KEEN_SENSE);
	}
}

void main()
{
	HearingTheAir();
}