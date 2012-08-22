package.cpath="?;?.lua;?.dll"


local ifc_read  = require "IfcRead"
local lua_base  = require "lua_base"
local file_dlg  = require "iup_filedlg"
local sap2kshow  = require "Sap2kShow"
local ifc_write = require "IfcWrite"
local ifc_write_cmd = require "IfcWrite_cmd"
local rei_staad = require "ReiStaad"
local rei_model_ = require "ReiModel"
local ifc_exportifc_dlg = require "iup_exportifc_dlg"

require "ifc"

module (...,package.seeall)


function set_view()
	--trace_out(tostring(g_scene) .. "\n");
	if(g_scene)then
		--scene_clip(g_scene,0,0,10,0,0,0);
		local scene = get_scene_t(g_scene);
		local clip_p = { pt = luapt.new() , x = luapt.normx() , z = luapt.normy1() };
		scene.clip = clip_p;
		set_scene_t(g_scene,scene);	
	end
end


function on_command(cmd)
	
	--set_view();
	
	if(cmd == ID + 5000) then 		--Open Model
		local file_path = file_dlg.open_file_dlg("lua")
		lua_base.open_table(file_path)
		return true;
	elseif(cmd == ID + 5001 )then	--Save Model
		local file_path = file_dlg.save_file_dlg("lua")
		--local file_path = "d:\\no_loop.lua"
		lua_base.save_table("model",model,file_path)	
		return true;
	elseif(cmd == ID + 5003 )then	--Save have loop Model
		local file_path = file_dlg.save_file_dlg("lua")
		--local file_path = "d:\\have_loop.lua"
		lua_base.save_table_loop("model",model,file_path)	
		return true;
	elseif(cmd == ID + 5002 )then	--Open Ifc Model
		local file_path = file_dlg.open_file_dlg("ifc")
		--local file_path = "d:\\revit.ifc"
		--trace_out(file_path .. "\n")
		ifc_read.open_ifc_model(file_path)
		return true;
	elseif(cmd == ID + 5004 )then	--Save Ifc Model
		local file_path = file_dlg.save_file_dlg("ifc")
		trace_out(file_path .. "\n")
		ifc_read.save_ifc_model(file_path)
		return true;
	elseif(cmd == ID + 5005 )then	--open sap Model
		local file_path = file_dlg.open_file_dlg("s2k")
		sap2kshow.open_sap2k(file_path)
		return true;
	elseif(cmd == ID + 5006 )then	--save ifc Model
		ifc_exportifc_dlg.pop();
		local file_path = ifc_exportifc_dlg.setting_info["save_file"];
		--local file = file_path or file_dlg.save_file_dlg("ifc")

		if(file_path)then
			ifc_write.write_ifc(ifc.get_ifc_tab(),file_path);
		end	

		return true;
	elseif(cmd == ID + 5007 )then	--Open Staad Model
		local file_path = file_dlg.open_file_dlg("std");
		staad_model = ifc.new(rei_model_.ReiModel)

		local std_database = rei_staad.open_staad_file(file_path);
		rei_staad.create_model(staad_model,std_database);
		
		rei_staad.add_ifc_model_staad(staad_model);
		return true;
	else
		return false;
	end
end


