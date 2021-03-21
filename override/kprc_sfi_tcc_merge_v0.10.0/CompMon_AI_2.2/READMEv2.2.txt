Documentation for Companion and Monster AI Hak

V2.2 Sept 27, 2009

This version should be used with NWN2 1.21 or later with or without the MotB or SoZ 
expansion pack installed. The erf and hak version require SoZ due to nwscript constants 
that are only defined with SoZ installed. SoZ includes a modified version of the AI based 
on 1.9.

This is a package to improve the decision making of your companions and the monsters 
you combat. It is the successor to the NWVault NWN Hall of Fame hakpak Henchman 
Inventory & Battle AI.

Quick installation instructions:

Place all of the files in the zip into the "My Documents\Neverwinter Nights 2\override" 
directory. It can also be placed into subdirectories of the override directory. The presence 
of other haks may conflict with this one. If you run into a problem, try removing the other 
haks.

Your help in finding and diagnosing issues that are found will help everyone out that uses 
this package. I.e. I may ask for saved games, etc. in order to help find a problem. 
Suggestions about how to improve the AI are also welcome. I have play-tested this 
through the entire official campaign, but there are certainly more bugs yet to be found. 
Compressed saved game folders can be sent to kostichk@hotmail.com.


Known limitations:

Clerical spontaneous casting is done with cheat casting which sets the caster level at 10 
instead the real caster level. This is due to a limitation in the NWN2 script function calls.

Clerical domain spells are not used and can not be used with spontaneous casting. This is 
a limitation of the NWN2 script function calls.

Wands and other items that use charges can cause the AI to do nothing if there are too 
few charges remaining on the item. The item must be sold, dropped, or put into a bag.


To those familiar with the Henchman Inventory and Battle AI, almost all of the settings 
that were part of the henchman's dialog are now in the behavior tabs. This includes the 
weapons switching, trap, lock, and item settings. There also are some new settings. These 
options are available in both the character and creature behavior tabs. Some options that 
were part of the Henchman Inventory and Battle AI install are now in the character 
behavior tab. This includes the monster wander and stealth options. 


The following commands have changed:

Follow.

Telling a companion, henchman, or summoned creature to go into follow mode causes 
them to just follow and not attack. They will give a message "Should I attack" if they are 
in this state and enemies are nearby. Give an attack nearest to clear this state.

Heal Me.

Outside of combat the companion that was issued the command continues to try and heal 
the PC. Issuing a follow, guard or attack nearest stops the auto casting.

The following new commands have been added:

Heal Self.

Heal the target. Can be broadcast to entire party. Outside of combat the companion that 
was issued the command continues to try to heal himself.

Heal Party.

Heal the party. Can be broadcast to entire party. Outside of combat the companion that 
was issued the command continues to try to heal the party. Works well with clerical 
spontaneous casting of healing spells.

Buff.

The commands are divided into three categories, long (hour per caster level or longer), 
medium (minute per caster level), and short (round per caster level). Summon, spell 
mantles and globes, and most melee type buffs (barbarian rage, etc.) are not cast. Medium 
duration casts all long duration followed by medium duration. If more than one 
companion is issued the command, they will wait for all long duration spells to be cast 
before casting their medium duration spells. Short duration casts long duration followed 
by medium duration with multiple companions waiting for all members of the party to 
finish their long and medium duration spells before starting another duration. The 
commands can be issued to buff PC, self, or party. 

Scout.

This command is only available for a single target and only works with associates 
(henchmen, familiars, animal companions, summons, and dominated creatures). This is 
best used to send in summoned creatures first to soak up damage.

Directions.

This command is available for both a single member of your party or as a broadcast 
command. The sub commands under Directions change the default follow and guard 
behavior of both companions and associates. With these commands you can set a 
companion to follow another member of your party or to follow no one. Follow can be 
chained together in order to form a more organized marching order. A summoned 
creature can follow or guard someone else besides their master. I.e. a summoned creature 
from a caster at the back of the party can follow the leader of the party so it can get into 
melee combat sooner. As another example a summoned animal companion can be put at 
the back of the party and guard a mage in order to keep it out of melee combat at the 
beginning of an encounter. A "follow me" command overrides the follow directions until 
cancelled.

Follow No One (Directions - single target)

The targeted member of your party will not follow anyone. It is useful to set this on the 
PC or companion you normally control so that if you temporarily change control, they do 
not move.

Follow Default (Directions)

The targeted member of your party will use the default follow behavior of following the 
currently controlled character for a companion or their master for an associate. A 
broadcast will only change the behavior of the currently controlled character.

Follow Default All (Directions - broadcast)

Resets the entire party back to the default follow behavior. Companions follow the 
currently controlled character and associates follow their master.

Follow Me (Directions - single target)

The selected party member follows the currently controlled character.

Follow Target (Directions - single target)

The currently controlled character follows the selected party member.

Follow Single File (Directions - broadcast)

The entire party of companions follows single file. The currently controlled character 
follows no one and the rest of the party follows in order based on base attack bonus and if 
equal by armor class. Associates' following is not changed.

Follow Double File (Directions - broadcast)

The entire party of companions follows double file. The currently controlled character 
follows no one and the rest of the party follows in order based on base attack bonus and if 
equal by armor class. Associates' following is not changed.

Guard Target (Directions - single target)

The currently controlled character guards the currently selected party member.

Guard Me  (Directions - single target)

The currently selected party member guards the currently controlled character.

Guard Default (Directions)

The currently selected party member is set back to the default guard behavior (guard 
master for associates, guard currently controlled party member for companions).

Guard Default All (Directions - broadcast)

All party members are set back to the default guard behavior (guard master for associates, 
guard currently controlled party member for companions).


The following new options are available in the inventory screen to select weapons:

AI melee weapon

Sets the main (right hand) melee weapon that the companion uses. Automatic weapon 
switching must be turned on for this to work. The distance that ranged and melee 
weapons are equipped at is in the behavior settings.

AI no melee weapon

Use no melee weapon (unarmed strike). Automatic weapon switching must be turned on 
for this to work. The distance that ranged and melee weapons are equipped at is in the 
behavior settings.

AI ranged weapon

Sets the ranged weapon that the companion uses. Automatic weapon switching must be 
turned on for this to work. The distance that ranged melee and weapons are equipped at is 
in the behavior settings.

AI shield

Sets the shield that the companion uses. The companion must be set to use shields and the 
right hand weapon must be small enough to allow the shield to be used.

AI off hand weapon

Sets the off hand (left hand) melee weapon that the companion uses. The companion 
must be set to use off hand weapons and the main hand weapon cannot be two handed 
unless the companion has the monkey grip feat.

AI reset weapons

Reset all weapons back to the default auto select behavior.


The following original behavior is modified:

Casting option.
Previously only the disable casting mostly worked. It now works and the other three 
options control at what enemy difficultly spellcasting, feat use, and item usage starts at. 
Spells with infinite use like warlock or bard inspirations are only stopped by the disable 
casting option.

The following are new behaviors:

Recover Traps.
On, Safe, or Off. In Safe Mode, traps are recovered as long as there is at most a 25% 
chance of triggering them. This means not many traps are recovered and there is still a 
chance of failure.

Guard Distance.
Set the guard distance to default (20.0m if set to use ranged weapons, 7.0m if set to use 
melee), near (7.0m), medium (13.5m), and far (20.0m).

Automatically Open Locks.
Locked chests are automatically opened in a manner similar to how traps are done.

Automatically Pick Up Items.
Nearby body bag items are recovered. The items are placed into the companion's 
inventory. This option only works for companions.

Automatically Hide.
The companion will go into stealth if they have sneak attack and the hide can succeed.

Use Healing and Curing Items.
Turns on the use healing and curing items when the "use items" setting is off.

Summoning.
Turns on and off the use of summoning spells.

Polymorph
Turns on and off the use of polymorph spells. This also includes similar spells like stone 
and iron body.

Infinite Buff.
Turns on and off the use of unlimited spells and abilities out of combat. Only works with 
warlocks and bard inspirations (regeneration and competence). This option is turned off 
automatically if no buffs can be done.

Automatic Weapon Switching.
Enables the companion to automatically switch weapons during combat. This includes 
switching to/from ranged and switching to a blunt or sharp weapon based on the damage 
resistance of an opponent. Due to the NWN2 function being used, damage is the primary 
consideration for selection. This can result in two handed weapons being selected over 
ones that you might like. In this case, move the two handed weapons to another 
companion or put the weapon into a bag.

Ranged Weapons.
Enables use of ranged weapons. Off by default. Note that there is a quirk in the NWN2 
ranged weapon equipping function that prevents switching to another ranged weapon 
type if you run out of ammo. This can be worked around by giving them ammo or by 
taking the ranged weapon away or by moving the ranged weapon to the end of the 
inventory. (I.e. last tab, bottom right, assumes there is another ranged weapon earlier in 
the inventory) 

Switch To Melee Distance.
Near (3.5m), medium (5m), and far (6.5m). Distance at which ranged weapons will be 
switched to melee. 

Melee Attack for Party
Will go into melee attack if any member of the party is in melee attack. Otherwise ranged 
weapons are used.		

Back Away.
Will avoid melee combat by moving away from enemies. This is only done if there is a 
friend to hide behind and an enemy isn't too close already.

Disable Melee Attacks
Will not use melee attacks against enemies. Only spells and ranged weapons are used.	

Dual Wielding.
Enable, disable, or automatic dual wielding. Automatic checks for the two weapon 
fighting feat.

Heavy Off Hand Weapons.
Enable or disable. Heavy off hand weapons cause more of an attack penalty for both 
hands.

Use Shields.
Enable or disable.

Puppet Mode Pause Every Round
If the global option "Pause and Switch Control" is turned on, the companion will pause 
every round instead of when they have nothing to do or have switched targets.

The following are party options. They are only available in the character sheet and are 
stored on the PC character. Settings can be saved and loaded; the last saved settings are 
loaded automatically when a new game is started.

Unequip Weapons After Combat
If automatic weapon switching is turned on, companions will unequip weapons after 
combat is done.

Auto Summon Familiars
Outside of combat, party members will automatically summon familiars if they have the 
feat.

Auto Summon Animal Companions
Outside of combat, party members will automatically summon animal companions if they 
have the feat.

Ally Damage
Indicate the amount of ally damage allowed for harmful area of effect spells. (Low, 
medium, and high)

Peaceful Follow
Party members will not attack enemies after being issued a follow command. Issue an 
"Attack Nearest" to clear them out of this state.

Self Buff or Heal
Player character will buff or heal when group command is given.

Weapon Switching Messages
Turn on and off weapon switching messages from party members.

Puppet Follow
Party members will follow and do other non combat activities.

The following are global options. They are only available in the character sheet and are 
part of the saved game. Settings can be saved and loaded; the last saved settings are 
loaded automatically when a new game is started.

Monster Stealth.
Monsters will use stealth if they have any skill ranks with hide or move silently

Monster Wander.
Monsters will wander around looking for you

Monster Open Doors.
Monsters will open doors when looking for you. Only works if monster wander is turned 
on.

Monster Unlock or Bash Doors.
Monsters will unlock or bash open doors looking for you. Only works if monster open 
doors is turned on.

Knockdown
Changes knockdown use from regular, sometimes, to never.

Auto Set of Companion Behaviors
Default on. Automatically adjusts companion settings the first time they are met in order 
to provide better defaults.

Enemies Auto Cast Buffs
Long, medium, or off. Enemies automatically have cast long duration spells at the start of 
combat. Turning medium on has both long and medium duration buffs cast before 
combat. This simulates how creatures would normally buff while in a dangerous area.

Enemies Create Items
Enemies that can use potions create some healing and buffing potions randomly for their 
use.

Enemies Use Equipped Items
Workaround so enemies will be able to use equipped items such as staves and rings. This 
is not normally possible in NWN2.

Warlock One Round Hideous Blow
Warlocks use hideous blow in one round. Makes AI controlled creatures have the same 
ability as using Draco Rayne's warlock buddy.

Monster Ally Damage
Monsters damage allies with area of effect spells based on alignment.

Heartbeat Detection of Enemies
Heartbeat detection prevents monsters and companions standing around during combat 
due to certain actions they take. Options to turn on, off, or just enable hearing. Turning 
off hearing will make the AI less response to stealthed enemies but will stop attacks from 
the other sides of doors, etc. Turning this option off temporarily may help get past some 
cutscenes that don't work properly.

Pause and Switch Control
When puppet mode is on for a companion during combat, the game will pause and switch 
control to the companion when they need to do something. The "Puppet Mode Pause 
Every Round" behavior setting causes the pause to happen every round, otherwise a 
pause happens when the companion has nothing to do or they have switched attack 
targets.

Pause for Traps 
Pauses the game when a trap is detected by any party member.

Options (Save, Load, and Reset)
Allows saving a default set of party and global options to the campaign database. The 
first time a module is run, these settings are loaded. A Load button forces the settings to 
be loaded after a module is started and a Reset button puts all party and global settings 
back to default.


The following features are included:

1)	All creatures, both friends and foes, will make more intelligent choices about 
weapon switching, spellcasting, targeting, healing, feat/skill usage, dual wielding, 
and summoning during combat.
2)	Companions will be more useful outside combat. You will be able to ask them to 
pick up items for you, open locks, recover traps, cast healing and buffs spells on 
command, and cast infinite buff spells automatically for you if they have the 
appropriate spells or skills.
3)	More behavior settings in order to guide actions of companions and associates.
4)	Spellcasting companions will not waste their spells on weak enemies.
5)	Companions will use or better use thieves' tools, healing kits, and certain non-
equippable magical items such as wands.
6)	Spontaneous casting of clerical cure and inflict wounds spells.
7)	AI is scaled based on the creature's intelligence. Very low intelligence creatures 
only attack closest target, high intelligence creatures find and exploit enemies' 
weaknesses. The AI will not cast inappropriate spells against a target that is 
immune to them, including elemental immunities like fire.
8)	Summoned associates remember their behavior settings between summons.
9)	Companions can be asked to buff or heal you, themselves, or the whole party 
outside of combat.
10)	Summoned creatures can scout looking for enemies first in order to soak up 
damage.
11)	 Companions can be set up to follow or guard something other than the currently 
controlled character. Associates can be set up to follow or guard something 
besides just their master.


File reference

*.ncs files.		- These are compiled script files that run the AI.
henchspells.2da, henchclasses.2da, and henchracial.2da.
			-  Table that provides information to the AI about spells, classes, 
racial type and the feats they use.
characterscreen.xml	- Modified character behavior settings. This file may conflict with 
some UI customization mods.
creatureexamine.xml	- Modified companion and associate behavior settings. This file 
may conflict with some UI customization mods.
contextmenu.xml	- Modified context menu for issuing new commands. This file may 
conflict with some UI customization mods.
*.nss			- These files are required for the behavior setting customization to 
function.

Acknowledgements

From the original NWN Henchman Inventory  and Battle AI. There have been three main 
authors of the hak: Pausanias, Auldar, and Tony K. Some code and ideas are still in this 
AI from these people: Jugalator (draft of spell AI), Jasperre (healing and melee attacking 
code), and LoCash (animal behavior). Many others helped with things no longer a part of 
this AI or with testing it.

For the NWN2 version the following : Ishan, K2, Nickolaas, BrionT, macrocarl Pigwind, 
FieryDove, Cirerrek, Mountainlake, Omm_Ni, dorschman, Searevok, FalloutBoy, 
Vortaka, mindjuicer, Chris Shaffer, Acemo, Entropius42, ichibanb, 
and special mention to Bodea for being brave enough to try things out and report back 
about issues from the very first release. Use of NWN2Packer provided by tani.

History

V2.2, Sept 27, 2009

All feats are shown for familiars and animal companions. Adjustments for NWN 1.23 
patch. Add support for warlock epic spells. Changes and improvements in how guard 
mode works. Party members in guard mode should select targets better and position 
themselves better to counter observed threats. Updates for Kaedrin's PrC pack 1.38.3. AI 
support for instant feats. Better workaround for moving to unseen and unheard enemies. 
For module builders, support for at will spells for creatures and cheat cast caster level.

V2.1, Mar 15, 2009

When in pause and switch mode, do not pause and switch to disabled companions. Do 
not pause and switch during a cutscene (multiplayer conversion). For auto pickup account 
for containers in the inventory full messages. Remove use of inspire frenzy, it shouldn't 
get used unless all of the party is fighters and is done to all members of the same faction 
(not good for monsters). Rework AI to allow custom spells, classes, class spells, and 
racial spells to be added to it. Script functions added to allow adding the custom content 
on module load. Improve behavior of feat use with silence and anti magic effects. Basic 
support added for Kaedrin's custom classes with full support for blackguard, assassin and 
avenger spell books. Support for 10 of the 12 reserve feats. Fixed issues with fleeing 
persistent area of effect spells when immune to the spell. Improvements made in 
spellcasting with targets with immunities. Respond to saw trap events and broadcast them 
to party members. Out of combat trap removal should work better. Changes to prevent 
open lock attempts being made when pathing to lock isn't possible. Familiars always 
follow in puppet mode. Broadcast commands of attack nearest, follow me, guard me, and 
stand your ground now set the flags on the currently controlled party member. Add pause 
when floor trap detected global setting. Do not start monster wander if heartbeat detection 
is turned off and there are nearby enemies. Fix follow and guard target options across 
module loads with SoZ cohorts since they do not have tags. Fix for party members not 
following after directions commands are given. Fix an issue where it was harder than it 
should be to break away from an enemy that could not see or hear you. Disabled 
monsters do not record last location of enemies. Fix for doors not being opened when 
walking waypoints with monster wander on. Add script only flag to not attack dying 
enemies (PCs).

V2.0, Dec 13, 2008

Updates for new SoZ content - spells, feats, and classes. Stop flee the scene being cast 
out of combat with persistent haste already active. New global option and party setting 
for pause in combat while in puppet mode. Party follow setting - out of combat party 
members will follow and do other activities like picking up items if set to do so. Fixes to 
the heartbeat detection checks. Improvements to handling dying cohorts, including 
healing and raise dead. Slaan (at Highcliff castle) sometimes comes out of his normal 
target area. Hostile persistent area of effect spells are not cast at the same time by party 
members. Fixes and improvements to enemies not attacking past a closed door. 
Improvement to melee combat AI. DM client actions to move monsters past doors should 
work like the original default AI with default global options. Reduce use of healing spells 
on undead enemies.

V1.11, Aug 13, 2008

Fixed persistent spells being reported when they should not be for trap, lock, and item 
pickup routine. Improved reactions to persistent spells. Limits to how many persistent 
spells are cast in a combat. Fix for ranged weapons being turned off after loading a saved 
game. The companion spawn script runs on the PC when a saved game is loaded. 
Overrode spawn script in order to prevent settings being changed when loading saved 
game and give better defaults when a module is started. Fix healing not always being 
done in melee combat. Fix enemy autobuff not being used. Fix auras not always being 
enabled. Improve reliability of cut scene conversations. Reduce CPU usage for character 
and creature examine screens. Add heartbeat detection options to disable or to only detect 
seen enemies. Add party option to turn off messages during weapon switching.

V1.10, Jul 12, 2008

Add support for some types of buffs not currently cast with the out of combat buff 
commands (Summons, true seeing, and spell resistance). Improvements and fixes in 
casting of spell protection and detect invisibility spells.  Fixed use of healing items when 
items turned off but healing and curing is enabled attacking undead enemies. For auto 
disarming traps, opening locks, and picking up items, check if any area of effect spells 
are active in the area and wait for them to expire before doing automatic actions. 
Elemental summoning items are now used. When feat/ability use is turned off, do not use 
limited use feats in melee such as smite evil. Improve move to unheard and unseen 
enemy to not get stuck with other creatures moving to same enemy. Show the peaceful 
follow mode warning message "Should I attack?" only once per combat. Monsters will 
not use ranged weapons in their inventory unless equipped with them at the start of 
combat. Fix LoH using crossbow instead of melee weapon. Adjustment to heal command 
in checking regeneration. Will also try to use the lowest level spell that will still do full 
healing instead of wasting a higher level spell. Add buttons to the character screen that 
allow saving a default set of party and global options to the campaign database. The first 
time a module is run, these settings are loaded. A Load button forces the settings to be 
loaded after a module is started and a Reset button puts all party and global settings back 
to default.

V1.9, May 18, 2008

Updates for NWN2 patch 1.12. Includes support for portraits and various spell changes. 
Enhance disable melee attacks option to use combat expertise. When switching control of 
party members, if they are in stand ground mode, don't start following the leader. Fix 
honoring stand ground mode in combat if party member is set up to follow no one. 
Prevent infinite buff spells being cast during resting interrupting resting. Improvements in 
bard spells and feats, touch attack, invisibility, and persistent spell usage. When changing 
"Disable peaceful follow" it will immediately change the settings for the current party 
members. They do not need to be toggled to attack and back to follow mode to change 
the behavior. Also changed "Disable Peaceful Follow Mode" to "Peaceful Follow Mode" 
Add a context menu set melee weapon to used unarmed strike (no weapon). Stop combat 
feat use while polymorphed. Players are unable use combat feats while polymorphed, so 
the AI shouldn't either. Combat modes (parry, expertise, power attack) can be used. 
Enable the player controlled character to be directed to cast buff spells on command and 
cast infinite buff spells. Updates for spells from Kaedrin's PrC pack 1.32. Add support 
for medium duration buff precast as global option. With auto pick up, if the companion 
doesn't have any space in the inventory, a message is given that the inventory is full and 
no more items are picked up until space is made in the inventory.

V1.8, Jan 1, 2008

Add support for all druid polymorph feats. Improve support for stone and iron skin 
(especially use of stone skin more often by cleric). Improve logic for determining best 
polymorph shape (.i.e. check if greater magic fang spell is available and use a form that 
supports it.) Under certain circumstances, when a character is trying to melee and nearby 
friends block their path to the enemy they do doing, they will now either try to maneuver 
around their friends, or switch to ranged, or use a spell. Improve and rework the use of 
elemental shield and weapon buff spells. Add support for more spells from Kaedrin's PrC 
pack. Update skills UI for NWN2 patch 1.11 changes. Don't equip torches automatically. 
Use of a torch can still be set with context menu. Add support for most epic spells. Don't 
unequip shield when switching from melee to ranged weapons. Fix for settings of 
weapons and shields to use (via context menu) not always followed.

V1.7, Dec 8, 2007

Prevent shield from being equipped when spellcasting if auto weapon switching is off. 
Stop restoration spells from being used on friends with enlarge cast on them. Fix problem 
with dominated creatures not fighting. Adjustments to friendly targeting and back away 
test conditions. Start adding support for spells from Kaedrin's PrC pack. Additional 
support for MotB classes and feats. Stop attacking distant foes with nearby enemies in 
melee range. Improve weapon switching and decisions in general when attacking distant 
foes. For spellcasting thresholds, use the total party strength vs. the total enemies strength 
instead of just using your strength vs. the total enemies strength. Improvements in the 
melee attack distance when any party is in melee distance behavior setting. Stop peaceful 
mode carrying over after domination and stopping the creature from attacking its 
enemies. Help stop fear spells from drawing the party apart. Add global option to have AI 
controlled warlocks use hideous blow in one round instead of two. Add party settings to 
allow more damage to be done to allies. Add global setting for monsters to damage allies 
based on alignment. Charmed creatures are ignored and not attacked by creatures of same 
faction. Charmed creatures are also now targets for cure spells. Party behavior setting 
added to allow turning off the peaceful follow mode when a follow command is issued. 
Plot creatures do not respond to shouts for help. Improvements in the use of flurry of 
blows in combination with other feats.

V1.6, Nov 6, 2007

Add support for most MotB feats and spells. Rework regeneration, power word, and 
attribute buffing code. Fixes for self targeting in various cone and cylinder spells. Fix for 
whirlwind attacks only works for the first round, later rounds the character does nothing.
Improved use of tortoise shell in combat. Fix for Tiefling darkness being continually cast. 
Rogue familiar will automatically open lock if party member fails to open the lock. 
Adjustments to improve keeping party together when the back away behavior is set. 
Tweaks in the use of darkness.

V1.5, Sept 29, 2007

Updates for NWN2 1.10 patch. A user defined set of ranged and melee weapons can be 
defined using the context menu. Add a broadcast context menu option to turn off follow 
for all non associates. A "No melee" behavior option has been added. Character will not 
go into melee combat (useful for mages and familiars along with back away). Add a flag 
that switches to melee if any member of the party is in melee combat. Special troll killing 
AI. Fixes for some spell categorizations and add support for ethereal jaunt. Reduce the 
number of power attack mode switches during combat. Have the combat mode setting 
control use of power attack. Add behavior option to disable the use of stealth during 
combat. Add party wide option to unequip weapons outside of combat. Add party wide 
option to summon familiars and to summon animal companions outside of combat.

V1.4, Aug 8, 2007

Fixed slowdowns or freezing of the game while using the AI. Targas and githyanki mage 
will now exchanging spells before the encounter. After the Targas and githyanki mage 
encounter spawns the spiders, the githyanki should leave the area. Fix short pause in 
running for AI controlled creatures when attacking a distant target. Turn undead is no 
longer cast on allies unless they are summons or the difficulty level less than hardcore. AI 
controlled creatures no longer run away from friendly persistent area of effect spells in 
normal difficulty or below. Also improved persistent area of spell detection and handling 
in general.

V1.3, July 29, 2007
For a ranged attacker (ranged weapons or spells), when attacking a creature that is not in 
line of sight that an ally is attacking, try to go behind the ally in order to prevent getting 
into melee range. Changed follow behavior to follow another companion or associate. 
Changed guard to allow guarding just one companion, and not the one the PC is currently 
controlling. The guard distance can be changed. Improve back away code to be run more 
often. Adjustments and improvements to dispel and breach casting. Send message to PC 
for every item picked up by the auto pick up routine. Slaan (at Highcliff castle) 
sometimes comes out of his normal target area. Use bull's strength on melee type 
characters during buffing even if they are currently using ranged weapons. General 
improvements to the spellcasting routines. Puppet mode turns off the infinite cast 
behavior option. "I don't know how to use this shield!" no longer message given by 
monsters. Reduce number of times main AI scripts (i.e. hench_o0_ai) is called. Add 
support for using feint, smite infidel, and sacred vengeance.

V1.2, June 24, 2007
Fix for triggered conversations not occurring in OC. Improvements to default behavior 
option selections. Reduce chance of auto buff casting the same spell twice on the same 
character. Fix for alchemical fire being used on creatures with nearby friends so they are 
getting splash damage. Added support for auras (i.e. paladin and blackguard)

V1.1, June 16, 2007
Context menu support added for healing and buffing requests to party or to one member 
of the party. Companions will continue healing or buffing while they have spells and not 
in combat. Lag when starting up moving in a direction and the time that companions and 
associates start to follow. Fixes and improvements for various spells including 
spontaneous conversions. Off-hand weapons, shields, and healing kits inside of bags are 
no longer used. Fixed weapon switching from behavior setting screen for non controlled 
character. Changed "follow me" to turn off stealth, track, etc. so that the associate can 
match speed with the PC. If PC is in stealth then stealth is not turned off. Issuing an 
attack nearest allows the companion to go back into stealth if the stealth behavior setting 
is turned on. Enable use of certain druid spells meant for only for animal companions or 
for the druid while in wildshape. Set default behavior settings for the first time in order to 
give better results without tweaking the AI. Global flag can turn this off. Add global 
settings to have enemies auto quick cast long duration spells before combat, be able to 
use equipped items, and to generate healing and buffing potions. Adjustments for changes 
in spells for patch 1.06. Commands (follow, stand your ground, guard me, and attack 
nearest) broadcast to group do not get sent to the controlled character. The flags are now 
set on the controlled character so that when control changes, the previously controlled 
character doesn't do something unexpected. Added back in the "Scout" feature. Used to 
send in summoned creatures first to soak up damage. Consider concealment in target 
selection. Weapon equipping code will use shields with appropriate ranged weapons (i.e. 
throwing axes).

V1.0, May 8, 2007
NWVault release. Change so stealth is only entered into at the start of combat if the 
creature has sneak attack. Updated documentation and created versions for module 
builders and scripters.

V0.21 (beta), Apr 22, 2007
Updated character screen for patch 1.05 changes.  Change dragon breath to be used more 
often. Change dragon breath use to be unlimited (up to every third round limit as in 
default AI). Fix damage/cure amount estimation for heal and harm. Fix assassin darkness. 
Improved use of sunbeam and sunburst.

V0.20 (alpha), Mar 28, 2007
Check the area of effect damage for firebomb. High level healers don't always cast 
healing spells. Update scripts to new associate scripts (gb_assoc_*) and other changes for 
1.05 beta. Flag that prevented hearing without line of sight or previous was not set if 
monster wander was turned off. Enabled support for more spells (enlarge, raise dead, 
resurrection, etc.), fixed issues with attribute buffs.

V0.19 (alpha), Mar 18, 2007
Fixed target selection problem for creatures with sneak attack. Fixed divide by zero error 
if target was at 0 HP. Correctly use warlock Hideous Blow. Fix companions switching to 
melee if there was a nearby enemy and their target was far away. Chance of spell touch 
attacks now considered. Correction for paladin and ranger spell casting level. Practiced 
spellcaster feats considered for spell casting level.

V0.18 (alpha), Mar 4, 2007
Restoration of associate behavior settings on summon. Fix in problems using lesser mind 
blank and mind blank. Add support for checking spell damage immunities and 
resistances. Increase stealth use threshold to one half creature's hit dice. Add support for 
elephant's hide and oaken resilience druid feats. Reduce chance of monsters opening 
doors if not attacked. Add henchman scripts back, they are still used in the OC.

V0.17 (alpha), Feb 15, 2007
If one creature in a group that is stealthing is attacked, unstealth and then attack since it is 
best to close in and attack. Musical instruments being equipped as an off hand weapon. 
Global option to reduce or eliminate use of knockdown. Turn off use of hearing unless 
target is in line of sight (reduce monsters bunching up on the other side of doors). Fix for 
firebrand, missile storm, and use of dispel to remove effects on allies. Also increased use 
of area of effect spells in general.

V0.16 (alpha), Feb 4, 2007
Fix for disarm trap not being done with the "can't do that" voice message. Fix for ranged 
weapons being used even if there is a melee attacker. Use of power attack to get around 
damage reduction. Consider damage reduction in target selection. Added behavior option 
to enable use of healing and cure potions or items even if item usage is turned off. 
Reduce incidents of creatures getting stuck and not attacking. Added support for 
checking creature item damage resistance, immunities, and vulnerabilities. Fixes for spell 
damage calculation, dismissal check and regeneration. Improve back away code.

V0.15 (alpha), Jan 28, 2007
Fixes and improvements for warlock spells. Yet another fix for buffs. Checking spell 
level immunity (globe of inv., ethereal visage, etc.) for spellcasting. Fix for running AI 
when creature is player controlled. Removed need and use creature death script 
(nw_c2_default7).

V0.14 (alpha), Jan 26, 2007
Fix for attacking unseen and unheard opponents. This includes bringing friends along to 
help out... Partial fix for offhand and shield equip switch from ranged weapons. 
Sometimes the shield or offhand weapon is equipped in the second round. The switched 
melee and ranged weapons messages are not given as often. Newly dropped items are no 
longer picked up again by the auto pickup routine. Fix for use of spells while 
polymorphed with the natural spell feat (due to 1.04 script changes). Redid buffing code 
to use area buffs more frequently and to better cast AC improving and damage reduction 
spells. Some problems fixed with checks for buffs and some adjustments made for 
NWN2 script changes.

V0.13 (alpha), Jan 11, 2007
Have all racial types but animal and beast use the default herbivore behavior. Combat 
mode use now controls disarm and knockdown. Added checks to knockdown so it is only 
used if other attacks in round have a chance of succeeding or friends are also attacking 
the same target. Some adjustments to move back code. Lower spellcasting thresholds so 
that powered and scaled casting modes should be useful. Fix stealth mode behavior not 
working. 

V0.12 (alpha), Jan 7, 2007
Change fix for Deekin to instead only have RACIAL_TYPE_ANIMAL run away since 
herbivore seems to be used elsewhere in the OC.

V0.11 (alpha), Jan 6, 2007
Fix calling of special combat scripts. Disable item pickup for non companions. Fix 
Deekin running away.

V0.10 (alpha), Jan 4, 2007
Initial release.
