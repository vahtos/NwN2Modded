// Handles the actual tagging of set item members as set items
// Run in a sepperate script because that's the way the input dialog works

#include "ginc_crafting"

void main( string sSetName )
{
	object oObject = OBJECT_SELF;
	object oPC = GetLocalObject(oObject, "tcc_enchanter");
	object oContainer = GetLocalObject(oObject, "tcc_constructset");

	object oItem = GetFirstItemInInventory(oContainer);
	while (GetIsObjectValid(oItem))
	{
		if (GetItemCategory(oItem) == ITEM_CATEGORY_OTHER)
		{
			DestroyObject(oItem);
		}
		else if (GetLocalString(oItem,"tcc_setname") != sSetName)
		{
			ConvertToSetItem(oItem,sSetName,oContainer,oPC);
		}
		oItem = GetNextItemInInventory(oContainer);
	}
	
	DeleteLocalObject(oObject, "tcc_constructset");
}