package.cpath="?.dll;?51.dll";
local iup = require "iuplua"
local iupcontrol = require( "iupluacontrols" )
local luaext = require "luaext"
local tools = require("steel_tools")
local smd = require("steel_model");
module (...,package.seeall)

function add()
plane_lab = iup.label{title="Plane:"}
x_txt = iup.text{expand="HORIZONTAL",id="x_txt"}
x_txt.value = "5";
X_lab = iup.label{title="X"}
y_txt = iup.text{expand="HORIZONTAL",id="y_txt"}
y_txt.value = "3";
floor_lab = iup.label{title="Floor:"}
z_txt = iup.text{expand="HORIZONTAL",id="floor_txt"}
z_txt.value = "9";

column_section_label = iup.label{title="Column Section:"}
column_section_text = iup.text{expand="HORIZONTAL", id="column_section_text"}
column_section_text.value = "TUB200*200*6";
column_color_label = iup.label{title="Color:"}
column_color_text = iup.text{expand="HORIZONTAL", id="column_color_text"}
column_color_r_label = iup.label{title=" R:"}
column_color_r_text = iup.text{expand="HORIZONTAL", id="column_color_r"}
column_color_r_text.value = 1;
column_color_g_label = iup.label{title=" G:"}
column_color_g_text = iup.text{expand="HORIZONTAL", id="column_color_g"}
column_color_g_text.value = 1;
column_color_b_label = iup.label{title=" B:"}
column_color_b_text = iup.text{expand="HORIZONTAL", id="column_color_b"}
column_color_b_text.value = 0;

beam_section_label = iup.label{title="Beam Section:"}
beam_section_text = iup.text{expand="HORIZONTAL", id="beam_section_text"}
beam_section_text.value = "H200*150*9*2.3";
beam_color_label = iup.label{title="Color:"}
beam_color_text = iup.text{expand="HORIZONTAL", id="beam_color_text"}
beam_color_r_label = iup.label{title=" R:"}
beam_color_r_text = iup.text{expand="HORIZONTAL", id="beam_color_r"}
beam_color_r_text.value = 1;
beam_color_g_label = iup.label{title=" G:"}
beam_color_g_text = iup.text{expand="HORIZONTAL", id="beam_color_g"}
beam_color_g_text.value = 0;
beam_color_b_label = iup.label{title=" B:"}
beam_color_b_text = iup.text{expand="HORIZONTAL", id="beam_color_b"}
beam_color_b_text.value = 1;

local jntdis = 50;
local xdis, ydis, zdis = 7000, 5000, 2700;
local xnum, ynum, znum = 3, 2, 7; 
local pt = {};
local member = {};
member.color = {};
member.start_point = {};
member.end_point = {};


apply = iup.button{title="Apply", rastersize="x22",id="apply"};
cancel = iup.button{title="Cancel", rastersize="x22",id="cancle"};

dlg = iup.dialog
{
    iup.vbox
    {
		iup.hbox{floor_lab, z_txt},
		iup.hbox{plane_lab, x_txt, X_lab, y_txt},
		iup.hbox{column_section_label, column_section_text},
		iup.hbox{column_color_label, column_color_r_label, column_color_r_text, column_color_g_label, column_color_g_text, column_color_b_label, column_color_b_text},
		iup.hbox{beam_section_label, beam_section_text},
		iup.hbox{beam_color_label, beam_color_r_label, beam_color_r_text, beam_color_g_label, beam_color_g_text, beam_color_b_label, beam_color_b_text},
		iup.hbox{apply, cancel};
    };title="Model Infomation", size="300x200", margin="10x10"
}

function add_floor_column()
	member.start_point = tools.deepcopy(pt);
	member.end_point = tools.deepcopy(pt);
	member.end_point.z = pt.z + zdis - jntdis;
	smd.add_member(member);
end

function add_floor_beamx()
	member.start_point = tools.deepcopy(pt);
	member.start_point.z = pt.z + zdis -jntdis/2;
	member.end_point = tools.deepcopy(member.start_point);
	member.end_point.x = pt.x + xdis - jntdis;
	smd.add_member(member);
end

function add_floor_beamy()
	member.start_point = tools.deepcopy(pt);
	member.start_point.z = pt.z + zdis -jntdis/2;
	member.end_point = tools.deepcopy(member.start_point);
	member.end_point.y = pt.y + ydis - jntdis;
	smd.add_member(member);
end

function add_floor_x(way)
	local n = xnum;
	if way == "x" then n = n-1 end;
	for i=0, n do
		pt.x = xdis*i;
		if way == "x" then 
			add_floor_beamx() 
		elseif way == "y" then 
			add_floor_beamy()
		else 
			add_floor_column() 
		end
	end
end

function add_floor_y(way)
	local n = ynum;
	if way == "y" then n = n-1 end;
	for i=0, n do
		pt.y = ydis*i;
		add_floor_x(way);
	end
end

function add_model_floor(beam)
	for i=1, znum do
		pt.z = zdis*i;
		add_floor_y(beam);
	end
end

function apply:action()

	xnum = x_txt.value and tonumber(x_txt.value);
	ynum = y_txt.value and tonumber(y_txt.value);
	znum = z_txt.value and tonumber(z_txt.value);
	
	member.section = column_section_text.value;
	member.color.r = column_color_r_text.value;
	member.color.g = column_color_g_text.value;
	member.color.b = column_color_b_text.value;
	add_model_floor("z");
	member.section = beam_section_text.value;
	member.color.r = beam_color_r_text.value;
	member.color.g = beam_color_g_text.value;
	member.color.b = beam_color_b_text.value;
	add_model_floor("x");
	add_model_floor("y");
end

dlg:show()
iup.MainLoop()

end

