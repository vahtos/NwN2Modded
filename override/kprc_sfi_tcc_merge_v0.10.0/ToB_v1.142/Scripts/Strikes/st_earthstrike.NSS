//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 10/29/2009							//
//	Title: st_earthstrike						//
//	Description: You channel ki into the earth  //
//  with your mighty strike, causing the ground //
//  to rumble and shake briefly. Anyone standing//
//  on the ground in this maneuver's area must  //
//  make a successful Reflex save (DC 18 + your //
//  Str modifier) or be knocked prone. Any      //
//  creature in this area that is currently     //
//  casting a spell must succeed on an opposed  //
//  skill challenge of its Concentration check  //
//  versus your Parry check or suffer from a    //
//  spell failure effect for six seconds.       //
//////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_include"
#include "tob_i0_spells"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	SetLocalInt(oToB, "StoneDragonStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "StoneDragonStrike", 0));
	WrapperPlayCustomAnimation(oPC, "*powerattack", 0);
	ExpendManeuver(150, "STR");

	int nParry;

	nParry = GetSkillRank(SKILL_PARRY, oPC);

	if (GetHasFeat(6912, oPC)) //Blade Meditation
	{
		nParry += 2;
	}

	int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
	int nDC = GetManeuverDC(nStr, 0, 18);
	int nd20 = d20(1);
	int nRoll = nParry + nd20;
	float fRange = FeetToMeters(20.0f) + GetGirth(oPC); // Starts from the edge of the PC's square rather than the center.
	location lPC = GetLocation(oPC);
	effect eVis = EffectVisualEffect(VFX_SPELL_HIT_EARTHQUAKE);
	effect eKnockdown = EffectKnockdown();
	effect eFizzle = EffectSpellFailure(100);
	eFizzle = ExtraordinaryEffect(eFizzle);

	DelayCommand(2.8f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lPC));

	object oFoe;
	int nReflex, nAction, nConcentration, nFoed20, nFoeRoll;
	float fDelay;

	oFoe = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);

	while (GetIsObjectValid(oFoe))
	{
		if ((oPC != oFoe) && (spellsIsTarget(oFoe, SPELL_TARGET_STANDARDHOSTILE, oPC)))
		{
			nReflex = MySavingThrow(SAVING_THROW_REFLEX, oFoe, nDC);
			nAction = GetCurrentAction(oFoe);
			fDelay = (GetDistanceBetween(oPC, oFoe) / 20) + 2.8f; //2.8 is the animation's duration.

			if ((nReflex == 0) && (!GetIsImmune(oFoe, IMMUNITY_TYPE_KNOCKDOWN)))
			{
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oFoe, 3.0f));
			}

			if (nAction == ACTION_CASTSPELL)
			{
				nConcentration = GetSkillRank(SKILL_CONCENTRATION, oFoe);
				nFoed20 = d20(1);
				nFoeRoll = nConcentration + nFoed20;

				SendMessageToPC(oPC, "<color=chocolate>Opposed Skill Challenge: " + GetName(oPC) + "'s Parry vs. " + GetName(oFoe) + "'s Concentration: (" + IntToString(nd20) + " + " + IntToString(nParry) + " = " + IntToString(nRoll) + ") vs. (" + IntToString(nFoed20) + " + " + IntToString(nConcentration) + " = " + IntToString(nFoeRoll) + ").</color>");

				if (nRoll >= nFoeRoll)
				{
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFizzle, oFoe, 6.0f);
				}
			}
		}

		oFoe = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);
	}
}