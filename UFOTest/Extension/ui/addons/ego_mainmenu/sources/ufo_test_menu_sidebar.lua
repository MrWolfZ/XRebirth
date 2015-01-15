local function checkMenuSelectable()
  local playerShip = GetPlayerPrimaryShipID()
  local pilot = GetComponentData(playerShip, "pilot")
  return pilot ~= nil
end

-- register the new UFO menu
local function init()
	if LibMJ and LibMJ.RegisterSidebarMenu then
        local mainMenuName = "UFO Test Tools"

		LibMJ:RegisterSidebarMenu(
            "top", 
            "info", 
            mainMenuName, 
            "Spawn some ships for testing", 
            nil, -- section
            "mm_ic_comm_services",
            nil, -- sectionParam
            checkMenuSelectable)
            
		LibMJ:RegisterSidebarMenu(
            "top",
            { "info", mainMenuName },
            "Spawn 2 capital ships for player",
            "", -- description
            "gUFO_Test_Spawn_Player", -- section
            "mm_ic_info_shipstatus", -- icon
            { "XL", 2 }, -- sectionParam
            checkMenuSelectable)
            
		LibMJ:RegisterSidebarMenu(
            "top",
            { "info", mainMenuName },
            "Spawn 10 fighters for player",
            "", -- description
            "gUFO_Test_Spawn_Player", -- section
            "mm_ic_info_shipstatus", -- icon
            { "S", 10 }, -- sectionParam
            checkMenuSelectable)
            
		LibMJ:RegisterSidebarMenu(
            "top",
            { "info", mainMenuName },
            "Spawn 2 capital ships for enemy",
            "", -- description
            "gUFO_Test_Spawn_Enemy", -- section
            "mm_ic_info_shipstatus", -- icon
            { "XL", 2 }, -- sectionParam
            checkMenuSelectable)
            
		LibMJ:RegisterSidebarMenu(
            "top",
            { "info", mainMenuName },
            "Spawn 10 fighters for enemy",
            "", -- description
            "gUFO_Test_Spawn_Enemy", -- section
            "mm_ic_info_shipstatus", -- icon
            { "S", 10 }, -- sectionParam
            checkMenuSelectable)
            
		LibMJ:RegisterSidebarMenu(
            "top",
            { "info", mainMenuName },
            "Spawn 1 station for enemy",
            "", -- description
            "gUFO_Test_SpawnEnemyStation", -- section
            "mm_ic_info_shipstatus", -- icon
            nil, -- sectionParam
            checkMenuSelectable)
	else
		LibMJ = LibMJ or { registerFuncs = {} }
		table.insert(LibMJ.registerFuncs, init)
	end
end

init()