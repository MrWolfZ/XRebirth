Author: MadJoker 
Version: V0.4.3 Beta
Date: 25th Dec 2013

X Rebirth version: 1.21

http://xrebirth.nexusmods.com/mods/278/

=== About ===

Ever wondered why capital ships were just sitting idly while being bombarded by enemies? Ever were angry that your 
followers were being destroyed in distant sectors while you had long changed positions?

If you can answer these questions with 'yes', then this mod is for you. I proudly present:

UFO - Ultimate Fleet Overhaul

This mod is a complete rewrite from scratch for the escort and capital ship combat scripts.

UFO does not replace MCE. In fact, UFO is meant to complement MCE. With UFO, you can assign a fleet to a single ship,
and then via MCE give orders to that ship. So by giving one order with MCE you are controlling your whole fleet.

However, note that the MCE commands are not using the UFO scripts yet. If you add a ship to your squad or give it any 
MCE order, it will stop running the UFO scripts. To fix that just re-assign the ship to a commander once it's order 
is complete.

Also, this mod activates the UFO defence officer script in 'Defensive' mode for all player owned capital ships on game
load, if they are not running a UFO script yet. The script also gets activated when you assign a defence officer to
work on a ship. This is basically what CSE (Combat System Extension) did, but instead of using the stock combat scripts,
it uses the UFO scripts.

=== Details ===

This mod adds fleet creation commands to the main menu that allow to build hierarchies of ships. To create a fleet
simply go to MAINMENU/2/4/1, choose a commander and then choose one or more subordinates, and done, it is that simple.

Since version V0.2.0 it is now possible to assign "stances" to your fleet. Go to MAINMENU/2/4/3 and you will have the
possibilty to tell fleet commanders that their subordinates should be following the commander in a certain stance (for
a list see below). The commanders will then broadcast that stance to all of their subordinates (and their subordinates, 
and so on...). The stance will also affect the commander itself, but only if the commander is following another commander,
or is currently executing a fleet command. That means you can create sub-fleets and broadcast stances only to those 
fleets by creating a hierachy of commanders. Then you can for example broadcast an "Offensive" stance to all capital 
ships, and a "Follow" stance to all traders.

Since version V0.3.0 it is also possible to set a stance on a single NPC. To do that, comm that NPC (for defence 
officers go to the property menu, and use "CO" for the ship or go to ship details, click the defence officer, go 
"Details", then "Comm". When setting stances directly for NPCs you only get three choices (Offensive, Defensive, 
Follow). For pilots and captains this determines whether they should fly towards enemies as soon as spotted, only when 
attacked, or not at all. For defence officers it determines when they will open fire.

Also since version V0.3.0 you can get an overview of all active stances by going to MAINMENU/2/4/4. You will get a
report that shows each NPC in your fleet and their current orders. Please note that for this report to work, you have
to re-assign a stance to each of your ships in case you were using this mod in versions prior to V0.3.0.

The most basic functionality of this mod is to just assign a ship to the Skunk (the Skunk is an Class S ship) and it 
will follow you and engage enemies based on the selected stance. It will then not be part of your squad in terms of 
that game mechanic (since that simply screws with the AI), so you won't see "In my squad" on the property monitor. But 
it will still behave correctly.

One example how I test UFO is that I spawn some capital ships and fighters for me and assign all of them to the Skunk. 
Then I spawn some enemy capitals and fighters near me, and done. The rest happens on its own.

Another thing of note is, that you can create sub-fleets and broadcast orders only to those fleets by creating a 
hierachy of commanders. Then you can for example broadcast an "Offensive" order to all capital ships, and a "Follow" 
order to all traders.

Should your fleet detect some enemies, it will send you a real-time status report with details about your fleet, the
enemy fleet, and the zone where the enemy was detected.

The following is a list of all supported stances:

- Offensive: Continuously scan the environment for enemies, and attack and actively engage them (i.e. the ship will
try to close the distance to the enemies). You can also choose the distance at which enemies should be engaged.

- Offensive (Don't break): Continuously scan the environment for enemies, and attack them should they come in range, 
but don't break formation (i.e. ship will still follow the commander, but will shoot at any enemies in range).
Affects only capital ships. Fighters will still break formation.

- Defensive: React only to being attacked, and then actively engage enemies (i.e. the ship will try to close the 
distance to the enemies). You can also choose the maximum distance at which enemies should be engaged, i.e. when a 
ship in the same fleet is attacked, but it's attacker is very far away, this ship won't attack.

- Defensive (Don't break): React only to being attacked, but don't break formation (i.e. ship will continue following
its commander, but will shoot at enemies that attack it). Affects only capital ships. Fighters will still break 
formation. This mode is the default mode when assigning a ship to a commander.

- Follow: In this mode, ships will follow their commander and not engage enemies under any circumstances.

Since version V0.4.0 you have the option to give your fleets commands. Currently, there is only one command that
is supported, and only capital ships can be given fleet commands:

- Attack Zone: This orders your commander to take his fleet and attack a selected zone. Initially, the commander's
stance will be set to "Offensive", but his subordinates won't get their state changed (which you can do via
"Broadcast Stance"). The commander will then fly towards the center of the zone and attack all enemies he encounters
if in "Offensive" stance, or reacts to incoming attacks when in "Defensive" stance. Please note that movement in
crowded zones is currently rather buggy for capital ships (but that is not caused by this mod).

This mod also features using crew skills. For example, highly skilled captains can make in-sector jumps with their
capital ships, ships will follow their commanders more closely the more skilled they are, and ships react faster
to danger the better their combat skills are.

The main features of this mod are:

- Fighters can escort fighters (includes the Skunk), even through highways (the mod will "warp" them to the highway 
exit point of the commander)

- Capital ships can follow any kind of ship. Highly skilled pilots can jump inside of sectors, or use boost to 
navigate in zones

- Capital ships are constantly re-assessing their situation in combat. The frequency and accuracy of these assess-
ments depends on the combat skill of the defence officer

- Fleet behaviour: Ships are able to report enemy sightings to each other. If a report is received, the pilot/captain 
needs time to react based on his combined combat & navigation skill. Reports are also delayed by having commanders 
that are not skilled leaders.

- Fleet of fleets: You can assign some ships to one commander, and then assign that commanding ship to another 
commander. Orders and enemy reports are cascaded through the whole fleet.

Please be aware that this is an experimental release and as such should not be used in a real game. This mod might melt 
your PC, or destroy the world, who knows. So please use it with caution.

=== Installation (Nexus) ===

Extract and copy the "UFO" folder to the "Steam\steamapps\common\X Rebirth\extensions" folder (create the extensions 
folder if you don't have it already). 

If you are upgrading from a previous version, delete the old UFO folder first, and then extract the new one.

=== Compatibility ===

This mod should be compatible with all other mods. However, when a ship is assigned to a commander, all other scripts 
running on that ship's commander/pilot and defence officer (being stock or other mod's scripts) will be aborted.

=== Uninstallation ===

Note for workshop users: You will have to download the uninstallation scripts from the Nexus 
(http://xrebirth.nexusmods.com/mods/278/).

Extract the UFO Uninstallation archive into the extensions directory (this will overwrite the UFO/content.xml file and
add the UFO/md/UFO_Uninstall.xml file). Then load your game and wait for the uninstallation message to appear. Next,
save your game, close Rebirth, and delete the "Steam\steamapps\common\X Rebirth\extensions\UFO" folder. Lastly, load
your game, and save it again. This should remove all traces of UFO from your game.

Note that this will cause all pilots/captains that were in a fleet when uninstalling, to not have any scripts running,
and will start the stock capital defence script on all defence officers.

=== Known limitations/issues ===

- Assigning commanders only works while in space
- Currently it is not possible to cancel orders. Once a ship is assigned to a commander, it will stay assigned, until
it is assigned to another ship. However, UFO should be compatible with MCE (http://xrebirth.nexusmods.com/mods/59), so 
you can use that mod to cancel orders. However, capital ship defence officer scripts will stay active
- Sometimes, when you assign a capital ship to a commander all turret lights will turn red. This is due to a bug in
the game concerning those turret animations. To fix it, simply set the stance of the defence officer of that ship
again to what it was.
- launched drones might not always correctly return to their carrier
- when a commander is killed, all it's direct subordinates will abort their scripts and do nothing
- there is a rare race condition that causes fighter-sized ships to not follow their commander. This is due to 
in-space zone transitions
- somtimes, when a capital ship is following it's commander, it will begin 'sliding' around it's commander (happens 
especially in crowded spaces like zones with stations). This is probably due to the way UFO determines the target 
position for the capital ship to come to a stop
- UFO cannot yet cope with crew changes on ships. Should you change some crew (on either commanders or subordinates), 
please re-assign the ship/all assigned ships.

=== Technical Details ===

For texts I am using page 99998. 

=== Release history ===

 - [28.11.2013 - V0.1.0 Experimental] 
	Initial Release 
 - [28.11.2013 - V0.2.0 Experimental] 
	Fixed issue where defence officer scripts wouldn't properly start on load
	Added "Broadcast Orders" menu that allows better fleet 
 - [29.11.2013 - V0.3.0 Experimental]
	Changed wording from "Order" to "Stance"
	Fixed bug that caused fleets to not engage some enemies
	Added option to set stance for single ships
	Fixed core game bug where defence officers could not be commed on capital ships through the property menu "CO" button
	Added "Fleet Report" option that allows to get an overview of all active stances (note that you have to broadcast stances
	at least once to all ships in order for this to work)
	Made it impossible to add capital ships to a fleet that don't have a defence officer
	Made stance broadcast affect selected ship as well in case it is not the fleet commander (i.e. has no commander itself)
	Improved the way orders are acknowledged (by showing many NPCs at once)
 - [29.11.2013 - V0.3.1 Experimental]
	Fixes a bug that causes capital ships being unable to follow you into other sectors/clusters
	Also disabled jump fuel requirements for now until I can come up with a more elegant way of handling jump fuel (like making
	the needed amount base on navigation skill of captain and science skill of engineer)
 - [30.11.2013 - V0.3.2 Experimental]
	Workaround for core game bug causing capital ship radars to fail to detect any enemies
 - [01.12.2013 - V0.4.0 Experimental]
	Added possibility to choose engagement distances
	Removed XS ship categories (didn't make sense really)
	Reordered "Assign Commander" steps to make it more easy to assign multiple ships at once (thanks to ShadowWalker999 for the idea)
	Added "Real-time Fleet Status Report" feature when engaging enemies
	Captains prioritize enemy capital ships for movement during combat (and try to have their most DPS efficient side towards the enemy)
	Fixed the turret light problem for good
	Implemented first "Fleet Command" - "Attack Zone"
 - [03.12.2013 - V0.4.1 Beta]
	Fixed a bug that caused the stock "Take me to..." and MCE's "Move to zone" to not work
	Added functions to activate UFO scripts on all defence officers not running a UFO script on game load, as well as when assigning them
	to work on a ship (i.e. replacement for discontinued CSE mod)
	Also added possibility to set stances on defence officers when their ship is not part of a fleet"
 - [15.12.2013 - V0.4.2 Beta]
	Fixed bug that caused capital ships to not fire their main weapons (e.g. Balor torpedos)
	Reintroduced gravidar checks for enemies (also fixes bug of ships not attacking stations)
	Added option "Remove from Commander"
	Added uninstallation script
 - [25.12.2013 - V0.4.3 Beta]
	Fixed bug that caused capital ships to not attack stations
	Disabled in-zone boosting since it caused issues for many people

=== Future Plans ===

- better fleet ai, e.g. fighters not blindly attacking capital ships, fleets trying to stay close together, using tactics etc.
- make crew gain piloting skill by based on flying time
- make crew gain combat skill by fighting/killing enemies
- implement commander-promotion if commander is killed
- make more aspects skill-based
- create unique traits for crew, that give special bonuses
- better capital ship target prioritization
- rewrite fighter attack AI
- make capital ships need to buy ammunition (currently it is simply spawned, like it is in the stock game script)
- choose formations for fighter squads