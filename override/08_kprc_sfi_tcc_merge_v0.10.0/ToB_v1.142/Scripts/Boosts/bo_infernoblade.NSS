//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 10/15/2009						//
//	Title: bo_infernoblade					//
//	Description: Swift Action; Adds 3d6+1	//
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
		int nNumber = d6(3) + GetInitiatorLevel(oPC);
		int nDamage = GetConstDamageBonusFromNumber(nNumber); //Caps at 40 which isn't a problem until epic levels.
	
		if (GetIsObjectValid(oMyWeapon))
		{
		//	itemproperty ipFire = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, nDamage);
			itemproperty ipVis = ItemPropertyVisualEffect(ITEM_VISUAL_FIRE);
			IPSafeAddItemProperty(oMyWeapon, ipVis, 6.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
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
			RunSwiftAction(16, "B");
			ExpendManeuver(16, "B");
		}
		else SendMessageToPC(oPC, "<color=red>You must have a weapon equipped.</color>");
	}
}