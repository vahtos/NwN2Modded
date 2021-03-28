//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 2/8/2009							//
//	Title: sa_stncoclr						//
//	Description: Stance; +2 to AC vs one foe//
//	and -2 AC vs all others.				//
//////////////////////////////////////////////

#include "tob_x0_i0_enemy"
#include "bot9s_inc_maneuvers"

void StanceOfClarity(object oPC, object oToB)
{	
	if (ValidateStance(74))
	{
		object oTarget = IntToObject(GetLocalInt(oToB, "StanceOfClarity"));
		effect eACPlus = ExtraordinaryEffect(EffectACIncrease(2));
		effect eACMinus = ExtraordinaryEffect(EffectACDecrease(2));
		
		if (GetNearestEnemy(oPC, 1) == oTarget)
		{
			RemoveEffect(oPC, eACMinus);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eACPlus, oPC, 1.0f);
		}
		else ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eACMinus, oPC, 1.0f);

		DelayCommand(1.0f, StanceOfClarity(oPC, oToB));
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nTarget = GetLocalInt(oToB, "Target");
	object oTarget = IntToObject(nTarget);
	
	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "StanceOfClarity", nTarget);		
	StanceOfClarity(oPC, oToB);
}