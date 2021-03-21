// 'mrop_inc_preps'
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
// v.beta.7c, july 19 - expanded feedback if Prep not created.
//                    - changed feedback recipient to factionLeader
// v.beta.8, july 25
// ~ 2013 ~
// v.beta.93 april 19 - change 'oStore' to 'oBook', 'oSelf' to 'oPage'
//                    - changed 'sName' to 'sTalent'
//                    - renamed a dozen constants. at Liberty.
// v.beta.93b april 25 - moved GetPreparationStore() over from 'mrop_inc'
//                     - changed "s Name" string to "s Talent"
//                     - add check for iMeta in GetPreparationsEqual().
//                     - comment Debug.
// v.beta.93c april 26 - Changed parameter name oPC to oCaster in GetPreparationStore()
// v.beta.94 april 26 - adjusting comments.
// ~ 2016 ~
// v.beta.96 sept 9 - refactor & format.
// ~ 2020 ~
// v.beta.97a march 14 - reformat and break out constants to 'mrop_inc_const'.


#include "mrop_inc_const"

// _______________
// ---------------
// *** Structs ***
// _______________
// ---------------

struct preparation
{
	// Where the preparation is stored:
	object oPage;		// for self reference
	object oBook;		// in-game object that stores this preparation

	// What the preparation casts:
	string sTitle;		// the title of the Spell or Feat.
	int    iType;		// the TALENT_TYPE_* ( spell or feat )
	int    iSpellId;	// the SpellID in Spells.2da
	int    bCheat;		// boolean TRUE if the caster must "cheat" to cast this spell;
						// ie. a subradial spell with a Master spell.

	// Who casts it and on what:
	string sCreator;	// name of creator
	string sTarget;		// name of target (or the target's master)
	int    iAssoc;		// ASSOCIATE_TYPE_*

	// kL, additions for the MetaRoP:
	int    iMeta;		// to cast spell w/ proper metamagic
	int    iFeatId;		// if Feat store this ( as well as SpellID ).
	int    bItem;		// true if Target is an item.
};


// __________________
// ------------------
// *** Prototypes ***
// __________________
// ------------------

// Gets the active preparation store for oPC. Creates it if it doesn't exist.
object GetPreparationStore(object oCaster, int bCreate = TRUE);

// Get oPage's local preparation variable sVar.
// * Return value on error: Preparation();
struct preparation GetLocalPreparation(object oPage, string sVar);

// Set oPage's local preparation variable sVar to pPrep.
void SetLocalPreparation(object oPage, string sVar, struct preparation pPrep);

// Creates a new preparation with valid default fields.
struct preparation Preparation();

// Creates a debug string for pPrep
string PreparationToDebugString(struct preparation pPrep);

// Adds pPrep to a Page if it is new.
void AddPreparation(struct preparation pPrep, object oBook = OBJECT_INVALID);

// Searches oBook for a preparation for which GetPreparationsEqual() comparison is TRUE.
struct preparation FindPreparation(struct preparation pPrep, object oBook);

// Saves any changes to pPrep.
struct preparation SavePreparation(struct preparation pPrep);

// Returns TRUE if pPrep is a valid preparation.
int GetIsPreparationValid(struct preparation pPrep);

// Two preparations are equal if the following Vars are the same:
// - sCreator
// - sTarget
// - iAssoc
// - bItem
// - iSpellId
// - iFeatId
// - iType
// - iMeta
int GetPreparationsEqual(struct preparation pOne, struct preparation pTwo);

// Gets the first preparation from oBook
struct preparation GetFirstPreparation(object oBook);

// Gets the next preparation from oBook
struct preparation GetNextPreparation(object oBook);

// Returns a name for the Page.
string GetActionMessage(struct preparation pTalent);

// kL. not used in MRoP.
// Delete oPage's local preparation variable sVar.
//void DeleteLocalPreparation(object oPage, string sVar);

// kL. not used in MetaPrepa.
// Deletes all preparation records in oBook.
//void DeleteAllPreparations(object oBook);


// _________________
// -----------------
// *** Functions ***
// _________________
// -----------------

// Gets the active preparation store for oCaster. Creates it if it doesn't exist.
object GetPreparationStore(object oCaster, int bCreate = TRUE)
{
	object oBook = GetItemPossessedBy(oCaster, MROP_TAG_BOOK);
	if (!GetIsObjectValid(oBook) && bCreate)
		oBook = CreateItemOnObject(MROP_TAG_BOOK, oCaster);

	return oBook;
}


// Get oPage's local preparation variable sVar.
// * Return value on error: Preparation();
struct preparation GetLocalPreparation(object oPage, string sVar)
{
	struct preparation pPrep;

	if (GetIsObjectValid(oPage))
	{
		pPrep.oPage = oPage;

		pPrep.sTitle   = GetLocalString(oPage, sVar + ".sTitle");
		pPrep.iType    = GetLocalInt   (oPage, sVar + ".iType");
		pPrep.iSpellId = GetLocalInt   (oPage, sVar + ".iSpellId");
		pPrep.bCheat   = GetLocalInt   (oPage, sVar + ".bCheat");

		pPrep.sCreator = GetLocalString(oPage, sVar + ".sCreator");
		pPrep.sTarget  = GetLocalString(oPage, sVar + ".sTarget");
		pPrep.iAssoc   = GetLocalInt   (oPage, sVar + ".iAssoc");
		pPrep.bItem    = GetLocalInt   (oPage, sVar + ".bItem");

		pPrep.iMeta    = GetLocalInt   (oPage, sVar + ".iMeta");
		pPrep.iFeatId  = GetLocalInt   (oPage, sVar + ".iFeatId");
	}
	return pPrep;
}


//
void SetLocalPreparation(object oPage, string sVar, struct preparation pPrep)
{
	SetLocalString(oPage, sVar + ".sTitle",   pPrep.sTitle);
	SetLocalInt   (oPage, sVar + ".iType",    pPrep.iType);
	SetLocalInt   (oPage, sVar + ".iSpellId", pPrep.iSpellId);
	SetLocalInt   (oPage, sVar + ".bCheat",   pPrep.bCheat);

	SetLocalString(oPage, sVar + ".sCreator", pPrep.sCreator);
	SetLocalString(oPage, sVar + ".sTarget",  pPrep.sTarget);
	SetLocalInt   (oPage, sVar + ".iAssoc",   pPrep.iAssoc);
	SetLocalInt   (oPage, sVar + ".bItem",    pPrep.bItem);

	SetLocalInt   (oPage, sVar + ".iMeta",    pPrep.iMeta);
	SetLocalInt   (oPage, sVar + ".iFeatId",  pPrep.iFeatId);
}


//
struct preparation Preparation()
{
	struct preparation pBlank;

	// Where the preparation is stored:
	pBlank.oPage    = OBJECT_INVALID;
	pBlank.oBook    = OBJECT_INVALID;

	// What the preparation casts:
	pBlank.sTitle   = "";
	pBlank.iType    = TALENT_TYPE_UNKNOWN;
	pBlank.iSpellId = SPELL_INVALID;
	pBlank.bCheat   = FALSE;

	// Who casts it and on what:
	pBlank.sCreator = "";
	pBlank.sTarget  = "";
	pBlank.iAssoc   = ASSOCIATE_TYPE_NONE;
	pBlank.bItem    = FALSE;

	pBlank.iMeta    = METAMAGIC_NONE;
	pBlank.iFeatId  = FEAT_INVALID;

	return pBlank;
}


//
string PreparationToDebugString(struct preparation pPrep)
{
	return " - o Page : "      + GetName(pPrep.oPage)        + "\n" +
		   " - o Book : "      + GetName(pPrep.oBook)        + "\n\n" +

		   " - s Title : "     + pPrep.sTitle                + "\n" +
		   " - i Type ID : "   + IntToString(pPrep.iType)    + "\n" +
		   " - i Spell ID : "  + IntToString(pPrep.iSpellId) + "\n" +
		   " - i Feat ID : "   + IntToString(pPrep.iFeatId)  + "\n" +
		   " - i Metamagic : " + IntToString(pPrep.iMeta)    + "\n" +
		   " - b Cheat : "     + IntToString(pPrep.bCheat)   + "\n\n" +

		   " - s Creator : "   + pPrep.sCreator              + "\n" +
		   " - s Target : "    + pPrep.sTarget               + "\n" +
		   " - i Assoc ID : "  + IntToString(pPrep.iAssoc)   + "\n" +
		   " - b Item : "      + IntToString(pPrep.bItem);
}


// Adds pPrep to a Page if it is new.
void AddPreparation(struct preparation pPrep, object oBook = OBJECT_INVALID)
{
//	if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, "run AddPreparation ( ) - " + GetName(OBJECT_SELF));

	if (!GetIsObjectValid(oBook))
		oBook = pPrep.oBook;

	if (oBook != pPrep.oBook)
		pPrep.oBook = oBook;

	// this is for feedback to the Player ( sends messages to ControlledCharacter )
	object oLeader = GetFactionLeader(OBJECT_SELF);

	pPrep = FindPreparation(pPrep, oBook);
	if (!GetIsObjectValid(pPrep.oPage))
	{
		pPrep.oPage = CreateItemOnObject(MROP_TAG_PAGE, oBook);
		if (GetIsObjectValid(pPrep.oPage))
		{
			SendMessageToPC(oLeader, "<c=moccasin>MRoP :</c> Page created");
			SavePreparation(pPrep);
		}
//		else if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, ". Prep not created - error on CreateItem");
	}
	else
	{
		SendMessageToPC(oLeader, "<c=moccasin>MRoP :</c> Page already exists -"
				+ " preparation <b>not</b> created");
		SendMessageToPC(oLeader, "_ Caster = " + pPrep.sCreator
				+ " . Spell = <c=orchid>" + pPrep.sTitle
				+ "</c> . Target = " + pPrep.sTarget + "\n");
	}
}


// Searches oBook for a preparation for which GetPreparationsEqual() is TRUE.
struct preparation FindPreparation(struct preparation pPrep, object oBook)
{
	struct preparation pFound = GetFirstPreparation(oBook);
	while (GetIsPreparationValid(pFound))
	{
		if (GetPreparationsEqual(pPrep, pFound))
			return pFound;

		pFound = GetNextPreparation(oBook);
	}

	pPrep.oPage = OBJECT_INVALID;
	pPrep.oBook = oBook;

	return pPrep;
}


//
struct preparation SavePreparation(struct preparation pPrep)
{
	SetFirstName(pPrep.oPage, GetActionMessage(pPrep));

	string sDebug = PreparationToDebugString(pPrep);

	SetDescription(pPrep.oPage, "As long as you keep this Page in your Book of"
			+ " MetaPrepas, the character will do the indicated action whenever"
			+ " the Rod of MetaPrepas is activated for Buffing.\n\n"

			+ "To destroy a Page, take it out of its Book and use its special"
			+ " action.\n\n\n"

			+ sDebug);

	SetLocalPreparation(pPrep.oPage, MROP_TAG_PAGE, pPrep);

	return pPrep;
}


// Returns TRUE if pPrep is a valid preparation.
int GetIsPreparationValid(struct preparation pPrep)
{
	if (pPrep.sCreator == "" || pPrep.sTarget == "")
		return FALSE;

	switch (pPrep.iType)
	{
		case TALENT_TYPE_SPELL:
			return (pPrep.iSpellId != SPELL_INVALID);

		case TALENT_TYPE_FEAT:
			return (pPrep.iFeatId != FEAT_INVALID);
	}
	return TRUE;
}


// Two preparations are equal if the following Vars are the same:
// - sCreator
// - sTarget
// - iAssoc
// - bItem
// - iSpellId
// - iFeatId
// - iType
// - iMeta
int GetPreparationsEqual(struct preparation pOne, struct preparation pTwo)
{
	return pOne.sCreator == pTwo.sCreator
		&& pOne.sTarget  == pTwo.sTarget
		&& pOne.iAssoc   == pTwo.iAssoc
		&& pOne.bItem    == pTwo.bItem
		&& pOne.iSpellId == pTwo.iSpellId
		&& pOne.iFeatId  == pTwo.iFeatId
		&& pOne.iType    == pTwo.iType
		&& pOne.iMeta    == pTwo.iMeta;
}


// Gets the first preparation from oBook
struct preparation GetFirstPreparation(object oBook)
{
	object oPage             = GetFirstItemInInventory(oBook);
	struct preparation pPrep = GetLocalPreparation(oPage, MROP_TAG_PAGE);
	pPrep.oBook              = oBook;

	return pPrep;
}

// Gets the next preparation from oBook
struct preparation GetNextPreparation(object oBook)
{
	object oPage             = GetNextItemInInventory(oBook);
	struct preparation pPrep = GetLocalPreparation(oPage, MROP_TAG_PAGE);
	pPrep.oBook              = oBook;

	return pPrep;
}


// Returns a name for the Page.
string GetActionMessage(struct preparation pTalent)
{
	string sMessage;
	switch (pTalent.iType)
	{
		case TALENT_TYPE_SPELL:
			sMessage = "I will cast the spell <c=lightgreen>" + pTalent.sTitle;
			break;

		case TALENT_TYPE_FEAT:
			sMessage = "I will use the feat <c=slateblue>" + pTalent.sTitle;
			break;

		case TALENT_TYPE_ITEM_SPELL:
			sMessage = "I will use the item <c=gainsboro>" + pTalent.sTitle;
			break;

		case TALENT_TYPE_SKILL:
		case TALENT_TYPE_UNKNOWN:
		default:
			sMessage += "I will use <c=firebrick>" + pTalent.sTitle;
	}

	if (pTalent.bCheat)
		sMessage += " (10)";

	switch (pTalent.iMeta)
	{
//		case METAMAGIC_NONE: // not handled ( standard spell )

		case METAMAGIC_EMPOWER:    sMessage += " (Empower)";    break;
		case METAMAGIC_EXTEND:     sMessage += " (Extend)";     break;
		case METAMAGIC_MAXIMIZE:   sMessage += " (Maximize)";   break;
		case METAMAGIC_QUICKEN:    sMessage += " (Quicken)";    break;
		case METAMAGIC_SILENT:     sMessage += " (Silent)";     break;
		case METAMAGIC_STILL:      sMessage += " (Still)";      break;
		case METAMAGIC_PERSISTENT: sMessage += " (Persistent)"; break;
		case METAMAGIC_PERMANENT:  sMessage += " (Permanent)";  break;

//		default:
//			if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, ". pTalent.iMeta value not found");
	}

	sMessage += "</c>";

	if (pTalent.sTarget != pTalent.sCreator)
	{
		sMessage += " on " + pTalent.sTarget;
		if (pTalent.iAssoc != ASSOCIATE_TYPE_NONE)
		{
			if (GetStringRight(pTalent.sTarget, 1) == "s")
				sMessage += "'";
			else
				sMessage += "'s";
		}
	}
	else if (pTalent.iAssoc != ASSOCIATE_TYPE_NONE)
		sMessage += " on my";
	else
		sMessage += " on myself";

	switch (pTalent.iAssoc)
	{
		case ASSOCIATE_TYPE_ANIMALCOMPANION: sMessage += " Animal Companion";  break;
		case ASSOCIATE_TYPE_FAMILIAR:        sMessage += " Familiar";          break;
		case ASSOCIATE_TYPE_SUMMONED:        sMessage += " Summoned Creature"; break;
	}

	return sMessage;
}


// kL. not used in MRoP
/* void DeleteLocalPreparation(object oPage, string sVar)
{
	DeleteLocalString(oPage, sVar + ".sTitle");
	DeleteLocalInt   (oPage, sVar + ".iType");
	DeleteLocalInt   (oPage, sVar + ".iSpellID");
	DeleteLocalInt   (oPage, sVar + ".bCheat");

	DeleteLocalString(oPage, sVar + ".sCreator");
	DeleteLocalString(oPage, sVar + ".sTarget");
	DeleteLocalInt   (oPage, sVar + ".iAssoc");
	DeleteLocalInt   (oPage, sVar + ".bItem");

	DeleteLocalInt   (oPage, sVar + ".iMeta");
	DeleteLocalInt   (oPage, sVar + ".iFeatID");
} */


// kL. not used in MetaPrepa.
/* void DeleteAllPreparations(object oBook)
{
	object oPage = GetFirstItemInInventory(oBook);
	while (oPage != OBJECT_INVALID)
	{
		DestroyObject(oPage, 0.1f, FALSE);
		oPage = GetNextItemInInventory(oBook);
	}
} */
