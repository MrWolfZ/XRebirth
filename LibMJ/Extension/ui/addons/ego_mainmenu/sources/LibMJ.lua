--[[
	This file is part of the X Rebirth LibMJ script library.
	
	Author: MadJoker
  
	Last Change:
	Version: V0.1.1
	Date: 3rd February 2015
  
	X Rebirth version: 3.20
--]]

-- catch the case where menus tried to register before LibMJ was initialized
local registerFuncs = {}
if LibMJ then
	registerFuncs = LibMJ.registerFuncs
end

LibMJ = {
    mainMenuRef = nil,
	sidebarCategories = {},
    sidebarCategoryCount = 0,
	sidebarMenus = {},
    sidebarMenuCount = 0
}

LibMJ.sidebarLocationsAndCategories = {
  top = {
    "modes", 
    "info", 
    "missions", 
    "navigation",
    "communication",
    "trading",
    "crew",
    "drones"
  },
  bottom = {
    "options",
    "close"
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

  -- enrich the existing setup
  for location, categories in pairs(self.sidebarLocationsAndCategories) do
    local predefinedCategories = self.mainMenuRef.setup[location]
    for i, key in ipairs(categories) do
      predefinedCategories[i].key = key
    end
  end
  
  -- build an array from the categories based on their index
  -- to ensure correct category order
  local categories = {}
  for _, cat in pairs(self.sidebarCategories) do
    categories[cat.index] = cat
  end

  for _, cat in ipairs(categories) do
    self:AddCategoryToSidebar(cat)
  end
  
  -- build an array from the menus based on their index
  -- to ensure correct menu order
  local menus = {}
  for _, menu in pairs(self.sidebarMenus) do
    menus[menu.index] = menu
  end

  for _, menu in ipairs(menus) do
    self:AddMenuToSidebar(menu)
  end
end

function LibMJ:RegisterSidebarCategory(location, name, icon)
	assert(location, "Sidebar category must have a location (i.e. top or bottom)")
	assert(name, "Sidebar category must have a name")
	assert(icon, "Sidebar category must have an icon")

    error("Adding new categories to the sidebar is currently not supported!")

    local catKey = location .. "_" .. name
    
    if self.sidebarCategories[catKey] then
      error("Sidebar category with key " .. catKey .. " is already registered!")
    end

    self.sidebarCategoryCount = self.sidebarCategoryCount + 1
	self.sidebarCategories[catKey] = {
        index = self.sidebarCategoryCount,
        location = location,
		name = name,
        icon = icon
	}
end

function LibMJ:RegisterSidebarMenu(location, category, name, description, section, icon, sectionparam, condition)
	assert(location, "Sidebar menu must have a location (i.e. top or bottom)")
	assert(category, "Sidebar menu must have a category")
	assert(name, "Sidebar menu must have a name")

    local catPath = category
    local catCount = 1
    if type(category) == "table" then
      catPath = ""
      catCount = #category
      for _, cat in ipairs(category) do
        catPath = catPath .. "," .. cat
      end
    end

    local menuKey = location .. "_" .. catPath .. "_" .. name
    
    if self.sidebarMenus[menuKey] then
      error("Sidebar menu with key " .. menuKey .. " is already registered!")
    end

    if catCount > 1 and not icon then
      error("Sub menus must have an icon!")
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
        condition = condition or true
	}
end

function LibMJ:AddCategoryToSidebar(cat)
    local catObj = {
        key = cat.name,
		name = cat.name,
        icon = cat.icon
    }

    local reqCategories = { [0] = menu.category }
    if type(menu.category) == "table" then
      reqCategories = menu.category
    end

    local categories = self.mainMenuRef.setup[cat.location]
    for _, cat in pairs(categories) do
      if cat.name == reqCategory then
        error("Category with name " .. cat.name .. " already exists!")
      end
    end
    
    -- we have to adjust the height of the menu to compensate for the additional item
    -- 59 is the value that is added to the base height of the sidebar per item in Ego's code
    self.mainMenuRef.height = self.mainMenuRef.height + 59
    table.insert(categories, menuObj)
end

function LibMJ:AddMenuToSidebar(menu)
    local menuObj = {
        key = menu.name,
		name = menu.name,
        info = menu.description,
        section = menu.section,
        icon = menu.icon,
        sectionparam = menu.sectionparam,
        condition = menu.condition
    }

    if type(menuObj.condition) == "function" then
      menuObj.condition = menuObj.condition()
    end

    local reqCategories = { menu.category }
    if type(menu.category) == "table" then
      reqCategories = menu.category
    end

    local category = nil
    local categories = self.mainMenuRef.setup[menu.location]

    local catPath = ""
    for _, reqCategory in ipairs(reqCategories) do
      catPath = catPath .. " -> " .. reqCategory
      category = nil
      for _, cat in ipairs(categories) do
        if cat.key == reqCategory then
          category = cat
          categories = cat.list or {}
        end
      end

      if not category then
        categories = {}
      end
    end

    if not category then
      error("Menu path " .. catPath .. " does not exist!")
    end

    category.list = category.list or {}
    table.insert(category.list, menuObj)
end

init()