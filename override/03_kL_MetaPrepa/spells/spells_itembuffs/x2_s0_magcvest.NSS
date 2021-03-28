//::///////////////////////////////////////////////
//:: Magic Vestment
//:: 'x2_s0_magcvest'
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Grants a +1 AC bonus to armor touched per 4 caster
	levels (maximum of +5).
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 28, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 09, 2003
//:: 2003-07-29: Rewritten, Georg Zoeller
//:: Updated (JLR - OEI) 07/12/05 NWN2 3.5
//:: kevL's
//:: 2012 june 30
//:: - added code that allows Rod of Preparation to
//::   target shields & armors directly.
//:: - ApplyMetamagicDurationMods
//:: 2012 july 11
//:: - moved varname cycling code out to a function in 'mrop_inc'
//:: 2012 july 25
//:: - changed IPPolicy for ACBonus. -> replace, false, false.
//:: 2016 sept 10
//:: - include 'mrop_items_inc'
//:: - tidy & refactor.


#include "x2_inc_spellhook"

#include "mrop_inc"			// GetMRoPTarget()
#include "mrop_items_inc"	// GetTargetArmor()

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
	int iSpellId = GetSpellId();
	object oTarget = GetSpellTargetObject();

	object oMyArmor = GetMRoPTarget(iSpellId, oTarget);

	if (!GetIsObjectValid(oMyArmor)) // kL_RoP end.
		oMyArmor = GetTargetArmor();

	if (GetIsObjectValid(oMyArmor))
	{
		object oPossessor = GetItemPossessor(oMyArmor);
		if (GetIsObjectValid(oPossessor))
			SignalEvent(oPossessor, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));

		int iCL = GetCasterLevel(OBJECT_SELF);
		float fDur = HoursToSeconds(iCL);
		fDur = ApplyMetamagicDurationMods(fDur);

		if (fDur > 0.f)
		{
			if (GetIsObjectValid(oPossessor))
			{
				effect eVis = EffectVisualEffect(VFX_DUR_SPELL_MAGIC_VESTMENT);
				eVis = SupernaturalEffect(eVis);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPossessor, fDur);
			}

			int iAC = iCL / 4;
			if		(iAC < 1) iAC = 1;
			else if	(iAC > 5) iAC = 5;

			itemproperty ipAC = ItemPropertyACBonus(iAC);
			IPSafeAddItemProperty(oMyArmor, ipAC, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
		}
	}
	else
		FloatingTextStrRefOnCreature(83826, OBJECT_SELF); // "* Spell Failed - Target must be a valid creature, armor or shield *"
}
