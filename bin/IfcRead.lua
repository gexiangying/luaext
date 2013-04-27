package.cpath="?;?.lua;?.dll"

require "ifc"
local ifc_write = require "IfcWrite"
local luaext = require "luaext"

local ifc_model = require "IfcModel"



ifc_tab = {
	iso_infos = {},
	head_infos = {},
	datas = {},
	ifc_datas = {},
}
enum_tab  = {}
ifc_data = {}

local function deal_iso_stand(line,f,ifc_tab)
	line = f:read("*line")
	table.insert(ifc_tab.iso_infos,line)
	return line
end
local function deal_head_infos(line,f,ifc_tab)
	table.insert(ifc_tab.head_infos,line)
	while(true) do	
		if(string.find(line,"ENDSEC")) then break end
		line = f:read("*line")
		table.insert(ifc_tab.head_infos,line)
	end
	return line
end
local function deal_data_line(line,f,ifc_tab)
	if(string.find(line,";")) then 					
		table.insert(ifc_tab.datas,line)
		return line
	else
		local all_line = line
		local temp 
		local next_line
		line = string.sub(line,1,#line-1)
		while(true) do	
			temp = f:read("*line")
			if(string.find(temp,";")) then 	
				all_line = line .. ","..temp
				table.insert(ifc_tab.datas,all_line)
				break
			else
			end
		end		
	end
	return  all_line
end
local function deal_datas(line,f,ifc_tab)
	line = f:read("*line")
	while(true) do	
		if(string.find(line,"ENDSEC")) then break end
		if (string.sub(line,1,1) == "#") then
			deal_data_line(line,f,ifc_tab)		
		end			
		line = f:read("*line")
	end
	return line
end

function open_ifc_new(file_name)
	local f = io.open(file_name,"r")
	local all = f:read("*all")	
	local heads = string.match(all,"(.*DATA;)")	
	print(heads)
	line = f:read("*line")	
	while true do
		if (not line) then break end
		print(line)					
	end
	io.close()		
end

function open_ifc(file_name,ifc_tab)
	local f = io.open(file_name,"r")
	line = f:read("*line")	
	while true do
		if (not line) then break end					
		if(string.find(line,"ISO-")) then
			line = deal_iso_stand(line,f,ifc_tab)
		elseif (string.find(line,"HEADER;")) then
			line = deal_head_infos(line,f,ifc_tab)			
		elseif (string.find(line,"DATA;")) then
			line = deal_datas(line,f,ifc_tab)
		else
			line = f:read("*line")
		end				
	end
	io.close()	
end	





local function set(t,p,val)
	local parent = getmetatable(p)
	local param = 0
	if(parent) then
		param = set(t,parent,val) 
	end
	for i = param + 1,param + p.param do
		t[i] = val[i]
	end
	return (param + p.param)
end
function create_ifc(k,class_name,val)
	ifc_data[k].key = k
	ifc_data[k].name = class_name 
	ifc_data[k].data = val 

	if ifc[class_name] then 
		set(ifc_data[k].result,ifc[class_name],ifc_data[k].data)	
	else
		print("????error! the class_name = " .. class_name .. "   isn't exist.")
	end	
end
local function create_class(key,class_name)
	if not ifc[class_name] then 
		print("????error! the class_name = " .. class_name .. "   isn't exist.")
	end	
	if ifc[class_name] then 		
		local t = ifc.new(ifc[class_name])
		t.key = key
		ifc_data[key] = {}
		ifc_data[key].result = t
		ifc_data[key].class_name = class_name
	end	
end
local function get_funtion_str(val,str)
	--处理函数中还有enmu或其它形式
	local fun_para = string.match(val,"(%(.*%))")
	local fun_name = string.sub(val,1,string.find(val,"%("))

	local temp = ""
	local s = get_para_str(fun_para,temp)
	
	return str .. fun_name ..s .. "),"
end
local function get_string_str(val,str)
	return str .."\"" .. val .."\","
end
local function get_number_str(val,str)
	return str .. val ..","
end
local function get_daole_str(val,str)
	return str .."\"" .. val .."\","
end
local function get_table_str(val,str)
	--print(val)
	str = str .. "{"
	str = get_para_str(val,str)
	str = str .. "},"
	return str
end
local function get_enmu_str(val,str)
	local t = "\"" .. val .. "\""
	table.insert(enum_tab,val)
	str = str .. t ..","
	return str
end
local function get_entity_str(val,str)
	local t = "ifc_data[\"" .. val .. "\"].result"
	str = str .. t ..","
	return str
end
local function deal_para(type,val,str)
	if(type == 1) then --函数调用
		return get_funtion_str(val,str)		
	elseif(type == 2)	then --字符串		
		return get_string_str(val,str)		
	elseif(type == 3)	then --数字		
		return get_number_str(val,str)		
	elseif(type == 4)	then --$		
		return get_daole_str(val,str)		
	elseif(type == 5)	then --表		
		return get_table_str(val,str)		
	elseif(type == 6)	then --宏变量		
		return get_enmu_str(val,str)		
	elseif(type == 7)	then --#23		
		return get_entity_str(val,str)		
	else			
		return get_string_str(val,str)		
	end
end
function get_para_str(para,para_str)
	local t = luaext.str_machine(para)
	for k,v in ipairs(t) do
		--print(v["type"] .. " ".. v["str"])
		para_str = deal_para(v["type"],v["str"],para_str)
	end
	para_str = string.sub(para_str,1,#para_str - 1)	
	return para_str	
end
function format_ifc(ifc_tab)
	local out_file = "d:\\data.ifc"
	local file = io.open ( out_file,"w+")
	file:write("setfenv(1,ifc)\n")
	for k in pairs(ifc_tab.datas) do
		local line = ifc_tab.datas[k]
		local key,class_name = string.match(line,"(.+)%s*=%s*(%w+)")
		pos = string.find(line,"%(")
		pos_r = string.find(line,";")
		--if(line ~= "") then
					
			--print(line)
			local parameter = string.sub(line,pos,pos_r-1)			
			local para_str = ""
			local para = get_para_str(parameter,para_str)
			para = "{" .. para .. "}"		
			para = string.gsub(para,"%(","{")
			para = string.gsub(para,"%)","}")				
			file:write("create_ifc(" .. "\"" ..key .. "\"" .. ","  .. "\""..class_name .. "\"" .. ",".. para .. ")\n")
			create_class(key,class_name)
		--end	
	end		
	file:close(file)
	return out_file
end
function number_ifc(ifc_data)
	local global_id = 1
	for k in pairs(ifc_data) do
		if (ifc_data[k].key) then
			local new_key = string.format("#%d",global_id)
			ifc_data[k].result.new_key = new_key
			ifc_data[k].new_key = new_key
			global_id = global_id + 1
		end
	end	
end
local function print_tab_ifc(ifc_data)
	print("name = ".. ifc_data.name .. " ifc_data.result value = ")	
	for k in pairs(ifc_data.result) do
		print(ifc_data.result[k])
	end
end
local function check_ifc_data(ifc_datas)	
	for k in pairs(ifc_datas) do
		print_tab_ifc(ifc_datas[k])
	end
end

--[[
--open_ifc_new("D:\\revit.ifc")
--open_ifc("D:\\aaa.ifc",ifc_tab)
open_ifc("D:\\revit.ifc",ifc_tab)
--open_ifc("D:\\test revit.ifc",ifc_tab)
print("****************Start fulling data to Ifc Structure!!**************************************************************")
local out_file = format_ifc(ifc_tab)
dofile(out_file )
--check_ifc_data(ifc_data)
number_ifc(ifc_data)
ifc_tab.ifc_datas = ifc_data
print("****************Start Write ifc to file  !!**************************************************************")
ifc_write.write_ifc(ifc_tab)
print("****************draw ifc model !!**************************************************************")
ifc.draw_ifc_model(ifc_tab.ifc_datas)
--]]


module (...,package.seeall)

function open_ifc_model(file_name)
	trace_out("open_ifc_model start .\n")
	open_ifc(file_name,ifc_tab)
	local out_file = format_ifc(ifc_tab)
	dofile(out_file)
	number_ifc(ifc_data)
	ifc_tab.ifc_datas = ifc_data
	ifc.draw_ifc_model(ifc_data)
	--ifc.model(ifc_data);
	--ifc.model_draw();
	trace_out("open_ifc_model end .\n")
end
function save_ifc_model(file_name)
	ifc_write.write_ifc(ifc_tab,file_name)
	
end
