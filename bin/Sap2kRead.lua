package.cpath="?;?.lua;?.dll"

local steel_tools_ = require "steel_tools";

local sap_section_ = require "Sap2kSection";
--f = io.open ("D:\\out.s2k","w+")
--f:write("sline = ", sline, "\n")
--f:close()


module (...,package.seeall)



--  ################## for definition and general utilities  #######################
head_blk = {}			--store the output file for head section
data_blk = {}			--store the output file for data section
database = {}
suntest = {}			--for table review test

function error_message(code)		--print the error message
	print(code)
	return code
end

function new(tab, o)
	o = o or {}
	tab.__index = tab
	setmetatable(o, tab)
	return o
end

function string_trim (str)  --delet the space in both side of the lane
	return (string.gsub(str,"^%s*(.-)%s*$", "%1"))
end

function read_input_file(input_file_name)  --read from input_file_name return input_str 
	local f = io.open(input_file_name,"r")	
	local str = f:read("*all")   --read entire input file without any treatment
	io.close()
	return str
end

function check_multi_line(line, marker)  --marker (string) = symbol of continue line
	local str = string_trim (line)
	if string.sub(str, -1, -1) == marker then
		str = string.sub(str, 1, -2)
	else
		str = nil
	end
	return str
end

function string_to_table(str, marker)  --to find \n and change the string to table
	local i = 0; local j = 0;  local k = 1; 
	local line = ""; local mline = ""; local s
	local tab = {}
	while true do
		if k then mline = "" end
		i = string.find(str, "\n", i+1)	-- find 'next' newline
		if i == nil then break end
		line = string.sub(str, j+1, i-1) 
		j = i
	--for treatment of multiple lines
		s = check_multi_line(line, marker)
		if s then
			mline = mline..s
			k = nil 
		else 
			mline = mline..line
			k = 1
		end
	--for transfer one line data from str to tab except the empty lines
		if string.find(mline, "%w") and not s then 
			table.insert(tab, mline)		
		end
	end
	return tab
end

function escape (s)	-- change magic sign to 16 system code 
    s = string.gsub(s, "([&=+%c])", function (c)
       return string.format("%%%02X", string.byte(c))
    end)
    s = string.gsub(s, " ", "+")
    return s
end

function unescape (s)  --return back of the magic sign to letter
    s = string.gsub(s, "+", " ")
    s = string.gsub(s, "%%(%x%x)", function (h)
       return string.char(tonumber(h, 16))
    end)
    return s
end

function separate_line_param(line) --consider one line saparate including the magic sign
	local tab = {}
	local t = {}; t_new = {}
	local val_new
	for val in string.gmatch(line, ("\".-\"")) do -- get string between quation marks
		val_new = escape (val)
		val_new = string.gsub(val_new,"(%W)","%%%1")
		val = string.gsub(val,"(%W)","%%%1")
		table.insert(t, val)
		table.insert(t_new, val_new)
	end
	for k, val in pairs(t) do
		val_new = t_new[k]
		line = string.gsub(line, val, val_new)
	end
	line = string.gsub(line,"%\n"," ")
	tab["speci"] = {}
	tab["param"] = {}

	for k, val in string.gmatch(line, "%s*([^ ]+)%s*=%s*([^ ]+)") do
		k = unescape (k) 
		val = unescape (val)
		table.insert(tab["speci"], k)
		table.insert(tab["param"], val)
	end
	return tab
end	

function create_data_blk(input_tab)  --creat the data blok for out put
	local tab = {} 
	local key; local section_flag; local count
	for k, line in ipairs(input_tab) do
		if (string.sub(line, 1, 14) == "END TABLE DATA") then
			print ("END OF THE INPUT FILE")
			break		
		end
		if(string.sub(line, 1, 6) == "TABLE:") then
			key = string.match(line, "%\"(.*)%\"")
			if key then
				section_flag = nil
				tab[key] = {}
				count = 1
			else
				error_message("Error Code 102 no TABLE key")  			--Error (101)
			end
--print ("key = ", key)
		else
			section_flag = ""
		end
		if section_flag and key then	--start treatment of a key section 
			tab[key][count] = separate_line_param(line)
			--print ("key =",key, " count =",count)
			count = count +1
		end
	end
	return tab
end

--  ################## for input data and treatment  #######################
-- store input file to head_blk and data_blk
function store_sap2k_input(input_file_name,heads,datas) 
	local input_str = read_input_file(input_file_name)--read entire input file only
	local input_tab = string_to_table(input_str, "_")
	heads = create_head_blk(input_tab)  --store the head part
	datas = create_data_blk(input_tab)  --store the data part

	return heads,datas;
end
	--tab["speci"] = {}
	--tab["param"] = {}

local function get_jnt_coordinates(datas,jnt_coords)
	local jnts = datas["JOINT COORDINATES"];
	if not jnts then
		return;
	end
	for k in pairs(jnts) do
		local jnt = {};
		jnt.index = jnts[k].param[1];
		jnt.coord_sys = jnts[k].param[2];
		jnt.coord_type = jnts[k].param[3];
		jnt.x = jnts[k].param[4];
		jnt.y = jnts[k].param[5];
		jnt.z = jnts[k].param[6];
		jnt.special_jt = jnts[k].param[7];
		jnt.g_x = jnts[k].param[8];
		jnt.g_y = jnts[k].param[9];
		jnt.g_z = jnts[k].param[10];
		jnt_coords[jnt.index] = jnt;
	end
end
local function get_connect_frame(datas,connect_frames)
	local frames = datas["CONNECTIVITY - FRAME"];
	if not frames then
		return;
	end
	for k in pairs(frames) do
		local fra = {};
		fra.index = frames[k].param[1];
		fra.start_jnt = frames[k].param[2];
		fra.end_jnt = frames[k].param[3];
		fra.is_curve = frames[k].param[4];
		fra.length = frames[k].param[5];
		fra.centroid_x = frames[k].param[6];
		fra.centroid_y = frames[k].param[7];
		fra.centroid_z = frames[k].param[8];
		connect_frames[fra.index] = fra;
	end
	
end
local function get_sections_db(datas,sections_db)
	local sects = datas["AREA SECTION PROPERTIES"];
	if not sects then
		return;
	end
	for k in pairs(sects) do
		local sec = {};
		sec.section = sects[k].param[1];
		sec.material = sects[k].param[2];
		sec.matAngle = sects[k].param[3];
		sec.areaType = sects[k].param[4];
		sec.type = sects[k].param[5];
		sec.thickness = sects[k].param[6];
		sec.bendThick = sects[k].param[7];
		sec.color = sects[k].param[8];
		sections_db[sec.section] = sec;
	end
	
end
local function get_jnt(area,name)
	for i=1 , #area.speci do
		if(area.speci[i] == name)then
			return area.param[i];
		end
	end
end

local function get_jnts(area,jnts)
	local i = 1;
	local jnt = get_jnt(area,"Joint1");
	while jnt do
		jnts[i] = jnt;		
		i = i+1;
		local name = "Joint" .. i;
		jnt = get_jnt(area,name);
	end
end

local function get_connect_areas(datas,connect_areas)
	local areas = datas["CONNECTIVITY - AREA"];
	if not areas then
		return;
	end
	for k in pairs(areas) do
		local area = {};
		area.index = areas[k].param[1];
		
		local jnts = {};
		get_jnts(areas[k],jnts);
		area.numJoints = #jnts;
		--steel_tools_.otrace(jnts);
		
		
--[[		area.numJoints = areas[k].param[2];
		local jnts = {};
		for i=1,area.numJoints do
			local node = areas[k].param[2+i];
			jnts[i] = node; 		
		end
--]]	
		area.jnts = jnts;
		--此处注意版本问题，如果再进一步处理时注意
	--[[	
		local pos = area.numJoints+2
		area.perimeter = areas[k].param[pos];
		pos = pos+1;
		area.areaArea = areas[k].param[pos];
		pos = pos+1;
		area.centroidX = areas[k].param[pos];
		pos = pos+1;
		area.centroidY = areas[k].param[pos];
		pos = pos+1;
		area.centroidZ = areas[k].param[pos];--]]
		
		connect_areas[area.index] = area;
	end
	
end
local function get_assign_sections_db(datas,assign_sections_db)
	local assign_sects = datas["AREA SECTION ASSIGNMENTS"];
	if not assign_sects then
		return;
	end
	for k in pairs(assign_sects) do
		local assign = {};
		assign.index = assign_sects[k].param[1];
		assign.section = assign_sects[k].param[2];
		assign.matProp = assign_sects[k].param[3];
		assign_sections_db[assign.index] = assign;
	end
	
end
local function deal_area_pts(connect_area,jnt_coords)
	local pts = {};
	for i=1,#connect_area.jnts do
		local index = connect_area.jnts[i];		
		if(jnt_coords[index])then
			local p = {x=jnt_coords[index].x,y=jnt_coords[index].y,z=jnt_coords[index].z};
			pts[i] = p;
		else
			trace_out("area id = " ..index .. "deal_area_pts : jnt_coords[index] = nil\n");
		end
	end	
	pts[#pts+1] = pts[1];
	connect_area.pts = pts;
	return connect_area.pts
end

local function set_section_to_areas(jnt_coords,connect_areas,assign_sections_db,sections_db)
	for k in pairs(connect_areas) do
		local index = connect_areas[k].index;
		--print(index);
		local item = assign_sections_db[index];
		if(item)then
			connect_areas[k].section = item.section;
			local sec = sections_db[item.section];
			if(sec)then
				connect_areas[k].thickness = sec.thickness;			
			else
				connect_areas[k].thickness = 8.0;
				trace_out("no assign section in assign_sections_db.connect_areas[k].thickness = 8.0\n");
			end						
		else
			connect_areas[k].thickness = 8.0;
			if(trace_out)then
				trace_out("no assign section in assign_sections_db.connect_areas[k].thickness = 8.0\n");			
			else
				print("no assign section in assign_sections_db.connect_areas[k].thickness = 8.0\n");			
			end			
		end
		
		connect_areas[k].pts = deal_area_pts(connect_areas[k],jnt_coords);
	end
end

local function get_jnt_num(cols)
	local num = 0;
	for i=1,#cols do
		if(string.find(cols[i],"Joint")) then
			num = num+1;
		end
	end
	return num;
end
local function get_solids(datas,solids)
	local sols = datas["CONNECTIVITY - SOLID"];
	if not sols then
		return;
	end
	for k in pairs(sols) do
		local s = {};
		s.index = sols[k].param[1];
		local num_jnt = get_jnt_num(sols[k].speci);
		local jnts = {};
		for i=1,num_jnt do
			local node = sols[k].param[1+i];
			jnts[i] = node; 		
		end
		s.jnts = jnts;
		
		local pos = num_jnt+1;
		s.Volume = sols[k].param[pos];
		pos = pos+1;
		s.centroidX = sols[k].param[pos];
		pos = pos+1;
		s.centroidY = sols[k].param[pos];
		pos = pos+1;
		s.centroidZ = sols[k].param[pos];
		
		--利用初始化厚度,这个跟solid的厚度有关系。
		s.thickness = 5;
		
		
		solids[s.index] = s;
	end
	
end

local function deal_area_pts_for_solids(solid,jnt_coords)
	local pts = {};
	for i=1,#solid.jnts do
		local index = solid.jnts[i];		
		local p = { x=jnt_coords[index].x, y=jnt_coords[index].y, z=jnt_coords[index].z };
		pts[i] = p;
	end	
	
	pts[#pts+1] = pts[1];
	solid.pts = pts;
	return solid.pts
end

local function set_solids_datas(jnt_coords,solids)
	for k in pairs(solids) do
		solids[k].pts = deal_area_pts_for_solids(solids[k],jnt_coords);
	end
end


--sap_model--
Sap_Model = {
			jnt_coords = {}	,
			connect_frames = {},
			connect_areas = {area=1,num_jnts=4,jnts={1,2,3,5},},--注意在此存储要加入截面名，再到截面库中取到截面的信息
			sections_db = {}, -- 截面库
			assign_sections_db = {} ,-- 指定截面库
			solids = {}, --solid 体结构
			frame_sections_db = {}, --frame 截面库
			frame_sect_assign_db = {} --frame 指定截面库
};
function get_sap_model(file_name,sap_model)
	sap_model = sap_model or {};	
	head_blk,data_blk = store_sap2k_input(file_name,heads,datas);
	sap_model.jnt_coords  = {};
	get_jnt_coordinates(data_blk,sap_model.jnt_coords);
	sap_model.connect_frames  = {};
	get_connect_frame(data_blk,sap_model.connect_frames);
	--取得截面库
	sap_model.sections_db  = {};
	get_sections_db(data_blk,sap_model.sections_db);
	
	--取得指定板或多边形
	sap_model.connect_areas  = {};
	get_connect_areas(data_blk,sap_model.connect_areas);
	--取得指定截面库
	sap_model.assign_sections_db  = {};
	get_assign_sections_db(data_blk,sap_model.assign_sections_db);
	
	--设定板的截面属性名称和其厚度，同时赋值
	set_section_to_areas(sap_model.jnt_coords,sap_model.connect_areas,sap_model.assign_sections_db,sap_model.sections_db);
	
	--取得指定的solid
--[[	sap_model.solids  = {};
	get_solids(data_blk,sap_model.solids);
	
	
	set_solids_datas(sap_model.jnt_coords,sap_model.solids);
--]]	
	
	
	
	
	--取得构件截面库
	sap_model.frame_sections_db  = {};
	sap_section_.get_frame_section_db(data_blk,sap_model.frame_sections_db);	
	sap_model.frame_sect_assign_db  = {};
	sap_section_.get_frame_sect_assign_db(data_blk,sap_model.frame_sect_assign_db);
	sap_section_.set_section_to_frames(sap_model.connect_frames,sap_model.frame_sect_assign_db,sap_model.frame_sections_db);
	
end



function create_head_blk(input_tab)
	local s = string.sub(input_tab[1], 1, 4)
	if (s == "File") then --read and store the first line (title)
		return s
	else		
		error_message("Error Code 101 not started with File command")  		 --Error (101)
	end
end

--[[model = {}
get_sap_model("D:\\a.s2k",model);
print("ssss");
--]]
