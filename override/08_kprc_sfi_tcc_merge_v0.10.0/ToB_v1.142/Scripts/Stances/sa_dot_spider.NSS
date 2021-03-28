//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 8/27/2009							//
//	Title: sa_dot_spider					//
//	Description: Grants a bonus to Move		//
//  Silently that makes it equal to your    //
//  skill in Hide.							//
//////////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void DanceOfTheSpider()
{
	if (ValidateStance(122))
	{
		object oPC = OBJECT_SELF;
		int nHide = GetSkillRank(SKILL_HIDE, oPC);
		int nMoveSilently = GetSkillRank(SKILL_MOVE_SILENTLY, oPC);

		if (nHide > nMoveSilently)
		{
			int nBonus = nHide - nMoveSilently;
			effect eSpider = EffectSkillIncrease(SKILL_MOVE_SILENTLY, nBonus);
			eSpider = SupernaturalEffect(eSpider);

			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpider, oPC, 5.99f);
		}

		DelayCommand(6.0f, DanceOfTheSpider());
	}
}

void main()
{
	DanceOfTheSpider();
}