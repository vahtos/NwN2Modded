//::///////////////////////////////////////////////
//:: Flamebound Weapon
//:: 'cmi_s0_flmbndwpn'
//:: Created By: Kaedrin (Matt)
//:: Created On: July 1, 2007
//:://////////////////////////////////////////////
//:: kevL's
//:: 2012 july 10
//:: - added code that allows Rod of Preparation to
//::   target offhand weapons & etc directly.
//:: 2012 july 11
//:: - moved varname cycling code out to a function in 'mrop_inc'
//:: 2016 sept 10
//:: - include 'mrop_items_inc'
//:: - tidy & refactor.


#include "x2_inc_spellhook"

#include "mrop_inc"			// GetMRoPTarget()
#include "mrop_items_inc"	// GetFighterCasterLevel(), GetTargetWeapon()

#include "nwn2_inc_metmag"


void main()
{
	if (!X2PreSpellCastCode())
	{
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
		return;
	}


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

		float fDur = TurnsToSeconds(GetFighterCasterLevel());
		fDur = ApplyMetamagicDurationMods(fDur);

		if (fDur > 0.f)
		{
			if (GetIsObjectValid(oPossessor))
			{
				effect eVis = EffectVisualEffect(VFX_DUR_SPELL_BLESS_WEAPON); // find a vFx for this ...
				eVis = SupernaturalEffect(eVis);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPossessor, fDur);
			}

			itemproperty ipDivine = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_1d6);
			IPSafeAddItemProperty(oMyWeapon, ipDivine, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

			itemproperty ipVis = ItemPropertyVisualEffect(ITEM_VISUAL_HOLY);
			IPSafeAddItemProperty(oMyWeapon, ipVis, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
		}
	}
	else
		FloatingTextStrRefOnCreature(83615, OBJECT_SELF); // * Spell Failed - Target must be a melee weapon or creature with a melee weapon equipped *
}


/*	object oMyWeapon = cmi_GetTargetedOrEquippedMeleeWeapon();
	if (GetIsObjectValid(oMyWeapon))
	{
		SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

		int nCasterLvl	= GetPalRngCasterLevel();
		float fDuration = TurnsToSeconds(nCasterLvl);
		fDuration		= ApplyMetamagicDurationMods(fDuration);

		effect eVis = EffectVisualEffect(VFX_DUR_SPELL_BLESS_WEAPON);
		IPSafeAddItemProperty(oMyWeapon, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_1d6), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		IPSafeAddItemProperty(oMyWeapon, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, TRUE);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, OBJECT_SELF, fDuration);
	}
	else
	{
		FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
	} */
