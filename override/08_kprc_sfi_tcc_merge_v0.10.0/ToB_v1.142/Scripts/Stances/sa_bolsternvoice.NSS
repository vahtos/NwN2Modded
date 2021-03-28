//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 6/19/2009							//
//	Title: sa_bolsternvoice					//
//	Description: Stance; Grants allies +2 vs//
//	will saves and +4 vs fear effects.		//
//////////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void BolsteringVoice()
{
	if (ValidateStance(189))
	{
		object oPC = OBJECT_SELF;
		float fRange = FeetToMeters(60.0f);
		location lPC = GetLocation(oPC);
		object oFriend;

		oFriend = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);

		while (GetIsObjectValid(oFriend))
		{
			if ((!GetIsReactionTypeHostile(oFriend, oPC)) && (oFriend != oPC) && (GetObjectHeard(oPC, oFriend)))
			{
				effect eWill = EffectSavingThrowIncrease(SAVING_THROW_WILL, 2);
				effect eFear = EffectSavingThrowIncrease(SAVING_THROW_WILL, 4, SAVING_THROW_TYPE_FEAR);
				effect eBolster = EffectLinkEffects(eWill, eFear);
				eBolster = ExtraordinaryEffect(eBolster);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBolster, oFriend, 6.0f);
			}
			oFriend = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);
		}
		DelayCommand(6.0f, BolsteringVoice());
	}
}

void main()
{
	BolsteringVoice();
}