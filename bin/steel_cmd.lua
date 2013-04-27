package.cpath="?.dll;?51.dll"
-- local luaext = require("luaext");
local stl_mem_dlg_ = require("steel_member_dlg");
local stl_quick_model_ = require("steel_quick_model");
local stl_model_ = require("steel_model");
local stl_model_test_ = require("steel_model_test");
local stl_case_ = require("steel_case");
local stl_iup_ = require("steel_iup_test");

local keydown_ = require("steel_keydown");
local mgr_ = require("steel_mgr");
local mgr_test_ = require("steel_mgr_test");
local redis_test_ = require("steel_redis_test");
local tools_ = require("steel_tools");
local user_ = require("steel_user");

module (...,package.seeall)

local is_offset_ = nil;
local offset_pt1_ = nil;
-- local lbndown_ = nil

function frm_on_command(cmd)
	if(cmd == ID + 2000) then 	
		user_.pop();
		-- redis_test_.main();
		return true;
	else
		return false;
	end
end

function on_command(cmd,scene)
	mgr_.cur_scene(scene);
	-- if(cmd == ID + 401) then 		
		-- stl_model_.model_singleline(1);
		-- return true;
	-- elseif(cmd == ID +3 )then
		-- stl_model_.model_singleline();
		-- set_lineframe(frm,1)
		-- return true;
	-- elseif(cmd == ID + 4) then
		-- stl_model_.model_singleline();
		-- set_lineframe(frm,0)
		-- return true;
	-- elseif(cmd == ID + 101) then 		
		-- stl_model_.add_member_type("h");
		-- return true;
	-- elseif(cmd == ID + 102) then 		
		-- stl_model_.add_member_type("l");
		-- return true;
	-- elseif(cmd == ID + 103) then 		
		-- stl_model_.add_member_type("t");
		-- return true;
	-- elseif(cmd == ID + 104) then 		
		-- stl_model_.add_member_type("u");
		-- return true;
	-- elseif(cmd == ID + 105) then 		
		-- stl_model_.add_member_type("c");
		-- return true;
	-- elseif(cmd == ID + 106) then 		
		-- stl_model_.add_member_type("tub");
		-- return true;
	-- elseif(cmd == ID + 107) then 		
		-- stl_model_.add_member_type("p");
		-- return true;
	-- elseif(cmd == ID + 108) then 		
		-- stl_model_.add_member_type("m");
		-- return true;
	-- elseif(cmd == ID + 109) then 		
		-- stl_model_.add_plate();
		-- return true;
	-- elseif(cmd == ID + 200) then 		
		-- stl_quick_model_.add();
		-- return true;
	-- elseif(cmd == ID + 400) then 	
		-- stl_case_.add();
		-- stl_iup_.pop_list();
		-- return true;
	if(cmd == ID + 110) then 		
		mgr_.pop_property_dlg();
		return true;
	elseif(cmd == ID + 120) then 		
		mgr_.del();
		return true;
	elseif(cmd == ID + 130) then 		
		is_add_member_ = true;
		return true;
	elseif(cmd == ID + 140) then 		
		is_offset_ = true;
		return true;
	elseif(cmd == ID + 150) then 
		mgr_.cur_offset_object(nil);
		return true;
	elseif(cmd == ID + 500) then 	
		mgr_test_.add();
		return true;
	--select
	elseif(cmd == ID + 1010) then 	
		mgr_.select_all();
		return true;
	elseif(cmd == ID + 1020) then 	
		mgr_.select_none();
		return true;
	elseif(cmd == ID + 1030) then 	
		mgr_.select_reverse();
		return true;
	else
		return false;
	end
end

function select_main(index)
	if (is_ctr_down()) and mgr_.is_select(index) then
		mgr_.select(index, nil)
	else
		mgr_.select(index, true)
	end
end

function on_lbuttondown(scene,flags,x,y)
	mgr_.cur_scene(scene);
	-- lbndown_ = {x=x,y=y};
	if is_offset_ then
		offset_pt1_ = {client_2_world(scene,x,y)};
	end
end

function on_lbuttonup(scene,flags,x,y)
	mgr_.cur_scene(scene);
	local w,h = 1,1;
	-- if lbndown_ then 
		-- x,y = x-(x-lbndown_.x)/2,y-(y-lbndown_.y)/2;
		-- w,h = math.abs(x-lbndown_.x),math.abs(y-lbndown_.y);
		-- lbndow_=nil;
	-- end;
	-- w = w>3 and w or 3;
	-- h = h>3 and h or 3;
	scene_select(scene,x,y,w,h,1)
	if is_offset_ then
		trace_out("on_lbuttonup()\n");
		local offset_pt2 = {client_2_world(scene,x,y)};
		local axis = require("steel_geometry").Axis:new():set_offset_line{offset_pt1_,offset_pt2};
		mgr_.cur_offset_object(axis);
		is_offset_ = nil
	end
end

function on_lbuttondblclk(scene,flags,x,y)
	mgr_.cur_scene(scene);
	scene_select(scene,x,y,1,1,1)
	mgr_.pop_property_dlg();
end

function on_keydown(scene,key)
	mgr_.cur_scene(scene);
	trace_out("keyownd, key="..key.."\n");
	local result =  type(keydown_[key])=="function" and keydown_[key](scene);
	mgr_.update(scene);
end

