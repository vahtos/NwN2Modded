// 'mrop_spellhook'
//
// kevL's, 2012 july 2
// MetaRod of Preparations ( MRoP )
// aka. Rod of MetaPreparations, Rod of Metamagic, Rod of MetaPrepa ( RoMP! )
// aka. MetaPrepa!
// v.beta.5
// v.beta.6, july 11
// v.beta.7, july 14
// v.beta.7a, july 15
// v.beta.8, july 17 - added Familiars & Animal Companions ( requires changing Spells.2da
//                     and adding spellhook to their summon scripts )
// v.beta.7b, july 16 - fixed bCheat ( subradials )
// v.beta.7c, july 19 - changed feedback recipient to factionLeader
// v.beta.8, july 25
// v.beta.9.1, sept 20 - added StormLord's weapon feats.
// ~ 2013 ~
// v.beta.9.2, jan 7 - fixed Animal Companions.
// v.beta.93 april 20 - stop Associates from preparing buffs.
//                    - refactored main() from top to bottom.
// v.beta.93b april 24 - Instant Feats. Added kPrC Telthor Companion.
//                     - comment Debug.
// v.beta.95 july 4    - added Lesser Mind Blank.
// --- 2014 ---
// v.beta.95a may 12 - added subradial buffs for Blessing of the Righteous.
// v.beta.96 sept 9 - refactor isBuff() use switch/case.
// --- 2020 ---
// v.beta.97 march 12 - add LesserVigor, Vigor, MassLesserVigor to isBuff()
// v.beta.97a march 13 - reformat and fix Storm Avatar ID
//
//
// kevL's, 2012 june 27
// This is a spellhooked script that attempts to implement LostCreation's Rod of
// Preparation as an effectual metamagic buffing device, in addition to its
// regular usage as a standard buffing device.

// NOTE TO DESIGNERS wishing to conform their spellhook script with the Rod of
// MetaMagics: after merging the code below with your own spellhook put a
// Local_Int_variable on your spell-hooked modules, call it
//
// RoM_bUseIntegratedSpellscript = TRUE
//
// Players can still use the Rod, of course; it means "do not use the rod's
// spellhooking script" ... use *your* spellhooking script. The scripts
// 'mrop.nss' and 'i_mrop_rod_ac.nss' ought use that boolean to determine
// whether or not to switch hooking scripts; TRUE means don't switch the
// hooking script back & forth when the Rod switches from Learn to
// Play modes and vice versa. It also eliminates the warning messages
// about existing spellhook scripts (ie. yours); note that naming your
// script the same as the RoP's hookscript would do nearly the same thing ...
// except that would shut down the spellhook when not in Learn mode. doh!
//
// Actually, I put code in that allows that above ....
//
// Ps. Doing this informs the metaRop scripts that you have dutifully merged/
// conformed the Rod of MetaMagics with your module(s), so it will no longer try
// to swap back and forth between them.


#include "mrop_inc"

// Checks if spell is a buff spell.
int isBuff(int iSpellId);


// ____________
// ------------
// *** MAIN ***
// ____________
// ------------

void main()
{
//	if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, "Run ( " + MROP_SPELLHOOK + " ) - " + GetName(OBJECT_SELF));

	// RESTRUCTURED SO IT DOES NOT USE Returns. This makes it easier to merge
	// with other spellhook scripts (believe it or not ..).


	object oModule = GetModule();
	int bMetaRoP_active = GetLocalInt(oModule, MROP_VAR_ACTIVE);
	if (bMetaRoP_active)
	{
		// check if Caster is PC faction
		object oCaster = OBJECT_SELF;
		object oLeader = GetFactionLeader(oCaster);
		if (GetIsObjectValid(oLeader))
		{
			SendMessageToPC(oLeader, "<c=moccasin>MRoP :</c> Learn mode is Active.");
			SendMessageToPC(oLeader, "_ Buffs will be created as Pages in the Book of MetaPrepas.");

			// check that Caster is Owned or Roster. Associates *not* allowed to Prepare buffs.
			if (GetAssociateType(oCaster) == ASSOCIATE_TYPE_NONE)
			{
				// check if Spell is a buff
				int iSpellId = GetSpellId();
				//if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, ". SpellID = " + IntToString(iSpellId));
				if (isBuff(iSpellId))
				{
					// check if spell was Targeted on the ground
					object oTarget = GetSpellTargetObject();
					if (GetIsObjectValid(oTarget)) // && oTarget is a creature or item ... bFaction might check this.
					{
						// check that Target is PC faction or valid faction item
						int bFaction, bItem;
						switch (GetObjectType(oTarget))
						{
							case OBJECT_TYPE_CREATURE:
								bFaction = GetFactionEqual(oTarget, oCaster);
								break;

							case OBJECT_TYPE_ITEM:
								bItem = TRUE;
								bFaction = GetFactionEqual(GetItemPossessor(oTarget), oCaster);
								break;

							default:
								// TODO: Put an error here.
								break;
						}

						// contact
						if (bFaction)
						{
							// ignition
							object oBook = GetPreparationStore(oCaster);
							if (GetIsObjectValid(oBook))
							{
								//if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, ". . Store is valid. Add prep !");

								// lift-off
								int iType, iFeatId;
								string sType, sArkInfo;

								//if (MRoP_iDebug) SendMessageToPC(MRoP_oDebug, ". . Caster class = " + IntToString(GetLastSpellCastClass()) + "\n");
								switch (GetLastSpellCastClass())
								{
									default:
										iType = TALENT_TYPE_SPELL;
										sType = "Spell ";
										sArkInfo = GetTalentTitle(iSpellId, iType);
										break;

									case CLASS_TYPE_INVALID:
										iType = TALENT_TYPE_FEAT;
										sType = "Feat ";
										iFeatId = GetFeatId(iSpellId);
										sArkInfo = GetTalentTitle(iFeatId, iType);
								}

								// MessageToPlayer:
								SendMessageToPC(oLeader, "<c=moccasin>MRoP :</c> attempting to <c=orchid>Prepare " + sType + sArkInfo + "</c>");

								string sMessage = "_ Spell ID : " + IntToString(iSpellId);
								if (iType == TALENT_TYPE_FEAT) sMessage += " . . Feat ID : " + IntToString(iFeatId);
								SendMessageToPC(oLeader, sMessage);

								int iMeta = GetMetaMagicFeat(); // <- the crux of the MetaRod of Preparations.
								// note that, if TALENT_TYPE_FEAT, iSpellId will be turned back into iFeatId ( again ) later
								AddPreparationToBook(iSpellId,
													 oBook,
													 oCaster,
													 oTarget,
													 iMeta,
													 iType,
													 bItem);
							}
							// Book is not valid here.
						}
						else // if (!bFaction)
							SendMessageToPC(oLeader, "<c=moccasin>MRoP :</c> The spellTarget is not PC faction."
									+ " A Page of Preparation will <b>not</b> be prepared. ( Target = " + GetName(oTarget) + " )");
					}
					else // if (!GetIsObjectValid(oTarget))
						SendMessageToPC(oLeader, "<c=moccasin>MRoP :</c> Spells cast onto the"
								+ " ground will <b>not</b> be prepared as Pages in a Book of Preparations.");
				}
				else // if (!bIsBuff)
					SendMessageToPC(oLeader, "<c=moccasin>MRoP :</c> The Talent you are attempting is"
							+ " <b>not</b> listed as a valid Buff. ( Spell ID = " + IntToString(iSpellId) + " )");
			}
			// Associates go here.
		}
		// not PC faction Casters go here.
	}
	// MetaRoP is *not* active here.
}



/*
GetSpellId();					// returns the SPELL_* constant of the spell cast
GetSpellLevel();
GetSpellTargetObject();			// returns the targeted object of the spell, if valid
GetSpellTargetLocation();		// returns the targeted location of the spell, if valid
GetLastSpellCastClass();		// gets the class the PC cast the spell as
GetSpellCastItem();				// if an item cast the spell, this function gets that item
GetSpellSaveDC();				// gets the DC required to save against the effects of the spell
GetCasterLevel(OBJECT_SELF);	// gets the level the PC cast the spell as

GetHasSpell
GetSpellKnown
GetSpellLevel
*/


// Checks if spell is a buff spell.
int isBuff(int iSpellId)
{
	// short duration buffs are Enabled.
	switch (iSpellId)
	{													//	Duration	Target					Childs
// WIZARD 0:
		case 100:	// light								long
		case 151:	// resistance							short
// WIZARD 1:
		case 1163:	// blades of fire						short
		case 845:	// detect undead
		case 50:	// endure elements						long
		case 846:	// enlarge person
		case 456:	// expeditious retreat					short
		case 848:	// low light vision
		case 102:	// mage armor							long
		case 544:	// magic weapon							long		creature or weapon
		case 1171:	// nightshield
//		case 321:		// protection from alignment		long								master
			case 138:	// protection from evil				long								subradial
			case 139:	// protection from good				long								subradial
		case 1200:	// reduce person
		case 417:	// shield
		case 174:	// summon creature 1					short
		case 415:	// true strike							short
// WIZARD 2:
		case 1168:	// animalistic power
		case 49:	// bear's endurance
		case 849:	// blindsight
		case 9:		// bull's strength
		case 13:	// cat's grace
		case 36:	// darkness								short
		case 519:	// death armor							short
		case 354:	// eagle's splendor
		case 850:	// false life							long
		case 356:	// fox's cunning
		case 120:	// ghostly visage
		case 90:	// invisibility
		case 852:	// mirror image
		case 355:	// owl's wisdom
		case 853:	// protection from arrows				long
		case 150:	// resist energy						long
		case 157:	// see invisibility
		case 1201:	// snake's swiftness					short
		case 175:	// summon creature 2					short
// WIZARD 3:
		case 20:	// clairaudience/clairvoyance			short
		case 458:	// displacement							short
		case 545:	// greater magic weapon					long		creature or weapon
		case 78:	// haste								short
		case 857:	// heroism								med-long
		case 858:	// improved mage armor					long
		case 92:	// invisibility sphere
		case 539:	// keen edge							med-long	creature or weapon
//		case 322:		// magic circle against alignment	long								master
			case 104:	// magic circle against evil		long								subradial
			case 105:	// magic circle against good		long								subradial
		case 137:	// protection from energy				long
		case 859:	// rage									short
		case 1213:	// snake's swiftness, mass				short
		case 860:	// spiderskin							med-long
		case 176:	// summon creature 3					short
//		case 1814:		// weapon of energy					short		weapon					master
			case 1815:	// weapon of F						short		weapon					subradial
			case 1816:	// weapon of A						short		weapon					subradial
			case 1817:	// weapon of C						short		weapon					subradial
			case 1818:	// weapon of E						short		weapon					subradial
		case 861:	// weapon of impact						med-long	creature or weapon
// WIZARD 4:
		case 2:		// animate dead							long
		case 47:	// elemental shield						short
		case 88:	// greater invisibility					short
		case 1013:	// greater resistance					long
		case 967:	// least spell mantle					short
		case 119:	// minor globe of invulnerability		short
//		case 130:		// polymorph self														master
			case 387:	// sword spider															subradial
			case 388:	// troll																subradial
			case 389:	// umber hulk															subradial
			case 390:	// gargoyle																subradial
			case 391:	// mindflayer															subradial
		case 1212:	// reduce person, mass
//		case 159:		// shadow conjuration													master
			case 344:	// summon shadow														subradial
			case 346:	// invisibility															subradial
			case 347:	// mage armor															subradial
		case 172:	// stoneskin							long
		case 177:	// summon creature 4					short
// WIZARD 5:
		case 95:	// lesser mind blank					short
		case 99:	// lesser spell mantle					short
		case 179:	// summon creature 5					short
// WIZARD 6:
		case 1812:	// chasing perfection
		case 30:	// create undead						long
		case 121:	// ethereal visage						short
		case 65:	// globe of invulnerability				short
		case 876:	// greater heroism
		case 74:	// greater stoneskin					long
		case 376:	// legend lore
		case 1024:	// mass bear's endurance
		case 1025:	// mass bull's strength
		case 1027:	// mass cat's grace
		case 1028:	// mass eagle's spendor
		case 1029:	// mass fox's cunning
		case 1026:	// mass owl's wisdom
		case 128:	// planar binding
		case 878:	// stone body
		case 180:	// summon creature 6					short
		case 1014:	// superior resistance					long
		case 184:	// tenser's transformation				short
		case 186:	// true seeing
// WIZARD 7:
//		case 879:		// energy immunity					long								master
			case 976:	// acid								long								subradial
			case 977:	// cold								long								subradial
			case 978:	// electrical						long								subradial
			case 979:	// fire								long								subradial
			case 980:	// sonic							long								subradial
		case 724:	// ethereal jaunt						short
//		case 71:		// greater shadow conjuration											master
			case 349:	// summon shadow														subradial
			case 351:	// ghostly visage														subradial
			case 353:	// minor globe of invulnerability										subradial
		case 123:	// mordenkainen's sword					short
		case 160:	// shadow shield
		case 169:	// spell mantle							short
		case 181:	// summon creature 7					short
// WIZARD 8:
		case 541:	// blackstaff							short		creature or weapon
		case 29:	// create greater undead				short
		case 69:	// greater planar binding
		case 885:	// iron body
		case 117:	// mind blank
		case 134:	// premonition							long
		case 141:	// protection from spells
		case 182:	// summon creature 8					short
// WIZARD 9:
		case 443:	// etherealness
		case 63:	// gate									short
		case 73:	// greater spell mantle					short
//		case 158:		// shades																master
																								//- Delayed Blast Fireball (when cast on a hostile creature)
																								//- Summon Creature VIII (when cast on the ground)
																								//- Premonition, Protection from Spells, and Shield (when cast on yourself)
			case 969:	// premonition, protection from spells, shield							subradial
//		case 161:		// shapechange															master
			case 392:	// frost giant															subradial
			case 393:	// fire giant															subradial
			case 394:	// horned devil															subradial
			case 395:	// nightwalker															subradial
			case 396:	// iron golem															subradial
		case 178:	// summon creature 9					short

// CLERIC 0:
		case 189:	// virtue								short
// CLERIC 1:
		case 6:		// bless
		case 1740:	// blessed aim
		case 1172:	// conviction							med-long
		case 414:	// divine favor							short
		case 418:	// entropic shield
		case 1021:	// lesser vigor
		case 154:	// sanctuary							short
		case 450:	// shield of faith
// CLERIC 2:
		case 1:		// aid
		case 2111:	// benediction							med-long
		case 2105:	// divine protection
		case 1760:	// hand of divinity
		case 1821:	// k's living undeath
//		case 1747:		// lesser energized shield			short		shield					master
			case 1748:	// lesser energized shield F		short		shield					subradial
			case 1749:	// lesser energized shield C		short		shield					subradial
			case 1750:	// lesser energized shield E		short		shield					subradial
			case 1751:	// lesser energized shield A		short		shield					subradial
			case 1752:	// lesser energized shield S		short		shield					subradial
		case 1170:	// living undeath
		case 133:	// prayer								short
		case 867:	// shield other							long
//		case 163:		// silence																master, mine
//			case 1685:	// silence, friendly				short								subradial, mine
// CLERIC 3:
		case 1744:	// cloak of bravery						med-long
//		case 1753:		// energized shield					short		shield					master
			case 1754:	// energized shield F				short		shield					subradial
			case 1755:	// energized shield C				short		shield					subradial
			case 1756:	// energized shield E				short		shield					subradial
			case 1757:	// energized shield A				short		shield					subradial
			case 1758:	// energized shield S				short		shield					subradial
		case 1759:	// flame of faith						short		weapon
		case 1040:	// lesser visage of the deity			short
		case 546:	// magic vestment						long		creature, armor or shield
		case 1052:	// mass aid
		case 1022:	// mass lesser vigor
		case 1766:	// shield of warding								shield
		case 1020:	// vigor
		case 1771:	// weapon of the deity					short		weapon
// CLERIC 4:
		case 1742:		// blessing of the righteous		short								// NOTE: Leave this for backward compatibility.
			// kL_add: 2014 may 12
			case 1775:	// BotR vs Evil						short								subradial, mine
			case 1776:	// BotR vs Good						short								subradial, mine
			// add_end.
		case 38:	// death ward
		case 42:	// divine power							short
		case 62:	// freedom of movement
		case 1054:	// recitation							short
		case 1770:	// undead bane weapon					long		weapon
// CLERIC 5:
		case 517:	// battletide							short
		case 890:	// righteous might						short
		case 168:	// spell resistance
// CLERIC 6:
		case 451:	// planar ally
		case 1795:	// visage of the deity					short
// CLERIC 7:
		case 374:	// regenerate							short
// CLERIC 8:
//		case 323:		// aura versus alignment			short								master
			case 84:	// holy aura						short								subradial
			case 187:	// unholy aura						short								subradial
		case 1820:	// lion's roar
		case 1018:	// mass death ward
// CLERIC 9:
		case 1041:	// greater visage of the deity			short
		case 444:	// undeath's eternal foe				short

// WARLOCK 1:
		case 811:	// all-seeing eyes						long
		case 807:	// beguiling influence					long
		case 809:	// dark one's own luck					long
		case 810:	// darkness								short
		case 814:	// entropic warding
		case 817:	// leaps and bounds						long
		case 1059:	// otherworldly whispers				long
		case 818:	// see the unseen						long
// WARLOCK 2:
		case 825:	// flee the scene						short
		case 2071:	// ignore the pyre						long
		case 823:	// the dead walk						long
		case 829:	// walk unseen							long
// WARLOCK 3:
// WARLOCK 4:
		case 2069:	// dark foresight						med-long
		case 838:	// dark premonition						med-long
		case 841:	// retributive invisibility				short
		case 843:	// word of changing						short

// DRUID 1:
		case 421:	// camoflage
		case 2094:	// enrage animal						short
		case 1000:	// foundation of stone					short
		case 452:	// magic fang
// DRUID 2:
		case 3:		// barkskin								long
		case 1001:	// body of the sun						short
		case 2099:	// embrace the wild						med-long
		case 542:	// flame weapon										creature or weapon
		case 2095:	// halo of sand							med-long
		case 2101:	// hawkeye								med-long
		case 2100:	// linked perception
		case 455:	// mass camoflage
		case 1828:	// nature's favor									animal companion
		case 2124:	// primal hunter						long
		case 1210:	// reduce animal									animal
		case 2121:	// spirit of the rat					short
		case 1832:	// wild instincts
// DRUID 3:
		case 453:	// greater magic fang
		case 1002:	// jagged tooth							med-long	animal companion
		case 2098:	// lesser aura of cold					short
		case 2125:	// primal instincts						long
		case 2123:	// spirit of the wolf					short
		case 1951:	// thorn skin							short
//		case 529:		// vine mine						short								master
			case 532:	// camouflage						short								subradial
// DRUID 4:
		case 2126:	// primal senses						long
		case 2096:	// skin of the cactus					med-long
		case 2120:	// spirit of the boar					short
// DRUID 5:
		case 2093:	// animal growth									animal companion
		case 363:	// awaken											animal companion
		case 438:	// owl's insight						long
		case 1950:	// plant body							med-long
		case 1830:	// sirine's grace						short
		case 2122:	// spirit of the tiger					short
// DRUID 6:
		case 1928:	// liveoak								long
		case 2116:	// primal speed							long
		case 2119:	// spirit of the bear					short
		case 1005:	// tortoise shell						med-long
// DRUID 7:
		case 372:	// aura of vitality						short
// DRUID 8:
		case 1931:	// phantom wolf							short
		case 1007:	// storm avatar							short
// DRUID 9:
		case 48:	// elemental swarm
		case 1008:	// nature's avatar						short		animal companion
		case 1930:	// phantom bear							short

// RANGER 1:
		case 2104:	// towering oak							short
// RANGER 2:
		case 2113:	// insignia of blessing
		case 2103:	// swift haste							short
// RANGER 3:
		case 2115:	// insignia of warding
// RANGER 4:

// PALADIN 1:
		case 537:	// bless weapon										creature or weapon
		case 2107:	// flamebound weapon								weapon
		case 1053:	// lionheart							short
		case 1765:	// second wind							long
		case 1767:	// silverbeard
		case 1768:	// strategic charge						short
// PALADIN 2:
		case 1738:	// angelskin							short
		case 429:	// aura of glory
		case 1769:	// strength of stone					short
		case 1772:	// zeal									short
// PALADIN 3:
		case 1741:	// blessing of bahumut					short
		case 2118:	// mantle of faith						med-long
		case 1764:	// righteous fury
// PALADIN 4:
		case 1746:	// draconic might
		case 2110:	// favor of the martyr
		case 2112:	// glory of the martyr					long
		case 538:	// holy sword							short		creature or weapon
		case 1761:	// lawful sword							short		creature or weapon
		case 1774:	// righteous glory

// BARD 1:
		case 442:	// amplify								short
		case 1819:	// inspirational boost
		case 864:	// joyful noise							short
// BARD 2:
		case 2129:	// blur
		case 1831:	// sonic weapon										weapon
// BARD 3:
		case 1813:	// sonic shield							short
// BARD 4:
		case 373:	// war cry								short
// BARD 5:
// BARD 6:
		case 1833:	// nixie's grace						med-long

// BARDIC INSPIRATIONS ( Feats )
		case 905:	// inspire courage
		case 906:	// inspire competence
		case 907:	// inspire defense
		case 908:	// inspire regeneration
		case 909:	// inspire toughness
		case 910:	// inspire slowing
		case 911:	// inspire jarring

// Familiar & Animal Companion SUMMONS ( Feats )
		case 317:	// animal companion
		case 318:	// familiar
		case 2063:	// telthor companion

// StormLord ( Feats )
		case 1108:	// shock weapon
		case 1109:	// sonic weapon
		case 1110:	// shocking burst weapon

// Cleric ( Feats )
//		case 1182:	// divine vengeance
//		case		// sacred vengeance
//		case 473:	// divine might
//		case 474:	// divine shield
			return TRUE;
	}

	return FALSE;
}
