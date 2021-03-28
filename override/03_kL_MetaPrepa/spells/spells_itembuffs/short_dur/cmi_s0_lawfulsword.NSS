//::///////////////////////////////////////////////
//:: Lawful Sword
//:: 'cmi_s0_lawfulsword'
//:: Created By: Kaedrin (Matt)
//:: Created On: June 28, 2007
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

		float fDur = RoundsToSeconds(GetFighterCasterLevel());
		fDur = ApplyMetamagicDurationMods(fDur);

		if (fDur > 0.f)
		{
			if (GetIsObjectValid(oPossessor))
			{
				effect eVis1 = EffectVisualEffect(VFX_DUR_SPELL_HOLY_SWORD);
				eVis1 = SupernaturalEffect(eVis1);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis1, oPossessor, fDur);

				location lLoc = GetLocation(oPossessor);
				TLVFXPillar(VFX_IMP_GOOD_HELP, lLoc, 4, 0.f, 6.f);

				effect eVis2 = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
				DelayCommand(0.75f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis2, lLoc));
			}

			itemproperty ipChaos1 = ItemPropertyEnhancementBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, 5);
			IPSafeAddItemProperty(oMyWeapon, ipChaos1, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

			itemproperty ipChaos2 = ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_2d6);
			IPSafeAddItemProperty(oMyWeapon, ipChaos2, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

			itemproperty ipVis = ItemPropertyVisualEffect(ITEM_VISUAL_HOLY);
			IPSafeAddItemProperty(oMyWeapon, ipVis, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
		}
	}
	else
		FloatingTextStrRefOnCreature(83615, OBJECT_SELF); // "* Spell Failed - Target must be a melee weapon or creature with a melee weapon equipped *"
}


/*	int nCasterLvl = GetPalRngCasterLevel();
	float fDuration = RoundsToSeconds( nCasterLvl );
	fDuration = ApplyMetamagicDurationMods(fDuration);

	object oMyWeapon = cmi_GetTargetedOrEquippedMeleeWeapon();

	if(GetIsObjectValid(oMyWeapon) )
	{
		SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

		effect eVis = EffectVisualEffect(VFX_DUR_SPELL_HOLY_SWORD);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, OBJECT_SELF, fDuration);

		IPSafeAddItemProperty(oMyWeapon,ItemPropertyEnhancementBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC,5), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		IPSafeAddItemProperty(oMyWeapon,ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_2d6), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		IPSafeAddItemProperty(oMyWeapon, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE );//Make the sword glow

		TLVFXPillar(VFX_IMP_GOOD_HELP, GetLocation(GetSpellTargetObject()), 4, 0.0f, 6.0f);
		DelayCommand(1.0f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_SUNSTRIKE ),GetLocation(GetSpellTargetObject())));
	}
		else
	{
		FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
	} */
