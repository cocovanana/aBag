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
