//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 1/16/2009							//
//	Title: bo_burningblade					//
//	Description: Swift Action; Adds 1d6+1	//
//	per iniator level fire damage for one	//
//	round.									//
//////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_variables"
#include "bot9s_inc_maneuvers"
#include "tob_i0_spells"
#include "tob_x2_inc_itemprop"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	
	if (GetLocalInt(oToB, "Swift") == 0)
	{
		object oMyWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		float fDuration = 6.0f;
		int nNumber = d6(1) + GetInitiatorLevel(oPC);
		int nDamage = GetConstDamageBonusFromNumber(nNumber);
	
		if (GetIsObjectValid(oMyWeapon))
		{
		//	itemproperty ipFire = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, nDamage);
			itemproperty ipVis = ItemPropertyVisualEffect(ITEM_VISUAL_FIRE);
			IPSafeAddItemProperty(oMyWeapon, ipVis, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
		//	IPSafeAddItemProperty(oMyWeapon, ipFire, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
		//  Removed due to a weird bug that ocurred when the PC died that prevented the removal of the damage property.
			effect eFire = EffectDamageIncrease(nDamage, DAMAGE_TYPE_FIRE);
			eFire = SupernaturalEffect(eFire);
			eFire = SetEffectSpellId(eFire, 6541); // spells 2da placeholder for boosts

			int nCheck = GetHasSpellEffect(6541, oPC);

			if (nCheck == TRUE)
			{
				RemoveEffectsFromSpell(oPC, 6541);
			}

			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFire, oPC, 6.0f);
			RunSwiftAction(2, "B");
			ExpendManeuver(2, "B");
		}
		else SendMessageToPC(oPC, "<color=red>You must have a weapon equipped.</color>");
	}
}