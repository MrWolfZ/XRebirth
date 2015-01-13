--[[
	This file is part of the X Rebirth LibMJ script library.
	
	Author: MadJoker
  
	Last Change:
	Version: V0.0.1
	Date: 1st May 2014
  
	X Rebirth version: 1.31
--]]

-- catch the case where menus tried to register before LibMJ was initialized
local registerFuncs = {}
if LibMJ then
	registerFuncs = LibMJ.registerFuncs
end

LibMJ = {
    mainMenuRef = nil,
	sidebarMenus = {},
    sidebarMenuCount = 0
}

LibMJ.sidebarLocationsAndCategories = {
  top = {
    modes = 1, 
    info = 2, 
    missions = 3, 
    navigation = 4,
    communication = 5,
    trading = 6,
    crew = 7,
    drones = 8,
    new = nil
  },
  bottom = {
    options = 1,
    close = 2,
    new = nil
  }
}

local function init()
	for _, func in ipairs(registerFuncs) do
		func()
	end

	registerFuncs = nil

    -- set up code for modifying sidebar    
    for _, menu in ipairs(Menus) do
      if menu.name == "MainMenu" then
        LibMJ.mainMenuRef = menu
        LibMJ.origMainMenuCreateSetup = menu.createSetup
        menu.createSetup = LibMJ.mainMenuCreateSetup
        break
      end
    end
end

LibMJ.mainMenuCreateSetup = function()
  local self = LibMJ
  self.origMainMenuCreateSetup()      
  
  -- first, we build an array from the menus based on their index
  -- to ensure correct menu order
  local menus = {}
  for _, menu in pairs(self.sidebarMenus) do
    menus[menu.index] = menu
  end

  for _, menu in ipairs(menus) do
    self:AddMenuToSidebar(menu)
  end
end

function LibMJ:RegisterSidebarMenu(location, category, name, description, section, icon, sectionparam, condition, list)
	assert(location, "Sidebar menu must have a location (i.e. top or bottom)")
	assert(category, "Sidebar menu must have a category")
	assert(name, "Sidebar menu must have a name")

    local menuKey = location .. "_" .. category .. "_" .. name
    
    if self.sidebarMenus[menuKey] then
      error("Sidebar menu with key " .. menuKey .. " is already registered!")
    end

    self.sidebarMenuCount = self.sidebarMenuCount + 1
	self.sidebarMenus[menuKey] = {
        index = self.sidebarMenuCount,
        location = location,
        category = category,
		name = name,
        info = description or "",
        section = section or "",
        icon = icon,
        sectionparam = sectionparam or {},
        condition = condition or true,
        list = list
	}
end

function LibMJ:AddMenuToSidebar(menu)
    local menuObj = {
		name = menu.name,
        info = menu.description,
        section = menu.section,
        icon = menu.icon,
        sectionparam = menu.sectionparam,
        condition = menu.condition,
        list = menu.list
    }

    if type(menuObj.condition) == "function" then
      menuObj.condition = menuObj.condition()
    end

    if type(menuObj.list) == "function" then
      menuObj.list = menuObj.list()
    end

    local categories = self.mainMenuRef.setup[menu.location]
    local index = self.sidebarLocationsAndCategories[menu.location][menu.category]
    local category = nil

    -- if category is not pre-defined, we search over existing categories to see if it has already been added
    if not index then
      for _, cat in pairs(categories) do
        if cat.name == menu.category then
          category = cat
        end
      end
    else
      category = categories[index]
    end

    if not category then
        error("Adding new categories to the sidebar is currently not supported!")
        -- we have to adjust the height of the menu to compensate for the additional item
        -- 59 is the value that is added to the base height of the sidebar per item in Ego's code
        self.mainMenuRef.height = self.mainMenuRef.height + 59
        table.insert(categories, menuObj)
    else
        category.list = category.list or {}
        table.insert(category.list, menuObj)
    end
end

init()