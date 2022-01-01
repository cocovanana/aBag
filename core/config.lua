local A, L = ...

L.C = {
  itemLevelThreshold = 11, -- show only iLevel on this level or higher. remove or =nil to hide all
  itemLevelQuality   = true,
  itemQualityEnabled = true, --colors non-quest items
  questColorEnabled  = true, --colors quest items
  junkIconEnabled    = true,
  questColor    = {1, 1, 0},
  selectedColor = {0, 0.5, 1},
  colorAlpha    = 1,
  scale         = 0.95,
  fontFamily    = STANDARD_TEXT_FONT,
  pushedTexture = "Interface\\AddOns\\"..A.."\\media\\pushed.tga",
  fontType      = "ChatFontNormal",
  fontSize      = 11, --for stuff like count or iLevel
  highlightFile = "Interface\\Buttons\\UI-ActionButton-Border",
  glowFile      = "Interface\\AddOns\\"..A.."\\media\\glow.tga",
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
  },
  bag = {
    enabled      = true,
    containerIds = {0, 1, 2, 3, 4},
    padding      = 4,
    maxColumns   = 8,
    minColumns   = 4,
    point        = {"BOTTOMRIGHT", -80, 80},
    iconSize     = 42,
    extraHeight  = 16, --if gold, sort or title
    title = {
      enabled    = false, --show name of profession bags. color config at end of file
      anchor     = "TOPLEFT", --use "TOPLEFT", "TOP", or "TOPRIGHT"
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
      enabled    = true,
      size       = 14,
      doSort     = function() SortBags() end
    }
  },
  keyring = {
    enabled      = true,
    buttonSize   = 14,
    containerIds = {-2},
    padding      = 4,
    maxColumns   = 4,
    minColumns   = 1,
    iconSize     = 42
  },
  bank = {
    enabled      = true,
    containerIds = {-1, 5, 6, 7, 8, 9, 10}, --vanilla
    --containerIds = {-1, 5, 6, 7, 8, 9, 10, 11}, --tbc
    padding      = 4,
    maxColumns   = 16,
    minColumns   = 4,
    point        = {"TOPLEFT", 80, -80},
    iconSize     = 42,
    sort = {
      enabled    = false,
      height     = 16,
      size       = 14,
      doSort     = function() SortBankBags() end
    },
    anchorSlots  = "LEFT", -- "LEFT" or "RIGHT"
    showAllSlots = true -- whether to show non-buyed bank slots
  },
  reagent = {
    enabled      = false, --not implemented
    containerIds = {-3},
    padding      = 4,
    maxColumns   = 16,
    minColumns   = 4,
    point        = {"TOPLEFT", 80, -80},
    iconSize     = 42
  },
  guild = {
    enabled      = false,
    containerIds = {}, --possibly works different
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
  }
}
