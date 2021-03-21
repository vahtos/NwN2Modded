// 'mrop_inc'
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
// v.beta.7b, july 16 - fix bCheat ( subradials ), both prep & cast
// v.beta.7c, july 19 - bypass OnItem iteration code if TargetItem not valid.
//                    - feedback for prep Page losing sync w/ metamagic type.
//                    - added return & feedback if Target is not in PC faction.
//                    - NB. above not yet done for EncapsulateFeat()
//                    - changed feedback recipient to factionLeader
// v.beta.8, july 25
// v.beta.9, sept 5 - fixed typos re. Bull's Strength etc. in isClericDomainSpell()
// ~ 2013 ~
// v.beta.93 april 19 - change 'oStore' to 'oBook', 'bOnItem' to 'bItem'
//                    - rename AddPreparationToStore() to AddPreparationToBook()
//                    - change DoControlCast() parameter 'oItem' to 'oObject'
//                    - changed ActionCastSpell to ActionUseFeat() for feats.
//                    - changed default value of 'bInstant' to FALSE for EncapsulateSpell()
//                    - parsed down isClericDomainSpell() to check only actual Domain feats.
// v.beta.93b april 24 - Instant Feats. Added kPrC Telthor Companion.
//                     - moved GetPreparationStore() over to 'mrop_inc_preps'
//                     - had to change AnComs & Familiars back to summon via ActionCastSpell,
//                       because ActionUseFeat() just doesn't do it.
//                     - re-implemented GetCastInstant() and did away with SetCastInstant();
//                       prevents excessive function calls. But now all members of Party
//                       are bInstant or not ( was, one might be, another might not );
//                       changed some defaults & stuff .... like putting the call right
//                       at the top of DoControlCast()
//                     - moved DoControlCast() & GetCastInstant() down into the Casting section.
//                     - wrote isInspirationInactive() to stop BardicInspirations from turning off.
//                     - comment Debug.
//                     - moved isPartyInCombat() over from 'i_mrop_rod_ac'
// v.beta.93c april 26 - removed some comments. Changed some parameter names.
//                     - fixed DoControlCast().. duh.
// ~ 2016 ~
// v.beta.96 sept 9 - workaround for "Persistent Haste" bug: Metamagic var gets
//                    dropped on bInstant if another preparation-cast follows.
//                    Delay casts by half-second intervals - (float)fDelay is
//                    retrieved from the Rod itself.
//                  - refactor, esp. isClericDomainSpell() use switch/case.
// ~ 2020 ~
// v.beta.97a march 13 - reformat and refactor a bit.
//
//
// Rod of Preparation - Include File
// ---------------------------------------------------------
// Contains the shared resources used by all RoP scripts.
// See "_ReadMe_kL_mRoP.txt" for more information.
//
// If you want to limit when the player can use fast casting, create a local_int
// "MROP_NOT_INSTANT" on any of these in-game objects, and set it to a non-zero
// integer.
// * on The Rod itself - that Rod will never use Fast casting.
// * on An Area        - Fast casting will not work in that area.
// * on The Module     - Fast casting will not work at all anywhere.


#include "mrop_inc_preps"

// ___________________
// -------------------
// *** Script Vars ***
// ___________________
// -------------------
float _fDel;
float _fInterval;


// __________________
// ------------------
// *** Prototypes ***
// __________________
// ------------------
// ____________________
// ** PREPARE PREPS ***

// this is where struct.preparation begins ...
//
// Creates iSpellId as a Page in a Book.
void AddPreparationToBook(int iSpellId,
						  object oBook,
						  object oCaster,
						  object oTarget,
						  int iMeta,
						  int iType,
						  int bItem);

// Sets up pTalent to use preparations on Characters & Associates.
struct preparation DetectTargetType(struct preparation pTalent, object oTarget);

// Gets the FeatID that was used to create a spell effect.
int GetFeatId(int iSpellId);

// Checks if the spell has a master spell (if so the cast needs to bCheat).
// @note SpellID #0 (AcidFog) is NOT a valid Masterspell.
int hasMasterSpell(int iSpellId);

// Gets the name of the Spell or Feat.
string GetTalentTitle(int iTalentId, int iType);


// ____________________
// ** CASTING PREPS ***

// Casts all preparations in Party.
void DoControlCast(object oActivator, object oRod);

// Checks if oRod will cast Fast spells.
// - checks Rod ( see Setup script 'mrop' ), Activator's area & module, as well
//   as party combat state
int isFastCast(object oActivator, object oRod);

// Checks if oPC's faction has any member that is currently in combat.
// - lifted from 'ginc_death'
// - bAssoc - if FALSE only check members that are PC or Roster member.
//            if TRUE include Associates.
int isPartyInCombat(object oMember = OBJECT_SELF, int bAssoc = FALSE);

// Commands oCaster to do all of his/her preparations.
void DoAllPreparations(object oBook, int bInstant);

// oCaster casts pSpell.
void EncapsulateSpell(struct preparation pSpell,
					  int bInstant,
					  int iIteration = 0,
					  object oPossessor = OBJECT_INVALID,
					  object oItem = OBJECT_INVALID);

// oCaster uses pFeat.
void EncapsulateFeat(struct preparation pFeat, int bInstant);

// Gets the target object for pPrep.
object GetPreparationTarget(struct preparation pPrep, object oPC);

// Gets the member of oPC's party that has name, sTarget.
object GetTargetByName(string sTarget, object oPC);

// Helper for EncapsulateFeat().
// - also returns TRUE if not an Inspiration
int isInspirationInactive(int iFeatId, object oTarget = OBJECT_SELF);


// Extras.

// Community Scripting Library: '_CSLCore_Strings.nss'.
string CSLGetLegalCharacterString(string sString, string sValid = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ");

// Used by spellscripts that target an item. Searches for valid TargetItem local_object.
object GetMRoPTarget(int iSpellId, object oTarget);

// For determining whether to bCheat a Cleric's domain-granted spell(s).
// - called from EncapsulateSpell()
int isClericDomainSpell(int iSpellId, object oCaster = OBJECT_SELF);

// Sets oTarget to cast spells Fastly when possible.
// kL. no Longer Needed: all casters treated identically in MRoP
//void SetCastInstant(object oCaster, int bInstant = FALSE);

// kL, not used in metaRoP
// Checks to see if oMaster has an animal companion or familiar
// summoned and adds the appropriate preparations to the Rod.
//kL void AddAssociateSummons(object oMaster, int nAssociateType = ASSOCIATE_TYPE_ANIMALCOMPANION);

// kL, not used in metaRoP
// Broadcasts an approprate message to oCaster that pTalent is being used or recorded.
//kL void BroadcastPreparationMessage(struct preparation pTalent, object oCaster,
//		int bRecorded = FALSE, int bDelay = FALSE);




// _________________
// -----------------
// *** Functions ***
// _________________
// -----------------
// ____________________
// ** PREPARE PREPS ***

// kL, this is where struct.preparation begins ......
//
// Creates iSpellId as a Page in a Book.
void AddPreparationToBook(int iSpellId,
						  object oBook,
						  object oCaster,
						  object oTarget,
						  int iMeta,
						  int iType,
						  int bItem)
{
//	if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, "run AddPreparationToBook ( ) - " + GetName(OBJECT_SELF));
	// Sanity checks ...
//	if (!GetIsObjectValid(oCaster)) return;
//	if (!GetIsObjectValid(oTarget)) return;
//	if (!GetIsObjectValid(oBook))	return;
//	if (iSpellId < 0)				return;


	// Now the real work.
	struct preparation pTalent = Preparation();

	pTalent.oBook    = oBook;
	pTalent.sCreator = GetName(oCaster);
	pTalent.iSpellId = iSpellId;
	pTalent.iMeta    = iMeta;
	pTalent.iType    = iType;
	pTalent.bItem    = bItem;

	switch (iType)
	{
		default:
		case TALENT_TYPE_SPELL:
			// kL-130419: Make this return and store the parentSpell:
			pTalent.bCheat = hasMasterSpell(iSpellId);			// get if spell has a masterspell
			pTalent.sTitle = GetTalentTitle(iSpellId, iType);	// get name of spell

			if (bItem)
			{
				// *cough* This string isn't being taken off anywhere, and theoretically lives the life
				// of the item; that can create a problem if this Prep is removed or destroyed ( and
				// the caster decides to cast the same spell onto a different item w/ the same name ! )
				SetLocalString(oTarget, MROP_VAR_CAST_ITEM, pTalent.sCreator + IntToString(iSpellId));
			}
			break;

		case TALENT_TYPE_FEAT:
//			if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, ". convert ID to FeatID");
			pTalent.iFeatId = GetFeatId(iSpellId);						// turn SpellID into FeatID
			pTalent.sTitle  = GetTalentTitle(pTalent.iFeatId, iType);	// get name of feat
	}

	pTalent = DetectTargetType(pTalent, oTarget);	// returns sTarget, iAssociate
	AddPreparation(pTalent);						// store it!
}


// Sets up pTalent to use preparations on companions and summoned creatures.
struct preparation DetectTargetType(struct preparation pTalent, object oTarget)
{
	int iAssoc = GetAssociateType(oTarget);
	switch (iAssoc)
	{
		case ASSOCIATE_TYPE_NONE:
			pTalent.sTarget = GetName(oTarget);
			pTalent.iAssoc  = iAssoc;
			break;

		case ASSOCIATE_TYPE_ANIMALCOMPANION:
		case ASSOCIATE_TYPE_FAMILIAR:
		case ASSOCIATE_TYPE_SUMMONED:		// iffy ...
			pTalent.sTarget = GetName(GetMaster(oTarget));
			pTalent.iAssoc  = iAssoc;
			break;

		default:
		case ASSOCIATE_TYPE_HENCHMAN:		// multiple generic names cause Probls.
		case ASSOCIATE_TYPE_DOMINATED:		// too short to bother (?)
			pTalent = Preparation();		// <- this wipes the Prep.
	}

	return pTalent;
}


// Gets the FeatID that was used to create a spell effect.
int GetFeatId(int iSpellId)
{
	// look up FeatID from Spells.2da ( ie. iID is passed from the spellhook as a Spell_ID )
	// so back-reference it so it can be stored as a Feat_ID.
	return StringToInt(Get2DAString("spells", "FeatID", iSpellId));
}


// Checks if the spell has a master spell (if so the cast needs to bCheat).
// @note SpellID #0 (AcidFog) is NOT a valid Masterspell.
int hasMasterSpell(int iSpellId)
{
	return (StringToInt(Get2DAString("spells", "Master", iSpellId)) != 0);
}


// Gets the name of the Spell or Feat.
string GetTalentTitle(int iTalentId, int iType)
{
	string s2da, sCol;
	switch (iType)
	{
		default:
		case TALENT_TYPE_SPELL:
			s2da = "spells";
			sCol = "Name";
			break;

		case TALENT_TYPE_FEAT:
			s2da = "feat";
			sCol = "FEAT";
	}

	string sTitle = Get2DAString(s2da, sCol, iTalentId);
	if (sTitle != "")
		sTitle = GetStringByStrRef(StringToInt(sTitle));

	return ((sTitle == "") ? "unknown" : sTitle); // safety.
}


// ____________________
// ** CASTING PREPS ***

// Casts all preparations in Party.
void DoControlCast(object oActivator, object oRod)
{
//	if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, "run DoControlCast ( ) - " + GetName(OBJECT_SELF));

	int bInstant = isFastCast(oActivator, oRod);

	_fInterval = GetLocalFloat(oRod, MROP_VAR_FAST_DELAY);
	if (_fInterval < 0.f) _fInterval = 0.f;
//	if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, ". fInterval = " + FloatToString(_fInterval, 18, 2));

	object oBook;

	object oParty = GetFirstFactionMember(oActivator, FALSE);
	while (GetIsObjectValid(oParty))
	{
		oBook = GetPreparationStore(oParty, FALSE);
		if (GetIsObjectValid(oBook)) // Associates not allowed here. Only Faction w/ Book ...
		{
			_fDel = 0.f; // reset for each Caster, it gets incremented in EncapsulateSpell().

			AssignCommand(oParty, ClearAllActions());
			AssignCommand(oParty, DoAllPreparations(oBook, bInstant));
		}
		oParty = GetNextFactionMember(oActivator, FALSE);
	}
}


// Checks if oRod will cast Fast spells.
// - checks Rod ( see Setup script 'mrop' ), Activator's area & module, as well as party combat state
int isFastCast(object oActivator, object oRod)
{
	if (   GetLocalInt(oRod, MROP_VAR_NOT_INSTANT)
		|| GetLocalInt(GetModule(), MROP_VAR_NOT_INSTANT)
		|| GetLocalInt(GetArea(oActivator), MROP_VAR_NOT_INSTANT))
	{
		return FALSE;
	}

	if (isPartyInCombat(oActivator)) // let Associates fight while party buffs Fastly
	{
		object oLeader = GetFactionLeader(oActivator);
		SendMessageToPC(oLeader, "<c=moccasin>MRoP :</c> Party in Combat ! ! !");
		return FALSE;
	}

	return TRUE;
}

// Checks if oPC's faction has any member that is currently in combat.
// - lifted from 'ginc_death'
// - bAssoc - if FALSE only check members that are PC or Roster member.
//            if TRUE include Associates.
int isPartyInCombat(object oPC = OBJECT_SELF, int bAssoc = FALSE)
{
	object oParty = GetFirstFactionMember(oPC, FALSE);
	while (GetIsObjectValid(oParty))
	{
		if (GetIsInCombat(oParty)
			&& (bAssoc || GetAssociateType(oParty) == ASSOCIATE_TYPE_NONE))
		{
			return TRUE;
		}
		oParty = GetNextFactionMember(oPC, FALSE);
	}
	return FALSE;
}


// Commands oCaster to do all of his/her preparations.
// - oCaster is OBJECT_SELF, see DoControlCast()
void DoAllPreparations(object oBook, int bInstant)
{
//	if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, "run DoAllPreparations ( ) - " + GetName(OBJECT_SELF));

	object oCaster = OBJECT_SELF;

	// this needs to be outside GetIsPreparationValid() so that it does not
	// clear w/ each Preparation.
	string sPossessor_ID_total = "";

	struct preparation pPrep = GetFirstPreparation(oBook);
	while (GetIsPreparationValid(pPrep))
	{
/*		switch (pPrep.iAssoc)
		{
			case ASSOCIATE_TYPE_ANIMALCOMPANION:
			case ASSOCIATE_TYPE_FAMILIAR:
			case ASSOCIATE_TYPE_SUMMONED:
				bDelay = TRUE;
				break;

			default:
				bDelay = FALSE;
				break;
		} */

		switch (pPrep.iType)
		{
			case TALENT_TYPE_SPELL:
			{
				object oItem      = OBJECT_INVALID;
				object oPossessor = OBJECT_INVALID;
				int iIteration = 0;

				if (pPrep.bItem)
				{
					int bFound = FALSE;
					int iSlot;

					object oParty = GetFirstFactionMember(oCaster, FALSE);
					while (GetIsObjectValid(oParty) && !bFound)
					{
//						if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, ". Looping faction member = " + GetName(oParty));
						oItem = GetFirstItemInInventory(oParty);
						while (GetIsObjectValid(oItem))
						{
//							if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, ". Looping inventory item = " + GetName(oItem));
							if (pPrep.sTarget == GetName(oItem)
								&& GetLocalString(oItem, MROP_VAR_CAST_ITEM) == pPrep.sCreator + IntToString(pPrep.iSpellId)
								&& !GetLocalInt(oItem, MROP_VAR_FLAG_ITEM))
							{
								SetLocalInt(oItem, MROP_VAR_FLAG_ITEM, TRUE);
								DelayCommand(1.f, DeleteLocalInt(oItem, MROP_VAR_FLAG_ITEM));

								bFound = TRUE;
								break;
							}
							oItem = GetNextItemInInventory(oParty);
						}

						if (!bFound)
						{
							iSlot = INVENTORY_SLOT_HEAD; // slots could prolly be cut back to include only chest, left & right hands and arms for bracers
							while (iSlot != INVENTORY_SLOT_CWEAPON_L) // <-- bypass creature Bite, Left & Right, & carapice.
							{
								oItem = GetItemInSlot(iSlot, oParty);
//								if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, ". Looping inventory slot = " + IntToString(iSlot) + " : " + GetName(oItem));
								if (GetIsObjectValid(oItem)
									&& pPrep.sTarget == GetName(oItem)
									&& GetLocalString(oItem, MROP_VAR_CAST_ITEM) == pPrep.sCreator + IntToString(pPrep.iSpellId)
									&& !GetLocalInt(oItem, MROP_VAR_FLAG_ITEM))
								{
									SetLocalInt(oItem, MROP_VAR_FLAG_ITEM, TRUE);
									DelayCommand(1.f, DeleteLocalInt(oItem, MROP_VAR_FLAG_ITEM));

									bFound = TRUE;
									break;
								}
								++iSlot;
							}
						}

						oParty = GetNextFactionMember(oCaster, FALSE);
					}

					if (GetIsObjectValid(oItem))
					{
						oPossessor = GetItemPossessor(oItem);
//						if (MRoP_iDebug && !GetIsObjectValid(oPossessor)) SendMessageToPC(MRoP_oDebug, ". Target Item Possessor not found");

						// this is the string for the buff being lined up.
						string sPossessor_ID = "_" + IntToString(pPrep.iSpellId) + ObjectToString(oPossessor);
//						if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, ". Possessor_ID : " + sPossessor_ID);

						// check if it has been cast previously before bothering to increment anything.
						if (FindSubString(sPossessor_ID_total, sPossessor_ID) != -1)
						{
//							SendMessageToPC(MRoP_oDebug, ". . subString found");

							// set sRight so we don't change the original string.
							string sRight = sPossessor_ID_total;

							// get the length of that original, full string ( it will be reduced to 0 during the loop )
							int iLength = GetStringLength(sRight);
							// examine the full string, and iterate it to zero length ( iterations allowed only from 0 - 7 in spellscripts ).
							while (iLength && iIteration < 8)
							{
								// iterate, then add this cast onto the end of the total string below ...
								++iIteration;
/*								if (MRoP_iDebug)
								{
									SendMessageToPC(MRoP_oDebug, ". . SubString found, Iteration : " + IntToString(iIteration));
									SendMessageToPC(MRoP_oDebug, ". . . while Length > 0 ( " + IntToString(iLength) + " )");
								} */

								// chop off the left side of the string at the position that the new buff
								// was previously cast and cut that previous buff out from the left also:
								sRight = GetStringRight(sRight, iLength - FindSubString(sRight, sPossessor_ID) - GetStringLength(sPossessor_ID));
//								if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, ". . . sRight : " + sRight);

								// if different buffs have been cast since that last one, remove those from the remainder as well.
								// if current bufftype is not found but there's still Length left, blank out sRight
								// so that no more iterations occur ( the current buff *will* be counted )

								// _546ca2a_545ca2a_545ca2a_546ca2a_545ca2a_546ca2a

								if (FindSubString(sRight, sPossessor_ID) == -1)
								{
									sRight = "";
//									if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, ". . . . sub-subString not found, sRight : terminating loop");
								}

								// tell the loop what the remaining length of the string currently examined is:
								iLength = GetStringLength(sRight);
//								if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, ". . . Length : " + IntToString(iLength));
							}
						}

						sPossessor_ID_total += sPossessor_ID;
//						if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, ". Possessor_ID_total : " + sPossessor_ID_total);
					}
					// feedback given to player, below in EncapsulateSpell()
//					else if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, ". Target Item not found");
				}

				EncapsulateSpell(pPrep, bInstant, iIteration, oPossessor, oItem);
				break;
			}

			case TALENT_TYPE_FEAT:
				EncapsulateFeat(pPrep, bInstant);
				break;
		}

		pPrep = GetNextPreparation(oBook);
	}
}


// oCaster casts pSpell.
void EncapsulateSpell(struct preparation pSpell,
					  int bInstant,
					  int iIteration = 0,
					  object oPossessor = OBJECT_INVALID,
					  object oItem = OBJECT_INVALID)
{
	object oCaster = OBJECT_SELF;

/*	if (MRoP_iDebug)
	{
		SendMessageToPC(MRoP_oDebug, "run EncapsulateSpell ( ) - " + GetName(oCaster));
		string sDebug = PreparationToDebugString(pSpell);
		SendMessageToPC(MRoP_oDebug, sDebug);
	} */

	// Could have used (oTarget==OBJECT_INVALID) instead of bItem, because
	// GetPreparationTarget() returns OBJECT_INVALID if an item is passed in,
	// but I suspect bItem runs faster .....
//	object oTarget = GetPreparationTarget(pSpell, oCaster);

	// this is for feedback to the Player ( sends messages to ControlledCharacter )
	object oLeader = GetFactionLeader(oCaster);


	// just to keep things straight: GetHasSpell() will say that caster has a
	// cast of a subradial spell but if you try to cast such a spell with
	// ActionCastSpellAtObject() it doesn't. Okay got it
	if (!GetHasSpell(pSpell.iSpellId, oCaster))
	{
		SendMessageToPC(oLeader, "<c=moccasin>MRoP :</c> Caster does not have Spell use - abort Prep");
		SendMessageToPC(oLeader, "_ Caster = " + pSpell.sCreator + " . Spell = <c=orchid>"
				+ pSpell.sTitle + "</c> . Target = " + pSpell.sTarget + "\n");
		return;
	}

	object oTarget = OBJECT_INVALID;
	// oTarget represents a party member. but if the real target is a weapon
	// or shield or armor that was buffed while in the Caster's inventory:
	if (pSpell.bItem)
	{
		if (!GetIsObjectValid(oItem))
		{
			SendMessageToPC(oLeader, "<c=moccasin>MRoP :</c> Target is not valid - abort Prep");
			SendMessageToPC(oLeader, "_ Caster = " + pSpell.sCreator + " . Spell = <c=orchid>"
					+ pSpell.sTitle + "</c> . Target = " + pSpell.sTarget + "\n");
			return;
		}

//		if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, ". Target ( possessor ) = " + GetName(oPossessor));

		// don't want to delete this or the itembuff only runs once.
		// or when Caster destroys the Prep and then creates a new Prep
		// on a different item w/ same spell & Targetname it goes wonky .....
		// HAVE TO FIGURE A WAY TO RELATE PREP TO TARGETITEM !!!
//		if ("" != GetLocalString(pSpell.oTarget, MROP_VAR_CAST_ITEM))
//		{
//			DeleteLocalString(pSpell.oTarget, MROP_VAR_CAST_ITEM);
//		}

		// remove non-alpha characters:
		string sCreator = CSLGetLegalCharacterString(pSpell.sCreator);
		// this should help limit sVar to ~30 characters.
		sCreator = GetStringLeft(sCreator, 20);
		// set the Target_item as a local object on the Possessor of Target_item,
		string sVar = MROP_VAR_CAST_PREF + sCreator + IntToString(pSpell.iSpellId) + "_" + IntToString(iIteration);
//		if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, ". RoP + Creator + ID + Iteration : " + sVar);
		// delete these in the spellscript:
		SetLocalObject(oPossessor, sVar, oItem);

		oTarget = oPossessor;
	}
	else // not an Item
		oTarget = GetPreparationTarget(pSpell, oCaster);


	if (!GetIsObjectValid(oTarget))
	{
		SendMessageToPC(oLeader, "<c=moccasin>MRoP :</c> Target is NOT valid - abort Prep");
		SendMessageToPC(oLeader, "_ Caster = " + pSpell.sCreator + " . Spell = <c=orchid>"
				+ pSpell.sTitle + "</c> . Target = " + pSpell.sTarget + "\n");
		return;
	}

	if (!GetFactionEqual(oTarget, oCaster))
	{
		SendMessageToPC(oLeader, "<c=moccasin>MRoP :</c> Target is NOT in PC faction - abort Prep");
		SendMessageToPC(oLeader, "_ Caster = " + pSpell.sCreator + " . Spell = <c=orchid>"
				+ pSpell.sTitle + "</c> . Target = " + pSpell.sTarget + "\n");
		return;
	}


	if (!pSpell.bItem
		&& GetHasSpellEffect(pSpell.iSpellId, oTarget))
	{
		SendMessageToPC(oLeader, "<c=moccasin>MRoP :</c> Refresh Spell Effect");
		SendMessageToPC(oLeader, "_ Caster = " + pSpell.sCreator + " . Spell = <c=orchid>"
				+ pSpell.sTitle + "</c> . Target = " + pSpell.sTarget + "\n");
	}

	// testing Domain spells:
/*	if (MRoP_iDebug)
	{
		int iCasts = GetHasSpell(pSpell.iSpellId, oCaster);
		SendMessageToPC(MRoP_oDebug, ". . . Has Spell = " + IntToString(iCasts));
		int iKnown = GetSpellKnown(oCaster, pSpell.iSpellId);
		SendMessageToPC(MRoP_oDebug, ". . . Spell known = " + IntToString(iKnown));
		int iLevel = GetSpellLevel(pSpell.iSpellId);
		SendMessageToPC(MRoP_oDebug, ". . . Spell level = " + IntToString(iLevel));
	} */

	// bCheat whenever a Cleric *could be* casting a Domain spell ....
	if (!pSpell.bCheat
		&& GetLevelByClass(CLASS_TYPE_CLERIC, oCaster))
	{
		pSpell.bCheat = isClericDomainSpell(pSpell.iSpellId, oCaster);
//		if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, ". . . Is Domain Spell = " + IntToString(pSpell.bCheat));
		if (pSpell.bCheat)
		{
			// at this point, there is no way to differentiate a 'legit' cast from a Domain cast:
			SendMessageToPC(oLeader, "<c=moccasin>MRoP :</c> <c=goldenrod>A possible Clerical Domain cast is detected.</c>");
			SendMessageToPC(oLeader, "_ Caster Level will to be set to CL 10 for <c=orchid>" + pSpell.sTitle + "</c>\n");
		}
	}

	if (!bInstant) // cast As Action ->
	{
//		if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, ". . . Cast as Action !");
		ActionCastSpellAtObject(pSpell.iSpellId,
								oTarget,
								pSpell.iMeta,
								pSpell.bCheat,
								0,
								PROJECTILE_PATH_TYPE_DEFAULT,
								FALSE);
	}
	else // cast Fast ->
	{
		_fDel += _fInterval;
//		if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, ". . . Fast Cast ! delay = " + FloatToString(_fDel, 18, 2));
		DelayCommand(_fDel, ActionCastSpellAtObject(pSpell.iSpellId,	// 'bInstant' spells need a delay or else 'pSpell.iMeta'
													oTarget,			// won't hold if another prep. follows. go figur.
													pSpell.iMeta,
													pSpell.bCheat,
													0,
													PROJECTILE_PATH_TYPE_DEFAULT,
													TRUE));
//		if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, ". . . . interval = " + FloatToString(_fInterval, 18, 2));
	}

	// hey ... Does this actually decrement the Master spell -> yes, yes it does.
	if (pSpell.bCheat)
	{
//		if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, ". . . Cheat cast = " + IntToString(pSpell.bCheat));
		DecrementRemainingSpellUses(oCaster, pSpell.iSpellId);
	}

//	if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, "\n");
}


// oCaster uses pFeat.
void EncapsulateFeat(struct preparation pFeat, int bInstant)
{
	object oCaster = OBJECT_SELF;

/*	if (MRoP_iDebug)
	{
		SendMessageToPC(MRoP_oDebug, "run EncapsulateFeat ( ) - " + GetName(OBJECT_SELF));

		string sDebug = PreparationToDebugString(pFeat);
		SendMessageToPC(MRoP_oDebug, sDebug);
	} */


	// this is for feedback to the Player ( sends messages to ControlledCharacter )
	object oLeader = GetFactionLeader(oCaster);
	// For now, just jump out if it's an Inspiration and it's already activated - might
	// want to do funny stuff like check all Faction for inspireEffect ( in radius ) later;
	// at present it checks for effects only on the Caster ( Object_Self ) .....
	if (!isInspirationInactive(pFeat.iFeatId)) // or if it's not an Inspiration.
	{
		SendMessageToPC(oLeader, "<c=moccasin>MRoP :</c> Inspiration is already active - bypass Prep");
		SendMessageToPC(oLeader, "_ Feator = " + pFeat.sCreator + " . Feat = <c=orchid>"
				+ pFeat.sTitle + "</c> . Target = " + pFeat.sTarget + "\n");
		return;
	}


	object oTarget = GetPreparationTarget(pFeat, oCaster);

	if (!GetIsObjectValid(oTarget))
	{
		SendMessageToPC(oLeader, "<c=moccasin>MRoP :</c> Target is NOT valid - abort Prep");
		SendMessageToPC(oLeader, "_ Feator = " + pFeat.sCreator + " . Feat = <c=orchid>"
				+ pFeat.sTitle + "</c> . Target = " + pFeat.sTarget + "\n");
		return;
	}

	if (!GetFactionEqual(oTarget, oCaster))
	{
		SendMessageToPC(oLeader, "<c=moccasin>MRoP :</c> Target is NOT in PC faction - abort Prep");
		SendMessageToPC(oLeader, "_ Feator = " + pFeat.sCreator + " . Feat = <c=orchid>"
				+ pFeat.sTitle + "</c> . Target = " + pFeat.sTarget + "\n");
		return;
	}

	// check if Feat maps to #Master uses.
	int iMaster = StringToInt(Get2DAString("feat", "USESMAPFEAT", pFeat.iFeatId));
	if (!iMaster) iMaster = pFeat.iFeatId;

//	int iUses = StringToInt(Get2DAString("feat", "USESPERDAY", pFeat.iFeatId));

	if (!GetHasFeat(iMaster, oCaster)) // && iUses != -1)
	{
		SendMessageToPC(oLeader, "<c=moccasin>MRoP :</c> Feator does not have Feat use - abort Prep");
		SendMessageToPC(oLeader, "_ Feator = " + pFeat.sCreator + " . Feat = <c=orchid>"
				+ pFeat.sTitle + "</c> . Target = " + pFeat.sTarget + "\n");
		return;
	}

	// This is *not* relevant for Feat Effects on items ...
	if (GetHasFeatEffect(pFeat.iFeatId, oTarget))
	{
		SendMessageToPC(oLeader, "<c=moccasin>MRoP :</c> Refresh Feat Effect");
		SendMessageToPC(oLeader, "_ Feator = " + pFeat.sCreator + " . Feat = <c=orchid>"
				+ pFeat.sTitle + "</c> . Target = " + pFeat.sTarget + "\n");
	}


	// Don't summon a familiar if one's already summoned.
	object oAssociate = OBJECT_INVALID;

	// OBJECT_SELF == oCaster, see DoControlCast()
	switch (pFeat.iFeatId)
	{
		case FEAT_SUMMON_FAMILIAR:
			oAssociate = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oCaster);
			if (GetIsObjectValid(oAssociate))
			{
				SendMessageToPC(oLeader, "<c=moccasin>MRoP :</c> Familiar is already summoned - skip Prep");
				SendMessageToPC(oLeader, "_ Feator = " + pFeat.sCreator + " . Feat = <c=orchid>"
						+ pFeat.sTitle + "</c> . Target = " + pFeat.sTarget + "\n");
				return;
			}

//			if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, " cast Familiar - bInstant = " + IntToString(bInstant));
			ActionCastSpellAtObject(SPELLABILITY_SUMMON_FAMILIAR,	// <- the SPELL.
									OBJECT_SELF,
									0,
									TRUE,							// Cheat ..
									0,
									PROJECTILE_PATH_TYPE_DEFAULT,
									bInstant);						// instant!

			DecrementRemainingFeatUses(oCaster, iMaster);
			return;

		case FEAT_ANIMAL_COMPANION:
//			if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, " feat Animal Companion");
			oAssociate = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oCaster);
			if (GetIsObjectValid(oAssociate))
			{
				SendMessageToPC(oLeader, "<c=moccasin>MRoP :</c> Animal Companion is already summoned - skip Prep");
				SendMessageToPC(oLeader, "_ Feator = " + pFeat.sCreator + " . Feat = <c=orchid>"
						+ pFeat.sTitle + "</c> . Target = " + pFeat.sTarget + "\n");
				return;
			}

//			if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, " cast Animal Companion - bInstant = " + IntToString(bInstant));
			ActionCastSpellAtObject(SPELLABILITY_SUMMON_ANIMAL_COMPANION,	// <- the SPELL.
									OBJECT_SELF,
									0,
									TRUE,									// Cheat ..
									0,
									PROJECTILE_PATH_TYPE_DEFAULT,
									bInstant);								// instant!

			DecrementRemainingFeatUses(oCaster, iMaster);
			return;

		case 3704: // FEAT_TELTHOR_COMPANION
			oAssociate = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oCaster);
			if (GetIsObjectValid(oAssociate))
			{
				SendMessageToPC(oLeader, "<c=moccasin>MRoP :</c> Telthor Companion is already summoned - skip Prep");
				SendMessageToPC(oLeader, "_ Feator = " + pFeat.sCreator + " . Feat = <c=orchid>"
						+ pFeat.sTitle + "</c> . Target = " + pFeat.sTarget + "\n");
				return;
			}

//			if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, " cast Telthor Companion - bInstant = " + IntToString(bInstant));
			ActionCastSpellAtObject(2063,							// <- the SPELL. SPELLABILITY_TELTHOR_COMPANION
									OBJECT_SELF,
									0,
									TRUE,							// Cheat ..
									0,
									PROJECTILE_PATH_TYPE_DEFAULT,
									bInstant);						// instant!

			DecrementRemainingFeatUses(oCaster, iMaster);
			return;

		default:
			if (bInstant)
			{
//				if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, " cast " + pFeat.sTitle + " Fast");
				ActionCastSpellAtObject(pFeat.iSpellId,					// <- the SPELL.
										oTarget,
										0,
										TRUE,							// Cheat ..
										0,
										PROJECTILE_PATH_TYPE_DEFAULT,
										TRUE);							// instant!

				DecrementRemainingFeatUses(oCaster, iMaster);
				return;
			}
	}

//	if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, " cast " + pFeat.sTitle + " as Action");
	ActionUseFeat(pFeat.iFeatId, oTarget);
}


// Gets the target object for pPrep.
object GetPreparationTarget(struct preparation pPrep, object oPC)
{
//	if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, "run GetPreparationTarget ( ) - " + GetName(OBJECT_SELF));

	switch (pPrep.iAssoc)
	{
		case ASSOCIATE_TYPE_NONE:
			return GetTargetByName(pPrep.sTarget, oPC);

		case ASSOCIATE_TYPE_ANIMALCOMPANION:
		case ASSOCIATE_TYPE_FAMILIAR:
		case ASSOCIATE_TYPE_SUMMONED:
		{
			object oMaster = GetTargetByName(pPrep.sTarget, oPC);
			return GetAssociate(pPrep.iAssoc, oMaster);
		}

//		case ASSOCIATE_TYPE_HENCHMAN:
//		case ASSOCIATE_TYPE_DOMINATED:
//			break;
	}
	return OBJECT_INVALID;
}


// Gets the member of oPC's party that has name 'sTarget'.
object GetTargetByName(string sTarget, object oPC)
{
//	if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, "run GetTargetByName ( ) - " + GetName(OBJECT_SELF));

	object oParty = GetFirstFactionMember(oPC, FALSE);
	while (GetIsObjectValid(oParty))
	{
		if (GetName(oParty) == sTarget)
			return oParty;

		oParty = GetNextFactionMember(oPC, FALSE);
	}
	return OBJECT_INVALID;
}


// Helper for EncapsulateFeat().
// Based on GetHasInspireBardSongSpellEffect() in 'x0_i0_talent'.
// - also returns TRUE if not an Inspiration
int isInspirationInactive(int iFeatId, object oTarget = OBJECT_SELF)
{
//	if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, "run isInspirationInactive ( ) - " + GetName(OBJECT_SELF));

	switch (iFeatId)
	{
		case FEAT_BARDSONG_INSPIRE_COURAGE:
			return !GetHasSpellEffect(SPELLABILITY_SONG_INSPIRE_COURAGE, oTarget);

		case FEAT_BARDSONG_INSPIRE_COMPETENCE:
			return !GetHasSpellEffect(SPELLABILITY_SONG_INSPIRE_COMPETENCE, oTarget);

		case FEAT_BARDSONG_INSPIRE_DEFENSE:
			return !GetHasSpellEffect(SPELLABILITY_SONG_INSPIRE_DEFENSE, oTarget);

		case FEAT_BARDSONG_INSPIRE_REGENERATION:
			return !GetHasSpellEffect(SPELLABILITY_SONG_INSPIRE_REGENERATION, oTarget);

		case FEAT_BARDSONG_INSPIRE_TOUGHNESS:
			return !GetHasSpellEffect(SPELLABILITY_SONG_INSPIRE_TOUGHNESS, oTarget);

		case FEAT_BARDSONG_INSPIRE_SLOWING:
			return !GetHasSpellEffect(SPELLABILITY_SONG_INSPIRE_SLOWING, oTarget);

		case FEAT_BARDSONG_INSPIRE_JARRING:
			return !GetHasSpellEffect(SPELLABILITY_SONG_INSPIRE_JARRING, oTarget);
	}
	return TRUE; // iFeatId is not an Inspiration
}


// Community Scripting Library '_CSLCore_Strings.nss'
// - used to ensure GetName(oCaster) does not go borky when setting sVar w/
//   EncapsulateSpell() and in spellscripts
/**
 * Gets a string where all contents match those provided in parameter 'sValid'.
 * (ASCII letters only by default)
 * @author Lilac Soul
 * @param sString input string
 * @param sValid valid characters
 * @return
 */
string CSLGetLegalCharacterString(string sString, string sValid = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
{
	string sOutPut, sCharacter;

	int iLength = GetStringLength(sString);
	int i = 0;
	for (; i != iLength; ++i)
	{
		sCharacter = GetSubString(sString, i, 1);
		if (TestStringAgainstPattern("**" + sCharacter + "**", sValid))
			sOutPut += sCharacter;
	}
	return sOutPut;
}


// Used by spellscripts that target an item. Searches for valid local_object.
object GetMRoPTarget(int iSpellId, object oTarget)
{
//	if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, "run GetMRoPTarget ( ) - " + GetName(OBJECT_SELF) + " casts at " + GetName(oTarget));

	string sCaster = GetName(OBJECT_SELF);
		   sCaster = CSLGetLegalCharacterString(sCaster);
		   sCaster = GetStringLeft(sCaster, 20);

	string sSpellId = IntToString(iSpellId);

	string sVar;
	object oItem;

	int i = 0;
	while (i != 8)
	{
		sVar = MROP_VAR_CAST_PREF + sCaster + sSpellId + "_" + IntToString(i);	// set by 'mrop_inc' EncapsulateSpell() via 'i_rop_item_ac'
		oItem = GetLocalObject(oTarget, sVar);									// needed to get the exact Target_item
//		if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, ". RoP + Caster + ID + Iteration : " + sVar);

		if (GetIsObjectValid(oItem))
		{
//			if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, ". RoP Weapon Valid : " + GetName(oItem));
			DeleteLocalObject(oTarget, sVar);
			return oItem;
		}
		++i;
	}
	return OBJECT_INVALID;
}


// For determining whether to bCheat a Cleric's domain-granted spell(s).
// - called from EncapsulateSpell()
int isClericDomainSpell(int iSpellId, object oCaster = OBJECT_SELF)
{
//	if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, "run isClericDomainSpell ( ) - " + GetName(OBJECT_SELF));

	// basic domains -> nwn2 / nwn1 / contemplative, see Domains.2da ( save vs. Confusion ;)
	// In the .2da, most domains have an NwN2 'Epithet Feat' but for some this is left blank
	// and those seem to fall back on NwN1 'Domain Power' GrantedFeat.
	//
	// So I'm going to *assume* that's how it works ...
	// NOTE: This list does not contain ALL Domains; only those that have domainSpells that are *** buffs ***

//	1834	// FEAT_EPITHET_AIR_DOMAIN // || GetHasFeat(311) // Air_Domain_Power // || GetHasFeat(1519) // FEAT_CONTEMPLATIVE_BONUS_DOMAIN_AIR
//	1835	// FEAT_EPITHET_ANIMAL_DOMAIN // || GetHasFeat(312) // Animal_Domain_Power // || GetHasFeat(1520) // FEAT_CONTEMPLATIVE_BONUS_DOMAIN_ANIMAL
//	310		// Death_Domain_Power // || (GetHasFeat(1836) // FEAT_EPITHET_DEATH_DOMAIN // || GetHasFeat(1521) // FEAT_CONTEMPLATIVE_BONUS_DOMAIN_DEATH
//	1837	// FEAT_EPITHET_DESTRUCTION_DOMAIN // || GetHasFeat(313) // Destruction_Domain_Power // || GetHasFeat(1522) // FEAT_CONTEMPLATIVE_BONUS_DOMAIN_DESTRUCTION
//	1838	// FEAT_EPITHET_EARTH_DOMAIN // || GetHasFeat(314) // Earth_Domain_Power // || GetHasFeat(1523) // FEAT_CONTEMPLATIVE_BONUS_DOMAIN_EARTH
//	1840	// FEAT_EPITHET_FIRE_DOMAIN // || GetHasFeat(316) // Fire_Domain_Power // || GetHasFeat(1525) // FEAT_CONTEMPLATIVE_BONUS_DOMAIN_FIRE
//	1841	// FEAT_EPITHET_GOOD_DOMAIN // || GetHasFeat(317) // Good_Domain_Power // || GetHasFeat(1526) // FEAT_CONTEMPLATIVE_BONUS_DOMAIN_GOOD
//	1843	// FEAT_EPITHET_KNOWLEDGE_DOMAIN // || GetHasFeat(319) // Knowledge_Domain_Power // || GetHasFeat(1528) // FEAT_CONTEMPLATIVE_BONUS_DOMAIN_KNOWLEDGE
//	1844	// FEAT_EPITHET_MAGIC_DOMAIN // || GetHasFeat(320) // Magic_Domain_Power // || GetHasFeat(1529) // FEAT_CONTEMPLATIVE_BONUS_DOMAIN_MAGIC
//	1845	// FEAT_EPITHET_PLANT_DOMAIN // || GetHasFeat(321) // Plant_Domain_Power // || GetHasFeat(1530) // FEAT_CONTEMPLATIVE_BONUS_DOMAIN_PLANT
//	308		// Protection_Domain_Power // || (GetHasFeat(1846) // FEAT_EPITHET_PROTECTION_DOMAIN // || GetHasFeat(1531) // FEAT_CONTEMPLATIVE_BONUS_DOMAIN_PROTECTION
//	307		// Strength_Domain_Power // || (GetHasFeat(1847) // FEAT_EPITHET_STRENGTH_DOMAIN // || GetHasFeat(1532) // FEAT_CONTEMPLATIVE_BONUS_DOMAIN_STRENGTH
//	322		// Sun_Domain_Power // || (GetHasFeat(1848)) // FEAT_EPITHET_SUN_DOMAIN // || GetHasFeat(1533) // FEAT_CONTEMPLATIVE_BONUS_DOMAIN_SUN
//	1849	// FEAT_EPITHET_TRAVEL_DOMAIN // || GetHasFeat(323) // Travel_Domain_Power // || GetHasFeat(1534) // FEAT_CONTEMPLATIVE_BONUS_DOMAIN_TRAVEL
//	1850	// FEAT_EPITHET_TRICKERY_DOMAIN // || GetHasFeat(324) // Trickery_Domain_Power // || GetHasFeat(1535)) // FEAT_CONTEMPLATIVE_BONUS_DOMAIN_TRICKERY
//	306		// War_Domain_Power // || (GetHasFeat(1851)) // FEAT_EPITHET_WAR_DOMAIN // || GetHasFeat(1536) // FEAT_CONTEMPLATIVE_BONUS_DOMAIN_WAR // Fury ( War <- so called. )
//	1852	// FEAT_EPITHET_WATER_DOMAIN // || GetHasFeat(325) // Water_Domain_Power // || GetHasFeat(1537) // FEAT_CONTEMPLATIVE_BONUS_DOMAIN_WATER
			// extra domains ( MotB )
//	2092	// FEAT_EPITHET_DARKNESS_DOMAIN
//	2096	// FEAT_EPITHET_LAW_DOMAIN
//	2097	// FEAT_EPITHET_LUCK_DOMAIN // || GetHasFeat(309) // Luck_Domain_Power
//	2098	// FEAT_EPITHET_TIME_DOMAIN
//	2099	// FEAT_EPITHET_UNDEATH_DOMAIN
			// kPrC domains
//	3058	// FEAT_EPITHET_CELERITY_DOMAIN
//	3059	// FEAT_EPITHET_DWARF_DOMAIN
//	3060	// FEAT_EPITHET_ELF_DOMAIN
//	3061	// FEAT_EPITHET_FATE_DOMAIN
//	3062	// FEAT_EPITHET_HATRED_DOMAIN
//	3063	// FEAT_EPITHET_MYSTICISM_DOMAIN
//	3068	// FEAT_EPITHET_REPOSE_DOMAIN
//	3069	// FEAT_EPITHET_COURAGE_DOMAIN, note: REMOVED from kPrC's 1.41.4 Feat.2da
//	3070	// FEAT_EPITHET_GLORY_DOMAIN, note: REMOVED from kPrC's 1.41.4 Feat.2da
//	3072	// FEAT_EPITHET_COMPETITION_DOMAIN, note: REMOVED from kPrC's 1.41.4 Feat.2da
//	3190	// FEAT_EPITHET_ILLUSION_DOMAIN
//	3191	// FEAT_EPITHET_PRIDE_DOMAIN

	switch (iSpellId)
	{
		case 2: // animate dead
			return GetHasFeat(2099, oCaster);

		case 3: // barkskin
			return GetHasFeat(1845, oCaster);

		case 9: // bull's strength
			return GetHasFeat( 307, oCaster);

		case 13: // cat's grace
			return GetHasFeat(1835, oCaster);

		case 20: // clairaudience & clairvoyance
			return GetHasFeat(1843, oCaster);

		case 29: // create greater undead
			return GetHasFeat(2099, oCaster);

		case 38: // death ward
			return GetHasFeat( 310, oCaster)
				|| GetHasFeat(3068, oCaster);

		case 42: // divine power
			return GetHasFeat( 307, oCaster);

		case 47: // elemental shield
			return GetHasFeat( 322, oCaster)
				|| GetHasFeat(1840, oCaster);

		case 48: // elemental swarm
			return GetHasFeat(1834, oCaster)
				|| GetHasFeat(1838, oCaster)
				|| GetHasFeat(1840, oCaster)
				|| GetHasFeat(1852, oCaster)
				|| GetHasFeat(3059, oCaster);

		case 62: // freedom of movement
			return GetHasFeat(1849, oCaster)
				|| GetHasFeat(2097, oCaster);

		case 73: // greater spell mantle
			return GetHasFeat(2097, oCaster);

		case 78: // haste
			return GetHasFeat(1849, oCaster)
				|| GetHasFeat(2098, oCaster)
				|| GetHasFeat(3058, oCaster);

		case 90: // invisibility
			return GetHasFeat(1850, oCaster)
				|| GetHasFeat(3058, oCaster);

		case 96: // lesser planar binding
			return GetHasFeat(1841, oCaster);

		case 102: // mage armor
			return GetHasFeat(1844, oCaster);

		case 104: // magic circle vs. alignment - iSpellId == 322 subradials ->
		case 105:
			return GetHasFeat(1841, oCaster);

		case 117: // mind blank
			return GetHasFeat( 308, oCaster)
				|| GetHasFeat(3061, oCaster);

		case 119: // lesser globe of invulnerability
			return GetHasFeat( 308, oCaster);

		case 120: // ghostly visage
			return GetHasFeat(1834, oCaster)
				|| GetHasFeat(1852, oCaster)
				|| GetHasFeat(2092, oCaster);

		case 134: // premonition
			return GetHasFeat(2098, oCaster)
				|| GetHasFeat(3061, oCaster);

		case 141: // protection vs. spells
			return GetHasFeat(3059, oCaster);

		case 169: // spell mantle
			return GetHasFeat(1844, oCaster);

		case 172: // stoneskin
			return GetHasFeat( 307, oCaster)
				|| GetHasFeat( 308, oCaster)
				|| GetHasFeat(1838, oCaster);

		case 184: // tenser's transformation
			return GetHasFeat( 306, oCaster);

		case 186: // true seeing
			return GetHasFeat(1835, oCaster)
				|| GetHasFeat(1843, oCaster);

		case 344: // shadow conjuration - iSpellId == 159 subradials ->
		case 346:
		case 347:
			return GetHasFeat(2092, oCaster);

		case 376: // legend lore
			return GetHasFeat(1843, oCaster)
				|| GetHasFeat(2098, oCaster)
				|| GetHasFeat(3061, oCaster);

		case 415: // true strike
			return GetHasFeat(2098, oCaster)
				|| GetHasFeat(3060, oCaster)
				|| GetHasFeat(3061, oCaster);

		case 455: // mass camoflage
			return GetHasFeat(1845, oCaster);

		case 456: // expeditious retreat
			return GetHasFeat(3058, oCaster);

		case 458: // displacement
			return GetHasFeat(3190, oCaster);

		case 481: // cat's grace
			return GetHasFeat(3058, oCaster)
				|| GetHasFeat(3060, oCaster);

		case 537: // bless weapon
		case 538: // holy sword
			return GetHasFeat(3070, oCaster);

		case 541: // blackstaff
			return GetHasFeat(1844, oCaster);

		case 846: // enlarge person
			return GetHasFeat( 306, oCaster);

		case 852: // mirror image
			return GetHasFeat(3190, oCaster);

		case 857: // heroism
			return GetHasFeat(3069, oCaster)
				|| GetHasFeat(3191, oCaster);

		case 859: // rage
			return GetHasFeat(1837, oCaster)
				|| GetHasFeat(3062, oCaster);

		case 876: // greater heroism
			return GetHasFeat(3069, oCaster)
				|| GetHasFeat(3191, oCaster);

		case 885: // ironbody
			return GetHasFeat(1838, oCaster);

		case 890: // righteous might
			return GetHasFeat(3063, oCaster);

		case 976: // energy immunity - iSpellId == 879 subradials ->
		case 977:
		case 978:
		case 979:
		case 980:
			return GetHasFeat( 308, oCaster)
				|| GetHasFeat(1838, oCaster);

		case 1027: // mass cat's grace
			return GetHasFeat(3058, oCaster);

		case 1040: // lesser visage of the deity
			return GetHasFeat(3063, oCaster);

		case 1053: // lionheart
			return GetHasFeat(2096, oCaster);

		case 1744: // cloak of bravery
			return GetHasFeat(3069, oCaster);

		case 1772: // zeal
			return GetHasFeat(3072, oCaster);

		case 1928: // liveoak
			return GetHasFeat(3060, oCaster);
	}
	return FALSE;
}


/*
1834	311		1519		// air					120 ghostly visage, 48 elemental swarm
1835	312		1520		// animal				13 cat's grace, 186 true seeing
2094						// chaos
1836	310		1521		// death*				38 death ward
1837	313		1522		// destruction			859 rage
1838	314		1523		// earth				172 stoneskin, 879 energy immunity, 885 iron body, 48 elemental swarm
1839	315		1524		// evil*
1840	316		1525		// fire					47 elemental shield, 48 elemental swarm
1841	317		1526		// good					322 magic circle against alignment, 96 lesser planar binding
1842	318		1527		// healing*
1843	319		1528		// knowledge			20 clairaudience & clairvoyance, 186 true seeing, 376 legend lore
2096						// law					1053 lionheart
2097	309					// luck					62 freedom of movement, 73 greater spell mantle
1844	320		1529		// magic				102 mage armor, 169 spell mantle, 541 blackstaff
1845	321		1530		// plant				3 barkskin, 455 mass camoflage
1846	308		1531		// protection*			119 lesser globe of invulnerability, 879 energy immunity, 172 stoneskin, 117 mind blank
1847	307		1532		// strength*			9 bull's strength, 42 divine power, 172 stoneskin
1848	322		1533		// sun*					47 elemental shield
1849	323		1534		// travel				62 freedom of movement, 78 haste
1850	324		1535		// trickery				90 invisibility
1851	306		1536		// fury -> was WAR		846 enlarge person, 184 tenser's transformation
1852	325		1537		// water				120 ghostly visage, 48 elemental swarm
2093						// cold
2092						// darkness				120 ghostly visage, 159 shadow conjuration
2095						// dream
2098						// time					415 true strike, 78 haste, 134 premonition, 376 legend lore
2099						// undeath				2 animate dead, 29 create greater undead
2100						// warreal

// kPrc Domains
3058						// celerity					456 expeditious retreat, 481 cat's grace, 90 invisibility, 78 haste, 1027 mass cat's grace
3059						// dwarf					141 protection from spells, 48 elemental swarm
3060						// elf						415 true strike, 481 cat's grace, 1928 liveoak
3061						// fate						415 true strike, 117 mind blank, 134 premonition, 376 legend lore
3062						// hatred					859 rage
3063						// mysticism				1040 lesser visage of the deity, 890 righteous might
3064						// pestilence
3065						// storm
3066						// suffering
3067						// tyranny
3068						// repose					38 death ward
3069						// courage * no.Tlk			1744 cloak of bravery, 857 heroism, 876 greater heroism
3070						// glory * no.Tlk			537 bless weapon, 538 holy sword
3071						// purification * no.Tlk
3072						// competition * no.Tlk		1772 zeal
3190						// illusion					852 mirror image, 458 displacement
3191						// pride					857 heroism, 876 greater heroism
		// spell
		// renewal
		// charm
		// drow
		// moon
		// portal
		// craft
		// metal
		// planning
		// nobility
		// spider
		// rune
		// cavern
		// trade
		// retribution
		// ocean
		// family
		// scalykind
		// slime
		// mentalism
		// gnome
		// halfling
		// orc

- NwScript.nss
int FEAT_WAR_DOMAIN_POWER				= 306;
int FEAT_STRENGTH_DOMAIN_POWER			= 307;
int FEAT_PROTECTION_DOMAIN_POWER		= 308;
int FEAT_LUCK_DOMAIN_POWER				= 309;
int FEAT_DEATH_DOMAIN_POWER				= 310;
int FEAT_AIR_DOMAIN_POWER				= 311;
int FEAT_ANIMAL_DOMAIN_POWER			= 312;
int FEAT_DESTRUCTION_DOMAIN_POWER		= 313;
int FEAT_EARTH_DOMAIN_POWER				= 314;
int FEAT_EVIL_DOMAIN_POWER				= 315;
int FEAT_FIRE_DOMAIN_POWER				= 316;
int FEAT_GOOD_DOMAIN_POWER				= 317;
int FEAT_HEALING_DOMAIN_POWER			= 318;
int FEAT_KNOWLEDGE_DOMAIN_POWER			= 319;
int FEAT_MAGIC_DOMAIN_POWER				= 320;
int FEAT_PLANT_DOMAIN_POWER				= 321;
int FEAT_SUN_DOMAIN_POWER				= 322;
int FEAT_TRAVEL_DOMAIN_POWER			= 323;
int FEAT_TRICKERY_DOMAIN_POWER			= 324;
int FEAT_WATER_DOMAIN_POWER				= 325; */

// Sets oTarget to cast spells Fastly when possible.
// kL. no Longer Needed: all casters treated identically in MRoP
/* void SetCastInstant(object oCaster, int bInstant = FALSE)
{
	if (bInstant)
		DeleteLocalInt(oCaster, MROP_VAR_NOT_INSTANT);
	else
		SetLocalInt(oCaster, MROP_VAR_NOT_INSTANT, TRUE);
} */


// Returns TRUE if oCaster may cast Fast spells.
// Checks module, area, and character, as well as combat state
// - from DoControlCast(), checks only the Rod itself.
// - from DoAllPreparations(), checks both Area & Module also.
// kL. reDone
/* int GetCastInstant(object oObject)
{
	if (MRoP_iDebug)
	{
		SendMessageToPC(MRoP_oDebug, "run GetCastInstant ( ) - " + GetName(OBJECT_SELF));

		if (!GetIsObjectValid(oObject))
		{
			if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, ". problem : Object NOT valid");
//			return TRUE;
			// kL. If any of these are not valid you got real problems.
		}
	}

	int bInstant = TRUE;

	if (GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
	{
		// Lets Associates fight while party buffs Fastly:
		if (GetIsFactionInCombat(oObject))
		{
			object oLeader = GetFactionLeader(oObject);
			SendMessageToPC(oLeader, "<c=moccasin>MRoP :</c> Party in Combat ! ! !");
			return FALSE;
		}

		// All of these lines must be TRUE to Fast cast spells.
//		bInstant = !GetIsInCombat(oObject)
		bInstant = GetCastInstant(GetArea(oObject)) && GetCastInstant(GetModule());
	}

	// kL. Checks Caster ( DoControlCast() ), then area & module ( DoAllPreparations() )
	return bInstant && !GetLocalInt(oObject, MROP_VAR_NOT_INSTANT);
} */


// kL, not used in metaRoP
// Checks to see if oMaster has an animal companion or familiar
// summoned and adds the appropriate preparations to the Rod.
/* void AddAssociateSummons(object oMaster, int nAssociateType = ASSOCIATE_TYPE_ANIMALCOMPANION)
{
	if (!GetIsObjectValid(GetAssociate(nAssociateType, oMaster)))
		return;

	struct preparation pSummon = Preparation();

	switch (nAssociateType)
	{
		case ASSOCIATE_TYPE_ANIMALCOMPANION:
			pSummon.iID = FEAT_ANIMAL_COMPANION;
			break;

		case ASSOCIATE_TYPE_FAMILIAR:
			pSummon.iID = FEAT_SUMMON_FAMILIAR;
			break;

		case ASSOCIATE_TYPE_SUMMONED:
		case ASSOCIATE_TYPE_DOMINATED:
		case ASSOCIATE_TYPE_HENCHMAN:
		case ASSOCIATE_TYPE_NONE:
		default:
			return;
	}

	pSummon.oBook		= GetPreparationStore(oMaster);
	pSummon.iType		= TALENT_TYPE_FEAT;
	pSummon.sCreator	= GetName(oMaster);
	pSummon.sTarget		= GetName(oMaster);
	pSummon.iAssoc		= ASSOCIATE_TYPE_NONE;
	pSummon.sName		= GetNameFrom2DA(pSummon);
	pSummon				= AddPreparation(pSummon);
} */


// kL, not used in metaRoP
// Broadcasts an approprate message to oCaster that pTalent is being used or recorded.
/* void BroadcastPreparationMessage(struct preparation pTalent, object oCaster, int bRecorded = FALSE, int bDelay = FALSE)
{
	string sMessage = GetActionMessage(pTalent);
	sMessage += bDelay ? " after a short delay." : ".";
	FloatingTextStringOnCreature(sMessage, oCaster);
} */
