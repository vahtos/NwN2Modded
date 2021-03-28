///////////////////////////////////////////////////////////////
//	Author: Drammel											 //
//	Date: 5/9/2009											 //
//	Name: ddp_hb										     //
//	Description: Script that runs on the Delayed Damage Pool //
//	creature's heartbeat script.  This script is extremely	 //
//	picky.  Try not to mess around with it if you can.		 //
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
	object oPC = IntToObject(GetLocalInt(oToB, "PC"));
	There is probably a better way to do this via the module events, but that doesn't help me with single player compatibility.*/

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
	effect ePool = EffectShareDamage(oDDP, 1, 99);
	ePool = SupernaturalEffect(ePool);
	ePool = SetEffectSpellId(ePool, nEffectID);

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

	int nDifference = nMaxHp - nHP;
	int nDamage;

	if (nDifference > nLimit)
	{
		nDamage = nLimit;
	}
	else nDamage = nMaxHp - nHP;

	DelayCommand(0.01f, SetLocalInt(oToB, "DDPool", nDamage));

	if (nHP != nMaxHp)
	{
		effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL, TRUE);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC);
	}

	effect eHeal = EffectHeal(nMaxHp);

	ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oDDP);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePool, oPC, 5.5f); // Shorter than a round due to the random delay added to heartbeats.

	if ((!GetIsInCombat(oPC)) && (GetLocalInt(oToB, "Encounter") == 0))
	{
		DestroyObject(oDDP, 0.0f, FALSE);
	}
}