//////////////////////////////////////////////////////////
//  Author: Drammel                                     //
//  Date: 10/15/2009                                    //
//  Title: salamander_charge                            //
//  Description: Handles location tracking and damage   //
//  for the maneuver Salamander Charge.                 //
//////////////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"
#include "tob_i0_spells"

void IterateSalNumber()
{
	object oPC = OBJECT_SELF;

	int nNumber = GetLocalInt(oPC, "SalamanderNumber");

	SetLocalInt(oPC, "SalamanderNumber", nNumber + 1);
	SetLocalInt(oPC, "SalamanderTopNumber", nNumber + 1);
}

void DoSalamanderLoc()
{
	object oPC = OBJECT_SELF;
	location lPC = GetLocation(oPC);

	if (GetLocalLocation(oPC, "SalamanderLoc") != lPC) //Checking to see if we stopped moving.
	{
		int nNumber = GetLocalInt(oPC, "SalamanderNumber");

		SetLocalLocation(oPC, "SalamanderLoc", lPC);
		SetLocalLocation(oPC, "SalamanderLoc" + IntToString(nNumber), lPC);
		DelayCommand(0.01f, IterateSalNumber()); //Being paranoid here, but for a good reason.
		DelayCommand(0.5f, DoSalamanderLoc());
	}
	else 
	{
		DeleteLocalInt(oPC, "SalamanderActive");

		effect eTest; //Turning off the fire when movement stops.
	
		eTest = GetFirstEffect(oPC);
	
		while (GetIsEffectValid(eTest))
		{
			if (GetEffectSpellId(eTest) == 6554)
			{
				RemoveEffect(oPC, eTest);
				break;
			}
			eTest = GetNextEffect(oPC);
		}
	}
}

void RunWallHeartDamage(string sPC, int nDC, effect eHit)
{
	object oPC = OBJECT_SELF;

	if (GetLocalInt(oPC, "SalamanderChargeActive") == 1)
	{
		int nLocations = GetLocalInt(oPC, "SalamanderTopNumber");
		float fFive = FeetToMeters(5.0f);

		location lTarget;
		object oTarget;
		int n, nDamage;
		effect eDamage;

		n = 1;
		lTarget = GetLocalLocation(oPC, "SalamanderLoc" + IntToString(n));
		oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fFive, lTarget);

		while (n <= nLocations)
		{
			if ((GetLocalInt(oTarget, "SalWall_" + sPC) == 0) && (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))) //Do damage once per round per character using it.
			{
				nDamage = Bot9sReflexAdjustedDamage(d6(6), oTarget, nDC, SAVING_THROW_TYPE_FIRE);
	
				SetLocalInt(oTarget, "SalWall_" + sPC, 1);
				AssignCommand(oTarget, DelayCommand(5.99f, DeleteLocalInt(oTarget, "SalWall_" + sPC)));
	
				if (nDamage > 0)
				{
					eDamage = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
	
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
				}
			}

			oTarget = GetNextObjectInShape(SHAPE_SPHERE, fFive, lTarget);

			if (!GetIsObjectValid(oTarget)) //Move to the next location.
			{
				n++;
				lTarget = GetLocalLocation(oPC, "SalamanderLoc" + IntToString(n));
				oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fFive, lTarget);
			}
		}

		DelayCommand(0.1f, RunWallHeartDamage(sPC, nDC, eHit)); //Not as bad as it looks since damage can't be applied until after the gateway variable is removed.
	}
}

void RunEdgeHeartDamage(string sPC, int nDC, effect eHit)
{
	object oPC = OBJECT_SELF;

	if (GetLocalInt(oPC, "SalamanderChargeActive") == 1)
	{
		int nLocations = GetLocalInt(oPC, "SalamanderTopNumber");
		float fFive = FeetToMeters(5.0f);
		float fTen = FeetToMeters(10.0f);

		location lTarget;
		object oTarget;
		int n, nDamage;
		effect eDamage;
		float fDist;

		n = 1;
		lTarget = GetLocalLocation(oPC, "SalamanderLoc" + IntToString(n));
		oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fTen, lTarget);

		while (n <= nLocations)
		{
			fDist = GetDistanceBetweenLocations(GetLocation(oTarget), lTarget);

			if (fDist > fFive)
			{
				if ((GetLocalInt(oTarget, "SalEdge_" + sPC) == 0) && (GetLocalInt(oTarget, "SalWall_" + sPC) == 0) && (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))) //Do damage once per round per character using it.
				{
					nDamage = Bot9sReflexAdjustedDamage(d6(3), oTarget, nDC, SAVING_THROW_TYPE_FIRE);

					SetLocalInt(oTarget, "SalEdge_" + sPC, 1);
					AssignCommand(oTarget, DelayCommand(5.99f, DeleteLocalInt(oTarget, "SalEdge_" + sPC)));
		
					if (nDamage > 0)
					{
						eDamage = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);

						ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
						ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
					}
				}
			}

			oTarget = GetNextObjectInShape(SHAPE_SPHERE, fTen, lTarget);
	
			if (!GetIsObjectValid(oTarget)) //Move to the next location.
			{
				n++;
				lTarget = GetLocalLocation(oPC, "SalamanderLoc" + IntToString(n));
				oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fTen, lTarget);
			}
		}

		DelayCommand(6.0f, RunWallHeartDamage(sPC, nDC, eHit));
	}
}

void PostCleanUp()
{
	object oPC = OBJECT_SELF;

	DeleteLocalInt(oPC, "SalamanderTopNumber");
	DeleteLocalInt(oPC, "End_Salamander");
}

void EndEffects()
{
	object oPC = OBJECT_SELF;

	if (GetCurrentHitPoints(oPC) < 1)
	{
		SetLocalInt(oPC, "End_Salamander", 1);
	}

	if (GetLocalInt(oPC, "End_Salamander") == 1)
	{
		DeleteLocalInt(oPC, "SalamanderChargeActive");
		DeleteLocalInt(oPC, "SalamanderActive");
		DeleteLocalInt(oPC, "SalamanderNumber");
		DeleteLocalLocation(oPC, "SalamanderLoc");
	
		int nNumber = GetLocalInt(oPC, "SalamanderTopNumber");
		int n;
	
		n = 1;
	
		while (n <= nNumber) // Reinitiating this maneuver ends previous effects.
		{
			DeleteLocalLocation(oPC, "SalamanderLoc" + IntToString(n));
			n++;
		}

		effect eTest;
	
		eTest = GetFirstEffect(oPC);
	
		while (GetIsEffectValid(eTest))
		{
			if (GetEffectSpellId(eTest) == 6554)
			{
				RemoveEffect(oPC, eTest);
				break;
			}
			eTest = GetNextEffect(oPC);
		}

		DelayCommand(0.1f, PostCleanUp());
	}

	if (GetLocalInt(oPC, "End_Salamander") == 0)
	{
		DelayCommand(0.1f, EndEffects());
	}
}

void SalamanderTimer()
{
	object oPC = OBJECT_SELF;
	int nTimer = GetLocalInt(oPC, "SalamanderTimer");

	if (GetLocalInt(oPC, "End_Salamander") == 1)
	{
		DeleteLocalInt(oPC, "SalamanderTimer");
	}
	else if (nTimer > 29)
	{
		SetLocalInt(oPC, "End_Salamander", 1);
		DeleteLocalInt(oPC, "SalamanderTimer");
	}
	else 
	{
		SetLocalInt(oPC, "SalamanderTimer", nTimer + 1);
		DelayCommand(1.0f, SalamanderTimer());
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	string sPC = GetFirstName(oPC);
	int nWisdom = GetAbilityModifier(ABILITY_WISDOM, oPC);
	int nDC = GetManeuverDC(nWisdom, 0, 17);
	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
	effect eSalamander = EffectVisualEffect(VFX_TOB_FIRETRAIL);
	eSalamander = SetEffectSpellId(eSalamander, 6554);

	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSalamander, oPC);
	DeleteLocalInt(oPC, "SalamanderNumber");
	SetLocalInt(oPC, "SalamanderActive", 1);
	SetLocalInt(oPC, "SalamanderChargeActive", 1);
	DelayCommand(0.5f, EndEffects());
	DelayCommand(0.1f, DoSalamanderLoc());
	DelayCommand(0.11f, RunWallHeartDamage(sPC, nDC, eHit));
	DelayCommand(0.12f, RunEdgeHeartDamage(sPC, nDC, eHit));
	DelayCommand(0.11f, SalamanderTimer());
}