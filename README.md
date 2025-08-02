# Player-NPC-Cuffing-System-Standalone-No-Framework-Requirements

FiveM Handcuff Script
This script provides a straightforward handcuffing system for FiveM roleplay servers. It supports cuffing and uncuffing nearby players and NPCs, complete with animations, props, and control restrictions to simulate being restrained.

Customization
All key customization options — including cuff distance, animation timing, control disables, keybindings, and prop settings — have been moved into a dedicated file: client_customise_ME.lua.
This makes it easy for server developers or admins to tweak the script behavior without diving into the main code logic. Simply open that file and adjust values like:

CUFF_DISTANCE — how close you must be to cuff someone

Animation dictionary and names for cuff, idle, and uncuff

Handcuff prop model and bone attachment settings

Disabled controls while cuffed

Keybinding for cuffing command

Keeping config separate makes upgrading or integrating this script simpler and cleaner.

How It Works
When the cuff command/keybind is triggered, the script finds the nearest player or NPC within the specified distance.

If the target is not cuffed, it plays the cuffing animation from the cop’s perspective, attaches the cuffs prop to the target’s hands, freezes their position, disables key controls, and plays an idle cuffed animation.

When uncuffing, it plays the uncuff animation, removes the prop, unfreezes the entity, and restores full control.

The cuff state is synced via server events to keep everyone consistent.

It disables various controls (jumping, sprinting, attacking, weapon wheel, etc.) to simulate restraint but does not affect things outside the cuff scope.

Development Notes
The main logic resides in client.lua, but all values that devs might want to tweak should be in client_customise_ME.lua.

This separation prevents accidental edits breaking the core code and streamlines maintenance.

Animations use standard GTA V dictionaries and names, so they should work out of the box with minimal issues.

The prop is attached to the bone index 57005 (right hand wrist), but you can adjust this if your server uses custom models or you want a different placement.

Control disables cover most actions that would realistically be restricted, but you can easily add or remove controls in the customize file.

The script supports both players and AI peds to provide flexibility in RP scenarios.

Installation
Place client.lua and client_customise_ME.lua in your resource folder.

Ensure your server triggers the cuff toggle events properly (usually handled in server.lua).

Modify client_customise_ME.lua to fit your server preferences.

Start the resource and enjoy handcuffing!




https://github.com/user-attachments/assets/8c64ac8a-54e4-4479-9ae5-56cbc13c0765

