//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 7/14/2009							//
//	Title: ct_action_before					//
//	Description: Immeadiate Action; Makes a //
//	Concentration check instead of a reflex	//
//	save while active.  The goal here is to	//
//	reduce the PC's base reflex bonuses by	//
//	their current amount and then add a		//
//	bonus equal to the PC's concetration	//
//	skill.  In either event a d20 roll is	//
//	added.									//
//////////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void ActionBeforeThought()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	
	int nMyReflex = GetReflexSavingThrow(oPC);
	int nABT = GetSkillRank(SKILL_CONCENTRATION, oPC, FALSE);
	int nBonus = nABT - nMyReflex;
	effect eReflex;

	if (ValidateCounter(54))
	{
		if (nBonus >= 0)
		{
			eReflex = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nBonus, SAVING_THROW_TYPE_ALL);
		}
		else eReflex = EffectSavingThrowDecrease(SAVING_THROW_REFLEX, abs(nBonus), SAVING_THROW_TYPE_ALL);

		eReflex = ExtraordinaryEffect(eReflex);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eReflex, oPC, 0.99f);

		object oTest = IntToObject(GetLocalInt(oToB, "SaveTarget"));

		if ((GetLocalInt(oToB, "SaveType") == SAVING_THROW_REFLEX) && (oTest == oPC) && (GetLocalInt(oToB, "Swift") == 0))
		{
			SetLocalInt(oToB, "SaveType", 0);
			SetLocalInt(oToB, "SaveTarget", 0);
			FloatingTextStringOnCreature("<color=cyan>*Action Before Thought!*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
			RunSwiftAction(54, "C");
		}
		else DelayCommand(1.0f, ActionBeforeThought());
	}
}

void main()
{
	ExpendManeuver(54, "C");
	ActionBeforeThought();
}