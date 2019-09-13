local A, L = ...

L.C = {
  itemLevelThreshold = 11,     -- shows only item level text for gear this level or higher
  itemLevelQuality   = true,   -- colors item level text with quality colors
  itemQualityEnabled = true,   -- colors border for non-quest items with quality colors
  questColorEnabled  = true,   -- colors border for quest items using color defined below
  junkIconEnabled    = true,   -- shows a golden coin for junk items
  questColor    = {1, 1, 0},   -- color for quest items' border, default is yellow {1, 1, 0}
  selectedColor = {0, 0.5, 1}, -- color for the highlighting slots you hover, default is cyan-ish {0, 0.5, 1}
  colorAlpha    = 1,           -- alpha for the colored borders, default is 1
  scale         = 0.95,        -- scale for the whole thing, default is 0.95
  fontFamily    = STANDARD_TEXT_FONT,
  pushedTexture = "Interface\\AddOns\\"..A.."\\media\\pushed.tga",
  fontType      = "ChatFontNormal",
  highlightFile = "Interface\\Buttons\\UI-ActionButton-Border",
  glowFile      = "Interface\\AddOns\\"..A.."\\media\\glow.tga",
  bag = {
    enabled      = true,
    containerIds = {0, 1, 2, 3, 4},
    padding      = 4,
    maxColumns   = 8,
    minColumns   = 4,
    point        = {"BOTTOMRIGHT", -80, 80}, -- anchors to the screen, default is "BOTTOMRIGHT", -80, 80
    iconSize     = 42,
    extraHeight  = 16,                       -- height of the title/gold/sort frames
    title = {
      enabled    = false,                    -- shows the name of the profession/soul/ammo bags
      anchor     = "TOPLEFT",                -- use "TOPLEFT", "TOP", or "TOPRIGHT" for left, middle and right alignment
      offsetX    = 10,
      offsetY    = -8,
      font       = "Fonts\\FRIZQT__.TTF",
      fontSize   = 12
    },
    gold = {
      font       = "Fonts\\FRIZQT__.TTF",
      fontSize   = 13
    },
    sort = {
      enabled    = true,       -- enables the sorting dot, if SortBags addon is present
      size       = 14,
      doSort     = function() SortBags() end
    }
  },
  keyring = {
    enabled      = false,      --releases in first patch after launch
    containerIds = {-2},
    padding      = 4,
    maxColumns   = 2,
    minColumns   = 1,
    point        = {"BOTTOMLEFT", -80, 80},
    iconSize     = 42,
    extraHeight  = 16,         -- height of the title frame
    title = {
      enabled    = false,      -- shows 'keyring' as title
      anchor     = "TOPLEFT",  -- use "TOPLEFT", "TOP", or "TOPRIGHT" for left, middle and right alignment
      offsetX    = 10,
      offsetY    = -8,
      font       = "Fonts\\FRIZQT__.TTF",
      fontSize   = 12
    }
  },
  bank = {
    enabled      = true,
    containerIds = {-1, 5, 6, 7, 8, 9, 10}, --vanilla
    --containerIds = {-1, 5, 6, 7, 8, 9, 10, 11}, --tbc
    padding      = 4,
    maxColumns   = 16,
    minColumns   = 4,
    point        = {"TOPLEFT", 80, -80}, -- anchors to the screen, default is "TOPLEFT", 80, -80
    iconSize     = 42,
    sort = {
      enabled    = false,
      height     = 16,
      size       = 14,
      doSort     = function() SortBankBags() end
    },
    anchorSlots  = "LEFT", -- "LEFT" or "RIGHT" to align slots to the left or right beneath the bank frame
    showAllSlots = true    -- whether to show unbought bank slots
  },
  reagent = {
    enabled      = false, --wod
    containerIds = {-3},
    padding      = 4,
    maxColumns   = 16,
    minColumns   = 4,
    point        = {"TOPLEFT", 80, -80},
    iconSize     = 42
  },
  guild = {
    enabled      = false, --tbc
    containerIds = {},    --possibly works different
    padding      = 4,
    maxColumns   = 16,
    minColumns   = 4,
    point        = {"TOPLEFT", 80, -80},
    iconSize     = 42,
    extraHeight  = 16,
    gold = {
      font       = "Fonts\\FRIZQT__.TTF",
      fontSize   = 13
    }
  },
  professionColors = { --default {0.08, 0.08, 0.1, 0.92}
    {0, 0, 0, 0},            --  1 dummy
    {0.08, 0.08, 0.1, 0.92}, --  2 soul
    {0.08, 0.08, 0.1, 0.92}, --  3 herb
    {0.08, 0.08, 0.1, 0.92}, --  4 enchanting
    {0.08, 0.08, 0.1, 0.92}, --  5 engineering
    {0.08, 0.08, 0.1, 0.92}, --  6 gem
    {0.08, 0.08, 0.1, 0.92}, --  7 mining
    {0.08, 0.08, 0.1, 0.92}, --  8 leather
    {0.08, 0.08, 0.1, 0.92}, --  9 inscription
    {0.08, 0.08, 0.1, 0.92}, -- 10 tackle
    {0.08, 0.08, 0.1, 0.92}, -- 11 cooking
    {0, 0, 0, 0},            -- 12 dummy
    {0.08, 0.08, 0.1, 0.92}, -- 13 quiver
    {0.08, 0.08, 0.1, 0.92}  -- 14 ammo pouch
  },
  professionBorderColors = { --default {0.1, 0.1, 0.1, 0.6}
    {0, 0, 0, 0},         --dummy
    {0.1, 0.1, 0.1, 0.6}, --soul
    {0.1, 0.1, 0.1, 0.6}, --herb
    {0.1, 0.1, 0.1, 0.6}, --enchanting
    {0.1, 0.1, 0.1, 0.6}, --engineering
    {0.1, 0.1, 0.1, 0.6}, --gem
    {0.1, 0.1, 0.1, 0.6}, --mining
    {0.1, 0.1, 0.1, 0.6}, --leather
    {0.1, 0.1, 0.1, 0.6}, --inscription
    {0.1, 0.1, 0.1, 0.6}, --tackle
    {0.1, 0.1, 0.1, 0.6}, --cooking
    {0, 0, 0, 0},         --dummy
    {0.1, 0.1, 0.1, 0.6}, --quiver
    {0.1, 0.1, 0.1, 0.6}  --ammo pouch
  },
  professionTitleColors = { --default "9d9d9d"
    "ffffff", --dummy
    "9d9d9d", --soul
    "9d9d9d", --herb
    "9d9d9d", --enchanting
    "9d9d9d", --engineering
    "9d9d9d", --gem
    "9d9d9d", --mining
    "9d9d9d", --leather
    "9d9d9d", --inscription
    "9d9d9d", --tackle
    "9d9d9d", --cooking
    "ffffff", --dummy
    "9d9d9d", --quiver
    "9d9d9d"  --ammo pouch
  },
  containerBackdrop = {
    bgFile               = "Interface\\Buttons\\WHITE8x8",
    bgColor              = {0.08, 0.08, 0.1, 0.92},
    edgeFile             = "Interface\\Tooltips\\UI-Tooltip-Border",
    borderColor          = {0.1, 0.1, 0.1, 0.6},
    itemBorderColorAlpha = 0.9,
    tile                 = false,
    tileEdge             = false,
    tileSize             = 16,
    edgeSize             = 16,
    insets               = {left = 3, right = 3, top = 3, bottom = 3}
  },
  itemBackdrop = {
    bgFile               = "Interface\\Buttons\\WHITE8x8",
    bgColor              = {0, 0, 0, 0},
    edgeFile             = "Interface\\Tooltips\\UI-Tooltip-Border",
    edgeColor            = {r = 1, g = 1, b = 1, a = 1},
    borderColor          = {0.1, 0.1, 0.1, 0.6},
    itemBorderColorAlpha = 0.9,
    tile                 = false,
    tileEdge             = false,
    tileSize             = 12,
    edgeSize             = 12,
    insets               = {left = 3, right = 3, top = 3, bottom = 3}
  }
}
