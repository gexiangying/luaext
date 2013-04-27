package.cpath="?;?.lua;?.dll"

local ifc_exportifc_dlg = require "iup_exportifc_dlg"

local file_dlg  = require "iup_filedlg"

local progress_bar ;

module (...,package.seeall)


local function wirte_iso_blk(file,iso_infos)
	file:write("ISO-10303-21;\n")
	--[[for i=1, #iso_infos do
		file:write(iso_infos[i] .. "\n")
	end
--]]
end
local function wirte_iso_blk_end(file,iso_infos)
	file:write("ENDSEC;\n")
	file:write("END-ISO-10303-21;\n")
end
local function wirte_headinfo_blk(file,head_infos)
	head_infos = head_infos or {}
	if (#head_infos == 0)then
		file:write("HEADER;" .. "\n")
		file:write([[FILE_DESCRIPTION(('IFC2X_PLATFORM'),'2;1');]] .. "\n")
		file:write([[FILE_NAME('Project Number','2012-07-09T11:02:20',(''),(''),'Autodesk Revit Structure 2012 - 1.0','20110309_2315(x64)','');]] .. "\n")
		file:write([[FILE_SCHEMA(('IFC2X3'));]] .. "\n")
		file:write("ENDSEC;" .. "\n")
	end
	
	
	for i=1, #head_infos do
		file:write(head_infos[i] .. "\n")
	end






	
end
local function 	write_string(file,val)
	if(val) then
		file:write(tostring(val))
	end
end
local function is_ifc_function(file,val)
	local class_name = val.class_name
	local style = val.style	
	if(class_name and style) then
		return 1
	end	
	return nil
end
local function is_ifc_class(file,val)
	local meta = getmetatable(val)
	local key = val.key	
	if(meta and key) then
		return 1
	end	
	return nil
end
local function is_list(file,val)
	local meta = getmetatable(val)
	local key = val.key	
	if((not meta) and (not key)) then
		return 1
	end	
	return nil
end
local function wirte_function(file,val)
	local str = ""
	for i=1 ,#val do
		if (str == "") then
			str = val[i]
		else				
			str = str .."," ..val[i]
		end					
	end
	file:write(tostring(val.class_name).."("..str ..")")	
end
local function wirte_ifc_class(file,val)
	if(val.new_key) then
		file:write(val.new_key)
	else
		file:write(val.key)
	end
end
local function write_list(file,val)
	file:write("(")
	for k,v in pairs(val) do
		if(type(v) == "table") then
			wirte_table(file,v)
		else
			write_string(file,v)
		end
		if(v)then
			file:write(",")
		end	
	end
	file:seek("cur",-1)
	file:write(")")	
end
function wirte_table(file,val)
	if(is_ifc_class(file,val))then
		wirte_ifc_class(file,val)			
	elseif(is_ifc_function(file,val))then
		wirte_function(file,val)			
	elseif(is_list(file,val))then
		write_list(file,val)
	else
		print("error!error!error!the kind can't deal it")
	end
end
local function write_para_new(file,t,p)	
	local parent = getmetatable(p)
	local param = 0
	if(parent) then
		param = write_para_new(file,t,parent) 
	end
	for i = param + 1,param + p.param do
		if(type(t[i]) == "table") then
			wirte_table(file,t[i])
		else
			write_string(file,t[i])
		end
		if (t[i]) then file:write(",") end	
	end
	return (param + p.param)		
end
local function write_para(file,data)
	write_para_new(file,data.result,ifc[data.name])
end

local function check_write(class_name)
	local isdraw_beam = ifc_exportifc_dlg.setting_info["ifcbeam"];
	local isdraw_slab = ifc_exportifc_dlg.setting_info["ifcslab"];
	
	if(class_name == "IFCBEAM")then
		if(isdraw_beam == "OFF")then
			return false;
		end	
	end
	if(class_name == "IFCSLAB")then
		if(isdraw_slab == "OFF")then
			return false;
		end	
			
	end	
	return true;
end
local function wirte_data_blk(file,ifc_data)
	file:write("\n" )
	file:write("DATA;\n" )
	file:write("\n" )
	local i = 1;
	
	for k ,v in pairs(ifc_data) do
	
		progress_bar.value = i / #ifc_data;
		i = i + 1;
		iup.LoopStep();
		
		if check_write(v.class_name) then
			file:write(v.new_key .. "=" .. v.class_name .. "(" );			
			write_para(file,v)
			file:seek("cur",-1)
			file:write(");\n" )		
		end	
	end	
end
function write_ifc(ifc_tab,file_name)
	if(file_name == "")then
		return;	
	end
	progress_bar = file_dlg.start_progress_bar();
	--local out_file = "d:\\out_data.ifc"
	local out_file = file_name
	--trace_out(file_name .. "\n")
	local file = io.open ( out_file,"w+")	
	--table.sort(ifc_tab)
	wirte_iso_blk(file,ifc_tab.iso_infos)
	wirte_headinfo_blk(file,ifc_tab.head_infos)
	wirte_data_blk(file,ifc_tab.ifc_datas)
	wirte_iso_blk_end(file)	

	file_dlg.close_progress_bar();

	file:close(file)
end


