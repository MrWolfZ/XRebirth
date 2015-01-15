local function checkFleetManagementSelectable()
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
            "Fleet Management", 
            "Manage your fleets", 
            "gUFO_MenuFleetManagement",
            "mm_ic_info_shipstatus",
            nil, -- sectionParam
            checkFleetManagementSelectable)
	else
		LibMJ = LibMJ or { registerFuncs = {} }
		table.insert(LibMJ.registerFuncs, init)
	end
end

init()