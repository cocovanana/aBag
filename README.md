# aBag
WoW Classic bag and bank addon, featuring simplicity and sleek design.

## Intro
Extra simple bag and bank addon for simple people like me!
Position can be adjusted using /abag. All other config is done in the core/config.lua file.
Sorting dot is by default enabled for bags and disabled for bank. This depends on [SortBags](https://github.com/shirsig/SortBags), so you'll need to download it for it to appear and work.
Profession and ammo bags are displayed in separate frames. Title and color can be fully customized. By default, color is the same as the main bag and title is hidden.

All config is done in the core/config.lua file!!! There's many configuration options, so take a look!


## Features
  * One big bag!
  * And for bank too!
  * Profession and ammo bags!
  * Keyring!
  * Item quality borders!
  * Item level!
  * Optional sorting!
  * No bag bar!
  * No searching!
  * No grouping!
  * No nothing!

## Known bugs
  * When removing a bag from the bank and placing it in the backpack or the default bank slots, its related slots are not immediately removed. Fix: click/drag any item
  * Bank main container's items' tooltips aren't displayed.

## Changelog
  * 1.8: Added keyring support.
  * 1.7: Added in-game drag configuration via /abag.
  * 1.6: Added multiple configuration options for item quest/level/quality/junk.
  * 1.5: Added support for bank slots.
  * 1.4: Major bug fixes.
  * 1.3: Added profession/ammo/soul bags support.
  * 1.2: Added sort functionality using SortBag.
  * 1.0: Initial build.
