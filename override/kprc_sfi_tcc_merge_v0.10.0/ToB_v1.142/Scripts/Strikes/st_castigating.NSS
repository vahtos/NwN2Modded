//////////////////////////////////////////////////////////////////
//	Author: Drammel												//
//	Date: 10/16/2009											//
//	Title: st_castigating										//
//	Description: When you use this strike, make a single melee  //
//  attack. If you hit your opponent and his alignment has at   //
//  least one component different from yours, a blast of divine //
//  energy originates from your attack's point of impact. The   //
//  target of this strike takes an extra 8d6 points of damage   //
//  and must succeed on a Fortitude save (DC 17 + your Cha      //
//  modifier) or take a -2 penalty on attack rolls for 1 minute.// 
//  All of your opponents within a 30 foot radius burst of the  //
//  target creature must also succeed on a Fortitude save.      //
//  Those who fail take 5d6 points of damage and take a -2      //
//  penalty on attack rolls for 1 minute. A successful save     //
//  results in half damage and negates the attack penalty.		//
//////////////////////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"
#include "bot9s_inc_variables"
#include "tob_i0_spells"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 32);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DevotedSpiritStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DevotedSpiritStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);

	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	BasicAttackAnimation(oWeapon, nHit);
	ExpendManeuver(32, "STR");

	if (GetAlignment(oPC) != GetAlignment(oTarget))
	{
		DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget, d6(8)));

		if (nHit > 0)
		{
			int nCha = GetAbilityModifier(ABILITY_CHARISMA, oPC);
			int nDC = GetManeuverDC(nCha, 0, 17);
			int nFortitude = MySavingThrow(SAVING_THROW_FORT, oTarget, nDC);
			effect eVis = EffectVisualEffect(VFX_TOB_CASTIGATING);

			DelayCommand(0.3f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 6.0f));

			if (nFortitude == 0)
			{
				effect eHit = EffectAttackDecrease(2);
				eHit = ExtraordinaryEffect(eHit); // According to page 40 attack roll penalties do not stack.

				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHit, oTarget, 60.0f);
			}

			float fRange = FeetToMeters(30.0f);
			location lTarget = GetLocation(oTarget);
			effect eHoly = EffectVisualEffect(VFX_HIT_SPELL_HOLY);

			object oFoe;
			int nFort, nDamage;
			effect eDamage, eCastigating;

			oFoe = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lTarget, TRUE);

			while (GetIsObjectValid(oFoe))
			{
				if ((oFoe != oPC) && (oFoe != oTarget) && (GetIsReactionTypeHostile(oFoe, oPC)))
				{
					nFort = MySavingThrow(SAVING_THROW_FORT, oFoe, nDC);

					if (nFort == 0)
					{
						nDamage = d6(5);
						eDamage = EffectDamage(nDamage);
						eCastigating = EffectAttackDecrease(2);
						eCastigating = ExtraordinaryEffect(eCastigating);

						DelayCommand(3.3f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oFoe));
						DelayCommand(3.3f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHoly, oFoe));
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCastigating, oFoe, 60.0f);
					}
					else if ((nFort > 0) && (GetHasFeat(6818, oFoe)))
					{
						//Mettle!
						DelayCommand(3.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHoly, oFoe));
					}
					else
					{
						nDamage = d6(5) / 2;
						eDamage = EffectDamage(nDamage);

						DelayCommand(3.3f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oFoe));
						DelayCommand(3.3f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHoly, oFoe));
					}
				}

				oFoe = GetNextObjectInShape(SHAPE_SPHERE, fRange, lTarget, TRUE);
			}
		}
	}
	else DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));
}