// 'mrop_inc_const'
/*
	Constants for MetaPrepa scripts.
*/
// kevL
// v.beta.97a march 14

// debug helpers
//const int MRoP_iDebug = FALSE;
//object MRoP_oDebug = GetFirstPC(FALSE);


const string MROP_TAG_ROD                 = "mrop_rod";
const string MROP_TAG_BOOK                = "mrop_book";
const string MROP_TAG_PAGE                = "mrop_page";

const string MROP_VAR_SETUP_COMPLETE      = "MROP_SETUP_COMPLETE";
const string MROP_VAR_VERSION             = "MROP_VERSION";

const string MROP_VAR_NOT_INSTANT         = "MROP_NOT_INSTANT";
const string MROP_VAR_FAST_DELAY          = "MROP_FAST_DELAY";

// Learn or Play mode ( true is Learn mode )
const string MROP_VAR_ACTIVE              = "RoM_bActive";

const string MROP_MSG_WELCOME             = "Welcome !";

const string MROP_VAR_MESSAGEBOX          = "MROP_MESSAGEBOX";
const string MROP_VAR_ITEM                = "MROP_ITEM";
const string MROP_VAR_TARGET              = "MROP_TARGET";

const int MROP_FLG_MESSAGEBOX_SETUP       = 0;
const int MROP_FLG_MESSAGEBOX_DESTROY     = 1;
const int MROP_FLG_MESSAGEBOX_EMPTY       = 2;
const int MROP_FLG_MESSAGEBOX_DELETE      = 3;
const int MROP_FLG_MESSAGEBOX_DELETE_PAGE = 4;

// for buffing party items ( keep this short to avoid 32-char string )
const string MROP_VAR_CAST_PREF           = "RoM_";
const string MROP_VAR_CAST_ITEM           = "RoM_sCasterID";
const string MROP_VAR_FLAG_ITEM           = "RoM_bFound";

// spellhook string Constants
const string MROP_VAR_SPELLHOOK           = "X2_S_UD_SPELLSCRIPT";		// standard var for spellhooking
const string MROP_SPELLHOOK               = "mrop_spellhook";			// filename of the MRoP spellhook script ( val )
const string MROP_VAR_SPELLHOOK_ORIG      = "RoM_sOriginalSpellhook";	// module author's spellhook script ( used only when non-integrated )
const string MROP_VAR_WILDMAGIC           = "X2_L_WILD_MAGIC";			// standard var for wild magic
const string MROP_VAR_WILDMAGIC_ORIG      = "RoM_bWildMagicFalse";		// module author's setting for Wild Magic on an area
const string MROP_VAR_USEINTEGRATED       = "RoM_bUseIntegrated";		// module author has integrated their spellhoook script with MetaRoP's


const int TALENT_TYPE_UNKNOWN             = -1;
//    int TALENT_TYPE_SPELL               =  0; // nwscript.nss
//    int TALENT_TYPE_FEAT                =  1; // nwscript.nss
//    int TALENT_TYPE_SKILL               =  2; // nwscript.nss
const int TALENT_TYPE_ITEM_SPELL          =  3;

const int SPELL_INVALID                   = -1;
//    int FEAT_INVALID                    = 65535; // nwscript.nss
