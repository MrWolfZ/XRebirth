Author: MadJoker 
Version: V0.5.0 Beta
Date: 1st May 2014

X Rebirth version: 1.31

http://steamcommunity.com/sharedfiles/filedetails/?id=247004923
http://xrebirth.nexusmods.com/mods/278/

=== About ===

Ever wondered why capital ships were just sitting idly while being bombarded by enemies? Ever were angry that your 
followers were being destroyed in distant sectors while you had long changed positions?

If you can answer these questions with 'yes', then this mod is for you. I proudly present:

UFO - Ultimate Fleet Overhaul

This mod is a complete rewrite from scratch for the escort and capital ship combat scripts.

=== Details ===

This mod adds a fleet management UI to the game, accessible via the Radial Menu -> 3-Universe -> 4 Fleet Management.

The most basic functionality of this mod is to just assign some ships to the 'Player Fleet' and they will follow you 
and engage enemies based on the selected stances (see below). The ships will then not be part of your squad in terms 
of that game mechanic, so you won't see "In my squad" on the property monitor. But it will still behave correctly.

UFO allows you to assign "stances" to your fleets, ships, and even single NPCs. Stances are seperated into "Aggression
Level" and "Formation Mode".

The following is a list of all aggression Levels:

- Passive: This mode forces the formation mode "Don't Break". In this mode captains and pilots will stay in formation
with the fleet at all times, and defence officers will never fire at enemies.

- Defensive: Captains and pilots will react to enemies based on their formation mode only if the fleet is attacked.
Defence officers will fire upon enemies only if the fleet is attacked.

- Offensive: Captains and pilots will react to enemies based on their formation mode as soon as enemies are detected.
Defence officers will fire upon any enemy in range.

The following is a list of all formation modes (note that defence officers ignore formation modes):

- Break: In this mode captains and pilots will break formation based on their aggression level.

- Don't Break: In this mode, captains and pilots will always stay in formation and never fly towards the enemy,
regardless of aggression level.

UFO also allows you to give some basic commands to your fleet. Below is a list of all commands currently supported:

- Escort Ship: This orders the fleet to protect a chosen ship based on the stances of the fleet (e.g. if all ships
are 'Passive' then this is just a follow command).

- Move to Zone: This orders the fleet to move to a chosen zone. Enemies will be engaged based on the stances of the
fleet (e.g. in 'Offensive' stance, this acts like an attack command).

Should any of your fleets engage some enemies, they will send you a real-time status report with details about your 
fleet, the enemy ships, and the zone where the enemy was detected.

This mod also features using crew skills. For example, highly skilled captains can make in-sector jumps with their
capital ships, and ships in general react faster to changing circumstances based on their skills.

Please be aware that this is a beta release and as such might melt your PC, destroy the world, or who knows. So 
please use it with caution.

=== Installation (Nexus) ===

Extract and copy the "UFO" folder to the "Steam\steamapps\common\X Rebirth\extensions" folder (create the extensions 
folder if you don't have it already). 

If you are upgrading from a previous version, delete the old UFO folder first, and then extract the new one.

=== Installation (Workshop) ===

Simply subscribe to the mod.

=== Compatibility ===

This mod is incompatible with any other mod that changes the pilot/captain/defence officer scripts. That being said,
the UFO scripts only become active once a ship is assigned to a fleet. Therefore, as long as a ship is not in a fleet,
all other mods should work correctly with that ship.

=== Uninstallation ===

UFO features a one-click uninstallation routine. To access it, click the 'Info' icon in the top left corner of the Fleet
Management menu and then select the 'Uninstall' button and follow the on-screen instructions (also available in the
logbook).

Note that this will cause all pilots/captains that were in a fleet when uninstalling, to not have any scripts running,
and will start the stock capital defence script on all defence officers.

=== Known limitations/issues ===

- The Fleet Management menu is only available while not being docked
- Ships without captain/pilot or defence officer cannot be added to fleets
- Before using their boost for far away targets, capital ships will rotate to align with the target; however, this rotation
  does not take obstacles into account. Capital ships will also sometimes get stuck in crowded areas. To resolve this issue
  simply leave the area, since movement that happens outside of the player's area is not impeded by obstacles.
- Fleets lead by fighters cannot escort other fighters; this is due to how formations work in the game
- Zones and ships as targets for fleet commands can not yet be selected via the map, but instead use a list menu
- Launched drones might not always correctly return to their carrier
- When a fleet commander is killed, the fleet will be dissolved and you will have to create a new fleet
- UFO cannot cope with crew changes; should you change some crew on a fleet ship, please re-assign the ship

=== Technical Details ===

For texts I am using page 99998. 

=== Release history ===

 - [2013-11-28 - V0.1.0 Experimental] 
	Initial Release 
 - [2013-11-28 - V0.2.0 Experimental] 
	Fixed issue where defence officer scripts wouldn't properly start on load
	Added "Broadcast Orders" menu that allows better fleet 
 - [2013-11-29 - V0.3.0 Experimental]
	Changed wording from "Order" to "Stance"
	Fixed bug that caused fleets to not engage some enemies
	Added option to set stance for single ships
	Fixed core game bug where defence officers could not be commed on capital ships through the property menu "CO" button
	Added "Fleet Report" option that allows to get an overview of all active stances (note that you have to broadcast stances
	at least once to all ships in order for this to work)
	Made it impossible to add capital ships to a fleet that don't have a defence officer
	Made stance broadcast affect selected ship as well in case it is not the fleet commander (i.e. has no commander itself)
	Improved the way orders are acknowledged (by showing many NPCs at once)
 - [2013-11-29 - V0.3.1 Experimental]
	Fixes a bug that causes capital ships being unable to follow you into other sectors/clusters
	Also disabled jump fuel requirements for now until I can come up with a more elegant way of handling jump fuel (like making
	the needed amount base on navigation skill of captain and science skill of engineer)
 - [2013-11-30 - V0.3.2 Experimental]
	Workaround for core game bug causing capital ship radars to fail to detect any enemies
 - [2013-12-01 - V0.4.0 Experimental]
	Added possibility to choose engagement distances
	Removed XS ship categories (didn't make sense really)
	Reordered "Assign Commander" steps to make it more easy to assign multiple ships at once (thanks to ShadowWalker999 for the idea)
	Added "Real-time Fleet Status Report" feature when engaging enemies
	Captains prioritize enemy capital ships for movement during combat (and try to have their most DPS efficient side towards the enemy)
	Fixed the turret light problem for good
	Implemented first "Fleet Command" - "Attack Zone"
 - [2013-12-03 - V0.4.1 Beta]
	Fixed a bug that caused the stock "Take me to..." and MCE's "Move to zone" to not work
	Added functions to activate UFO scripts on all defence officers not running a UFO script on game load, as well as when assigning them
	to work on a ship (i.e. replacement for discontinued CSE mod)
	Also added possibility to set stances on defence officers when their ship is not part of a fleet"
 - [2013-12-15 - V0.4.2 Beta]
	Fixed bug that caused capital ships to not fire their main weapons (e.g. Balor torpedos)
	Reintroduced gravidar checks for enemies (also fixes bug of ships not attacking stations)
	Added option "Remove from Commander"
	Added uninstallation script
 - [2014-03-20 - V0.4.3 Beta]
	Compatibility update for game version 1.25
	Moved fleet menu to MAINMENU/3/4
	Disabled in-zone boosting since it caused issues for many player
 - [2014-05-21 - V0.5.0 Beta]
	Major rewrite of almost everything in the mod
	Added Fleet Management UI

=== Future Plans ===

- none