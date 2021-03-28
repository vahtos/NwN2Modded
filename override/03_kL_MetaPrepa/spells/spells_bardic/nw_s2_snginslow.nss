//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Inspire Slowing
//:: 'nw_s2_snginslow'
//:: Created By: Jesse Reynolds (JLR-OEI)
//:: Created On: 04/07/06
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
	This spells applies negative modifiers to all enemies
	within 20 feet.
*/
//:: AFW-OEI 06/06/2006:
//:: Reduced movement penalties from 25%/50% to 15%/30%
//:: PKM-OEI 07.13.06 VFX Pass
//:: PKM-OEI 07.20.06 Added Perform skill check
//:: kevL's
//:: 2012 july 7
//:: - note this is Kaedrin's 1.41.4 script.
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
			int iLevel = GetBardicClassLevel(oCaster);

			int iWillSave = 13 + (iLevel / 2) + GetAbilityModifier(ABILITY_CHARISMA, oCaster);

			if (GetHasFeat(FEAT_DRAGONSONG))				iWillSave += 2;
			if (GetHasFeat(FEAT_ABILITY_FOCUS_BARDSONG))	iWillSave += 2;
			if (GetHasFeat(FEAT_SONG_OF_THE_HEART))			iWillSave += 1;

			int iMoveDecr = 15;
			if (iLevel > 15) iMoveDecr = 30;

			effect eMove	= EffectMovementSpeedDecrease(iMoveDecr);
			effect eDur		= EffectVisualEffect(VFX_HIT_BARD_INS_SLOWING);
			eDur			= EffectLinkEffects(eMove, eDur);
			eDur			= ExtraordinaryEffect(eDur);

			float fDur = 4.f;
			ApplyHostileSongEffectsToArea(oCaster, iSpellId, fDur, RADIUS_SIZE_HUGE, eDur, SAVING_THROW_WILL, iWillSave);

			DelayCommand(2.5f, RunPersistentSong(oCaster, iSpellId));
		}
	}
}


// ___________
// ** MAIN ***
// -----------
void main()
{
//	if (kL_iDebug) SendMessageToPC(GetFirstPC(FALSE), "Run ( nw_s2_snginslow ) - " + GetName(OBJECT_SELF));

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
