//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 8/25/2009							//
//	Title: ct_mind_over						//
//	Description: Immeadiate Action; Makes a //
//	Concentration check instead of a Fort	//
//	save while active.  The goal here is to	//
//	reduce the PC's base Fort bonuses by	//
//	their current amount and then add a		//
//	bonus equal to the PC's concetration	//
//	skill.  In either event a d20 roll is	//
//	added.									//
//////////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void MindOverBody()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	
	int nMyFort = GetFortitudeSavingThrow(oPC);
	int nMOB = GetSkillRank(SKILL_CONCENTRATION, oPC, FALSE);
	int nBonus = nMOB - nMyFort;
	effect eFort;

	if (ValidateCounter(64))
	{
		if (nBonus >= 0)
		{
			eFort = EffectSavingThrowIncrease(SAVING_THROW_FORT, nBonus, SAVING_THROW_TYPE_ALL);
		}
		else eFort = EffectSavingThrowDecrease(SAVING_THROW_FORT, abs(nBonus), SAVING_THROW_TYPE_ALL);

		eFort = ExtraordinaryEffect(eFort);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFort, oPC, 0.99f);

		object oTest = IntToObject(GetLocalInt(oToB, "SaveTarget"));

		if ((GetLocalInt(oToB, "SaveType") == SAVING_THROW_FORT) && (oTest == oPC) && (GetLocalInt(oToB, "Swift") == 0))
		{
			SetLocalInt(oToB, "SaveType", 0);
			SetLocalInt(oToB, "SaveTarget", 0);
			FloatingTextStringOnCreature("<color=cyan>*Action Before Thought!*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
			RunSwiftAction(64, "C");
		}
		else DelayCommand(1.0f, MindOverBody());
	}
}

void main()
{
	ExpendManeuver(64, "C");
	MindOverBody();
}