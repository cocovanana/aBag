local A, L = ...

L.M.bag = CreateFrame("Frame")
L.M.bag.isInit  = false

function L.M.bag:Init()
  self.containers = {}
  self:GenerateContainerGroups()

  self.isInit = true
end

function L.M.bag:Update()
  if not self.isInit then
    self:Init()
  end

  local previousContainerGroups = self.containerGroups
  self:GenerateContainerGroups()

  for containerGroupId, containerIds in pairs(previousContainerGroups) do
    if not self.containerGroups[containerGroupId] then --unequip last bag of the group
      L.M.container.Delete(self.containers[containerGroupId])
      self.containers[containerGroupId] = nil
    else
      for containerId, container in ipairs(containerIds) do
        if not self.containerGroups[containerGroupId][containerId] then --unequip (not last) bag of group
          for i, item in ipairs(self.containers[containerGroupId].items[container]) do
            L.M.item.Delete(item)
          end
          self.containers[containerGroupId].items[container] = nil
        elseif (self.containerGroups[containerGroupId][containerId] ~= container) then --- swap bags
          for i, item in ipairs(self.containers[containerGroupId].items[container]) do
            L.M.item.Delete(item)
          end
          self.containers[containerGroupId].items[container] = nil
        end
      end
    end
  end

  local lastContainerFrame
  for containerGroupId, containerIds in pairs(self.containerGroups) do
      if not self.containers[containerGroupId] then
        local subClassId = containerGroupId
        local classId = 3 --containers
        if subClassId > 11 then
          subClassId = subClassId-11
          classId = 11 --quivers&co
        end
        self.containers[containerGroupId] = L.M.container.Create("aBag"..containerGroupId, L.C.bag, containerIds, lastContainerFrame, containerGroupId, GetItemSubClassInfo(classId, subClassId))
      end
      lastContainerFrame = self.containers[containerGroupId].frame
  end

  for containerGroupId, container in pairs(self.containers) do
    L.M.container.Update(container, self.containerGroups[containerGroupId], containerGroupId)
    L.M.container.UpdateCooldowns(container, self.containerGroups[containerGroupId])
  end

  if (L.C.keyring and L.C.keyring.enabled) then
    L.M.keyring:Update()
  end

  local oneShown, oneHidden = false, false
  for containerGroupId, container in pairs(self.containers) do
    if container.frame:IsShown() then
      oneShown = true
    else
      oneHidden = true
    end
  end

  if (oneShown and oneHidden) then
    for containerGroupId, container in pairs(self.containers) do
      L.M.container.DoShow(container)
    end
  end
end

function L.M.bag:Toggle()
  if self.containers and self.containers[1] then --main bag controls visibility of all others
    local shown = self.containers[1].frame:IsShown()
    for containerGroupId, container in pairs(self.containers) do
      if shown then
        L.M.container.DoHide(container)
      else
        L.M.container.DoShow(container)
      end
    end
  end

  if L.C.keyring and L.C.keyring.enabled then
    if L.M.keyring.container.frame:IsShown() then
      L.M.container.DoHide(L.M.keyring.container)
    else
      L.M.container.DoShow(L.M.keyring.container)
    end
  end
end

function L.M.bag.OnEvent(self, e, ...)
	local arg1, arg2 = ...
  if (e == "ADDON_LOADED" and arg1 == A) then
    self:Update()
    L.LoadBindings()
  elseif (e == "BAG_OPEN" or e == "TRADE_SHOW" or e == "MERCHANT_SHOW" or e == "TRADE_SKILL_SHOW" or e == "AUCTION_HOUSE_SHOW" or e == "MAIL_SHOW" or e == "BANKFRAME_OPENED" or e == "BANK_BAG_SLOT_FLAGS_UPDATED") then
    for containerGroupId, container in pairs(self.containers) do
      L.M.container.DoShow(container)
    end
    if L.C.keyring and L.C.keyring.enabled then
      L.M.container.DoShow(L.M.keyring.container)
    end
  elseif (e == "BAG_CLOSED" or e == "TRADE_CLOSED" or e == "MERCHANT_CLOSED" or e == "TRADE_SKILL_CLOSE" or e == "AUCTION_HOUSE_CLOSED" or e == "MAIL_CLOSED" or e == "BANKFRAME_CLOSED" or e == "PLAYER_LOGOUT") then
    for containerGroupId, container in pairs(self.containers) do
      L.M.container.DoHide(container)
    end
    if L.C.keyring and L.C.keyring.enabled then
      L.M.container.DoHide(L.M.keyring.container)
    end
	elseif (e == "BAG_UPDATE" or e == "BAG_NEW_ITEMS_UPDATED" or e == "BAG_SLOT_FLAGS_UPDATED" or e == "QUEST_ACCEPTED" or (e == "UNIT_QUEST_LOG_CHANGED" and arg1 == "player")) then
    self:Update()
	elseif (e == "BAG_UPDATE_COOLDOWN") then
    for containerGroupId, container in pairs(self.containers) do
      L.M.container.UpdateCooldowns(container, self.containerGroups[containerGroupId])
    end
    if L.C.keyring and L.C.keyring.enabled then
      L.M.container.UpdateCooldowns(L.M.keyring.container, L.C.keyring.containerIds)
    end
  end
end

function L.M.bag:GenerateContainerGroups()
  self.containerGroups = {}

  local containerLink, containerTypeId, containerSubTypeId, containerGroup

  for i, currentContainer in ipairs(L.C.bag.containerIds) do
    containerGroup = nil
    containerLink = GetInventoryItemLink("player", CONTAINER_BAG_OFFSET+currentContainer)

    if containerLink then
      _, _, _, _, _, _, _, _, _, _, _, containerTypeId, containerSubTypeId, _, _, _, _ = GetItemInfo(containerLink)
      if (containerTypeId and containerSubTypeId) then
        containerGroup = containerTypeId+containerSubTypeId
      else
        containerGroup = 1
      end
    end

    if (currentContainer == 0) then
      containerGroup = 1
    end

    if containerGroup then
      if not self.containerGroups[containerGroup] then
        self.containerGroups[containerGroup] = {}
      end
      table.insert(self.containerGroups[containerGroup], currentContainer)
    end
  end
end

function L.M.bag:SetupHooks()
  self.hider = CreateFrame("Frame")
  self.hider:Hide()

  MainMenuBarBackpackButton:HookScript("OnClick", aBagToggle)

  L.U.Unset(ContainerFrame1, self.hider)
  L.U.Unset(ContainerFrame2, self.hider)
  L.U.Unset(ContainerFrame3, self.hider)
  L.U.Unset(ContainerFrame4, self.hider)
  L.U.Unset(ContainerFrame5, self.hider)

  self:RegisterEvent("ADDON_LOADED")
  self:RegisterEvent("BAG_OPEN")
  self:RegisterEvent("TRADE_SHOW")
  self:RegisterEvent("TRADE_SKILL_SHOW")
  self:RegisterEvent("AUCTION_HOUSE_SHOW")
  self:RegisterEvent('MAIL_SHOW')
  self:RegisterEvent("BAG_CLOSED")
  self:RegisterEvent("TRADE_CLOSED")
  self:RegisterEvent("TRADE_SKILL_CLOSE")
  self:RegisterEvent("AUCTION_HOUSE_CLOSED")
  self:RegisterEvent("MAIL_CLOSED")
  self:RegisterEvent("BAG_UPDATE")
  self:RegisterEvent("BANKFRAME_OPENED")
  self:RegisterEvent("BANKFRAME_CLOSED")
  self:RegisterEvent("ITEM_LOCK_CHANGED")
  self:RegisterEvent("BAG_UPDATE_COOLDOWN")
  self:RegisterEvent("BANK_BAG_SLOT_FLAGS_UPDATED")
  self:RegisterEvent("MERCHANT_SHOW")
  self:RegisterEvent("MERCHANT_CLOSED")
  self:SetScript("OnEvent", self.OnEvent)
end

-- Override standard functions which other addons may use:

ToggleAllBags = function()
  L.M.bag:Toggle()
end

OpenAllBags = function()
  for containerGroupId, container in pairs(L.M.bag.containers) do
    L.M.container.DoShow(container)
  end
  if L.C.keyring and L.C.keyring.enabled then
    L.M.container.DoShow(L.M.keyring.container)
  end
end
