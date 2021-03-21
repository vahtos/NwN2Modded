#include "bot9s_inc_maneuvers"
//#include "bot9s_combat_overrides"
#include "tob_i0_spells"
#include "bot9s_include"
//#include "bot9s_inc_levelup"
#include "bot9s_inc_constants"
#include "bot9s_inc_2da"
//#include "bot9s_inc_misc"
//#include "bot9s_inc_retrain"
//#include "bot9s_inc_levelup"
//#include "bot9s_attack"
//#include "bot9s_weapon"
//#include "bot9s_inc_feats"
#include "bot9s_inc_fx"

void main()
{
	object oPC = OBJECT_SELF;
	object oMartialAdept = GetControlledCharacter(oPC);
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nWeapon = GetBaseItemType(oWeapon);
	object oFoe = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE);
	object oToB = GetItemPossessedBy(oMartialAdept, "tob");
	int nHp = GetMaxHitPoints(oPC);
	effect eHeal = EffectHeal(GetMaxHitPoints(oPC));
	effect eAttack = EffectAttackIncrease(20);
	
//	ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
//	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTest, oPC, 15.0f);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAttack, oPC);

//	int nVar = GetVariableCount(oToB);
//	string sVar = GetVariableName(oToB, 22);
//	SendMessageToPC(oPC, IntToString(nVar));
	SetImmortal(oPC, TRUE);
}

/*	

}*/