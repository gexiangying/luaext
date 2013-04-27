local g_pt_ = require "g_pt"
local trace_ = require "trace_obj"

local steel_tools_ = require "steel_tools"
local file_dlg  = require "iup_filedlg"

module (...,package.seeall)

require "ifc"

local sap_read = require "Sap2kRead";
local stl_model_ = require "steel_model";
local ifc_write = require "IfcWrite_cmd"

local function add_jnts(jnts)
	for k in pairs(jnts) do
		trace_out("add_jnts\n")
		stl_model_.add_node(jnts[k].index , {x = jnts[k].x,y = jnts[k].y,z = jnts[k].z});
	end

end
local function add_frames(frames)
	for k in pairs(frames) do
		trace_out("add_frames\n")
		stl_model_.add_member{
			section = "H50*15*2*3";
			color = {r=1,g=0,b=0};
			start_node = frames[k].start_jnt;
			end_node = frames[k].end_jnt;
			beta = 0;
		};
	end	
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
	
	local gaxis = ifc.new(g_pt_.g_axis,{
		base = ifc.new(g_pt_.Point,points[2]);
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
	local new_pts = {};
	for i=1,#points do
		if(points[i].z == nil)then
			points[i].z = 0;		
		end
		new_pts[i] = g_pt_.l2g(points[i],gaxis);
	end	
	return gaxis,points;
end
local function add_ifc_slab(slabs)
	for k in pairs(slabs) do
		local thickness = slabs[k].thickness;
		if(not thickness)then
			thickness = 8;		
			trace_out ("slab's thick isn't exits,please check it \n" );
		end
		
		local axis, ptsss= transform_xy(slabs[k].pts);
		--steel_tools_.otrace(ptsss);

		local slab_info = {thicks = thickness, pts = ptsss,start_pt={x=0,y=thickness,z=0},end_pt = {x=0,y=0,z=0} };
		ifc.create_slab_by_pts(slab_info,axis) ;
	
	end	
end
local function add_ifc_solids(solids)
	for k in pairs(solids) do
		local thickness = solids[k].thickness;
		print (thickness);
		local axis, ptsss= transform_xy(solids[k].pts);		
		local slab_info = {thickness = thicks; pts = ptsss,start_pt={x=10,y=10,z=0},end_pt = {x=100,y=thickness,z=0} };
		ifc.create_slab_by_pts(slab_info,axis) ;	
	end	
end

local function add_ifc_mems(frames,sap_model)
	local i = 1
	local progress_bar = file_dlg.start_progress_bar();

	for k in pairs(frames) do
		progress_bar.value = i / #frames;
		i = i + 1;
		iup.LoopStep();


		local st_jnt =  sap_model.jnt_coords[ frames[k].start_jnt ];
		local end_jnt =  sap_model.jnt_coords[ frames[k].end_jnt ];
		
		--local beam_info = {start_pt = {x=st_jnt.x,y=st_jnt.y,z=st_jnt.z},end_pt = {x=end_jnt.x,y=end_jnt.y,z=end_jnt.z},section = "S-50*50*8"};
		local beam_info = {start_pt = {x=st_jnt.x,y=st_jnt.y,z=st_jnt.z},end_pt = {x=end_jnt.x,y=end_jnt.y,z=end_jnt.z},section = frames[k].section,material = frames[k].material};
		ifc.create_beam(beam_info,ifc.get_db());
	end

end

--TUB S
function add_ifc_model(sap_model)
	--加构件信息
	add_ifc_mems(sap_model.connect_frames,sap_model);	
	--加板信息
	add_ifc_slab(sap_model.connect_areas);	
	--加solids信息
	--add_ifc_solids(sap_model.solids);	
	ifc.create_assist_info(ifc.get_db());	
end

function open_sap2k(file_path)
	
	if(not file_path)then
		return;	
	end

	local sap_model = {};
	sap_read.get_sap_model(file_path,sap_model);
	--add_jnts(sap_model.jnt_coords);
	--add_frames(sap_model.connect_frames);
	add_ifc_model(sap_model);
	file_dlg.close_progress_bar();
	--ifc.number_ifc(ifc.get_db());	
	ifc.draw_ifc_model(ifc.get_db())	;
	
	
	--ifc_write.write_ifc(ifc.get_ifc_tab());
end

--open_sap2k("D:\\a.s2k");
