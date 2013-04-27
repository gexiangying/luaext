package.cpath="?;?.lua;?.dll"

local steel_model_ = require("steel_model");

local g_pt_ = require("g_pt")
local trace_obj_ = require("trace_obj")
local obj_tool_ = require "obj_tool"
local steel_tools_ = require "steel_tools"

cur_ent_name = ""
local file_dlg  = require "iup_filedlg"

require "ifc"

setfenv(1,ifc)

--ifc结构实例-----------------
--representations产品描述集合，是个多种类的表，需要知道每种representation的种类
--Representation_Item = { type = "" }
--Representation = {type = "",identifier = "",items = {} }
--surface中存在就有2dcurve线的时候，此时不需要坐标转换，只需要绘制出即可，kind = "LINE"
--local surface = {kind = "",ents = profile_lns_t,direct =direct_t,len = depth_t}
--IfcCartesianPoint = {x = 0,y = 0,z = 0}
--IFCPOLYLINE = {start_pt = pt1,end_pt =pt2}	
--IfcAxis2Placement2D ={ origin = {x=0,y=1,z=0} ,dircet = {x=0,y=1,z=0}}
--IfcTrimmedCurve = {start_angle = 0,end_angle = 0,center = {IfcAxis2Placement2D},radius = 0} 
--[[
object={
	index = 1,
	surfaces = {
		{	points={r,g,b,u,v,x,y,z},
			lines={},
			triangles={},
			quadrangles={},
			outer={1,2,3,4},
			inners={{},{}},
			texts={{ptno=1,r,g,b,str},{},},},
		{},
	},
}
--]]
--axis = {base = {},x = {},y = {} ,z = {},beta = 0.0 }
--曲梁的结构 info = {center = pt,r = 1,start_angle=0,end_angle = 180,section = "",start_pt = ,end_pt =}
--

function get_members(datas,mems)
	
	for k ,v in pairs(datas) do		
		if (v.class_name == "IFCBEAM") then
			table.insert(mems,v)		
		elseif (v.class_name == "IFCCOLUMN") then
			table.insert(mems,v)		
		elseif (v.class_name == "IFCSLAB") then
			table.insert(mems,v)		
		else
		end
		
	end
end
Column = { 				axis = {origin = {},x_axis = {},z_axis = {}},
			surface = {
						vertexs = {},
						direct = {},
						len = 0.0
				}
}
function get_column(col)
	local column = {}
	if (col[6])then
		column.axis = col[6]:get_axis()	
	end
	if (col[7])then
		column.surface = col[7]:get_surface()	
	end
	return column;
end

function get_root_info(v)
	print(v.key)	
	local obj = v:get_obj()
	--add_obj
	local root_info = v:get_root_info()
	print(root_info.GlobalId)	
	print(root_info.OwnerHistory)	
	print(root_info.Name)	
	print(root_info.Description)	

end
local function create_obj(shapes)
	local id=0
	for k in pairs(shapes.ents) do
		trace_out("create_obj k = " .. k .. "\n")
		mem = {}
		mem.id = id
		mem.section = "H50*15*2*1.5"
		mem.color = {r=1,g=1,b=0}
		mem.sketch = 2
		mem.beta = 0				
		mem.start_point = shapes.ents[k].start_pt	
		mem.end_point = shapes.ents[k].end_pt	
		steel_model_.add_member(mem)
		id = id+1
	end
	
end
local function create_line(ln,len,direct,new_lns,axis)	
	ln.start_pt.z = 0
	ln.end_pt.z = 0
	--shapes.len = shapes.len * 100
	local s = ln.start_pt
	local e = ln.end_pt
	
	ln.start_pt =  g_pt_.l2g(ln.start_pt,axis);
	ln.end_pt =  g_pt_.l2g(ln.end_pt,axis);
	
	s =  g_pt_.l2g(s,axis);
	e =  g_pt_.l2g(e,axis);	
	
	local new_s = g_pt_.pt_polar_norm(s,len ,direct)	
	local new_e = g_pt_.pt_polar_norm(e,len,direct)

	local new_ln = {start_pt = new_s,end_pt = new_e}
	local new_side_1 = {start_pt = s,end_pt = new_s}
	local new_side_2 = {start_pt = e,end_pt = new_e }
	
	table.insert(new_lns,new_ln)
	table.insert(new_lns,new_side_1)
	table.insert(new_lns,new_side_2)	
end
--IfcAxis2Placement2D ={ origin = {x=0,y=1,z=0} ,dircet = {x=0,y=1,z=0}}
--IfcTrimmedCurve = {start_angle = 0,end_angle = 0,center = {IfcAxis2Placement2D},radius = 0} 
local function create_arc(arc,len,direct,new_lns,axis)	

	local PI = 3.1415926

	arc.start_angle = arc.start_angle+180
	arc.end_angle = arc.end_angle+180
	local s_x = arc.center.origin.x + arc.radius * math.cos(arc.start_angle*PI/180.0)
	local s_y = arc.center.origin.y + arc.radius * math.sin(arc.start_angle*PI/180.0)
	local e_x = arc.center.origin.x + arc.radius * math.cos(arc.end_angle*PI/180.0)
	local e_y = arc.center.origin.y + arc.radius * math.sin(arc.end_angle*PI/180.0)	
	local st_pt = {x = s_x,y = s_y,z = 0}
	local en_pt = {x = e_x,y = e_y,z = 0} 
	
	st_pt =  g_pt_.l2g(st_pt,axis);
	en_pt =  g_pt_.l2g(en_pt,axis);
	
	
	local ln = {start_pt = st_pt,end_pt = en_pt}	

	local new_s = g_pt_.pt_polar_norm(st_pt,len,direct)	
	local new_e = g_pt_.pt_polar_norm(en_pt,len,direct)
	
	local new_ln = {start_pt = new_s,end_pt = new_e}

	table.insert(new_lns,ln)
	table.insert(new_lns,new_ln)

	
end

local function deal_lines(axis,shapes,new_lns)
	for k in pairs(shapes.ents) do
		local ln = {start_pt = shapes.ents[k].start_pt,end_pt = shapes.ents[k].end_pt}	
		table.insert(new_lns,ln)	
	end
end
local function deal_surface(axis,shapes,new_lns)
	for k in pairs(shapes.ents) do
		if(shapes.direct) then
			if(shapes.ents[k].kind == "line")then
				create_line(shapes.ents[k],shapes.len,shapes.direct,new_lns,axis)			
			elseif(shapes.ents[k].kind == "arc")then
				create_arc(shapes.ents[k],shapes.len,shapes.direct,new_lns,axis)			
			end	
		end
	end	
end

local function conversion_coord(axis,shapes)
	local new_lns = {}

	if(shapes.kind == "LINE") then
		deal_lines(axis,shapes,new_lns)
	else
		deal_surface(axis,shapes,new_lns)		
	end
	for k in pairs(new_lns) do
		table.insert(shapes.ents,new_lns[k])	
	end
end
local function conversion_coord_obj(axis,obj)
	for i=1,#obj.surfaces do
		--local f1 = i .. "old_pts";
		--steel_tools_.ofile_name(f1,obj.surfaces[i].points,"old pt");	
		
		for j=1,#obj.surfaces[i].points do
			local p = obj.surfaces[i].points[j]	
			local pt = {x = p[6],y = p[7],z = p[8]}
	
	
			pt =  g_pt_.l2g(pt,axis);				
			
			
			obj.surfaces[i].points[j][6] =  pt.x		
			obj.surfaces[i].points[j][7] =  pt.y		
			obj.surfaces[i].points[j][8] =  pt.z		
		end
		
		--local f2 = i .. "new_pts";
		--steel_tools_.ofile_name(f2,obj.surfaces[i].points,"l2g");
	end
end

function draw_ifc_model(datas)
	trace_out("draw_ifc_model start\n")
	local cols ={}
	get_members(datas,cols)
	local i = 1
	local gauge = file_dlg.start_progress_bar();
	
	trace_out("the entities num = " .. #cols .. "\n")
	for k in pairs(cols) do					
	
		gauge.value = i / #cols;
		i = i + 1.09;
		iup.LoopStep();

		cur_ent_name = cols[k].result.name
		-- local axis = cols[k].result:get_axis();
		
		-- local file = i .. "_axis.lua"
		-- steel_tools_.ofile_name(file,axis,"axis");

		-- local obj  = obj_tool_.Object:new()
		-- cols[k].result:get_obj(obj)		
		-- conversion_coord_obj(axis,obj)		
		-- obj.index = i
		-- add_obj(frm,obj)
		-- i = i + 1
		require("steel_mgr").add(cols[k].result);
	end
	file_dlg.close_progress_bar();
	trace_out("draw_ifc_model end\n")
end

function IFCPRODUCT:draw()
	local axis = cols[k].result:get_axis();
	local obj = obj_tool_.Object:new()
	self.result:get_obj(obj);
	conversion_coord_obj(axis,obj);
	obj.index = self.id;
	add_obj(frm,obj);
end


function test(datas)
	local cols ={}
	get_members(datas,cols)
	for k,v in pairs(cols) do
		steel_model_.add_ifc(v);
	end
end

----------------------------------------------------------------------------------
function get_model()
	return ifc_tab.ifc_datas;
end



