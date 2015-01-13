--[[
	This file is part of the X Rebirth LibMJ script library.
	
	Author: MadJoker
  
	Last Change:
	Version: V0.0.1
	Date: 1st May 2014
  
	X Rebirth version: 1.31
--]]

-- persistent state
local Functions, Buttons = {}, {}

-- register the new UFO menu
local function init()
	if LibMJ and LibMJ.RegisterMenu then
		LibMJ:RegisterMenu("LibMJ_InputText", 
							Functions.onMenuInit, 
							Functions.onMenuClosed, 
							nil, -- onReturnArgsReceived 
							Functions.titleProvider, 
							Functions.rowProvider, 
							{ type = "buttons", provider = Functions.buttonProvider },
							Functions.onUpdate)
	else
		LibMJ = LibMJ or { registerFuncs = {} }
		table.insert(LibMJ.registerFuncs, init)
	end
end

Functions.onMenuInit = function (state, title, initialText, isEmptyAllowed)
	state.title = title or ReadText(99997,1) -- "Enter Text"
	state.initialText = initialText or ""
	state.isEmptyAllowed = isEmptyAllowed
end

Functions.onMenuClosed = function (state)		
	local returnVal = {}
	table.insert(returnVal, state.text)
	
	-- clean up state
	state.title = nil
	state.initialText = nil
	state.text = nil
	
	return returnVal
end

Functions.onUpdate = function (state)
	if state.activateTextInputBox then
		state.activateTextInputBox = nil
		Helper.activateEditBox(state.bodyTable, 1, 1)
	end
		
	-- we also check our buttons
	LibMJ:CheckButtonBarAvailability(1, nil)
end

Functions.titleProvider = function (state)
	return state.title
end

Functions.rowProvider = function (state, rowCollection)
	local cells = {}

	local editBoxInitialText = Helper.createButtonText(state.initialText, "left", Helper.standardFont, Helper.standardFontSize, 255, 255, 255, 100)
	local editBox = Helper.createEditBox(editBoxInitialText, false, 0, 0, 880, 24, nil, nil, true)
	local editBoxScript = function (_, text, textchanged)
		state.text = text
	end

	table.insert(cells, LibMJ:EditBoxCell(editBox, editBoxScript))
	
	table.insert(rowCollection, LibMJ:Row(cells))
	
	local colWidths = { 0 }
	local isColumnWidthsInPercent = false
	local height = 75
	return colWidths, isColumnWidthsInPercent, height
end

Functions.buttonProvider = function (state)
	local buttons = {}
		
	table.insert(buttons, LibMJ:BarButton())
	
	local confirmButtonLabel = ReadText(1001, 14)
	local confirmButtonScript = Buttons.confirmInput
	
	-- TODO: check for state.isEmptyTextAllowed
	-- we can only make the button available after the text input box was activated, since it will bug out otherwise
	local confirmButtonAvailability = function (state) return not state.activateTextInputBox end
	local confirmButtonHotkey = "INPUT_STATE_DETAILMONITOR_A"
	table.insert(buttons, LibMJ:BarButton(confirmButtonLabel, confirmButtonScript, confirmButtonAvailability, confirmButtonHotkey))
	
	local cancelButtonLabel = ReadText(1001, 64)
	local cancelButtonScript = function () 
		Helper.cancelEditBoxInput(state.bodyTable, 1, 1)
		LibMJ:CloseMenu() 
	end
	local cancelButtonHotkey = "INPUT_STATE_DETAILMONITOR_ESC"
	table.insert(buttons, LibMJ:BarButton(cancelButtonLabel, cancelButtonScript, nil, cancelButtonHotkey))
	
	state.activateTextInputBox = true
	
	return buttons
end

Buttons.confirmInput = function (state)
	-- this should set state.text
	Helper.confirmEditBoxInput(state.bodyTable, 1, 1)

    if not state.text or state.text == "" then
        return
    end

	if state.followUpMenu then
		LibMJ:OpenMenu(state.followUpMenu, nil, unpack(state.followUpMenuArgs), state.text)
	else
		LibMJ:CloseMenu()
	end
end

init()