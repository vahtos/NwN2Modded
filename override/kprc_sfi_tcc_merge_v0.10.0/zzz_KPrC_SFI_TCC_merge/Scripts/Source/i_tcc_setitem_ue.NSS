// Script runs whenever a TCC set item is unequipped
// Processes all equiped items setting properties based on TCC variables
// Properties set are also based on number of set items equipped

#include "ginc_crafting"

void main()
{
    object oPC      = GetPCItemLastUnequippedBy();
    object oItem    = GetPCItemLastUnequipped();

	// Get the set name and number of equipped set items
	string sSetName = GetLocalString(oItem,"tcc_setname");
	
	// Subtract one because the item being unequipped still gets counted
	int iPartsEquipped = GetNumEquippedParts(sSetName,oPC) - 1;
	
	// Reset all set items to the appropriate bonuses
	SetSetLevelProperties(oPC,sSetName,iPartsEquipped);
}