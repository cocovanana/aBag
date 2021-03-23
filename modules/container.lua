local A, L = ...

L.M.container = {}

local _G = _G
local unpack, GetCoinTextureString, GetMoney, ceil = unpack, GetCoinTextureString, GetMoney, math.ceil
local SOUNDKIT_IG_BACKPACK_OPEN, SOUNDKIT_IG_BACKPACK_CLOSE = SOUNDKIT.IG_BACKPACK_OPEN, SOUNDKIT.IG_BACKPACK_CLOSE

function L.M.container.Create(name, cfg, containerIds, anchorTo, containerGroupId, containerGroupName)
  local container = {}

  if L.SpecialFrames[name] then
    name = name..math.random(1, 1000)
  end

  container.cfg     = cfg
  container.frame   = tremove(L.FramePool) or CreateFrame("Frame", name, UIParent)
  container.frame:SetParent(UIParent)
  name = container.frame:GetName()

  L.U.SetSlots(container, containerIds)
  L.U.SetColumns(container, cfg)

  container.frame:SetFrameStrata("MEDIUM")
  container.frame:SetFrameLevel(1)
  container.frame:SetScale(L.C.scale)
  container.frame:SetWidth(container.columns*cfg.iconSize + L.C.containerBackdrop.insets.left + L.C.containerBackdrop.insets.right + cfg.padding*2)
  container.frame:SetBackdrop(L.C.containerBackdrop)
  if containerGroupId == 1 then
    if containerGroupName == "Keyring" then
      container.frame:SetPoint("BOTTOMRIGHT", L.M.bag.containers[1].frame, "BOTTOMLEFT")
    else
      container.frame:SetPoint(unpack(cfg.point))
    end
    container.frame:SetBackdropColor(unpack(L.C.containerBackdrop.bgColor))
    container.frame:SetBackdropBorderColor(unpack(L.C.containerBackdrop.borderColor))

    if cfg.gold then
      container.frame:SetHeight(ceil(container.slots / container.columns)*cfg.iconSize + L.C.containerBackdrop.insets.top + L.C.containerBackdrop.insets.bottom + cfg.padding*2 + cfg.extraHeight)
      if not container.frame.gold then
        container.frame.gold = CreateFrame("Frame", name.."Gold", container.frame, "SmallMoneyFrameTemplate")
      end
      _G[name.."GoldCopperButtonText"]:SetFont(cfg.gold.font, cfg.gold.fontSize, "OUTLINE")
      _G[name.."GoldSilverButtonText"]:SetFont(cfg.gold.font, cfg.gold.fontSize, "OUTLINE")
      _G[name.."GoldGoldButtonText"]:SetFont(cfg.gold.font, cfg.gold.fontSize, "OUTLINE")
      container.frame.gold:SetPoint("BOTTOMRIGHT", container.frame, -L.C.containerBackdrop.insets.right+6, L.C.containerBackdrop.insets.bottom+5)
    elseif (cfg.sort and cfg.sort.enabled and SortBags) then
      container.frame:SetHeight(ceil(container.slots / container.columns)*cfg.iconSize + L.C.containerBackdrop.insets.top + L.C.containerBackdrop.insets.bottom + cfg.padding*2 + cfg.extraHeight)
    else
      container.frame:SetHeight(ceil(container.slots / container.columns)*cfg.iconSize + L.C.containerBackdrop.insets.top + L.C.containerBackdrop.insets.bottom + cfg.padding*2)
    end

    if (cfg.sort and cfg.sort.enabled and SortBags) then
      if not container.frame.sort then
        container.frame.sort = CreateFrame("Button", name.."Sort", container.frame)
      end
      container.frame.sort:SetPoint("BOTTOMLEFT", container.frame, L.C.containerBackdrop.insets.right+6, L.C.containerBackdrop.insets.bottom+4)
      container.frame.sort:SetWidth(cfg.sort.size)
      container.frame.sort:SetHeight(cfg.sort.size)
      container.frame.sort.dot = container.frame.sort:CreateFontString(name.."SortDot", "BORDER", L.C.fontType)
      container.frame.sort.dot:SetShadowOffset(1,-1)
      container.frame.sort.dot:SetAllPoints(container.frame.sort)
      container.frame.sort.dot:SetText("|cff9d9d9d•|r")
      container.frame.sort:RegisterForClicks("AnyUp");
      container.frame.sort:SetScript("OnClick", function (self, button, down) cfg.sort.doSort() end)
    end
  elseif cfg.title and cfg.title.enabled then
    container.frame:SetHeight(ceil(container.slots / container.columns)*cfg.iconSize + L.C.containerBackdrop.insets.top + L.C.containerBackdrop.insets.bottom + cfg.padding*2 + cfg.extraHeight)
    container.frame:SetPoint("BOTTOMRIGHT", anchorTo, "TOPRIGHT", 0, 6)
    container.frame:SetBackdropColor(unpack(L.C.professionColors[containerGroupId]))
    container.frame:SetBackdropBorderColor(unpack(L.C.professionBorderColors[containerGroupId]))

    if not container.frame.title then
      container.frame.title = container.frame:CreateFontString(nil, "BORDER", L.C.fontType)
    end
    container.frame.title:SetShadowOffset(1,-1)
    container.frame.title:SetText("|cff"..L.C.professionTitleColors[containerGroupId]..""..containerGroupName.."|r")
    container.frame.title:SetPoint(cfg.title.anchor, container.frame, cfg.title.offsetX, cfg.title.offsetY)
    container.frame.title:Show()
  else
    container.frame:SetHeight(ceil(container.slots / container.columns)*cfg.iconSize + L.C.containerBackdrop.insets.top + L.C.containerBackdrop.insets.bottom + cfg.padding*2)
    container.frame:SetPoint("BOTTOMRIGHT", anchorTo, "TOPRIGHT", 0, 6)
    container.frame:SetBackdropColor(unpack(L.C.professionColors[containerGroupId]))
    container.frame:SetBackdropBorderColor(unpack(L.C.professionBorderColors[containerGroupId]))
  end
  container.frame:Hide()

  if not anchorTo then
    L.U.CreateDragFrame(container.frame)
  end

  container.items = {}

  tinsert(UISpecialFrames, name)
  L.SpecialFrames[name] = true

  return container
end

function L.M.container.Update(container, containerIds, containerGroupId)
  if containerIds then
    local cfg = container.cfg
    local addHeight = 0

    L.U.SetSlots(container, containerIds)
    L.U.SetColumns(container, cfg)

    if ((containerGroupId == 1 and (cfg.gold or (cfg.sort and cfg.sort.enabled and SortBags))) or (cfg.title and cfg.title.enabled)) then
      addHeight = cfg.extraHeight
    end
    container.frame:SetWidth(container.columns*cfg.iconSize + L.C.containerBackdrop.insets.left + L.C.containerBackdrop.insets.right + cfg.padding*2)
    container.frame:SetHeight(ceil(container.slots / container.columns)*cfg.iconSize + L.C.containerBackdrop.insets.top + L.C.containerBackdrop.insets.bottom + cfg.padding*2 + addHeight)

    local previousRow = container.frame
    local previousItem = nil
    local yOffset = -L.C.containerBackdrop.insets.top - cfg.padding
    local xOffset = L.C.containerBackdrop.insets.left + cfg.padding
    local slotCount = 1

    for i, currentContainer in ipairs(containerIds) do

      if container.items[currentContainer] then
        for containerId, items in pairs(container.items) do
          for slotId = #items, container.containerSlots[containerId]+1, -1 do
            L.M.item.Delete(tremove(items, slotId))
          end
          items = nil
        end
      else
        container.items[currentContainer] = CreateFrame("Frame", nil, container.frame, nil, currentContainer)
        container.items[currentContainer]:SetID(currentContainer)
      end

      for currentSlot = 1, container.containerSlots[currentContainer], 1 do
        if not container.items[currentContainer][currentSlot] then
          container.items[currentContainer][currentSlot] = L.M.item.Create(container.items[currentContainer], cfg, currentContainer, currentSlot)
        end

        if ((slotCount+(cfg.maxColumns-1)) % cfg.maxColumns == 0) then
          if (containerGroupId ~= 1 and currentSlot == 1 and cfg.title and cfg.title.enabled) then
            yOffset = yOffset - cfg.extraHeight
          end
          container.items[currentContainer][currentSlot]:SetPoint("TOPLEFT", previousRow, "TOPLEFT", xOffset, yOffset)
          previousRow = container.items[currentContainer][currentSlot]
          yOffset = -cfg.iconSize
          xOffset = 0
        else
          container.items[currentContainer][currentSlot]:SetPoint("TOPLEFT", previousItem, "TOPRIGHT", 0, 0)
        end

        L.M.item.Update(container.items[currentContainer][currentSlot], currentContainer, currentSlot)
        previousItem = container.items[currentContainer][currentSlot]
        slotCount = slotCount + 1
      end
    end
  end
end

function L.M.container.Delete(container)
  if container then
    for containerId, items in pairs(container.items) do
      for slotId = #items, 1, -1 do
        L.M.item.Delete(tremove(items, slotId))
      end
      items = nil
    end

    container.frame:Hide()
    container.frame:SetParent(nil)
    container.frame:ClearAllPoints()

    tinsert(L.FramePool, container.frame)
  end
end

function L.M.container.DoShow(container)
  if container then
    PlaySound(SOUNDKIT_IG_BACKPACK_OPEN, "SFX")
    container.frame:Show()
  end
end

function L.M.container.DoHide(container)
  if container then
    PlaySound(SOUNDKIT_IG_BACKPACK_CLOSE, "SFX")
    container.frame:Hide()
  end
end

function L.M.container.UpdateCooldowns(container, containerIds)
  if containerIds then
    for i, currentContainer in ipairs(containerIds) do
      for currentSlot = 1, container.containerSlots[currentContainer], 1 do
        if container.items[currentContainer][currentSlot] then
          L.M.item.UpdateCooldown(container.items[currentContainer][currentSlot])
        end
      end
    end
  end
end
