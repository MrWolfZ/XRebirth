--[[
	This file is part of the X Rebirth UFO mod.
	
	Author: MadJoker
  
	Last Change:
	Version: V0.6.0 Beta
	Date: 17th January 2015
  
	X Rebirth version: 3.10
--]]

-- persistent state
local Functions, Buttons = {}, {}

-- register the new UFO menu
local function init()
	if LibMJ and LibMJ.RegisterMenu then
		LibMJ:RegisterMenu("UFOConfiguration", 
							nil, -- onMenuInit, 
							nil, -- onMenuClosed, 
							nil, -- onReturnArgsReceived 
							Functions.titleProvider, 
							Functions.rowProvider,
							{ type = "buttons", provider = Functions.buttonProvider })
	else
		LibMJ = LibMJ or { registerFuncs = {} }
		table.insert(LibMJ.registerFuncs, init)
	end
end

Functions.titleProvider = function (state)
	return ReadText(99998,9000) -- "UFO Configuration"
end

Functions.rowProvider = function (state, rowCollection)
	local buttonFontSize = 12

	local emptyRow = LibMJ:Row({ LibMJ:Cell(nil, nil, 10) }, nil, LibMJ.colors.transparent, true)
	
	table.insert(rowCollection, emptyRow)
	
	local cells = {}
	table.insert(cells, LibMJ:Cell(ReadText(99997,9001) .. ":")) -- "Debug Level:"
	table.insert(cells, LibMJ:Cell(UFO.debugLevel.selected.label))
	
	local setErrorButtonLabel = UFO.debugLevel.error.label
	local setErrorButtonScript = function() 
		UFO.debugLevel.selected = UFO.debugLevel.error
		LibMJ:RefreshMenu()
	end	
	table.insert(cells, LibMJ:ButtonCell(setErrorButtonLabel, setErrorButtonScript, 1, true, nil, buttonFontSize))
	
	table.insert(cells, LibMJ:Cell())
	
	local setInfoButtonLabel = UFO.debugLevel.info.label
	local setInfoButtonScript = function() 
		UFO.debugLevel.selected = UFO.debugLevel.info
		LibMJ:RefreshMenu()
	end	
	table.insert(cells, LibMJ:ButtonCell(setInfoButtonLabel, setInfoButtonScript, 1, true, nil, buttonFontSize))
	
	table.insert(cells, LibMJ:Cell())
	
	local setFineButtonLabel = UFO.debugLevel.fine.label
	local setFineButtonScript = function() 
		UFO.debugLevel.selected = UFO.debugLevel.fine
		LibMJ:RefreshMenu()
	end	
	table.insert(cells, LibMJ:ButtonCell(setFineButtonLabel, setFineButtonScript, 1, true, nil, buttonFontSize))
	
	table.insert(cells, LibMJ:Cell())	
	
	local setFinestButtonLabel = UFO.debugLevel.finest.label
	local setFinestButtonScript = function() 
		UFO.debugLevel.selected = UFO.debugLevel.finest
		LibMJ:RefreshMenu()
	end	
	table.insert(cells, LibMJ:ButtonCell(setFinestButtonLabel, setFinestButtonScript, 1, true, nil, buttonFontSize))
	
	table.insert(cells, LibMJ:Cell())	
	
	table.insert(rowCollection, LibMJ:Row(cells, nil, LibMJ.colors.transparent, true))
	
	local colWidths = { 180, 100, 100, 20, 100, 20, 100, 20, 100, 0 }
	return colWidths
end

Functions.buttonProvider = function (state)
	local buttons = {}
	
	table.insert(buttons, LibMJ:BarButton())
	table.insert(buttons, LibMJ:BarButton())
	table.insert(buttons, LibMJ:BarButton())
	table.insert(buttons, LibMJ:BarButton())
	table.insert(buttons, LibMJ:BarButton())
	table.insert(buttons, LibMJ:BarButton())
	table.insert(buttons, LibMJ:BarButton())
	
	local uninstallButtonLabel = ReadText(99997,9000) -- "Uninstall"
	local uninstallButtonSript = Buttons.uninstall
	table.insert(buttons, LibMJ:BarButton(uninstallButtonLabel, uninstallButtonSript))
	
	return buttons
end

Buttons.uninstall = function ()
	UFO.uninstall = true
	LibMJ:CloseMenu()
end

init()