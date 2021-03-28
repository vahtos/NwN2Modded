//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 4/27/2009								//
//	Name: clf_dual_boost						//
//	Description: Allows a PC to use two Boost	//
//	maneuvers in the same round 3 times per day.//
//////////////////////////////////////////////////

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	int nDualBoost = GetLocalInt(oToB, "DualBoost");

	if (nDualBoost > 0)
	{
		FloatingTextStringOnCreature("<color=cyan>*Dual Boost Active!*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
		SetLocalInt(oToB, "DualBoostActive", 1);
	}
	else SendMessageToPC(oPC, "<color=red>You must rest before you can use Dual Boost again.</color>");
}