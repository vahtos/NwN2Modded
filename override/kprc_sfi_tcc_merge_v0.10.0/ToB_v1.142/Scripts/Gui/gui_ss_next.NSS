//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 6/9/2009								//
//	Title: gui_ss_next							//
//	Description: Allows the a first level		//
//	Swordsage to confirm their selection for the//
//	class feature, Insightful Strike: Weapon	//
//	Focus.										//
//////////////////////////////////////////////////

#include "bot9s_inc_constants"

void main()
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nSSWF = GetLocalInt(oToB, "SSWeaponFocus");

	switch (nSSWF)
	{
		case 1:
		{
			SetLocalInt(oToB, "ForbiddenRetrain1", FEAT_WEAPON_FOCUS_SCIMITAR);
			SetLocalInt(oToB, "ForbiddenRetrain2", FEAT_WEAPON_FOCUS_LIGHT_MACE);
			SetLocalInt(oToB, "ForbiddenRetrain3", FEAT_WEAPON_FOCUS_SPEAR);
			SetLocalInt(oToB, "ForbiddenRetrain4", FEAT_WEAPON_FOCUS_FALCHION);
			break;
		}
		case 3:
		{
			SetLocalInt(oToB, "ForbiddenRetrain1", FEAT_WEAPON_FOCUS_RAPIER);
			SetLocalInt(oToB, "ForbiddenRetrain2", FEAT_WEAPON_FOCUS_SICKLE);
			SetLocalInt(oToB, "ForbiddenRetrain3", FEAT_WEAPON_FOCUS_KATANA);
			SetLocalInt(oToB, "ForbiddenRetrain4", FEAT_WEAPON_FOCUS_BASTARD_SWORD);
			break;
		}
		case 5:
		{
			SetLocalInt(oToB, "ForbiddenRetrain1", 100);
			SetLocalInt(oToB, "ForbiddenRetrain2", FEAT_WEAPON_FOCUS_SHORT_SWORD);
			SetLocalInt(oToB, "ForbiddenRetrain3", FEAT_WEAPON_FOCUS_SLING);
			SetLocalInt(oToB, "ForbiddenRetrain4", FEAT_WEAPON_FOCUS_STAFF);
			break;
		}
		case 6:
		{
			SetLocalInt(oToB, "ForbiddenRetrain1", 100);
			SetLocalInt(oToB, "ForbiddenRetrain2", FEAT_WEAPON_FOCUS_SHORT_SWORD);
			SetLocalInt(oToB, "ForbiddenRetrain3", FEAT_WEAPON_FOCUS_DAGGER);
			SetLocalInt(oToB, "ForbiddenRetrain4", FEAT_WEAPON_FOCUS_SHORTBOW);
			SetLocalInt(oToB, "ForbiddenRetrain5", FEAT_WEAPON_FOCUS_SCYTHE);
			SetLocalInt(oToB, "ForbiddenRetrain6", FEAT_WEAPON_FOCUS_SHURIKEN);
			break;
		}
		case 7:
		{
			SetLocalInt(oToB, "ForbiddenRetrain1", 100);
			SetLocalInt(oToB, "ForbiddenRetrain2", FEAT_WEAPON_FOCUS_GREAT_SWORD);
			SetLocalInt(oToB, "ForbiddenRetrain3", FEAT_WEAPON_FOCUS_GREAT_AXE);
			SetLocalInt(oToB, "ForbiddenRetrain4", FEAT_WEAPON_FOCUS_WARMACE);
			break;
		}
		case 8:
		{
			SetLocalInt(oToB, "ForbiddenRetrain1", 100);
			SetLocalInt(oToB, "ForbiddenRetrain2", 291);
			SetLocalInt(oToB, "ForbiddenRetrain3", FEAT_WEAPON_FOCUS_GREAT_AXE);
			SetLocalInt(oToB, "ForbiddenRetrain4", FEAT_WEAPON_FOCUS_SHORTBOW);
			SetLocalInt(oToB, "ForbiddenRetrain5", FEAT_WEAPON_FOCUS_KUKRI);
			SetLocalInt(oToB, "ForbiddenRetrain6", FEAT_WEAPON_FOCUS_HAND_AXE);
			break;
		}
	}

	SetGUIObjectDisabled(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "CHOICE_NEXT", TRUE);
	ExecuteScript("clf_ss_wpnfocus", oPC);
	DelayCommand(0.1f, SetLocalInt(oToB, "FeatRetrainPhase", 1));
	SetGUIObjectDisabled(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "CHOICE_FINISH", FALSE);
}