//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Inspire Courage
//:: 'nw_s2_sngincour'
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
void cmi_ApplyFriendlySongEffectsToArea(object oCaster, int iSpellId, float fDur, float fRadius, effect eLink)
{
	// AFW-OEI 07/17/2006: Because the caster will already have the EFFECT_BARDSONG_SINGING
	// effect on him, we need to do some shenanigans to see if that's the only effect
	// w/ that bardsong ID. If it is, we need to apply the bonuses for the first time.
	int bCasterAlreadyHasBardsongEffects = FALSE;

	effect eCheck = GetFirstEffect(oCaster);
	while (GetIsEffectValid(eCheck))
	{
		if (GetEffectSpellId(eCheck) == iSpellId
			&& GetEffectType(eCheck) != EFFECT_TYPE_BARDSONG_SINGING)
		{
			bCasterAlreadyHasBardsongEffects = TRUE;
			break;
		}
		eCheck = GetNextEffect(oCaster);
	}

	location lCaster = GetLocation(oCaster);
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lCaster);
	while (GetIsObjectValid(oTarget))
	{
		int iRacialType = GetRacialType(oTarget);

		// AFW-OEI 07/02/2007: Inspire Regen does not affect undead or constructs.
		if (GetIsObjectValidSongTarget(oTarget)
			&& !(iSpellId == SPELLABILITY_SONG_INSPIRE_REGENERATION
				&& (iRacialType == RACIAL_TYPE_CONSTRUCT || iRacialType == RACIAL_TYPE_UNDEAD)))
		{
			if (!GetHasSpellEffect(iSpellId, oTarget)
				|| (oTarget == oCaster && !bCasterAlreadyHasBardsongEffects))
			{
				if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))
				{
					if (GetHasSpellEffect(SPELLABILITY_DRPIRATE_RALLY_THE_CREW, oTarget))
						RemoveEffectsFromSpell(oTarget, SPELLABILITY_DRPIRATE_RALLY_THE_CREW);

					SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));

					eLink = SetEffectSpellId(eLink, iSpellId);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);
				}
			}
			else
				RefreshSpellEffectDurations(oTarget, iSpellId, fDur);
		}

		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lCaster);
	}
}

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
			int iAttack = 1;

			int iLevel = GetBardicClassLevel(oCaster);
			if (iLevel > 7)
			{
				iAttack += (iLevel - 2) / 6; // +1 every six levels starting at level 2
			}

			if (GetHasFeat(FEAT_EPIC_INSPIRATION, oCaster)) 			iAttack += 2;
			if (GetHasSpellEffect(SPELL_Inspirational_Boost, oCaster))	iAttack += 1;
			if (GetHasFeat(FEAT_SONG_OF_THE_HEART, oCaster))			iAttack += 1;
			if (GetHasFeat(FEAT_LEADERSHIP, oCaster))					iAttack += 1;

			int iPirate = GetLevelByClass(CLASS_DREAD_PIRATE, oCaster);
			if		(iPirate > 6) iAttack += 2;
			else if (iPirate > 2) iAttack += 1;

			int iDamage = IPGetDamageBonusConstantFromNumber(iAttack);

			effect eAttack	= EffectAttackIncrease(iAttack);
			effect eDamage	= EffectDamageIncrease(iDamage);
			effect eDur		= EffectVisualEffect(VFX_HIT_BARD_INS_COURAGE);
			eDur			= EffectLinkEffects(eAttack, eDur);
			eDur			= EffectLinkEffects(eDamage, eDur);
			eDur			= ExtraordinaryEffect(eDur);

			float fDur = 4.f;
			cmi_ApplyFriendlySongEffectsToArea(oCaster, iSpellId, fDur, RADIUS_SIZE_COLOSSAL, eDur);

			DelayCommand(2.5f, RunPersistentSong(oCaster, iSpellId));
		}
	}
}


// ___________
// ** MAIN ***
// -----------
void main()
{
//	if (kL_iDebug) SendMessageToPC(GetFirstPC(FALSE), "Run ( nw_s2_sngincour ) - " + GetName(OBJECT_SELF));

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
