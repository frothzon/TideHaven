# TideHaven

TideHaven is a GameMaker Studio 2 project. Open `tidehaven.yyp` in the GameMaker IDE to edit or run it.

## Build and run

1. Open `tidehaven.yyp` in GameMaker Studio 2 and wait for the project resources to load.
2. Choose **Build → Run** or press **F5**.
3. Check the IDE's **Output** and **Compile Errors** panes if the build fails.

The project was last built and launched on **2026-11-11** in GameMaker IDE **2024.14.4.222** with Runtime **2024.14.4.268**. The current source also compiles against Runtime **2024.14.4.268** and passes an isolated 11-check gameplay scenario covering legacy-save migration, the dungeon route and shrine, bridge placement and removal, housing templates, room transitions, and versioned save reload. A full keyboard playthrough is still useful before release.

## Controls

| Key | Action |
| --- | --- |
| WASD | Move |
| E | Interact |
| P | Open inventory |
| M | Open world map |
| B | Open skills |
| Escape | Close the current menu and resume gameplay |
| Ctrl+S | Save |
| Ctrl+H | Save nearby placed floor, wall, and soil pieces as a house template |
| Ctrl+J | Select the next saved house template |
| Ctrl+T | Preview the selected template; left-click to place or Escape to cancel |

## Building and housing

The starter recipe list includes a Water Bridge recipe (3 wood and 1 rock). Existing saves receive it once on load if it is missing. Place the bridge item over water to create a walkable tile; destroying the bridge restores the previous water tile.

House templates capture placed floor, wall, and soil pieces within 128 pixels. Up to 12 templates are kept in the versioned save. Placement checks for land, collisions, and the required materials, then saves the placed pieces with the room state. The isolated scenario verifies capture, material costs, placement, and persistence through a dungeon/overworld transition. Builder anchors now start at each instance's creation position so placed pieces stay put after placement and reload.

## Skill tree art

The original three-frame, 64×64 skill-node button sprite is restored as `spr_skill_icon` and supplies normal, hover, and pressed states. Nine implemented skills have individual pixel-art symbols from the 3×3 sheet in `art/generated/skill-icons-sheet.png`, imported into `spr_skill_symbols` and cropped by the skill renderer. The other 16 nodes remain generic placeholders with no assigned symbols.

The original `spr_gear` sprite is also restored with all 37 frames from the downloaded source project. New game art should preserve these resource identities and frame data when possible; use separate resources for replacement or generated art.

## Saves

The current save format is versioned JSON (`TideHavenSave.json`) with a `.bak` recovery copy. The game can also migrate progression from the older `save.dat` INI/base64 format. An isolated scenario verifies representative legacy progression migration and reload of progression, skill, seed, inventory, shrine, player-position, template, and room-snapshot data. It uses a generated legacy fixture; migration from an actual older player save still needs confirmation. GameMaker resolves these filenames in the Runner's working directory, which can differ between IDE and exported builds.

## Project layout

- `objects/` — gameplay objects and event code
- `scripts/` — shared systems, world generation, items, UI, and saves
- `rooms/` — GameMaker rooms
- `art/generated/` — source PNGs for generated replacement art
- `sprites/`, `tilesets/`, `fonts/`, `sounds/` — game art and audio resources
- `notes/` — implementation backlog and project status

## Project notes

The detailed baseline, milestone plan, status, and acceptance criteria are in `notes/TIdehaven TODO/TIdehaven TODO.txt`. `notes/TODO/TODO.txt` points to that file and gives a short status summary.
