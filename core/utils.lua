local A, L = ...
local GetContainerNumSlots = GetContainerNumSlots

L.U = {}

function L.U.SetSlots(target, containerIds)
  target.slots = 0
  target.containerSlots = {}

  for i = 1, #containerIds, 1 do
    target.containerSlots[containerIds[i]] = GetContainerNumSlots(containerIds[i])
    target.slots = target.slots + target.containerSlots[containerIds[i]]
  end

  if (target.slots == 0) then
    target.slots = 1
  end
end

function L.U.SetColumns(target, cfg)
  target.columns = cfg.maxColumns
  if (target.columns > target.slots) then
    if (target.slots > cfg.minColumns) then
      target.columns = target.slots
    else
      target.columns = cfg.minColumns
    end
  end
end

function L.U.Unset(frame, hider)
  frame:UnregisterAllEvents()
  frame:SetScript("OnShow", nil)
  frame:SetParent(hider)
end

function L.U.tprint(tbl, deepLevel, indent)
  if not deepLevel then deepLevel = 1 end
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
      formatting = string.rep("  ", indent) .. k .. ": "
      if type(v) == "table" then
        if deepLevel > indent then
          print(formatting)
          L.U.tprint(v, deepLevel, indent+1)
        else
          print(formatting, 'table')
        end
      else
        print(formatting, v)
      end
    end
end

function L.U.GetPoint(frame)
  if not frame then return end
  local point = {}
  point.a1, point.af, point.a2, point.x, point.y = frame:GetPoint()
  if point.af and point.af:GetName() then
    point.af = point.af:GetName()
  end
  return point
end

function L.U.ResetPoint(frame)
  if not frame then return end
  if not frame.defaultPoint then return end
  if InCombatLockdown() then return end
  local point = frame.defaultPoint
  frame:ClearAllPoints()
  if point.af and point.a2 then
    frame:SetPoint(point.a1 or "CENTER", point.af, point.a2, point.x or 0, point.y or 0)
  elseif point.af then
    frame:SetPoint(point.a1 or "CENTER", point.af, point.x or 0, point.y or 0)
  else
    frame:SetPoint(point.a1 or "CENTER", point.x or 0, point.y or 0)
  end
end

local function OnDragStart(self, button)
  if button == "LeftButton" then
    self:GetParent():StartMoving()
  end
end

local function OnDragStop(self)
  self:GetParent():StopMovingOrSizing()
end

function L.U.CreateDragFrame(parent)
  if not parent then return end

  parent.defaultPoint = L.U.GetPoint(parent)
  table.insert(L.DragFrames, parent)

  local df = CreateFrame("Frame", nil, parent)
  df:SetAllPoints(parent)
  df:SetFrameStrata("HIGH")
  df:EnableMouse(true)
  df:RegisterForDrag("LeftButton")
  df:SetScript("OnDragStart", OnDragStart)
  df:SetScript("OnDragStop", OnDragStop)
  df:Hide()

  local t = df:CreateTexture(nil, "OVERLAY", nil, 6)
  t:SetAllPoints(df)
  t:SetColorTexture(1,1,1)
  t:SetVertexColor(0,1,0)
  t:SetAlpha(0.3)
  df.texture = t

  parent.dragFrame = df
  parent:SetMovable(true)
  parent:SetUserPlaced(true)
end

function L.U.UnlockDrag(str)
  for i, frame in ipairs(L.DragFrames) do
    if frame:IsUserPlaced() then
      if frame.frameVisibility then
        if frame.frameVisibilityFunc then
          UnregisterStateDriver(frame, frame.frameVisibilityFunc)
        end
        RegisterStateDriver(frame, "visibility", "show")
      end
    end
    frame.dragFrame:Show()
  end
  print(str)
end

function L.U.LockDrag(str)
  for i, frame in ipairs(L.DragFrames) do
    if frame:IsUserPlaced() then
      if frame.frameVisibility then
        if frame.frameVisibilityFunc then
          UnregisterStateDriver(frame, "visibility")
          --hack to make it refresh properly, otherwise if you had state n (no vehicle exit button) it would not update properly because the state n is still in place
          RegisterStateDriver(frame, frame.frameVisibilityFunc, "zorkwashere")
          RegisterStateDriver(frame, frame.frameVisibilityFunc, frame.frameVisibility)
        else
          RegisterStateDriver(frame, "visibility", frame.frameVisibility)
        end
      end
    end
    frame.dragFrame:Hide()
  end
  print(str)
end

function L.U.ResetDrag(str)
  if InCombatLockdown() then
    print("|c00FF0000ERROR:|r "..str.." not allowed while in combat!")
    return
  end
  for i, frame in ipairs(L.DragFrames) do
    L.U.ResetPoint(frame)
  end
  print(str)
end
