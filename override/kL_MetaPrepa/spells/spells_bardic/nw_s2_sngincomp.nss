//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Inspire Competence
//:: 'nw_s2_sngincomp'
//:: Created By: Jesse Reynolds (JLR-OEI)
//:: Created On: 04/06/06
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
	This spells applies bonuses to all of the bard's
	allies within 30ft for as long as it is kept up.
*/
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
			FloatingTextStrRefOnCreature(182800, OBJECT_SELF);	// "You do not have enough ranks in Perform to use this ability."
			return;
		}

		if (FindEffectSpellId(EFFECT_TYPE_BARDSONG_SINGING) == iSpellId)
		{
			int iSkill = 2;

			int iLevel = GetBardicClassLevel(oCaster);
			if (iLevel > 10)
			{
				iSkill += ((iLevel - 3) / 8) * 2; // +2 every 8 levels starting at level 3
			}

			if (GetHasFeat(FEAT_EPIC_INSPIRATION, oCaster))		iSkill += 2;
			if (GetHasFeat(FEAT_SONG_OF_THE_HEART, oCaster))	iSkill += 1;

			effect eSkill	= EffectSkillIncrease(SKILL_ALL_SKILLS, iSkill);
			effect eDur		= EffectVisualEffect(VFX_HIT_BARD_INS_COMPETENCE);
			eDur			= EffectLinkEffects(eSkill, eDur);
			eDur			= ExtraordinaryEffect(eDur);

			float fDur = 4.f;
			ApplyFriendlySongEffectsToArea(oCaster, iSpellId, fDur, RADIUS_SIZE_COLOSSAL, eDur);

			DelayCommand(2.5f, RunPersistentSong(oCaster, iSpellId));
		}
	}
}


// ___________
// ** MAIN ***
// -----------
void main()
{
//	if (kL_iDebug) SendMessageToPC(GetFirstPC(FALSE), "Run ( nw_s2_sngincomp ) - " + GetName(OBJECT_SELF));

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
