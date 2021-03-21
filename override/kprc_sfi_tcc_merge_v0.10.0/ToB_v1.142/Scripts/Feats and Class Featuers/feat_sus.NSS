//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: April Fool's Day 2009						//
//	Title: feat_sus									//
//	Description: Improves unarmed damage based on	//
//	class, size and level.							//
//////////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_feats"
#include "bot9s_inc_maneuvers"
#include "bot9s_inc_variables"

void SuperiorUnarmedStrike()
{
	object oPC = OBJECT_SELF;
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
	int nMonk  = GetLevelByClass(CLASS_TYPE_MONK, oPC) + GetLevelByClass(CLASS_TYPE_SACREDFIST, oPC);
	int nNotMonk = GetHitDice(oPC) - nMonk;
	int nMySize = GetCreatureSize(oPC);
	int nFists;
	int nMonkFists;

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6512);
	
	if ((nMonk == 0) && (oWeapon == OBJECT_INVALID))// Applies to all sizes oddly enough.
	{
		switch (nNotMonk)
		{
			case 1:	 nFists = nFists + d2();	break;
			case 2:	 nFists = nFists + d2();	break;
			case 3:	 nFists = nFists + d4();	break;
			case 4:	 nFists = nFists + d6();	break;
			case 5:	 nFists = nFists + d6();	break;
			case 6:	 nFists = nFists + d6();	break;
			case 7:	 nFists = nFists + d6();	break;
			case 8:	 nFists = nFists + d8();	break;
			case 9:	 nFists = nFists + d8();	break;
			case 10: nFists = nFists + d8();	break;
			case 11: nFists = nFists + d8();	break;
			case 12: nFists = nFists + d10();	break;
			case 13: nFists = nFists + d10();	break;
			case 14: nFists = nFists + d10();	break;
			case 15: nFists = nFists + d10();	break;
			case 16: nFists = nFists + d6(2);	break;
			case 17: nFists = nFists + d6(2);	break;
			case 18: nFists = nFists + d6(2);	break;
			case 19: nFists = nFists + d6(2);	break;
			case 20: nFists = nFists + d6(2);	break;
			case 21: nFists = nFists + d8(2);	break;
			case 22: nFists = nFists + d8(2);	break;
			case 23: nFists = nFists + d8(2);	break;
			case 24: nFists = nFists + d8(2);	break;
			case 25: nFists = nFists + d10(2);	break;
			case 26: nFists = nFists + d10(2);	break;
			case 27: nFists = nFists + d10(2);	break;
			case 28: nFists = nFists + d10(2);	break;
			case 29: nFists = nFists + d6(4);	break;
			case 30: nFists = nFists + d6(4);	break;
		}
	}
	else if ((nMySize == CREATURE_SIZE_TINY || nMySize == CREATURE_SIZE_SMALL) && (oWeapon == OBJECT_INVALID))
	{
		switch (nMonk)
		{
			case 1: nMonkFists = nMonkFists + d2();		break;
			case 2: nMonkFists = nMonkFists + d2();		break;
			case 3: nMonkFists = nMonkFists + d2();		break;
			case 4: nMonkFists = nMonkFists + d2();		break;
			case 5: nMonkFists = nMonkFists + d2();		break;
			case 6: nMonkFists = nMonkFists + d2();		break;
			case 7: nMonkFists = nMonkFists + d2();		break;
			case 8: nMonkFists = nMonkFists + d2();		break;
			case 9: nMonkFists = nMonkFists + d2();		break;
			case 10:nMonkFists = nMonkFists + d2();		break;
			case 11:nMonkFists = nMonkFists + d2();		break;
			case 12:nMonkFists = nMonkFists + d4();		break;
			case 13:nMonkFists = nMonkFists + d4();		break;
			case 14:nMonkFists = nMonkFists + d4();		break;
			case 15:nMonkFists = nMonkFists + d4();		break;
			case 16:nMonkFists = nMonkFists + d4();		break;
			case 17:nMonkFists = nMonkFists + d4();		break;
			case 18:nMonkFists = nMonkFists + d4();		break;
			case 19:nMonkFists = nMonkFists + d4();		break;
			case 20:nMonkFists = nMonkFists + d4();		break;
			case 21:nMonkFists = nMonkFists + d4();		break;
			case 22:nMonkFists = nMonkFists + d4();		break;
			case 23:nMonkFists = nMonkFists + d4();		break;
			case 24:nMonkFists = nMonkFists + d6();		break;
			case 25:nMonkFists = nMonkFists + d6();		break;
			case 26:nMonkFists = nMonkFists + d6();		break;
			case 27:nMonkFists = nMonkFists + d6();		break;
			case 28:nMonkFists = nMonkFists + d6();		break;
			case 29:nMonkFists = nMonkFists + d6();		break;
			case 30:nMonkFists = nMonkFists + d6();		break;
		}
	}
	else if (nMySize == CREATURE_SIZE_MEDIUM && oWeapon == OBJECT_INVALID)
	{
		switch (nMonk)
		{
			case 1: nMonkFists = nMonkFists + d2();		break;
			case 2: nMonkFists = nMonkFists + d2();		break;
			case 3: nMonkFists = nMonkFists + d2();		break;
			case 4: nMonkFists = nMonkFists + d4();		break;
			case 5: nMonkFists = nMonkFists + d4();		break;
			case 6: nMonkFists = nMonkFists + d4();		break;
			case 7: nMonkFists = nMonkFists + d4();		break;
			case 8: nMonkFists = nMonkFists + d4();		break;
			case 9: nMonkFists = nMonkFists + d4();		break;
			case 10:nMonkFists = nMonkFists + d4();		break;
			case 11:nMonkFists = nMonkFists + d4();		break;
			case 12:nMonkFists = nMonkFists + d4();		break;
			case 13:nMonkFists = nMonkFists + d4();		break;
			case 14:nMonkFists = nMonkFists + d4();		break;
			case 15:nMonkFists = nMonkFists + d4();		break;
			case 16:nMonkFists = nMonkFists + d6();		break;
			case 17:nMonkFists = nMonkFists + d6();		break;
			case 18:nMonkFists = nMonkFists + d6();		break;
			case 19:nMonkFists = nMonkFists + d6();		break;
			case 20:nMonkFists = nMonkFists + d6();		break;
			case 21:nMonkFists = nMonkFists + d6();		break;
			case 22:nMonkFists = nMonkFists + d6();		break;
			case 23:nMonkFists = nMonkFists + d8();		break;
			case 24:nMonkFists = nMonkFists + d8();		break;
			case 25:nMonkFists = nMonkFists + d8();		break;
			case 26:nMonkFists = nMonkFists + d8();		break;
			case 27:nMonkFists = nMonkFists + d8();		break;
			case 28:nMonkFists = nMonkFists + d8();		break;
			case 29:nMonkFists = nMonkFists + d8();		break;
			case 30:nMonkFists = nMonkFists + d8();		break;
		}
	}
	else if (nMySize > CREATURE_SIZE_MEDIUM && oWeapon == OBJECT_INVALID)
	{
		switch (nMonk)
		{
			case 1: nMonkFists = nMonkFists + d2();		break;
			case 2: nMonkFists = nMonkFists + d2();		break;
			case 3: nMonkFists = nMonkFists + d2();		break;
			case 4: nMonkFists = nMonkFists + d6();		break;
			case 5: nMonkFists = nMonkFists + d6();		break;
			case 6: nMonkFists = nMonkFists + d6();		break;
			case 7: nMonkFists = nMonkFists + d6();		break;
			case 8: nMonkFists = nMonkFists + d6();		break;
			case 9: nMonkFists = nMonkFists + d6();		break;
			case 10:nMonkFists = nMonkFists + d6();		break;
			case 11:nMonkFists = nMonkFists + d6();		break;
			case 12:nMonkFists = nMonkFists + d8();		break;
			case 13:nMonkFists = nMonkFists + d8();		break;
			case 14:nMonkFists = nMonkFists + d8();		break;
			case 15:nMonkFists = nMonkFists + d8();		break;
			case 16:nMonkFists = nMonkFists + d8();		break;
			case 17:nMonkFists = nMonkFists + d8();		break;
			case 18:nMonkFists = nMonkFists + d8();		break;
			case 19:nMonkFists = nMonkFists + d8();		break;
			case 20:nMonkFists = nMonkFists + d10();	break;
			case 21:nMonkFists = nMonkFists + d10();	break;
			case 22:nMonkFists = nMonkFists + d10();	break;
			case 23:nMonkFists = nMonkFists + d10();	break;
			case 24:nMonkFists = nMonkFists + d10();	break;
			case 25:nMonkFists = nMonkFists + d10();	break;
			case 26:nMonkFists = nMonkFists + d10();	break;
			case 27:nMonkFists = nMonkFists + d10();	break;
			case 28:nMonkFists = nMonkFists + d12();	break;
			case 29:nMonkFists = nMonkFists + d12();	break;
			case 30:nMonkFists = nMonkFists + d12();	break;
		}
	}

	if (!GetIsObjectValid(oWeapon))
	{
		effect eDamage;
		int nDamage;

		if (GetLevelByClass(CLASS_TYPE_MONK, oPC) > 15)
		{
			nDamage = GetConstDamageBonusFromNumber(nMonkFists + nFists);
			eDamage = EffectDamageIncrease(nDamage, DAMAGE_TYPE_MAGICAL);
			eDamage = SupernaturalEffect(eDamage);
		}
		else
		{
			nDamage = GetConstDamageBonusFromNumber(nMonkFists + nFists);
			eDamage = EffectDamageIncrease(nDamage, DAMAGE_TYPE_BLUDGEONING);
			eDamage = SupernaturalEffect(eDamage);
		}
		
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDamage, oPC, 1.0f);
	}

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 1.0f);
	DelayCommand(1.0f, SuperiorUnarmedStrike());
}

void CheckLoopEffect()
{
	if(!CheckRecursive(6512))
	{
		SuperiorUnarmedStrike(); //Only runs if the effect is no longer on the player.
	}
}

void main()
{
	DelayCommand(6.0f, CheckLoopEffect()); // Needs to be delayed because when the feat fires after resting the engine doesn't detect effects immeadiately.
}