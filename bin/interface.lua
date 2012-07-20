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
menu1 = { name = "test2", items = {
	{ id = ID + 5, name = "test21"},
	{ id = ID + 6, name = "test22"},
  { id = ID + 7, name = "test23"},
	},
}
																		--better
menu_steel = {													
	name = "Steel",
	items = {
		{id=ID+130,name="Add Member"},
		{id=ID+110,name="Property"},
		{id=ID+120,name="Delete"},
		{id=ID+101,name="H"},
		{id=ID+102,name="L"},
		{id=ID+103,name="T"},
		{id=ID+104,name="U"},
		{id=ID+105,name="C"},
		{id=ID+106,name="TUB"},
		{id=ID+107,name="P"},
		{id=ID+108,name="M"},
		{id=ID+109,name="PL"},
		{id=ID+200,name="Quick Model"},
		{id=ID+400,name="Test"},
	},
}
function create_menu()
	local m = menu:new{name = "test1"}
	for i = 1,3 do
		local item = menu_item:new{id = ID + i + 1,name = "test" .. i}
		m:add_item(item)
	end
	add_menu(frm,m)
	add_menu(frm,menu1)
	add_menu(frm,menu_steel)											--better
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
toolbar = { bmpname = "toolbar.bmp",nbmps = 36, dxButton = 0, dyButton = 0,dxBitmap = 16,dyBitmap = 15}
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
	local but = button:new()
	but:set(8,10002,"open")
	tool:add_button(but)
	for i = 9,11 do 
		but = button:new()
		but:set(i, ID + i - 9 + 2,"tool" .. i-9+2)
		tool:add_button(but)
	end
	crt_toolbar(frm,tool)
	crt_toolbar(frm,tool1)
end
