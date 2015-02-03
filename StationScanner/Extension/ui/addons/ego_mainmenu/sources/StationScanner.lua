-- register the new StationScanner menu
local function init()
	if LibMJ and LibMJ.RegisterSidebarMenu then
		-- LibMJ:RegisterSidebarMenu("top", "info", "Station Scanner", "Open Station Scanner", "gStationScanner")
		-- LibMJ:RegisterSidebarMenu("top", "new", "Station Scanner", nil, nil, "mm_ic_info")
		-- LibMJ:RegisterSidebarMenu("top", "Station Scanner", "Station Scanner", "Open Station Scanner", "gStationScanner")
	else
		LibMJ = LibMJ or { registerFuncs = {} }
		table.insert(LibMJ.registerFuncs, init)
	end
end

init()