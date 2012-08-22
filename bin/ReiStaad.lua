package.cpath="?;?.lua;?.dll"

local rei_model_g = require "ReiModel"
local rei_operate = require "ReiOperate"
local rei_obj = require "ReiObject"
local rei_structure = require "ReiStructure"
local rei_geometry = require "ReiGeometry"

local luaext = require "luaext"
local rei_load = require "ReiLoad"
local rei_odpobj = require "ReiOdpObject"

local steel = require("steel")

local std_io = require("STAADIO")
local g_pt_ = require "g_pt"
local trace_ = require "trace_obj"

local staad_section = require "StaadSection"
local steel_tools_ = require "steel_tools";
local staad_section_db = require "Staad_Section_DB";

local file_dlg  = require "iup_filedlg"

require "ifc"



module (...,package.seeall)



--STAAD SPACE--------------
local function deal_staad_segment(line,f,rei_model)
	--luaext.msg("deal_staad_segment  ","start")
	--print ("deal_staad_segment start")
	control,name  = string.match(line,"([^ ]+) ([^ ]+)")
	--rei_model.operate = {}
	rei_model.operate.control = control
	rei_model.operate.name = name
	i, j = string.find(line, rei_model.operate.name) 
	rei_model.operate.title = string.sub(line,j+1, -1)				
	line = f:read("*line")
	
	--luaext.msg("deal_staad_segment  control",rei_model.operate.control)
	--luaext.msg("deal_staad_segment  name",rei_model.operate.name)
	--print ("\trei_model.operate.control = " .. rei_model.operate.control)
	--print ("\trei_model.operate.name = " .. rei_model.operate.name)
	--print ("\trei_model.operate.title = " .. rei_model.operate.title)
	return line
end
--START JOB INFORMATION--------------
local function deal_job_segment(line,f,rei_model)
	--print ("deal_job_segment start")
	line = f:read("*line")
	engineer,da,data = string.match(line,"([^ ]+) ([^ ]+) ([^ ]+)")
	--rei_model.rei_project = {}
	rei_model.rei_project.control = engineer
	rei_model.rei_project.message = data
	
	--print ("\trei_model.rei_project.control = " .. rei_model.rei_project.control)
	--print ("\trei_model.rei_project.message = " .. rei_model.rei_project.message)
	
	line = f:read("*line")
	if( string.find(line,"END")) then
		return line
	end
	
	return line
end
--INPUT WIDTH 79--------------
local function deal_input_width_segment(line,f,rei_model)
	--print ("deal_input_width_segment start")
	
	input,width,val = string.match(line,"([^ ]+) ([^ ]+) ([^ ]+)")
	rei_model.operate.input_width = val
		
	--print ("\trei_model.operate.input_width = " .. rei_model.operate.input_width)
		
	line = f:read("*line")
	return line
end
--UNIT FEET KIP--------------
local function deal_unit_segment(line,f,rei_model)
	--print ("deal_unit_segment start")
	line = f:read("*line")
	return line
end


--JOINT COORDINATES--------------
local function deal_jnt_coord_segment(line,f,rei_model)

	while true do
		line = f:read("*line")
		--print(line)
		if not line then break end
			
		pos = string.find(line,";")			
		if(not pos) then
			return line
		end
		local i=0
		local j=0
		--luaext.msg("f:read",line)
		while true do				
			j = i+1	
			i = string.find(line, ";",i+1) 
			
			--print(i)
			if not i then break end
			local sx = string.sub(line, j,i-1)
			local n, x, y, z = string.match(sx,"([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+)")
			local k = tonumber(n)
			local coord = rei_structure.new(rei_geometry.ReiGeoShapeCoordinate)
			coord.id = k
			coord.number_id = k
			coord.value_list = {}
			coord.value_list[1] = tonumber(x)
			coord.value_list[2] = tonumber(y)
			coord.value_list[3] = tonumber(z) 
				
			--print ("\tcoord.number_id = " .. coord.number_id)
			--print ("\tcoord.value_list[1] = " .. coord.value_list[1])
			--print ("\tcoord.value_list[2] = " .. coord.value_list[2])
			--print ("\tcoord.value_list[3] = " .. coord.value_list[3])
		
			rei_model.nodes[coord.number_id] = coord
			
			--line = 	string.sub(line, j,-1)
			
			--k = k + 1
		end
	end		
	
	
	--luaext.msg("deal_mem_incidence_segment end",line)
	--line = f:read("*line")
	return line
end
--MEMBER INCIDENCES--------------
local function deal_mem_incidence_segment(line,f,rei_model)
	--print ("deal_mem_incidence_segment start")
	
	--luaext.msg("deal_mem_incidence_segment f:read",line)
	
	while true do
		line = f:read("*line")
		--luaext.msg("deal_mem_incidence_segment f:read",line)
		--print(line)
		if not line then break end
		pos = string.find(line,";")			
		if(not pos) then
			return line
		end

		local i=0
		local j=0
		while true do				
			j = i+1	
			i = string.find(line, ";",i+1) 
			
			--print(i)
			if not i then break end
			local sx = string.sub(line, j,i-1)
			--luaext.msg("string.sub ",sx)

			local mem_id, node_s, node_e = string.match(sx,"([^ ]+) ([^ ]+) ([^ ]+)")
			--luaext.msg("mem.mem_id ",mem_id)
			--luaext.msg("mem.node_s ",node_s)
			--luaext.msg("mem.node_e ",node_e)
			local k = tonumber(mem_id)
			local mem = rei_structure.new(rei_obj.ReiObjectMember)
			mem.number_id = k
			mem.incidence = {}
			mem.incidence[1] = tonumber(node_s)
			mem.incidence[2] = tonumber(node_e)
			
				
			--print ("\tcoord.number_id = " .. coord.number_id)
			--print ("\tcoord.value_list[1] = " .. coord.value_list[1])
			--print ("\tcoord.value_list[2] = " .. coord.value_list[2])
			--print ("\tcoord.value_list[3] = " .. coord.value_list[3])
		
			rei_model.mems[mem.number_id] = mem
			
			--line = 	string.sub(line, j,-1)
			
			--k = k + 1
		end
	end		
	--line = f:read("*line")
	return line
end
--ELEMENT INCIDENCES SHELL--------------

local function get_element(element)
	local ele = {};
	local js = {};
	local i=1
	local j=1
	element = string.sub(element,1,#element-1);
	print(element);
	for n in string.gmatch(element,"([^ ])") do
		print(n);
		if(i == 1)then
			ele.index = n;
			i = i+1;
		else
			js[j] = n;
			j = j + 1;
		end
	end
	ele.jnts = js;
	return ele;
end
local function get_elements(line,rei_model)
	for element in string.gmatch(line,".-;") do
		local ele = get_element(element);
		table.insert(rei_model.elements,ele);
	end
	
end

local function deal_element_segment(line,f,rei_model)
	--print ("deal_element_segment start")
	while true do
		line = f:read("*line")
		if not line then break end
		pos = string.find(line,";")			
		if(not pos) then
			return line
		end		
		get_elements(line,rei_model);	
	end		
	return line
end
local function get_tos(line)
	local tos = {};	
	for left,pos_l,pos_r,right in string.gmatch(line,"(%d*)%s*()TO()%s*(%d*)") do
		local to = {};
		to.left = left;
		to.pos_l = pos_l;
		to.pos_r = pos_r;
		to.right = right;
		table.insert(tos,to);
	end
	return tos;
end
local function get_elements_property(line,rei_model)
	local tos = get_tos(line);
	
	
end


local function deal_element_property_segment(line,f,rei_model)
	while true do
		line = f:read("*line")
		if not line then break end
		pos = string.find(line,"%d")			
		if(not pos) then
			return line
		end		
		get_elements_property(line,rei_model);	
	end		
	return line
end
--DEFINE PMEMBER--------------
local function deal_def_pmember_segment(line,f,rei_model)
	--print ("deal_def_pmember_segment start")
	line = f:read("*line")
	line = f:read("*line")
	return line
end
--DEFINE MATERIAL START--------------
local function deal_def_material_segment(line,f,rei_model)
	--print ("deal_def_material_segment start")
	line = f:read("*line")
	return line
end
--CONSTANTS--------------
local function deal_constants_segment(line,f,rei_model)
	--print ("deal_def_material_segment start")
	line = f:read("*line")
	return line
end
--SUPPORTS--------------
local function deal_supports_segment(line,f,rei_model)
	--print ("deal_supports_segment start")
	line = f:read("*line")
	return line
end
--MEMBER LOAD--------------
local function deal_member_load_segment(line,f,rei_model)
	--print ("deal_member_load_segment start")
	line = f:read("*line")
	return line
end
--AREA LOAD--------------
local function deal_area_load_segment(line,f,rei_model)
	--print ("deal_area_load_segment start")
	line = f:read("*line")
	return line
end

function open_staad(file_name,rei_model)
	--luaext.msg("open_staad = ","start")


	local f = io.open(file_name,"r")
	line = f:read("*line")	
	while true do		
	
		if not line then break end
		if( string.find(line,"STAAD")) then
			line = deal_staad_segment(line,f,rei_model)
		elseif (string.find(line,"START JOB")) then
			line = deal_job_segment(line,f,rei_model)			
		elseif (string.find(line,"INPUT WIDTH")) then
			line = deal_input_width_segment(line,f,rei_model)			
		elseif (string.find(line,"UNIT")) then
			line = deal_unit_segment(line,f,rei_model)
		elseif (string.find(line,"JOINT COORDINATES")) then
			line = deal_jnt_coord_segment(line,f,rei_model)
			--num = table.getn(rei_model.nodes)
			--luaext.msg("deal_jnt_coord_segment num",tostring(num))
		elseif (string.find(line,"MEMBER INCIDENCES")) then
			line = deal_mem_incidence_segment(line,f,rei_model)
			--num = table.getn(rei_model.mems)
			--luaext.msg("deal_mem_incidence_segment num",tostring(num))

		elseif (string.find(line,"ELEMENT INCIDENCES SHELL")) then  -- 开始处理板数据
			line = deal_element_segment(line,f,rei_model)
		elseif (string.find(line,"ELEMENT PROPERTY")) then
			line = deal_element_property_segment(line,f,rei_model)
--[[		elseif (string.find(line,"DEFINE PMEMBER")) then
			line = deal_def_pmember_segment(line,f),rei_model
		elseif (string.find(line,"DEFINE MATERIAL START")) then
			line = deal_def_material_segment(line,f,rei_model)
		elseif (string.find(line,"CONSTANTS")) then
			line = deal_constants_segment(line,f,rei_model)
		elseif (string.find(line,"SUPPORTS")) then
			line = deal_supports_segment(line,f,rei_model)
		elseif (string.find(line,"MEMBER LOAD")) then
			line = deal_member_load_segment(line,f,rei_model)
		elseif (string.find(line,"AREA LOAD")) then
			line = deal_area_load_segment(line,f,rei_model)		
--]]		else
			line = f:read("*line")
			--print(line)					
		end				
	end --while
	io.close()
	return rei_model
end
section_g = "S-30*30*8";

function show_model(rei_model)	
	j=100
	for k in pairs(rei_model.nodes) do		
		rei_model.nodes[k].id	= j
		rei_model.nodes[k].value_list [1] = rei_model.nodes[k].value_list [1] * 1000.0
		rei_model.nodes[k].value_list [2] = rei_model.nodes[k].value_list [2] * 1000.0
		rei_model.nodes[k].value_list [3] = rei_model.nodes[k].value_list [3] * 1000.0
	
		j = j+1	
	end
		
	num = table.getn(rei_model.mems)
	local i=1
	
	for k in pairs(rei_model.mems) do		
			rei_model.mems[k].id = j			
			rei_model.mems[k].section = section_g
			rei_model.mems[k].color = {r=1,g=0,b=0}
			rei_model.mems[k].sketch = 0
			rei_model.mems[k].beta = 45
			
			local node_start = rei_model.nodes[rei_model.mems[k].incidence[1]]
			rei_model.mems[k].start_point = {node_start.value_list[1],node_start.value_list[2],node_start.value_list[3]}
			
			local node_end = rei_model.nodes[rei_model.mems[k].incidence[2]]
			rei_model.mems[k].end_point = {node_end.value_list[1],node_end.value_list[2],node_end.value_list[3]}
			
		
			o = steel.draw_member(rei_model.mems[k]);
			add_obj(frm,o)	
			j = j+1	
	end
	


	
end

function draw_load(rei_model)	
		local point_load = rei_structure.new(rei_load.ReiLoadObjectPoint)
		local con = rei_structure.new(rei_load.ReiLoadValueConcentrate)
		con.value = 100
		point_load.load_type = "FX"
		point_load.direction = "GY"
		point_load.location = {10}
		point_load.loadvalue = con
		local o = rei_load.draw_load(rei_model,rei_model.mems[1],point_load,100000);
		add_obj(frm,o)		
end



local function transform_xy(pts)
	local points = {}	
	for i=1,#pts do
		local p = {x=pts[i].x,y=pts[i].y,z=pts[i].z};
		points[i] = p;
	end
	

	local nor1 = g_pt_.pt_minus(points[1],points[2]);
	local nor2 = g_pt_.pt_minus(points[2],points[3]);

	local z_axis = g_pt_.pt_multi(nor1,nor2);
	local x_axis = nor1;
	local y_axis = g_pt_.pt_multi(z_axis,x_axis);
	
	x_axis = g_pt_.pt_normalize(x_axis);
	y_axis = g_pt_.pt_normalize(y_axis);
	z_axis = g_pt_.pt_normalize(z_axis);
	trace_.print_pt(x_axis);
	trace_.print_pt(y_axis);
	trace_.print_pt(z_axis);
	
	
	local gaxis = ifc.new(g_pt_.g_axis,{
		base = ifc.new(g_pt_.Point,{x=0,y=0,z=0});
		x = ifc.new(g_pt_.Point,x_axis);
		y = ifc.new(g_pt_.Point,y_axis);
		z = ifc.new(g_pt_.Point,z_axis);
	});
	
	for i=1,#points do
		points[i] = g_pt_.g2l(points[i],gaxis);
		if(points[i].z == 0)then
			points[i].z = nil;		
		else
			print("points[i].z != 0 ,axis transform is wrong.")
		end
	end	
	return gaxis,points;
end

local function add_ifc_element(staad_model)
	for k in pairs(staad_model.elements) do
		local thickness = staad_model.elements[k].thickness;
		trace_out (tostring(thickness));
		local axis, ptsss= transform_xy(staad_model.elements[k].pts);
		
		local slab_info = {thickness = thicks; pts = ptsss,start_pt={x=0,y=0,z=0},end_pt = {x=0,y=thickness,z=0} };
		ifc.create_slab_by_pts(slab_info,axis) ;
	end
end




function add_ifc_model_staad(staad_model)
	trace_out("add_ifc_model_staad(staad_model) start.\n")
	trace_out("mems 'num = " .. #staad_model.mems .. ".\n")
	
	local gauge = file_dlg.start_progress_bar();
	local i = 1;
	

	for k in pairs(staad_model.mems) do			
		
		gauge.value = i / #staad_model.mems;
		i = i + 1.09;
		iup.LoopStep();


		local st = staad_model.mems[k].start_point;
		local ed = staad_model.mems[k].end_point;
		st.z = st.z or 0;
		ed.z = ed.z or 0;
		--local beam_info = {start_pt = {x=st[1],y=st[2],z=st[3]},end_pt = {x=ed[1],y=ed[2],z=ed[3]},section = section_g};
		local beam_info = {start_pt = {x=st[1],y=st[2],z=st[3]},end_pt = {x=ed[1],y=ed[2],z=ed[3]},section = staad_model.mems[k].section};
		local key = ifc.create_beam(beam_info,ifc.get_db());
		--trace_out("create beam the key  = " .. key .. "\n");
	end		
	file_dlg.close_progress_bar();
	add_ifc_element(staad_model);		
	ifc.create_assist_info(ifc.get_db());	
	ifc.draw_ifc_model(ifc.get_db());	
		
	trace_out("add_ifc_model_staad(staad_model) end.\n")
	
end--TUB U H L C  P圆管； M圆钢。

--H TUB T 



function open_staad_file(file_name)
	return std_io.store_stad_input(file_name);
end

--start transform dabase-------------------------------------------------------------------
local function get_nodes_segment(std_db,nodes)
	local ns = std_db["JOINT COORDINATES"];
	if not ns then
		return;
	end
	for i=1, #ns.param  do
		local nd = {};
		nd.value_list = {};
		nd.id = ns.param[i][1];
		nd.value_list[1] = ns.param[i][2]*1000.0;---问题放大倍数----------------
		nd.value_list[2] = ns.param[i][3]*1000.0;
		nd.value_list[3] = ns.param[i][4]*1000.0;
		nodes[nd.id] = nd;
	end
	
end
local function get_mems_segment(std_db,mems,nodes)
	local ms = std_db["MEMBER INCIDENCES"];
	if not ms then
		return;
	end
	for i=1, #ms.param  do
		local m = {};
		m.value_list = {};
		m.id = ms.param[i][1];
		m.start_node = ms.param[i][2];
		m.end_node = ms.param[i][3];
		
		m.start_point = {nodes[m.start_node].value_list[1],nodes[m.start_node].value_list[2],nodes[m.start_node].value_list[3]};
		m.end_point =  {nodes[m.end_node].value_list[1],nodes[m.end_node].value_list[2],nodes[m.end_node].value_list[3]};

		mems[m.id] = m;
	end	
end

local function get_element_two(ns,elements,nodes)
	local element = {};
	local ptss = {};
	local j=1
	for i=1, #ns  do
		if(i == 1)then
			element.index = ns[i];
		else
			local id = ns[i];
			print("id " .. id);
			trace_out("eeeeeeeee  = " .. nodes[id].value_list[1] .. " , " ..nodes[id].value_list[2] .. " , " ..nodes[id].value_list[3] .. " , \n" )
			ptss[j] =  { x=nodes[id].value_list[1],y=nodes[id].value_list[2],z=nodes[id].value_list[3] };
			j = j + 1;		
		end
	end	
	element.thickness = 10;


	ptss[#ptss+1] =  { x=nodes[ns[2]].value_list[1],y=nodes[ns[2]].value_list[2],z=nodes[ns[2]].value_list[3] };
	element.pts = ptss;
	
	elements[element.index] = element;
end

local function get_element_one(ns,elements,nodes)
	for i=1, #ns  do
		get_element_two(ns[i],elements,nodes)
	end
end

local function get_elements_segment(std_db,elements,nodes)
	local eles = std_db["ELEMENT INCIDENCES SHELL"];
	if not eles then
		return;
	end
	for i=1, #eles.param  do		
		get_element_one(eles.param[i],elements,nodes);
	end		
end

local function deal_property(elements,prop)
	local prop_str = prop.str[1];
	local prop_val = prop.num[#prop.num];
	trace_out(prop_str .. "====" .. prop_val .. "\n");
	for i=1, #prop.num-1  do		
		local ele_index = prop.num[i];
		--将来此处应该是可以设置的，按照字符串来设置
		trace_out( "index = " .. ele_index .. "\n");
		trace_out(  "elements val = " .. tostring(elements[ele_index]) .. "\n");
		if(elements[ele_index])then
			elements[ele_index].thickness = prop_val;
		end
	end	
	
	
end
local function get_elements_property_segment(elements,std_db,elements_property)
	local props = std_db["ELEMENT PROPERTY"];
	if not props then
		return;
	end
	for i=1, #props.param  do		
		deal_property(elements,props.param[i]);
	end	
	
	
end


function create_model(staad_model,std_database)
	trace_out("create_model(staad_model,std_database) start.\n")
	staad_section_db.create_staad_section_db();
	
	staad_model = staad_model or {};	

	staad_model.nodes  =  staad_model.nodes or {};
	get_nodes_segment(std_database,staad_model.nodes);
	
	staad_model.mems  =  staad_model.mems or {};
	get_mems_segment(std_database,staad_model.mems,staad_model.nodes);
	
	staad_model.elements  =  staad_model.elements or {};
	get_elements_segment(std_database,staad_model.elements,staad_model.nodes);
	
	
	staad_model.elements_property  =  staad_model.elements_property or {};
	get_elements_property_segment(staad_model.elements,std_database,staad_model.elements_property);
	
	--处理截面
	staad_model.mems_property  = staad_model.mems_property or {};
	staad_section.get_mems_property_segment(std_database,staad_model.mems_property);
	staad_section.set_section_to_frames(staad_model.mems,staad_model.mems_property);
	trace_out("create_model(staad_model,std_database) end.\n")
end

--[[
staad_model = {};
local std_database = open_staad_file("d:\\section.std");
create_model(staad_model,std_database);

--]]





