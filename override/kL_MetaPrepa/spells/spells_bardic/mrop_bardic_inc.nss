// 'mrop_bardic_inc'
//
// kevL 2016 sept 10
// - data from the kPrC Pack to allow re-compiling.

// ________________
// ** CONSTANTS ***
// ----------------
const int FEAT_EPIC_INSPIRATION			= 3200;
const int FEAT_SONG_OF_THE_HEART		= 3201;
const int FEAT_DRAGONSONG				= 3529;
const int FEAT_ABILITY_FOCUS_BARDSONG	= 3530;

const int SPELL_Inspirational_Boost				= 1819;
const int SPELLABILITY_DRPIRATE_RALLY_THE_CREW	= 2062;

const int CLASS_STORMSINGER			= 109;
const int CLASS_CANAITH_LYRIST		= 124;
const int CLASS_LYRIC_THAUMATURGE	= 125;
const int CLASS_DREAD_PIRATE		= 146;
const int CLASS_DISSONANT_CHORD		= 184;


// ___________________
// ** DECLARATIONS ***
// -------------------

// Gets effective Bardic level.
int GetBardicClassLevel(object oPC);


// __________________
// ** DEFINITIONS ***
// ------------------

// Gets effective Bardic level.
int GetBardicClassLevel(object oPC)
{
	int iBardicMusic = GetLevelByClass(CLASS_TYPE_BARD, oPC);

	iBardicMusic += GetLevelByClass(CLASS_STORMSINGER, oPC);
	iBardicMusic += GetLevelByClass(CLASS_CANAITH_LYRIST, oPC);
	iBardicMusic += GetLevelByClass(CLASS_LYRIC_THAUMATURGE, oPC);
	iBardicMusic += GetLevelByClass(CLASS_DISSONANT_CHORD, oPC);

	return iBardicMusic;
}
