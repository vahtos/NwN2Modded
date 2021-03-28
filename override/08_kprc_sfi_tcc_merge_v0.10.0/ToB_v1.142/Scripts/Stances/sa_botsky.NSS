//////////////////////////////////////////////////////
//  Author: Drammel									//
//  Date: 10/28/2009								//
//  Title: sa_botsky								//
//  Description: You gain immunity to entanglement  //
//  and from the effects of traps. You must keep at //
//  least one hand empty while using this stance.   //
//////////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void BalanceOnTheSky()
{
	if (ValidateStance(117))
	{
		object oPC = OBJECT_SELF;
		object oOffHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

		if (!GetIsObjectValid(oOffHand))
		{
			effect eEntangle = EffectImmunity(IMMUNITY_TYPE_ENTANGLE);
			effect eTraps = EffectImmunity(IMMUNITY_TYPE_TRAP);
			effect eBalance = EffectLinkEffects(eEntangle, eTraps);
			eBalance = SupernaturalEffect(eBalance);

			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBalance, oPC, 6.0f);
		}

		DelayCommand(6.0f, BalanceOnTheSky());
	}
}


void main()
{
	BalanceOnTheSky();
}