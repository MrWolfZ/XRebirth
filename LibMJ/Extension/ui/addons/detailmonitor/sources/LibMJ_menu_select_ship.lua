-- persistent state
local Functions, Buttons = {}, {}, {}

-- register the new UFO menu
local function init()
	if LibMJ and LibMJ.RegisterMenu then
		LibMJ:RegisterMenu("LibMJ_ShipSelection", 
							Functions.onMenuInit, 
							Functions.onMenuClosed, 
							nil, -- onReturnArgsReceived
							Functions.titleProvider, 
							Functions.rowProvider)
	else
		LibMJ = LibMJ or { registerFuncs = {} }
		table.insert(LibMJ.registerFuncs, init)
	end
end

Functions.onMenuInit = function (state, title, shipDescriptors, chooseMultiple)
	state.title = title or ReadText(99997,2) -- "Select Ship(s)"
	state.chooseMultiple = chooseMultiple
	
	local smallShips = {}
	local mediumShips = {}
	local largeShips = {}
	local extraLargeShips = {}
	for _, shipDesc in ipairs(shipDescriptors) do
        local ship = shipDesc.ship
		if IsComponentClass(ship, "ship_xl") then
			table.insert(extraLargeShips, shipDesc)
		elseif IsComponentClass(ship, "ship_l") then
			table.insert(largeShips, shipDesc)
		elseif IsComponentClass(ship, "ship_m") then
			table.insert(mediumShips, shipDesc)
		elseif IsComponentClass(ship, "ship_s") then
			table.insert(smallShips, shipDesc)
		end
	end
	
	state.nrOfShips = #smallShips + #mediumShips + #largeShips + #extraLargeShips
	
	state.categories = { { label = "S", ships = smallShips }, { label = "M", ships = mediumShips }, { label = "L", ships = largeShips }, { label = "XL", ships = extraLargeShips } }	
	state.selectedShips = {}
end

Functions.onMenuClosed = function (state)
	local selectedShips = state.selectedShips
	
	-- clean up our state
	state.categories = nil
	state.selectedShips = nil
	state.nrOfShips = nil
	state.title = nil
	state.chooseMultiple = nil
	state.args = nil
	
	return { selectedShips }
end

Functions.titleProvider = function (state)
	return (type(state.title) == "function" and state.title(unpack(state.args))) or state.title
end

Functions.rowProvider = function (state, rowCollection)
	for _, category in ipairs(state.categories) do	
		local ships = category.ships
		local isExpanded = LibMJ:IsExpanded(#rowCollection + 1) or not state.initialized
				
		local cells = {}
		
		-- create "expand category" button
		local categoryExpandButtonLabel = ((#ships > 0 and isExpanded) and "-") or "+"
		local categoryExpandScript = function (rowIdx, colIdx)
			LibMJ:ToggleRow(rowIdx)
		end
		table.insert(cells, LibMJ:ButtonCell(categoryExpandButtonLabel, categoryExpandScript, 1, #ships > 0))
		
		local categoryLabel = category.label .. " (" .. #ships .. ")"
		table.insert(cells, LibMJ:Cell(categoryLabel, nil, 3))
				
		local rowData = { ["Category"] = category }
		local nrOfChildRows = #ships
		table.insert(rowCollection, LibMJ:Row(cells, rowData, Helper.defaultHeaderBackgroundColor, false, nrOfChildRows))
				
		-- we also expand the rows here the first time the ship selection screen is loaded
		if not state.initialized then
			LibMJ:ExpandRow(#rowCollection, true)
		end
		
		-- if category is extended, add line per ship
		if isExpanded then
			for _, shipDesc in ipairs(ships) do		
                local ship = shipDesc.ship
				local cells = { LibMJ:Cell() }
				
				local shipLabel = GetComponentData(ship, "name")
                if shipDesc.additionalLabel then
                    shipLabel = shipLabel .. " " .. shipDesc.additionalLabel
                end
				table.insert(cells, LibMJ:Cell(shipLabel))
				
				local maxHull, hullPrc, maxShield, shieldPrc, cluster, sector, zone = GetComponentData(ship, "hullmax", "hullpercent", "shieldmax", "shieldpercent", "cluster", "sector", "zone")														
				local shipStatus = string.format("%s: %.0f%%", "H", hullPrc)
				if maxShield and maxShield > 0 then
					shipStatus = string.format("%s, %s: %.0f%%", shipStatus, "S", shieldPrc)
				end
				shipStatus = string.format("%s, %s / %s / %s", shipStatus, cluster, sector, zone)
				
				table.insert(cells, LibMJ:Cell(shipStatus))
	
				local selectShipButtonLabel = ReadText(99997,1000) -- "Select"
				local selectShipButtonScript = function (rowIdx, colIdx)				
					table.insert(state.selectedShips, ship)
					table.remove(category.ships, LibMJ.indexOf(category.ships, ship, function (descr, s2) return tostring(descr.ship) == tostring(s2) end))
					
					-- if multiple selection is allowed and ships are available, we continue, otherwise we close the menu
					if state.chooseMultiple and #state.selectedShips < state.nrOfShips then
						LibMJ:RemoveRow(rowIdx)
					else
						LibMJ:CloseMenu()
					end
				end
                local selectShipButtonSelectable = shipDesc.selectable
				
				table.insert(cells, LibMJ:ButtonCell(selectShipButtonLabel, selectShipButtonScript, 1, selectShipButtonSelectable))
				
				local rowData = { ["Ship"] = ship }
				table.insert(rowCollection, LibMJ:Row(cells, rowData))
			end
		end
	end	
	
	state.initialized = true

	local butWidth = Helper.standardButtonWidth - 10
	local colWidths = { butWidth, 260, 0, 80 }
	local isColumnWidthsInPercent = false
	local fixedRows = 0
	return colWidths, isColumnWidthsInPercent, fixedRows
end

init()