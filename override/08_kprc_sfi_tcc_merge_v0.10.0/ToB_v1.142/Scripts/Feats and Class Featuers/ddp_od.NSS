///////////////////////////////////////////////////////////////
//	Author: Drammel											 //
//	Date: 5/9/2009											 //
//	Name: ddp_od										     //
//	Description: Script that runs on the Delayed Damage Pool //
//	creature's OnDamaged script.							 //
///////////////////////////////////////////////////////////////

#include "bot9s_inc_constants"
	
void main()
{
	object oDDP = OBJECT_SELF;
	location lPool = GetLocation(oDDP);
	string sTag = GetTag(oDDP);
	string sName = GetLocalString(GetArea(oDDP), sTag);
/*	string sToB = sName + "tob";
	object oToB = GetObjectByTag(sToB);
	object oPC = IntToObject(GetLocalInt(oToB, "PC"));*/

	object oPC, oTest;
	string sPC;

	oTest = GetFirstObjectInShape(SHAPE_SPHERE, 100.0f, lPool); //fSize is arbitrarily huge because I'm pretty sure the creature doesn't move after creation.

	while (GetIsObjectValid(oTest))
	{
		sPC = GetFirstName(oTest);

		if ((sPC == sName) && (sPC != ""))
		{
			oPC = oTest;
			break;
		}

		oTest = GetNextObjectInShape(SHAPE_SPHERE, 100.0f, lPool);
	}

	object oToB = GetItemPossessedBy(oPC, "tob");
	int nEffectID = SPELL_FEAT_DDP;
	int nMaxHp = GetMaxHitPoints(oDDP);
	int nHP = GetCurrentHitPoints(oDDP);
	int nLevel = GetLevelByClass(CLASS_TYPE_CRUSADER, oPC);
	int nLimit;

	if (nLevel < 4)
	{
		nLimit = 5;
	}
	else if (nLevel < 8)
	{
		nLimit = 10;
	}
	else if (nLevel < 12)
	{
		nLimit = 15;
	}
	else if (nLevel < 16)
	{
		nLimit = 20;
	}
	else if (nLevel < 20)
	{
		nLimit = 25;
	}
	else if (nLevel < 24)
	{
		nLimit = 30;
	}
	else if (nLevel < 28)
	{
		nLimit = 35;
	}
	else nLimit = 40;

	int nHealMe = GetLocalInt(oToB, "DDPoolCanHeal");

	if (nHealMe == 1)
	{
		int nHealPool = GetLocalInt(oToB, "DDPoolHealValue");
		effect eHealPool = EffectHeal(nHealPool);

		ApplyEffectToObject(DURATION_TYPE_INSTANT, eHealPool, oDDP);
		SetLocalInt(oToB, "DDPoolCanHeal", 0);
		SetLocalInt(oToB, "DDPoolHealValue", 0);
	}

	if (nHP < 1001)
	{
		effect eTest = GetFirstEffect(oPC);

		while (GetIsEffectValid(eTest))
		{	
			if (GetEffectSpellId(eTest) == nEffectID)
			{
				RemoveEffect(oPC, eTest);
			}
			eTest = GetNextEffect(oPC);
		}

		int nDamage = nMaxHp - nHP - nLimit;
		effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL, TRUE);

		AssignCommand(oDDP, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC));
	}
}