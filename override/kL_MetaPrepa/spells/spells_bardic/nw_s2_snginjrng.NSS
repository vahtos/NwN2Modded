//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Inspire Jarring
//:: 'nw_s2_snginjrng'
//:: Created By: Jesse Reynolds (JLR-OEI)
//:: Created On: 04/07/06
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
	This spells applies negative modifiers to all enemies
	within 20 feet.
*/
//:: AFW-OEI 06/06/2006:
//:: Change from a "Jarring" effect to -4 Discipline/Concentration and -2 to all Will saves.
//:: PKM-OEI 07.13.06 VFX Pass
//:: PKM-OEI 07.20.06 Added Perform skill check
//:: kevL's
//:: 2012 july 7
//:: - added spellhook & tidy up.
//:: 2016 sept 10
//:: - include "mrop_bardic_inc"
//:: - tidy & refactor.


#include "x2_inc_spellhook"		// kL_RoM, addition of spellhook

#include "mrop_inc_preps"		// kL_RoM, MROP_VAR_ACTIVE
#include "mrop_bardic_inc"		// GetBardicClassLevelForUses()

#include "nwn2_inc_spells"


//
void RunPersistentSong(object oCaster, int iSpellId)
{
	if (GetCanBardSing(oCaster))
	{
		if (GetSkillRank(SKILL_PERFORM) < 3)
		{
			FloatingTextStrRefOnCreature(182800, OBJECT_SELF);
			return;
		}

		if (FindEffectSpellId(EFFECT_TYPE_BARDSONG_SINGING) == iSpellId)
		{
//			effect eJarring = ExtraordinaryEffect(EffectJarring());

			effect eDisc	= EffectSkillDecrease(SKILL_DISCIPLINE, 4);
			effect eConc	= EffectSkillDecrease(SKILL_CONCENTRATION, 4);
			effect eWill	= EffectSavingThrowDecrease(SAVING_THROW_WILL, 2);
			effect eDur		= EffectVisualEffect(VFX_HIT_BARD_INS_JARRING);
			eDur			= EffectLinkEffects(eDisc, eDur);
			eDur			= EffectLinkEffects(eConc, eDur);
			eDur			= EffectLinkEffects(eWill, eDur);
			eDur			= ExtraordinaryEffect(eDur);

			float fDur = 4.f;
			ApplyHostileSongEffectsToArea(oCaster, iSpellId, fDur, RADIUS_SIZE_HUGE, eDur);

			DelayCommand(2.5f, RunPersistentSong(oCaster, iSpellId));
		}
	}
}


// ___________
// ** MAIN ***
// -----------
void main()
{
//	if (kL_iDebug) SendMessageToPC(GetFirstPC(FALSE), "Run ( nw_s2_snginjrng ) - " + GetName(OBJECT_SELF));

	// kL_RoM, addition of Spellhook
	if (GetLocalInt(GetModule(), MROP_VAR_ACTIVE) // the spellhook will fire in Learn mode if TRUE
		&& !X2PreSpellCastCode())
	{
		return;
	}

	if (GetCanBardSing(OBJECT_SELF) && AttemptNewSong(OBJECT_SELF, TRUE))
	{
		effect eFNF = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_BARD_SONG));
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

		DelayCommand(0.f, RunPersistentSong(OBJECT_SELF, GetSpellId()));
	}
}
