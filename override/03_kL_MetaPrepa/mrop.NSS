// 'mrop'
//
// LostCreation
// Rod of Preparation
// Version 0.04 (preview 2):
// 2010 april 1
//
// kevL's, 2012 july 2
// MetaRod of Preparations
// v.beta.5
// v.beta.6, july 11
// v.beta.7, july 14
// v.beta.8, july 25
// ~ 2013 ~
// v.beta.93 april 19 - tighten spellhook script swapping.
// v.beta.93a april 22 - check if player is already in OwnedPC.
//                     - break Rod creation out w/ delay.
// v.beta.93b april 25 - remove Rod creation breakout.
// ~ 2016 ~
// v.beta.96 sept 9 - freshen & refactor.
// ~ 2020 ~
// v.beta.97 march 12 - show message to player if the rod is reset.
// v.beta.97a march 14 - reformat.

#include "mrop_inc_const"


void main()
{
	object oPC = OBJECT_SELF;

	// toss the player back into OwnedCharacter
	if (!GetIsOwnedByPlayer(oPC))
	{
		oPC = SetOwnersControlledCompanion(oPC);
	}


	// check for prior spellhook script, and if none is found apply
	// 'mrop_spellhook' ( MROP_SPELLHOOK )
	// as the spellhook script -- else set the original spellhook script as a
	// LocalString and swap it out with the MRoP script during Learn mode.
	// - bUseIntegratedScript - lets designers bypass these warnings
	//							and go straight to the good stuff.
	object oModule = GetModule();
	int bUseIntegratedScript = GetLocalInt(oModule, MROP_VAR_USEINTEGRATED);
	if (!bUseIntegratedScript)
	{
		string sScript = GetLocalString(oModule, MROP_VAR_SPELLHOOK); // <- there is original spellhook script
		if (sScript != "" && sScript != MROP_SPELLHOOK)
		{
			SendMessageToPC(oPC, "<c=moccasin>MRoP :</c> <c=firebrick>spellHook"
					+ " is already enabled on this module.</c>");

			SendMessageToPC(oPC, "_ The MetaPrepa modification attempts to"
					+ " leave the original script intact. But it might fail."
					+ " Therefore you can ( a ) opt not to use the MetaRod at"
					+ " all, ( b ) use Lost Creation's Rod of Preparations,"
					+ " which does not interfere with spellhook scripting, or"
					+ " ( c ) contact the module's author and request that the"
					+ " MRoP script -- <c=white>mrop_spellhook</c> -- be merged"
					+ " with the existing spellhook, or even do it yourself. Or"
					+ " ( d ) use the Rod of MetaPreparation anyway -- the"
					+ " MetaRod code attempts to keep things sorted.\n\n"

					+ "Read further information when the MetaRod is activated."
					+ " The original spellhook script will switch to the"
					+ " MetaPrepa script as soon as the MetaRod is activated"
					+ " and targeted on itself -- but then swap back when"
					+ " deactivated.");

			SetLocalString(oModule, MROP_VAR_SPELLHOOK_ORIG, sScript);
		}
		else // -> no original spellhook script, set MRoP script as spellhook ....
		{
			SendMessageToPC(oPC, "<c=moccasin>MRoP :</c> <c=firebrick>spellHook"
					+ " is now enabled on this module.</c>");
			SetLocalString(oModule, MROP_VAR_SPELLHOOK, MROP_SPELLHOOK);
		}
	}


	// the Party gets only one Rod
	// "One Rod to Rule them all and ... " yeah whatver.
	object oRod = OBJECT_INVALID;

	object oParty = GetFirstFactionMember(oPC, FALSE);
	while (GetIsObjectValid(oParty))
	{
		oRod = GetItemPossessedBy(oParty, MROP_TAG_ROD);
		if (GetIsObjectValid(oRod))
			break;

		oParty = GetNextFactionMember(oPC, FALSE);
	}

	if (!GetIsObjectValid(oRod))
	{
		oRod = CreateItemOnObject(MROP_TAG_ROD, oPC);
	}
	else // reset setup ->
	{
		DeleteLocalInt(oRod, MROP_VAR_SETUP_COMPLETE);
		SendMessageToPC(oPC, "<c=moccasin>MRoP :</c> Your MetaRod has been reset."
				+ " The GUI setup shall be displayed the next time the Rod is activated.");
	}
}
