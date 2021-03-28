//////////////////////////////////////////
//  Author: Drammel						//
//  Date: 8/25/2009						//
//  Title: sa_holo_cloak				//
//  Description: Grants the feat Scent	//
//	while the Stance is active.			//
//////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void HolocaustCloak()
{
	object oPC = OBJECT_SELF;

	if (ValidateStance(15))
	{
		effect eCloak = EffectDamageShield(5, 0, DAMAGE_TYPE_FIRE);
		effect eFire = EffectVisualEffect(VFX_TOB_HOLOCLOAK);
		eCloak = SupernaturalEffect(eCloak);

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCloak, oPC, 6.0f);
		DelayCommand(6.0f, HolocaustCloak());
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	effect eFire = EffectVisualEffect(VFX_TOB_HOLOCLOAK);

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFire, oPC, 12.0f);
	HolocaustCloak();
}