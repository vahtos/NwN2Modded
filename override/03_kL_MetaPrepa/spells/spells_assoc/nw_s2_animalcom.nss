//::///////////////////////////////////////////////
//:: Summon Animal Companion
//:: 'nw_s2_animalcom'
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	This spell summons a Druid's animal companion
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////
//:: kevL's
//:: 2012 july 15
//:: - note this is a modified Kaedrin's 1.41.4 script.
//:: - added spellhook & tidy up.
//:: 2013 jan 6
//:: - fixed apply DamageReduction w/ Exalted Companion.
//:: - calls kL_SummonCMIAnimComp() to get around
//::   issues w/out Kaedrin's PrC pack ...
//:: 2013 april 20
//:: - swapped in alphaConstants for numeric.
//:: 2016 sept 10
//:: - refactor.


#include "x2_inc_spellhook"	// kL_RoM, addition of spellhook

#include "mrop_inc_preps"	// kL_RoM, MROP_VAR_ACTIVE
#include "mrop_cmi_animcom"	// kL_RoM, kL_SummonAssociate(), kL_ApplySilverFangEffect()


void main()
{
	//SendMessageToPC(GetFirstPC(FALSE), "Run ( nw_s2_animalcom ) - " + GetName(OBJECT_SELF));

	// kL_RoM, addition of Spellhook
	if (GetLocalInt(GetModule(), MROP_VAR_ACTIVE) // the spellhook will fire in Learn mode if TRUE
		&& !X2PreSpellCastCode())
	{
		return;
	}


	kL_SummonAssociate();
	object oAssoc = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION);

	if (GetHasFeat(FEAT_SILVER_FANG))
	{
		kL_ApplySilverFangEffect(oAssoc);
	}

	string sTag = GetTag(oAssoc);
	if (FindSubString(sTag, "blue") != -1 || FindSubString(sTag, "bronze") != -1) // is Dragon
	{
		effect eEffect	= EffectImmunity(FEAT_SNEAK_ATTACK);
		eEffect			= SupernaturalEffect(eEffect);

		DelayCommand(0.f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oAssoc));
	}
	else if (FindSubString(sTag, "ele") != -1) // is Elemental
	{
		effect eEffect	= EffectSetScale(0.3f);
		eEffect			= SupernaturalEffect(eEffect);

		DelayCommand(0.f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oAssoc));
	}


	int iHD = GetHitDice(oAssoc);
	effect eSR = EffectSpellResistanceIncrease(iHD + 5);

	int bExalted = FALSE;
	if (GetHasFeat(FEAT_EXALTED_COMPANION))
	{
		bExalted = TRUE;

		effect eLink;

		int iReduct;
		if (iHD > 11)	iReduct = 10;
		else			iReduct = 5;

		effect eReduct = EffectDamageReduction(iReduct, GMATERIAL_METAL_ADAMANTINE, 0, DR_TYPE_GMATERIAL);

		int iResist;
		if (iHD > 7)	iResist = 10;
		else			iResist = 5;

		switch (GetAlignmentGoodEvil(OBJECT_SELF))
		{
			default:
			case ALIGNMENT_GOOD: // Celestial
			case ALIGNMENT_NEUTRAL:
			{
				effect eDmgRes1 = EffectDamageResistance(DAMAGE_TYPE_ACID, iResist);
				effect eDmgRes2 = EffectDamageResistance(DAMAGE_TYPE_COLD, iResist);
				effect eDmgRes3 = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, iResist);

				eLink = EffectLinkEffects(eDmgRes1, eDmgRes2);
				eLink = EffectLinkEffects(eDmgRes3, eLink);
				break;
			}

			case ALIGNMENT_EVIL: // Fiendish
			{
				effect eDmgRes1 = EffectDamageResistance(DAMAGE_TYPE_FIRE, iResist);
				effect eDmgRes2 = EffectDamageResistance(DAMAGE_TYPE_COLD, iResist);

				eLink = EffectLinkEffects(eDmgRes1, eDmgRes2);
			}
		}

		effect eDarkVision = EffectDarkVision();

		eLink = EffectLinkEffects(eLink, eDarkVision);
		eLink = EffectLinkEffects(eLink, eSR);
		eLink = EffectLinkEffects(eLink, eReduct);

		eLink = SupernaturalEffect(eLink);
		DelayCommand(0.f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oAssoc));
	}

	if (GetHasFeat(FEAT_DEVOTED_TRACKER))
	{
		FeatAdd(oAssoc, FEAT_DASH, FALSE);
		FeatAdd(oAssoc, FEAT_EVASION, FALSE);
		FeatAdd(oAssoc, FEAT_IMPROVED_EVASION, FALSE);

		effect eLink = EffectACIncrease(2);

		if (!bExalted && GetLevelByClass(CLASS_TYPE_PALADIN) > 14)
		{
			eLink = EffectLinkEffects(eLink, eSR);
		}

		eLink = SupernaturalEffect(eLink);
		DelayCommand(0.f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oAssoc));
	}
}
