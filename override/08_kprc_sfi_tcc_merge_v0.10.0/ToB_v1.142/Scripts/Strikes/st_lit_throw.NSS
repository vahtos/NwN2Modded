//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 10/27/2009								//
//	Title: st_lit_throw				        		//
//	Description: When you use this strike, you make //
//  a single melee attack (even though you are      //
//  throwing your weapon). You deal damage to each  //
//  creature in the maneuver's area equal to your   //
//  normal melee damage (including damage from your //
//  Strength modifier, feats, magical abilities on  //
//  your weapon, and so forth), plus an extra 12d6  //
//  points of damage. Each creature in the attack's //
//  area can make a Reflex save with a DC equal to  //
//  the result of your attack roll. A successful    //
//  save halves the damage dealt.                   //
//////////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_include"
#include "tob_i0_spells"
#include "tob_x0_i0_position"

void CleanUp()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nLit = GetLocalInt(oToB, "LightningThrowNumber");
	int n;
	object oFoe;

	n = 1;

	while (n < nLit)
	{
		oFoe = GetLocalObject(oToB, "LightningFoe" + IntToString(n));

		if (oFoe == OBJECT_INVALID)
		{
			DeleteLocalInt(oToB, "LightningThrowNumber");
			break;
		}
		else DeleteLocalObject(oToB, "LightningFoe" + IntToString(n));

		n++;
	}
}

void LightningThrow(object oWeapon, object oTarget, int nHit, int nRoll)
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	location lPC = GetLocation(oPC);
	location lLand = GetLocation(oTarget);
	vector vPC = GetPosition(oPC);
	vector vTarget = GetPositionFromLocation(lLand);
	float fFive = FeetToMeters(5.0f); // Preferred number for incrementing because in Pen and Paper rules this is the size of a square.
	float fMax = GetDistanceBetweenLocations(lPC, lLand);
	float fDest = GetAngle(vPC, vTarget, fMax);
	effect eLightning = EffectBeam(VFX_BEAM_LIGHTNING, OBJECT_SELF, BODY_NODE_HAND);

	object oLightning;
	location lLine;
	float fDistance;
	int n, nDamage;

	PlayVoiceChat(VOICE_CHAT_PAIN2, oPC);
	WrapperPlayCustomAnimation(oPC, "Throw", 0);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, oTarget, 1.0);

	n = 1;
	fDistance += fFive; // Five feet out from the PC's origin position.
	lLine = GenerateNewLocation(oPC, fDistance, fDest, fDest);

	if (GetIsLocationValid(lLine))
	{
		oLightning = GetFirstObjectInShape(SHAPE_SPHERE, fFive, lLine);

		while (GetIsObjectValid(oLightning))
		{
			if ((GetIsReactionTypeHostile(oLightning, oPC)) && (GetLocalInt(oLightning, "LightningThrow") == 0))
			{
				SetLocalInt(oLightning, "LightningThrow", 1);
				AssignCommand(oLightning, DelayCommand(0.5f, DeleteLocalInt(oLightning, "LightningThrow")));
				SetLocalObject(oToB, "LightningFoe" + IntToString(n), oLightning);
				n++;
			}

			oLightning = GetNextObjectInShape(SHAPE_SPHERE, fFive, lLine);
		}
	}

	fDistance += fFive; // 10 feet.
	lLine = GenerateNewLocation(oPC, fDistance, fDest, fDest);

	if (GetIsLocationValid(lLine))
	{
		oLightning = GetFirstObjectInShape(SHAPE_SPHERE, fFive, lLine);

		while (GetIsObjectValid(oLightning))
		{
			if ((GetIsReactionTypeHostile(oLightning, oPC)) && (GetLocalInt(oLightning, "LightningThrow") == 0))
			{
				SetLocalInt(oLightning, "LightningThrow", 1);
				AssignCommand(oLightning, DelayCommand(0.5f, DeleteLocalInt(oLightning, "LightningThrow")));
				SetLocalObject(oToB, "LightningFoe" + IntToString(n), oLightning);
				n++;
			}

			oLightning = GetNextObjectInShape(SHAPE_SPHERE, fFive, lLine);
		}
	}

	fDistance += fFive; // 15 feet.
	lLine = GenerateNewLocation(oPC, fDistance, fDest, fDest);

	if (GetIsLocationValid(lLine))
	{
		oLightning = GetFirstObjectInShape(SHAPE_SPHERE, fFive, lLine);

		while (GetIsObjectValid(oLightning))
		{
			if ((GetIsReactionTypeHostile(oLightning, oPC)) && (GetLocalInt(oLightning, "LightningThrow") == 0))
			{
				SetLocalInt(oLightning, "LightningThrow", 1);
				AssignCommand(oLightning, DelayCommand(0.5f, DeleteLocalInt(oLightning, "LightningThrow")));
				SetLocalObject(oToB, "LightningFoe" + IntToString(n), oLightning);
				n++;
			}

			oLightning = GetNextObjectInShape(SHAPE_SPHERE, fFive, lLine);
		}
	}

	fDistance += fFive; // 20 feet.
	lLine = GenerateNewLocation(oPC, fDistance, fDest, fDest);

	if (GetIsLocationValid(lLine))
	{
		oLightning = GetFirstObjectInShape(SHAPE_SPHERE, fFive, lLine);

		while (GetIsObjectValid(oLightning))
		{
			if ((GetIsReactionTypeHostile(oLightning, oPC)) && (GetLocalInt(oLightning, "LightningThrow") == 0))
			{
				SetLocalInt(oLightning, "LightningThrow", 1);
				AssignCommand(oLightning, DelayCommand(0.5f, DeleteLocalInt(oLightning, "LightningThrow")));
				SetLocalObject(oToB, "LightningFoe" + IntToString(n), oLightning);
				n++;
			}

			oLightning = GetNextObjectInShape(SHAPE_SPHERE, fFive, lLine);
		}
	}

	fDistance += fFive; // 25 feet.
	lLine = GenerateNewLocation(oPC, fDistance, fDest, fDest);

	if (GetIsLocationValid(lLine))
	{
		oLightning = GetFirstObjectInShape(SHAPE_SPHERE, fFive, lLine);

		while (GetIsObjectValid(oLightning))
		{
			if ((GetIsReactionTypeHostile(oLightning, oPC)) && (GetLocalInt(oLightning, "LightningThrow") == 0))
			{
				SetLocalInt(oLightning, "LightningThrow", 1);
				AssignCommand(oLightning, DelayCommand(0.5f, DeleteLocalInt(oLightning, "LightningThrow")));
				SetLocalObject(oToB, "LightningFoe" + IntToString(n), oLightning);
				n++;
			}

			oLightning = GetNextObjectInShape(SHAPE_SPHERE, fFive, lLine);
		}
	}

	fDistance += fFive; // 30 feet.
	lLine = GenerateNewLocation(oPC, fDistance, fDest, fDest);

	if (GetIsLocationValid(lLine))
	{
		oLightning = GetFirstObjectInShape(SHAPE_SPHERE, fFive, lLine);

		while (GetIsObjectValid(oLightning))
		{
			if ((GetIsReactionTypeHostile(oLightning, oPC)) && (GetLocalInt(oLightning, "LightningThrow") == 0))
			{
				SetLocalInt(oLightning, "LightningThrow", 1);
				AssignCommand(oLightning, DelayCommand(0.5f, DeleteLocalInt(oLightning, "LightningThrow")));
				SetLocalObject(oToB, "LightningFoe" + IntToString(n), oLightning);
				n++;
			}

			oLightning = GetNextObjectInShape(SHAPE_SPHERE, fFive, lLine);
		}
	}

	fDistance += fFive; // 35 feet. 
	lLine = GenerateNewLocation(oPC, fDistance, fDest, fDest);

	if (GetIsLocationValid(lLine))
	{
		oLightning = GetFirstObjectInShape(SHAPE_SPHERE, fFive, lLine);

		while (GetIsObjectValid(oLightning))
		{
			if ((GetIsReactionTypeHostile(oLightning, oPC)) && (GetLocalInt(oLightning, "LightningThrow") == 0))
			{
				SetLocalInt(oLightning, "LightningThrow", 1);
				AssignCommand(oLightning, DelayCommand(0.5f, DeleteLocalInt(oLightning, "LightningThrow")));
				SetLocalObject(oToB, "LightningFoe" + IntToString(n), oLightning);
				n++;
			}

			oLightning = GetNextObjectInShape(SHAPE_SPHERE, fFive, lLine);
		}
	}

	SetLocalInt(oToB, "LightningThrowNumber", n);

	object oFoe1 = GetLocalObject(oToB, "LightningFoe1");

	if (GetIsObjectValid(oFoe1))
	{
		nDamage = Bot9sReflexAdjustedDamage(d6(12), oFoe1, nRoll);

		if (nDamage > 0)
		{
			StrikeWeaponDamage(oWeapon, nHit, oFoe1, nDamage);
		}
	}

	object oFoe2 = GetLocalObject(oToB, "LightningFoe2");

	if (GetIsObjectValid(oFoe2))
	{
		nDamage = Bot9sReflexAdjustedDamage(d6(12), oFoe2, nRoll);

		if (nDamage > 0)
		{
			StrikeWeaponDamage(oWeapon, nHit, oFoe2, nDamage);
		}
	}

	object oFoe3 = GetLocalObject(oToB, "LightningFoe3");

	if (GetIsObjectValid(oFoe3))
	{
		nDamage = Bot9sReflexAdjustedDamage(d6(12), oFoe3, nRoll);

		if (nDamage > 0)
		{
			StrikeWeaponDamage(oWeapon, nHit, oFoe3, nDamage);
		}
	}

	object oFoe4 = GetLocalObject(oToB, "LightningFoe4");

	if (GetIsObjectValid(oFoe4))
	{
		nDamage = Bot9sReflexAdjustedDamage(d6(12), oFoe4, nRoll);

		if (nDamage > 0)
		{
			StrikeWeaponDamage(oWeapon, nHit, oFoe4, nDamage);
		}
	}

	object oFoe5 = GetLocalObject(oToB, "LightningFoe5");

	if (GetIsObjectValid(oFoe5))
	{
		nDamage = Bot9sReflexAdjustedDamage(d6(12), oFoe5, nRoll);

		if (nDamage > 0)
		{
			StrikeWeaponDamage(oWeapon, nHit, oFoe5, nDamage);
		}
	}

	object oFoe6 = GetLocalObject(oToB, "LightningFoe6");

	if (GetIsObjectValid(oFoe6))
	{
		nDamage = Bot9sReflexAdjustedDamage(d6(12), oFoe6, nRoll);

		if (nDamage > 0)
		{
			StrikeWeaponDamage(oWeapon, nHit, oFoe6, nDamage);
		}
	}

	object oFoe7 = GetLocalObject(oToB, "LightningFoe7");

	if (GetIsObjectValid(oFoe7))
	{
		nDamage = Bot9sReflexAdjustedDamage(d6(12), oFoe7, nRoll);

		if (nDamage > 0)
		{
			StrikeWeaponDamage(oWeapon, nHit, oFoe7, nDamage);
		}
	}

	object oFoe8 = GetLocalObject(oToB, "LightningFoe8");

	if (GetIsObjectValid(oFoe8))
	{
		nDamage = Bot9sReflexAdjustedDamage(d6(12), oFoe8, nRoll);

		if (nDamage > 0)
		{
			StrikeWeaponDamage(oWeapon, nHit, oFoe8, nDamage);
		}
	}

	object oFoe9 = GetLocalObject(oToB, "LightningFoe9");

	if (GetIsObjectValid(oFoe9))
	{
		nDamage = Bot9sReflexAdjustedDamage(d6(12), oFoe9, nRoll);

		if (nDamage > 0)
		{
			StrikeWeaponDamage(oWeapon, nHit, oFoe9, nDamage);
		}
	}

	object oFoe10 = GetLocalObject(oToB, "LightningFoe10");

	if (GetIsObjectValid(oFoe10))
	{
		nDamage = Bot9sReflexAdjustedDamage(d6(12), oFoe10, nRoll);

		if (nDamage > 0)
		{
			StrikeWeaponDamage(oWeapon, nHit, oFoe10, nDamage);
		}
	}

	object oFoe11 = GetLocalObject(oToB, "LightningFoe11");

	if (GetIsObjectValid(oFoe11))
	{
		nDamage = Bot9sReflexAdjustedDamage(d6(12), oFoe11, nRoll);

		if (nDamage > 0)
		{
			StrikeWeaponDamage(oWeapon, nHit, oFoe11, nDamage);
		}
	}

	object oFoe12 = GetLocalObject(oToB, "LightningFoe12");

	if (GetIsObjectValid(oFoe12))
	{
		nDamage = Bot9sReflexAdjustedDamage(d6(12), oFoe12, nRoll);

		if (nDamage > 0)
		{
			StrikeWeaponDamage(oWeapon, nHit, oFoe12, nDamage);
		}
	}

	object oFoe13 = GetLocalObject(oToB, "LightningFoe13");

	if (GetIsObjectValid(oFoe13))
	{
		nDamage = Bot9sReflexAdjustedDamage(d6(12), oFoe13, nRoll);

		if (nDamage > 0)
		{
			StrikeWeaponDamage(oWeapon, nHit, oFoe13, nDamage);
		}
	}

	object oFoe14 = GetLocalObject(oToB, "LightningFoe14");

	if (GetIsObjectValid(oFoe14))
	{
		nDamage = Bot9sReflexAdjustedDamage(d6(12), oFoe14, nRoll);

		if (nDamage > 0)
		{
			StrikeWeaponDamage(oWeapon, nHit, oFoe14, nDamage);
		}
	}

	object oFoe15 = GetLocalObject(oToB, "LightningFoe15");

	if (GetIsObjectValid(oFoe15))
	{
		nDamage = Bot9sReflexAdjustedDamage(d6(12), oFoe15, nRoll);

		if (nDamage > 0)
		{
			StrikeWeaponDamage(oWeapon, nHit, oFoe15, nDamage);
		}
	}

	object oFoe16 = GetLocalObject(oToB, "LightningFoe16");

	if (GetIsObjectValid(oFoe16))
	{
		nDamage = Bot9sReflexAdjustedDamage(d6(12), oFoe16, nRoll);

		if (nDamage > 0)
		{
			StrikeWeaponDamage(oWeapon, nHit, oFoe16, nDamage);
		}
	}

	object oFoe17 = GetLocalObject(oToB, "LightningFoe17");

	if (GetIsObjectValid(oFoe17))
	{
		nDamage = Bot9sReflexAdjustedDamage(d6(12), oFoe17, nRoll);

		if (nDamage > 0)
		{
			StrikeWeaponDamage(oWeapon, nHit, oFoe17, nDamage);
		}
	}

	object oFoe18 = GetLocalObject(oToB, "LightningFoe18");

	if (GetIsObjectValid(oFoe18))
	{
		nDamage = Bot9sReflexAdjustedDamage(d6(12), oFoe18, nRoll);

		if (nDamage > 0)
		{
			StrikeWeaponDamage(oWeapon, nHit, oFoe18, nDamage);
		}
	}

	object oFoe19 = GetLocalObject(oToB, "LightningFoe19");

	if (GetIsObjectValid(oFoe19))
	{
		nDamage = Bot9sReflexAdjustedDamage(d6(12), oFoe19, nRoll);

		if (nDamage > 0)
		{
			StrikeWeaponDamage(oWeapon, nHit, oFoe19, nDamage);
		}
	}

	object oFoe20 = GetLocalObject(oToB, "LightningFoe20");

	if (GetIsObjectValid(oFoe20))
	{
		nDamage = Bot9sReflexAdjustedDamage(d6(12), oFoe20, nRoll);

		if (nDamage > 0)
		{
			StrikeWeaponDamage(oWeapon, nHit, oFoe20, nDamage);
		}
	}

	AssignCommand(oPC, CleanUp());
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 87);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "IronHeartStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "IronHeartStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);
	int nRoll = GetLocalInt(oToB, "AttackRollResult");

	TurnToFaceObject(oTarget, oPC);
	ExpendManeuver(87, "STR");
	DelayCommand(0.5f, LightningThrow(oWeapon, oTarget, nHit, nRoll)); //Time to turn and get a correct facing value.
}