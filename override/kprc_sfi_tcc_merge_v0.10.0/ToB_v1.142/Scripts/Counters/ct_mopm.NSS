//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 2/9/2009							//
//	Title: ct_mopm							//
//	Description: Immeadiate Action; Makes a //
//	Concentration check instead of a will	//
//	save while active.  The goal here is to	//
//	reduce the PC's base will and bonuses by//
//	their current amount and then add a		//
//	bonus equal to the PC's concetration	//
//	skill.  In either event a d20 roll is	//
//	added.									//
//////////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void MomentOfPerfectMind()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	
	int nMyWill = GetWillSavingThrow(oPC);
	int nPM = GetSkillRank(SKILL_CONCENTRATION, oPC, FALSE);
	int nBonus = nPM - nMyWill;
	effect eWill;

	if (ValidateCounter(67))
	{
		if (nBonus >= 0)
		{
			eWill = EffectSavingThrowIncrease(SAVING_THROW_WILL, nBonus, SAVING_THROW_TYPE_ALL);
		}
		else eWill = EffectSavingThrowDecrease(SAVING_THROW_WILL, abs(nBonus), SAVING_THROW_TYPE_ALL);

		eWill = ExtraordinaryEffect(eWill);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWill, oPC, 0.99f);

		object oTest = IntToObject(GetLocalInt(oToB, "SaveTarget"));

		if ((GetLocalInt(oToB, "SaveType") == SAVING_THROW_WILL) && (oTest == oPC) && (GetLocalInt(oToB, "Swift") == 0))
		{
			SetLocalInt(oToB, "SaveType", 0);
			SetLocalInt(oToB, "SaveTarget", 0);
			FloatingTextStringOnCreature("<color=cyan>*Moment of Perfect Mind!*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
			RunSwiftAction(67, "C");
		}
		else DelayCommand(1.0f, MomentOfPerfectMind());
	}
}

void main()
{
	ExpendManeuver(67, "C");
	MomentOfPerfectMind();
}