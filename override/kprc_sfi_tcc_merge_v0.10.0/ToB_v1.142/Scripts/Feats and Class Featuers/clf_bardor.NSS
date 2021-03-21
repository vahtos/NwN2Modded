//////////////////////////////////////////////////////////////
//	Author: Drammel											//
//	Date: May Day 2009										//
//	Name: clf_bardor									    //
//	Description: Grants a bonus to the PC's critical 		//
//	confirmation mod on strikes and occassionally adds		//
//	weapon damage to the PC's attacks.  This extra damage is//
//	intended to average out to the same amount of damage a	//
//	straight bonus to the PC's crit confirmation mod would	//
//	add, were it possible to directly modify.  Also, the 	//
//	Warblade's int bonus is included in StrikeAttackRoll.	//
//////////////////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_feats"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"
#include "bot9s_weapon"

effect TallyDamage(object oWeapon, object oPC, object oFoe)
{
	struct main_damage rDamage = GenerateAttackEffect(oPC, oWeapon, oFoe);
	int bIgnoreResistances = FALSE;

	int nSlash = rDamage.nSlash;
	int nBlunt = rDamage.nBlunt;
	int nPierce = rDamage.nPierce;
	int nAcid = rDamage.nAcid;
	int nFire = rDamage.nFire;
	int nCold = rDamage.nCold;
	int nElec = rDamage.nElec;
	int nSonic = rDamage.nSonic;
	int nDivine = rDamage.nDivine;
	int nMagic = rDamage.nMagic;
	int nPosit = rDamage.nPosit;
	int nNegat = rDamage.nNegat;

	effect eLink;

	eLink = EffectDamage(nPierce, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL, bIgnoreResistances);

	if (nAcid > 0)
	{
		effect eDmg = EffectDamage(nAcid, DAMAGE_TYPE_ACID, DAMAGE_POWER_NORMAL, bIgnoreResistances);
		eLink = EffectLinkEffects(eDmg, eLink);
	}

	if (nSlash > 0)
	{
		effect eDmg = EffectDamage(nSlash, DAMAGE_TYPE_SLASHING, DAMAGE_POWER_NORMAL, bIgnoreResistances);
		eLink = EffectLinkEffects(eDmg, eLink);
	}

	if (nBlunt > 0)
	{
		effect eDmg = EffectDamage(nBlunt, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL, bIgnoreResistances);
		eLink = EffectLinkEffects(eDmg, eLink);
	}

	if (nCold > 0)
	{
		effect eDmg = EffectDamage(nCold, DAMAGE_TYPE_COLD, DAMAGE_POWER_NORMAL, bIgnoreResistances);
		eLink = EffectLinkEffects(eDmg, eLink);
	}			

	if (nElec > 0)
	{
		effect eDmg = EffectDamage(nElec, DAMAGE_TYPE_ELECTRICAL, DAMAGE_POWER_NORMAL, bIgnoreResistances);
		eLink = EffectLinkEffects(eDmg, eLink);
	}

	if (nFire > 0)
	{
		effect eDmg = EffectDamage(nFire, DAMAGE_TYPE_FIRE, DAMAGE_POWER_NORMAL, bIgnoreResistances);
		eLink = EffectLinkEffects(eDmg, eLink);
	}

	if (nSonic > 0)
	{
		effect eDmg = EffectDamage(nSonic, DAMAGE_TYPE_SONIC, DAMAGE_POWER_NORMAL, bIgnoreResistances);
		eLink = EffectLinkEffects(eDmg, eLink);
	}		

	if (nDivine > 0)
	{
		effect eDmg = EffectDamage(nDivine, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_NORMAL, bIgnoreResistances);
		eLink = EffectLinkEffects(eDmg, eLink);
	}			

	if (nMagic > 0)
	{
		effect eDmg = EffectDamage(nMagic, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL, bIgnoreResistances);
		eLink = EffectLinkEffects(eDmg, eLink);
	}

	if (nPosit > 0)
	{
		effect eDmg = EffectDamage(nPosit, DAMAGE_TYPE_POSITIVE, DAMAGE_POWER_NORMAL, bIgnoreResistances);
		eLink = EffectLinkEffects(eDmg, eLink);
	}

	if (nNegat > 0)
	{
		effect eDmg = EffectDamage(nNegat, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_NORMAL, bIgnoreResistances);
		eLink = EffectLinkEffects(eDmg, eLink);
	}

	return eLink;
}

void BattleArdor()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6528);

	if (GetIsInCombat(oPC) && (GetCurrentAction(oPC) == ACTION_ATTACKOBJECT))
	{
		int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
		object oTarget = GetAttackTarget(oPC); //Clears at the end of every round.
		float fRange = GetMeleeRange(oPC);

		if ((nInt > 0) && (GetDistanceBetween(oPC, oTarget) <= fRange) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)))
		{
			object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
			object oOffHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

			SetLocalObject(oToB, "BArdorTarget", oTarget);

			object oFoe = GetLocalObject(oToB, "BArdorTarget");
			int nRoll = StrikeAttackRoll(oWeapon, oFoe, 0, FALSE, nInt);
			int nOffHand;

			if ((GetIsObjectValid(oOffHand)) && (d100(1) > 50)) //Because this function is run on every attack we're rolling twice for crits.  The d100 roll is to balance that out.
			{
				nOffHand = StrikeAttackRoll(oOffHand, oFoe, 0, FALSE, nInt);
			}
			else nOffHand = 0;

			if ((nRoll == 2) && (d100(1) > 50))
			{
				effect eDamage = TallyDamage(oWeapon, oPC, oFoe);

				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oFoe);
			}
				
			if (nOffHand == 2)
			{
				effect eLHDamage = TallyDamage(oWeapon, oPC, oFoe);

				ApplyEffectToObject(DURATION_TYPE_INSTANT, eLHDamage, oFoe);
			}

			int nRHandAttacks, nLHandAttacks;
			int nBAB = GetTRUEBaseAttackBonus(oPC);

			switch (nBAB)
			{
				case 0:	nRHandAttacks = 1; break;
				case 1:	nRHandAttacks = 1; break;
				case 2:	nRHandAttacks = 1; break;
				case 3:	nRHandAttacks = 1; break;
				case 4:	nRHandAttacks = 1; break;
				case 5:	nRHandAttacks = 1; break;
				case 6:	nRHandAttacks = 2; break;
				case 7:	nRHandAttacks = 2; break;
				case 8:	nRHandAttacks = 2; break;
				case 9:	nRHandAttacks = 2; break;
				case 10:nRHandAttacks = 2; break;
				case 11:nRHandAttacks = 3; break;
				case 12:nRHandAttacks = 3; break;
				case 13:nRHandAttacks = 3; break;
				case 14:nRHandAttacks = 3; break;
				case 15:nRHandAttacks = 3; break;
				case 16:nRHandAttacks = 4; break;
				case 17:nRHandAttacks = 4; break;
				case 18:nRHandAttacks = 4; break;
				case 19:nRHandAttacks = 4; break;
				case 20:nRHandAttacks = 5; break;
				case 21:nRHandAttacks = 5; break;
				case 22:nRHandAttacks = 5; break;
				case 23:nRHandAttacks = 5; break;
				case 24:nRHandAttacks = 5; break;
				default:nRHandAttacks = 6; break;
			}

			if (GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)))
			{
				if (GetHasFeat(FEAT_EPIC_PERFECT_TWO_WEAPON_FIGHTING, oPC) || GetHasFeat(FEAT_COMBATSTYLE_RANGER_DUAL_WIELD_PERFECT_TWO_WEAPON_FIGHTING, oPC, TRUE))
				{
					int nBAB2 = GetTRUEBaseAttackBonus(oPC);

					switch (nBAB2)
					{
						case 0:	nLHandAttacks = 1; break;
						case 1:	nLHandAttacks = 1; break;
						case 2:	nLHandAttacks = 1; break;
						case 3:	nLHandAttacks = 1; break;
						case 4:	nLHandAttacks = 1; break;
						case 5:	nLHandAttacks = 1; break;
						case 6:	nLHandAttacks = 2; break;
						case 7:	nLHandAttacks = 2; break;
						case 8:	nLHandAttacks = 2; break;
						case 9:	nLHandAttacks = 2; break;
						case 10:nLHandAttacks = 2; break;
						case 11:nLHandAttacks = 3; break;
						case 12:nLHandAttacks = 3; break;
						case 13:nLHandAttacks = 3; break;
						case 14:nLHandAttacks = 3; break;
						case 15:nLHandAttacks = 3; break;
						case 16:nLHandAttacks = 4; break;
						case 17:nLHandAttacks = 4; break;
						case 18:nLHandAttacks = 4; break;
						case 19:nLHandAttacks = 4; break;
						case 20:nLHandAttacks = 5; break;
						case 21:nLHandAttacks = 5; break;
						case 22:nLHandAttacks = 5; break;
						case 23:nLHandAttacks = 5; break;
						case 24:nLHandAttacks = 5; break;
						default:nLHandAttacks = 6; break;
					}
				}
				else if (GetHasFeat(FEAT_GREATER_TWO_WEAPON_FIGHTING, oPC))
				{
					nLHandAttacks = 3;
				}
				else if (GetHasFeat(FEAT_IMPROVED_TWO_WEAPON_FIGHTING, oPC))
				{
					nLHandAttacks = 2;
				}
				else nLHandAttacks = 1;
			}
			else nLHandAttacks = 0;

			if ((nRHandAttacks > 1) && (d100(1) > 50)) // Two attacks.
			{
				int nHit2 = StrikeAttackRoll(oWeapon, oTarget, -5, FALSE, nInt);

				if (nHit2 == 2)
				{
					effect eDamage2 = TallyDamage(oWeapon, oPC, oFoe);
					DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage2, oFoe));
				}
			}

			if ((nLHandAttacks > 1) && (d100(1) > 50))
			{
				int nLeft2 = StrikeAttackRoll(oOffHand, oTarget, -5, FALSE, nInt);
				
				if (nLeft2 == 2)
				{
					effect eLHDamage2 = TallyDamage(oWeapon, oPC, oFoe);
					DelayCommand(1.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLHDamage2, oFoe));
				}
			}

			if ((nRHandAttacks > 2) && (d100(1) > 50)) // Three attacks.
			{
				int nHit3 = StrikeAttackRoll(oWeapon, oTarget, -10, FALSE, nInt);
				
				if (nHit3 == 2)
				{
					effect eDamage3 = TallyDamage(oWeapon, oPC, oFoe);
					DelayCommand(2.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage3, oFoe));
				}
			}

			if ((nLHandAttacks > 2) && (d100(1) > 50))
			{
				int nLeft3 = StrikeAttackRoll(oOffHand, oTarget, -10, FALSE, nInt);
				
				if (nLeft3 == 2)
				{
					effect eLHDamage3 = TallyDamage(oWeapon, oPC, oFoe);
					DelayCommand(2.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLHDamage3, oFoe));
				}
			}

			if ((nRHandAttacks > 3) && (d100(1) > 50)) // Four attacks.
			{
				int nHit4 = StrikeAttackRoll(oWeapon, oTarget, -15, FALSE, nInt);
				
				if (nHit4 == 2)
				{
					effect eDamage4 = TallyDamage(oWeapon, oPC, oFoe);
					DelayCommand(3.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage4, oFoe));
				}
			}

			if ((nLHandAttacks > 3) && (d100(1) > 50))
			{
				int nLeft4 = StrikeAttackRoll(oOffHand, oTarget, -15, FALSE, nInt);
				
				if (nLeft4 == 2)
				{
					effect eLHDamage4 = TallyDamage(oWeapon, oPC, oFoe);
					DelayCommand(3.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLHDamage4, oFoe));
				}
			}

			if ((nRHandAttacks > 4) && (d100(1) > 50)) // Five attacks.
			{
				int nHit5 = StrikeAttackRoll(oWeapon, oTarget, -20, FALSE, nInt);
				
				if (nHit5 == 2)
				{
					effect eDamage5 = TallyDamage(oWeapon, oPC, oFoe);
					DelayCommand(4.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage5, oFoe));
				}
			}

			if ((nLHandAttacks > 4) && (d100(1) > 50))
			{
				int nLeft5 = StrikeAttackRoll(oOffHand, oTarget, -20, FALSE, nInt);
				
				if (nLeft5 == 2)
				{
					effect eLHDamage5 = TallyDamage(oWeapon, oPC, oFoe);
					DelayCommand(4.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLHDamage5, oFoe));
				}
			}

			if ((nRHandAttacks > 5) && (d100(1) > 50)) // Six attacks.
			{
				int nHit6 = StrikeAttackRoll(oWeapon, oTarget, -25, FALSE, nInt);
				
				if (nHit6 == 2)
				{
					effect eDamage6 = TallyDamage(oWeapon, oPC, oFoe);
					DelayCommand(5.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage6, oFoe));
				}
			}

			if ((nLHandAttacks > 5) && (d100(1) > 50))
			{
				int nLeft6 = StrikeAttackRoll(oOffHand, oTarget, -25, FALSE, nInt);
				
				if (nLeft6 == 2)
				{
					effect eLHDamage6 = TallyDamage(oWeapon, oPC, oFoe);
					DelayCommand(5.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLHDamage6, oFoe));
				}
			}

			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
			DelayCommand(6.0f, BattleArdor());
		}
		else
		{
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
			DelayCommand(6.0f, BattleArdor());
		}
	}
	else 
	{
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 1.0f);
		DelayCommand(1.0f, BattleArdor());
	}
}

void CheckLoopEffect()
{
	if(!CheckRecursive(6528))
	{
		BattleArdor(); //Only runs if the effect is no longer on the player.
	}
}

void main()
{
	DelayCommand(6.0f, CheckLoopEffect()); // Needs to be delayed because when the feat fires after resting the engine doesn't detect effects immeadiately.
}