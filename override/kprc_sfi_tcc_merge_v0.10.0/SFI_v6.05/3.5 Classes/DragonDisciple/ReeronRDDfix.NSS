//::///////////////////////////////////////////////

/*
	This initiates the RDD fix script.
	
	To use:
	
	Left-click on the main character.
	Highlight the main character by right-clicking on his/her portrait.
	Make sure you did both of the above steps.
	Press the tilde key "~" to enter the console.
	Type "DebugMode 1" and press the enter key.
	Type "rs reeronrddfix" and press the enter key.
	Type "DebugMode 0" and press the enter key.
	Close the console by pressing the tilde key "~".
	You are done.
	
	The script will fix all members, in your party, that have Red Dragon Disciple levels.
	There is no need to run it more than once, as it will fix all RDDs in your 
	party on the first running of the script.

*/
//:://////////////////////////////////////////////


#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "nwn2_inc_metmag"
#include "x2_inc_itemprop"

void main()
{

	
    int i1;
    int nRDDstart = 2863;// First original RDD feat.
    //int nRDDnewstart = 4350;// First new RDD feat is nRDDstart + 1487.
    int nRDDfinish = 2981;// Last original RDD feat.
    //int nRDDnewfinish = 4468;// Last new RDD feat is nRDDfinish + 1487.
    object oPartyMember = GetFirstFactionMember(GetFirstPC(), FALSE);
    while(GetIsObjectValid(oPartyMember) == TRUE)
    {
        //ExecuteScript("community_user_script_here", OBJECT_SELF);
        if(GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE ,oPartyMember) >0)
            {
            for(i1=nRDDstart; i1<=nRDDfinish; i1++)
                {
                if(GetHasFeat(i1, oPartyMember, TRUE)==TRUE)
                    {
                    FeatRemove(oPartyMember, i1);
                    FeatAdd(oPartyMember,(i1 + 1487), FALSE);
                    }
                }
            }
       
        oPartyMember = GetNextFactionMember(GetFirstPC(), FALSE);
    }
}