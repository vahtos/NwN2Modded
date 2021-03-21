Readme - Light Emitter in Spell Effects

Author: K2
Author website: http://www.hardfought.org

v1.0 - January 19th, 2007

===================================

This VFX pack modifies certain spells within the game, allowing them to emit actual light as opposed to a non-light emitting glow effect. I always found it odd that several types of spells that you would think would emit light (like a fireball spell, or lightning, or magic missle, etc) do not. This VFX pack is my attempt to correct that, and in a manner that has the least performance impact, while preserving a realistic look to suit the spell effect modified.

None of the lights added to any spell effect is set to cast shadows.

How this VFX pack works:

I used the Visual Effects Editor plugin that came with the NWN2 toolset. All I am doing, is opening up a corresponding spells .sef file (sp_wall_of_fire.sef for example), and adding a light event to the special effect package. You can edit these modified .sef files as you see fit should you decide that you'd like to change the color of a particular light, or its intensity, etc.

To install:

Unzip the contents of this zip file into your ..\My Documents\Neverwinter Nights 2\override folder - make sure that 'use folder names' is checked so that the folder structure is preserved, otherwise the game may not parse all files correctly. So, once installed, the file paths should look something like this...

..\My Documents\Neverwinter Nights 2\override\NWN2_VFX\SP_Evocation\sp_fireball.sef

I also discovered while making these modifications that the corresponding particle effects, billboard, and other effects files had to be included with the .sef files that went with them, otherwise the total spell effect would be incomplete. So be sure to preserve every file included with this VFX pack.

NOTICE - for spells that only emit a single light (read: almost all of them), the performance hit incurred will be hardly noticeable if at all. For spells that emit multiple lights at the same time for an extended duration (read: Wall of Fire), the performace hit will be noticeable. If you have a system that isn't very fast, and you're having performance issues with a particular spell, just delete the .sef file that is assigned to that spell along with any other pfx/bbx/tfx files that belong to it - issue resolved.


Spells adjusted to emit light with this VFX pack:

Flare
Burning Hands
Combust
Firebrand
Fireburst (normal/greater)
Fireball
Flame Arrow
Delayed Blast Fireball
Wall of Fire
Shroud of Flame
Incediary Cloud
Meteor Swarm

Plus any other spells that call any .sef files found in ..\NWN2_VFX\FX_Generic\Fire (conjuration/casting mode more than likely, not the actual spell itself).

I will definitely be adding more spells from ALL spell-casting classes as time allows.

Current discussion about this VFX pack can be found here - http://nwn2forums.bioware.com/forums/viewtopic.html?topic=675528&forum=109 (old thread - http://nwn2forums.bioware.com/forums/viewtopic.html?topic=543515&forum=115)


History
==================
v1.10 - May 4th, 2009

Modified fx_enlarge_person_hit.sef to give off light that is consistient with the rest of the Transmutation line of spell casting. A light will be included with the visual effect at the end of spell casting when transforming your PC/NPC (enlarge, polymorph self, etc).

Modified fx_paralyze.sef to give off a low intensity/low range light. This comes into play when a PC/NPC/Monster is grappled or held (Bigby line of spells, evard's black tentacles, chilling tentacles, other various hold-type spells).

The spell Wall of Fire and the Warlock Invocation Wall of Perilous Flame have been altered so that they each display only one light emitter for the entire spell/invocation, instead of an emitter for each section of flame effect. This change will significantly improve performance for all users of this pack when these spells are cast, as the old method would spawn several light emitters for each spell cast. The scripts altered are nw_s0_wallfire and nw_s0_iwallflam. VFX files added are sp_wall_fire_light.sef and sp_peril_flame_light.sef. BUG - the only downside to this change is that if the spell/invocation ends earlier than what is defined by nDuration, the light emitter will remain while the rest of the spell vfx disappear. In other words, if you dispel the spell or est, the wall of flame will fade out but the light for it will remain until nDuration for that spell runs out. Letting the spell/invocation run its course naturally without any interuption avoids this behavior. If this behavior bothers you to the point that you would rather not have the light effect for these at all, just rename/delete the above-mentioned .sef files.

Warlock invocation 'Eldritch Cone' series - these invocation effects are now cast correctly from the PC/NPC/Monsters right hand instead of their chest.

Modified the Warlock invocation Chilling Tentacles so that the light emitted is not so intense, and now gives of low-intensity shadows.

Modified Waukeen's Light so that it now gives of shadows.

Modified Red and Black Dragon's breath (again) so that the light emitted is now more intense (from 2.0 to 2.5).

Unless any glaring bugs or issues are found, this will be the final installment to this pack for the 1.x series. Further updated will be specific to MotB and SoZ and will be versions 2.x and 3.x accordingly.
 

v1.09b - April 19th, 2009

Modified x2_s0_magcweap and x2_s0_grmagweap scripts so that the spells Magic Weapon and Greater Magic Weapon now have a visual effect assigned to them. This a quick n' dirty work-around - the original file that each script calls for a visual effect (fx_defaultitem_magic.sef) is missing. I can recreate it, but the scripts in their current form assigns the effect to the casters BODY, not the weapon. So for right now I am using an existing effect that's easy to call - when cast, the weapon affected by each spell will look charged with electrical energy and cast off a small bit of light. As per the spells, on a successful hit, MAGICAL damage is applied, not electrical.

Once I figure out how to make the visual work as I'd like, I'll create a custom visual effect, and have an actual replacement for the missing fx_defaultitem_magic.sef file.

v1.09a - December 6th, 2008

Modified nw_s0_conecold script so that it uses the proper spell effect during casting. End state - Cone of Cold spell is cast from your hand as intended, and Winter Wolf breath comes from its mouth.

This *should be* the last version for NWN2 only (without MoTB/SoZ).

v1.09 - November 12th, 2008

Fixed the following spells so that they cast from the casters hand as intended:

Magic Missle
Color Spray
Prismatic Spray
Isaac's Missile Storm (Lesser/Greater)
Burning Hands
Cone of Cold
Scintillating Sphere
Gedlee's Electric Loop
Melf's Acid Arrow
Flame Arrow
Flare

Before, the spell effect for each of these spells would appear to come from the casters torso or face, instead of their hand, even when the animation would emphasize being cast from the hand (the spell description would also state being cast from the hand). Some of the changes are subtle, while others are more pronounced.

Also, Red and Black Dragon's breath attack has had it's light intensity doubled. They're dragons, dammit.


v1.08 - February 27th, 2007

This version is somewhat of a major overhaul of this entire spell effects pack. Shadow-casting properties have been added to almost every single light emitter included with their related spell. The notable exceptions to that are Wall of Fire, Perilous Flame, and Chilling Tentacles - the first two, when cast, spawn 5-6 copies of itself at once. That means 5-6 light emitters, all of which are casting shadows - it looks bad, plus it's just too great of a performance hit. Chilling Tentacles, it just looked bad no matter where I placed the light source, however the tentacles themselves will cast shadows from other light sources nearby.

If you play with shadows on, but the spell lighting effects when casting shadows just seems to be too much of a performance drain, you can disable 'point light shadows' under the advanced graphics setting under options - this will still allow environmental shadows while disabling the shadows cast by the light emitters in this spell VFX pack.

At first I had stated that I was going to make two seperate VFX packs - one with and one without shadows. However, the prospect of having to maintain *two* VFX packs of this size is a much greater time investment than maintaining just one VFX pack. Besides, if you have a system fast enough to play with shadows enabled anyways, you should be able to reap the benefits of having the spell light emitters cast off shadows as well.

Other significant changes:

The spells 'Gate' and 'Wail of the Banshee' have been included.
Several positional emitter errors were found and corrected.
Elemental weapons now cast light from all over the weapon, rather than just from the hilt.


v1.07 - February 6th, 2007

Added light emitters to various creature effects that warrant them, such as dragon breath (both red and black), hellhound and winter wolf breath attack, fire and bombadier beetles attacks, lich/succubus eyes, balor/pit fiend fiery effects, tweaks to the will o' wisp, etc.

Added light emitters to the following spells that weren't already covered under their basic class-type component:

Bigby line of spells
Storm rage
Bless
Prayer
Implosion
Prismatic Spray/Ray
Color Spray
Shades (summoning and targeted only)
Destruction
Finger of death
Creepy Doom
Bane
Divine Favor
Swamp Lung
Cocoon
Drown
Aid


v1.06 - January 28th, 2007

Illusion-based, Inflict-based, Necromancy-based, and Transmutation-based spells now have light emitters attached to their spell effects (see notes for 1.05).

Other spells/effects added:

Summon Creature (all levels)
Any weapon that has a negative magic effect (template based off of Evil-based spells)


v1.05 - January 27th, 2007

Evil-based, Abjuration-based, Conjuration-based, Divination-based, Enchantment-based, and Cure-based spells now have light emitters attached to their spell effects (this doesnt mean that any specific spell has had an emitter added, but if it falls under the above-mention class, then light will be seen during the conjuration/casting phase). This affects a significant amount of spells in the game.

All darkness type spells are considered 'evil' - the light emitters attached to this line of spells is subtle... a dark blood-red color that isnt too intense. The light emitters are there to signify that that type of spell is being cast, that's all. So when you cast the AoE spell 'Darkness', it will give off an evil red aura for a couple seconds as the spell goes into effect; afterwards all PC/NPC/creatures affected by the spell will be blind as usual. If you believe this effect is counter-productive to the spell description, just rename/erase all the files found under ..\NWN2_VFX\FX_Generic\Evil.

Other spells that have been added or tweaked:

Rebuke Undead
Resurrection
Body of the Sun
Storm of Vengeance

Body of the Sun already had an emitter attached to it - I tweaked it to make the effect more prominent. Storm of Vengeance also had an emitter attached, but has been tweaked as well to not be so intense, and shadow casting by the emitter has been disabled to prevent any performance loss.

Removed a few duplicate files from ..\NWN2_VFX\SP_Conjuration

This VFX pack is now available in HAK and ERF format for builders who wish to incorporate this VFX pack into their modules.


v1.04 - January 25th, 2007

This update is known as the 'Warlock Patch' - every Eldritch-based invocation effect has been modified to emit light, with a color appropriate to the invocations particle effects. Exceptions - if the invocation is a buff (read: Retributive Invisibility, etc), light is only emitted during the casting/conjuration phase.

Spells (Invocations) added:

Beguiling influence
Beshadowed blast
Bewitching blast
Brimstone blast
Charm
Chilling tentacles
Curse of despair
Dark foresight
Dark one's own luck
Darkness
Devil's sight
Devour magic
Draining blast
Eldritch blast
Eldritch chain
Eldritch cone
Eldritch doom
Eldritch spear
Entropic warding
Flee the scene
Frightful blast
Hellrime blast
Hideous blow
Leaps and bounds
Noxious blast
Retributive Invisibility
See the unseen
Tenacious plague
The dead walk
Utterdark blast
Vitriolic blast
Voracious dispelling
Walk unseen
Wall of perilous flame
Word of changing

Plus any other spells/invocations that call on the generic eldritch vfx template.

Also fixed a positional error with light emitters on cone-based spells.

 

v1.03 - January 21st, 2007

Mordenkainen's Sword has been modified with the visual effect like an ice blade, and casts light as such (I tried several different effects, but ones that were already made for weapons work best). I also increased the size of Mordenkainen's sword by 50%. ONLY the visual properties of this spell have been altered, nothing else - it still acts as a mid-level fighter (w/ construct properties) wielding a +3 longsword. If you do not wish to use this VFX modification for Mordenkainen's Sword, simply rename/delete c_msword.utc and nw_wswmls0120.uti from your root override directory.

Spells added:

Mordenkainen's Sword (see above)
Magic Missle
Isaac's Missile Storm (Lesser/Greater)
Moonbeam
Bombardment
Crumble
Quillfire

Plus every spell that is Evocation-based... the list is too great for me to type it out here. As of this version, every spell that calls for sp_evocation_*.sef will exhibit lighting effects while conjuring, casting, and any ray/aoe effects from said spells. I studied the particle effects for this class, and have made the lighting effects for Evocation somewhat subdued, staying in line with the particle effects shown.

Turning Undead now exhibits holy lighting effects at all stages, from conjuration/casting to impact upon undead creatures.


v1.02 - January 21st, 2007

Modified magic weapons that have a visible effect (Stonefire Greataxe +2, Icy Blade, etc) to cast light appropriate to the magical damage given. The radius is small (not much greater than a normal torch), however the light intensity is default. I may tweak this in a future release. Current magic weapon types affected - fire/ice/acid/lightning/holy-based. Also note, a side effect of modifying spells to give off light on a target impact, is that magic weapons that do magical elemental damage call the same effects... killing two birds with one stone it seems.

Spells added:

Searing Light
Sunbeam
Hammer of the Gods
Ray of Frost
Ice Storm
Cone of Cold
Polar Ray


v1.01 - January 20th, 2007

Cleaned up the light effect on impact for Fireball
Fixed light emitter not being present on Shroud of Flame burn duration effect

Spells added:

Acid Splash
Shocking Grasp
Gedlee's Electric Loop
Melf's Acid Arrow
Lightning Bolt
Mestil's Acid Breath
Scintillating Sphere
Vitriolic Sphere
Acid Fog
Chain Lightning
Call Lightning
Firestorm
Flame Strike


v1.00 - January 19th, 2007

Initial release