//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 4/13/2009									//
//	Name: sf_avenge_strikeA							//
//	Description: As a swift action, grants the		//
//	player their CHA bonus against evil outsiders	//
//	for one round.									//
//////////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "tob_x2_inc_itemprop"

void main()
{
	object oPC = OBJECT_SELF;
	int nUses = GetLocalInt(oPC, "AvengingStrikeUses");

	if ((nUses > 0) && (GetLocalInt(oPC, "Swift") == 0))
	{
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
		
		if (oWeapon == OBJECT_INVALID)
		{
			oWeapon = GetItemInSlot(INVENTORY_SLOT_ARMS);
		}
		
		int nMyCHA = GetAbilityModifier(ABILITY_CHARISMA);
		int nPlus = GetDamageByIPConstDamageBonus(nMyCHA);
		itemproperty ipDamage = ItemPropertyEnhancementBonusVsRace(RACIAL_TYPE_OUTSIDER, nPlus);

		effect eAvStrike = EffectNWN2SpecialEffectFile("ror_blue_eyes_con1", oPC);
		eAvStrike = SupernaturalEffect(eAvStrike);

		IPSafeAddItemProperty(oWeapon, ipDamage, 3.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAvStrike, oPC, 3.0f);
		SetLocalInt(oPC, "AvengingStrikeUses", nUses - 1);
		RunSwiftAction(213, "F");
	}
	else SendMessageToPC(oPC, "<color=red>You must rest before you can use Avenging Strike again.</color>");
}