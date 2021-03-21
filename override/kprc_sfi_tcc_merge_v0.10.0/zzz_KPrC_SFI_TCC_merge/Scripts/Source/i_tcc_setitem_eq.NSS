// Script runs whenever a TCC set item is equipped
// Processes all equiped items setting properties based on TCC variables
// Properties set are also based on number of set items equipped

#include "ginc_crafting"

void main()
{
    object oPC = GetPCItemLastEquippedBy();
    object oItem = GetPCItemLastEquipped();

	// Get the set name and number of equipped set items
	string sSetName = GetLocalString(oItem,"tcc_setname");
	int iPartsEquipped = GetNumEquippedParts(sSetName,oPC);
	
	// Reset all set items to the appropriate bonuses
	SetSetLevelProperties(oPC,sSetName,iPartsEquipped);
}