//////////////////////////////////////////////////
//  Author: Drammel								//
//  Date: 9/20/2009								//
//  Title: sa_step_moth 						//
//  Description: While you are in this stance,  //
//  your speed drops to one third of its normal //
//  value and you gain a +2 bonus to dexterity. //
//  After you end this stance, if you are       //
//  equipped with a Shadow Hand weapon, for one //
//  round your speed drops to two thirds of its //
//  normal value and you gain a +8 bonus to     //
//  dexterity.                                  //
//////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_inc_variables"

void StepOfTheDancingMoth()
{
	if (ValidateStance(139))
	{
		object oPC = OBJECT_SELF;
		effect eSlow = EffectMovementSpeedDecrease(33);
		effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, 2);
		effect eDancingMoth = EffectLinkEffects(eSlow, eDex);
		eDancingMoth = ExtraordinaryEffect(eDancingMoth);
		eDancingMoth = SetEffectSpellId(eDancingMoth, 6553);

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDancingMoth, oPC, 5.99f);
		SetLocalInt(oPC, "DancingMoth", 1);
		DelayCommand(5.99f, DeleteLocalInt(oPC, "DancingMoth"));
		DelayCommand(6.0f, StepOfTheDancingMoth());
	}
	else if (GetIsShadowHandWeapon(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)))
	{
		object oPC = OBJECT_SELF;
		effect eSlow = EffectMovementSpeedDecrease(67);
		effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, 8);
		effect eDancingMoth = EffectLinkEffects(eSlow, eDex);
		eDancingMoth = ExtraordinaryEffect(eDancingMoth);
		eDancingMoth = SetEffectSpellId(eDancingMoth, 6553);

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDancingMoth, oPC, 6.0f);
	}
}

void main()
{
	object oPC = OBJECT_SELF;

	if (GetLocalInt(oPC, "DancingMoth") == 0)
	{
		StepOfTheDancingMoth();
	}
	else SendMessageToPC(oPC, "<color=red>You must wait until next round before you can initiate Step of the Dancing Moth again.</color>");
}