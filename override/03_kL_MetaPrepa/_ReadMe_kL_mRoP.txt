===============================================================================

MetaPrepa
MetaRod of Preparations ( MRoP )
v.beta.97a
2020 mar 14


-------------------------------------------------------------------------------
Editor:
kevL's, a variant of Lost Creation's Rod of Preparation

Contact:
https://neverwintervault.org/

Webpages:
https://neverwintervault.org/project/nwn2/script/metaprepa

The MetaRod of Preparations, or MetaPrepa, allows PC and Companions to quickly
and consistently recast spell buffs as well as refresh Bardic Inspirations.


-------------------------------------------------------------------------------
Credits:

MetaPrepa is a variant of the Rod of Preparation by Matt McMahon (aka "Lost
Creation") which can be found on the Vault:

https://neverwintervault.org/project/nwn2/other/gui/rod-preparation


The RoP is a complete rewrite of Loudent's Rod of Full Party Buffing which can
be found here on the Vault:

https://neverwintervault.org/project/nwn2/prefab/item/rod-full-party-buffing


Arkalezth of the BSN boards, the Don Quixote who offered insightful feedback
that broadened the scope and generally urged the tone of this project.


Sky FM radio - Mostly Classical
http://www.sky.fm/classical ( before it went pseudo-commercial )


-------------------------------------------------------------------------------
How it works:

If you're familiar with LC's Rod of Preparation, there are three major
differences.

1. The primary purpose of this Rod, the MetaPrepa rod, is to implement
metamagics on buffing spells. It does this by using a spellhook, while
attempting to respect modules that are designed with a spellhook already in
place. ( See the hook script for further information. )

2. To do that, the MetaRod has two modes of operation - Learn and Play modes.
Both are activated by double-clicking the Rod and activating it on itself. First
up is Learn mode; this searches through a list of spells when a party member
casts a spell, and if the buff is found ( or if it's one of the 7 Bardic
Inspirations ) a Page of Preparation is added to a Book of Preparations on the
caster of that buff. This lets the spellhook capture the metamagic type, as well
as other things, and write it as a variable on the preparation. Play mode then
needs to be activated for regular play and re-buffing after resting. If you
forget to switch from Learn to Play modes it should not break anything, but
there might be a few more preparations in your Books than you want. Watch for
messages that are intended as reminders of which mode your Rod is in ...

3. Feats work differently because technically they do not use a spellhook. They
also are not always 'spells' at all. Feats have ... issues. So far the only
feats that are allowed to be prepared are the 7 Bardic Inspirations. This
required adding the spellhooking code to those 7 scripts ( included ). The
Stormlord weapon feats, as well as Summon Companion and Summon Familiar, have
been additionally added since. The latter two scripts are also included.

Further, spellscripts are included to cover buffs that are cast on items in
characters' inventories - armor, shields, and weapons basically. I did this so
that items which have received buffs do not need to be passed back to a caster
when re-buffing with the Rod.

Kaedrin's 1.41.4 PrC Pack functions were used where applicable. All spellscripts
included have been tidied and recompiled, so if you have issues with any of them
talk to me, or fix them yourself. Since I find Kaedrin's material slightly
overpowered I backed off a couple of Massive Critical properties etc by a notch.

no, I don't want to keep two versions of spells. nyah!


-------------------------------------------------------------------------------
Installation:

Unzip the MetaPrepa to your MyDocs->NwN2->override folder. MAKE SURE THAT FILES
ARE NOT DUPLICATED IN THE OVERRIDE FOLDER! This means searching for duplicate
spellscripts + Inspirations, then rename, back up, or remove them. If you have
Kaedrin's PrC Pack or any other spell fixes pack, you will very likely have
duplicates kicking around.

The core MRoP files do not conflict with previous Rod of Preparation files.


Uninstallation:

Remove the MetaPrepa folder from MyDocs->NwN2->override. Revert all spellscripts
and Inspiration scripts that you had backed up.


-------------------------------------------------------------------------------
Setup:

In the game, open the console by typing

`
DebugMode 1

then enter,

RunScript mrop

If you are not controlling your PC, control will be switched to your PC. This is
simply a safety measure and should help focus your attention on what comes next.
Then exit the console by typing

DebugMode 0
`

Or you can do it from the chat window.

##DebugMode 1
##RunScript mrop
##DebugMode 0


Your PC should receive a MetaRod. Then activate the Rod on anything ( your PC,
the ground, wherever ) to get things moving along. A GUI will pop up with the
setup screen if everything is progressing nicely. The only setup is chosing
whether you want re-buffing to happen Fast or As Actions. Fast means
all spell buffs are cast quickly, and As Actions means each preparation takes
a normal round to cast. If you want to change your previous setup, repeat the
console commands above.

Congratulationz!!! the MetaPrepaRoP is installed!


-------------------------------------------------------------------------------
Usage:

Activate the Rod on itself
- switches between Learn and Play modes. Learn allows buffs ( and Bardic
Inspirations!! &tc. ) to be turned into preparations, Pages in the Book of
Preparations that get created on each caster that prepares ( casts ) a buff from
the list of ID's in the spellhook script. Pages of Preparation are created
only for buffs cast on PC faction members or their equipment. When done,
re-activate the Rod on itself to switch to Play mode. Adventure as usual ...
and after a rest - or whenever you like really -

Activate the Rod on anything except itself
( but not on a Book of Preparations ) - this causes the buffing sequence to
begin, whether Fast or As Actions. Spells that are not memorized will
merely be skipped, as will buffs that were cast on targets that are no longer
available. If a character still has effects from a previous buffing, the buffs
should refresh ( rather than be skipped ).

Activate the Rod on a Book of Preparations
- this brings up a GUI asking if you wish to destroy the Book and all its Pages
& contents. A confirmation is required if you then want to destroy the Book.

Activate a Page of Preparation on itself:
- brings up a GUI asking if you wish to destroy the Page. A confirmation request
is not given.


note: Anyone in the party can carry and activate the MetaRod.


-------------------------------------------------------------------------------
Tips:

Pages at the top of the Book get cast first .....

Pages can be taken out of the Book and put back in at your discretion. Only
Pages that are in a Book will be cast during the buffing routine.

Pages of Preparation can be added one ( or several ) at a time to a Book by
entering Learn mode, casting the buff(s), then returning to Play mode.

Bardic Inspirations that are prepared have special considerations. A bard can
have only one Inspiration active, but you will find that the Rod allows up to
all 7 to be prepared as Pages. My advice is to prepare two or three Inspirations
that you like to use as your standard Bard defaults, then take them out of your
Book and swap in only the one that you want to go with for a while. If you
change your mind later, just swap in a different one ( without having to enter
Learn mode ).

If a Page of Preparation is examined, you should see a lot of arcana there -
that is for debugging and, well ... arcana lore. It has occult significance ...!

A Book of Preparations is cursed and cannot be gotten rid of except by
activating the Rod on it and chosing to destroy it. Pages however can be passed
around freely, although if you put one into the Book of a caster to which it
does not belong and your cat happens to scratch your eye out as a result, I am
not responsible. Thanks!

The MetaRod is not meant for combat. It cannot be placed into Learn mode when
a member of the party is in combat. You can do the buffing routine while combat
is near, but the Rod will cast spells As Actions even if Fast was chosen
during setup.

Do not store anything in the Books apart from Pages of Preparation. ( I don't
know why, exactly, it just sounds good to get that out of the way. )

Druidic Spontaneous Conversion is not supported. The Bardic Inspirations will
work Fast if you chose Fast during setup. Other feats should not work
at all ( as of v.beta.7 ). As of v.beta.8, the Animal Companion and Summon
Familiar feats have been added - they require the special scripts that are
included, just like the Bardic Inspiration scripts ( and buff-on-item scripts ).
As of v.beta.92, fixed a bad bug that kept Animal Companions at low level iff
Kaedrin's PrC Pack wasn't installed correctly. dam animals ...

MetaPrepa ought work with or without the kPrC Pack!!! Note: Cyphre's Companions
are also supported.

Spells that are cast from subradial menus need to use 'cheat casting' by the
Rod, as such they will be cast at CL 10 and will have "(10)" on their Pages'
descriptions.

Spells that were granted to a character by Cleric Domain powers are also
problematic. Since, like subradial spells mentioned above, they are not fully
registered as known by the caster these must also be cheat-cast at CL 10. Their
Pages of Preparation will not have "(10)" in the description, because the method
of determining which casts come from Domain granted powers is not absolute. I
believe the underlying issue is hard-coded.

The MetaRop has added code to spellscripts that cast buffs on items. This allows
items such as armor, shields, and weapons to be buffed in the caster's
inventory during Learn mode and then passed to other characters, where they
will be targetted directly for rebuffing during regular Play mode. Again, the
method used is not foolproof: it depends on (a) the caster, (b) the name of the
item, and (c) the spell. When an idea occurs that would make this more solid, it
should be done.

Finally, spells that are cast on the ground will never be prepared. All
preparations need a targetted object to maintain integrity. Usually this means
that if you try to prepare a summons such as Planar Ally or Summon Creature, the
file Spells.2da ( and Feat.2da ) have to be configured to cast the spell or
perform the feat on an object, which ought then allow a Page to be written in a
Book of Preparation. In addition, don't expect to prepare a summons and then
buff it during the buffing routine: the target will be invalid since it hasn't
been summoned yet. If you want to buff your summons you need to have it out
already, or call it before engaging the buffing routine ....


nb. There is a maximum number of spells that can be lined up on the Action
Queue. It's about 20.


-------------------------------------------------------------------------------
Bug Reports requested:

If you notice any spell buffs that MetaPrepa does not prepare, feel free to tell
me about them.

If you notice any spell buffs that were cast on items ( armor, shields,
weapons ) that do not get correctly re-applied, please let me know about these.

If you have a favorite Feat that you would like to see implemented, I'll
look into it - no guarantee though.

And anything else that goes the wrong direction, after you've ruled out as many
possibilities as you can on your end. Tks!

Players will and have noticed that numerous spell descriptions do not match
their actual use in NwN2; this is because descriptions are in a file called
Dialog.Tlk while spell usage is handled by Spells.2da and the spellscripts. It
is far beyond the purview of the MetaPrepa to address those inconsistencies, but
there it is.


-------------------------------------------------------------------------------
A Note About 2DAs:

The .2da files that come with Lost Creation's Rod of Preparation are not used
by the MetaRod. Instead, Spells.2da is used and Feats are handled partly as
spells.

Of particular interest in Spells.2da are the columns: MetaMagic, TargetType,
ImpactScript, and FeatID; also Name and SpellDesc.


-------------------------------------------------------------------------------
File Manifest:

blueprints:
mrop_rod.uti
mrop_book.uti
mrop_page.uti

scripts:
mrop.nss/ncs ( setup )

mrop_inc.nss ( #include )
mrop_inc_preps.nss ( #include )
mrop_inc_gui.nss ( #include )

mrop_spellhook.nss/ncs ( spellhook )

i_mrop_rod_ac.nss/ncs ( activate rod )
i_mrop_page_ac.nss/ncs ( activate page )

gui_mrop_ok.nss/ncs ( gui accept )
gui_mrop_cancel.nss/ncs ( gui cancel )

mrop_debug.nss/ncs ( debug vars )

spellscripts ( nss/ncs )
7 inspirations ( nss/ncs )

nw_s2_animalcom.nss/ncs ( Animal Companion )
nw_s2_familiar.nss/ncs ( Familiar )
mrop_cmi_animcom ( #include for Animal Companions )


+ a few ReadMe's scattered about ... and as of ver.beta.96 ->

mrop_bardic_inc.nss ( #include for Bardic Inspirations )
mrop_items_inc.nss ( #include for Item buffs )

mrop_setdelay.nss/ncs ( console-script for changing the fast-cast delay )


-------------------------------------------------------------------------------
Spellhooking:

If a module author has already implemented a spellhook script, the MetaRod will
do its best to switch back and forth between that script and the MRoP spellhook.
Messages ought appear in the chat window to the effect that spellhooking is
already enabled and that the module's author should be contacted, or at least
that the two scripts should be merged ( see the MRoP spellhook script
'mrop_spellhook' for detailed info ).

Wild Magic works in conjunction with the spellhook and will switch back and
forth as appropriate. The spellhook and Wild Magic need to be enabled during
Learn mode only. Play mode operates with neither.


Finally, NwN2-style tag-based scripting has to be enabled by the module author
for the MetaPrepa to work in that module.
