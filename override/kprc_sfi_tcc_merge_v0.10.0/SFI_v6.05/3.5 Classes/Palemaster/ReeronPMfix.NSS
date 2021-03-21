//::///////////////////////////////////////////////

/*
	This initiates the PM fix script.
	
	To use:
	
	Left-click on the main character.
	Highlight the main character by right-clicking on his/her portrait.
	Make sure you did both of the above steps.
	Press the tilde key "~" to enter the console.
	Type "DebugMode 1" and press the enter key.
	Type "rs reeronpmfix" and press the enter key.
	Type "DebugMode 0" and press the enter key.
	Close the console by pressing the tilde key "~".
	You are done.
	
	The script will fix all members, in your party, that have Palemaster levels.
	There is no need to run it more than once, as it will fix all PMs in your 
	party on the first running of the script. This only needs to be run if any 
	Palemasters are above 4th level. Those PMs that are 4th level, or less, are not 
	affected, and therefore, this script doesn't need to be run on them.

*/
//:://////////////////////////////////////////////


#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "nwn2_inc_metmag"
#include "x2_inc_itemprop"

void main()
{

	
	
	object oPartyMember = GetFirstFactionMember(GetFirstPC(), FALSE);
	while(GetIsObjectValid(oPartyMember) == TRUE)
	{
		//ExecuteScript("community_user_script_here", OBJECT_SELF);
        if(GetLevelByClass(CLASS_TYPE_PALEMASTER ,oPartyMember) >6)
            {
            FeatRemove(oPartyMember, 2861);
            FeatRemove(oPartyMember, 2862);
            FeatAdd(oPartyMember, 3403, FALSE);
            FeatAdd(oPartyMember, 3404, FALSE);
            }
        else if (GetLevelByClass(CLASS_TYPE_PALEMASTER ,oPartyMember) >4)
            {
            FeatRemove(oPartyMember, 2861);
            FeatAdd(oPartyMember, 3403, FALSE);
            }
		oPartyMember = GetNextFactionMember(GetFirstPC(), FALSE);
	}	
}