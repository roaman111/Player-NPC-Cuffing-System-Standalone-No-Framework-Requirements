# Player-NPC-Cuffing-System-Standalone-No-Framework-Requirements

FiveM Handcuff Script
This is a simple but functional handcuff script designed for FiveM servers. It lets police or other players cuff and uncuff nearby players or NPCs, adding a layer of realism to roleplay situations where detaining someone is necessary.

Features:
Cuff and uncuff both players and NPCs within a customizable radius.

Realistic animations for cuffing, idling while cuffed, and uncuffing.

Attaches actual handcuff props to the target’s hands while cuffed.

Freezes the cuffed entity in place and disables certain controls to simulate being restrained.

Easy to customize key settings like cuff distance, animation timing, and keybinds right at the top of the script — no digging through code required.

Clean, simple implementation with minimal dependencies so you can easily integrate it into your existing server framework.

How it works:
When you press the configured key (default is “G”), the script finds the closest player or NPC within the cuff radius. If they’re not cuffed, the cuff animation plays and the target gets restrained, preventing movement and disabling actions like sprinting or attacking. Uncuffing plays a separate animation before restoring full control.

Why use this script?
Many roleplay servers need a reliable way to simulate arresting or restraining suspects. This script focuses on core functionality without overcomplicating things, giving server owners an easy-to-edit, stable handcuff mechanic that “just works.” Plus, it works with both players and NPCs.
