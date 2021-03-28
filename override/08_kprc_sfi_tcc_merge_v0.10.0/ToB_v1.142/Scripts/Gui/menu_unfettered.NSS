//////////////////////////////////////////////
//  Author: Drammel							//
//  Date: 10/22/2009						//
//  Title: menu_unfettered					//
//  Description: Creates the Book of the    //
//  Nine Swords for the Crusader.  After    //
//  this has been created this button       //
//  toggles on and off the Crusader's       //
//  martial adept menu.                     //
//////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_levelup"

void main()
{
	object oPC = OBJECT_SELF;
	//Ensures that the game checks an item unique to the player.
	//This is to prevent script confusion with characters of the same class.
	object oToB = GetTomeOfBattle(oPC);

	if (GetIsObjectValid(oToB))
	{
		int nLevel = GetLocalInt(oToB, "LevelupGate" + IntToString(CLASS_TYPE_CRUSADER));

		if (GetLocalInt(oToB, "cr_sword") == 0)
		{
			SetLocalInt(oToB, "cr_sword", 1);
			CreateItemOnObject("cr_sword", oPC);
		}

		if ((!GetIsInCombat(oPC)) && (GetLevelByClass(CLASS_TYPE_CRUSADER, oPC) >= nLevel))
		{
			int nLevelCap;
		
			if (GetLocalInt(oToB, "LevelupGate" + IntToString(CLASS_TYPE_CRUSADER)) == 0)
			{
				nLevelCap = 1;
				SetLocalInt(oToB, "LevelupGate" + IntToString(CLASS_TYPE_CRUSADER), 1);
			}
			else nLevelCap = GetLocalInt(oToB, "LevelupGate" + IntToString(CLASS_TYPE_CRUSADER));
	
			int nLearn, nRetrain, nStance;
	
			switch (nLevelCap) // Level chart :p
			{
				case 1:	nLearn = 5;	nRetrain = 0;	nStance = 1;	break;
				case 2: nLearn = 0;	nRetrain = 0;	nStance = 1;	break;
				case 3:	nLearn = 1;	nRetrain = 0;	nStance = 0;	break;
				case 4: nLearn = 0;	nRetrain = 1;	nStance = 0;	break;
				case 5:	nLearn = 1;	nRetrain = 0;	nStance = 0;	break;
				case 6: nLearn = 0;	nRetrain = 1;	nStance = 0;	break;
				case 7:	nLearn = 1;	nRetrain = 0;	nStance = 0;	break;
				case 8: nLearn = 0;	nRetrain = 1;	nStance = 1;	break;
				case 9:	nLearn = 1;	nRetrain = 0;	nStance = 0;	break;
				case 10:nLearn = 0;	nRetrain = 1;	nStance = 0;	break;
				case 11:nLearn = 1;	nRetrain = 0;	nStance = 0;	break;
				case 12:nLearn = 0;	nRetrain = 1;	nStance = 0;	break;
				case 13:nLearn = 1;	nRetrain = 0;	nStance = 0;	break;
				case 14:nLearn = 0;	nRetrain = 1;	nStance = 1;	break;
				case 15:nLearn = 1;	nRetrain = 0;	nStance = 0;	break;
				case 16:nLearn = 0;	nRetrain = 1;	nStance = 0;	break;
				case 17:nLearn = 1;	nRetrain = 0;	nStance = 0;	break;
				case 18:nLearn = 0;	nRetrain = 1;	nStance = 0;	break;
				case 19:nLearn = 1;	nRetrain = 0;	nStance = 0;	break;
				case 20:nLearn = 0;	nRetrain = 1;	nStance = 0;	break;
				case 21:nLearn = 1;	nRetrain = 0;	nStance = 1;	break;
				case 22:nLearn = 0;	nRetrain = 1;	nStance = 0;	break;
				case 23:nLearn = 1;	nRetrain = 0;	nStance = 0;	break;
				case 24:nLearn = 0;	nRetrain = 1;	nStance = 0;	break;
				case 25:nLearn = 1;	nRetrain = 0;	nStance = 0;	break;
				case 26:nLearn = 0;	nRetrain = 1;	nStance = 0;	break;
				case 27:nLearn = 1;	nRetrain = 0;	nStance = 0;	break;
				case 28:nLearn = 0;	nRetrain = 1;	nStance = 1;	break;
				case 29:nLearn = 1;	nRetrain = 0;	nStance = 0;	break;
				case 30:nLearn = 0;	nRetrain = 1;	nStance = 0;	break;
			}

			LoadLevelup(oPC, oToB, CLASS_TYPE_CRUSADER, nLearn, nRetrain, nStance, nLevelCap);
		}
		else if (GetLocalInt(oToB, "Unfettered") == 1)
		{
			SetLocalInt(oToB, "Unfettered", 0);
			DisplayGuiScreen(oPC, "SCREEN_MARTIAL_MENU_CR", FALSE, "martial_menu_cr.xml");
		}
		else
		{
			SetLocalInt(oToB, "Unfettered", 1);
			CloseGUIScreen(oPC, "SCREEN_MARTIAL_MENU_CR");
		}
	}
	else CreateItemOnObject("tob", oPC, 1);
}