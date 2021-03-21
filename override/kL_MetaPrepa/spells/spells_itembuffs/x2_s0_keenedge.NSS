//::///////////////////////////////////////////////
//:: Keen Edge
//:: 'x2_s0_keenedge'
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Adds the keen property to one melee weapon,
	increasing its critical threat range.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 28, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 08, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:: 2003-07-17: Complete Rewrite to make use of Item Property System
//:: JLR - OEI 08/24/05 -- Metamagic changes
//:: kevL's
//:: 2012 june 30
//:: - added code that allows Rod of Preparation to
//::   target offhand weapons & etc directly.
//:: 2012 july 11
//:: - moved varname cycling code out to a function in 'mrop_inc'
//:: 2012 july 25
//:: - changed IPPolicy for keen. -> replace, false, false.
//:: 2016 sept 10
//:: - include 'mrop_items_inc'
//:: - tidy & refactor.


#include "x2_inc_spellhook"

#include "mrop_inc"			// GetMRoPTarget()
#include "mrop_items_inc"	// GetTargetWeapon()

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

	object oMyWeapon = GetMRoPTarget(iSpellId, oTarget);

	if (!GetIsObjectValid(oMyWeapon)) // kL_RoP end.
		oMyWeapon = GetTargetWeapon(WEAPTYPE_MEL);

	if (GetIsObjectValid(oMyWeapon))
	{
		object oPossessor = GetItemPossessor(oMyWeapon);
		if (GetIsObjectValid(oPossessor))
			SignalEvent(oPossessor, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));

		switch (GetWeaponType(oMyWeapon))
		{
			case WEAPON_TYPE_PIERCING:
			case WEAPON_TYPE_SLASHING:
			case WEAPON_TYPE_PIERCING_AND_SLASHING:
			{
				float fDur = TurnsToSeconds(GetCasterLevel(OBJECT_SELF) * 10);
				fDur = ApplyMetamagicDurationMods(fDur);

				if (fDur > 0.f)
				{
					if (GetIsObjectValid(oPossessor))
					{
						effect eVis = EffectVisualEffect(VFX_DUR_SPELL_KEEN_EDGE);
						eVis = SupernaturalEffect(eVis);
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPossessor, fDur);
					}

					itemproperty ipKeen = ItemPropertyKeen();
					IPSafeAddItemProperty(oMyWeapon, ipKeen, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

					itemproperty ipVis = ItemPropertyVisualEffect(ITEM_VISUAL_HOLY);
					IPSafeAddItemProperty(oMyWeapon, ipVis, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
				}
				break;
			}

			default:
				FloatingTextStrRefOnCreature(83621, OBJECT_SELF);	// "* Invalid Target - This spell must be cast on a slashing weapon *"
		}															// TODO: "... or piercing ... or piercing and slashing."
	}
	else
		FloatingTextStrRefOnCreature(83615, OBJECT_SELF); // "* Spell Failed - Target must be a melee weapon or creature with a melee weapon equipped *"
}
