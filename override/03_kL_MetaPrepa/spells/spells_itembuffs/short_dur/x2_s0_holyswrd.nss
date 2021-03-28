//::///////////////////////////////////////////////
//:: Holy Sword
//:: 'x2_s0_holyswrd'
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Grants holy avenger properties.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 28, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 08, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:: PKM-OEI 07.08.06: VFX update for NWN2
//:: kevL's
//:: 2012 july 9
//:: - added code that allows Rod of Preparation to
//::   target offhand weapons & etc directly.
//:: - ApplyMetamagicDurationMods.
//:: - changed ipPolicy.
//:: - restructured.
//:: 2016 sept 10
//:: - include 'mrop_items_inc'
//:: - tidy & refactor.
//:: - remove surplus SignalEvent().


#include "x2_inc_spellhook"

#include "mrop_inc"			// GetMRoPTarget()
#include "mrop_items_inc"	// GetFighterCasterLevel(), GetTargetWeapon()

#include "nwn2_inc_metmag"
#include "x2_inc_toollib"	// TLVFXPillar()


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

		float fDur = RoundsToSeconds(GetFighterCasterLevel());
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
				DelayCommand(0.8f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVisSun, lLoc));
			}

			itemproperty ipHolyAvenger = ItemPropertyHolyAvenger();
			IPSafeAddItemProperty(oMyWeapon, ipHolyAvenger, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

			itemproperty ipVis = ItemPropertyVisualEffect(ITEM_VISUAL_HOLY);
			IPSafeAddItemProperty(oMyWeapon, ipVis, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
		}
	}
	else
		FloatingTextStrRefOnCreature(83615, OBJECT_SELF); // "* Spell Failed - Target must be a melee weapon or creature with a melee weapon equipped *"
}


/*	//effect eVis = EffectVisualEffect(VFX_IMP_GOOD_HELP);//NWN1 VFX
	//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);//NWN1 VFX
	effect eDur = EffectVisualEffect(VFX_DUR_SPELL_HOLY_SWORD);
	int nDuration = GetPalRngCasterLevel();
	int nMetaMagic = GetMetaMagicFeat();

	if (nMetaMagic == METAMAGIC_EXTEND)
	{
		nDuration = nDuration * 2; //Duration is +100%
	}

	object oMyWeapon = cmi_GetTargetedOrEquippedMeleeWeapon();
	if (GetIsObjectValid(oMyWeapon))
	{
		SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

		if (nDuration > 0)
		{
			//ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));//Don't need this, NWN1 VFX
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), RoundsToSeconds(nDuration));

			AddHolyAvengerEffectToWeapon(oMyWeapon, RoundsToSeconds(nDuration));
		}
		TLVFXPillar(VFX_IMP_GOOD_HELP, GetLocation(GetSpellTargetObject()), 4, 0.f, 6.f);
		DelayCommand(1.f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUNSTRIKE), GetLocation(GetSpellTargetObject())));
	}
	else
	{
		FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
	} */
