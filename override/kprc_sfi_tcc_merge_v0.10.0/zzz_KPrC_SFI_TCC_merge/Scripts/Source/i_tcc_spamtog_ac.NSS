// Associated with the TCC Feedback Switch item
// Script is run when the item's special ability is used
// No target is required
// Toggles the feedback global int

// Created by Dashiel Nemeth, 12/12/06
// for The Complete Craftsman Hak Pak

void main()
{
    object oPC      = GetItemActivator();
	if (GetGlobalInt("CraftSpam"))
	{
		SetGlobalInt("CraftSpam",FALSE);
		SendMessageToPC(oPC,"Crafting feedback disabled...");
	}
	else
	{
		SetGlobalInt("CraftSpam",TRUE);
		SendMessageToPC(oPC,"Crafting feedback enabled...");
	}
}