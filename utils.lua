local A, L = ...
local unpack = unpack

L.U = {}

local dummy = function() end

function L.U.calcPos(index, cfg)
  return (index-1) % cfg.maxColumns, math.floor((index-1) / cfg.maxColumns)
end

function L.U.exileFrame(frame, point)
  frame:ClearAllPoints()
  frame:SetPoint(unpack(point or {"BOTTOMRIGHT", UIParent, "TOPLEFT"}))
  frame.ClearAllPoints = dummy
  frame.SetPoint = dummy
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
