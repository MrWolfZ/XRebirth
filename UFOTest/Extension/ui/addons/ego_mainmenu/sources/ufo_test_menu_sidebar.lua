local function checkMenuSelectable()
  local playerShip = GetPlayerPrimaryShipID()
  local pilot = GetComponentData(playerShip, "pilot")
  return pilot ~= nil
end

-- register the new UFO menu
local function init()
	if LibMJ and LibMJ.RegisterSidebarMenu then
		LibMJ:RegisterSidebarMenu(
            "top", 
            "info", 
            "UFO Test", 
            "Spawn some ships for testing", 
            "gUFO_Test",
            nil, -- icon
            nil, -- sectionParam
            checkMenuSelectable)
	else
		LibMJ = LibMJ or { registerFuncs = {} }
		table.insert(LibMJ.registerFuncs, init)
	end
end

init()