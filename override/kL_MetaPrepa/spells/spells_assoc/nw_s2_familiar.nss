//::///////////////////////////////////////////////
//:: Summon Familiar
//:: 'nw_s2_familiar'
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	This spell summons an Arcane caster's familiar.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////
//:: kevL's
//:: 2012 june 18
//:: - combine Kaedrin's PrC pack + Loki's ( reeron's ) SR fix routines,
//::   in case one of the new Familiar's has SR on its hide.
//:: 2012 july 15
//:: - note this is Kaedrin's 1.41.4 script.
//:: - added spellhook & tidy up.
//:: 2016 sept 10
//:: - refactor.
//:: 2017 feb 19
//:: - don't apply SR if == 0.


#include "x2_inc_spellhook" // kL_RoM, addition of spellhook

#include "mrop_inc_preps"	// kL_RoM, MROP_VAR_ACTIVE


// Applies non-bugged Spell Resistance.
void ApplyFamiliarSr(object oAssoc);
// Gets the Spell Resistance of oAssoc's skin.
int GetSkinSr(object oAssoc);


// ___________
// ** MAIN ***
// -----------
void main()
{
//	SendMessageToPC(GetFirstPC(FALSE), "Run ( nw_s2_familiar ) - " + GetName(OBJECT_SELF));

	// kL_RoM, addition of Spellhook
	if (GetLocalInt(GetModule(), MROP_VAR_ACTIVE) // the spellhook will fire in Learn mode if TRUE
		&& !X2PreSpellCastCode())
	{
		return;
	}

	SummonFamiliar();

	object oAssoc = GetAssociate(ASSOCIATE_TYPE_FAMILIAR);
	DelayCommand(0.f, ApplyFamiliarSr(oAssoc));

}


// Applies non-bugged Spell Resistance.
void ApplyFamiliarSr(object oAssoc)
{
	int iSR = GetSkinSr(oAssoc);

	// If the master is 11th level or higher, its familiar gains spell
	// resistance equal to the master’s level + 5.
	// This probably needs more kPrC classes added:
	int iCL = GetLevelByClass(CLASS_TYPE_WIZARD)
			+ GetLevelByClass(CLASS_TYPE_SORCERER);
	if (iCL > 10 && (iCL += 5) > iSR) iSR = iCL;

	if (iSR != 0)
	{
		effect eSR	= EffectSpellResistanceIncrease(iSR);
		eSR			= SupernaturalEffect(eSR);
//		eSR			= SetEffectSpellId(eSR, -1000);	// This makes it compatible with Kaedrin's feats that handle SR.
													// But I don't believe it's applicable to associates.
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSR, oAssoc);
	}
}

// Gets the Spell Resistance of oAssoc's skin.
int GetSkinSr(object oAssoc)
{
	object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oAssoc);
	if (GetIsObjectValid(oSkin))
	{
		itemproperty ipProp = GetFirstItemProperty(oSkin);
		while (GetIsItemPropertyValid(ipProp))
		{
			if (GetItemPropertyCostTable(ipProp) == 11) // spell resistance
			{
				int iCost = GetItemPropertyCostTableValue(ipProp);
				return StringToInt(Get2DAString("iprp_srcost", "Value", iCost));
			}
			ipProp = GetNextItemProperty(oSkin);
		}
	}

	return 0;
}
