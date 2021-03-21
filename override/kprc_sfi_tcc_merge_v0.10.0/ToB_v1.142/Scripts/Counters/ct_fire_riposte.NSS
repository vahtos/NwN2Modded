//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 8/21/2009									//
//	Title: ct_fire_riposte							//
//	Description: When a creature successfully 		//
//  strikes you with a melee or natural weapon, you //
//  can use this maneuver to give yourself the 		//
//  ability to make an immediate melee touch attack.//
//  If your attack hits, your target takes 4d6 		//
//  points of fire damage.							//
//////////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"

void FireRiposte(object oPC, object oToB)
{
	if (ValidateCounter(10))
	{
		object oAttacker = GetLastDamager();
		object oAttacked = GetAttackTarget(oAttacker);

		if ((oPC == oAttacked) && (GetDistanceBetween(oPC, oAttacker) - GetGirth(oAttacker) <= FeetToMeters(8.0f)))
		{
			int nMyHp = GetLocalInt(oToB, "FireRiposteHP");
			int nMyHp2 = GetCurrentHitPoints();
	
			if (nMyHp > nMyHp2)
			{
				int nTouch = TouchAttackMelee(oAttacker);

				if (nTouch > 0)
				{
					effect eFire, eFireRiposte;
					effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);

					if (nTouch == 1)
					{
						eFire = EffectDamage(d6(4), DAMAGE_TYPE_FIRE);
						eFireRiposte = EffectLinkEffects(eFire, eVis);
						
					}
					else //Crit
					{
						eFire = EffectDamage(d6(8), DAMAGE_TYPE_FIRE);
						eFireRiposte = EffectLinkEffects(eFire, eVis);
					}

					ApplyEffectToObject(DURATION_TYPE_INSTANT, eFireRiposte, oAttacker);
					FloatingTextStringOnCreature("<color=cyan>*Fire Riposte!*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
					RunSwiftAction(10, "C");
				}
			}
			else DelayCommand(0.1f, FireRiposte(oPC, oToB));
		}
		else DelayCommand(0.1f, FireRiposte(oPC, oToB));
	}
}

void RunRoundHealth(object oPC, object oToB)
{
	if (ValidateCounter(10))
	{
		SetLocalInt(oToB, "FireRiposteHP", GetCurrentHitPoints());
		DelayCommand(6.0f, RunRoundHealth(oPC, oToB));
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	ExpendManeuver(10, "C");
	SetLocalInt(oToB, "FireRiposteHP", GetCurrentHitPoints());
	DelayCommand(6.0f, RunRoundHealth(oPC, oToB));
	FireRiposte(oPC, oToB);
}