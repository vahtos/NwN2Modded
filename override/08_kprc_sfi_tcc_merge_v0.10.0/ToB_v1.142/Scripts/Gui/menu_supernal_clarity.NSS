//////////////////////////////////////////////
//  Author: Drammel							//
//  Date: 10/22/2009						//
//  Title: menu_supernal_clarity			//
//  Description: Creates the Book of the    //
//  Nine Swords for the Crusader.  After    //
//  this has been created this button       //
//  toggles on and off the Warblade's       //
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
		int nLevel = GetLocalInt(oToB, "LevelupGate" + IntToString(CLASS_TYPE_WARBLADE));

		if (GetLocalInt(oToB, "wb_rapier") == 0)
		{
			SetLocalInt(oToB, "wb_rapier", 1);
			CreateItemOnObject("wb_rapier", oPC);
		}

		if ((!GetIsInCombat(oPC)) && (GetLevelByClass(CLASS_TYPE_WARBLADE, oPC) >= nLevel))
		{
			int nLevelCap;
		
			if (GetLocalInt(oToB, "LevelupGate" + IntToString(CLASS_TYPE_WARBLADE)) == 0)
			{
				nLevelCap = 1;
				SetLocalInt(oToB, "LevelupGate" + IntToString(CLASS_TYPE_WARBLADE), 1);
			}
			else nLevelCap = GetLocalInt(oToB, "LevelupGate" + IntToString(CLASS_TYPE_WARBLADE));
	
			int nLearn, nRetrain, nStance;
	
			switch (nLevelCap) // Level chart :p
			{
				case 1:	nLearn = 3;	nRetrain = 0;	nStance = 1;	break;
				case 2: nLearn = 1;	nRetrain = 0;	nStance = 0;	break;
				case 3:	nLearn = 1;	nRetrain = 0;	nStance = 0;	break;
				case 4: nLearn = 0;	nRetrain = 1;	nStance = 1;	break;
				case 5:	nLearn = 1;	nRetrain = 0;	nStance = 0;	break;
				case 6: nLearn = 0;	nRetrain = 1;	nStance = 0;	break;
				case 7:	nLearn = 1;	nRetrain = 0;	nStance = 0;	break;
				case 8: nLearn = 0;	nRetrain = 1;	nStance = 0;	break;
				case 9:	nLearn = 1;	nRetrain = 0;	nStance = 0;	break;
				case 10:nLearn = 0;	nRetrain = 1;	nStance = 1;	break;
				case 11:nLearn = 1;	nRetrain = 0;	nStance = 0;	break;
				case 12:nLearn = 0;	nRetrain = 1;	nStance = 0;	break;
				case 13:nLearn = 1;	nRetrain = 0;	nStance = 0;	break;
				case 14:nLearn = 0;	nRetrain = 1;	nStance = 0;	break;
				case 15:nLearn = 1;	nRetrain = 0;	nStance = 0;	break;
				case 16:nLearn = 0;	nRetrain = 1;	nStance = 1;	break;
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
				case 27:nLearn = 1;	nRetrain = 0;	nStance = 1;	break;
				case 28:nLearn = 0;	nRetrain = 1;	nStance = 0;	break;
				case 29:nLearn = 1;	nRetrain = 0;	nStance = 0;	break;
				case 30:nLearn = 0;	nRetrain = 1;	nStance = 0;	break;
			}

			LoadLevelup(oPC, oToB, CLASS_TYPE_WARBLADE, nLearn, nRetrain, nStance, nLevelCap);
		}
		else if (GetLocalInt(oToB, "SupernalClarity") == 1)
		{
			SetLocalInt(oToB, "SupernalClarity", 0);
			DisplayGuiScreen(oPC, "SCREEN_MARTIAL_MENU_WB", FALSE, "martial_menu_wb.xml");
		}
		else
		{
			SetLocalInt(oToB, "SupernalClarity", 1);
			CloseGUIScreen(oPC, "SCREEN_MARTIAL_MENU_WB");
		}
	}
	else CreateItemOnObject("tob", oPC, 1);
}