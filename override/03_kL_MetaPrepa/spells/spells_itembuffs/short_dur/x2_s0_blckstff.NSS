//::///////////////////////////////////////////////
//:: Blackstaff
//:: 'x2_s0_blckstff'
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Adds +4 enhancement bonus, On Hit: Dispel.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 29, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 07, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:: 2003-07-15: Complete Rewrite to make use of Item Property System
//:: kevL's
//:: 2012 july 3
//:: - added code that allows Rod of Preparation to
//::   target offhand weapons & etc directly.
//:: - ApplyMetamagicDurationMods
//:: 2012 july 25
//:: - changed IPPolicy for ipEnhanc -> replace, false, false.
//:: 2016 sept 10
//:: - include 'mrop_items_inc'
//:: - tidy & refactor.


#include "x2_inc_spellhook"

#include "mrop_inc"			// GetMRoPTarget()
#include "mrop_items_inc"	// GetTargetWeapon()

#include "nwn2_inc_metmag"


void main()
{
/*	Spellcast Hook Code
	Added 2003-07-07 by Georg Zoeller
	If you want to make changes to all spells,
	check x2_inc_spellhook.nss to find out more */
	if (!X2PreSpellCastCode())
	{
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
		return;
	}
	// End of Spell Cast Hook


	// kL_RoP addition:
	int iSpellId = GetSpellId();
	object oTarget = GetSpellTargetObject();

	object oMyWeapon = GetMRoPTarget(iSpellId, oTarget);

	if (!GetIsObjectValid(oMyWeapon)) // kL_RoP end.
		oMyWeapon = GetTargetWeapon(WEAPTYPE_MEL);

	if (GetIsObjectValid(oMyWeapon))
	{
		object oPossessor = GetItemPossessor(oMyWeapon);
		if (GetIsObjectValid(oPossessor))
			SignalEvent(oPossessor, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));

		if (GetBaseItemType(oMyWeapon) == BASE_ITEM_QUARTERSTAFF)
		{
			float fDur = RoundsToSeconds(GetCasterLevel(OBJECT_SELF));
			fDur = ApplyMetamagicDurationMods(fDur);

			if (fDur > 0.f)
			{
				if (GetIsObjectValid(oPossessor))
				{
					effect eVis = EffectVisualEffect(VFX_DUR_SPELL_BLACKSTAFF);
					eVis = SupernaturalEffect(eVis);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPossessor, fDur);
				}

				itemproperty ipEnhanc = ItemPropertyEnhancementBonus(4);
				IPSafeAddItemProperty(oTarget, ipEnhanc, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

				itemproperty ipDispel = ItemPropertyOnHitProps(IP_CONST_ONHIT_DISPELMAGIC, IP_CONST_ONHIT_SAVEDC_16);
				IPSafeAddItemProperty(oTarget, ipDispel, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

				itemproperty ipVis = ItemPropertyVisualEffect(ITEM_VISUAL_EVIL);
				IPSafeAddItemProperty(oTarget, ipVis, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
			}
		}
		else
			FloatingTextStrRefOnCreature(83620, OBJECT_SELF); // "* Invalid Target - This spell must be cast on a quarterstaff *"
	}
	else
		FloatingTextStrRefOnCreature(83615, OBJECT_SELF); // "* Spell Failed - Target must be a melee weapon or creature with a melee weapon equipped *"
}
