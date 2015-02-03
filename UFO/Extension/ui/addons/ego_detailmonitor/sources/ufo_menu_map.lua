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
		LibMJ:RegisterMenu("UFOChooseTargetOnMap", 
							nil, -- onMenuInit, 
							nil, -- onMenuClosed, 
							nil, -- onReturnArgsReceived 
							Functions.titleProvider, 
							Functions.rowProvider,
							{ 
								type = "map", 
								provider = Functions.mapDataProvider, 
								navButtonAvailabilityProvider = Functions.navButtonAvailabilityProvider,
								onUpdateHoloMap = Functions.onUpdateHoloMap })
	else
		LibMJ = LibMJ or { registerFuncs = {} }
		table.insert(LibMJ.registerFuncs, init)
	end
end

Functions.titleProvider = function (state)
	return "Map" -- TODO: ReadText
end

Functions.rowProvider = function (state, rowCollection)
	table.insert(rowCollection, LibMJ:Row({ LibMJ:Cell("test"), LibMJ:Cell("test2"), LibMJ:Cell("test3") }))	
	table.insert(rowCollection, LibMJ:Row({ LibMJ:Cell("tes4"), LibMJ:Cell("test5"), LibMJ:Cell("test6") }))
	
	return { 100, 100, 0 }
end

Functions.mapDataProvider = function (state)
	return nil, nil
end

Functions.navButtonAvailabilityProvider = function (state)
	return true, true, true
end

Functions.onUpdateHoloMap = function (state)
end

init()