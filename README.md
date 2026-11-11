# TideHaven

TideHaven is a GameMaker Studio 2 project. Open `tidehaven.yyp` in the GameMaker IDE to edit or run it.

## Build and run

1. Open `tidehaven.yyp` in GameMaker Studio 2 and wait for the project resources to load.
2. Choose **Build → Run** or press **F5**.
3. Check the IDE's **Output** and **Compile Errors** panes if the build fails.

The project was last built and launched on **2026-11-11** in GameMaker IDE **2024.14.4.222** with Runtime **2024.14.4.268**. The guided-start dialogue, biome terrain, and the new bridge/template code all compile and launch in the Runner. Bridge and template placement behavior and the full cave reward-and-return route still need playthrough checks.

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

The starter recipe list includes a Water Bridge recipe (3 wood and 1 rock). Place the bridge item over water to create a walkable tile; destroying the bridge restores the previous water tile.

House templates capture placed floor, wall, and soil pieces within 128 pixels. Up to 12 templates are kept in the versioned save. Placement checks for land, collisions, and the required materials, then saves the placed pieces with the room state. These interactions compile and launch, but still need in-game verification.

## Saves

The current save format is versioned JSON (`TideHavenSave.json`) with a `.bak` recovery copy. The game can also migrate progression from the older `save.dat` INI/base64 format. GameMaker resolves these filenames in the Runner's working directory, which can differ between IDE and exported builds.

## Project layout

- `objects/` — gameplay objects and event code
- `scripts/` — shared systems, world generation, items, UI, and saves
- `rooms/` — GameMaker rooms
- `sprites/`, `tilesets/`, `fonts/`, `sounds/` — game art and audio resources
- `notes/` — implementation backlog and project status

## Project notes

The detailed baseline, milestone plan, status, and acceptance criteria are in `notes/TIdehaven TODO/TIdehaven TODO.txt`. `notes/TODO/TODO.txt` points to that file and gives a short status summary.
