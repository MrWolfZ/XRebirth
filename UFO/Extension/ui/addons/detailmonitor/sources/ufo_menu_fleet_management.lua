-- global UFO info container
UFO = {}

UFO.stances = {
	aggressionLevel = {
		passive = {
			key = "passive", -- constant defined in md.UFO
			label = ReadText(99998,1000)
		},
		defensive = {
			key = "defensive", -- constant defined in md.UFO
			label = ReadText(99998,1001)
		},
		aggressive = {
			key = "aggressive", -- constant defined in md.UFO
			label = ReadText(99998,1002)
		},
	},
	formationMode = {
		doBreak = {
			key = "break", -- constant defined in md.UFO
			label = ReadText(99998,1003)
		},
		noBreak = {
			key = "noBreak", -- constant defined in md.UFO
			label = ReadText(99998,1004)
		}
	}
}

UFO.stances.aggressionLevels = {
	[UFO.stances.aggressionLevel.passive.key] = UFO.stances.aggressionLevel.passive,
	[UFO.stances.aggressionLevel.defensive.key] = UFO.stances.aggressionLevel.defensive,
	[UFO.stances.aggressionLevel.aggressive.key] = UFO.stances.aggressionLevel.aggressive
}

UFO.stances.formationModes = {
	[UFO.stances.formationMode.doBreak.key] = UFO.stances.formationMode.doBreak,
	[UFO.stances.formationMode.noBreak.key] = UFO.stances.formationMode.noBreak,
}

UFO.command = {
	escortShip = {
		key = "escort",
		label = ReadText(99998,101), -- "Escort Ship"
		formattedLabel = function (args) return "Escort Ship " .. GetComponentData(args[1], "name") end
	},
	moveToZone = {
		key = "moveToZone",
		label = ReadText(99998,102), -- "Move to Zone"
		formattedLabel = function (args) return "Move to Zone " .. GetComponentData(args[1], "name") end
	}
}

UFO.commands = {
	[UFO.command.escortShip.key] = UFO.command.escortShip,
	[UFO.command.moveToZone.key] = UFO.command.moveToZone
}

UFO.debugLevel = {
	error = {
		id = 0,
		label = ReadText(99997,9002) -- "Error"
	},
	info = {
		id = 1,
		label = ReadText(99997,9003) -- "Info"
	},
	fine = {
		id = 2,
		label = ReadText(99997,9004) -- "Fine"
	},
	finest = {
		id = 3,
		label = ReadText(99997,9005) -- "Finest"
	}
}

UFO.debugLevels = {
	[0] = UFO.debugLevel.error,
	[1] = UFO.debugLevel.info,
	[2] = UFO.debugLevel.fine,
	[3] = UFO.debugLevel.finest
}

UFO.debugLevel.selected = UFO.debugLevel.error

-- persistent state
local Functions, Buttons, ExpandedFleets = {}, {}, {}

-- temporary state
local Fleets, FleetsById, ShipsToFleetId, PlayerShips, StateContainers = nil

-- register the new UFO menu
local function init()
	if LibMJ and LibMJ.RegisterMenu then
		LibMJ:RegisterMenu("UFOFleetManagement", 
							Functions.onMenuInit, 
							Functions.onMenuClosed, 
							Functions.onReturnArgsReceived, 
							Functions.titleProvider, 
							Functions.rowProvider, 
							{ type = "buttons", provider = Functions.buttonProvider })
	else
		LibMJ = LibMJ or { registerFuncs = {} }
		table.insert(LibMJ.registerFuncs, init)
	end
end

Functions.onMenuInit = function (state, params)
	-- only act if not yet initialized
	if Fleets then
		return
	end
	
	local fleetIds = params[1]
	local fleetNames = params[2]
	local fleetCommanders = params[3]
	local fleetShips = params[4]
	local fleetCurrentCommands = params[5]
	PlayerShips = params[6] or {}
	local stateContainers = params[7]
	UFO.copilot = params[8]
	UFO.debugLevel.selected = UFO.debugLevels[params[9]]
	
	Fleets = {}
	FleetsById = {}
	ShipsToFleetId = {}
	
	for i, fleetId in ipairs(fleetIds) do
		local shipsById = {}
		for _, ship in ipairs(fleetShips[i]) do
			shipsById[tostring(ship)] = ship
			ShipsToFleetId[tostring(ship)] = fleetId
		end
		local fleet = {
			id = fleetId,
			name = fleetNames[i],
			ships = fleetShips[i],
			shipsById = shipsById,
			commander = fleetCommanders[i],
			command = UFO.commands[fleetCurrentCommands[i][1]],
			commandArgs = fleetCurrentCommands[i][2]
		}
		FleetsById[fleetId] = fleet
	end
	
	-- make sure fleets are sorted by id
	for _, fleetId in ipairs(Helper.orderedKeys(FleetsById)) do	
		table.insert(Fleets, FleetsById[fleetId])
	end
	
	StateContainers = {}
	for _, pair in ipairs(stateContainers) do
		local entity = pair[1]
		local keys = pair[2][1]
		local values = pair[2][2]
		
		for i, key in ipairs(keys) do
			Functions.setNPCState(state, entity, key, values[i])
		end
	end
end

Functions.onMenuClosed = function (state)
	ExpandedFleets = {}

	-- TODO: verify if fleet indices are stable and synchronized with display order in list
	-- store the currently expanded fleets
	for i, expandState in ipairs(state.expandStates) do
		ExpandedFleets[i] = expandState.expanded
	end

	local fleetIds = {}
	local fleetNames = {}
	local fleetCommanders = {}
	local fleetShips = {}
	local fleetCurrentCommands = {}
	
	-- we sort the fleets by ids, and then normalize the ids
	for i, fleetId in ipairs(Helper.orderedKeys(FleetsById)) do
		local fleet = FleetsById[fleetId]
		table.insert(fleetIds, i)
		table.insert(fleetNames, fleet.name)
		table.insert(fleetCommanders, fleet.commander)
		table.insert(fleetShips, fleet.ships)
		table.insert(fleetCurrentCommands, { fleet.command.key, fleet.commandArgs })
	end
	
	local stateContainers = {}
	for _, entityState in pairs(StateContainers) do
		local entity = entityState.entity
		local container = entityState.container
		local keys = {}
		local values = {}
		for key, value in pairs(container) do
			table.insert(keys, key)
			table.insert(values, value)
		end
		table.insert(stateContainers, { entity, { keys, values } })
	end
	
	-- clean up our state
	Fleets = nil
	FleetsById = nil
	PlayerShips = nil
	StateContainers = nil
	ShipsToFleetId = nil
	
	if UFO.uninstall then
		return { "UFOUninstall" }
	end
	
	return { fleetIds, fleetNames, fleetCommanders, fleetShips, fleetCurrentCommands, stateContainers, UFO.debugLevel.selected.id }
end

Functions.onReturnArgsReceived = function(state, isClosingAll, returnArgs)	
	-- check for the specific sub menu
	if state.subMenu == "CreateFleet" then
		-- we expect to find a name in the return args		
		local fleetName = returnArgs[1]
		
		-- if no return value was present, user must have canceled
		if fleetName then
			state.newFleetName = fleetName
			
			state.subMenu = "ChooseCommander"
			
			-- we can then open the ship selection menu
			local title = ReadText(99998,23) .. " '" .. fleetName .. "'" -- "Choose Commander for Fleet '%s'"
			local ships = Functions.getUnassignedShips()			
			local chooseMultiple = false
			
            -- let the menu know fighters are not yet supported as fleet commanders
            local shipDescriptors = {}
            local smallShipLabel = ReadText(99998,9001)
            for _, ship in ipairs(ships) do
                local isCap = IsComponentClass(ship, "ship_l") or IsComponentClass(ship, "ship_xl")
                table.insert(shipDescriptors, { 
                    ship = ship, 
                    selectable = true
                })
            end

			LibMJ:OpenMenu("LibMJ_ShipSelection", nil, title, shipDescriptors, chooseMultiple)
			
			-- don't reopen this menu
			return false
		else
			state.subMenu = nil
		end
	end
	if state.subMenu == "ChooseCommander" then		
		local ships = returnArgs[1]
		local fleetName = state.newFleetName
		state.newFleetName = nil
		
		-- if a ship was returned, we can create the fleet
		if ships and #ships > 0 then
			local ship = ships[1]
			
			-- compute a new fleet ID
			local newId = 1
			local orderedIds = Helper.orderedKeys(FleetsById)
			local maxId = orderedIds[#orderedIds]
			if maxId ~= nil then
				newId = maxId + 1
			end
		
			local fleet = {
				id = newId,
				name = fleetName,
				ships = { ship },
				shipsById = { [tostring(ship)] = ship },
				commander = ship,
				command = UFO.command.moveToZone,
				commandArgs = { GetComponentData(ship, "zoneid") }
			}
				
			-- now, we can finalize the fleet
			table.insert(Fleets, fleet)
			FleetsById[fleet.id] = fleet
			ShipsToFleetId[tostring(ship)] = fleet.id
			
			-- we also update the state container for all NPCs on the ship
			for _, npc in ipairs(Functions.getNPCsOnShip(state, ship)) do
				Functions.setNPCState(state, npc, "iFleetId", fleet.id)
					
				-- we set the stance for the NPC, if it does not yet have a stance
				if not Functions.getStanceForNPC(state, npc) then
					Functions.broadcastStanceToNPC(state, npc, UFO.stances.aggressionLevel.defensive, UFO.stances.formationMode.doBreak, 10000)
				end					
			end
			
			state.subMenu = nil
		else
			-- otherwise, we have to reopen the naming menu
			Buttons.createNewFleet(state, nil, nil, fleetName)
			
			-- don't reopen this menu
			return false
		end
	end
	if state.subMenu == "AddShips" then
		-- we expect to find a ship list in the return args
		local ships = returnArgs[1]
		if ships then
			local fleet = state.selectedFleet
			
			-- as the target stance, we use the commander's stance
			local npcs = Functions.getNPCsOnShip(state, fleet.commander)
			local aggressionLevel, formationMode, engageDist = Functions.getStanceForNPC(state, npcs[1])
			
			local parentRowIdx = state.fleetToRowIdx[fleet.id]
			LibMJ:AddRows(parentRowIdx, #ships, true)
			
			for _, ship in ipairs(ships) do
				table.insert(fleet.ships, ship)
				ShipsToFleetId[tostring(ship)] = fleet.id
			
				-- we also update the state container for all NPCs on the ship
				for _, npc in ipairs(Functions.getNPCsOnShip(state, ship)) do
					Functions.setNPCState(state, npc, "iFleetId", fleet.id)
					
					-- we set the stance for the NPC, if it does not yet have a stance
					if not Functions.getStanceForNPC(state, npc) then
						Functions.broadcastStanceToNPC(state, npc, aggressionLevel, formationMode, engageDist)
					end					
				end
			end
		end
		
		state.subMenu = nil
		state.selectedFleet = nil
	end	
	if state.subMenu == "BroadcastStance" then
		if #returnArgs > 0 then
			if state.broadcastTargetNPC then
				Functions.broadcastStanceToNPC(state, state.broadcastTargetNPC, unpack(returnArgs))
			end
			if state.broadcastTargetShip then
				Functions.broadcastStanceToShip(state, state.broadcastTargetShip, unpack(returnArgs))
			end
			if state.broadcastTargetFleet then
				Functions.broadcastStanceToFleet(state, state.broadcastTargetFleet, unpack(returnArgs))
			end
		end
	
		state.broadcastTargetFleet = nil
		state.broadcastTargetShip = nil
		state.broadcastTargetNPC = nil
	end
	if state.subMenu == "ChooseFleetCommand" then
		-- we expect to find a fleet command in the return args
		local command = returnArgs[1]
		if command then
			local fleet = state.selectedFleet
			
			-- now, we "switch" on the selected command
			if command == UFO.command.escortShip then
				-- we fetch the ship to escort
				local ship = returnArgs[2]
				
				fleet.command = UFO.command.escortShip
				fleet.commandArgs = { ship }
			elseif command == UFO.command.moveToZone then
				-- we fetch the target zone
				local zone = returnArgs[2]
				
				fleet.command = UFO.command.moveToZone
				fleet.commandArgs = { zone }
			end
		end
		
		state.subMenu = nil
		state.selectedFleet = nil
	end
	
	-- we check if the unistallation flag was set
	if UFO.uninstall then
		LibMJ:CloseMenu()
		return false
	end
	
	-- we want to keep the menu open
	return true
end

Functions.titleProvider = function (state)
	local title = ReadText(99998, 1) -- Fleet Management
	local infoMenu = "UFOConfiguration"
	local infoMenuArgs = {}
	return title, infoMenu, infoMenuArgs
end

Functions.rowProvider = function (state, rowCollection)
	state.fleetToRowIdx = {}
	if #Fleets > 0 then
		for i, fleet in ipairs(Fleets) do	
			local ships = fleet.ships
			local isExpanded = LibMJ:IsExpanded(#rowCollection + 1) or ExpandedFleets[i]
			
			local rowData = { ["Fleet"] = fleet, ["ValidForBroadcastStance"] = true }
			local cells = {}
			
			-- create "expand fleet" button
			local fleetExpandButtonLabel = (isExpanded and "-") or "+"
			local fleetExpandScript = function (rowIdx, colIdx)
				LibMJ:ToggleRow(rowIdx)
			end
			table.insert(cells, LibMJ:ButtonCell(fleetExpandButtonLabel, fleetExpandScript, 1, #ships > 0))
			
			local fleetLabel = fleet.name .. " (" .. #ships .. ")"
			table.insert(cells, LibMJ:Cell(fleetLabel, nil, (fleet.id ~= 1 and 3) or 5))
			
			-- we show fleet commands only for non-player fleets
			if fleet.id ~= 1 then
				local currentCommandLabel = ReadText(99998,103) .. ": " .. fleet.command.formattedLabel(fleet.commandArgs) -- Command: <label>
				table.insert(cells, LibMJ:Cell(currentCommandLabel, nil, 2))
			end
			
			local issueCommandButtonLabel = ReadText(99998,103) -- "Command"
			local issueCommandButtonScript = function (rowIdx, colIdx)
				Buttons.issueCommand(state, fleet)
			end
			table.insert(cells, LibMJ:ButtonCell(issueCommandButtonLabel, issueCommandButtonScript, 1, fleet.id ~= 1))
			
			-- create "add ships" button
			local addShipsButtonScript = function (rowIdx, colIdx)
				Buttons.openAddShipsMenu(state, fleet) 
			end
			table.insert(cells, LibMJ:ButtonCell("+", addShipsButtonScript, 1, #Functions.getUnassignedShips() > 0, LibMJ.colors.green, 24))
			
			-- create "delete fleet" button (player fleet (ID 1) cannot be deleted)
			local deleteFleetScript = function (rowIdx, colIdx)
				table.remove(Fleets, LibMJ.indexOf(Fleets, fleet, function (f1, f2) return f1.id == f2.id end))
				FleetsById[fleet.id] = nil
				for _, ship in ipairs(fleet.ships) do
					ShipsToFleetId[tostring(ship)] = nil
					for _, npc in ipairs(Functions.getNPCsOnShip(state, ship)) do
						Functions.setNPCState(state, npc, "iFleetId", -1)
					end
				end
				
				LibMJ:RemoveRow(rowIdx)
			end
			table.insert(cells, LibMJ:ButtonCell("X", deleteFleetScript, 1, fleet.id ~= 1, LibMJ.colors.red, nil, true))
			
			local nrOfChildRows = #ships
			table.insert(rowCollection, LibMJ:Row(cells, rowData, Helper.defaultHeaderBackgroundColor, false, nrOfChildRows))

		    -- we expand the fleets according to the saved state every time the fleet management menu is opened
		    if ExpandedFleets[i] then
			    LibMJ:ExpandRow(#rowCollection, true)
		    end
			
			state.fleetToRowIdx[fleet.id] = #rowCollection
			
			-- if fleet is expanded, add line per ship
			if isExpanded then
				for _, ship in ipairs(ships) do					
					local shipName, pilot, defencenpc, engineer = GetComponentData(ship, "name", "pilot", "defencenpc", "engineer")
					local shipExpandKey = fleet.id .. "-" .. tostring(ship)
					local isExpanded = LibMJ:IsExpanded(#rowCollection + 1)
					local isCommander = tostring(ship) == tostring(fleet.commander)
					local isPlayer = tostring(ship) == tostring(GetPlayerPrimaryShipID())
					local npcs = Functions.getNPCsOnShip(state, ship)
		
					local cells = { LibMJ:Cell() }
					
					-- create "expand ship" button
					local shipExpandButtonLabel = (isExpanded and "-") or "+"
					local shipExpandScript = function (rowIdx, colIdx)
						LibMJ:ToggleRow(rowIdx)
					end
					table.insert(cells, LibMJ:ButtonCell(shipExpandButtonLabel, shipExpandScript, 1, #npcs > 0))
										
					local shipLabel = shipName .. ((isCommander and " (" .. ReadText(99998,1005) .. ")") or "") -- <name> (Commander)
					table.insert(cells, LibMJ:Cell(shipLabel, nil, 2))

					local maxHull, hullPrc, maxShield, shieldPrc, cluster, sector, zone = GetComponentData(ship, "hullmax", "hullpercent", "shieldmax", "shieldpercent", "cluster", "sector", "zone")										
					-- local shipStatus = string.format("%s: %.0f%%", ReadText(1001, 1), hullPrc)					
					local shipStatus = string.format("%s: %.0f%%", "H", hullPrc)					
					if maxShield and maxShield > 0 then
						-- shipStatus = string.format("%s, %s: %.0f%%", shipStatus, ReadText(1001, 2), shieldPrc)
						shipStatus = string.format("%s, %s: %.0f%%", shipStatus, "S", shieldPrc)
					end
					-- shipStatus = string.format("%s, %s: %s / %s / %s", shipStatus, ReadText(99997, 1001), cluster, sector, zone)
					shipStatus = string.format("%s, %s / %s / %s", shipStatus, cluster, sector, zone)
					
					table.insert(cells, LibMJ:Cell(shipStatus, nil, 4))
					
					local deleteShipScript = function (rowIdx, colIdx)
						table.remove(fleet.ships, LibMJ.indexOf(fleet.ships, ship))
						fleet.shipsById[tostring(ship)] = nil
						ShipsToFleetId[tostring(ship)] = nil
						for _, npc in ipairs(Functions.getNPCsOnShip(state, ship)) do
							Functions.setNPCState(state, npc, "iFleetId", -1)
						end
						LibMJ:RemoveRow(rowIdx)
					end
					
					table.insert(cells, LibMJ:ButtonCell("X", deleteShipScript, 1, not isCommander, LibMJ.colors.red, nil, true))
					
					local rowData = { ["Ship"] = ship, ["ValidForBroadcastStance"] = true }
					local nrOfChildRows = (isPlayer and 0) or #npcs
					table.insert(rowCollection, LibMJ:Row(cells, rowData, nil, false, nrOfChildRows))
					
					if isExpanded then
						for _, npc in ipairs(npcs) do
							local npcName, typestring, typeName, iconTexture = GetComponentData(npc, "name", "typestring", "typename", "typeicon")
							local npcState = StateContainers[tostring(npc)]
														
							local cells = { LibMJ:Cell(nil, nil, 2) }
							
							local typeIcon = Helper.createIcon(iconTexture, false, 255, 255, 255, 100, 0, 0, Helper.standardTextHeight, Helper.standardButtonWidth - 10)
							table.insert(cells, LibMJ:Cell(typeIcon))
							
							local npcLabel = typeName .. " " .. npcName
							table.insert(cells, LibMJ:Cell(npcLabel, nil, 2))
							
							local stanceLabel = ""
							if npcState then
								local stateContainer = npcState.container
								local aggressionLevelKey = stateContainer["sAggressionLevel"]
								local formationModeKey = stateContainer["sFormationMode"]
								local engageDist = stateContainer["mEngageDist"]
								if aggressionLevelKey then
									local aggressionLevel = UFO.stances.aggressionLevels[aggressionLevelKey]
									local formationMode = UFO.stances.formationModes[formationModeKey]
									assert(aggressionLevel, "must have valid aggression level. row index: " .. #rowCollection + 1)
									assert(formationMode, "must have valid formation mode. row index: " .. #rowCollection + 1)
									stanceLabel = aggressionLevel.label
									local isPassive = aggressionLevel == UFO.stances.aggressionLevel.passive
									local isBreak = formationMode == UFO.stances.formationMode.doBreak
									if not isPassive then
										if isBreak then
											stanceLabel = stanceLabel .. " (" .. (engageDist/1000) .. "km)"
										else
											stanceLabel = stanceLabel .. " (" .. formationMode.label .. ")"
										end
									end
								end
							end
							table.insert(cells, LibMJ:Cell(stanceLabel, nil, 4))
							
							local rowData = { ["NPC"] = npc, ["ValidForBroadcastStance"] = typestring ~= "engineer" }
							
							table.insert(rowCollection, LibMJ:Row(cells, rowData))
						end
					end
				end
			end
		end
	else
		table.insert(rowCollection, LibMJ:Row({ LibMJ:Cell(ReadText(99998, 3)) }, nil, 7)) -- No fleets detected
	end

	-- we also reset the global expand states
	ExpandedFleets = {}
	
	local butWidth = Helper.standardButtonWidth - 10
	local colWidths = { butWidth, butWidth, butWidth, 200, 0, 180, 120, butWidth, butWidth }
	return colWidths
end

Functions.buttonProvider = function (state)
	local buttons = {}
	
	local createFleetButtonLabel = ReadText(99998,104) -- "Create Fleet"
	local createFleetButtonSript = Buttons.createNewFleet
	local createFleetButtonAvailability = function () return #Functions.getUnassignedShips() > 0 end
	table.insert(buttons, LibMJ:BarButton(createFleetButtonLabel, createFleetButtonSript, createFleetButtonAvailability))
	
	local broadcastStanceButtonLabel = ReadText(99998,100) -- "Broadcast Stance"
	local broadcastStanceButtonSript = Buttons.broadcastStance
	local broadcastStanceButtonAvailability = function (state, rowIdx, rowData)
		return rowData["ValidForBroadcastStance"]
	end
	table.insert(buttons, LibMJ:BarButton(broadcastStanceButtonLabel, broadcastStanceButtonSript, broadcastStanceButtonAvailability))
	
	table.insert(buttons, LibMJ:BarButton())
	table.insert(buttons, LibMJ:BarButton())
	table.insert(buttons, LibMJ:BarButton())
	table.insert(buttons, LibMJ:BarButton())
	table.insert(buttons, LibMJ:BarButton())
	
	-- TODO: implement details screen
	-- table.insert(buttons, LibMJ:BarButton("Details", function() LibMJ:OpenMenu("UFOChooseTargetOnMap", nil) end, function () return true end)) -- TODO: ReadText
	
	return buttons
end

Functions.getUnassignedShips = function (state)
	local ships = {}
	
	-- we can do a quick heuristic check to see if there are ships at all
	if #PlayerShips > #ShipsToFleetId then
		-- only allow ships to be selected that are not already in a fleet
		for _, ship in ipairs(PlayerShips) do
			local isDrone = IsComponentClass(ship, "ship_xs")
			if not ShipsToFleetId[tostring(ship)] and not isDrone then
				table.insert(ships, ship)
			end
		end
	end
	
	return ships
end

Functions.broadcastStanceToFleet = function (state, fleet, aggressionLevel, formationMode, engageDist)
	for _, ship in ipairs(fleet.ships) do
		Functions.broadcastStanceToShip(state, ship, aggressionLevel, formationMode, engageDist)
	end
end

Functions.broadcastStanceToShip = function (state, ship, aggressionLevel, formationMode, engageDist)	
	local npcs = Functions.getNPCsOnShip(state, ship)
		
	for _, npc in ipairs(npcs) do
		Functions.broadcastStanceToNPC(state, npc, aggressionLevel, formationMode, engageDist)
	end
end

Functions.broadcastStanceToNPC = function (state, npc, aggressionLevel, formationMode, engageDist)
	local typestring = GetComponentData(npc, "typestring")
	Functions.setNPCState(state, npc, "sAggressionLevel", aggressionLevel.key)
	
	-- defence npcs are always set to break
	if typestring ~= "defencecontrol" then
		Functions.setNPCState(state, npc, "sFormationMode", formationMode.key)
	else
		Functions.setNPCState(state, npc, "sFormationMode", UFO.stances.formationMode.doBreak.key)
	end
	Functions.setNPCState(state, npc, "mEngageDist", engageDist)
end

Functions.getStanceForNPC = function (state, npc)
	assert(npc, "must provide npc")
	local npcState = StateContainers[tostring(npc)]
	if not npcState then
		return nil, nil, nil
	end
	
	local aggressionLevel, formationMode = nil
	local aggressionLevelKey = npcState.container["sAggressionLevel"]
	if aggressionLevelKey then
		aggressionLevel = UFO.stances.aggressionLevels[aggressionLevelKey]
	end
	local formationModeKey = npcState.container["sFormationMode"]
	if formationModeKey then
		formationMode = UFO.stances.formationModes[formationModeKey]
	end
	local engageDist = npcState.container["mEngageDist"]
	
	return aggressionLevel, formationMode, engageDist
end

Functions.getNPCsOnShip = function (state, ship)
	local pilot, defencenpc, engineer = GetComponentData(ship, "pilot", "defencenpc", "engineer")
	local isPlayer = tostring(ship) == tostring(GetPlayerPrimaryShipID())
	local npcs = {}
	
	if pilot then
		table.insert(npcs, (not isPlayer and pilot) or UFO.copilot)
	end
	if defencenpc then
		table.insert(npcs, defencenpc)
	end
	if engineer then
		table.insert(npcs, engineer)
	end
	
	return npcs
end

Functions.setNPCState = function (state, npc, key, value)
	-- for now, we filter out all engineers here
	local typestring = GetComponentData(npc, "typestring")
	if typestring ~= "engineer" then
		StateContainers[tostring(npc)] = StateContainers[tostring(npc)] or { entity = npc, container = {} }
		StateContainers[tostring(npc)].container[key] = value
	end
end

Buttons.openAddShipsMenu = function (state, fleet)	
	state.subMenu = "AddShips"
	state.selectedFleet = fleet
	
	local title = ReadText(99998,25) .. " '" .. fleet.name .. "'" -- "Add Ships to Fleet '%s'"
	local ships = Functions.getUnassignedShips(state)
	local chooseMultiple = true

    -- let the menu know that ships without defence officers cannot be selected
    local shipDescriptors = {}
    local noDefenceNPCWarning = ReadText(99998,30) .. " " .. ReadText(20208,1501) -- "no Defence Officer"
    for _, ship in ipairs(ships) do
        local isCap = IsComponentClass(ship, "ship_l") or IsComponentClass(ship, "ship_xl")
        local pilot = GetComponentData(ship, "pilot")
        local noPilotWarning = ReadText(99998,30) .. " " .. ((isCap and ReadText(20208,501)) or ReadText(20208,401)) -- "no Pilot/no Captain"
        local defenceNPC = GetComponentData(ship, "defencenpc")

        table.insert(shipDescriptors, { 
            ship = ship, 
            selectable = pilot and (not isCap or defenceNPC ~= nil),
            additionalLabel = (not pilot and "(" .. noPilotWarning .. ")") or (isCap and not defenceNPC and "(" .. noDefenceNPCWarning .. ")")
        })
    end
    	
	LibMJ:OpenMenu("LibMJ_ShipSelection", nil, title, shipDescriptors, chooseMultiple)
end

Buttons.createNewFleet = function (state, rowIdx, rowData, initialText)
	state.subMenu = "CreateFleet"
	
	local title = ReadText(99998,24) -- "Create New Fleet"
	initialText = initialText or ReadText(99998,1006) -- "New Fleet"
	local isEmptyAllowed = false
	LibMJ:OpenMenu("LibMJ_InputText", nil, title, initialText, isEmptyAllowed)
end

Buttons.broadcastStance = function (state, rowIdx, rowData)
	state.subMenu = "BroadcastStance"
	local name, npc, typestring = nil
	local disableFormationMode = false
	
	state.broadcastTargetFleet = rowData["Fleet"]
	state.broadcastTargetShip = rowData["Ship"]
	state.broadcastTargetNPC = rowData["NPC"]
	
	if state.broadcastTargetFleet then
		-- get the stance of the fleet commander
		local npcs = Functions.getNPCsOnShip(state, state.broadcastTargetFleet.commander)
		npc = npcs[1]
		name = state.broadcastTargetFleet.name
	elseif state.broadcastTargetShip then
		local npcs = Functions.getNPCsOnShip(state, state.broadcastTargetShip)
		npc = npcs[1]
		name = GetComponentData(state.broadcastTargetShip, "name")
	else
		npc = state.broadcastTargetNPC
		name, typestring = GetComponentData(npc, "name", "typestring")
		disableFormationMode = typestring == "defencecontrol"
	end
	
	local aggressionLevel, formationMode, engageDist = Functions.getStanceForNPC(state, npc)
	
	LibMJ:OpenMenu("UFOChooseStance", nil, name, aggressionLevel, formationMode, engageDist, disableFormationMode)
end

Buttons.issueCommand = function (state, fleet)
	state.subMenu = "ChooseFleetCommand"
	state.selectedFleet = fleet
	
	LibMJ:OpenMenu("UFOChooseFleetCommand", nil, fleet, PlayerShips)
end

init()