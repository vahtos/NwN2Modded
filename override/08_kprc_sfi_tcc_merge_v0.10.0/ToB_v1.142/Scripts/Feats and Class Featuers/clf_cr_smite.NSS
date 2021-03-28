////////////////////////////////////////////////////////////
//	Author: Drammel										  //
//	Date: 5/15/2009										  //
//	Name: clf_cr_smite									  //
//	Description: Allows the player to make an attack 	  //
//	which is increased by the player's CHA modifier to	  //
//	hit and by the player's levels in Crusader for damage.//
////////////////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oFoe = GetSpellTargetObject();
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nUses = GetLocalInt(oToB, "SmiteUses");

	if (nUses > 0)
	{
		int nCha = GetAbilityModifier(ABILITY_CHARISMA, oPC);
		int nLevel = GetLevelByClass(CLASS_TYPE_CRUSADER, oPC);
		int nCHA;

		if (GetAbilityModifier(ABILITY_CHARISMA, oPC) > 0)
		{
			nCHA = nCha;
		}
		else nCHA = 0;

		if (GetHasFeat(FEAT_EPIC_GREAT_SMITING_10, oPC))
		{
			nLevel += (nLevel * 10);
		}
		else if (GetHasFeat(FEAT_EPIC_GREAT_SMITING_9, oPC))
		{
			nLevel += (nLevel * 9);
		}
		else if (GetHasFeat(FEAT_EPIC_GREAT_SMITING_8, oPC))
		{
			nLevel += (nLevel * 8);
		}
		else if (GetHasFeat(FEAT_EPIC_GREAT_SMITING_7, oPC))
		{
			nLevel += (nLevel * 7);
		}
		else if (GetHasFeat(FEAT_EPIC_GREAT_SMITING_6, oPC))
		{
			nLevel += (nLevel * 6);
		}
		else if (GetHasFeat(FEAT_EPIC_GREAT_SMITING_5, oPC))
		{
			nLevel += (nLevel * 5);
		}
		else if (GetHasFeat(FEAT_EPIC_GREAT_SMITING_4, oPC))
		{
			nLevel += (nLevel * 4);
		}
		else if (GetHasFeat(FEAT_EPIC_GREAT_SMITING_3, oPC))
		{
			nLevel += (nLevel * 3);
		}
		else if (GetHasFeat(FEAT_EPIC_GREAT_SMITING_2, oPC))
		{
			nLevel += (nLevel * 2);
		}
		else if (GetHasFeat(FEAT_EPIC_GREAT_SMITING_1, oPC))
		{
			nLevel += nLevel;
		}

		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		int nRoll = StrikeAttackRoll(oWeapon, oFoe, nCHA);

		StrikeAttackSound(oWeapon, oFoe, nRoll, 0.2f);
		BasicAttackAnimation(oWeapon, nRoll); 
		DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nRoll, oFoe, nLevel));
		SetLocalInt(oToB, "SmiteUses", (nUses - 1));
	}
	else SendMessageToPC(oPC, "<color=red>You do not have any remaining uses of Smite left</color>");
}