package.cpath="?.dll;?51.dll";
local iup = require "iuplua"
local iupcontrol = require( "iupluacontrols" )
local object_ = require("object");



module (...,package.seeall)

axis_info = {};

local dlg = nil;
local cur_scene;

local function init_buttons()
	ok 		= iup.button{title="Draw"		,rastersize="62X26"};
	cancel 	= iup.button{title="Cancel"	,rastersize="62X26"};
end

local function init_controls()
	static_x_space = iup.label{title="X Spaces:",rastersize="80X21"}
	x_space =  iup.text{expand="HORIZONTAL",rastersize="150X21",value="0 9*2100.0"}
	static_y_space = iup.label{title="Y Spaces:",rastersize="80X21"}
	y_space =  iup.text{expand="HORIZONTAL",rastersize="150X21",value="0 5*2100.0"}
	static_z_space = iup.label{title="Z Spaces:",rastersize="80X21"}
	z_space =  iup.text{expand="HORIZONTAL",rastersize="150X21",value="0 3475"}
	
	static_x_lable = iup.label{title="X Lables:",rastersize="80X21"}
	x_lable =  iup.text{expand="HORIZONTAL",rastersize="150X21",value="1 2 3 4 5 6 7 8 9 10"}
	static_y_lable = iup.label{title="Y Lables:",rastersize="80X21"}
	y_lable =  iup.text{expand="HORIZONTAL",rastersize="150X21",value="A B C D E F"}
	static_z_lable = iup.label{title="Z Lables:",rastersize="80X21"}
	z_lable =  iup.text{expand="HORIZONTAL",rastersize="150X21",value="0 3.475"}
end

local function create_control()
	init_controls();
	init_buttons();
end

local function tabs()
	local page1 = iup.vbox{		
		iup.hbox{static_x_space,x_space},
		iup.hbox{static_y_space,y_space},
		iup.hbox{static_z_space,z_space},
		
		iup.hbox{static_x_lable,x_lable},
		iup.hbox{static_y_lable,y_lable},
		iup.hbox{static_z_lable,z_lable},
		
	};
	page1.tabtitle = "Axis";	
	return iup.tabs{page1};
end

local function create_dlg()
	dlg = iup.dialog{
		iup.vbox{
			tabs();
			iup.hbox{ok,cancel};
			margin="10x10";
			alignment="ARIGHT"
		};
		title="Set Axis Net";
		size="320x";
		maxbox = "NO";
	}
end

local function on_cancel()
	dlg:hide();
end
local function get_info()
	axis_info["x_sapce"] = x_space.value;
	axis_info["y_sapce"] = y_space.value;
	axis_info["z_sapce"] = z_space.value;

	axis_info["x_label"] = x_lable.value;
	axis_info["y_label"] = y_lable.value;
	axis_info["z_label"] = z_lable.value;
end
local function get_lables(strs)	
	local vs = {};
	for v in string.gmatch(strs,"([^ ]+)") do
		vs[#vs+1] = v;
		trace_out("lable = " .. v .. "\n");
	end
	return vs;
end
local function deal_xing(v,vs)	
	local num = string.sub(v,1,string.find(v,"*")-1);
	local val = string.sub(v,string.find(v,"*")+1,#v);
	
	for i=1,num do
		vs[#vs+1] = val;
	end
end
local function get_spaces(strs)	
	local vs = {};
	for v in string.gmatch(strs,"([^ ]+)") do
		if(string.find(v,"*"))then
			deal_xing(v,vs);		
		else
			vs[#vs+1] = v;
		end
	end
	return vs;
end
local function set_axis(lables,spaces,vs)	
	local name = "";
	for i=1,#spaces do
		if lables[i] then
			name = lables[i];
		end
		trace_out("dis = " .. spaces[i] .."  ,lable = " .. tostring(lables[i]) .. "\n");
		
		vs[#vs+1] = {["dis"] = tonumber(spaces[i]),["name"] = name};
	end
end
local function deal_infoes(axis_info)	
	axis_info.base = {0,0,0};
	
	local x_lables = get_lables(axis_info["x_label"]);
	local y_lables = get_lables(axis_info["y_label"]);
	local z_lables = get_lables(axis_info["z_label"]);
	
	
	
	local x_spaces = get_spaces(axis_info["x_sapce"]);
	local y_spaces = get_spaces(axis_info["y_sapce"]);
	local z_spaces = get_spaces(axis_info["z_sapce"]);
	
	
	axis_info.xs = {};
	set_axis(x_lables,x_spaces,axis_info.xs);
	axis_info.ys = {};
	set_axis(y_lables,y_spaces,axis_info.ys);
	axis_info.zs = {};
	--set_axis(z_lables,z_spaces,axis_info.zs);
	--[[
	
	axis_info.xs = {};
	axis_info.xs[1] = {dis = 0,name = "a"};
	axis_info.xs[2] = {dis = 2000,name = "b"};
	axis_info.xs[3] = {dis = 3000,name = "c"};
	axis_info.xs[4] = {dis = 3000,name = "d"};
	axis_info.xs[5] = {dis = 5000,name = "e"};
	
	axis_info.ys = {};
	axis_info.ys[1] = {dis = 0,name = "1"};
	axis_info.ys[2] = {dis = 2000,name = "2"};
	axis_info.ys[3] = {dis = 6000,name = "3"};
	axis_info.ys[4] = {dis = 3000,name = "4"};
	axis_info.ys[5] = {dis = 4000,name = "5"};
	axis_info.ys[6] = {dis = 2000,name = "6"};
	axis_info.ys[7] = {dis = 6000,name = "7"};
	
	axis_info.zs = {};
	axis_info.zs[1] = {dis = 0,name = "bot"};
	axis_info.zs[2] = {dis = 1000,name = "z"};--]]
	
	
end
local function get_max(vs)
	local dis = 0;
	for i=1,#vs do
		dis = dis + vs[i].dis
	end
	return dis;
end
local function get_min(vs)
	if not vs then
		return 0;	
	end
	return vs[1].dis;
end

local function add_axis(st,ed,name,obj_axis)
	
	local surface = {};
	surface.points = {};
	surface.points[#surface.points+1] = {0,0,1,0,0,st.x,st.y,st.z};
	surface.points[#surface.points+1] = {0,0,1,0,0,ed.x,ed.y,ed.z};
	
	surface.lines = {};
	surface.lines[#surface.lines+1] = {#surface.points-1,#surface.points};
	
	surface.texts = {};
	surface.texts[#surface.texts+1] = {ptno=#surface.points-1,r=0,g=0,b=1,str=name};
	
	obj_axis.surfaces[#obj_axis.surfaces+1] = surface;		
	
end
local dis_reach = 150;

local function draw_xs(xs,y_max,y_min,obj_axis)
	local dis =0;
	for i=1,#xs do
		dis = dis + xs[i].dis;	
		local st = luapt.new(dis,y_min - dis_reach,0);
		local ed = luapt.new(dis,y_max+ dis_reach,0);		
		add_axis(st,ed,xs[i].name,obj_axis);
	end

end
local function draw_ys(ys,x_max,x_min,obj_axis)
	local dis =0;
	for i=1,#ys do
		dis = dis + ys[i].dis;	
		local st = luapt.new(x_min - dis_reach,dis,0);
		local ed = luapt.new(x_max + dis_reach,dis,0);		
		add_axis(st,ed,ys[i].name,obj_axis);
	end

end
--axis_info = { base = {x,y,z},xs = {{dis = 1000,name = "a"},{dis = 2000,name = "b"}}}
local function create_obj(axis_info,obj_axis)	
	local x_max = get_max(axis_info.xs);
	local y_max = get_max(axis_info.ys);
	local x_min = get_min(axis_info.xs);
	local y_min = get_min(axis_info.ys);
	
	draw_xs(axis_info.xs,y_max,y_min,obj_axis);
	draw_ys(axis_info.ys,x_max,x_min,obj_axis);
end

	

local function draw_axis(axis_info)	
	local obj_axis = object_.OBJ:new(obj);
	obj_axis.surfaces = {};
	create_obj(axis_info,obj_axis);
	obj_axis.index = 100000;--index存在问题，可能会重复
	add_obj(frm,obj_axis);
	scene_addobj(cur_scene,obj_axis);

end
local function on_ok()	
	get_info(axis_info);
	deal_infoes(axis_info);
	draw_axis(axis_info);
	dlg:hide()
end

local function msg()
	function ok:action()
		on_ok();
	end
	function cancel:action()
		on_cancel();
	end
end

local function show()
	dlg:show() 
end

local function init()
	create_control();
	create_dlg();
	msg();
	dlg:show()
	iup.MainLoop()
end

--main----------------
function pop()
	if dlg then 
		show() 
	else
		init()
	end
end


function create_axis(scene)
	cur_scene = scene;
	pop();	
end

