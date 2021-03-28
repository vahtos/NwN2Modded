//::///////////////////////////////////////////////
//:: Energy Weapon
//:: 'cmi_s0_energywpn'
//:: Created By: Kaedrin (Matt)
//:: Created On: October 25, 2007
//:://////////////////////////////////////////////
//:: kevL's
//:: 2012 july 3
//:: - added code that allows Rod of Preparation to
//::   target offhand weapons & etc directly.
//:: - changed the code to work as described in Dialog.Tlk ...
//::   ie, the shield *must be equipped* if using my personal
//::   'cmi_player_equip' & 'cmi_player_unequip' scripts
//:: - the code for that is commented for distribution.
//:: 2016 sept 10
//:: - include 'mrop_items_inc'
//:: - tidy & refactor.


#include "x2_inc_spellhook"

#include "mrop_inc"			// GetMRoPTarget()
#include "mrop_items_inc"	// GetTargetWeapon()

#include "nwn2_inc_metmag"


// ___________
// ** MAIN ***
// -----------
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

		float fDur = RoundsToSeconds(GetCasterLevel(OBJECT_SELF));
		fDur = ApplyMetamagicDurationMods(fDur);

		if (fDur > 0.f)
		{
			if (GetIsObjectValid(oPossessor))
			{
				// NOTE: This does not remove itemproperty from the weapon itself.
				if (GetHasSpellEffect(SPELL_Weapon_Energy, oPossessor))
				{
					effect eEffect = GetFirstEffect(oPossessor);
					while (GetIsEffectValid(eEffect))
					{
						if (GetEffectSpellId(eEffect) == SPELL_Weapon_Energy)
						{
							RemoveEffect(oPossessor, eEffect);
							eEffect = GetFirstEffect(oTarget);
						}
						else
							eEffect = GetNextEffect(oTarget);
					}
				}

				int iType;
				switch (iSpellId)
				{
					case SPELL_Weapon_Energy_F:			// #1815 - subradials of #1814 SPELL_Weapon_Energy
						iType = DAMAGE_TYPE_FIRE;
						break;
					case SPELL_Weapon_Energy_A:			// #1816
						iType = DAMAGE_TYPE_ACID;
						break;
					case SPELL_Weapon_Energy_C:			// #1817
						iType = DAMAGE_TYPE_COLD;
						break;
					case SPELL_Weapon_Energy_E:			// #1818
						iType = DAMAGE_TYPE_ELECTRICAL;

				// TODO: should put Sonic in here also. ( requires new Spells.2da entry ... )
				}
//					iType = IP_CONST_DAMAGETYPE_FIRE;
//					iType = IP_CONST_DAMAGETYPE_ACID;
//					iType = IP_CONST_DAMAGETYPE_COLD;
//					iType = IP_CONST_DAMAGETYPE_ELECTRICAL;

				effect eBonus	= EffectDamageIncrease(DAMAGE_BONUS_1d6, iType);
				effect eVis		= EffectVisualEffect(VFX_DUR_SPELL_BLESS_WEAPON);
				eBonus			= EffectLinkEffects(eBonus, eVis);
				eBonus			= SetEffectSpellId(eBonus, SPELL_Weapon_Energy); // #1814

				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oPossessor, fDur);
			}

//			itemproperty ipBonus = ItemPropertyDamageBonus(iType, IP_CONST_DAMAGEBONUS_1d6)
//			IPSafeAddItemProperty(oMyWeapon, ipBonus, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);

			itemproperty ipMassCrit = ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_1d8);
			IPSafeAddItemProperty(oMyWeapon, ipMassCrit, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
		}
	}
	else
		FloatingTextStrRefOnCreature(83615, OBJECT_SELF); // "* Spell Failed - Target must be a melee weapon or creature with a melee weapon equipped *"
}


// Kaedrin's old code:
/*	int nSpellId = GetSpellId();
	int DamageType;

	if (nSpellId == SPELL_Weapon_Energy || nSpellId == SPELL_Weapon_Energy_F)
		DamageType = DAMAGE_TYPE_FIRE;
	else
	if (nSpellId == SPELL_Weapon_Energy_A)
		DamageType = DAMAGE_TYPE_ACID;
	else
	if (nSpellId == SPELL_Weapon_Energy_C)
		DamageType = DAMAGE_TYPE_COLD;
	else
	if (nSpellId == SPELL_Weapon_Energy_E)
		DamageType = DAMAGE_TYPE_ELECTRICAL;

	int nCasterLvl = GetCasterLevel(OBJECT_SELF);
	float fDuration = RoundsToSeconds(nCasterLvl);
	fDuration = ApplyMetamagicDurationMods(fDuration);

	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_BLESS_WEAPON);
	object oMyWeapon = IPGetTargetedOrEquippedWeapon();

	if (GetIsObjectValid(oMyWeapon))
	{
		if (GetHasSpellEffect(SPELL_Weapon_Energy,GetItemPossessor(oMyWeapon)))
		{
			RemoveAnySpellEffects(SPELL_Weapon_Energy, GetItemPossessor(oMyWeapon));
		}

		effect DamageBonus = EffectDamageIncrease(DAMAGE_BONUS_1d6, DamageType);
		DamageBonus = SetEffectSpellId(DamageBonus, SPELL_Weapon_Energy);

		SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
		//IPSafeAddItemProperty(oMyWeapon, ItemPropertyDamageBonus(ipDamageType, IP_CONST_DAMAGEBONUS_1d6), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, DamageBonus, GetItemPossessor(oMyWeapon), fDuration);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, GetItemPossessor(oMyWeapon), fDuration);
		IPSafeAddItemProperty(oMyWeapon, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_1d10), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		return;
	}
	else
	{
		FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
		return;
	} */


// Kaedrin's older code:
/*	int nSpellId = GetSpellId();
	int ipDamageType;
	//SendMessageToPC(OBJECT_SELF,IntToString(nSpellId));

	if (nSpellId == SPELL_Weapon_Energy || nSpellId == SPELL_Weapon_Energy_F)
		ipDamageType = IP_CONST_DAMAGETYPE_FIRE;
	else
	if (nSpellId == SPELL_Weapon_Energy_A)
		ipDamageType = IP_CONST_DAMAGETYPE_ACID;
	else
	if (nSpellId == SPELL_Weapon_Energy_C)
		ipDamageType = IP_CONST_DAMAGETYPE_COLD;
	else
	if (nSpellId == SPELL_Weapon_Energy_E)
		ipDamageType = IP_CONST_DAMAGETYPE_ELECTRICAL;

	int nCasterLvl = GetCasterLevel(OBJECT_SELF);
	float fDuration = RoundsToSeconds(nCasterLvl);
	fDuration = ApplyMetamagicDurationMods(fDuration);

	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_BLESS_WEAPON);
	object oMyWeapon = IPGetTargetedOrEquippedWeapon();

	if (GetIsObjectValid(oMyWeapon))
	{
		SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
		IPSafeAddItemProperty(oMyWeapon, ItemPropertyDamageBonus(ipDamageType, IP_CONST_DAMAGEBONUS_1d6), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, GetItemPossessor(oMyWeapon), fDuration);
		IPSafeAddItemProperty(oMyWeapon, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_1d10), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		return;
	}
	else
	{
		FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
		return;
	} */
