### Install
* (Optional - Recommended) install [git](https://git-scm.com/download/win), then open command prompt or powershell in your NwN 2 "override" folder, and type `git clone https://github.com/vahtos/NwN2Modded.git`
* If not using git, download the .zip file https://github.com/vahtos/NwN2Modded.git, extract it to your NwN 2 "override" folder.
* Copy d2d9.dll and dxvk.conf to your game folder (C:\Program Files (x86)\GOG Galaxy\Games\NWN2 Complete)
* Copy the contents of the "override" folder to Documents\Neverwinter Nights 2\override
* Copy "dialog.TLK" to Documents\Neverwinter Nights 2

**** Start the game using override\clientextension_latest\NWLauncher.exe ****

Run the Pull_Latest.bat to update to the latest files in this repo.


### To Join Multiplayer Games

1. Go to gog.com and log in

2. Put mouse over your profile and click games

3. In the game list click NWN2, More and Serial Keys.

4. Finally, go to where you have installed NWN2 and open the app that says "SerialTool.exe" and put there the serials and save.

### To Use MetaPrep
In the game, open the console by typing ~

```
DebugMode 1
RunScript mrop
DebugMode 0
```
If you are not controlling your PC, control will be switched to your PC. This is
simply a safety measure and should help focus your attention on what comes next.
Then exit the console by typing ~

Or you can do it from the chat window.

```
##DebugMode 1
##RunScript mrop
##DebugMode 0
```

Your PC should receive a MetaRod. Then activate the Rod on anything ( your PC,
the ground, wherever ) to get things moving along. A GUI will pop up with the
setup screen if everything is progressing nicely. The only setup is chosing
whether you want re-buffing to happen Fast or As Actions. Fast means
all spell buffs are cast quickly, and As Actions means each preparation takes
a normal round to cast. If you want to change your previous setup, repeat the
console commands above.
