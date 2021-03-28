//////////////////////////////////////////////
//  Author: Drammel							//
//  Date: 10/22/2009						//
//  Title: menu_umbral_awn					//
//  Description: Creates the Book of the    //
//  Nine Swords for the Martial Study and   //
//  Stance feats.  After this has been      //
//  created this button toggles on and off  //
//  the martial adept menu for these feats. //
//////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_include"
#include "bot9s_inc_levelup"

void main()
{
	object oPC = OBJECT_SELF;
	//Ensures that the game checks an item unique to the player.
	//This is to prevent script confusion with characters of the same class.
	object oToB = GetTomeOfBattle(oPC);

	if (GetIsObjectValid(oToB))
	{
		if ((!GetIsInCombat(oPC)) && (GetHasFeat(FEAT_MARTIAL_STUDY, oPC)) && (GetLocalInt(oToB, "MStudy1Used") == 0))
		{
			int nCap = GetLocalInt(oToB, "MartialStudy1");
			SetLocalInt(oToB, "MStudy1Pending", 1);
			LoadLevelup(oPC, oToB, 255, 1, 0, 0, nCap);
			SetGUIObjectDisabled(oPC, "SCREEN_LEVELUP_MANEUVERS", "CHOICE_NEXT", TRUE);
		}
		else if ((!GetIsInCombat(oPC)) && (GetHasFeat(FEAT_MARTIAL_STUDY_2, oPC)) && (GetLocalInt(oToB, "MStudy2Used") == 0))
		{
			int nCap = GetLocalInt(oToB, "MartialStudy2");
			SetLocalInt(oToB, "MStudy2Pending", 1);
			LoadLevelup(oPC, oToB, 255, 1, 0, 0, nCap);
			SetGUIObjectDisabled(oPC, "SCREEN_LEVELUP_MANEUVERS", "CHOICE_NEXT", TRUE);
		}
		else if ((!GetIsInCombat(oPC)) && (GetHasFeat(FEAT_MARTIAL_STUDY_3, oPC)) && (GetLocalInt(oToB, "MStudy3Used") == 0))
		{
			int nCap = GetLocalInt(oToB, "MartialStudy3");
			SetLocalInt(oToB, "MStudy3Pending", 1);
			LoadLevelup(oPC, oToB, 255, 1, 0, 0, nCap);
			SetGUIObjectDisabled(oPC, "SCREEN_LEVELUP_MANEUVERS", "CHOICE_NEXT", TRUE);
		}
		else if ((!GetIsInCombat(oPC)) && (GetHasFeat(FEAT_MARTIAL_STANCE, oPC)) && (GetLocalInt(oToB, "MStance1Used") == 0))
		{
			int nCap = GetLocalInt(oToB, "MartialStance1");
			SetLocalInt(oToB, "MStance1Pending", 1);
			LoadLevelup(oPC, oToB, 255, 0, 0, 1, nCap);
			SetGUIObjectDisabled(oPC, "SCREEN_LEVELUP_MANEUVERS", "CHOICE_NEXT", TRUE);
		}
		else if ((!GetIsInCombat(oPC)) && (GetHasFeat(FEAT_MARTIAL_STANCE_2, oPC)) && (GetLocalInt(oToB, "MStance2Used") == 0))
		{
			int nCap = GetLocalInt(oToB, "MartialStance2");
			SetLocalInt(oToB, "MStance2Pending", 1);
			LoadLevelup(oPC, oToB, 255, 0, 0, 1, nCap);
			SetGUIObjectDisabled(oPC, "SCREEN_LEVELUP_MANEUVERS", "CHOICE_NEXT", TRUE);
		}
		else if ((!GetIsInCombat(oPC)) && (GetHasFeat(FEAT_MARTIAL_STANCE_3, oPC)) && (GetLocalInt(oToB, "MStance3Used") == 0))
		{
			int nCap = GetLocalInt(oToB, "MartialStance3");
			SetLocalInt(oToB, "MStance3Pending", 1);
			LoadLevelup(oPC, oToB, 255, 0, 0, 1, nCap);
			SetGUIObjectDisabled(oPC, "SCREEN_LEVELUP_MANEUVERS", "CHOICE_NEXT", TRUE);
		}
		else if (GetLocalInt(oToB, "UmbralAwn") == 1)
		{
			SetLocalInt(oToB, "UmbralAwn", 0);
			DisplayGuiScreen(oPC, "SCREEN_MARTIAL_MENU", FALSE, "martial_menu.xml");
		}
		else if (GetLocalInt(oToB, "UmbralAwn") == 0)
		{
			SetLocalInt(oToB, "UmbralAwn", 1);
			CloseGUIScreen(oPC, "SCREEN_MARTIAL_MENU");
		}
	}
	else CreateItemOnObject("tob", oPC, 1);
}