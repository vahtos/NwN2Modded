//::///////////////////////////////////////////////
//:: Shield of Warding
//:: 'cmi_s0_shldward'
//:: Created By: Kaedrin (Matt)
//:: Created On: July 5, 2007
//:://////////////////////////////////////////////
//:: kevL's
//:: 2012 july 8
//:: - added code that allows Rod of Preparation to
//::   target shields directly.
//:: 2012 july 11
//:: - moved varname cycling code out to a function in 'mrop_inc'
//:: 2016 sept 10
//:: - include 'mrop_items_inc'
//:: - tidy & refactor.


// issue: This should stack with vs Align, vs Damage, vs Racial, and vs
// Specific_Align as well; need to redo the GetAC to account for it, wrapping
// it as a new function in the cmi_ginc_spells -
// StackShieldBonus(object oShield, int nBonus) that checks all Item_Props.


#include "x2_inc_spellhook"

#include "mrop_inc"			// GetMRoPTarget()
#include "mrop_items_inc"	// GetFighterCasterLevel(), GetTargetShield()

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

	object oMyShield = GetMRoPTarget(iSpellId, oTarget);

	if (!GetIsObjectValid(oMyShield)) // kL_RoP end.
		oMyShield = GetTargetShield();

	if (GetIsObjectValid(oMyShield))
	{
		object oPossessor = GetItemPossessor(oMyShield);
		if (GetIsObjectValid(oPossessor))
			SignalEvent(oPossessor, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));

		int iCL = GetFighterCasterLevel();
		float fDur = TurnsToSeconds(iCL);
		fDur = ApplyMetamagicDurationMods(fDur);

		if (fDur > 0.f)
		{
			if (GetIsObjectValid(oPossessor))
			{
				effect eVis = EffectVisualEffect(VFX_DUR_SPELL_BLESS_WEAPON); // find a vFx for this ...
				eVis = SupernaturalEffect(eVis);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPossessor, fDur);
			}

			int iReflex = iCL / 5 + 1;
			if (iReflex > 5) iReflex = 5;

			// If the caster is a Cleric only a +1 AC enhancement gets added (plus any existing shield enhancement).
			// If the caster is a Paladin the full AC enhancement gets added (plus any existing shield enhancement).
			// Note that the Reflex saving-throw bonus stays the same for both caster classes.
			int iEnhanc = iReflex;
			int iEnhancPre = IPGetWeaponEnhancementBonus(oMyShield, ITEM_PROPERTY_AC_BONUS);
			switch (GetLastSpellCastClass())
			{
				default:
				case CLASS_TYPE_CLERIC: // todo: should check for additional kPrC classes
					iEnhanc = iEnhancPre + 1;
					break;

				case CLASS_TYPE_PALADIN:
					iEnhanc += iEnhancPre;
			}

			itemproperty ipAC = ItemPropertyACBonus(iEnhanc);
			IPSafeAddItemProperty(oMyShield, ipAC, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

			itemproperty ipReflex = ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_REFLEX, iReflex);
			IPSafeAddItemProperty(oMyShield, ipReflex, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
		}
	}
	else
		FloatingTextStringOnCreature("* Spell Failed ! Target must be a shield or creature with a shield equipped *", OBJECT_SELF);
}


/*	int nSpellID = SPELL_Shield_Warding;
	int nCasterLvl = GetPalRngCasterLevel();
	float fDuration = TurnsToSeconds(nCasterLvl);
	fDuration = ApplyMetamagicDurationMods(fDuration);

	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_BLESS_WEAPON);
	eVis = SetEffectSpellId(eVis, nSpellID);
	eVis = SupernaturalEffect(eVis);

	object oShield = IPGetTargetedOrEquippedShield();
	object oHolder = GetItemPossessor(oShield);

	if (GetHasSpellEffect(nSpellID, oHolder))
	{
		SendMessageToPC(OBJECT_SELF, "Shield of Warding is already active on the target. Wait for the spell to expire.");
	}

	int iEnhancement = 1 + (nCasterLvl/5);
	if (iEnhancement > 5)
		iEnhancement = 5;

	int iReflex = iEnhancement;

	if (GetIsObjectValid(oShield))
	{
		SignalEvent(oShield, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

		int iCurrent = IPGetWeaponEnhancementBonus(oShield,ITEM_PROPERTY_AC_BONUS);
		if (GetLastSpellCastClass() == 6)
			iEnhancement = iEnhancement + iCurrent;
		else
			iEnhancement = iCurrent++;

		IPSafeAddItemProperty(oShield, ItemPropertyACBonus(iEnhancement), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
		IPSafeAddItemProperty(oShield, ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_REFLEX, iReflex), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oHolder, fDuration);
	}
	else
	{
		FloatingTextStringOnCreature("*Spell Failed: Target must be a shield or creature with a shield equipped.*", OBJECT_SELF);
	} */
