-- persistent state
local Functions, Buttons = {}, {}

-- register the new UFO menu
local function init()
	if LibMJ and LibMJ.RegisterMenu then
		LibMJ:RegisterMenu("UFOChooseStance", 
							Functions.onMenuInit, 
							Functions.onMenuClosed, 
							nil, -- onReturnArgsReceived 
							Functions.titleProvider, 
							Functions.rowProvider,
							{ type = "slider", provider = Functions.sliderProvider },
							Functions.onUpdate)
	else
		LibMJ = LibMJ or { registerFuncs = {} }
		table.insert(LibMJ.registerFuncs, init)
	end
end

Functions.onMenuInit = function (state, targetName, aggressionLevel, formationMode, engageDist, disableFormationMode)
	state.targetName = targetName
	state.aggressionLevel = aggressionLevel or UFO.stances.aggressionLevel.defensive
	state.formationMode = formationMode or UFO.stances.formationMode.noBreak
	state.engageDist = (engageDist or 10000) / 1000
	state.disableFormationMode = disableFormationMode
end

Functions.onMenuClosed = function (state)
	local returnVal = {}
	table.insert(returnVal, state.aggressionLevel)
	table.insert(returnVal, state.formationMode)
	table.insert(returnVal, state.engageDist * 1000)
	
	-- clean up state
	state.targetName = nil
	state.aggressionLevel = nil
	state.formationMode = nil
	state.engageDist = nil
	
	if not state.confirmed then
		return {}
	end
	
	state.confirmed = nil
	
	return returnVal
end

Functions.onUpdate = function (state)
	local engageDist = GetSliderValue(state.sliderTable)
	state.engageDist = engageDist + 1
end

Functions.titleProvider = function (state)
	local titleWithoutTarget = ReadText(99998,10) -- "Choose Stance"
	local titleWithTargetFormat = ReadText(99998,11) .. " '%s'" -- "Choose Stance for"
	
	return (state.targetName and string.format(titleWithTargetFormat, state.targetName)) or titleWithoutTarget
end

Functions.rowProvider = function (state, rowCollection)
	local buttonFontSize = 12

	local emptyRow = LibMJ:Row({ LibMJ:Cell(nil, nil, 8) }, nil, LibMJ.colors.transparent, true)
	
	table.insert(rowCollection, emptyRow)
	
	local cells = {}
	table.insert(cells, LibMJ:Cell(ReadText(99998,12) .. ":")) -- "Aggression Level:"
	table.insert(cells, LibMJ:Cell(state.aggressionLevel.label))
	
	local setPassiveButtonLabel = UFO.stances.aggressionLevel.passive.label
	local setPassiveButtonScript = function() 
		state.aggressionLevel = UFO.stances.aggressionLevel.passive
		state.formationMode = UFO.stances.formationMode.noBreak
		LibMJ:RefreshMenu()
	end	
	table.insert(cells, LibMJ:ButtonCell(setPassiveButtonLabel, setPassiveButtonScript, 1, true, nil, buttonFontSize))
	
	table.insert(cells, LibMJ:Cell())
	
	local setDefensiveButtonLabel = UFO.stances.aggressionLevel.defensive.label
	local setDefensiveButtonScript = function() 
		state.aggressionLevel = UFO.stances.aggressionLevel.defensive
		LibMJ:RefreshMenu()
	end	
	table.insert(cells, LibMJ:ButtonCell(setDefensiveButtonLabel, setDefensiveButtonScript, 1, true, nil, buttonFontSize))
	
	table.insert(cells, LibMJ:Cell())
	
	local setAggressiveButtonLabel = UFO.stances.aggressionLevel.aggressive.label
	local setAggressiveButtonScript = function() 
		state.aggressionLevel = UFO.stances.aggressionLevel.aggressive
		LibMJ:RefreshMenu()
	end	
	table.insert(cells, LibMJ:ButtonCell(setAggressiveButtonLabel, setAggressiveButtonScript, 1, true, nil, buttonFontSize))
	
	table.insert(cells, LibMJ:Cell())	
	
	table.insert(rowCollection, LibMJ:Row(cells, nil, LibMJ.colors.transparent, true))
	
	table.insert(rowCollection, emptyRow)
	
	cells = {}
	table.insert(cells, LibMJ:Cell(ReadText(99998,13) .. ":")) -- "Formation Mode:"
	table.insert(cells, LibMJ:Cell(state.formationMode.label))
		
	local setDoBreakButtonLabel = UFO.stances.formationMode.doBreak.label
	local setDoBreakButtonScript = function() 
		state.formationMode = UFO.stances.formationMode.doBreak
		LibMJ:RefreshMenu()
	end	
	local setDoBreakButtonSelectable = state.aggressionLevel ~= UFO.stances.aggressionLevel.passive and not state.disableFormationMode
	table.insert(cells, LibMJ:ButtonCell(setDoBreakButtonLabel, setDoBreakButtonScript, 1, setDoBreakButtonSelectable, nil, buttonFontSize))
	
	table.insert(cells, LibMJ:Cell())
		
	local setNoBreakButtonLabel = UFO.stances.formationMode.noBreak.label
	local setNoBreakButtonScript = function() 
		state.formationMode = UFO.stances.formationMode.noBreak
		LibMJ:RefreshMenu()
	end	
	local setNoBreakButtonSelectable = state.aggressionLevel ~= UFO.stances.aggressionLevel.passive and not state.disableFormationMode
	table.insert(cells, LibMJ:ButtonCell(setNoBreakButtonLabel, setNoBreakButtonScript, 1, setNoBreakButtonSelectable, nil, buttonFontSize))
	
	table.insert(cells, LibMJ:Cell(nil, nil, 3))
	
	table.insert(rowCollection, LibMJ:Row(cells, nil, LibMJ.colors.transparent, true))
	
	for i = 1, 5 do
		table.insert(rowCollection, emptyRow)
	end
	
	cells = { LibMJ:Cell(nil, nil, 2) }
	
	local buttonWidth = 140
	
	local confirmButtonLabel = ReadText(1001, 14)
	local confirmButtonHotkey = "INPUT_STATE_DETAILMONITOR_A"
	local confirmButton = LibMJ:CreateDefaultButtonBarButton(confirmButtonLabel, true, Helper.createButtonHotkey(confirmButtonHotkey, true), nil, nil, buttonWidth)
	local confirmButtonScript = function() 
		state.confirmed = true
		LibMJ:CloseMenu()
	end
	table.insert(cells, LibMJ:ButtonCell(confirmButton, confirmButtonScript))	
	
	table.insert(cells, LibMJ:Cell())
	
	local cancelButtonLabel = ReadText(1001, 64)
	local cancelButtonHotkey = "INPUT_STATE_DETAILMONITOR_ESC"
	local cancelButton = LibMJ:CreateDefaultButtonBarButton(cancelButtonLabel, true, Helper.createButtonHotkey(cancelButtonHotkey, true), nil, nil, buttonWidth)
	local cancelButtonScript = function() 
		LibMJ:CloseMenu()
	end	
	table.insert(cells, LibMJ:ButtonCell(cancelButton, cancelButtonScript))
	
	table.insert(cells, LibMJ:Cell(nil, nil, 3))
	
	table.insert(rowCollection, LibMJ:Row(cells, nil, LibMJ.colors.transparent, true))
	
	local colWidths = { 180, 120, 140, 20, 140, 20, 140, 0 }
	local height = 75
	return colWidths, height
end

Functions.sliderProvider = function (state)
	local sliderInfo = {
		background = "tradesellbuy_blur",
		captionCenter = ReadText(99998,14) ..  " (1km - 50km)", -- "Max. Engagement Distance"
		min = 0,
		max = 49,
		minSelectable = 0,
		maxSelectable = 49,
		zero = 0, -- is subtracted from all values
		start = state.engageDist - 1
	}
	local scaleInfo1 = {
		center = false,
		suffix = "km",
		right = 1
	}
	local scaleInfo2 = nil
	
	local offsetY = 210
	
	return sliderInfo, scaleInfo1, scaleInfo2, offsetY
end

init()