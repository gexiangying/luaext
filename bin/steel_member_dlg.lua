package.cpath="?.dll;?51.dll";
local iup = require "iuplua"
local iupcontrol = require( "iupluacontrols" )
local luaext = require "luaext"
local stlent = require("steel_entity");
local smd = require("steel_model");
module (...,package.seeall)

local dlg = nil;
local s = {};
local c = {};
s.title = "Member Property";
s.sects = {"H200*100*20*15","L-200*100x6","U200*150*15","C200*150*50*20","T200*150*20*15","S200*150*20","P-200X5","M50"};
s.htipw = 50;

local function myfenv(t)
	setmetatable(t, {__index=_G})
	setfenv(2,t)
end

--tab, key
local function add_tab_key(t)
	myfenv(t);
	tab = tab or {}
	tab[key] = tab[key] or {}
end

--tab, key, tip, wid
local function add_lab(t)
	add_tab_key{tab=t.tab,key=t.key}
	myfenv(t)
	tab[key].lab = iup.label{title=tip;size=wid and wid.."x"}
end

--tab, key, tip, wid
local function add_tog(t)
	add_tab_key{tab=t.tab,key=t.key}
	myfenv(t)
	tab[key].tog = iup.toggle{title=tip;size=wid and wid.."x"}
end

--tab, key
local function add_txt(t)
	add_tab_key{tab=t.tab,key=t.key}
	myfenv(t)
	tab[key].txt = iup.text{expand="HORIZONTAL"}
end

--tab, key, its
local function add_lst(t)
	add_tab_key{tab=t.tab,key=t.key}
	myfenv(t)
	local lst = {expand="HORIZONTAL",editbox="YES",dropdown="YES",visible_items=20}
	for i, v in ipairs(its) do
		table.insert(lst,v)
	end
	tab[key].lst = iup.list(lst);
end

local function init_ctrl_section()
	add_tog{tab=c,key="sect",tip="Section",wid=s.htipw};
	add_lst{tab=c,key="sect",its=s.sects};
end

local function init_ctrl_color()
	add_tog{tab=c,key="cr",tip="Color",wid=s.htipw};
	add_txt{tab=c,key="cr"}
	add_lab{tab=c.cr,key="r",tip="R="};add_txt{tab=c.cr,key="r"}
	add_lab{tab=c.cr,key="g",tip="G="};add_txt{tab=c.cr,key="g"}
	add_lab{tab=c.cr,key="b",tip="B="};add_txt{tab=c.cr,key="b"}
end

--tab, tip, key
local function init_ctrl_pt(t)
	add_tog{tab=t.tab,key=t.key,tip=t.tip,wid=s.htipw};add_txt{tab=t.tab,key=t.key};
	add_lab{tab=t.tab[t.key],key="x",tip="X="};add_txt{tab=t.tab[t.key],key="x"};
	add_lab{tab=t.tab[t.key],key="y",tip="Y="};add_txt{tab=t.tab[t.key],key="y"};
	add_lab{tab=t.tab[t.key],key="z",tip="Z="};add_txt{tab=t.tab[t.key],key="z"};
end

local function init_stl_bn()
	apply 	= iup.button{title="Apply "	,rastersize="60X30"};
	modify	= iup.button{title="Modify"	,rastersize="60X30"};
	ok 		= iup.button{title="OK"		,rastersize="60X30"};
	cancel 	= iup.button{title="Cancel"	,rastersize="60X30"};
end

local function ctrl()
	init_ctrl_section();
	init_ctrl_color();
	init_ctrl_pt{tab=c, key="s", tip="Start"};
	init_ctrl_pt{tab=c, key="e", tip="End"};
	init_stl_bn();
end

local function tabs()
	local page1 = iup.vbox{
		iup.hbox{c.sect.tog, c.sect.lst},
	};
	local page2 = iup.vbox{
		iup.hbox{c.s.tog, c.s.txt, c.s.x.lab, c.s.x.txt, c.s.y.lab, c.s.y.txt, c.s.z.lab, c.s.z.txt},
		iup.hbox{c.e.tog, c.e.txt, c.e.x.lab, c.e.x.txt, c.e.y.lab, c.e.y.txt, c.e.z.lab, c.e.z.txt},
	};
	local page3 = iup.vbox{
		iup.hbox{c.cr.tog, c.cr.r.lab, c.cr.r.txt, c.cr.g.lab, c.cr.g.txt, c.cr.b.lab, c.cr.b.txt},
	};
	page1.tabtitle = "Base";
	page2.tabtitle = "Pos";
	page3.tabtitle = "Ex";
	
	return iup.tabs{page1, page2, page3};
end

local function face()
	dlg = iup.dialog
	{
		iup.vbox
		{
			tabs();
			iup.hbox{apply,modify,ok,cancel};
			margin="10x10";
			alignment="ARIGHT"
		};
		title=s.title;
		size="320x";
	}
end

local function cur()
	local m = nil
	if (smd.cur()) and (getmetatable(smd.cur())==stlent.Member) then 
		m = smd.cur()
	end
	return m;
end

local function curs()
	local ms = {}
	for i, v in pairs(smd.curs()) do
		if getmetatable(v)==stlent.Member then 
			table.insert(ms, v);
		end
	end
	return ms;
end

local function property_to_dlg(mem)
	if not mem then return end
	c.sect.lst.value = mem.section
	mem.color = mem.color or {}
	c.cr.r.txt.value = mem.color.r
	c.cr.g.txt.value = mem.color.g
	c.cr.b.txt.value = mem.color.b
	mem.start_point = mem.start_point or {}
	c.s.txt.value = mem.start_node
	c.s.x.txt.value = mem.start_point.x
	c.s.y.txt.value = mem.start_point.y
	c.s.z.txt.value	= mem.start_point.z
	mem.end_point = mem.end_point or {}
	c.e.txt.value = mem.end_node
	c.e.x.txt.value = mem.end_point.x
	c.e.y.txt.value	= mem.end_point.y
	c.e.z.txt.value = mem.end_point.z
end

local function property_to_mem(mem)
	if not mem then return end
	if c.sect.tog.value=="ON" then mem.section = c.sect.lst.value end;
	if c.cr.tog.value=="ON" then
		mem.color = mem.color or {}
		mem.color.r = c.cr.r.txt.value;
		mem.color.g = c.cr.g.txt.value;
		mem.color.b = c.cr.b.txt.value;
	end
	if c.s.tog.value=="ON" then 
		mem.start_point = mem.start_point or {}
		mem.start_node = c.s.txt.value;
		mem.start_point.x = c.s.x.txt.value;
		mem.start_point.y = c.s.y.txt.value;
		mem.start_point.z = c.s.z.txt.value;		
	end
	if c.e.tog.value=="ON" then 
		mem.end_point = mem.end_point or {}
		mem.end_node = c.e.txt.value;
		mem.end_point.x = c.e.x.txt.value;
		mem.end_point.y = c.e.y.txt.value;	
		mem.end_point.z = c.e.z.txt.value;
	end
end

local function property_to_mems(mems)
	for i, v in pairs(mems) do
		property_to_mem(v)
	end
end

local function on_apply()
	property_to_mem(smd.default_member());
end

local function on_modify()
	property_to_mems(curs());
	stlent.draw_members(curs());
end

local function on_cancel()
--	iup.Hide(dlg);
	dlg:hide();
--	dlg = nil
end

local function msg()
	function apply:action()
		on_apply();
	end
	function modify:action()
		on_modify();
	end
	function ok:action()
		on_modify();
		on_cancel();
	end
	function cancel:action()
		on_cancel();
	end
end

local function show()
	property_to_dlg(cur())
	dlg:show() 
end

local function init()
	ctrl();
	property_to_dlg(cur())
	face();
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

