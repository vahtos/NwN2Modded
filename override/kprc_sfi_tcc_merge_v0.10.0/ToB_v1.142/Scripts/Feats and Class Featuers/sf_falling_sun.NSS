//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 4/19/2009									//
//	Name: sf_falling_sun							//
//	Description: Allows the PC to incorperate a 	//
//	Stunning Fist attack into a Setting Sun strike	//
//	by decalaring the feat as active and running the//
//	effect from Setting Sun strikes.				//
//////////////////////////////////////////////////////

void main()
{
	object oPC = OBJECT_SELF;

	if (GetHasFeat(FEAT_STUNNING_FIST))
	{
		object oToB = GetItemPossessedBy(oPC, "tob");

		SetLocalInt(oToB, "FallingSun", 1);
		DelayCommand(6.0f, SetLocalInt(oToB, "FallingSun", 0));
		FloatingTextStringOnCreature("<color=cyan>Falling Sun Attack has been declared for six seconds.</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
	}
}