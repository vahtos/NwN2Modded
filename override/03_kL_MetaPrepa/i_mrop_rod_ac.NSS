// 'i_mrop_rod_ac'
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
// v.beta.7a, july 16 - remove debug-info on recasting buffs
// v.beta.7c, july 19 - touchup messages.
// v.beta.8, july 25
// ~ 2013 ~
// v.beta.93 april 19 - patched a hole where WildMagic could get turned off when it shouldn't.
//                    - tighten spellhook script swapping. Refactor.
//                    - removed calls to 'x2_inc_switches'
//                    - destroy Pages also when upgrading Rod.
//                    - moved isPartyInCombat() over to 'mrop_inc'
//                    - comment Debug.
// v.beta.93c april 19 - checks Associates for combatstate when trying to enter Learn mode.
// ~ 2016 ~
// v.beta.96 sept 9 - refactor.
//                  - Update kL_UpgradeVersion().
// ~ 2020 ~
// v.beta.97 march 12 - kL_UpgradeVersion() check for book before attempting to destroy it.
// v.beta.97a march 14 - reformat.
//
//
// Rod of Preparation - Item Activation Script
// -----------------------------------------------------
// This is the activation script for the Rod of Preparation.
// If NwN2-style tag-based scripts are enabled this script will be called when
// the Rod is activated.

#include "mrop_inc"
#include "mrop_inc_gui"

// __________________
// ------------------
// *** Prototypes ***
// __________________
// ------------------

// Upgrades oRod to the current version.
void kL_UpgradeVersion(object oRod);


// ____________
// ------------
// *** MAIN ***
// ____________
// ------------
void main()
{
	object oPC  = GetItemActivator();
	object oRod = GetItemActivated();

	if (GetIsObjectValid(oPC) && GetIsObjectValid(oRod))
	{
		// Destroy the rod & books, if earlier than v.beta.96
		if (GetLocalInt(oRod, MROP_VAR_VERSION) < 96)
		{
			kL_UpgradeVersion(oRod);
			return;
		}

		// Player just consoled the Setup script 'mrop.nss'
		if (!GetLocalInt(oRod, MROP_VAR_SETUP_COMPLETE))
		{
			SetLocalInt(oRod, MROP_VAR_SETUP_COMPLETE, TRUE);
			ShowSetupMessage(oPC, oRod);
			return;
		}

		// Delete the targeted Book of Preparations.
		object oTarget = GetItemActivatedTarget();
		if (GetTag(oTarget) == MROP_TAG_BOOK)
		{
			ShowDestroyBook(oPC, oRod, oTarget);
			return;
		}


		object oModule = GetModule();

		// spellhook script if it exists
		string sScript_active = GetLocalString(oModule, MROP_VAR_SPELLHOOK);
		string sScript_original;

		// allow Scripters to bypass warnings and get straight to the good stuff.
		int bUseIntegratedScript = GetLocalInt(oModule, MROP_VAR_USEINTEGRATED);
		if (!bUseIntegratedScript)
		{
			if (sScript_active == "")
			{
				// This prevents MRoP from applying a module's original script
				// * if that script has been purposely unHooked *
				DeleteLocalString(oModule, MROP_VAR_SPELLHOOK_ORIG);
			}
			else if (sScript_active != MROP_SPELLHOOK)
			{
				SetLocalString(oModule, MROP_VAR_SPELLHOOK_ORIG, sScript_active);
				sScript_original = sScript_active;
			}
			else // if (sScript_active == MROP_SPELLHOOK)
			{
				sScript_original = GetLocalString(oModule, MROP_VAR_SPELLHOOK_ORIG);
			}
		}


		object oArea = GetArea(oPC);

		// Switch between Learn & Play modes
		int bLearnActived = GetLocalInt(oModule, MROP_VAR_ACTIVE);
		if (oTarget == oRod && !bLearnActived)
		{
			if (isPartyInCombat(oPC, TRUE))
			{
				SendMessageToPC(oPC, "<c=moccasin>MRoP :</c> <c=firebrick>The"
						+ " Rod cannot be activated to Learn mode when Party is"
						+ " in combat.</c>");
				return;
			}

			// Activate the RoP so spells allow the hook to create Pages:
			SetLocalInt(oModule, MROP_VAR_ACTIVE, TRUE); // switch to Learn

			if (sScript_original != "")
			{
				SendMessageToPC(oPC, "<c=moccasin>MRoP :</c> <c=firebrick>WARNING.</c>"
						+ " You are opting to use the Rod of MetaMagics despite"
						+ " the fact that this module already has a spellhook"
						+ " script. Spellhooking causes additional code to run"
						+ " when spells are cast and the intentions of that"
						+ " code might not be compatible with the MetaRod"
						+ " ( material component usage, eg ). Continuing to use"
						+ " MRoP will cause the scripts to attempt to switch"
						+ " back and forth whenever the Rod is activated from"
						+ " Play to Learn modes or vice versa.");
			}

			if (!bUseIntegratedScript && sScript_active != MROP_SPELLHOOK)
			{
				// The MRoP spellhook is now Active:
				SetLocalString(oModule, MROP_VAR_SPELLHOOK, MROP_SPELLHOOK);
			}


			int bWildMagic = GetLocalInt(oArea, MROP_VAR_WILDMAGIC);
			if (!bWildMagic)
			{
				// Store the original False setting ( note this operates inversely )
				SetLocalInt(oArea, MROP_VAR_WILDMAGIC_ORIG, TRUE);
				// and set WildMagic true
				SetLocalInt(oArea, MROP_VAR_WILDMAGIC, TRUE);

				SendMessageToPC(oPC, "<c=moccasin>MRoP :</c> Wild Magic will be"
						+ " set on this Area.");
			}
			else
			{
				SendMessageToPC(oPC, "<c=moccasin>MRoP :</c> <c=firebrick>WARNING.</c>"
						+ " Wild Magic was already set on this Area.");
			}
			SendMessageToPC(oPC, "_ This allows uncontrolled companions to"
					+ " create Pages of Preparation in their Books.");


			// this could be replaced by a GUI messagebox
			// ... possibly spec'ing short/long buff modes.
			SendMessageToPC(oPC, "<c=moccasin>MRoP :</c> <c=lightgreen>The Rod"
					+ " is Active : Learn Mode</c>");
			SendMessageToPC(oPC, "_ Cast any buffs you want prepared as Pages"
					+ " in the Book of Preparations. Once that is done"
					+ " activate the Rod on itself a second time : this will"
					+ " prevent spells from being written in your Books.");

			SendMessageToPC(oPC, "<c=firebrick>__ DO NOT NEGLECT DEACTIVATION !</c>");
			SendMessageToPC(oPC, "<c=oldlace>_ Or else a Balor will be summoned"
					+ " to remind you ... they're big and mean and nasty and"
					+ " have big sharp pointy spikey teeth.</c>"
					+ " <c=firebrick><b>It will eat you</b>.</c>");
		}
		else if (bLearnActived) // switch to Play, whether Target=Rod or other
		{
			// de-activate the RoP so casts do not create Pages:
			SetLocalInt(oModule, MROP_VAR_ACTIVE, FALSE);

			if (!bUseIntegratedScript && sScript_original != "")
			{
				// NOTE: the MRoP script remains active ...
				// iff there's no original script ( and no Integration )
				SetLocalString(oModule, MROP_VAR_SPELLHOOK, sScript_original);
				SendMessageToPC(oPC, "<c=moccasin>MRoP :</c> The spellHook has"
						+ " reverted to its original state.");
			}

			if (GetLocalInt(oArea, MROP_VAR_WILDMAGIC_ORIG))
			{
				DeleteLocalInt(oArea, MROP_VAR_WILDMAGIC_ORIG);

				SetLocalInt(oArea, MROP_VAR_WILDMAGIC, FALSE);
				SendMessageToPC(oPC, "<c=moccasin>MRoP :</c> Wild Magic"
						+ " has reverted to its original state.");
			}

			SendMessageToPC(oPC, "<c=moccasin>MRoP :</c> <c=lightgreen>The Rod"
					+ " is not active : Play Mode</c>");
			SendMessageToPC(oPC, "_ Cast Spells will <b>not</b> be written as"
					+ " Pages in a Book until the Rod is activated on itself"
					+ " again.");
		}

		// **** CAST THE BUFFS already !!! ***
		if (oTarget != oRod)
		{
			DoControlCast(oPC, oRod);
		}
	}
}



// _________________
// -----------------
// *** Functions ***
// _________________
// -----------------

// Upgrades oRod to the current version.
void kL_UpgradeVersion(object oRod)
{
	object oPC = GetItemPossessor(oRod); // OBJECT_SELF, should be.

	SendMessageToPC(oPC, "<c=moccasin>MRoP :</c> <c=firebrick>Upgrading to ver.beta.96</c>");
	SendMessageToPC(oPC, "_ Your MetaRod as well as all Books & Pages have been"
			+ " destroyed. reRun the Setup script 'mrop' to persnaggle a new Rod.\n");

	SendMessageToPC(oPC, "_ beta.96 works around a quirk in the game engine."
			+ " The problem - when buffing in Fast mode ( previously Instantly )"
			+ " the metamagic variable tended to get dropped if it was followed"
			+ " by another preparation. The solution - add a half-second"
			+ " interval between casts in Fast mode. This does not affect As"
			+ " Actions, but other functions have been optimized and refactored.\n");

	SendMessageToPC(oPC, "_ Any books and pages that are NOT in the party have NOT"
			+ " been destroyed. They are obsolete, and should be avoided or"
			+ " manually destroyed. This message won't be shown again.\n");

	object oParty = GetFirstFactionMember(oPC, FALSE);
	while (GetIsObjectValid(oParty))
	{
		object oPage = GetFirstItemInInventory(oParty);
		while (GetIsObjectValid(oPage))
		{
			if (GetTag(oPage) == MROP_TAG_PAGE)
				DestroyObject(oPage); // Items do *not* have to be Plot=FALSE for destruction.

			oPage = GetNextItemInInventory(oParty);
		}

		object oBook = GetItemPossessedBy(oParty, MROP_TAG_BOOK);
		if (GetIsObjectValid(oBook))
			DestroyObject(oBook, 0.23f);

		oParty = GetNextFactionMember(oPC, FALSE);
	}

	DestroyObject(oRod);
}
