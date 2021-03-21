Description:

	Expands all of the "high-use during normal play" NWN2 pop-up windows to
	have longer lists more suited for higher resolution displays (at least
	960 pixels vertical).
	
	This mod contains nothing but modified XML files, no scripts or new images.
	(easy install, and easier to just use what you want)

Compatibility:

	NWN2 Version 1.05

Installation:

	Place all XML files in the following directory:

	C:\Documents and Settings\(User Name)\My Documents\Neverwinter Nights 2\ui\custom

	Start the game.





OTHER STUFF (YOU DON'T NEED TO READ IF YOU DON'T CARE)
------------------------------------------------------------------------------------

	
Complex Installation:

	If you have other mods, and/or want to set it up differently, this excellent site
	(you should bookmark if you haven't)
	
	http://www.nwn2wiki.org/Installation_directories
	
	has more info on different methods of installing UI mods, and lots of other info.
	(Although, it's UI mod stuff may be out of date as of this writing, for NWN2 v1.05.)

Files in This Mod:

	characterscreen.xml
	container.xml          (visually modified, in addition to expanded)
	examine.xml            
	journal.xml
	quickchat.xml          (visually modified, in addition to expanded)
	spells_known.xml
	spells_memorized.xml
	store.xml
	
	Just load the ones you want, or load them all.
	
Additional Notes:

	The theme of this mod is mostly just to expand the existing lists vertically, not
	make other modifications to the visual layout of the windows from the game, many
	of which I think are already pretty good.  This mod doesn't get as in-depth with
	visual modifications (and extra files) as something like Charlies (excellent) UI mod.
	
	I took the most time with modifying the quick chat window (you use to talk to NPCs).
	Since reading NPC dialogue is an important part of this game (and rewarding, due
	to the great writing) I wanted a visually nice window that was more pleasing to
	read than the tiny thing you get by default in higher resolutions.
	
	But it's all a matter of taste, you might look at the screenshot and see an
	unmitigated visual disaster, in which case I wouldn't load the quickchat.xml :-)
	
	The loot window is a thinner width than cyricc's version (credited below).  For
	very long item names, they will not appear unless you mouse over them.  Having
	said that, at least 99%	of the stuff you find will fit just fine.
	
	LOOT WINDOW NOTE:
	
	As with cyricc's loot window mod, this one has the same issue.  You want it longer
	for your magic bags, but *all other* container windows will use this longer list too.
	If you find this mod's length too annoying for those other times, you can compromise
	and lower the length a bit for a tradeoff.  Edit all the lines in container.xml (that
	have a big '**** EDIT HEIGHT/Y= HERE ***' marker over them.  Subtract an even 200
	off of all abnormally large 'y=...' or 'height=...' attributes.  (You can do this
	while still	in the game.  ALT-TAB to the desktop, edit and save the file, then
	ALT-TAB back into the game and go through a door to another area and your changes
	will show up.)

Credits:

	Loot Window was modified originally from:
		Expanded Loot Window (for Magic Bags) mod, by cyricc
	Quick Chat was modified originally from:
		[D.T.E.] Better QuickChat UI mod, by [D.T.E.] LuCif3r
		
	Thanks to these two authors for getting me started/pointed in the right direction
	by using their modified files as a starting point to making my own edits.
