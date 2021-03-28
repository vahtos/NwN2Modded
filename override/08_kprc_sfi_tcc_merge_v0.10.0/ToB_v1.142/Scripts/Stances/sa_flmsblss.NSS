//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 2/8/2009							//
//	Title: sa_flmsblss						//
//	Description: Stance; Grants resitance to//
//	fire based on the player's ranks in 	//
//	Tumble.									//
//////////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void FlamesBlessing()
{	
	if (ValidateStance(12))
	{
		object oPC = OBJECT_SELF;
		float fDuration = 6.0f;

		DelayCommand(6.0f, FlamesBlessing());
		
		if ((GetSkillRank(SKILL_TUMBLE, oPC, TRUE) >= 4) && (GetSkillRank(SKILL_TUMBLE, oPC, TRUE) <= 8))
		{
			effect eFlmsBlss = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_FIRE, 5, 0));
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFlmsBlss, oPC, fDuration);
		}
		else if ((GetSkillRank(SKILL_TUMBLE, oPC, TRUE) >= 9) && (GetSkillRank(SKILL_TUMBLE, oPC, TRUE) <= 13))
		{
			effect eFlmsBlss = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_FIRE, 10, 0));
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFlmsBlss, oPC, fDuration);
		}
		else if ((GetSkillRank(SKILL_TUMBLE, oPC, TRUE) >= 14) && (GetSkillRank(SKILL_TUMBLE, oPC, TRUE) <= 18))
		{
			effect eFlmsBlss = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_FIRE, 20, 0));
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFlmsBlss, oPC, fDuration);
		}
		else if (GetSkillRank(SKILL_TUMBLE, oPC, TRUE) >= 19)
		{
			effect eFlmsBlss = SupernaturalEffect(EffectImmunity(DAMAGE_TYPE_FIRE));
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFlmsBlss, oPC, fDuration);
		}
		else return;
	}
}

void main()
{
	FlamesBlessing();
}