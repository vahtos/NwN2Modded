//:: 'mrop_cmi_animcom'
//
//:: Created By: Kaedrin (Matt)
/*
	This is the include file for my content and will hopefully allow
	others to remap my content for their own use more easily.
*/
//:: modified by kevL: this is a subset of the kPrC pack's 'cmi_animcom'
//:: so that users wishing to recompile MRoP scripts don't need kPrC installed.
//:: Note that some versions of the kPrC don't include source anyway ....
//
// kevL's
// 2012 june 17
// - merged w/ Cyphre's Companions Pack.
// 2013 jan 6
// - fixed problem with Animal Companions not leveling w/ PC
//   if Kaedrin's PrC pack is not also installed;
//   'cmi_player_levelup' deletes the string_var "cmi_animcomp"
//   on the PC object. This bypasses that ....
// 2013 jan 7
// - renamed the file and functions to not conflict w/ Kaedrin's original.
// 2016 sept 9
// - added constants and kL_ApplySilverFangEffect().
// - refactor.
// 2016 sept 18
// - changed name of file from 'kl_cmi_animcom' to 'mrop_cmi_animcom'.


// _______________
// ---------------
// ** Constants **
// _______________
// ---------------
const int CLASS_LION_TALISID			= 123;

const int FEAT_EPIC_ANIMAL_COMPANION	= 1959;
const int FEAT_EPIC_DRAGON_COMPANION	= 2002;
const int FEAT_NATURAL_BOND				= 2106;
const int FEAT_DEVOTED_TRACKER			= 3697;
const int FEAT_TELTHOR_COMPANION		= 3704;
const int FEAT_IMPROVED_NATURAL_BOND	= 3705;
const int FEAT_SILVER_FANG				= 3527;
const int FEAT_EXALTED_COMPANION		= 3133;


// _________________
// -----------------
// ** Prototypes **
// _________________
// -----------------

//
void kL_SummonAssociate(object oPC = OBJECT_SELF);
//
int kL_GetAnimalTier(object oPC);
//
int kL_GetElementalTier(object oPC);
//
int kL_GetAssociateLevel(object oPC);
//
void kL_ApplySilverFangEffect(object oTarget);


// ________________
// ----------------
// ** Functions **
// ________________
// ----------------

//
void kL_SummonAssociate(object oPC = OBJECT_SELF)
{
	string sResRef;

	int bTelthor = FALSE;

	if (GetTag(oPC) == "co_umoja") // Umoja from SoZ always gets his Dino.
	{
		SendMessageToPC(oPC, "<c=seagreen>Umoja calls to nature for his trusted companion.</c>");
		sResRef = "c_ancom_dino";
	}
	else if (GetHasFeat(FEAT_TELTHOR_COMPANION, oPC, TRUE)) // Telthor Companion takes precedence over the rest.
	{
		bTelthor = TRUE;
		sResRef = "cmi_ancom_telthor";
	}
	else if (GetHasFeat(FEAT_EPIC_DRAGON_COMPANION, oPC, TRUE))
	{
		switch (GetAlignmentGoodEvil(oPC))
		{
			default:
			case ALIGNMENT_GOOD:
			case ALIGNMENT_NEUTRAL:
				sResRef = "c_ancom_bronze";
				break;

			case ALIGNMENT_EVIL:
				sResRef = "c_ancom_blue";
		}
	}
	else if (GetHasFeat(FEAT_DINOSAUR_COMPANION, oPC, TRUE))
	{
		sResRef = "c_ancom_dino";
	}
	else
	{
		SummonAnimalCompanion(oPC); // need to summon the associate just to find out what it is.
		// because ->
//		iType = GetAnimalCompanionCreatureType(...); <- doesn't fing work!!
		// hence we do this the hard way ->

		string sTag = GetTag(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC));
		if (FindSubString(sTag, "badger") != -1)			// #0 badger - 'Hen_Companion.2da'
		{
			sResRef = "c_ancom_badger";
		}
		else if (FindSubString(sTag, "wolf") != -1)			// #1 wolf
		{
			sResRef = "c_ancom_wolf";
		}
		else if (FindSubString(sTag, "bear") != -1)			// #2 bear
		{
			sResRef = "c_ancom_bear";
		}
		else if (FindSubString(sTag, "boar") != -1)			// #3 boar
		{
			sResRef = "c_ancom_boar";
		}
		else if (FindSubString(sTag, "spider") != -1)		// #4 giant spider
		{
			sResRef = "c_ancom_spider";
		}
		else if (FindSubString(sTag, "blue") != -1)			// #5 blue dragon
		{
			sResRef = "c_ancom_blue";
		}
		else if (FindSubString(sTag, "panther") != -1)		// #6 panther
		{
			sResRef = "c_ancom_panther";
		}
		else if (FindSubString(sTag, "bronze") != -1)		// #4 bronze dragon
		{
			sResRef = "c_ancom_bronze";
		}
		else if (FindSubString(sTag, "dino") != -1)			// #8 deinonychus
		{
			sResRef = "c_ancom_dino";
		}
															// #9, #10 : not used.
		else if (FindSubString(sTag, "elew") != -1)			// #11 water elemental
		{
			sResRef = "cmi_ancom_elew";
		}
		else if (FindSubString(sTag, "elef") != -1)			// #12 fire elemental
		{
			sResRef = "cmi_ancom_elef";
		}
		else if (FindSubString(sTag, "telthor") != -1)		// #13 telthor wolf
		{
			sResRef = "cmi_ancom_telthor";
		}
		else if (FindSubString(sTag, "elea") != -1)			// #14 air elemental
		{
			sResRef = "cmi_ancom_elea";
		}
		else if (FindSubString(sTag, "elee") != -1)			// #15 earth elemental
		{
			sResRef = "cmi_ancom_elee";
		}
		else if (FindSubString(sTag, "abo") != -1)			// #16 arctic boar
		{
			sResRef = "c_ancom_abo";
		}
		else if (FindSubString(sTag, "awo") != -1)			// #17 arctic wolf
		{
			sResRef = "c_ancom_awo";
		}
		else if (FindSubString(sTag, "hshark") != -1)		// #18 hammerhead shark
		{
			sResRef = "c_ancom_hshark";
		}
		else if (FindSubString(sTag, "snake") != -1)		// #19 highland snake
		{
			sResRef = "c_ancom_snake";
		}
		else if (FindSubString(sTag, "mshark") != -1)		// #20 mako shark
		{
			sResRef = "c_ancom_mshark";
		}
		else if (FindSubString(sTag, "mlion") != -1)		// #21 mountain lion
		{
			sResRef = "c_ancom_mlion";
		}
		else if (FindSubString(sTag, "bpolar") != -1)		// #22 polar bear
		{
			sResRef = "c_ancom_bpolar";
		}
		else if (FindSubString(sTag, "sleo") != -1)			// #23 snow leopard
		{
			sResRef = "c_ancom_sleo";
		}
		else if (FindSubString(sTag, "wolverine") != -1)	// #24 wolverine
		{
			sResRef = "c_ancom_wolverine";
		}
		else if (FindSubString(sTag, "tiger") != -1)		// #25 tiger
		{
			sResRef = "c_ancom_tiger";
		}
		else if (FindSubString(sTag, "stiger") != -1)		// #26 snow tiger
		{
			sResRef = "c_ancom_stiger";
		}
		else if (FindSubString(sTag, "white_tiger") != -1)	// UNVERIFIED
		{
			sResRef = "c_ancom_white_tiger";
		}
		else if (FindSubString(sTag, "grender") != -1)		// #27 gray render
		{
			sResRef = "c_ancom_grender";
		}
		else if (FindSubString(sTag, "smilo") != -1)		// #28 smilodon
		{
			sResRef = "c_ancom_smilo";
		}
		else if (FindSubString(sTag, "deino") != -1)		// #29 deinonychus
		{
			sResRef = "c_ancom_deino";
		}
		else if (FindSubString(sTag, "megara") != -1)		// #30 megaraptor
		{
			sResRef = "c_ancom_megara";
		}
		else if (FindSubString(sTag, "jsnake") != -1)		// #31 jungle snake
		{
			sResRef = "c_ancom_jsnake";
		}
		else if (FindSubString(sTag, "myconid") != -1)		// #32 myconid
		{
			sResRef = "c_ancom_myconid";
		}
		else if (FindSubString(sTag, "psimyco") != -1)		// #33 psionic myconid
		{
			sResRef = "c_ancom_psimyco";
		}
		else if (FindSubString(sTag, "wmyco") != -1)		// #34 wood myconid
		{
			sResRef = "c_ancom_wmyco";
		}
		else if (FindSubString(sTag, "felion") != -1)		// #35 female lion
		{
			sResRef = "c_ancom_felion";
		}
		else if (FindSubString(sTag, "malion") != -1)		// #36 male lion
		{
			sResRef = "c_ancom_malion";
		}
		else if (FindSubString(sTag, "dmt") != -1)			// #37 dinosaur
		{
			sResRef = "c_ancom_dmt";
		}
															// #38 : dire badger
															// #39 : dire bear
															// #40 : dire boar
															// #41 : dire wolf
															// #42 : dire wolverine
															// #43 : dire rat
															// #44 : dire spider
															// #45 : celestial dire bear!
															// #46 : giant scorpion
															// #47 : giant ant
		else if (FindSubString(sTag, "shamblingm") != -1)	// #48 shambling mound
		{
			sResRef = "c_ancom_shamblingm";
		}
		else if (FindSubString(sTag, "winter") != -1)		// #49 winter wolf, UNVERIFIED.
		{
			sResRef = "c_ancom_winter_wolf";
		}
		else if (FindSubString(sTag, "worg") != -1)			// #50 worg
		{
			sResRef = "c_ancom_worg";
		}
		else if (FindSubString(sTag, "basilisk") != -1)		// #51 basilisk
		{
			sResRef = "c_ancom_basilisk";
		}
															// #52 : umberhulk
															// #53 : glow spider
															// #54 : phase spider
															// #55 : snow spider
															// #56 : manticore
		else if (FindSubString(sTag, "gcube") != -1)		// #57 gelatinous cube
		{
			sResRef = "c_ancom_gcube";
		}
															// #58 - 68 : not used.
		else if (FindSubString(sTag, "toki") != -1)			// #69 Toki of Caerbannog
		{
			sResRef = "c_acp_toki";
		}
	}

	if (sResRef == "")
	{
		SendMessageToPC(oPC, "ERROR ( kl_cmi_animcom ) cannot find Animal Companion resref");
		return;
	}

	int iTier;
	if (FindSubString(sResRef, "ele") != -1)
	{
		iTier = kL_GetElementalTier(oPC);
	}
	else
		iTier = kL_GetAnimalTier(oPC);

	SummonAnimalCompanion(oPC, sResRef + IntToString(iTier)); // will replace current associate.

	if (bTelthor) // why not done on Blueprints ...
		SetFirstName(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC), "Spirit Telthor");
}

//
int kL_GetAnimalTier(object oPC)
{
	return kL_GetAssociateLevel(oPC) / 3 + 1;
}

//
int kL_GetElementalTier(object oPC)
{
	int iRange = kL_GetAssociateLevel(oPC);
	return ((iRange + 2) / 6 + 1);
}

//
int kL_GetAssociateLevel(object oPC)
{
	int iLevel = 0;

	if (   GetHasFeat(1835, oPC) // Animal Domain Cleric (yep, all 3 of them.)
		|| GetHasFeat(312, oPC)
		|| GetHasFeat(1520, oPC))
	{
		iLevel += GetLevelByClass(CLASS_TYPE_CLERIC, oPC);
	}

	int iClass = GetLevelByClass(CLASS_TYPE_RANGER, oPC);
	if (iClass > 3) iLevel += (iClass - 3);

	iLevel += GetLevelByClass(CLASS_TYPE_DRUID, oPC);
	iLevel += GetLevelByClass(CLASS_LION_TALISID, oPC);

	if (GetHasFeat(FEAT_DEVOTED_TRACKER, oPC))
	{
		iClass = GetLevelByClass(CLASS_TYPE_PALADIN, oPC);
		if (iClass > 4) iLevel += (iClass - 4);
	}

	if (GetHasFeat(FEAT_TELTHOR_COMPANION, oPC, TRUE))
	{
		iClass = GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oPC);
		if (iClass > 3) iLevel += (iClass - 3);
	}

	if (GetHasFeat(FEAT_IMPROVED_NATURAL_BOND, oPC))
	{
		if ((iClass = GetHitDice(oPC)) > iLevel
			&& (iLevel += 6) > iClass)
		{
			iLevel = iClass;
		}
	}
	else if (GetHasFeat(FEAT_NATURAL_BOND, oPC))
	{
		if ((iClass = GetHitDice(oPC)) > iLevel
			&& (iLevel += 3) > iClass)
		{
			iLevel = iClass;
		}
	}

	if (GetHasFeat(FEAT_EPIC_ANIMAL_COMPANION, oPC))
		iLevel += 3;

	return iLevel;
}

//
void kL_ApplySilverFangEffect(object oTarget)
{
	object oWeapon;

	int iSlot;
	for (iSlot = INVENTORY_SLOT_CWEAPON_L; iSlot != INVENTORY_SLOT_CARMOUR; ++iSlot)
	{
		if (GetIsObjectValid(oWeapon = GetItemInSlot(iSlot, oTarget)))
			SetItemBaseMaterialType(oWeapon, GMATERIAL_METAL_ALCHEMICAL_SILVER);
	}
}


/*		// kL, this needs to be kept in sync w/ 'hen_companion.2da'
		iAnComType = GetAnimalCompanionCreatureType(oComp); <- doesn't fing work!!
		SendMessageToPC(oPC, "AnComType = " + IntToString(iAnComType));
		switch (iAnComType)
		{
			case 0:		// badger
				sResRef = "c_ancom_badger";
				break;
			case 1:		// wolf
				sResRef = "c_ancom_wolf";
				break;
			case 2:		// bear
				sResRef = "c_ancom_bear";
				break;
			case 3:		// boar
				sResRef = "c_ancom_boar";
				break;
			case 4:		// giant spider
				sResRef = "c_ancom_spider";
				break;
			case 5:		// blue dragon
				sResRef = "c_ancom_blue";
				break;
			case 6:		// panther
				sResRef = "c_ancom_panther";
				break;
			case 7:		// bronze dragon
				sResRef = "c_ancom_bronze";
				break;
			case 8:		// deinonychus
				sResRef = "c_ancom_dino";
				break;
			case 9:		// not used.
				sResRef = "";
				break;
			case 10:	// not used.
				sResRef = "";
				break;
			case 11:	// water elemental
				sResRef = "cmi_ancom_elew";
				break;
			case 12:	// fire elemental
				sResRef = "cmi_ancom_elef";
				break;
			case 13:	// telthor wolf
				sResRef = "cmi_ancom_telthor";
				break;
			case 14:	// air elemental
				sResRef = "cmi_ancom_elea";
				break;
			case 15:	// earth elemental
				sResRef = "cmi_ancom_elee";
				break;
			case 16:	// arctic boar
				sResRef = "c_ancom_abo";
				break;
			case 17:	// arctic wolf
				sResRef = "c_ancom_awo";
				break;
			case 18:	// hammerhead shark
				sResRef = "c_ancom_hshark";
				break;
			case 19:	// highland snake
				sResRef = "c_ancom_snake";
				break;
			case 20:	// mako shark
				sResRef = "c_ancom_mshark";
				break;
			case 21:	// mountain lion
				sResRef = "c_ancom_mlion";
				break;
			case 22:	// polar bear
				sResRef = "c_ancom_bpolar";
				break;
			case 23:	// snow leopard
				sResRef = "c_ancom_sleo";
				break;
			case 24:	// wolverine
				sResRef = "c_ancom_wolverine";
				break;
			case 25:	// tiger
				sResRef = "c_ancom_tiger";
				break;
			case 26:	// snow tiger
				sResRef = "c_ancom_stiger";
				break;
			case 27:	// gray render
				sResRef = "c_ancom_grender";
				break;
			case 28:	// smilodon
				sResRef = "c_ancom_smilo";
				break;
			case 29:	// deinonychus
				sResRef = "c_ancom_deino";
				break;
			case 30:	// megaraptor
				sResRef = "c_ancom_megara";
				break;
			case 31:	// jungle snake
				sResRef = "c_ancom_jsnake";
				break;
			case 32:	// myconid
				sResRef = "c_ancom_myconid";
				break;
			case 33:	// psionic myconid
				sResRef = "c_ancom_psimyco";
				break;
			case 34:	// wood myconid
				sResRef = "c_ancom_wmyco";
				break;
			case 35:	// female lion
				sResRef = "c_ancom_felion";
				break;
			case 36:	// male lion
				sResRef = "c_ancom_malion";
				break;
			case 37:	// dinosaur
				sResRef = "c_ancom_dmt";
				break;
			case 38:	// dire badger
				sResRef = "";
				break;
			case 39:	// dire bear
				sResRef = "";
				break;
			case 40:	// dire boar
				sResRef = "";
				break;
			case 41:	// dire wolf
				sResRef = "";
				break;
			case 42:	// dire wolverine
				sResRef = "";
				break;
			case 43:	// dire rat
				sResRef = "";
				break;
			case 44:	// dire spider
				sResRef = "";
				break;
			case 45:	// celestial dire bear!
				sResRef = "";
				break;
			case 46:	// giant scorpion
				sResRef = "";
				break;
			case 47:	// giant ant
				sResRef = "";
				break;
			case 48:	// shambling mound
				sResRef = "c_ancom_shamblingm";
				break;
			case 49:	// winter wolf
				sResRef = "";
				break;
			case 50:	// worg
				sResRef = "c_ancom_worg";
				break;
			case 51:	// basilisk
				sResRef = "c_ancom_basilisk";
				break;
			case 52:	// umberhulk
				sResRef = "";
				break;
			case 53:	// glow spider
				sResRef = "";
				break;
			case 54:	// phase spider
				sResRef = "";
				break;
			case 55:	// snowspider
				sResRef = "";
				break;
			case 56:	// manticore
				sResRef = "";
				break;
			case 57:	// gelatinous cube
				sResRef = "c_ancom_gcube";
				break;
			// case 58 - 68: not used.
			case 69:	// Toki of Caerbannog
				sResRef = "c_acp_toki";
				break;
		} */
