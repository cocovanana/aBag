local A, L = ...

local unpack, GetNumBankSlots = unpack, GetNumBankSlots

L.M.bankSlots = {}

function L.M.bankSlots.Create(name, cfg, bankFrame)
  local slots = {}

  slots.cfg   = cfg
  slots.frame = CreateFrame("Frame", name, UIParent)
  tinsert(UISpecialFrames, name)

  slots.boughtSlots, slots.full = GetNumBankSlots()

  if slots.full then
    slots.canBuy = 0
  else
    slots.canBuy = 1
  end
  if cfg.showAllSlots then
    slots.numSlots = NUM_BANKBAGSLOTS
  else
    slots.numSlots = slots.boughtSlots
  end

  slots.frame:SetFrameStrata("BACKGROUND")
  slots.frame:SetScale(L.C.scale)
  slots.frame:SetWidth((slots.numSlots+slots.canBuy)*cfg.iconSize + L.C.containerBackdrop.insets.left + L.C.containerBackdrop.insets.right + cfg.padding*2)
  slots.frame:SetHeight(cfg.iconSize + L.C.containerBackdrop.insets.top + L.C.containerBackdrop.insets.bottom + cfg.padding*2)
  slots.frame:SetBackdrop(L.C.containerBackdrop)
  slots.frame:SetPoint("TOP"..cfg.anchorSlots, bankFrame, "BOTTOM"..cfg.anchorSlots)
  slots.frame:SetBackdropColor(unpack(L.C.containerBackdrop.bgColor))
  slots.frame:SetBackdropBorderColor(unpack(L.C.containerBackdrop.borderColor))
  slots.frame:Hide()

  slots.bags = {}
  local previousSlot, nextAnchor = slots.frame, "TOPLEFT"
  local yOffset = -L.C.containerBackdrop.insets.top - cfg.padding
  local xOffset = L.C.containerBackdrop.insets.left + cfg.padding

  for i = 1, slots.numSlots, 1 do
    slots.bags[i] = CreateFrame("Button", "aBankSlot"..i, slots.frame, "BankItemButtonBagTemplate", i)
    L.M.item.ClearAllTextures(slots.bags[i])

    slots.bags[i]:SetID(i)
    slots.bags[i]:ClearAllPoints()
    slots.bags[i]:SetParent(slots.frame)
    slots.bags[i]:SetFrameStrata("MEDIUM")
    slots.bags[i]:SetFrameLevel(1)
    slots.bags[i]:SetWidth(cfg.iconSize)
    slots.bags[i]:SetHeight(cfg.iconSize)
    slots.bags[i]:SetPoint("TOPLEFT", previousSlot, nextAnchor, xOffset, yOffset)
    slots.bags[i]:SetBackdrop(L.C.itemBackdrop)
    slots.bags[i]:SetBackdropBorderColor(unpack(L.C.itemBackdrop.borderColor))
    slots.bags[i]:SetPushedTexture(L.C.pushedTexture)
    slots.bags[i]:Show()

    slots.bags[i]:HookScript("OnEnter", L.M.item.Select)
    slots.bags[i]:HookScript("OnLeave", L.M.item.Deselect)

    slots.bags[i].texture = slots.bags[i]:CreateTexture(nil, "BACKGROUND", nil, -8)
    slots.bags[i].texture:SetPoint("TOPLEFT", slots.bags[i], "TOPLEFT", L.C.itemBackdrop.insets.left, -L.C.itemBackdrop.insets.top)
    slots.bags[i].texture:SetPoint("BOTTOMRIGHT", slots.bags[i], "BOTTOMRIGHT", -L.C.itemBackdrop.insets.right, L.C.itemBackdrop.insets.bottom)
    slots.bags[i].texture:SetTexCoord(0.1,0.9,0.1,0.9)
    slots.bags[i].texture:Hide()

    slots.bags[i].selected = slots.bags[i]:CreateTexture(nil, 'BORDER', nil, 2)
    slots.bags[i].selected:SetPoint("TOPLEFT", slots.bags[i], "TOPLEFT", L.C.itemBackdrop.insets.left, -L.C.itemBackdrop.insets.top)
    slots.bags[i].selected:SetPoint("BOTTOMRIGHT", slots.bags[i], "BOTTOMRIGHT", -L.C.itemBackdrop.insets.right, L.C.itemBackdrop.insets.bottom)
    slots.bags[i].selected:SetTexture(L.C.highlightFile)
    slots.bags[i].selected:SetBlendMode("ADD")
    slots.bags[i].selected:SetTexCoord(0.25,0.75,0.25,0.75)
    slots.bags[i].selected:SetVertexColor(unpack(L.C.selectedColor))
    slots.bags[i].selected:SetAlpha(L.C.colorAlpha)
    slots.bags[i].selected:Hide()

    previousSlot, nextAnchor = slots.bags[i], "TOPRIGHT"
    yOffset, xOffset = 0, 0
  end

  if not slots.full then
    slots.buy = CreateFrame("Frame", "aBankBuy", slots.frame)
    slots.buy:ClearAllPoints()
    slots.buy:SetParent(slots.frame)
    slots.buy:SetFrameStrata("MEDIUM")
    slots.buy:SetFrameLevel(1)
    slots.buy:SetWidth(cfg.iconSize)
    slots.buy:SetHeight(cfg.iconSize)

    if (not cfg.showAllSlots and slots.boughtSlots > 0) then
      slots.buy:SetPoint("TOPLEFT", previousSlot, nextAnchor)
    else
      slots.buy:SetPoint("TOPLEFT", previousSlot, nextAnchor, L.C.containerBackdrop.insets.left + cfg.padding, -L.C.containerBackdrop.insets.top - cfg.padding)
    end

    slots.buy.price = slots.buy:CreateFontString("aBankBuyPrice", "BORDER", L.C.fontType)
    slots.buy.price:SetShadowOffset(1,-1)
    slots.buy.price:SetPoint("BOTTOM", slots.buy, "BOTTOM", -1, 3)
    slots.buy.price:SetText(GetCoinTextureString(GetBankSlotCost(i)))
    slots.buy.price:Show()

    slots.buy.button = CreateFrame("Button", "aBankBuyButton", slots.buy)
    L.M.item.ClearAllTextures(slots.buy.button)

    slots.buy.button:ClearAllPoints()
    slots.buy.button:SetParent(slots.buy)
    slots.buy.button:SetFrameStrata("MEDIUM")
    slots.buy.button:SetFrameLevel(1)
    slots.buy.button:SetWidth(cfg.iconSize)
    slots.buy.button:SetHeight(cfg.iconSize/2)
    slots.buy.button:SetPoint("TOP", slots.buy, "TOP")
    slots.buy.button:SetBackdrop(L.C.itemBackdrop)
    slots.buy.button:SetBackdropColor(unpack(L.C.itemBackdrop.bgColor))
    slots.buy.button:SetBackdropBorderColor(unpack(L.C.itemBackdrop.borderColor))
    slots.buy.button:SetPushedTexture(L.C.pushedTexture)
    slots.buy.button:Show()

    slots.buy.button.text = slots.buy.button:CreateFontString("aBankBuyButtonText", "BORDER", L.C.fontType)
    slots.buy.button.text:SetShadowOffset(1,-1)
    slots.buy.button.text:SetPoint("CENTER", slots.buy.button, "CENTER")
    slots.buy.button.text:SetText("+")
    slots.buy.button.text:Show()

    slots.buy.button.selected = slots.buy:CreateTexture(nil, 'BORDER', nil, 2)
    slots.buy.button.selected:SetPoint("TOPLEFT", slots.buy.button, "TOPLEFT", L.C.itemBackdrop.insets.left, -L.C.itemBackdrop.insets.top)
    slots.buy.button.selected:SetPoint("BOTTOMRIGHT", slots.buy.button, "BOTTOMRIGHT", -L.C.itemBackdrop.insets.right, L.C.itemBackdrop.insets.bottom)
    slots.buy.button.selected:SetTexture(L.C.highlightFile)
    slots.buy.button.selected:SetBlendMode("ADD")
    slots.buy.button.selected:SetTexCoord(0.25,0.75,0.25,0.75)
    slots.buy.button.selected:SetVertexColor(unpack(L.C.selectedColor))
    slots.buy.button.selected:SetAlpha(L.C.colorAlpha)
    slots.buy.button.selected:Hide()

    slots.buy.button:HookScript("OnEnter", L.M.item.Select)
    slots.buy.button:HookScript("OnLeave", L.M.item.Deselect)
    slots.buy.button:HookScript("OnClick", L.M.bankSlots.BuyBankSlot)
  end

  return slots
end

function L.M.bankSlots.Update(slots)
  local slotItemID
  for i = 1, slots.numSlots, 1 do
    slotItemID = GetInventoryItemID("player", 71+i) -- bank frame slots start at 72 (classic) and 76 (retail)
    if slotItemID then
      slots.bags[i].texture:SetTexture(select(10, GetItemInfo(slotItemID)))
      slots.bags[i].texture:Show()
    else
      slots.bags[i].texture:Hide()
    end

    if (i > GetNumBankSlots()) then
      slots.bags[i]:SetBackdropColor(1, 0.1, 0.1, 0.2)
      slots.bags[i].tooltipText = BANK_BAG_PURCHASE
    else
      slots.bags[i]:SetBackdropColor(unpack(L.C.itemBackdrop.bgColor))
      slots.bags[i].tooltipText = BANK_BAG
    end
  end

  if slots.full then
    slots.frame:SetWidth(slots.numSlots*cfg.iconSize + L.C.containerBackdrop.insets.left + L.C.containerBackdrop.insets.right + cfg.padding*2)
    slots.buy:Hide()
  else
    if (L.C.bank.showAllSlots or slots.boughtSlots > 0) then
      slots.buy:SetPoint("TOPLEFT", slots.bags[slots.numSlots], "TOPRIGHT", 0, 0)
    end
    slots.buy:Show()
  end
end

function L.M.bankSlots.BuyBankSlot()
  local numSlots, full = GetNumBankSlots()
  if not full then
    PurchaseSlot()
  end
end
