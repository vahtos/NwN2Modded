//////////////////////////////////////////////////////
//  Author: Drammel									//
//  Date: 10/30/2009								//
//  Title: sa_wolfpack								//
//  Description: While you are in this stance, the  //
//  target of your attacks loses any benefit it     //
//  might have had from concealment.  Additionally, //
//  your opponent gains a vulnerability to the      //
//  attacks of your weapon equal to your skill in   //
//  Taunt.  Your allies also benefit from this      //
//  stance, although the vulnerability placed on    //
//  your target is specific to your weapon.         //
//////////////////////////////////////////////////////

#include "bot9s_inc_feats"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void WolfPackTactics()
{
	if (ValidateStance(186))
	{
		object oPC = OBJECT_SELF;
		object oFoe = GetAttemptedAttackTarget();

		if (GetIsObjectValid(oFoe))
		{
			object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
			int nDamageType = GetWeaponDamageType(oWeapon);
			int nTaunt = GetJumpSkill(oPC);
			effect eNegate = EffectConcealmentNegated();
			effect eDecrease = EffectDamageImmunityDecrease(nDamageType, nTaunt);
			effect eWolfPack = EffectLinkEffects(eNegate, eDecrease);
			eWolfPack = ExtraordinaryEffect(eWolfPack);

			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWolfPack, oFoe, 6.0f);
		}

		DelayCommand(6.0f, WolfPackTactics());
	}
}

void main()
{
	WolfPackTactics();
}