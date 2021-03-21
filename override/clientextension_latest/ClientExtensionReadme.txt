Welcome to the Client Extension!

This program acts as a client plug-in (and, for DMs, optionally a completely
independent standalone client) whose purpose is to improve the multi-player
experience of Neverwinter Nights 2.  It fixes several client crash bugs, and
adds some useful new features.

See the "Quick Start & Overview" section for using the client extension as an
add-on to the game (recommended for most users).  See the "DM Standalone
Client" section for details on using the client extension to log on to your
server as a DM, without starting the game (advanced usage for PW admins).


Quick Start & Overview
----------------------

The Client Extension can either plug-in to the player or DM client, or it can
operate as an independent DM client.  To get started with using the Client
Extension as a player or a DM, use one of the following methods:


(a) Start the game with the included NWLauncher program (recommended).

1)  Run NWLauncher.exe and the game will start with the client extension
    already active.  You need to keep NWLauncher.exe and ClientExtension.hdl
    in the same place for the launcher to work correctly.
    
    It is recommended that you use the game in windowed mode to get the most
    out of the client extension.
                
    You may pass command line arguments to the game by providing them to
    NWLauncher.exe, e.g. by creating a shortcut.  This is useful for launching
    the game in DM mode with the -dmc option.  You can also directly connect to
    a game server at startup by using the +connect <server> argument.  See the
    "Features" section for more details on how to create a shortcut to connect
    to a game server automatically.


2)  Log on to your server as normal and play the game.


                                    - or -


(b) Apply the client extension after starting the game.

1)  (First time only.)  Double-click hdlinstall.reg to install support for .hdl
     files.  You only need to perform this step once per computer.
     
2)  Start Neverwinter Nights 2 in normal or DM client mode, and go to the main
    menu.  It is recommended that you use Neverwinter Nights 2 in windowed mode
    but this is not strictly required.
     
3)  Navigate to where you have placed ClientExtension.hdl in Explorer,
    right-click the ClientExtension.hdl file, and choose the 'Apply' option
    from the menu that appears.
    
4)  Log on to your server as normal.  You must follow steps 3-5 again each time
    you exit Neverwinter Nights 2.  Be sure to apply the extension -before- you
    log on to your server.


The AMDXP version of Neverwinter Nights 2 is not supported.  Only very old AMD
machines use the AMDXP version; recent AMD machines do not.  You will receive
an error message if you attempt to use the AMDXP version of the client.

In order to get the most out of the Client Extension, it is highly recommended
that you read the remainder of the document.  Players should read the
"Features" section; DMs are encouraged to read the entire document for details
on how to best use DM-specific features.


Avoid running Neverwinter Nights 2 in a compatibility mode (i.e. Windows XP
compatibility mode) if you plan on using the Client Extension.  It is not
necessary to run the game in compatibility mode, and doing so may prevent the
Client Extension from loading in some circumstances.


Modes of Operation
------------------

There are two basic modes of operation for the Client Extension:

- Client Extension mode, which can be used in conjuction with the game client
  as a normal player.  To use the Client Extension, simply start the game
  client as normal, then right-click ClientExtension.hdl in Explorer and choose
  the 'Apply' option.  The Client Extension is only active for a single game
  session; you must re-apply the Client Extension each time you wish to use it.
  
  The Client Extension may also be used when you are logged on as a DM, with
  the DM client.  In this mode of operation, the Client Extension can act as an
  aid to your dungeon sessions by providing a more-detailed area map.  Several
  DM-specific commands and features are also available.  See the "DM Features"
  section for more details.
  
- DM Standalone Client mode, which operates as a wholly independent client for
  DMs to log on to their servers and interact with the game world to a limited
  extent.  The usage of the DM Standalone Client is somewhat different, and is
  explained later.
  
  
Features
--------

The Client Extension includes a number of new features and bug fixes that are
designed to improve your multiplayer experience:

- A replacement for the Internet Server Browser functionality, formerly
  provided by GameSpy (official support has since been discontinued).  This
  enables players to locate other servers to join, as prior to the
  discontinuation of matchmaking services by GameSpy.

- An option to directly connect to a multiplayer game server from the command
  line.  Simply run NWLauncher.exe +connect <server> [+password <pw>] to start
  the game and directly connect to a server.  This can be used to create a
  shortcut to launch the game and connect to a particular server.  Here are
  some example command line:

  NWLauncher.exe +connect mynwn2pw.example.com
  NWLauncher.exe +connect mynwn2privatepw.example.com +password playerpassword
  NWLauncher.exe -dmc +connect mynwn2pw.example.com +password dmpassword

- Command history is now available for the client!  The client extension has a
  separate text-entry user interface which allows a history of all chat text
  that you send to be accessed.  Even text you enter in to the normal game chat
  interface is added to the command history, but you may only access the
  command history from the new text-entry user interface.  The new text-input
  user interface is described in the "Text-input User Interface" section.
  
- Larger chat messages can now be sent (up to approximately 4,096 characters).
  Please use this feature appropriately.  Long text messages do not cause any
  problems for normal clients or servers, but sending an overly long message
  may produce results that are difficult to read.  Large text messages are only
  available through the new text-input user interface.
  
  Tip:  You can also paste directly into the separate text-entry user interface
        as an option to paste chat into the game.
  
- A properly functioning reply command (/re) is now available.  This command
  supersedes the built-in reply function.  It has the following improved
  properties:
  
  - Only senders of tells (not other chat messages) are set to the reply
    target.
    
  - Sending a tell no longer sets the reply target to yourself.
  
  The /re command can be used in both the normal game interface and the
  separate text-entry user interface.
  
  When using the separate text-entry user interface, you may use /r as a
  shorthand for /re.  However, using /r in the normal game interface will
  access the old reply function that ships with the game.
  
- A re-tell function (/rt) is now available.  This command sends a tell to the
  last player you have sent a tell to.  Like all other new slash-commands, this
  command is available both through the normal game interface and through the
  separate text-entry user interface.
  
- An /invertrun function is now available.  This command switches the behavior
  for point-and-click movement, so that by default, you will walk unless you
  hold down SHIFT.  WASD movement in the game still runs unless you use SHIFT.
  
  Tip:  You can use /invertrun instead of activating Tracking Mode if you would
        like to walk by default.  You still have easy access to run mode
        without having to toggle a mode button when using /invertrun, as you
        just need to use WASD or hold down SHIFT.

- Rotating chat and combat logs are now automatically written by the Client
  Extension.  Logs are rotated once per day and named by character, with
  entries individually timestamped.  Chat and combat logs are stored under the
  "Logs" directory of your NWN2 home path, i.e.
  "Documents\Neverwinter Nights 2\Logs".  Currently, only server notices are
  written to the combat log; full combat text display is not yet available.
  
- A new area minimap is available.  You can click on a point in the new area
  minimap (not the in-game automap) in order to move to that point.  This is
  often useful if you need to cross a very large area without having to click
  many different times.  Note that if your pathing orders are too complicated,
  the game engine will discard them.  The map is further described in the
  "Area Map" section.
  
- A new form of macro-enabled hotbar buttons are available.  Macro-enabled
  hotbar buttons are created with the /setmacro command (see the documentation
  in this file for details).  Macro-enabled hotbar buttons can perfrom many
  actions per hotbar press, such as enqueuing up many buff spells all at one
  time.
  
  More details on hotbar macros are available in the "Custom Hotbar Macros"
  section.
  
- An appending log file with your chat history is available.  The log file is
  named "nwn2reportlog.log" and is written to your Neverwinter Nights 2
  installation directory.  (Windows Vista and Windows 7 users may need to click
  the "Show compatibility fixes" option in Explorer to see it.)
  
- A console interface for displaying in-game chat is now available.  This is
  often useful if you would like to minimize the game, but still keep tabs on
  what's going on (such as if you are waiting for someone to log on or send you
  a tell) without wasting a large amount of screen real-estate.  This function
  is further described in the "Console Interface" section.
  
  Tip:  You can also copy text from the console window if you enable "Quick
        Edit" in the console properties.  (Right-click the console icon and
        go to the "Properties" menu item.)  This is often useful if you want to
        copy and paste chat from the game.
  
- A crash in a third party library used for autodownloader support is avoided.
  This crash may have occured when attempting to download news information at
  the logon screen.  (The crash only occurs sporadically.)
  
- Wizards with metamagic spells on their hotbars should no longer periodically
  crash during area transitions.
  
- The client should no longer crash when the loading initial area after the
  character selection screen, when the initial area has creatures with certain
  VFX or animation parameters updating.

- Hotbar buttons should no longer occasionally flicker and fail to persist
  changes when editing them.
  
- The client now properly displays Darkvision when transitioning to a new area.

- Animations (particularly terrain scrolling while walking) no longer begin to
  stutter or "chunk up" in NWN2 after the computer has been running for several
  days since its last reboot.

- The networking code responsible for sequencing and reliability over UDP in
  the game client is replaced with more reliable code (if you apply the
  extension before logging on to a game server).  This works around several
  data corruption and data loss problems that result in some transition crashes
  during a zone transfer.
  
  Note that not all transition crashes are caused by these issues.  Also,
  because the same bugs exist in the server-end of connection, some transition
  problems will not be completely fixed unless the server is also using a
  rewritten networking subsystem.
  
  The networking subsystem rewrite does not impact compatibility with clients
  or servers that do not use the more reliable networking code, however, these
  clients and servers will not be protected from their own bugs.

- Point and click movement in the game world no longer waits for a response
  from the server before beginning to animate movement.  In some cases where
  there are dynamic path obstructions, this might result in minor path
  "glitching".  You may disable this feature by using the /mpredict command.

  Movement prediction only applies for point and click in the rendered game
  window and not point and click in the area map.  This feature improves
  perceived responsiveness with respect to movement on laggy servers.
  
- Right-clicking a name in the game's chat history and choosing the send tell
  option will now work for characters with no last name.

- You may use the /tilegrid command to toggle display of the area tile grid on
  the area map.  This is generally only useful for builders.
  
- You may use the /rendertiles command to toggle rendering of tile tints on the
  area map.  This is generally only useful for builders.
  
- DMs have additional graphical interfaces for controlling the game world, and
  are highly encouraged to read the entire readme document for details.

- Improved GUI debugging is available with the new /guidebug and /guitracing
  commands, that log detailed information about what XML GUI events are being
  raised (and with what parameters).  These two commands toggle GUI debugging
  output to the Client Extension console; enable both for maximum output, or
  just enable /guidebug for basic debug output.

  When /guitracing mode is enabled, the console will include lines similar to
  the following:

  FilterClientCallbackSetEventType: Executing NWN2_UIEVENT_DROP - self:UIData
  (int:1, int:1, int:1, int:0, objectid:0x8000039b, objectid:0x8000039b),
  callbackparams: ("self:", "objectid", 0, "local:100")

  The self:UIData () section lists the data that can be retrieved for this
  event using UIObject_Misc_ExtractData().  In this example, there are four
  ints available at int indexes 0, 1, 2, 3, and two objectids available at
  objectid indexes 0 and 1.

  The callbackparams: () section lists the arguments to the GUI XML function
  that this event is configured to run.  In this case, there was a call to the
  UIObject_Misc_ExtractData function with the four arguments listed.

Text-input User Interface
-------------------------

The program will create a free-floating text input box (called "Send message")
at startup time.  You can use this text input box to enter in commands or chat
like you would through the normal game interface.

You can enter in long messages (up to approximately 4,096 characters) through
the text input box, past the normal limit in-game.

The text input box adds a command history function that keeps track of all chat
text and commands that you send in-game or through the text input box itself.

To access this command history, hold down the CONTROL key, and press the UP or
DOWN arrow keys while the text input box is the active window.  This feature is
particularly useful if you have typed a long message, but the person you had
sent it to disconnected before they could read it.

Once you move the cursor to the start or end of the current message, UP/DOWN
arrow keys will also switch to the previous or next command, respectively.


Area Map
--------

One of the first screens that you'll notice when using the client extension is
the map window.  This window provides your view into the game world, rendered
as a top-down, 2D flat board.  Each object in the game is represented by a
small block of pixels.  Hovering the mouse over an object will display a short
description of that object.  Some description details are only available if you
are logged on with the DM client.

To view information about an object that is moving, simply hover the mouse over
the object and leave the cursor still.  The tool tip will display in a moment
without you needing to follow the object with the mouse each step of the way.

A color coding scheme is used to draw each object, so here's the legend you'll
need to understand what you are seeing:

Dark blue                             - Closed door.
Dark blue and magenta hatched         - Open or destroyed* door.
Bright green                          - Map pin with description.
Vermillion                            - Your current position.
Purple                                - Your current target.
Faint green                           - Placeable object.
Faint blue-green                      - Item.
Faint green and faint yellow hatched  - Usable* placeable object.
Faint blue                            - Environmental object.
Bright red                            - Detected hostile creature
Faint red                             - Hostile creature* (not detected)
Bright yellow                         - Detected neutral creature
Faint yellow                          - Neutral creature* (not detected)
Bright turquoise                      - Detected friendly creature
Faint turqouise                       - Friendly creature* (not detected)
Bright white                          - Player+ (other than yourself)
Faint white                           - Player* (not detected)
Pink                                  - Your currently selected player*.

*: Feature only available if you are using the DM client.
+: Only party members are shown unless you are using the DM client.


Detection criteria for non-DM players is based on the tracking skill only in
this release; only creatures that you can track on the in-game minimap will be
visible.


Additionally, certain objects are drawn as simple polygon shapes:

Blue polygon with dotted white line   - Transition trigger.
Red polygon with dotted white line    - Hostile trap (detected).
Green polygon with dotted white line  - Friendly trap.
Yellow polygon with dotted white line - Script* trigger.

*: Feature only available if you are using the DM client.


The client extension also supports showing where objects are pathing to.
Object pathing orders are drawn as a series of line segments, which correspond
to the current movement orders assigned to that object.  Note that only a few
steps ahead are pre-planned, so the final line segment may appear to cross
regions that are not walkable.  Pathing orders are reevaluated automatically at
each step of the way.

Pathing (movement) orders are drawn according to the following legend:

Bright red line dotted with white      - Hostile creature* pathing orders.
Faint red line dotted with white       - Hostile creature* (not detected) path.
Bright yellow line with dotted white   - Neutral creature* pathing orders.
Faint yellow line with dotted white    - Neutral creature* (not detected) path.
Turquoise line with dotted white       - Friendly creature* pathing orders.
Faint turqouise line with dotted white - Friendly creature* (undetected) path.
Solid bright white line                - Player+ pathing orders.
Faint bright white line                - Player* (not detected) pathing orders.
Vermillion line dotted with white      - Your pathing orders.
Pink with dotted white line            - Your currently selected player*.
Purple line dotted with white          - Your target.

*: Feature only available if you are using the DM client.
+: Only party members are shown unless you are using the DM client.


Some servers may not allow display of doors, placeables, or other objects.


The map allows you to change what objects are displayed if you only want to see
objects of a certain type.  To cycle through the drawing levels on the map, you
may press the L key while the map is the active window.  Doing so moves the
drawing level down by one, or starts over at the top if you reach the last
drawing level.  The drawing levels that are supported are:

- Self only
- Creatures* and players*
- Map pins
- Doors
- Environmental objects and placeables
- Transition triggers, traps, and script triggers
- Pathing orders
- Wireframe models (default drawing layer)
- Collision meshes
- Bones (including for creature objects -- slow!)

*: DMs automatically discover all creatures and players in the current area.


The map also allows you to choose the level of terrain drawn.  To cycle between
terrain drawing levels on the map, you may press the T key while the map is the
active window.  The terrain drawing layers that are supported are:

- None (black background)
- Walkable (black for walkable, light gray for non-walkable)
- Walkmesh (walkmesh outlines and filled walkable regions)
- Full terrain display
- Full terrain display with cross-hatched walkable region overlay
- Full terrain display with walkmesh and cross-hatched walkable region overlay

The default drawing layer is full terrain display with walkable region overlay.

If tile tint rendering is enabled with /rendertiles, then tiles are drawn with
the terrain drawing step.

Tip:  Resizing the map window works much quicker in "None" or "Walkable"
      terrain mode.


The map supports displaying a position grid; press the G key while the map is
the active window to toggle grid drawing.

You can press P to toggle display the pathing tile grid.  Fine-grained pathing
data in a baked walkmesh is calculated for each point relative to each other
point only within a pathing tile; intertile pathing uses coarse-grained path
calculations which are then stitched together to form straight lines when
possible.

You can press I to toggle directional light rendering based on the current sun
or moon position.  Directional lighting is enabled by default.


You can left-click an object or point on the map to interact with that object,
or move to that point.  The following interaction behaviors are supported:

Non-hostile creature                 - Initiate NPC dialog*.
Hostile creature                     - Attack creature.
Player                               - Follow player.
Locked door                          - Unlock door.
Closed door                          - Open door.
Open, non-transition door            - Close door.
Open, transition door                - Use transition.
Transition trigger                   - Use transition.
Usable placeable                     - Use placeable.
<Other objects or empty point>       - Move to this location.

*: Feature only available if you are using the DM client.


You can SHIFT-left-click to walk instead of run when performing one of the
above operations.

You can ALT-left-click an object on the map to request a description for that
object should you be using the DM client.  This feature is only available in DM
mode.

In standalone DM client mode, you can hover the mouse over an object on the map
to request a description for that object should you be using the DM client.
The object description is shown on in the object tool tip.  Automatic examine
on mouse hover is only performed in standalone mode in order to avoid causing
unexpected examine GUI pop-ups in the Neverwinter Nights 2 game client.

Holding down CTRL will show you what path the server will send you on from your
current location to the location that you leave the mouse over.  A green line
is drawn from your current position to mouse along the path, should there be a
legal path between those two points.  A straight red line is drawn if there is
no valid path.  This is useful for debugging AI pathing issues with your module
as it allows you to see how a creature would attempt to move to any other point
if it were standing where you were.  Only static collisions are calculated for
the proposed path (that is, the path does not consider any blocking creatures
or other dynamically created path blockers).

Proposed path display is modified by the /smoothpath option, which allows you
to see toggle display of the raw walkmesh path before optimization into
straight lines.

The path smoother generates the same rounding errors with respect to straight
line visibility as the server in order to accurately show you how your path
will be computed by the server.

Holding down X displays whether a clear line of sight (taking only base
terrain into account) exists between your position and a target position.

You can CTRL-left-click a point on the map to walk to that point even if there
is an object nearby that you would normally interact with.  If you are logged
on as a DM, CTRL-left-click will teleport you to the desired point instead of
walking.  (You must regular left-click once more to use a transition.)

You can right-click a point on the map to target that object, if it is an
object that may be targetted.

You can CTRL-right-click a creature object to take control of it if you have DM
privileges.  Simply use CTRL-right-click on an empty map region to return
control to the DM PC.

You can left click and drag the mouse to create a selection rectangle.  Release
the mouse to select all actable creature objects in the selection rectangle.
Should you hold down SHIFT while creating the drag selection, all encompassed
objects are appended to your existing selection instead of replacing the prior
selection entirely.  (The selection rectangle is outlined in bright green.)

You can define selection groups in the map window by holding CTRL down and
pressing a number key (0-9).  Press the same number key without CTRL held to
recall a previously set selection group, selecting it in-game.

If you are logged on as a DM, a shorthand function is provided to allow you to
quickly position creatures in your game field.  You may middle-click a point on
the map to move your targetted creature to that point without having to possess
and unpossess the creature in separate steps.  The creature will walk or run
based on on your walk/run setting as with left-clicking.

Similarly, if you are logged on as a DM, you may CTRL-middle-click to teleport
your selection to an area.  This can even be used to teleport objects that
resided within a different area to a specific point in your current area.

When using CTRL-middle-click, if you have no selected objects, then the list
of selected players in the player list window is assumed.  This is useful if
you wish to jump multiple PCs to a new area at a specific point via point and
click on the map; you would jump to the new area, make a selection in the
player list window (multiple players may be selected), and then use the
CTRL-middle-click function to pull those players into your area.

If you are logged on as a DM, you can ALT-middle-click to force your current
selection to attack another creature.  This can be combined with multiple
selection to force many creatures to attack another creature (i.e. a player in
a battle scenario).

You may CTRL-right-click an object to possess it if you are logged on as a DM.
Similarly, you may then CTRL-right-click on empty ground to unpossess your
possessed object.


While the map is the active window, you can also move using the WASD keys.
It is generally recommended to use point-and-click movement instead.  The WASD
movement keys are:

W - Move forwards.  The distance moved depends on your movement rate.
S - Move backwards.  The distance moved depends on your movement rate.
A - Turn left by 18 degrees.
D - Turn right by 18 degrees.

There is no direct indication as to your current heading, although it is
remembered.

You may hold down SHIFT to walk instead of run when using WASD mode.


The map is unable to display what regions are walkable or not.  You will need
to know this based on the objects displayed and your knowledge of the area's
layout.  Attempting to move to a non-walkable location will result in your
movement order being canceled.


You may press the escape key (ESC) to cancel all orders in your order queue
while the map window is active.


Objects are drawn as updating along their current paths smoothly based on their
walk or run characteristics.  This can be disabled with the /clientpath text
command.  Disabling smooth client pathing significantly reduces CPU consumption
spent redrawing the map window.


Area Map Camera Modes and Camera Control
----------------------------------------

The area map supports multiple camera types, which may be cycled through via
the use of the 'C' key while the map window is active.  The following camera
modes are available:

- 2D top-down mode (the default), which is most like a traditional minimap.
  All object control functions are available in 2D top-down mode.
- 3D tactical mode, which renders the game world in a 3D perspective view, with
  a camera under full control of the user.  Currently, group selections are not
  available in 3D tactical mode.  By default, the camera in 3D tactical mode is
  positioned looking down on the area.
- 3D chase mode, which is a 3D perspective view that follows your character in
  a third person view.
  
3D camera modes are experimental and are not intended for performance operation
at this time.

While in a 3D camera mode, pressing 'R' once resets the camera to its default
parameters.  In 3D tactical mode, pressing 'R' a second time will set the
camera so that is roughly located at your character's location, looking in
the direction of your character's facing.

In 3D camera modes, the following control functions area available to orient
and move the camera:

- Scrolling the mouse wheel zooms the camera with respect to its look-at axis.
- Holding the right mouse button down and moving the mouse will rotate (turn)
  the camera.
- Holding the right mouse button down and scrolling the mouse wheel will roll
  the camera.

The map window is rendered entirely in software via GDI, without any hardware
assistance.  As a result, 3D camera modes are intended for static viewing and
not a general purpose, real-time updated interactive 3D display.

A diagnostics readout at the top left of the map window displays the current
camera parameters.




DM Area Teleport Chooser Window
-------------------------------

If you are logged on as a DM, a "DM Area Teleport Chooser" window will be
displayed.  The area chooser window is similar to the map window, but it lets
you choose which area is rendered.

The area chooser window has a drop-down box at the bottom which lets you choose
the name of the area you would like to view.  You must have previously visited
an area to display it; this is a technical limitation of the game protocol.

Unlike the map window, the area chooser window only allows you one possible
action, which is to left-click a point on the map.  Left-clicking teleports
your current selection (which may include multiple creatures or players, or may
even include yourself) to the point you clicked.  This is useful for precision
group teleports to another area, without having to zone to that area first.

If you left-click a point on the map and you have no selection, your character
is teleported alone.  This is useful as a flexible area teleport jump across
your game world, as an adjunct to the existing DM Chooser jump functionality.

Creatures are, by default, not shown on the area chooser window, and the area
chooser window does not update in real time for performance reasons.

You can add two scripts to your server to allow the DM Area Teleport Chooser
window to show creatures (including players) in the area chooser window, when
viewing areas other than your current area.  This feature lets you keep tabs on
what's happening in your PW, without leaving your current area.

Sample scripts to support the DM Area Teleport Chooser's creature viewing
functionality are included (gui_scliext_dm_pollarea, gui_scliext_identify).


Console Interface
-----------------

The program creates a console (text-mode) window for displaying output text to
you outside of the normal rendered game scene.  This window can be observed
even if you minimize the normal game window; it may also be resized or moved
at will.

You cannot enter text directly into the console window; instead, you must use
the normal game interface or the separate text-entry interface.

Player chat and player join/leave events are displayed to the console window,
along with various status miscellaneous pieces of information.


Player List Window
------------------

If you are logged on as a DM, a "Player List Scry" window will be shown.  This
window lists which players are logged on to the server and whether they are
present in the same area as you or not.

There are several columns in the player list window:

Column   Description
--------------------

"Name"   Indicates the player's character name.

"Area"   Indicates the area tag of the player, if known.  This information is
         not always available.  If the area tag is truncated due to being too
         long, then the full area tag name can be seen in the player details
         box by clicking on the player's list box entry 

"cHP"    Indicates the current hit points of the player.

"mHP"    Indicates the maximum hit points of the player.

"Lv"     Indicates the player's character level, if known.  This information is
         not always available.

"AC"     Indicates the player's armor class, if known.  This information is not
         always available.

"A"      Indicates whether the player is in the current area or not.  If the
         player is in the current area, the row reads "A".  This feature works
         similar to how a player is shown as in the current area or not in the
         full Neverwinter Nights 2 client player list screen.
         
"DM"     Indicates if the player is logged on as a DM.  If so, then the text
         "DM" appears in the row.
         
         
     
You may select a player in the player list to display additional debugging
interface about that player.  This debugging information is usually only useful
for script debugging.  (The player's account name is also displayed in the
extra information section.)

Selecting a player in the player list highlights the player as pink in the area
map window.  This selection is separate from your in-game selection.

Double-clicking a player in the player list will pull up an Examine dialog in
the game for that player.  This will also select that player in-game for the
next operation, such as /export.

Control-double-clicking a player in the player list will prepopulate the text
input window with a tell command for that player and set the keyboard focus to
the text input window.

By default, the player list window will automatically update.  You may turn
this function off with the "/scry off" command.  Disabling automatic scry
updates is recommended if your server has not yet upgraded to xp_bugfix
1.0.5 or later with ReplaceNetLayer = 1 set.


DM Features
----------

When you apply the extension in DM client mode, additional features that are
designed to improve your ability to act as a dungeon master are activated.

Operating in DM mode greatly increases the amount of information that is
displayed to you in the area map window.  The "Area Map" section covers this
information.

DMs have access to the DM Scry window described above, as well as the DM Area
Teleport Chooser window, also as described above.

While in DM mode, several new command are available for your use.  These
commands may be accessed from either the in-game interface, or the standalone
text-input interface:

/export            - Exports the currently selected creature object to your
                     local vault.  This may be used on other players, or even
                     on non-player creatures.
                     
/saverules         - This command is used to prepare for the DM Standalone
                     Client; its usage is described in the
                     "DM Standalone Client" section.

                     Note that /saverules is generally not needed unless you do
                     not have a full game install.
                     

DM Standalone Client
--------------------

The DM Standalone Client is a completely separate, standalone client for
Neverwinter Nights 2.  It can be used instead of the conventional DM client,
for purposes of aiding your work as a dungeon master.  With the DM Standalone
Client, all of the functionality that the Client Extension exposes in DM mode
is you to use; that is, you may walk around and interact with doors,
placeables, transitions, as well as enter chat commands and receive chat from
players.

To use the DM Standalone Client, you need to install the Visual C++ runtime
update as described in step (b)(2) of the "Quick Start & Overview" section.


Other DM functionality is only available when using the DM client itself.  The
DM Standalone Client is intended as a lightweight replacement client which does
not have the system requirements of the conventional DM client.  In fact, you
could even log on two sessions, one with the player client, and one with the DM
Assistant Client simultaneously to the same server; however, both sessions will
need unique accounts and legal CD-Keys.

If you have scriptable DM functionality available via chat commands or creature
dialogs, this functionality can be accessed from the DM Standalone Client.

Like the conventional DM client, the DM Standalone Client still requires that
you have a valid Neverwinter Nights 2 CD-Key.  The system will consider your
CD-Keys in use for the duration of your session, regardless of whether you are
logged on with the player client, DM client, or DM Standalone Client.


DM Standalone Client Setup (Game Installation Present)
------------------------------------------------------

If the computer that you are running the DM Standalone Client on already has a
game installation with all expansions installed, then you need take no further
steps.  Simply launch NWStandaloneClient.exe and you should be ready to go.

The "DM Standalone Client - Logging On" section describes next steps to log on
to your game world.


DM Standalone Client Setup (Game Not Installed)
-----------------------------------------------

NOTE:  If you have a full install of the game on your computer, then you do not
need to follow these steps.

Because the DM Standalone Client operates in a completely independent fashion
from the conventional client, it requires an additonal preparatory step in
order to assess which client data files are needed in order to connect to your
server.

To perform this one-time preparatory step, you must launch the DM client, apply
the Client Extension in DM mode, and log in to your server as a DM.  Then, use
the "/saverules" command to save a limited set of client data files that are
required to connect to your server.  This command saves the required data to
your <Documents>\Neverwinter Nights 2\ModuleRules\<Module Resource Name> path
for the current module.

This step need only be performed once, unless you make a change to the
visualeffects.2da or baseitems.2da files, or if you create additional classes
or skills.  In such a case, you must re-run the preparatory "/saverule" step
once more in order to capture the current data files contents.  Otherwise, you
may experience erratic behavior with the DM Standalone Client.

The DM Standalone Client uses the walkmesh files (*.trx) downloaded from the
client's autodownloader to display the area map.  However, the DM Standalone
Client cannot download updated file automatically, so you will need to download
them by logging in to the game with the full Neverwinter Nights 2 client.  The
DM Standalone Client will automatically use the walkmesh files once the
autodownloader in the full Neverwinter Nights 2 client has updated them.


The DM Standalone Client will attempt to use your installation CD-Keys and your
saved community account credentials.  If either your installation CD-Keys or
saved community account credentials cannot be automatically discovered, then
you will have to set them manually.  See the "DM Standalone Client Commands"
section for more information on how to manually configure your credentials.


DM Standalone Client - Logging On
---------------------------------

After you have performed the initial set-up steps for the DM Standalone Client,
you're ready to log on.  To begin, simply run the "NWStandaloneClient.exe" file
in Explorer (double-clicking it will suffice).  This will bring up an interface
similar to that which you would see when using the Client Extension in DM mode,
however, it does not plug-in to the normal game client.  Instead, it acts as a
seperate client, operating entirely on its own (with minimal memory usage).

To connect to a server, use the /connectpw <hostname[:port]> <DM password>
command.  If your server's DM password has a space in it, you should instead 
use the /setserverpassword <DM password> command, followed by the
/connect <hostname[:port]> command.

An error message will appear in the console screen if there was an error when
connecting.  Otherwise, you should be presented with a character selection
prompt in the console; use the /pickcharfile <DM Vault Character .BIC File>
command to select a character to log on with.  For example, you might use
/pickcharfile char.bic.  (You may also supply a full path name if the character
file is located somewhere else besides your DM vault.)

Tip:  You can save time by putting connection commands like the /connectpw
or /logoncharfile commands in the autorun command file; see the section
"Automatic Command Sending" for more details.


DM Standalone Client Commands
-----------------------------

The following command are available in the DM Standalone Client:


/connectpw <hostname[:port]> <DM password>     - Connects to a server, possibly
                                                 disconnecting from the current
                                                 server.  The supplied DM
                                                 password must not contain
                                                 spaces.  The hostname may
                                                 optionally include a port
                                                 number for the server data
                                                 port if the default of 5121 is
                                                 not in use.
                                                 
/connect <hostname[:port]>                     - Operates as /connectpw, but
                                                 with the server password set
                                                 via the /setserverpassword
                                                 command.
                                                 
/setserverpassword <DM password>               - Sets the server DM password to
                                                 use with /connect; spaces are
                                                 permitted.

/setaccountname <community account name>       - Sets your community account
                                                 name, only required if the
                                                 DM Standalone Client could not
                                                 automatically detect your
                                                 account information from your
                                                 nwn2player.ini file.
                                                 
/setaccountpassword <account passworrd>        - Sets your community account
                                                 password, only required if the
                                                 DM Standalone Client could not
                                                 automatically detect your
                                                 account information from your
                                                 nwn2player.ini file.
                                                 
/addcdkey <CD-Key>                             - Adds a CD-Key to the list of
                                                 CD-Keys to authenticate.  One
                                                 key is required per expansion
                                                 pack that your server uses.
                                                 
                                                 The first invocation sets the
                                                 original game's CD-Key, the
                                                 next sets the XP1 CD-Key, and
                                                 so-forth.
                                                 
                                                 The CD-Key must be given in
                                                 EXACTLY the same format as it
                                                 resides in nwncdkey.ini.
                                                 
/setexpansions <expansion bitmask>             - Sets the bitmask of present
                                                 expansion packs.  0 for none,
                                                 or 0x1 for XP1, 0x2 for XP2,
                                                 0x3 for XP1 and XP2, etc.
                                                 Defaults to 0x3 (XP1 + XP2).
                                                 
/nocdkeys                                      - Clears any existing, partially
                                                 entered CD-Key data that was
                                                 set via the /addcdkey command.
                                                 
                                                 You must enter in the
                                                 appropriate CD-Keys before the
                                                 connection attempt will work.
                                                 
/readini                                       - Attempts to discover your
                                                 CD-Keys and community account
                                                 credentials from the game's
                                                 INI files.  You generally do
                                                 not need to use this command
                                                 as this step is automatically
                                                 attempted at startup time.
                                                 
/logoncharfile <DM Vault Character .BIC File>  - Supplies the file name for a
                                                 character present in your DM
                                                 vault that you would like to
                                                 log on to the game iwth.
                                                 
/pickcharfile <Full .BIC File Path>            - Chooses a character file to
                                                 log on with manually at the
                                                 appropriate step in the log in
                                                 process, versus automatically
                                                 logging in.  Use this command
                                                 only if prompted to do so by
                                                 the DM Standalone Client.
                                                 
/export                                        - Exports the currently selected
                                                 player's character file.  You
                                                 must double click a player in
                                                 the player list first before
                                                 using this command.

/dialog <Dialog Choice Number>                 - Chooses a response from an
                                                 active dialog; the response
                                                 number must be the same as
                                                 shown in the response list.
                                                 
                                                 This is an experimental
                                                 command, use with caution.
                                                 
                                                 You may also use the command
                                                 "/dialog escape" to exit the
                                                 dialog with the default escape
                                                 action.
                                                 
/combatlog                                     - Toggles display of combat-
                                                 related events to the console.
                                                 
                                                 By default, these events are
                                                 displayed.
                                                 
/reconnect                                     - Reconnects to the server that
                                                 you had last connected to.
                                                 
/autoreconnect                                 - Toggles automatic reconnect
                                                 for connection timeouts or the
                                                 server shutting down.  The
                                                 standalone client will try to
                                                 reconnect every 10 seconds
                                                 when this mode is enabled.

/disconnect                                    - Disconnects from the current
                                                 server.
                                                 
/item                                          - Lists the items that you have
                                                 on your person.
                                                 
/item <Item Name or Hex Item Object ID>        - Uses a 'Unique Power' item on
                                                 your current selection, else
                                                 yourself for 'self-only'
                                                 'Unique Powers'.

/equip <Item Name or Hex Item Object ID>       - Equips an item on your person.

/cast "Spell Name" [Metamagic1[,Metamagic2]    - Casts a spell, optionally with
                                                 a list of metamagic names,
                                                 such as "extend", "maximize",
                                                 and so forth.  The spell name
                                                 must be enclosed in quotes if
                                                 metamagic is in use; otherwise
                                                 quotes are optional.
                                                 
                                                 If specifying a combination of
                                                 metamagic types, separate the
                                                 types with commas.
                                                 
                                                 For more details, see the
                                                 "Casting Spells from Macros"
                                                 section.
 
/memorize <Slot> "Spell" [Metamagic][|Class]   - Memorizes a spell at a given
                                                 spell slot (the spell level is
                                                 computed automatically based
                                                 on the spell given and the
                                                 metamagic applied).  Specify
                                                 metamagic(s) in the same way
                                                 as with the /cast command.

                                                 Optionally, a class name can
                                                 be specified.  This is useful
                                                 should multiple classes in a
                                                 multiclass character can cast
                                                 and memorize the same spell.

                                                 If no class name is given,
                                                 then the first class that
                                                 meets the requirements for the
                                                 given spell is used for the
                                                 memorization.

                                                 Spell slots are numbered from
                                                 0 (the top and leftmost slot
                                                 for a given spell level).

/spells                                        - Prints information about known
                                                 and memorized spells.

/feats                                         - Prints information about
                                                 feats.

/talent <Talent Name>                          - Uses a talent (spell-like
                                                 ability).  This command is
                                                 generally only useful for
                                                 DMs that are possessing a
                                                 creature.

/feat <Feat Name>                              - Uses an activateable feat.
                                                 This command is useful for
                                                 activating feats via macros.

                                                 The currently selected target
                                                 is used if the feat requires
                                                 an explicit target object.

/hotbar <Button Number>                        - Activates a hotbar button on
                                                 your current selection.
                                                 Button 1  = row 1, button 1
                                                 Button 13 = row 2, button 1,
                                                 etc.
                                                 
/setmacro <Button Number> <Commands>           - Define a custom macro command
                                                 set to run when you press a
                                                 hotbar button.  More than one
                                                 command may be supplied,
                                                 delimited by semicolon
                                                 characters.  You may use the
                                                 /hotbar command, or any other
                                                 text commands (or even just
                                                 plain chat) from the macro
                                                 command list.

/cancelpolymorph                               - Cancels an active polymorph.

/rest                                          - Activates the rest function.

/areas                                         - List all known areas (only
                                                 static template areas are
                                                 listed).
                                                 
/dmjump <Area>                                 - Jumps the control object to an
                                                 area (by name, tag, or raw hex
                                                 object id).
                                                 
/dmjumpplayer <Account name>                   - Jumps to a location nearby a
                                                 player given their account
                                                 name.
                                                 
/dmjumpsel <Area>                              - Jumps all selected creatures
                                                 to an area (by name, tag, or
                                                 raw hex object id).  The
                                                 objects arrive at (0, 0).
                                                 
/dmjumpall <Area>                              - Jumps all players to an area
                                                 (by name, tag, or raw hex
                                                 object id).  The objects
                                                 arrive at (0, 0).

/t "Character Name" Message                    - Send a tell.

/tp "Player Name" Message                      - Send a tell (by account name).

/o "Character First Name" Message              - Send a tell (by first name of
                                                 a character).
                                                 
/r Message    -or-    /re Message              - Reply to a previous tell.

/rt Message                                    - Send a tell to the last person
                                                 that you sent a tell to.  This
                                                 is useful if several persons
                                                 send you a tell while you are
                                                 holding a conversation.
                                                 
/s Message                                     - Shout a 'message'.

/l Message                                     - Send 'message' as a normal
                                                 volume talk.
                                                 
/w Message                                     - Send 'message' as a whisper.

/p Message                                     - Send 'message' to your party
                                                 members, and all DMs.
                                                 
/dm Message                                    - Send 'message' to all DMs.

/invertrun                                     - Changes the behavior for point
                                                 and click movement to walk by
                                                 default unless SHIFT is held.
                                                 
/modes                                         - List your active modes, such
                                                 as stealth or detect.
                                                 
/stealth                                       - Toggles the stealth mode, if
                                                 it is supported for your
                                                 character.

/resname <Module Resource Name>                - Overrides the default module
                                                 resource name.  This command
                                                 is generally only useful when
                                                 attaching the client extension
                                                 to an already running game
                                                 client instance without
                                                 logging out first.
                                                 
/replyinvite <accept|reject|ignore>            - Responds to a prior party
                                                 invitation.
                                                 
/invite <Character Name>                       - Invites a character to join
                                                 the party.
                                                 
/leaveparty                                    - Depart the current party.
                                                 
/partyleader <Character Name>                  - Make another player the party
                                                 leader.

/removeparty <Character Name>                  - Remove a party member.

/scry [on|off]                                 - Refreshes the player list scry
                                                 window with current area data,
                                                 or disables or re-enables
                                                 automatic updating of area
                                                 data.  It is recommended that
                                                 automatic area updates only be
                                                 used on servers with the
                                                 xp_bugfix ReplaceNetLayer = 1
                                                 fix enabled due to the data
                                                 volume sent.
                                                 
/clientpath                                    - Toggles client-side pathing
                                                 prediction on or off for game
                                                 world objects.  Disabling the
                                                 client-side path predictor
                                                 will cause objects to only
                                                 update positions in the map
                                                 when new pathing orders are
                                                 recalculated.

/smoothpath                                    - Toggles smooth pathing for
                                                 proposed paths (when you hold
                                                 control down in the map window
                                                 and see a path line).
                                                 
/windowstats                                   - Displays internal networking
                                                 counters and statistics.

/tilegrid                                      - Toggles display of the map
                                                 tile grid.

/rendertiles                                   - Toggles rendering of tile tint
                                                 contents for indoor areas.

/polydraw <x1 y1 x2 y2 ... xN yN>              - Draws a series of line
                                                 segments on the map window.
                                                 Coordinates are expressed in
                                                 game units.

/raydraw <o.x o.y o.z d.x d.y d.z>             - Draws a portion of a ray,
                                                 given an origin and a ray
                                                 direction (in game units).
                                                 This is primarily used to
                                                 debug the rendering system.

/moveto <x> <y>                                - Attempts to walk to a specific
                                                 coordinate set.

/calcpath <x1> <y1> <x2> <y2>                  - Calculates a path between two
                                                 points and prints the result
                                                 to the console.

/pathto <x> <y>                                - Calculates a path between your
                                                 current position and another
                                                 point in the same area.

/time                                          - Displays the current game
                                                 world time.

/settime <hour> [minute] [second] [millisec]   - Advances server time as per
                                                 the behavior of the SetTime
                                                 nwscript function (no server
                                                 scripts are required).  If you
                                                 omit any arguments after hour,
                                                 they are defaulted to zero.

/showui                                        - Re-opens all client extension
                                                 UI windows that you've closed,
                                                 such as the map window.

/kill                                          - Uses DM powers to kill your
                                                 current selection.

/heal                                          - Uses DM powers to heal and
                                                 resurrect your current
                                                 selection.

/getres <restype> <resref>                     - Unpacks a module resource from
                                                 the module or its HAK files.

/help [command]                                - Provides online help about a
                                                 text command or lists all text
                                                 commands if no arguments were
                                                 supplied.

/pickupitem                                    - Picks up an item from the
                                                 ground were it the selected
                                                 item.

/lootitem <item name>                          - Loots an item from the open
                                                 item container.

/lootall                                       - Loots all items from the open
                                                 item container.

/takeitem                                      - Moves an item directly to your
                                                 repository using DM powers.
                                                 The selected item is used.

/dumpobject                                    - Use DM powers to display
                                                 various trivia about an
                                                 object.

/direct2d                                      - Toggles Direct2D acceleration
                                                 on or off (requires Vista+).

/nomodels                                      - Enables or disables model
                                                 loading (speeds area loading,
                                                 but disables wireframe view in
                                                 the area map).

/perftrace                                     - Enables logging of client
                                                 message processing performance
                                                 characteristics.  This tracing
                                                 only functions in Client
                                                 Extension mode, and only when
                                                 using the replacement network
                                                 layer (which is the default).

/showfps                                       - Toggles display of nwn2main's
                                                 FPS counter (no DM privileges
                                                 are required).

/logfps                                        - Toggles timestamped logging of
                                                 nwn2main's FPS counter to the
                                                 Client Extension log file.

/fswindow                                      - Toggles fullscreen windowed
                                                 mode, which covers the monitor
                                                 but does not engage fullscreen
                                                 input capture.

/tts                                           - Toggles text to speech support
                                                 for logon and logoff events,
                                                 and in-game chatter.

/ttsfilter [.NET regular expression match]     - Set a .NET regular expression
                                                 filter that voice events must
                                                 match in text to speech mode
                                                 for voice playback to be sent.

                                                 If used without arguments, any
                                                 filter is removed.

/testregex [text]                              - Tests a regex match assigned
                                                 by /ttsfilter against a text
                                                 string.

/away [response message]                       - Sets away mode, or toggles it
                                                 off if no argument is supplied
                                                 and away mode is already on.

                                                 When enabled, an automatic
                                                 tell ("response message") is
                                                 sent to any incoming tell, one
                                                 time per sender.  Away mode is
                                                 automatically cancelled when a
                                                 message is sent or the player
                                                 moves.

                                                 A summary of received tells
                                                 during away mode is shown when
                                                 away mode ends.

/camerapitch [degrees]                         - Sets a new default maximum
                                                 camera pitch for the
                                                 Exploration Mode camera view.
                                                 90 degrees is the game default
                                                 and 179 degrees is the default
                                                 for Character Mode.  The 
                                                 Client Extension default is
                                                 179 degrees.  Valid values
                                                 must be between [90, 179].

/freecam                                       - Enables free camera mode, for
                                                 DM privileged users.  Switch
                                                 to another camera mode to
                                                 cancel free camera mode.  Use
                                                 the arrow keys and scroll
                                                 wheel to navigate in free
                                                 camera mode.

/fadeobjects                                   - Toggles object fade for all
                                                 camera modes.  The setting is
                                                 not persisted to disk.  Use
                                                 /fadeobjects again to return
                                                 to the configured settings for
                                                 the active camera mode.

/console <console-cmd> [console-cmd-params]    - Runs a server-side console
                                                 command.


If a text line does not begin with a /, then it is sent as a normal volume talk
message.


Regular Expressions
-------------------

.NET regular expressions are used for the text to speech filter.  Documentation
for the regular expression language can be found at the following Microsoft web
site:

http://msdn.microsoft.com/en-us/library/az24scfc(v=vs.110).aspx


Automatic Command Sending
-------------------------

Although the DM Standalone Client does not have a dedicated configuration file,
it will read commands (one per line) from two files on the disk at certain
points in time.  These command can configure the DM Standalone Client's
settings, such as the default DM logon character file.

The DM Standalone Client will read the
<Documents>\Neverwinter Nights 2\autocmds.txt file at startup time (where the
<Documents> variable indicates your My Documents (or Documents on Windows Vista
or later) folder.  Once the DM Standalone Client has joined the game world, it
will read the <Documents>\Neverwinter Nights 2\autocmds_ingame.txt file.  Both
files have identical formats.

Should a particular autorun command file not exist, the autorun phase is
simply silently skipped.


Saved Window Positions
----------------------

The client extension remembers how you positioned its windows for the next time
that you log on.  There is one set of settings used in client extension mode,
and another used if you log on with the DM Standalone Client.

Window settings are recorded in the registry at the following location:

HKEY_CURRENT_USER\SOFTWARE\Valhalla Legends\ClientExtension\Settings

There is generally no need to directly edit the saved settings.


Casting Spells from Macros
--------------------------

The /cast command (usable both outside and inside of macros) allows you to cast
a spell by name.

When naming a spell, you should use the spell's full display name.  For spells
with sub-spells (for example, Protection from Alignment), it is usually best to
cast the specific sub-spell you want.  (Many such spells will either do nothing
or take a default behavior that you might not like when casting the main spell
directly.)

For example, if you wanted to cast Protection from Alignment's Protectiom from
Evil sub-spell, you could use the following command:

/cast Protection from Evil

Spells can also be given metamagic modifiers as a comma-separated list.  The
following are the metamagic modifier names that are accepted:

empower
extend
maximize
quicken
silent
still
persistent
permanent

You must have the appropriate feats and spell levels or readied spell
memorizations available to successfully cast a spell.  Otherwise, the spell
casting attempt fails.

The /cast command always uses your current target, unless the spell in question
can only be cast on yourself, in which cast your character is automatically
used as the target.

It is currently not possible to cast spells on the ground with /cast.

Similarly to spells, the /feat <Feat-Name> command can be used to invoke a feat
from a macro.  Only feats that are activateable may be referenced via this
command.  For example, to activate the Racial Spell (Light) feat, one might use
the following command:

/feat Racial Spell (Light)

Subradial feat selection is not currently supported.


Custom Hotbar Macros
--------------------

Custom macro hotbar buttons are a new feature that the Client Extension adds to
the game.  Macros allow you to assign a set of text commands that run when you
press a hotbar button.

This feature is particularly useful when you have a large number of repetitive
actions that you would like to consolidate into just one keypress.  For a
familiar example, you could create a single hotbar button that, when pressed,
would activate all of a Cleric's, or Wizard's buff spells.

To create a hotbar macro button, use the /setmacro command as follows:

/setmacro <hotbar button number> <command1>[;command2;commandN]

"Hotbar button number" indicates the hotbar button which will be turned into a
macro-enabled hotbar button.  Button 1 is the first hotbar button, on row 1.
Button 13 is the first hotbar button on row 2, and buttom 15 is the third
hotbar button on row 2, and so on.

After the hotbar button number, you may provide a list of text commands that
are processed when the hotbar button is pressed.  If you would like to run more
than one text command, separate the commands with a semicolon.

Any Client Extension text command, and any text command supported by the game
client itself may be used in a macro.  You may also macro up simple chat text,
if desired.

The most common use of macro hotbar buttons is to cast several spells in
succession.  There are two ways to do this: by spell name, and by referencing a
different hotbar button.



Tutorial: Creating a hotbar button to cast several buffs at once via casting
          spells by name.
----------------------------------------------------------------------------
          
Let's say that you want to have a single hotbar button which casts several
offensive spells, all in one go.  (The spells would be enqueued up to be cast
one after another, just as if you hit two hotbar buttons separately.)

For this example, we will create a hotbar button which casts a quickened
version of Isaac's Lesser Missle Storm, followed by Flame Arrow.

This task can be easily automated by creating a hotbar button that casts both
of these spells.  We will use the /cast macro command, which looks up a spell
by name, and casts it on your current target.

We can construct a sequence of /cast commands that will cast the spells that we
want as follows:

/cast "Isaac's Lesser Missile Storm" quicken
/cast Flame Arrow

The first spell casts the lesser missle storm spell, with the "quicken"
metamagic property.  If you wanted to add other metamagic properties to a
spell, you could specify them in a comma-separated list.

For instance, to cast a silent and still Magic Missle spell, you would use the
following command:

/cast "Magic Missile" still, silent

Now, back to our example.  We can create a hotbar button that will run both of
the above macro commands with the /setmacro command.  Here, we will assign the
macro to hotbar button 1, which is the first button on the first hotbar row.

/setmacro 1 /cast "Isaac's Lesser Missile Storm" quicken ; /cast Flame Arrow

That's all there is to it.  Now, the next time you press that hotbar button,
all of the spells you have listed in the macro will be cast.



Tutorial: Creating a hotbar button to cast several buffs at once via hotbar
          buttons.
---------------------------------------------------------------------------

Let's consider that you want to cast several buff spells with one hotbar
button.  This task can be easily accomplished with the /setmacro command.

First, you must place the spells that you would like to cast on their own
hotbar slots.  We'll use hotbar buttons 2, 3, and 4 for this example, so drag
the spells that you would like to cast onto those buttons (first hotbar row).

Now, for this example, we will turn the first hotbar button into a macro-
enabled button which will use buttons 2, 3, and 4.  After you have set up those
three hotbar buttons, type the following command:

/setmacro 1 /hotbar 2 ; /hotbar 3 ; /hotbar 4

If everything worked out, you should see a couple of messages written to your
combat log, along the lines of "Configuring macro command: /hotbar 2".  You
should also have a new hotbar button which has a "2D Missing Texture" icon in
the button 1 slot.  (Don't worry about the missing texture; the button will
still work fine.)

That's it; you're done!  Now, the next time you press the first hotbar button
on row 1, the actions that you have assigned to buttons 2-4 will be carried
out.

Tip:  If you have buff spells that can buff an ally, select that ally before
      you push the macro-enabled hotbar button.  Macros will use your currently
      selected target for their spell targets, for spells that may target a
      creature other than yourself.


Accessing possessed creature abilities as a Dungeon Master
----------------------------------------------------------

You can use special abilities of possessed creatures with the /talent command.

This command only works for intrinsic creature special abilities, such as
Dragon Breath.

When you possess a creature, your hotbar will be populated with grayed spell
buttons for each creature special ability.  While you cannot use the grayed
buttons directly, you may hover the mouse over them to discover the ability
names.  The ability name can then be used with /talent.

For example this command:

/talent Dragon Breath, Fire

...will use the fire-breathing ability of a Red Dragon.

You may use /talent in hotbar macro buttons, or you may simply type it out on
the text input line directly if you prefer.  The same targetting rule as for
/cast apply to /talent.


Launching the Client Extension from the Toolset (Advanced)
----------------------------------------------------------

You can configure the toolset to launch the game with the Client Extension and
not the standard game client.  This step is only recommended for advanced users
that are comfortable with changing their game install.

1) Go to the game installation directory and rename nwn2main.exe to
   nwn2main_override.exe.

2) Copy NWLauncher.exe into the game installation directory, and rename it to
   nwn2main.exe.

To undo this setting, you will have to manually rename back the original
version of nwn2main.exe.


Online Services
---------------

This release of the Client Extension includes connectivity to a third-party
online service operated by the creator of the Client Extension program,
Skywing.  The following describes the online service functionality and any data
collected.

* Master Server Listing:  A master server listing of known NWN2 game servers is
  queried by the Client Extension via a web service API.  This powers the
  Internet Server Browser functionality in the game, now that GameSpy support
  has been discontinued.

* Master Server Population:  When connecting to a server not known to the
  master server listing, the Client Extension requests that the master server
  infrastructure add the server in question to the master list, so that other
  players may join the server.  This broadens coverage of known servers in the
  Internet Server Browser, as not all servers have been upgraded to participate
  in the master server infrastructure project.  The only information passed to
  the online services functionality is the IP address and port number of the
  game server to add to the master server listing.  This functionality is not
  used to correlate or track activity by Client Extension users.  A server that
  has been listed by this mechanism will be visible to other Client Extension
  users, and other clients of the online services API, but no information about
  the user that requested the listing is retained; this information is purely
  used for public server listing and matchmaking purposes.

* Auto Update Functionality:  When started, the Client Extension will attempt
  to discover whether new software updates for the NWN2 Client Extension
  software are available.  If an update is available, the user is prompted to
  decide whether to install the update or continue without installing the
  update.  All software updates are digitally signed.  In addition, the auto
  update functionality provides a description of the update to the user, and
  can provide a "Message of the Day" to the user used to provide notification
  of important community news.  All auto update functionality notifications
  take the form of a clearly marked message box at the main screen in the game
  client, and the user is never required to install an update if they elect not
  to.

* Diagnostics Statistics:  Aggregate counters of selected events, listed below,
  are recorded by means of the online services connectivity.  These counters
  are used only to diagnose and identify problems with software updates and are
  not used to track or identify users.  Information about the individual user
  that incremented a diagnostics counter is not retained; only an aggregate
  numeric counter value of events across all Client Extension users is
  maintained.

  Counters:  Failed Software Update, Successful Software Update, Manual
             Installed Software Update.

* Data Collection and Privacy Policy:  No personally identifying information is
  retained by any of the third party online services hosted by Skywing that the
  Client Extension maintains connectivity to.  IP addresses may be temporarily
  retained in the form of standard web server request logs, but these are not
  used to attempt to identify, contact, or track the activity of Client
  Extension users.  Web server request logs are not shared with external
  parties.

* Online Services Source Code:  The source code for the online services
  functionality used by the Client Extension can be located at the following
  web URL:  https://github.com/SkywingvL/nwn2dev-public

* Online Services Communication Endpoint:  The online services functionality
  supported by the NWN2 Client Extension involves an HTTP connection to
  api.mst.valhallalegends.com and the exchange of standard SOAP messages.  The
  source code for the online services functionality is available at the above
  URL.

Acknowledgements
----------------

Grinning Fool, for assistance with area decoding and portions of the game
object update message decoding.

Obsidian, for working to provide debug symbols for the Neverwinter Nights 2
client and server.  This has proven by far the most positive interaction with
a game developer that I've had to date, something that should be considered a
model for other game developers to emulate.

Brian Meyer, for bearing with several test builds and providing extensive
test work and valuable feedback.

Tero Kivinen <kivinen@iki.fi>, for decoding portions of the walkmesh on-disk
format.

KEMO, for bearing with me for extensive testing of DM cross-area creature
viewing and other assistance with debugging the server-side GUI scripts
involved.

tazpn, for releasing the source code to his Neverwinter Nights 2 model import
and export tool, from which information on the game's bone system was derived.

Numerous beta testers for providing feedback, catching issues, and suggesting
new features.
