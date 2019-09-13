local A, L = ...

L.M.bank = CreateFrame("Frame")
L.M.bank.isInit = false

function L.M.bank:Init()
  self.container = L.M.container.Create("aBank", L.C.bank, L.C.bank.containerIds, nil, 1, "Bank")
  self.bankSlots = L.M.bankSlots.Create("aBankSlots", L.C.bank, self.container.frame)
  self.container.frame:HookScript("OnHide", CloseBankFrame)

  self.isInit = true
end

function L.M.bank:Update()
  if not self.isInit then
    self:Init()
  end

  L.M.bankSlots.Update(self.bankSlots)
  L.M.container.Update(self.container, L.C.bank.containerIds, 1)
end

function L.M.bank.OnEvent(self, e, ...)
	local arg1, arg2 = ...
  if (e == "BANKFRAME_OPENED") then
    self:Update()
    L.M.container.DoShow(self.container)
    self.bankSlots.frame:Show()
    self:Rehook()
  elseif (e == "BANKFRAME_CLOSED") then
    L.M.container.DoHide(self.container)
    self.bankSlots.frame:Hide()
    self:Unhook()
  elseif (e == "BAG_UPDATE" or e == "BAG_CLOSED" or e == "PLAYERBANKBAGSLOTS_CHANGED" or e == "PLAYERBANKSLOTS_CHANGED" or e == "PLAYERBANKBAGSLOTS_CHANGED" or e == "BANK_BAG_SLOT_FLAGS_UPDATED" or e == "ITEM_LOCK_CHANGED") then
    for bagContainerGroupId, bagContainer in pairs(L.M.bag.containers) do
      L.M.container.DoShow(bagContainer)
    end
    if L.C.keyring and L.C.keyring.enabled then
      L.M.container.DoShow(L.M.keyring.container)
    end
    self:Update()
  end
end

function L.M.bank:SetupHooks()
  self.hider = CreateFrame("Frame", "aBankHider")
  self.hider:Hide()

  L.U.Unset(BankFrame, self.hider)

  self:RegisterEvent("BANKFRAME_OPENED", "OnEvent")
  self:RegisterEvent("BANKFRAME_CLOSED", "OnEvent")
  self:SetScript("OnEvent", self.OnEvent)
end

function L.M.bank:Rehook()
  self:RegisterEvent("BAG_UPDATE", "OnEvent")
  self:RegisterEvent("BAG_CLOSED", "OnEvent")
  self:RegisterEvent("ITEM_LOCK_CHANGED", "OnEvent")
  self:RegisterEvent("PLAYERBANKSLOTS_CHANGED", "OnEvent")
  self:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED", "OnEvent")
  self:RegisterEvent("BANK_BAG_SLOT_FLAGS_UPDATED", "OnEvent")
end

function L.M.bank:Unhook()
  self:UnregisterEvent("BAG_UPDATE")
  self:UnregisterEvent("BAG_CLOSED")
  self:UnregisterEvent("ITEM_LOCK_CHANGED")
  self:UnregisterEvent("PLAYERBANKSLOTS_CHANGED")
  self:UnregisterEvent("PLAYERBANKBAGSLOTS_CHANGED")
  self:UnregisterEvent("BANK_BAG_SLOT_FLAGS_UPDATED")
end
