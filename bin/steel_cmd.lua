-- package.cpath="?.dll;?51.dll"
-- local luaext = require("luaext");
local stl_mem_dlg_ = require("steel_member_dlg");
local stl_quick_model_ = require("steel_quick_model");
local stl_model_ = require("steel_model");
local stl_case_ = require("steel_case");
local stl_iup_ = require("steel_iup_test");
module (...,package.seeall)

local is_add_member_ = false;
function on_lbuttondown(scene,flags,x,y)
	if is_add_member_ then
		stl_model_.set_default_member_start(client_2_world(scene,x,y))
	end
end

function on_lbuttonup(scene,flags,x,y)
	if is_add_member_ then
		stl_model_.set_default_member_end(client_2_world(scene,x,y))
		stl_model_.add_default_member();
		is_add_member_ = false
	end
end

function on_command(cmd)
	if(cmd == ID + 401) then 		
		stl_model_.model_singleline(1);
		return true;
	elseif(cmd == ID +3 )then
		stl_model_.model_singleline();
		set_lineframe(frm,1)
		return true;
	elseif(cmd == ID + 4) then
		stl_model_.model_singleline();
		set_lineframe(frm,0)
		return true;
	elseif(cmd == ID + 101) then 		
		stl_model_.add_member_type("h");
--		memdlg_.pop();
		return true;
	elseif(cmd == ID + 102) then 		
		stl_model_.add_member_type("l");
		return true;
	elseif(cmd == ID + 103) then 		
		stl_model_.add_member_type("t");
		return true;
	elseif(cmd == ID + 104) then 		
		stl_model_.add_member_type("u");
		return true;
	elseif(cmd == ID + 105) then 		
		stl_model_.add_member_type("c");
		return true;
	elseif(cmd == ID + 106) then 		
		stl_model_.add_member_type("tub");
		return true;
	elseif(cmd == ID + 107) then 		
		stl_model_.add_member_type("p");
		return true;
	elseif(cmd == ID + 108) then 		
		stl_model_.add_member_type("m");
		return true;
	elseif(cmd == ID + 109) then 		
		stl_model_.add_plate();
		return true;
	elseif(cmd == ID + 110) then 		
		stl_mem_dlg_.pop();
		return true;
	elseif(cmd == ID + 120) then 		
		stl_model_.del();
		return true;
	elseif(cmd == ID + 130) then 		
		is_add_member_ = true;
		return true;
	elseif(cmd == ID + 200) then 		
		stl_quick_model_.add();
		return true;
	elseif(cmd == ID + 400) then 	
		stl_case_.add();
		-- stl_iup_.pop_list();
		return true;
	else
		return false;
	end
end
