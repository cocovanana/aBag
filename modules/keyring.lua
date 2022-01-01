local A, L = ...

L.M.keyring = CreateFrame("Frame")
L.M.keyring.isInit = false
L.M.keyring.isOpen = false

function L.M.keyring:Init()
  self.container = L.M.container.Create("aKeyring", L.C.keyring, L.C.keyring.containerIds, nil, 1, "Keyring")
  self.isInit = true
end

function L.M.keyring:Update()
  if not self.isInit then
    self:Init()
  end

  L.M.container.Update(self.container, L.C.keyring.containerIds)
end

function L.M.keyring:Toggle()
  if L.M.keyring.isOpen then
    L.M.keyring.isOpen = false
    L.M.container.DoHide(L.M.keyring.container)
  else
    L.M.keyring.isOpen = true
    L.M.container.DoShow(L.M.keyring.container)
  end
end
