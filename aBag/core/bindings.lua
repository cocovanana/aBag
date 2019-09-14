local A, L = ...

do
	_G['BINDING_HEADER_ABAG'] = "aBag"
	_G['BINDING_NAME_ABAGTOGGLE'] = "aBag Dummy - won't work"
end

function L.SaveBindings()
	local key1, key2 = GetBindingKey("TOGGLEBACKPACK")
	if key1 then
		bindingOne = key1
	elseif key2 then
		bindingOne = key2
	end

	key1, key2 = GetBindingKey("OPENALLBAGS")
	if key1 then
		bindingTwo = key1
	elseif key2 then
		bindingTwo = key1
	end
end

function L.LoadBindings()
  if (bindingOne or bindingTwo) then
		if bindingOne then
			SetOverrideBinding(L.M.bag, true, bindingOne, "ABAGTOGGLE")
		end
		if bindingTwo then
			SetOverrideBinding(L.M.bag, true, bindingTwo, "ABAGTOGGLE")
		end
	else
    StaticPopupDialogs["ABAG_BINDING_REQUEST"] = {
      text = "aBag needs a reload to set your bag bindings. Reload now?",
      button1 = "Yes",
      button2 = "No",
      OnAccept = function()
				L.SaveBindings()
        ReloadUI()
      end,
      timeout = 0,
      whileDead = true,
      hideOnEscape = true,
      preferredIndex = 3,
    }
    StaticPopup_Show("ABAG_BINDING_REQUEST")
  end
end

function aBagToggle()
	L.M.bag:Toggle()
end
