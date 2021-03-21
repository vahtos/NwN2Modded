//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 3/31/2009									//
//	Title: feat_dvt_bulwark							//
//	Description: If damaged with a melee attack,	//
//	gain +1 AC for 6 seconds.						//
//////////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_feats"
#include "bot9s_include"

void DevotedBulwark()
{
	object oPC = OBJECT_SELF;
	object oAttacker = GetLastDamager();
	object oAttacked = GetAttackTarget(oAttacker);

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6509);

	if ((oPC == oAttacked) && (GetDistanceBetween(oPC, oAttacker) <= GetMeleeRange(oPC)))
	{
		object oToB = GetItemPossessedBy(oPC, "tob");
		int nMyHp = GetLocalInt(oToB, "DevotedBulwarkHP");
		int nMyHp2 = GetLocalInt(oToB, "DevotedBulwarkHP2");

		if (nMyHp > nMyHp2)
		{
			effect eBulwark = EffectACIncrease(1);
			eBulwark = SupernaturalEffect(eBulwark);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBulwark, oPC, 6.0f);
		}
	}

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
	DelayCommand(6.0f, DevotedBulwark());
}

void RunDBHealth()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	SetLocalInt(oToB, "DevotedBulwarkHP", GetCurrentHitPoints());
	DelayCommand(5.7f, SetLocalInt(oToB, "DevotedBulwarkHP2", GetCurrentHitPoints()));
	// Window of .2 seconds to determine if the PC has lost Hit points in the round.
	DelayCommand(6.0f, RunDBHealth());
}

void CheckLoopEffect()
{
	if(!CheckRecursive(6509))
	{
		RunDBHealth();
		DelayCommand(5.8f, DevotedBulwark()); //Only runs if the effect is no longer on the player.
	}
}

void main()
{
	DelayCommand(6.0f, CheckLoopEffect()); // Needs to be delayed because when the feat fires after resting the engine doesn't detect effects immeadiately.
}