//::///////////////////////////////////////////////
//:: Sonic Weapons
//:: 'cmi_s0_sonicwpn'
//:: Created By: Kaedrin (Matt)
//:: Created On: October 26, 2007
//:://////////////////////////////////////////////
//:: kevL's
//:: 2012 july 6
//:: - added code that allows Rod of Preparation to
//::   target offhand weapons & etc directly.
//:: - restructured code.
//:: 2012 july 11
//:: - moved varname cycling code out to a function in 'mrop_inc'
//:: 2016 sept 10
//:: - include 'mrop_items_inc'
//:: - tidy & refactor.

#include "x2_inc_spellhook"

#include "mrop_inc"			// GetMRoPTarget()
#include "mrop_items_inc"	// GetTargetWeapon()

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
		oMyWeapon = GetTargetWeapon(WEAPTYPE_ALL);

	if (GetIsObjectValid(oMyWeapon))
	{
		object oPossessor = GetItemPossessor(oMyWeapon);
		if (GetIsObjectValid(oPossessor))
			SignalEvent(oPossessor, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));

		float fDur = TurnsToSeconds(GetCasterLevel(OBJECT_SELF));
		fDur = ApplyMetamagicDurationMods(fDur);

		if (fDur > 0.f)
		{
			if (GetIsObjectValid(oPossessor))
			{
				effect eVis = EffectVisualEffect(VFX_DUR_SPELL_BLESS_WEAPON); // find a vFx for this ...
				eVis = SupernaturalEffect(eVis);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPossessor, fDur);
			}

			itemproperty ipDamBonus = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGEBONUS_1d6);
			IPSafeAddItemProperty(oMyWeapon, ipDamBonus, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
		}
	}
	else
		FloatingTextStrRefOnCreature(83615, OBJECT_SELF); // * Spell Failed - Target must be a melee weapon or creature with a melee weapon equipped *
}
