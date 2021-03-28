//::///////////////////////////////////////////////
//:: Lesser Energized Shield - Fire
//:: 'cmi_s0_lsrenrgshld_f'
//:: Created By: Kaedrin (Matt)
//:: Created On: July 3, 2007
//:://////////////////////////////////////////////
//:: kevL's
//:: 2012 july 3
//:: - added code that allows Rod of Preparation to
//::   target shields directly.
//:: - changed the code to work as described in Dialog.Tlk ...
//::   ie, the shield *must be equipped* if using my personal
//::   'cmi_player_equip' & 'cmi_player_unequip' scripts
//:: - the code for that is commented for distribution.
//:: 2016 sept 10
//:: - include 'mrop_items_inc'
//:: - tidy & refactor.


#include "x2_inc_spellhook"

#include "mrop_inc"			// GetMRoPTarget()
#include "mrop_items_inc"	// GetFighterCasterLevel(), GetTargetShield(), ClearEnergizedEffects(), CreateEnergizedEffect()

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

	object oMyShield = GetMRoPTarget(iSpellId, oTarget);

	if (!GetIsObjectValid(oMyShield)) // kL_RoP end.
		oMyShield = GetTargetShield();

	if (GetIsObjectValid(oMyShield))
	{
		object oPossessor = GetItemPossessor(oMyShield);
		if (GetIsObjectValid(oPossessor))
			SignalEvent(oPossessor, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));

		float fDur = RoundsToSeconds(GetFighterCasterLevel());
		fDur = ApplyMetamagicDurationMods(fDur);

		if (fDur > 0.f && GetIsObjectValid(oPossessor))
		{
			ClearEnergizedEffects(oPossessor);

			effect eShield = CreateEnergizedEffect(DAMAGE_TYPE_FIRE, TRUE);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShield, oPossessor, fDur);
		}
	}
	else
		SendMessageToPC(OBJECT_SELF, "* Spell Failed - target must be a shield or creature equipped with a shield *");
}


/*	effect eDamShld = EffectDamageShield(0, DAMAGE_BONUS_1d4, DAMAGE_TYPE_FIRE);
	effect eDamRes = EffectDamageResistance(DAMAGE_TYPE_FIRE, 5, 0);
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);

	effect eLink = EffectLinkEffects(eDamRes, eDamShld);
	eLink = EffectLinkEffects(eLink, eVis);

	int nCasterLvl = GetPalRngCasterLevel();
	float fDuration = RoundsToSeconds( nCasterLvl );
	fDuration = ApplyMetamagicDurationMods(fDuration);

	object oTarget = GetSpellTargetObject();

    RemoveEffectsFromSpell(oTarget, GetSpellId());
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration); */
