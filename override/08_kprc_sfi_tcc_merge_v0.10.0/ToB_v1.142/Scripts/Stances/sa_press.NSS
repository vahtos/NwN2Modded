//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 9/20/2009								//
//	Title: sa_press								//
//	Description: While you are in this stance,  //
//  as your foe becomes weaker you are able to  //
//  chase him down more quickly.  When your foe //
//  drops below 75% of his maximum hit point    //
//  value, you gain a movement speed bonus of an//
//  extra five feet per round.  When his health //
//  dips below half its total value your speed  //
//  bonus increases to ten feet per round.  At  //
//  25% of his total health your bonus increases//
//  to fifteen feet per round.					//
//////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_inc_variables"

void PressTheAdvantage()
{	
	if (ValidateStance(198))
	{
		object oPC = OBJECT_SELF;
		object oFoe = GetAttemptedAttackTarget();

		if (GetIsObjectValid(oFoe))
		{
			int nHp = GetPercentHP(oFoe);
	
			if (nHp <= 25)
			{
				effect ePress = EffectMovementSpeedIncrease(50);
				ePress = ExtraordinaryEffect(ePress);
				ePress = SetEffectSpellId(ePress, -1);

				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePress, oPC, 1.0f);
			}
			else if (nHp <= 50)
			{
				effect ePress = EffectMovementSpeedIncrease(33);
				ePress = ExtraordinaryEffect(ePress);
				ePress = SetEffectSpellId(ePress, -1);

				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePress, oPC, 1.0f);
			}
			else if (nHp <= 75)
			{
				effect ePress = EffectMovementSpeedIncrease(17);
				ePress = ExtraordinaryEffect(ePress);
				ePress = SetEffectSpellId(ePress, -1);

				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePress, oPC, 1.0f);
			}
		}

		DelayCommand(1.0f, PressTheAdvantage());
	}
}

void main()
{
	PressTheAdvantage();
}