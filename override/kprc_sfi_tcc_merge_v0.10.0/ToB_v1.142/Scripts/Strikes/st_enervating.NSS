//////////////////////////////////////////////////////////////
//	Author: Drammel											//
//	Date: 10/28/2009										//
//	Title: st_enervating	  								//
//	Description: As part of this maneuver, you make a single//
//  melee attack. If this attack hits, the target must make //
//  a successful Fortitude save (DC 18 + your Wis modifier) //
//  or gain 1d4 negative levels. You gain 5 temporary hit   //
//  points for each negative level your enemy gains.        //
//  Temporary hit points gained in this manner last until   //
//  the end of the encounter. The effects of any negative   //
//  levels bestowed by this strike disappear in 24 hours. If//
//  the target has at least as many negative levels as Hit  //
//  Dice, it dies. Each negative level gives a creature a -1//
//  penalty on attack rolls, saving throws, skill checks,   //
//  ability checks, and effective level (for determining the//
//  power, duration, DC, and other details of spells or     //
//  special abilities).  Additionally, a spellcaster loses  //
//  one spell or spell slot from her highest available      //
//  level.  Negative levels stack. In addition to the       //
//  negative levels, your attack deals normal damage, even  //
//  if the target succeeds on the saving throw.				//
//////////////////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"
#include "tob_i0_spells"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 125);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "ShadowHandStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "ShadowHandStrike", 0));
	
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);
	
	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	BasicAttackAnimation(oWeapon, nHit); 
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));
	ExpendManeuver(125, "STR");

	int nNonLiving;

	if ((GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT) || (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD))
	{
		nNonLiving = 1;
	}
	else nNonLiving = 0;

	if ((nHit > 0) && (nNonLiving == 0) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_NEGATIVE_LEVEL)))
	{
		int nWisdom = GetAbilityModifier(ABILITY_WISDOM, oPC);
		int nDC = GetManeuverDC(nWisdom, 0, 18);
		int nFort = MySavingThrow(SAVING_THROW_FORT, oTarget, nDC);

		if (nFort == 0)
		{
			int nNumber;

			if ((nHit == 2) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))) // According the the Rules Compendium this does get multiplied.
			{
				nNumber = d4(2);
			}
			else nNumber = d4(1);

			effect eVis = EffectVisualEffect(VFX_TOB_ENERVATION);
			effect eEnervating = EffectNegativeLevel(nNumber, TRUE);
			eEnervating = SupernaturalEffect(eEnervating);
			eEnervating = SetEffectSpellId(eEnervating, -1);

			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 3.0f);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEnervating, oTarget); // I think applying this as permanent is pretty close to a 24 hour period.
		}
	}
}