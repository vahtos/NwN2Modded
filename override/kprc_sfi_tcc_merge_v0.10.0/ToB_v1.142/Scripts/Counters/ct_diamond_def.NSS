//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 10/27/2009						//
//	Title: ct_diamond_def					//
//	Description: You can initiate this      //
//  maneuver any time before you would be   //
//  required to make a saving throw. You    //
//  gain a bonus on that save equal to your //
//  initiator level. You use this maneuver  //
//  before you roll the saving throw.       //
//////////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void DiamondDefense()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	
	int nBonus = GetInitiatorLevel(oPC);

	if (ValidateCounter(57))
	{
		effect eBonus = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus);
		eBonus = ExtraordinaryEffect(eBonus);

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oPC, 0.99f);

		object oTest = IntToObject(GetLocalInt(oToB, "SaveTarget"));

		if ((oTest == oPC) && (GetLocalInt(oToB, "SaveType") == SAVING_THROW_ALL) && (GetLocalInt(oToB, "Swift") == 0))
		{
			SetLocalInt(oToB, "SaveType", 0);
			SetLocalInt(oToB, "SaveTarget", 0);
			FloatingTextStringOnCreature("<color=cyan>*Diamond Defense!*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
			RunSwiftAction(57, "C");
		}
		else DelayCommand(1.0f, DiamondDefense());
	}
}

void main()
{
	ExpendManeuver(57, "C");
	DiamondDefense();
}