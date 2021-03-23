local A, L = ...

L.bag = CreateFrame("Frame")

function L.bag:SetupBag()
  L.bag.items = {}

  -- Filter out non-existing slots
  for i = 1, 5 do
    if (GetContainerNumSlots(i-1) > 0) then
      for j = 1 + #L.C.items[i] - GetContainerNumSlots(i-1), #L.C.items[i] do
        table.insert(L.bag.items, L.C.items[i][j])
      end
    end
  end

  L.bag.rows = ceil((#L.bag.items-1)/L.C.bag.maxColumns)
  L.bag.frame = CreateFrame("Frame", "aBagContainer", UIParent, BackdropTemplateMixin and "BackdropTemplate")
  L.bag.frame:SetParent(UIParent)
  L.bag.frame:SetFrameStrata("MEDIUM")
  L.bag.frame:SetFrameLevel(1)
  L.bag.frame:SetWidth(L.C.bag.maxColumns*L.C.iconSize + L.C.backdrop.insets.left + L.C.backdrop.insets.right + L.C.bag.padding)
  L.bag.frame:SetBackdrop(L.C.backdrop)
  L.bag.frame:SetPoint(unpack(L.C.bag.point))
  L.bag.frame:SetBackdropColor(unpack(L.C.backdrop.bgColor))
  L.bag.frame:SetBackdropBorderColor(unpack(L.C.backdrop.borderColor))
  L.bag.frame:SetHeight(L.bag.rows*L.C.iconSize + L.C.backdrop.insets.top + L.C.backdrop.insets.bottom + L.C.bag.padding + L.C.bag.extraHeight)
  L.bag.frame:Hide()

  if (L.C.sort) then
    SetSortBagsRightToLeft(true)
    L.bag.frame.sort = CreateFrame("Button", "aBagSort", L.bag.frame)
    L.bag.frame.sort:SetPoint("BOTTOMLEFT",L. container.frame, L.C.backdrop.insets.right+6, L.C.backdrop.insets.bottom+4)
    L.bag.frame.sort:SetWidth(14)
    L.bag.frame.sort:SetHeight(14)
    L.bag.frame.sort.dot = L.bag.frame.sort:CreateFontString("aBagSortDot", "BORDER", L.C.fontType)
    L.bag.frame.sort.dot:SetShadowOffset(1,-1)
    L.bag.frame.sort.dot:SetAllPoints(L.bag.frame.sort)
    L.bag.frame.sort.dot:SetText("|cff9d9d9d•|r")
    L.bag.frame.sort:RegisterForClicks("AnyUp");
    L.bag.frame.sort:SetScript("OnClick", SortBags)
  end

  -- Reposition slots
  for k, v in pairs(L.bag.items) do
    local posX, posY = L.U.calcPos(k, L.C.bag)
    L.U.exileFrame(v, {"TOPLEFT", L.bag.frame, "TOPLEFT", 1 + L.C.backdrop.insets.left + L.C.bag.padding + L.C.iconSize*posX, -L.C.backdrop.insets.top - L.C.bag.padding - L.C.iconSize*posY})

    -- Create a nice and sleek backdrop for empty bagslots
    v.backdrop = CreateFrame("Frame", "aBagItemBackdrop"..k, v, BackdropTemplateMixin and "BackdropTemplate")
    v.backdrop:SetFrameStrata("MEDIUM")
    v.backdrop:SetFrameLevel(2)
    v.backdrop:SetWidth(L.C.iconSize)
    v.backdrop:SetHeight(L.C.iconSize)
    v.backdrop:SetPoint("TOPLEFT", -L.C.backdrop.insets.left, L.C.backdrop.insets.top)
    v.backdrop:SetBackdrop(L.C.backdrop)
    v.backdrop:SetBackdropColor(unpack(L.C.backdrop.bgColor))
    v.backdrop:SetBackdropBorderColor(unpack(L.C.backdrop.borderColor))
    v.backdrop:Show()
  end

  -- Reposition money
  L.U.exileFrame(ContainerFrame1MoneyFrame, {"BOTTOMRIGHT", L.bag.frame, "BOTTOMRIGHT", L.C.backdrop.insets.right + L.C.bag.padding, L.C.backdrop.insets.bottom + L.C.bag.padding})

  -- Remove blizzard's border for empty bagslots
  for k, v in pairs(L.C.borders) do
    L.U.exileFrame(v)
  end

  -- Show/hide aBag container
  ContainerFrame1:HookScript("OnShow", function(self)
    L.bag.frame:Show()
  end)
  ContainerFrame1:HookScript("OnHide", function(self)
    L.bag.frame:Hide()
  end)
end

function L.bag.OnEvent(self, e, ...)
	local arg1, arg2 = ...
  if (e == "PLAYER_ENTERING_WORLD") then
    self:SetupBag()
    ContainerFrame2Item1.ExtendedSlot:SetPoint("CENTER", ContainerFrame2Item1, "RIGHT", 0, 0)
    local dummy = function() end
    ContainerFrame2Item1.ExtendedSlot.SetPoint = dummy
  end
end

function L.bag:SetupHooks()
  -- Get rid of blizzard bag frames
  L.U.exileFrame(ContainerFrame1)
  L.U.exileFrame(ContainerFrame2)
  L.U.exileFrame(ContainerFrame3)
  L.U.exileFrame(ContainerFrame4)
  L.U.exileFrame(ContainerFrame5)

  -- Usually we'd use ADDON_LOADED, but it loads before blizzard bags after the first login.
  self:RegisterEvent("PLAYER_ENTERING_WORLD")
  self:SetScript("OnEvent", self.OnEvent)
end
