//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 2/2/2010									//
//	Title: gui_tob_xref								//
//	Description: Cross references data stored on the//
//  ToB object.  This function compares which level //
//  against which discipline the player has selected//
//  and displays the relavent maneuvers on the      //
//  Primer Screen.                                  //
//////////////////////////////////////////////////////

#include "bot9s_inc_2da"

void ShowManeuver(int n, string s2da)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");
	string sTga = tob_Get2daString("maneuvers", "ICON", StringToInt(s2da));
	int nStrRef = tob_Get2daInt("maneuvers", "StrRef", StringToInt(s2da));
	string sTextures = "MANEUVER_IMAGE=" + sTga;
	string sText = "MANEUVER_TEXT=" + GetStringByStrRef(nStrRef);
	string sVari = "7=" + s2da;

	AddListBoxRow(oPC, "SCREEN_TOB_PRIMER", "SHOWN_MANEUVER_LIST", "MANEUVERPANE_PROTO" + IntToString(n), sText, sTextures + ".tga", sVari, "");
}

void main(string sData)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = GetItemPossessedBy(oPC, "tob");

	if (sData == "0" || sData == "1" || sData == "2" || sData == "3" || sData == "4" || sData == "5" || sData == "6"
	|| sData == "7" || sData == "8" || sData == "9")
	{
		SetLocalString(oToB, "PrimerNumber", sData);
	}
	else if (sData == "DW" || sData == "DS" || sData == "DM" || sData == "IH" || sData == "SS" || sData == "SH"
	|| sData == "SD" || sData == "TC" || sData == "WR")
	{
		SetLocalString(oToB, "PrimerDiscipline", sData);
	}

	string sNumber = GetLocalString(oToB, "PrimerNumber");
	string sDiscipline = GetLocalString(oToB, "PrimerDiscipline");

	if (sNumber == "" || sDiscipline == "")
	{// If either of these hasn't been set yet we can end the script.
		return;
	}

	ClearListBox(oPC, "SCREEN_TOB_PRIMER", "SHOWN_MANEUVER_LIST");

	if (sNumber == "0" && sDiscipline == "DW") // Stances
	{
		ShowManeuver(1, "12");
		ShowManeuver(2, "15");
		ShowManeuver(3, "9");
		ShowManeuver(4, "21");
	}
	else if (sNumber == "0" && sDiscipline == "DS")
	{
		ShowManeuver(1, "42");
		ShowManeuver(2, "44");
		ShowManeuver(3, "51");
		ShowManeuver(4, "28");
		ShowManeuver(5, "29");
		ShowManeuver(6, "30");
		ShowManeuver(7, "31");
		ShowManeuver(8, "41");
	}
	else if (sNumber == "0" && sDiscipline == "DM")
	{
		ShowManeuver(1, "74");
		ShowManeuver(2, "68");
		ShowManeuver(3, "61");
	}
	else if (sNumber == "0" && sDiscipline == "IH")
	{
		ShowManeuver(1, "90");
		ShowManeuver(2, "76");
		ShowManeuver(3, "78");
		ShowManeuver(4, "95");
	}
	else if (sNumber == "0" && sDiscipline == "SS")
	{
		ShowManeuver(1, "113");
		ShowManeuver(2, "105");
		ShowManeuver(3, "110");
		ShowManeuver(4, "104");
	}
	else if (sNumber == "0" && sDiscipline == "SH")
	{
		ShowManeuver(1, "119");
		ShowManeuver(2, "129");
		ShowManeuver(3, "116");
		ShowManeuver(4, "122");
		ShowManeuver(5, "139");
		ShowManeuver(6, "117");
	}
	else if (sNumber == "0" && sDiscipline == "SD")
	{
		ShowManeuver(1, "163");
		ShowManeuver(2, "149");
		ShowManeuver(3, "159");
		ShowManeuver(4, "152");
		ShowManeuver(5, "164");
	}
	else if (sNumber == "0" && sDiscipline == "TC")
	{
		ShowManeuver(1, "165");
		ShowManeuver(2, "174");
		ShowManeuver(3, "175");
		ShowManeuver(4, "187");
		ShowManeuver(5, "177");
		ShowManeuver(6, "186");
	}
	else if (sNumber == "0" && sDiscipline == "WR")
	{
		ShowManeuver(1, "189");
		ShowManeuver(2, "195");
		ShowManeuver(3, "202");
		ShowManeuver(4, "198");
		ShowManeuver(5, "199");
	}
	else if (sNumber == "1" && sDiscipline == "DW") // Level 1
	{
		ShowManeuver(1, "1");
		ShowManeuver(2, "2");
		ShowManeuver(3, "6");
		ShowManeuver(4, "25");
	}
	else if (sNumber == "1" && sDiscipline == "DS")
	{
		ShowManeuver(1, "33");
		ShowManeuver(2, "53");
	}
	else if (sNumber == "1" && sDiscipline == "DM")
	{
		ShowManeuver(1, "67");
		ShowManeuver(2, "72");
	}
	else if (sNumber == "1" && sDiscipline == "IH")
	{
		ShowManeuver(1, "92");
		ShowManeuver(2, "93");
	}
	else if (sNumber == "1" && sDiscipline == "SS")
	{
		ShowManeuver(1, "209");
		ShowManeuver(2, "107");
	}
	else if (sNumber == "1" && sDiscipline == "SH")
	{
		ShowManeuver(1, "120");
		ShowManeuver(2, "132");
	}
	else if (sNumber == "1" && sDiscipline == "SD")
	{
		ShowManeuver(1, "146");
		ShowManeuver(2, "160");
	}
	else if (sNumber == "1" && sDiscipline == "TC")
	{
		ShowManeuver(1, "182");
		ShowManeuver(2, "185");
	}
	else if (sNumber == "1" && sDiscipline == "WR")
	{
		ShowManeuver(1, "192");
		ShowManeuver(2, "208");
		ShowManeuver(3, "194");
	}
	else if (sNumber == "2" && sDiscipline == "DW") // Level 2
	{
		ShowManeuver(1, "3");
		ShowManeuver(2, "10");
		ShowManeuver(3, "13");
		ShowManeuver(4, "14");
	}
	else if (sNumber == "2" && sDiscipline == "DS")
	{
		ShowManeuver(1, "40");
		ShowManeuver(2, "48");
	}
	else if (sNumber == "2" && sDiscipline == "DM")
	{
		ShowManeuver(1, "54");
		ShowManeuver(2, "60");
	}
	else if (sNumber == "2" && sDiscipline == "IH")
	{
		ShowManeuver(1, "80");
		ShowManeuver(2, "96");
	}
	else if (sNumber == "2" && sDiscipline == "SS")
	{
		ShowManeuver(1, "97");
		ShowManeuver(2, "99");
	}
	else if (sNumber == "2" && sDiscipline == "SH")
	{
		ShowManeuver(1, "121");
		ShowManeuver(2, "124");
		ShowManeuver(3, "135");
	}
	else if (sNumber == "2" && sDiscipline == "SD")
	{
		ShowManeuver(1, "156");
		ShowManeuver(2, "162");
	}
	else if (sNumber == "2" && sDiscipline == "TC")
	{
		ShowManeuver(1, "166");
		ShowManeuver(2, "179");
	}
	else if (sNumber == "2" && sDiscipline == "WR")
	{
		ShowManeuver(1, "188");
		ShowManeuver(2, "201");
	}
	else if (sNumber == "3" && sDiscipline == "DW") // Level 3
	{
		ShowManeuver(1, "4");
		ShowManeuver(2, "8");
		ShowManeuver(3, "27");
	}
	else if (sNumber == "3" && sDiscipline == "DS")
	{
		ShowManeuver(1, "35");
		ShowManeuver(2, "47");
	}
	else if (sNumber == "3" && sDiscipline == "DM")
	{
		ShowManeuver(1, "62");
		ShowManeuver(2, "64");
	}
	else if (sNumber == "3" && sDiscipline == "IH")
	{
		ShowManeuver(1, "87");
		ShowManeuver(2, "85");
	}
	else if (sNumber == "3" && sDiscipline == "SS")
	{
		ShowManeuver(1, "101");
		ShowManeuver(2, "102");
	}
	else if (sNumber == "3" && sDiscipline == "SH")
	{
		ShowManeuver(1, "134");
		ShowManeuver(2, "140");
	}
	else if (sNumber == "3" && sDiscipline == "SD")
	{
		ShowManeuver(1, "144");
		ShowManeuver(2, "161");
	}
	else if (sNumber == "3" && sDiscipline == "TC")
	{
		ShowManeuver(1, "170");
		ShowManeuver(2, "181");
	}
	else if (sNumber == "3" && sDiscipline == "WR")
	{
		ShowManeuver(1, "196");
		ShowManeuver(2, "207");
	}
	else if (sNumber == "4" && sDiscipline == "DW") // Level 4
	{
		ShowManeuver(1, "11");
		ShowManeuver(2, "23");
		ShowManeuver(3, "24");
	}
	else if (sNumber == "4" && sDiscipline == "DS")
	{
		ShowManeuver(1, "36");
		ShowManeuver(2, "39");
	}
	else if (sNumber == "4" && sDiscipline == "DM")
	{
		ShowManeuver(1, "56");
		ShowManeuver(2, "65");
		ShowManeuver(3, "71");
	}
	else if (sNumber == "4" && sDiscipline == "IH")
	{
		ShowManeuver(1, "86");
		ShowManeuver(2, "89");
	}
	else if (sNumber == "4" && sDiscipline == "SS")
	{
		ShowManeuver(1, "100");
		ShowManeuver(2, "114");
	}
	else if (sNumber == "4" && sDiscipline == "SH")
	{
		ShowManeuver(1, "128");
		ShowManeuver(2, "130");
	}
	else if (sNumber == "4" && sDiscipline == "SD")
	{
		ShowManeuver(1, "143");
		ShowManeuver(2, "145");
		ShowManeuver(3, "158");
	}
	else if (sNumber == "4" && sDiscipline == "TC")
	{
		ShowManeuver(1, "168");
		ShowManeuver(2, "171");
	}
	else if (sNumber == "4" && sDiscipline == "WR")
	{
		ShowManeuver(1, "191");
		ShowManeuver(2, "206");
	}
	else if (sNumber == "5" && sDiscipline == "DW") // Level 5
	{
		ShowManeuver(1, "7");
		ShowManeuver(2, "18");
		ShowManeuver(3, "19");
	}
	else if (sNumber == "5" && sDiscipline == "DS")
	{
		ShowManeuver(1, "34");
		ShowManeuver(2, "38");
		ShowManeuver(3, "43");
		ShowManeuver(4, "45");
		ShowManeuver(5, "52");
	}
	else if (sNumber == "5" && sDiscipline == "DM")
	{
		ShowManeuver(1, "59");
		ShowManeuver(2, "70");
	}
	else if (sNumber == "5" && sDiscipline == "IH")
	{
		ShowManeuver(1, "79");
		ShowManeuver(2, "84");
	}
	else if (sNumber == "5" && sDiscipline == "SS")
	{
		ShowManeuver(1, "108");
		ShowManeuver(2, "111");
		ShowManeuver(3, "112");
	}
	else if (sNumber == "5" && sDiscipline == "SH")
	{
		ShowManeuver(1, "118");
		ShowManeuver(2, "137");
	}
	else if (sNumber == "5" && sDiscipline == "SD")
	{
		ShowManeuver(1, "151");
		ShowManeuver(2, "155");
	}
	else if (sNumber == "5" && sDiscipline == "TC")
	{
		ShowManeuver(1, "167");
		ShowManeuver(2, "176");
	}
	else if (sNumber == "5" && sDiscipline == "WR")
	{
		ShowManeuver(1, "193");
	}
	else if (sNumber == "6" && sDiscipline == "DW") // Level 6
	{
		ShowManeuver(1, "5");
		ShowManeuver(2, "20");
	}
	else if (sNumber == "6" && sDiscipline == "DS")
	{
		ShowManeuver(1, "46");
	}
	else if (sNumber == "6" && sDiscipline == "DM")
	{
		ShowManeuver(1, "63");
		ShowManeuver(2, "66");
	}
	else if (sNumber == "6" && sDiscipline == "IH")
	{
		ShowManeuver(1, "83");
		ShowManeuver(2, "88");
	}
	else if (sNumber == "6" && sDiscipline == "SS")
	{
		ShowManeuver(1, "98");
		ShowManeuver(2, "109");
	}
	else if (sNumber == "6" && sDiscipline == "SH")
	{
		ShowManeuver(1, "127");
		ShowManeuver(2, "136");
		ShowManeuver(3, "138");
	}
	else if (sNumber == "6" && sDiscipline == "SD")
	{
		ShowManeuver(1, "148");
		ShowManeuver(2, "153");
		ShowManeuver(3, "154");
	}
	else if (sNumber == "6" && sDiscipline == "TC")
	{
		ShowManeuver(1, "178");
		ShowManeuver(2, "184");
	}
	else if (sNumber == "6" && sDiscipline == "WR")
	{
		ShowManeuver(1, "197");
		ShowManeuver(2, "203");
	}
	else if (sNumber == "7" && sDiscipline == "DW") // Level 7
	{
		ShowManeuver(1, "16");
		ShowManeuver(2, "22");
	}
	else if (sNumber == "7" && sDiscipline == "DS")
	{
		ShowManeuver(1, "32");
		ShowManeuver(2, "49");
	}
	else if (sNumber == "7" && sDiscipline == "DM")
	{
		ShowManeuver(1, "55");
		ShowManeuver(2, "69");
	}
	else if (sNumber == "7" && sDiscipline == "IH")
	{
		ShowManeuver(1, "82");
		ShowManeuver(2, "91");
	}
	else if (sNumber == "7" && sDiscipline == "SS")
	{
		ShowManeuver(1, "106");
	}
	else if (sNumber == "7" && sDiscipline == "SH")
	{
		ShowManeuver(1, "123");
		ShowManeuver(2, "133");
	}
	else if (sNumber == "7" && sDiscipline == "SD")
	{
		ShowManeuver(1, "142");
		ShowManeuver(2, "147");
	}
	else if (sNumber == "7" && sDiscipline == "TC")
	{
		ShowManeuver(1, "173");
		ShowManeuver(2, "183");
	}
	else if (sNumber == "7" && sDiscipline == "WR")
	{
		ShowManeuver(1, "190");
		ShowManeuver(2, "200");
	}
	else if (sNumber == "8" && sDiscipline == "DW") // Level 8
	{
		ShowManeuver(1, "26");
	}
	else if (sNumber == "8" && sDiscipline == "DS")
	{
		ShowManeuver(1, "37");
	}
	else if (sNumber == "8" && sDiscipline == "DM")
	{
		ShowManeuver(1, "57");
		ShowManeuver(2, "58");
	}
	else if (sNumber == "8" && sDiscipline == "IH")
	{
		ShowManeuver(1, "77");
		ShowManeuver(2, "87");
	}
	else if (sNumber == "8" && sDiscipline == "SS")
	{
		ShowManeuver(1, "103");
	}
	else if (sNumber == "8" && sDiscipline == "SH")
	{
		ShowManeuver(1, "125");
		ShowManeuver(2, "131");
	}
	else if (sNumber == "8" && sDiscipline == "SD")
	{
		ShowManeuver(1, "141");
		ShowManeuver(2, "150");
	}
	else if (sNumber == "8" && sDiscipline == "TC")
	{
		ShowManeuver(1, "172");
		ShowManeuver(2, "180");
	}
	else if (sNumber == "8" && sDiscipline == "WR")
	{
		ShowManeuver(1, "199");
		ShowManeuver(2, "205");
	}
	else if (sNumber == "9" && sDiscipline == "DW") // Level 9
	{
		ShowManeuver(1, "17");
	}
	else if (sNumber == "9" && sDiscipline == "DS")
	{
		ShowManeuver(1, "50");
	}
	else if (sNumber == "9" && sDiscipline == "DM")
	{
		ShowManeuver(1, "75");
	}
	else if (sNumber == "9" && sDiscipline == "IH")
	{
		ShowManeuver(1, "94");
	}
	else if (sNumber == "9" && sDiscipline == "SS")
	{
		ShowManeuver(1, "115");
	}
	else if (sNumber == "9" && sDiscipline == "SH")
	{
		ShowManeuver(1, "126");
	}
	else if (sNumber == "9" && sDiscipline == "SD")
	{
		ShowManeuver(1, "157");
	}
	else if (sNumber == "9" && sDiscipline == "TC")
	{
		ShowManeuver(1, "169");
	}
	else if (sNumber == "9" && sDiscipline == "WR")
	{
		ShowManeuver(1, "204");
	}
}
	