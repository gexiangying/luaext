package.cpath="?.dll;?51.dll"
local luaext = require "luaext"
local iup = require "iuplua"
local iupcontrol = require( "iupluacontrols" )
local redis = require "luaredis"
local room = require "room"
local test = require "test"
local interface = require "interface"
interface.create_menu()
interface.create_toolbar()
select_ary = {}
model = {	lk = {0.011707,-356.0,-68.0,-1.0},
	texs={
				{"images/mb04.bmp","REPEAT_TEXTURE"},
				{"images/rosewd.bmp","REPEAT_TEXTURE"},
				{"images/pine.bmp","REPEAT_TEXTURE"},
				{"images/sunset.bmp","REPEAT_TEXTURE"},
				{"images/lack2.bmp","REPEAT_TEXTURE"},
				{"images/128x128_1.bmp","REPEAT_TEXTURE"},
				{"images/128x128_4.bmp","REPEAT_TEXTURE"},
				{"images/128x128_3.bmp","REPEAT_TEXTURE"},
				{"images/128x128_2.bmp","REPEAT_TEXTURE"},
				{"images/kb.bmp","REPEAT_TEXTURE"},
			},
	objects = {},
}

local stl_cmd_ = require("steel_cmd");							-- better
local stl_model_ = require("steel_model");								-- better


function on_command(cmd,child)
	if(cmd == ID + 2 ) then 
		room.load_room_item()
	elseif(cmd == ID +3 )then
		set_lineframe(frm,1)
	elseif(cmd == ID + 4) then
		set_lineframe(frm,0)
	elseif(cmd == ID +5) then
		remove_toolbar(frm,11041)
	elseif(cmd == ID +6) then
		test.test_iup()
	elseif stl_cmd_.on_command(cmd) then							-- better
	else luaext.msg("on_command",tostring(cmd))
	end
end

function begin_select(ctrlkey)
	-- if(ctrlkey == 0) then
		-- select_ary = {}
	-- else
		-- select_ary.ctrlkey = true
	-- end
end

function end_select()
end

local function trace_select()
	trace_out("select_ary[] = ")
	for k,v in pairs(select_ary) do
		trace_out( k .. " ")
	end
	trace_out("\n")
end

function select_main(index)
	if (is_ctr_down() ~= 0) and stl_model_.get_select_ary_index(index) then
		stl_model_.model_select(index, nil)
	else
		stl_model_.model_select(index, 1)
	end
end

function select_sub(mainindex,subindex)
	if(select_ary[mainindex]) then
		select_ary[mainindex][subindex] = {}
	end
end

function on_lbuttondown(scene,flags,x,y)
	scene_select(scene,x,y,1,1,1)
	stl_cmd_.on_lbuttondown(scene,flags,x,y)								-- better
end

function on_lbuttonup(scene,flags,x,y)
	stl_cmd_.on_lbuttonup(scene,flags,x,y)								-- better
end

function on_mousemove(scene,flags,x,y)
	x1,y1,z1 = client_2_world(scene,x,y)
	str = string.format("(%f%f%f)\n",x1,y1,z1)
--	trace_out("lua:on_mousemoven" .. str )
end
function on_mbuttondown(scene,flags,x,y)
	--trace_out("lua:on_mbuttondown()\n")
end
function on_mbuttonup(scene,flags,x,y)
	--trace_out("lua:on_mbuttonup()\n")
end
function on_rbuttondown(scene,flags,x,y)
	--trace_out("lua:on_rbuttondown()\n")
end
function on_rbuttonup(scene,flags,x,y)
	--trace_out("lua:on_rbuttonup()\n")
end
function on_rbuttondblclk(scene,flags,x,y)
	--trace_out("lua:on_rbuttondblclk()\n")
end
function on_lbuttondblclk(scene,flags,x,y)
	--trace_out("lua:on_lbuttondblclk()\n")
end
--load_apx("1.apx")
--trace_out("hello" .. " world\n")


