﻿Author: MadJoker 
Version: V0.1.1
Date: 3rd February 2015

X Rebirth version: 3.20

http://www.nexusmods.com/xrebirth/mods/385/
http://steamcommunity.com/sharedfiles/filedetails/?id=255150121

=== About ===

This is a set of library scripts and UIs that can be used by modders.

=== Details ===

This library contains:

- A generic installation and version control MD script. See the LibMJ.xml file for an example of 
  how the generic script is used by the LibMJ initialization script itself.

- A generic radial menu generator.

- A mechanism to add menu items to the sidebar (compatible with SidebarExtender).

- A way to create dictionaries/associative arrays to be used in scripts:

For a long time, I have searched for a way to have dictionaries in the X:Rebirth XML scripting 
language. Then I realized, that entities/actors could be used for this purpose, since they have 
a blackboard which behaves almost like a dictionary (with the exception, that keys cannot be
enumerated). The second insight was that it is possible to store a "virtual entity" in a completed
cue, and still access it as if it was real. This allows to use those virtual entities as dictionaries.
To create a new dictionary simply use

<create_cue_actor name="$dDict" cue="md.LibMJ.DictionaryContainer" />

However, you need to be aware that this actor will stay in the cue indefinitely unless manually removed.
It is important to clean up each dictionary created, since otherwise the savegame will be bloated. To
remove a dictionary simply use

<remove_cue_actor cue="md.LibMJ.DictionaryContainer" actor="$dDict" />

- A UI framework to effortlessly created new UIs. A usage guide might be provided at a later point. For
  now please see the other UI scripts for examples of how to use the framework.

- Some generic UI screens for selecting a ship/zone through a list or capture some text input.

=== Installation (Nexus) ===

Extract and copy the "LibMJ" folder to the "Steam\steamapps\common\X Rebirth\extensions" folder (create the extensions 
folder if you don't have it already).

=== Installation (Workshop) ===

Simply subscribe to the mod.

=== Compatibility ===

Since this is only a library, there are no compatibility issues.

=== Uninstallation (Nexus) ===

Simply delete the "LibMJ" folder from the "Steam\steamapps\common\X Rebirth\extensions" folder.

=== Uninstallation (Steam) ===

Simply unsubscribe from the mod.

=== Known limitations/issues ===

- none so far

=== Technical Details ===

For texts I am using page 99997. 

=== Release history ===

 - [2014-05-01 - V0.0.1] 
	Initial Release 
 - [2015-01-17 - V0.1.0] 
    Compatibility with X:Rebirth 3.10
    New mechanism for adding items to the sidebar 
 - [2015-02-03 - V0.1.1] 
    Compatibility with X:Rebirth 3.20

=== Future Plans ===

- none