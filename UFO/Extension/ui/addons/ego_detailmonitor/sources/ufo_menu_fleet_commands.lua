--[[
	This file is part of the X Rebirth UFO mod.
	
	Author: MadJoker
  
	Last Change:
	Version: V0.6.1 Beta
	Date: 3rd February 2015
  
	X Rebirth version: 3.20
--]]

-- persistent state
local Functions, Buttons = {}, {}

-- register the new UFO menu
local function init()
	if LibMJ and LibMJ.RegisterMenu then
		LibMJ:RegisterMenu("UFOChooseFleetCommand", 
							Functions.onMenuInit, 
							Functions.onMenuClosed, 
							Functions.onReturnArgsReceived, 
							Functions.titleProvider, 
							Functions.rowProvider)
	else
		LibMJ = LibMJ or { registerFuncs = {} }
		table.insert(LibMJ.registerFuncs, init)
	end
end

Functions.onMenuInit = function (state, fleet, playerShips)
	state.title = ReadText(99998,20) .. " '" .. fleet.name .. "'" -- "Choose Command for Fleet '%s'"
	state.fleet = fleet
	state.playerShips = playerShips
end

Functions.onMenuClosed = function (state)
	return state.returnArgs or {}
end

Functions.onReturnArgsReceived = function (state, closeAll, returnArgs)
	if state.subMenu == "EscortShip" then
		-- we expect to find a ship in the return args
		local ships = returnArgs[1]
		if ships and #ships > 0 then
			state.returnArgs = { UFO.command.escortShip, ships[1] }
			LibMJ:CloseMenu()
			return false
		end
		
		state.subMenu = nil
	end
	if state.subMenu == "MoveToZone" then
		-- we expect to find a zone in the return args
		local zones = returnArgs[1]
		if zones and #zones > 0 then
			state.returnArgs = { UFO.command.moveToZone, zones[1] }
			LibMJ:CloseMenu()
			return false
		end
		
		state.subMenu = nil
	end
	
	return true
end

Functions.titleProvider = function (state)
	return state.title
end

Functions.rowProvider = function (state, rowCollection)
	local buttonFontSize = 12

	local emptyRow = LibMJ:Row({ LibMJ:Cell(nil, nil, 3) }, nil, LibMJ.colors.transparent, true)
	
	table.insert(rowCollection, emptyRow)
	
	local cells = { LibMJ:Cell() }
	
	local escortShipButtonLabel = UFO.command.escortShip.label
	local escortShipButtonScript = function() Buttons.selectEscortShip(state) end
	local escortShipButtonSelectable = #Functions.getShipsForEscort(state) > 0
	table.insert(cells, LibMJ:ButtonCell(escortShipButtonLabel, escortShipButtonScript, 1, escortShipButtonSelectable, nil, buttonFontSize))	
	
	table.insert(cells, LibMJ:Cell())
	table.insert(rowCollection, LibMJ:Row(cells, nil, LibMJ.colors.transparent, true))
	
	table.insert(rowCollection, emptyRow)
	
	cells = { LibMJ:Cell() }
	
	local moveToZoneButtonLabel = UFO.command.moveToZone.label
	local moveToZoneButtonScript = function() Buttons.selectZoneForMove(state) end
	table.insert(cells, LibMJ:ButtonCell(moveToZoneButtonLabel, moveToZoneButtonScript, 1, true, nil, buttonFontSize))
	
	table.insert(cells, LibMJ:Cell())
	table.insert(rowCollection, LibMJ:Row(cells, nil, LibMJ.colors.transparent, true))
	
	local colWidths = { 20, 150, 0 }
	return colWidths
end

Functions.getShipsForEscort = function (state)
	-- filter out all ships in this fleet and ships of size XS, but allow playership to be escorted
	local ships = { GetPlayerPrimaryShipID() }
	local fleet = state.fleet
	
	-- we can do a quick heuristic check to see if there are ships at all
	if #state.playerShips > #fleet.ships then
		-- only allow ships to be selected that are not already in the fleet
		for _, ship in ipairs(state.playerShips) do
			local isDrone = IsComponentClass(ship, "ship_xs")
			if not fleet.shipsById[tostring(ship)] and not isDrone then
				table.insert(ships, ship)
			end
		end
	end
	
	return ships
end

Buttons.selectEscortShip = function (state)
	state.subMenu = "EscortShip"
	local title = ReadText(99998,21) -- "Choose Ship to Escort"
	local ships = Functions.getShipsForEscort(state)
	
    local commanderIsFighter = IsComponentClass(state.fleet.commander, "ship_s") or IsComponentClass(state.fleet.commander, "ship_m")

    -- we disallow fighter fleets escorting fighter fleets, since this will screw up formations
    local shipDescriptors = {}
    local notSupportedYetLabel = ReadText(99998,9001) -- "not supported yet"
    for _, ship in ipairs(ships) do
        local shipIsFighter = IsComponentClass(ship, "ship_s") or IsComponentClass(ship, "ship_m")
        table.insert(shipDescriptors, { 
            ship = ship, 
            selectable = not commanderIsFighter or not shipIsFighter,
            additionalLabel = commanderIsFighter and shipIsFighter and "(" .. notSupportedYetLabel .. ")"
        })
    end

	LibMJ:OpenMenu("LibMJ_ShipSelection",nil,title,shipDescriptors)
end

Buttons.selectZoneForMove = function (state)
	state.subMenu = "MoveToZone"
	local title = ReadText(99998,22) -- "Choose Target Zone"
	local fleetCluster, fleetSector = GetComponentData(state.fleet.commander, "clusterid", "sectorid")
	local preExtended = { fleetCluster, fleetSector }
	
	LibMJ:OpenMenu("LibMJ_ZoneSelection", nil, title, false, preExtended)
end

init()