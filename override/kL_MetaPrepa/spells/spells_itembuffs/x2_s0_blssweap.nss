//::///////////////////////////////////////////////
//:: Bless Weapon
//:: 'x2_s0_blssweap'
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	If cast on a crossbow bolt, it adds the ability to
	slay rakshasa's on hit

	If cast on a melee weapon, it will add:
		grants a +1 enhancement bonus.
		grants a +2d6 damage divine to undead

	- will add a holy vfx when command becomes available

	If cast on a creature it will pick the first
	melee weapon without these effects

	Now considered "Good" for Damage Reduction purposes ...
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 28, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 09, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:: 2003-07-15: Complete Rewrite to make use of Item Property System
//:: Updated JLR - OEI 08/01/05 NWN2 3.5 -- "Good" change
//:: kevL's
//:: 2012 july 8
//:: - added code that allows Rod of Preparation to
//::   target offhand weapons & etc directly.
//:: - note this is Kaedrin's 1.41.4 script.
//:: - ApplyMetamagicDurationMods
//:: 2012 july 11
//:: - moved varname cycling code out to a function in 'mrop_inc'
//:: 2012 july 25
//:: - changed IPPolicy for EnhanceEvil. -> replace, false, false.
//:: 2013 april 26
//:: - remove *2 duration, as per .Tlk desc. Refactored ( again )
//:: 2016 sept 10
//:: - include 'mrop_items_inc'
//:: - tidy & refactor.


#include "x2_inc_spellhook"

#include "mrop_inc"			// GetMRoPTarget()
#include "mrop_items_inc"	// GetFighterCasterLevel(), GetTargetWeapon()

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
	int iID = GetSpellId();
	object oTarget = GetSpellTargetObject();

	object oMyWeapon = GetMRoPTarget(iID, oTarget);

	int bBolts = FALSE; // special handling for blessing crossbow bolts that can slay rakshasa's
	if (!GetIsObjectValid(oMyWeapon)) // kL_RoP end.
	{
		if (GetIsObjectValid(oTarget) && GetBaseItemType(oTarget) == BASE_ITEM_BOLT)
		{
			bBolts = TRUE;
			oMyWeapon = oTarget;
		}
		else
			oMyWeapon = GetTargetWeapon(WEAPTYPE_MEL);
	}

	if (GetIsObjectValid(oMyWeapon))
	{
		float fDur;
		int iCL = GetFighterCasterLevel();
		if (bBolts)
			fDur = RoundsToSeconds(iCL);
		else
			fDur = TurnsToSeconds(iCL);

		fDur = ApplyMetamagicDurationMods(fDur);

		if (fDur > 0.f)
		{
			object oPossessor = GetItemPossessor(oMyWeapon);
			if (GetIsObjectValid(oPossessor))
			{
				SignalEvent(oPossessor, EventSpellCastAt(OBJECT_SELF, iID, FALSE));

				effect eVis = EffectVisualEffect(VFX_DUR_SPELL_BLESS_WEAPON);
				eVis = SupernaturalEffect(eVis);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPossessor, fDur);
			}

			if (bBolts)
			{
				// ---------------- TARGETED ON BOLT -------------------- //
				itemproperty ipSlayRaksha = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_SLAYRAKSHASA, 10);
				IPSafeAddItemProperty(oMyWeapon, ipSlayRaksha, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
			}
			else
			{
				itemproperty ipEvil = ItemPropertyEnhancementBonusVsAlign(ALIGNMENT_EVIL, 1);
				IPSafeAddItemProperty(oTarget, ipEvil, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

				itemproperty ipUndead = ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_2d6);
				IPSafeAddItemProperty(oTarget, ipUndead, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

				itemproperty ipVis = ItemPropertyVisualEffect(ITEM_VISUAL_HOLY);
				IPSafeAddItemProperty(oTarget, ipVis, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
			}
		}
	}
	else
		FloatingTextStrRefOnCreature(83615, OBJECT_SELF); // "* Spell Failed - Target must be a melee weapon or creature with a melee weapon equipped *"
}
