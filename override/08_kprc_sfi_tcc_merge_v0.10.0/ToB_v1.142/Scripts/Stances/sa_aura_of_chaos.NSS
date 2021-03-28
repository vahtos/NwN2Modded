//////////////////////////////////////////////////
//  Author: Drammel								//
//  Date: 10/8/2009								//
//  Title: sa_aura_of_chaos						//
//  Description: When rolling damage for a melee//
//  attack, you gain a special benefit from any //
//  damage die that rolls its maximum amount    //
//  (such as a result of 6 on a d6). When one or//
//  more of your damage dice show a maximum     //
//  possible result, reroll each such die and   //
//  add its result to the original damage total.//
//  You can continue to reroll as long as a die //
//  shows its maximum possible result, adding   //
//  each new number to the damage total until   //
//  each die has shown less than a maximum      //
//  result.		                            	//
//////////////////////////////////////////////////

	/* Most of the work of this function is handled in bot9s_inc_variables
	under the functions GetDamageByDice, GetDamageByDamageBonus, and
	GetDamageByIPConstDamageBonus.  This script only sets the combat override
	state on the player, which allows the damage bonus to occur.*/

#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"
#include "bot9s_combat_overrides"

void AuraOfChaos()
{
	object oPC = OBJECT_SELF;

	if (ValidateStance(28))
	{
		SetLocalInt(oPC, "AuraOfChaos", 1); // Status check to prevent extra callbacks of this function from running.

		if (GetLocalInt(oPC, "bot9s_overridestate") > 0)
		{
			//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
			//2 = Combat round is pending and the command has already been sent, do nothing.
		}
		else ManageCombatOverrides(TRUE);

		DelayCommand(6.0f, AuraOfChaos());
	}
	else
	{
		DeleteLocalInt(oPC, "AuraOfChaos");
		ProtectedClearCombatOverrides(oPC);
	}
}

void main()
{
	object oPC = OBJECT_SELF;

	if (GetLocalInt(oPC, "AuraOfChaos") == 0)
	{
		effect eChaos = EffectVisualEffect(VFX_TOB_AURA_CHAOS);

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eChaos, oPC, 6.0f);
		AuraOfChaos();
	}
}