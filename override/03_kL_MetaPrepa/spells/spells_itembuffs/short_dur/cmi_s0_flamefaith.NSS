//::///////////////////////////////////////////////
//:: Flame of Faith
//:: 'cmi_s0_flamefaith'
//:: Created By: Kaedrin (Matt)
//:: Created On: July 1, 2007
//:://////////////////////////////////////////////
//:: kevL's
//:: 2012 july 9
//:: - added code that allows Rod of Preparation to
//::   target offhand weapons & etc directly.
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

		float fDur = RoundsToSeconds(GetFighterCasterLevel());
		fDur = ApplyMetamagicDurationMods(fDur);

		if (fDur > 0.f)
		{
			if (GetIsObjectValid(oPossessor))
			{
				effect eVis = EffectVisualEffect(VFX_DUR_SPELL_BLESS_WEAPON); // find a vFx for this ...
				eVis = SupernaturalEffect(eVis);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPossessor, fDur);
			}

			itemproperty ipEnhanc = ItemPropertyEnhancementBonus(1);
			IPSafeAddItemProperty(oMyWeapon, ipEnhanc, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

			itemproperty ipFire = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6);
			IPSafeAddItemProperty(oMyWeapon, ipFire, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

			itemproperty ipCrit = ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_1d8);
			IPSafeAddItemProperty(oMyWeapon, ipCrit, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);

			itemproperty ipVis = ItemPropertyVisualEffect(ITEM_VISUAL_FIRE);
			IPSafeAddItemProperty(oMyWeapon, ipVis, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
		}
	}
	else
		FloatingTextStrRefOnCreature(83615, OBJECT_SELF); // "* Spell Failed - Target must be a melee weapon or creature with a melee weapon equipped *"
}


/*	int nCasterLvl = GetPalRngCasterLevel();
	float fDuration = RoundsToSeconds(nCasterLvl);
	fDuration = ApplyMetamagicDurationMods(fDuration);

	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_BLESS_WEAPON);
	object oMyWeapon = cmi_GetTargetedOrEquippedMeleeWeapon();

	if (GetIsObjectValid(oMyWeapon))
	{
		SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

		IPSafeAddItemProperty(oMyWeapon, ItemPropertyEnhancementBonus(1), fDuration,X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		IPSafeAddItemProperty(oMyWeapon, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_1d10), fDuration,X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		IPSafeAddItemProperty(oMyWeapon, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		IPSafeAddItemProperty(oMyWeapon, ItemPropertyVisualEffect(ITEM_VISUAL_FIRE), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, GetItemPossessor(oMyWeapon), fDuration);
	}
	else
	{
		FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
	} */
