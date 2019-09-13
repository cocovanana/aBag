local A, L = ...

L.FramePool     = {}
L.ButtonPool    = {}
L.SpecialFrames = {}

if L.C.bag and L.C.bag.enabled then
	L.M.bag:SetupHooks()
end

if L.C.bank and L.C.bank.enabled then
	L.M.bank:SetupHooks()
end

if L.C.guild and L.C.guild.enabled then
	L.M.guild:SetupHooks()
end
