//::///////////////////////////////////////////////
//:: Weapon of the Deity
//:: 'cmi_s0_wpndeity'
//:: Created By: Kaedrin (Matt)
//:: Created On: July 1, 2007
//:://////////////////////////////////////////////
//:: 2/26/2011 - Changed Keep Existing to Replace
//:: kevL's
//:: 2012 july 9
//:: - added code that allows Rod of Preparation to
//::   target offhand weapons & etc directly.
//:: 2012 july 25
//:: - changed IPPolicy for ipEnhance & ipKeen -> replace, false, false.
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

		float fDur;
		int iCL = GetFighterCasterLevel();
		switch (GetLastSpellCastClass())
		{
			case CLASS_TYPE_PALADIN:
				fDur = TurnsToSeconds(iCL);
				break;
			default:
				fDur = RoundsToSeconds(iCL);
		}
		fDur = ApplyMetamagicDurationMods(fDur);

		if (fDur > 0.f)
		{
			if (GetIsObjectValid(oPossessor))
			{
				effect eVis = EffectVisualEffect(VFX_DUR_SPELL_BLESS_WEAPON);
				eVis = SupernaturalEffect(eVis);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPossessor, fDur);
			}

			int iEnhanc = iCL / 3 - 1;
			if		(iEnhanc < 1) iEnhanc = 1;
			else if	(iEnhanc > 5) iEnhanc = 5;

			itemproperty ipEnhanc = ItemPropertyEnhancementBonus(iEnhanc);
			IPSafeAddItemProperty(oMyWeapon, ipEnhanc, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

			itemproperty ipKeen = ItemPropertyKeen();
			IPSafeAddItemProperty(oMyWeapon, ipKeen, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
		}
	}
	else
		FloatingTextStrRefOnCreature(83615, OBJECT_SELF); // "* Spell Failed - Target must be a melee weapon or creature with a melee weapon equipped *"
}


/*	int nCasterLvl = GetPalRngCasterLevel();
	float fDuration;

	if (GetLastSpellCastClass() == CLASS_TYPE_PALADIN)
		fDuration = TurnsToSeconds(nCasterLvl);
	else
		fDuration = RoundsToSeconds(nCasterLvl);

	fDuration = ApplyMetamagicDurationMods(fDuration);

	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_BLESS_WEAPON);
	object oMyWeapon = cmi_GetTargetedOrEquippedMeleeWeapon();

	int nEnhanceBonus = (nCasterLvl / 3) - 1;
	if (nEnhanceBonus > 5)
	{
		nEnhanceBonus = 5;
	}
	else if (nEnhanceBonus < 1)
	{
		nEnhanceBonus = 1;
	}

	if(GetIsObjectValid(oMyWeapon))
	{
		SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, GetItemPossessor(oMyWeapon), fDuration);

		IPSafeAddItemProperty(oMyWeapon, ItemPropertyKeen(), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
		IPSafeAddItemProperty(oMyWeapon, ItemPropertyEnhancementBonus(nEnhanceBonus), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
	}
	else
	{
		FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
	} */
