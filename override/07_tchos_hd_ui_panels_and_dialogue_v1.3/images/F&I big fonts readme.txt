                Fire&Ice's Big Fonts UI for Neverwinter Nights 2
                =----------------------------------------------=

Version:

        1.23

Overview:

        This mod aims to provide a better NWN2 UI experience at higher
        resolutions. By default, the NWN2 UI does not scale and
        becomes increasingly difficult for some players to read at
        resolutions of 1280x1024 and above.

        The mod increases the size of fonts in the game. Many NWN2 UI
        panels are made larger to accommodate the larger fonts.

        Please post any comments or bugs on the NWN vault page at:
        http://nwvault.ign.com/View.php?view=NWN2UI.Detail&id=65

Installation:

        If installing with the Setup .exe:

        You get the choice of which inventory to use -

            Big Bag Inventory - SoZ:           Extended inventory including SoZ 'cargo' button
            Big Bag Inventory - NWN2 or MotB:  Extended inventory with no 'cargo' button
            Normal Inventory

        If you install the SoZ inventory but are not playing SoZ, the
        cargo button won't do anything but the rest of the inventory
        will work fine.


        If you downloaded the .zip file:

        Place all XML files in the following directory in your 'My
        Documents' folder:

        My Documents\Neverwinter Nights 2\override

        Start the game as normal.

        (The expansion specific xml files ending x1.xml can be copied
        even if the expansion is not installed - in this case they
        will be safely ignored.)

        A file called 'inventoryscreenpresoz.xml' is included. This is
        the inventory without the cargo button. If you don't want the
        cargo button, delete the existing 'inventoryscreen.xml' and
        rename 'inventoryscreenpresoz.xml' to 'inventoryscreen.xml'.

Compatibility:

        NWN2 v1.22 / MotB v1.22 / SoZ v1.22 (not compatible with
        earlier patches).

        This UI mod is unlikely to be compatible with any other UI
        package, since they may both make modifications to the same
        files.

        Any of the files from this package (except fontfamily.xml) may
        be deleted without affecting the rest of the UI. Therefore, if
        you want to use a file from another package or simply dislike
        the changes in this UI, just delete the relevant file.

        The UI contains one overwritten script file
        (gui_bhvr_update.NCS).  This is used here to change the name
        of the one of the stealth behaviour options. If a mod
        overwrites this file, the stealth behaviour option will be
        truncated but there will be no other negative effects.

Known Issues:

        There may remain a few minor clipping issues on some UI panels
        (particularly multiplayer UI pages).  Please report any
        problems on the vault page.

UI Files overwritten:

        (This list includes expansion files. Even if the expansion is
        not installed, the expansion files will be installed but they
        will not do anything.)

                campaign.xml
                campaignx1.xml
                campaignx2.xml
                characterscreen.xml
                charchoice.xml
                charchoicex1.xml
                charchoicex2.xml
                chargen_abilities.xml
                chargen_abilitiesx1.xml
                chargen_abilitiesx2.xml
                chargen_bfeats.xml
                chargen_bfeatsx1.xml
                chargen_bfeatsx2.xml
                chargen_nfeats.xml
                chargen_nfeatsx1.xml
                chargen_nfeatsx2.xml
                chargen_skills.xml
                chargen_skillsx1.xml
                chargen_skillsx2.xml
                chargen_spells.xml
                chargen_spellsx1.xml
                chargen_spellsx2.xml
                container.xml
                container_recipe.xml
                creatureexamine.xml
                dmcchooser.xml
                dmccreator.xml
                examine.xml
                fontfamily.xml
                gui_bhvr_update.NCS
                internetbrowser.xml
                internetbrowserx1.xml
                internetbrowserx2.xml
                inventoryscreen.xml
                journal.xml
                lanbrowser.xml
                lanbrowserx1.xml
                lanbrowserx2.xml
                levelup_abilities.xml
                levelup_abilitiesx1.xml
                levelup_abilitiesx2.xml
                levelup_bfeats.xml
                levelup_bfeatsx1.xml
                levelup_bfeatsx2.xml
                levelup_nfeats.xml
                levelup_nfeatsx1.xml
                levelup_nfeatsx2.xml
                levelup_skills.xml
                levelup_skillsx1.xml
                levelup_skillsx2.xml
                levelup_spells.xml
                levelup_spellsx1.xml
                levelup_spellsx2.xml
                license.txt
                notes.txt
                noticewindow.xml
                nx2_market.xml
                nx2_storage.xml
                optionscreen.xml
                partybar.xml
                partychat.xml
                playerlogin.xml
                playerloginx1.xml
                playerloginx2.xml
                quickchat.xml
                spells_known.xml
                spells_memorized.xml
                store.xml
                stylesheet.xml
                target_enemy.xml
                target_object.xml


Authors:

        Tom Ford [fire&ice] (tom.ford@compsoc.net)
        [WhatIsSol]

Version history:

        1.22 (28/02/09)

        Updated to patch v1.22.
        Merged in the SoZ beta changes.
        Party bar changed to support 10 portraits.
        Removed annoying 'Game Paused' notification from SoZ.

        1.21 (17/11/08)

        Updated to patch v1.21.

        1.13b (19/10/08 - unreleased)

        Inspired by Ragnorak's Expanded Lists for Hi-Rez I have made
        the character screen and spell book screens longer

        1.13 (25/08/08)

        Updating to patch v1.13.
        Larger examine window.

        1.12 (24/03/08)

        Updating to patch v1.12.
        New version numbering to match NWN2/MotB patch.

        1.4 (12/01/08)

        Making the NWN1 chat window a little larger
        Fixes to DM Client
        Fixes to multiplayer menus

        1.3c (22/12/07)

        NWN2 v1.11 (+ hotfix) compatibility

        1.3b (06/11/07)

        Full MotB compatibility 

        1.3 (04/11/07)

        Updated to NWN2 v1.10

        Made the examine screen a little bigger

        1.2 (23/06/07)

        gui_bhvr_update.NCS script overwrite. This fixes the truncated
        stealth behaviour option (fire&ice)

        1.1 (17/06/07)

        Large number of additional UI elements resized to avoid
        clipping errors (WhatIsSol)
        
        Fixes to existing UI elements (WhatIsSol)

        Added a subtle alpha effect to the NWN1 chat window
        [remove alpha="0.80" from the bottom of quickchat.xml
        to disable this, if you don't like it] (fire&ice)

        Windows installer (fire&ice)

        1.0 (27/05/07)

        Initial release (fire&ice)

