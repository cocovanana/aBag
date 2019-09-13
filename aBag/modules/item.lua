local A, L = ...

L.M.item = {}

local unpack, GetContainerItemInfo, GetItemInfo, GetItemClassInfo = unpack, GetContainerItemInfo, GetItemInfo, GetItemClassInfo
local ITEM_QUALITY_COLORS, LE_ITEM_CLASS_QUESTITEM, LE_ITEM_CLASS_WEAPON, LE_ITEM_CLASS_ARMOR = ITEM_QUALITY_COLORS, LE_ITEM_CLASS_QUESTITEM, LE_ITEM_CLASS_WEAPON, LE_ITEM_CLASS_ARMOR

function L.M.item.Create(containerFrame, cfg, currentContainerId, currentSlotId)
  local item = tremove(L.ButtonPool) or CreateFrame("Button", "aItem_"..currentContainerId.."_"..currentSlotId, containerFrame, "ContainerFrameItemButtonTemplate", currentSlotId)
  L.M.item.ClearAllTextures(item)

  item:ClearAllPoints()
  item:SetID(currentSlotId)
  item:SetParent(containerFrame)
  item:SetFrameStrata("MEDIUM")
  item:SetFrameLevel(1)
  item:SetWidth(cfg.iconSize)
  item:SetHeight(cfg.iconSize)
  item:SetPoint("TOPLEFT", 0, 0)
  item:SetBackdrop(L.C.itemBackdrop)
  item:SetBackdropColor(unpack(L.C.itemBackdrop.bgColor))
  item:SetBackdropBorderColor(unpack(L.C.itemBackdrop.borderColor))
  item:SetPushedTexture(L.C.pushedTexture)
  item:Show()

  if not item.texture then
    item.texture = item:CreateTexture(nil, "BACKGROUND", nil, -8)
  end
  item.texture:SetPoint("TOPLEFT", item, "TOPLEFT", L.C.itemBackdrop.insets.left, -L.C.itemBackdrop.insets.top)
  item.texture:SetPoint("BOTTOMRIGHT", item, "BOTTOMRIGHT", -L.C.itemBackdrop.insets.right, L.C.itemBackdrop.insets.bottom)
  item.texture:SetTexCoord(0.1,0.9,0.1,0.9)
  item.texture:Hide()

  if not item.countText then
    item.countText = item:CreateFontString(nil, "BORDER", L.C.fontType)
  end
  item.countText:SetShadowOffset(1,-1)
  item.countText:SetPoint("BOTTOMRIGHT", item, -L.C.itemBackdrop.insets.right, L.C.itemBackdrop.insets.bottom)
  item.countText:Hide()

  if L.C.itemLevelThreshold then
    if not item.level then
      item.level = item:CreateFontString(nil, "BORDER", L.C.fontType)
    end
    item.level:SetShadowOffset(1,-1)
    item.level:SetPoint("TOPLEFT", item, L.C.itemBackdrop.insets.left*2, -L.C.itemBackdrop.insets.top*2)
    item.level:Hide()
  end

  if L.C.itemQualityEnabled or L.C.questColorEnabled then
    if not item.glow then
      item.glow = item:CreateTexture(nil, 'BORDER', nil, 2)
    end
    item.glow:SetPoint("TOPLEFT", item, "TOPLEFT", L.C.itemBackdrop.insets.left, -L.C.itemBackdrop.insets.top)
    item.glow:SetPoint("BOTTOMRIGHT", item, "BOTTOMRIGHT", -L.C.itemBackdrop.insets.right, L.C.itemBackdrop.insets.bottom)
    item.glow:SetTexture(L.C.glowFile)
    item.glow:SetBlendMode("ADD")
    item.glow:SetAlpha(L.C.colorAlpha)
    item.glow:Hide()
  end

  if L.C.junkIconEnabled then
    if not item.junk then
      item.junk = item:CreateTexture(nil, 'BORDER', nil, 1)
    end
    item.junk:SetPoint("TOPLEFT", item, "TOPLEFT", L.C.itemBackdrop.insets.left*2, -L.C.itemBackdrop.insets.top*2)
    item.junk:SetTexture("interface\\moneyframe\\ui-goldicon.blp");
    item.junk:SetScale(0.8)
    item.junk:Hide()
  end

  if not item.selected then
    item.selected = item:CreateTexture(nil, 'BORDER', nil, 2)
  end
  item.selected:SetPoint("TOPLEFT", item, "TOPLEFT", L.C.itemBackdrop.insets.left, -L.C.itemBackdrop.insets.top)
  item.selected:SetPoint("BOTTOMRIGHT", item, "BOTTOMRIGHT", -L.C.itemBackdrop.insets.right, L.C.itemBackdrop.insets.bottom)
  item.selected:SetTexture(L.C.highlightFile)
  item.selected:SetBlendMode("ADD")
  item.selected:SetTexCoord(0.25,0.75,0.25,0.75)
  item.selected:SetVertexColor(unpack(L.C.selectedColor))
  item.selected:SetAlpha(L.C.colorAlpha)
  item.selected:Hide()

  if not item.cooldown  then
    item.cooldown = CreateFrame("Cooldown", nil, item, "aBagCooldown")
  end
  item.cooldown:SetAllPoints()

  item:HookScript("OnEnter", L.M.item.Select)
  item:HookScript("OnLeave", L.M.item.Deselect)

  item.containerId  = currentContainerId
  item.slotId       = currentSlotId

  return item
end

function L.M.item.Delete(item)
  if item then
    item:Hide()
    item:SetParent(nil)
    item:ClearAllPoints()

    tinsert(L.ButtonPool, item)
  end
end

function L.M.item.Update(item, currentContainerId, currentSlotId)
  local itemIcon, itemCount, itemLocked, itemQuality, itemID, itemLevel, itemType, isQuestItem, isGear
  itemIcon, itemCount, itemLocked, itemQuality, _, _, _, _, _, itemID = GetContainerItemInfo(currentContainerId, currentSlotId)

  if itemID then
    _, _, _, itemLevel, _, itemType, _, _, _, _, _, _, _, _, _, _, _ = GetItemInfo(itemID)
    isQuestItem = itemType == GetItemClassInfo(LE_ITEM_CLASS_QUESTITEM)
    isGear = itemType == GetItemClassInfo(LE_ITEM_CLASS_WEAPON) or itemType == GetItemClassInfo(LE_ITEM_CLASS_ARMOR)

    item.texture:SetTexture(itemIcon)
    if (locked) then
      item.texture:SetDesaturated(1)
    else
      item.texture:SetDesaturated(nil)
    end
    item.texture:Show()

    if (itemCount and itemCount > 1) then
      item.countText:SetText(itemCount)
      item.countText:Show()
      item.count = itemCount
    else
      item.countText:SetText("")
      item.countText:Hide()
      item.count = 1
    end

    if L.C.itemLevelThreshold then
      if (isGear and itemLevel >= L.C.itemLevelThreshold) then
        item.level:SetText(itemLevel)
        if L.C.itemLevelQuality then
          item.level:SetTextColor(ITEM_QUALITY_COLORS[itemQuality].r, ITEM_QUALITY_COLORS[itemQuality].g, ITEM_QUALITY_COLORS[itemQuality].b, 1)
        end
        item.level:Show()
      else
        item.level:SetText("")
        item.level:Hide()
      end
    end

    if L.C.itemQualityEnabled or L.C.questColorEnabled then
      if (isQuestItem and L.C.questColorEnabled) then
        item.glow:Show()
        item.glow:SetVertexColor(unpack(L.C.questColor))
      elseif (itemQuality ~= 1 and L.C.itemQualityEnabled) then
        item.glow:Show()
        item.glow:SetVertexColor(ITEM_QUALITY_COLORS[itemQuality].r, ITEM_QUALITY_COLORS[itemQuality].g, ITEM_QUALITY_COLORS[itemQuality].b)
      else
        item.glow:Hide()
      end
    end

    if (itemQuality == 0 and not isGear and L.C.junkIconEnabled) then
      item.junk:Show()
    end

  else
    item.texture:Hide()
    item.countText:Hide()
    if L.C.itemLevelThreshold then
      item.level:Hide()
    end
    if L.C.itemQualityEnabled or L.C.questColorEnabled then
      item.glow:Hide()
    end
    if L.C.junkIconEnabled then
      item.junk:Hide()
    end
  end
end

function L.M.item.UpdateCooldown(item)
  if item and item:GetID() and item:GetParent() then
    local start, duration, enable = GetContainerItemCooldown(item:GetParent():GetID(), item:GetID())
  	if (duration > 0 and enable == 1) then
  		item.cooldown:Show()
      item.cooldown:SetCooldown(start, duration, enable)
  	else
  		item.cooldown:Hide()
  	end
  end
end

function L.M.item.ClearAllTextures(item)
  for k, v in pairs(item) do
    if k ~= 0 and v and type(v) == "table" and v["SetTexture"] then
      v["SetTexture"](v, nil)
    end
  end
  item:SetNormalTexture(nil)
  item:SetHighlightTexture(nil)
  item:SetPushedTexture(nil)
end

function L.M.item.Select(item)
  item.selected:Show()
end

function L.M.item.Deselect(item)
  item.selected:Hide()
end
