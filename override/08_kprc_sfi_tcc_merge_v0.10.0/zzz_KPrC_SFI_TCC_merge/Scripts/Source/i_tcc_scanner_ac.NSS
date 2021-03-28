// Associated with the TCC scanner gem item
// Script is run when the item's special ability is ues
// Target an item with the ability to use it
// Echoes item property information to the chat window

// Created by Dashiel Nemeth, 12/12/06
// for The Complete Craftsman Hak Pak

#include "ginc_crafting"
#include "ginc_item"

void main()
{
    // Get essential targeting variables
    object oPC      = GetItemActivator();
    object oTarget  = GetItemActivatedTarget();
	
	if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
	{
		int iPropType;
		int iPropSubType;
		int iPropFirstParam;
		int iPropParamValue;
		int iPropCostTable;
		int iPropCostTableValue;

		int iPropCounter = 0;
		itemproperty ipScan = GetFirstItemProperty(oTarget);
		
		SendMessageToPC(oPC,"Scanning <b>" + GetName(oTarget) + "</b> (" + GetTag(oTarget) + ")");
		SendMessageToPC(oPC,"Item Category: <b>" + IntToString(GetItemCategory(oTarget)));
		
		string sSetName = GetLocalString(oTarget,"tcc_setname");
		if (sSetName == "")
			sSetName = "None";
		
		string sProperty1 = GetLocalString(oTarget,"tcc_setprop_2");
		if (sProperty1 == "")
			sProperty1 = "None";
		
		string sProperty2 = GetLocalString(oTarget,"tcc_setprop_3");
		if (sProperty2 == "")
			sProperty2 = "None";
				
		string sProperty3 = GetLocalString(oTarget,"tcc_setprop_4");
		if (sProperty3 == "")
			sProperty3 = "None";
		
		string sProperty4 = GetLocalString(oTarget,"tcc_setprop_5");
		if (sProperty4 == "")
			sProperty4 = "None";
				
		SendMessageToPC(oPC,"Set: <b>" + sSetName + "</b> (SP2: <b>" + sProperty1 + "</b> SP3: <b>" + sProperty2 + "</b> SP4: <b>" + sProperty3 + "</b> SP5: <b>" + sProperty4 + 	"</b>)");
		
		string sLocalMat = GetLocalString(oTarget,"tcc_material");
		if (sLocalMat == "")
			sLocalMat = "None";
		
		string sLocalMasterwork = IntToString(GetLocalInt(oTarget,"tcc_masterwork"));
		if (sLocalMasterwork == "1")
			sLocalMasterwork = "True";
		else
			sLocalMasterwork = "False";
			
		string sLocalSetTag = IntToString(GetLocalInt(oTarget,"tcc_setflag"));
		if (sLocalSetTag == "0")
			sLocalSetTag = "None";
		
		SendMessageToPC(oPC,"Local Material: <b>" + sLocalMat + "</b> Local Masterwork: <b>" + sLocalMasterwork + "</b> Local Prep: <b>" + sLocalSetTag + "</b>");
						
		// Loop through and report properties on item
    	while (GetIsItemPropertyValid(ipScan))
		{
			iPropType = GetItemPropertyType(ipScan);
			iPropSubType = GetItemPropertySubType(ipScan);
			iPropFirstParam = GetItemPropertyParam1(ipScan);
			iPropParamValue = GetItemPropertyParam1Value(ipScan);
			iPropCostTable = GetItemPropertyCostTable(ipScan);
			iPropCostTableValue = GetItemPropertyCostTableValue(ipScan);
			iPropCounter = iPropCounter + 1;
			
			SendMessageToPC(oPC,"<b>Property #" + IntToString(iPropCounter) + "</b> (<b>Type:</b> " + IntToString(iPropType) + 
				", <b>Subtype:</b> " + IntToString(iPropSubType) + ", <b>Cost Value:</b> " + IntToString(iPropCostTableValue) + ")");
				
			ipScan = GetNextItemProperty(oTarget);
		}
		
		if (iPropCounter == 0)
			SendMessageToPC(oPC,"No properties found on item.");
	}
	else
	{
		SendMessageToPC(oPC,"You must target an item!");
	}
}