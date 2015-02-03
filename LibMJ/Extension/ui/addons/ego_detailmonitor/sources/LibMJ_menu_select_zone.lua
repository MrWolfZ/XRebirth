--[[
	This file is part of the X Rebirth LibMJ script library.
	
	Author: MadJoker
  
	Last Change:
	Version: V0.1.1
	Date: 3rd February 2015
  
	X Rebirth version: 3.20
--]]

-- persistent state
local Functions, Buttons = {}, {}, {}

-- register the new UFO menu
local function init()
	if LibMJ and LibMJ.RegisterMenu then
		LibMJ:RegisterMenu("LibMJ_ZoneSelection", 
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

Functions.onMenuInit = function (state, title, chooseMultiple, preExpanded, exclusions)
	state.title = title or ReadText(99997,3) -- "Choose Zone(s)"
	state.chooseMultiple = chooseMultiple
	state.preExpanded = preExpanded or {}
	state.exclusions = exclusions or {}
	
	state.selectedZones = {}
end

Functions.onMenuClosed = function (state)
	local selectedZones = state.selectedZones
	
	-- clean up our state
	state.selectedZones = nil
	state.title = nil
	state.chooseMultiple = nil
	state.exclusions = nil
	
	return { selectedZones }
end

Functions.titleProvider = function (state)
	return state.title
end

Functions.rowProvider = function (state, rowCollection)
	local clusters = GetClusters(true)
	local idComparer = function (o1, o2) return tostring(o1) == tostring(o2) end
	
	-- filter out exclusions
	for i = #clusters, 1, -1 do
		if LibMJ.indexOf(state.exclusions, clusters[i], idComparer) > 0 then
			table.remove(clusters, i)
		end
	end
	
	for _, cluster in ipairs(clusters) do
		local name = GetComponentData(cluster, "name")
		local sectors = GetSectors(cluster)
	
		-- filter out exclusions
		for i = #sectors, 1, -1 do
			if LibMJ.indexOf(state.exclusions, sectors[i], idComparer) > 0 then
				table.remove(sectors, i)
			end
		end
	
		local isExpanded = LibMJ:IsExpanded(#rowCollection + 1) or LibMJ.indexOf(state.preExpanded, cluster, idComparer) > 0
				
		local cells = {}
		
		-- create "expand cluster" button
		local clusterExpandButtonLabel = ((#sectors > 0 and isExpanded) and "-") or "+"
		local clusterExpandScript = function (rowIdx, colIdx)
			LibMJ:ToggleRow(rowIdx)
		end
		table.insert(cells, LibMJ:ButtonCell(clusterExpandButtonLabel, clusterExpandScript, 1, #sectors > 0))
		
		local clusterLabel = name .. " (" .. #sectors .. ")"
		table.insert(cells, LibMJ:Cell(clusterLabel, nil, 4))
		
		local rowData = { ["Cluster"] = cluster }
		local nrOfChildRows = #sectors
		table.insert(rowCollection, LibMJ:Row(cells, rowData, Helper.defaultHeaderBackgroundColor, false, nrOfChildRows))
		
		-- we also expand the cluster the fleet is in
		if tostring(cluster) == fleetClusterId then
			LibMJ:ExpandRow(#rowCollection, true)
		end
		
		-- if cluster is extended, add line per sector
		if isExpanded then
			for _, sector in ipairs(sectors) do		
				local name = GetComponentData(sector, "name")
				local zones = GetZones(sector)
				
				for i = #zones, 1, -1 do
					if LibMJ.indexOf(state.selectedZones, zones[i], idComparer) > 0 then
						table.remove(zones, i)
					end
					if LibMJ.indexOf(state.exclusions, zones[i], idComparer) > 0 then
						table.remove(zones, i)
					end
				end
				
				local isExpanded = LibMJ:IsExpanded(#rowCollection + 1) or LibMJ.indexOf(state.preExpanded, sector, idComparer) > 0
				
				local cells = { LibMJ:Cell() }
		
				-- create "expand sector" button
				local sectorExpandButtonLabel = ((#zones > 0 and isExpanded) and "-") or "+"
				local sectorExpandScript = function (rowIdx, colIdx)
					LibMJ:ToggleRow(rowIdx)
				end
				table.insert(cells, LibMJ:ButtonCell(sectorExpandButtonLabel, sectorExpandScript, 1, #zones > 0))
		
				local sectorLabel = name .. " (" .. #zones .. ")"
				table.insert(cells, LibMJ:Cell(sectorLabel, nil, 3))
		
				local rowData = { ["Sector"] = sector }
				local nrOfChildRows = #zones
				table.insert(rowCollection, LibMJ:Row(cells, rowData, Helper.defaultHeaderBackgroundColor, false, nrOfChildRows))
		
				-- we also expand the sector the fleet is in
				if tostring(sector) == fleetSectorId then
					LibMJ:ExpandRow(#rowCollection, true)
				end
				
				-- if sector is extended, add line per zone
				if isExpanded then
					for _, zone in ipairs(zones) do
						local name = GetComponentData(zone, "name")
						
						local cells = { LibMJ:Cell(nil, nil, 3) }
				
						table.insert(cells, LibMJ:Cell(name))
	
						local selectZoneButtonLabel = ReadText(99997,1000) -- "Select"
						local selectZoneButtonScript = function (rowIdx, colIdx)
							table.insert(state.selectedZones, zone)
							
							-- if multiple selection is allowed we continue, otherwise we close the menu
							if state.chooseMultiple then
								LibMJ:RemoveRow(rowIdx)
							else
								LibMJ:CloseMenu()
							end
						end
				
						table.insert(cells, LibMJ:ButtonCell(selectZoneButtonLabel, selectZoneButtonScript))
				
						local rowData = { ["Zone"] = zone }
						table.insert(rowCollection, LibMJ:Row(cells, rowData))
					end
				end
			end
		end
	end
	
	state.preExpanded = {}

	local butWidth = Helper.standardButtonWidth - 10
	local colWidths = { butWidth, butWidth, butWidth, 0, 80 }
	local isColumnWidthsInPercent = false
	local fixedRows = 0
	return colWidths, isColumnWidthsInPercent, fixedRows
end

init()