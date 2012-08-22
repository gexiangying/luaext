package.cpath="?.dll;?51.dll"
local luaext = require "luaext"
local iup = require "iuplua"
local iupcontrol = require( "iupluacontrols" )
require "luaredis"
local room = require "room"
local test = require "test"
local interface = require "interface"
local object = require "object"


local file_dlg  = require "iup_filedlg"
local rei_test  = require "rei_test"


----login---------------------------------------------------better
-- local redis_ = require("luaredis");
local login_ = nil;

local function model_login(redis, result, tip)
	login_ = result;
	if redis then redis:close() end;
	if not result then 
		luaext.msg("USER",tip);
	end;
end

function login(name,pass)
	trace_out("login...\n");
	if not name or not pass then return end;
	local redis = luaredis.new("www.qqft.com",6379);
	if not redis then model_login(redis,nil,"Net wrong") return end;
	trace_out("checking...\n");
	local stdpass,result = redis:hget("user",name);
	if result~=1 then model_login(redis,nil,"Name is wrong") return end;
	if pass~=stdpass then model_login(redis,nil,"Password is wrong") return end;
	trace_out("success\n");
	model_login(redis,true);
	return true;
end

function add_user(name,pass)
	trace_out("#### 	add_user() 	####\n");
	if not name or not pass then return end;
	local redis = luaredis.new("www.qqft.com",6379);
	if not redis then trace_out("Net wrong\n") return end;
	local result = redis:hset("user",name,pass)
	trace_out("hset result="..result.."\n");
	local val = redis:hget("user",name);
	trace_out("hget value="..(val or "nil").."\n");
	redis:close();
	trace_out("Teh End\n");
end

-- add_user("x","x");

require("steel_user").pop();
if not login_ then return end;

----login-----------------


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



g_scene  = {};

local stl_mgr_ = require("steel_mgr");							-- better
local stl_cmd_ = require("steel_cmd");							-- better
local modelcmd = require("model_cmd");							-- zgb
local iup_axis  = require "iup_axis_dlg"						-- zgb



function frm_on_command(cmd)
	if(cmd == ID + 1) then
---[[
		object.init()
		room.init()
		local s = new_child(frm,"main")
		room.room_textures()
		set_scene_t(s,room.room_t)
		g_scene = s;
---]]
--		file_open()
	elseif stl_cmd_.frm_on_command(cmd) then
	end
	modelcmd.set_view();		--zgb
	
end
function on_timer(scene,idevent)
	trace_out("ontimer:" .. idevent .. "\n")
end
function on_command(cmd,scene)
	stl_mgr_.cur_scene(scene);
	g_scene = scene;
	if(cmd == ID + 1) then
		new_child(frm,"main");
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
		iup_axis.create_axis(scene);		--zgb
		--remove_toolbar(frm,11041)
	  --test.test_get_scene_t(scene)	
		-- set_timer(scene,ID+1000,1000)	
	elseif(cmd == ID +6) then
		--test.test_iup()
		-- kill_timer(scene,ID+1000)

		--test.test_get_scene_t(scene)	
--	elseif(cmd == ID +6) then
--		test.test_iup()
	elseif(cmd == ID +8) then
		os.execute("start English_help.chm");
		rei_test.fun();
	elseif(cmd == ID +9) then
		file_dlg.show_rei_info();
	
	elseif(cmd == ID +10) then
		file_dlg.show_dlg_info("T.L.Lin Internation Group 's Tools. ");
	
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
	elseif stl_cmd_.on_command(cmd,scene) then							-- better
	elseif modelcmd.on_command(cmd) then							-- zb
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
	stl_cmd_.select_main(index);											-- better
end

function select_sub(mainindex,subindex)
	if(select_ary[mainindex]) then
		select_ary[mainindex][subindex] = {}
	end
end

function on_lbuttondown(scene,flags,x,y)
	stl_cmd_.on_lbuttondown(scene,flags,x,y)								-- better
end

function on_lbuttonup(scene,flags,x,y)
	stl_cmd_.on_lbuttonup(scene,flags,x,y)									-- better
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
	stl_cmd_.on_lbuttondblclk(scene,flags,x,y);						--better
	--trace_out("lua:on_lbuttondblclk()\n")
end
function free_scene(scene)
--trace_out("free_secen\n")
end
function on_keydown(scene,key)
	stl_cmd_.on_keydown(scene,key);									--better
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



