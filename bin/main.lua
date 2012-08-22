package.cpath="?.dll;?51.dll"
local luaext = require "luaext"
local iup = require "iuplua"
local iupcontrol = require( "iupluacontrols" )
local redis = require "luaredis"
local room = require "room"
local test = require "test"
local interface = require "interface"
local object = require "object"

interface.create_menu()
interface.create_toolbar()
--test.test_luapt()
--test.test_luaaxis()
--test.test_spawn_child()
--
select_ary = {}
model = {	--lk = {0.011707,-356.0,-68.0,-1.0},
--	lk = {0.207890,-310,-68,39},
	objects = {},
}

local stl_cmd_ = require("steel_cmd");							-- better
local stl_model_ = require("steel_model");								-- better

function frm_on_command(cmd)
	if(cmd == ID + 1) then
---[[
		object.init()
		room.init()
		local s = new_child(frm,"main")
		room.room_textures()
		set_scene_t(s,room.room_t)
---]]
--		file_open()
	end
end
function on_timer(scene,idevent)
	trace_out("ontimer:" .. idevent .. "\n")
end
function on_command(cmd,scene)
	if(cmd == ID + 1) then
		new_child(frm,"main")
	elseif(cmd == ID + 2 ) then 
		local obj = object.OBJ:new(room.load_room_item())
		obj:add_obj(add_2_model)	
		scene_addobj(scene,obj)
		scene_color(scene,0.0,0.0,1.0)
		model.objects[#model.objects + 1] = obj	
	elseif(cmd == ID +3 )then
		set_lineframe(frm,1)
	elseif(cmd == ID + 4) then
		set_lineframe(frm,0)
	elseif(cmd == ID +5) then
		--remove_toolbar(frm,11041)
	  --test.test_get_scene_t(scene)	
		set_timer(scene,ID+1000,1000)	
	elseif(cmd == ID +6) then
		--test.test_iup()
		kill_timer(scene,ID+1000)
	elseif(cmd == ID +7) then
--[[
		if(model.objects[1].hide == 1) then
			model.objects[1].hide = 0
			else model.objects[1].hide = 1
		end
		obj_hide(frm,model.objects[1])
--]]
		save_image(scene,"render.bmp");
		os.execute("convert render.bmp render.png")
		os.remove("render.bmp")
		send_gcad(frm,"from lua")
	elseif stl_cmd_.on_command(cmd) then							-- better
	else luaext.msg("on_command",tostring(cmd))
	end
end

function begin_select()
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
	if (is_ctr_down() ) and stl_model_.get_select_ary_index(index) then
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

function on_mbuttondblclk(scene,flags,x,y)
	--trace_out("lua:on_rbuttondblclk()\n")
	set_scene_t(scene,room.room_t)
end

function on_rbuttondblclk(scene,flags,x,y)
	--trace_out("lua:on_rbuttondblclk()\n")
end
function on_lbuttondblclk(scene,flags,x,y)
	--trace_out("lua:on_lbuttondblclk()\n")
end
function free_scene(scene)
--trace_out("free_secen\n")
end
function on_keydown(scene,key)
--[[
	trace_out("key press : " .. string.char(key) .. "\n")
	if(is_ctr_down()) then
		trace_out("ctrl keydown\n")
	end
	if(is_alt_down()) then
		trace_out("alt\n")
	end
	if(is_shf_down()) then
		trace_out("shift\n")
	end
--]]
end
function on_gcad_msg(scene,str)
	trace_out( "gcad_msg: " .. str .. "\n")
end

function add_2_model(obj)
--	trace_out("add_obj:index = " .. obj.index .. "\n")
	add_obj(frm,obj)
end

function file_open()
	local obj1 = object.OBJ:new(test.obj1)
	local obj2 = object.OBJ:new(test.obj2)
	local obj3 = (obj1 - obj2)
	--obj3.hide = 1
	--obj3:add_obj(add_2_model)
	
	--local obj4 = obj3:clone()
	obj3:translate(2000.0,0.0,0.0)
	obj3:rotatex(30.0)
	obj3:add_obj(add_2_model)
	local s = new_child(frm,"main")
	scene_addobj(s,obj1)
	scene_addobj(s,obj2)
	s = new_child(frm,"sub")
	scene_addobj(s,obj3)
	verwindow(frm)
end
