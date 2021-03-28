//::///////////////////////////////////////////////
//:: Undead Bane Weapon
//:: 'cmi_s0_undbanewpn'
//:: Created By: Kaedrin (Matt)
//:: Created On: July 7, 2007
//:: Based on X2_S0_HolySwrd
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
#include "x2_inc_toollib"	// TLVFXPillar()


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

		float fDur = HoursToSeconds(GetFighterCasterLevel());
		fDur = ApplyMetamagicDurationMods(fDur);

		if (fDur > 0.f)
		{
			if (GetIsObjectValid(oPossessor))
			{
				effect eVis = EffectVisualEffect(VFX_DUR_SPELL_HOLY_SWORD);
				eVis = SupernaturalEffect(eVis);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPossessor, fDur);

				location lLoc = GetLocation(oPossessor);
				TLVFXPillar(VFX_IMP_GOOD_HELP, lLoc, 4, 0.f, 6.f);
				effect eVisSun = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
				DelayCommand(0.75f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVisSun, lLoc));
			}

			int iEnhancement = IPGetWeaponEnhancementBonus(oMyWeapon) + 2;
			itemproperty ipEnhRace = ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, iEnhancement);
			IPSafeAddItemProperty(oMyWeapon, ipEnhRace, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

			itemproperty ipDamRace = ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_2d4);
			IPSafeAddItemProperty(oMyWeapon, ipDamRace, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

			itemproperty ipVis = ItemPropertyVisualEffect(ITEM_VISUAL_HOLY); // Make the sword glow for K2 light emitter vFx.
			IPSafeAddItemProperty(oMyWeapon, ipVis, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
		}
	}
	else
		FloatingTextStrRefOnCreature(83615, OBJECT_SELF); // * Spell Failed - Target must be a melee weapon or creature with a melee weapon equipped *
}


/*	int nCasterLvl = GetPalRngCasterLevel();
	float fDuration = HoursToSeconds( nCasterLvl );
	fDuration = ApplyMetamagicDurationMods(fDuration);

	object oMyWeapon = cmi_GetTargetedOrEquippedMeleeWeapon();

	if (GetIsObjectValid(oMyWeapon))
	{
		//SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

		effect eVis = EffectVisualEffect(VFX_DUR_SPELL_HOLY_SWORD);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, OBJECT_SELF, fDuration);

		int iEnhancement = IPGetWeaponEnhancementBonus(oMyWeapon);
		iEnhancement = iEnhancement + 2;

		IPSafeAddItemProperty(oMyWeapon, ItemPropertyEnhancementBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, iEnhancement), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
		IPSafeAddItemProperty(oMyWeapon, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_2d6), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
		IPSafeAddItemProperty(oMyWeapon, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);	//Make the sword glow

		TLVFXPillar(VFX_IMP_GOOD_HELP, GetLocation(GetSpellTargetObject()), 4, 0.f, 6.f);
		DelayCommand(1.f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_SUNSTRIKE ), GetLocation(GetSpellTargetObject())));
	}
	else
	{
		FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
	} */
