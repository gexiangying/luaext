module(...,package.seeall)
menu_item = {}
function menu_item:new(o)
	local t = o or {}
	self.__index = self
	setmetatable(t,self)
	return t
end
function menu_item:set(name,id)
	self["name"] = name
	self["id"] = id
end
menu = {}
function menu:new(o)
	local t = o or {}
	self.__index = self
	setmetatable(t,self)
	return t
end
function menu:set_name(name)
	self["name"] = name
end
function menu:add_item(item)
	self.items = self.items or {}
	table.insert(self.items,item)
end
--[[
menu = { name = "test", items = {
	{ id = ID + 2, name = "test1"},
	{ id = ID + 3, name = "test2"},
  { id = ID + 4, name = "test3"},
	},
}
--]]
menu1 = { name = "Edit", items = {
	{ id = ID + 5, name = "Line"},
	{ id = ID + 6, name = "Cirle"},
  { id = ID + 7, name = "Rrc"},
	},
}
menu_help = { name = "Help", items = {
	{ id = ID + 8, name = "Help Docment"},
	{ id = ID + 9, name = "About ApBim"},
	},
}

menu_user = {													
	name = "User",
	items = {
		{id=ID+2000,name="Login"},
	},
}

menu_select = {													
	name = "Select",
	items = {
		{id=ID+1010,name="All"},
		{id=ID+1020,name="None"},
		{id=ID+1030,name="Reverse"},
	},
}


menu_steel = {													
	name = "Steel",
	items = {
		{id=ID+110,name="Property"},
		{id=ID+120,name="Delete"},
		{id=ID+130,name="Add Member"},
		{id=ID+140,name="Add Offset"},
		{id=ID+150,name="Del Offset"},
		-- {id=ID+101,name="H"},
		-- {id=ID+102,name="L"},
		-- {id=ID+103,name="T"},
		-- {id=ID+104,name="U"},
		-- {id=ID+105,name="C"},
		-- {id=ID+106,name="TUB"},
		-- {id=ID+107,name="P"},
		-- {id=ID+108,name="M"},
		-- {id=ID+109,name="PL"},
		-- {id=ID+200,name="Quick Model"},
		-- {id=ID+400,name="s2k"},
		{id=ID+500,name="Test"},
	},
}

--zb
menu_model = {													
	name = "Model",
	items = {
		{id=ID+5000,name="Open Model"},
		{id=ID+5001,name="Save Model"},
		{id=ID+5003,name="Save Have Loop Model"},
		{id=ID+5002,name="Open Ifc Model"},
		{id=ID+5004,name="Save Ifc Model"},
		{id=ID+5005,name="Open Sap Model"},
		{id=ID+5007,name="Open Staad Model"},
		{id=ID+5006,name="Save Ifc File"},

	},
}


function create_menu()
	local m = menu:new{name = "Options"}
	for i = 1,1 do
		local item = menu_item:new{id = ID + i + 1,name = "Tool"}
		m:add_item(item)
	end
	add_menu(frm,m)
	add_menu(frm,menu1)
	add_menu(frm,menu_user)												--better
	add_menu(frm,menu_select)											--better
	add_menu(frm,menu_steel)											--better
	add_menu(frm,menu_model)											--zb
	add_menu(frm,menu_help)											--zb
end
button = { fsState = TBSTATE_ENABLED, fsStyle = BTNS_BUTTON }
function button:new(o)
	local t = o or {}
	self.__index = self
	setmetatable(t,self)
	return t
end
--[[
function button:set_ibitmap(ibitmap)
	self["iBitmap"] = ibitmap
end
function button:set_idcommand(idcommand)
	self["idCommand"] = idcommand
end
function button:set_istring(istring)
	self["iString"] = istring
end
--]]
function button:set(ibitmap,idcommand,istring)
	self["iString"] = istring
	self["idCommand"] = idcommand
	self["iBitmap"] = ibitmap
end
toolbar = { bmpname = "jnt.bmp",nbmps = 74, dxButton = 0, dyButton = 0,dxBitmap = 16,dyBitmap = 15}
function toolbar:new(o)
	local t = o or {}
	self.__index = self
	setmetatable(t,self)
	return t
end
function toolbar:add_button(but)
	self.buttons = self.buttons or {}
	table.insert(self.buttons,but)
end
--[[
toolbar = { bmpname = "toolbar.bmp",nbmps = 36,id = 11040,dxButton = 0, dyButton = 0,dxBitmap = 16,dyBitmap = 15,
	buttons = {
		{iBitmap = 8,idCommand = 10002 , fsState = TBSTATE_ENABLED, fsStyle = BTNS_BUTTON, iString = "open"},
		{iBitmap = 9,idCommand = ID + 2, fsState = TBSTATE_ENABLED, fsStyle = BTNS_BUTTON, iString = "tool1"},
		{iBitmap = 10,idCommand = ID + 3, fsState = TBSTATE_ENABLED, fsStyle = BTNS_BUTTON, iString = "tool2"},
		{iBitmap = 11,idCommand = ID + 4, fsState = TBSTATE_ENABLED, fsStyle = BTNS_BUTTON, iString = "tool3"},
	},
}
toolbar1 = { bmpname = "toolbar.bmp",nbmps = 36,id = 11041,dxButton = 0, dyButton = 0,dxBitmap = 16,dyBitmap = 15,
	buttons = {
		{iBitmap = 8,idCommand = ID + 5, fsState = TBSTATE_ENABLED, fsStyle = BTNS_BUTTON, iString = "≤‚ ‘5"},
		{iBitmap = 9,idCommand = ID + 6, fsState = TBSTATE_ENABLED, fsStyle = BTNS_BUTTON, iString = "tool6"},
		{iBitmap = 10,idCommand = ID + 7, fsState = TBSTATE_ENABLED, fsStyle = BTNS_BUTTON, iString = "tool7"},
	},
}
--]]
local tool1 = toolbar:new{
	id = 11041,
	buttons = {
		button:new{iBitmap = 8,idCommand  = ID + 5,iString = "tool5"},
		button:new{iBitmap = 9,idCommand  = ID + 6,iString = "tool6"},
		button:new{iBitmap = 10,idCommand  = ID + 7,iString = "tool7"},
	},
}
function create_toolbar()
	local tool = toolbar:new{id = 11040}
	for i = 1,55 do 					--zgb
		local but = button:new()
		but:set(i-1 , ID + i,"tool" .. i)
		tool:add_button(but)
	end
	
	
--[[	for i = 8,60 do 
		local but = button:new()
		but:set(i + 7, ID + i - 8 + 1,"tool" .. i-9+2)
		tool:add_button(but)
	end
--]]
--toolbar = { bmpname = "jnt.bmp",nbmps = 74, dxButton = 0, dyButton = 0,dxBitmap = 16,dyBitmap = 15}
	crt_toolbar(frm,tool)
	
	--zgb-----------------------------------------------------------------
	local tool_tyl = toolbar:new{id = 11042,bmpname = "jnt_tyl.bmp",nbmps = 3,
		buttons = {
			button:new{iBitmap = 0,idCommand  = ID + 10,iString = "T.L.Lin"},
			button:new{iBitmap = 1,idCommand  = ID + 11,iString = "T.L.Lin"},
			button:new{iBitmap = 2,idCommand  = ID + 12,iString = "T.L.Lin"},
		},	
	};
	crt_toolbar(frm,tool_tyl);	
	--zgb-----------------------------------------------------------------
end
