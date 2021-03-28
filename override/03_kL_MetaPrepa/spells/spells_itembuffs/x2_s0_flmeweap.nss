//::///////////////////////////////////////////////
//:: Flame Weapon
//:: 'x2_s0_flmeweap'
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Gives a melee weapon 1d4 fire damage +1 per caster
	level to a maximum of +10.
	3.5: Gives a melee weapon +1d6 fire damage (flat).
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 29, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 08, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:: 2003-07-15: Complete Rewrite to make use of Item Property System
//:: (Update JLR - OEI 07/26/05) -- 3.5 Update
//:: (Update BDF - OEI 08/29/05) -- Corrected the spellID param value of ItemPropertyOnHitCastSpell
//:: AFW-OEI 07/23/2007: If it's going to be fixed fire damage, forget the fancy on-hit spell and just
//		go with our elemental damage item property. Also, increase to 1d8.
//:: RPGplayer1 03/19/2008: Won't replace non-fire elemental damage
//:: RPGplayer1 01/11/2009: Corrected duration to 1 turn/level
//:: kevL's
//:: 2012 july 5
//:: - reverting duration to 1 min. per level.
//:: - added code that allows Rod of Preparation to
//::   target offhand weapons & etc directly.
//:: - note this is Kaedrin's 1.41.4 script.
//:: - ApplyMetamagicDurationMods
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
		oMyWeapon = GetTargetWeapon(WEAPTYPE_MEL);

	if (GetIsObjectValid(oMyWeapon))
	{
		object oPossessor = GetItemPossessor(oMyWeapon);
		if (GetIsObjectValid(oPossessor))
			SignalEvent(oPossessor, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));

		float fDur = TurnsToSeconds(GetCasterLevel(OBJECT_SELF));
		fDur = ApplyMetamagicDurationMods(fDur);

		if (fDur > 0.f)
		{
			// find a vFx for this ...

			itemproperty ipFlame = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d8);
			IPSafeAddItemProperty(oMyWeapon, ipFlame, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
		}
	}
	else
		FloatingTextStrRefOnCreature(83615, OBJECT_SELF); // "* Spell Failed - Target must be a melee weapon or creature with a melee weapon equipped *"
}
