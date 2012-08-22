package.cpath="?.dll;?51.dll";
local iup = require "iuplua"
local iupcontrol = require( "iupluacontrols" )
local luaext = require "luaext"
local iupt_ = require("steel_iup_tools");
local mgr_ = require("steel_mgr");
module (...,package.seeall)

local dlg = nil;
local s = {};
local c = {};
s.title = "Properties";
s.sects = {"H200*100*20*15","L-200*100x6","U200*150*15","C200*150*50*20","T200*150*20*15","S200*150*20","P-200X5","M50"};
s.mats = {"SS400","SS440"};
s.htipw = 50;


local function init_control_section()
	iupt_.add_tog{tab=c,key="sect",tip="Section",wid=s.htipw};
	iupt_.add_lst{tab=c,key="sect",its=s.sects};
end

local function init_control_material()
	iupt_.add_tog{tab=c,key="mat",tip="Material",wid=s.htipw};
	iupt_.add_lst{tab=c,key="mat",its=s.mats};
end

local function init_control_color()
	iupt_.add_tog{tab=c,key="cr",tip="Color",wid=s.htipw};
	iupt_.add_txt{tab=c,key="cr"}
	iupt_.add_lab{tab=c.cr,key="r",tip="R="};iupt_.add_txt{tab=c.cr,key="r"}
	iupt_.add_lab{tab=c.cr,key="g",tip="G="};iupt_.add_txt{tab=c.cr,key="g"}
	iupt_.add_lab{tab=c.cr,key="b",tip="B="};iupt_.add_txt{tab=c.cr,key="b"}
end

--tab, tip, key
local function init_control_pt(t)
	iupt_.add_tog{tab=t.tab,key=t.key,tip=t.tip,wid=s.htipw};iupt_.add_txt{tab=t.tab,key=t.key};
	iupt_.add_lab{tab=t.tab[t.key],key="x",tip="X="};iupt_.add_txt{tab=t.tab[t.key],key="x"};
	iupt_.add_lab{tab=t.tab[t.key],key="y",tip="Y="};iupt_.add_txt{tab=t.tab[t.key],key="y"};
	iupt_.add_lab{tab=t.tab[t.key],key="z",tip="Z="};iupt_.add_txt{tab=t.tab[t.key],key="z"};
end

local function init_stl_bn()
	apply 	= iup.button{title="Apply "	,rastersize="60X30"};
	modify	= iup.button{title="Modify"	,rastersize="60X30"};
	ok 		= iup.button{title="OK"		,rastersize="60X30"};
	cancel 	= iup.button{title="Cancel"	,rastersize="60X30"};
end

local function control()
	init_control_section();
	init_control_material();
	init_control_color();
	init_control_pt{tab=c, key="s", tip="Start"};
	init_control_pt{tab=c, key="e", tip="End"};
	init_stl_bn();
end

local function tabs()
	local page1 = iup.vbox{
		iup.hbox{c.sect.tog, c.sect.lst},
		iup.hbox{c.mat.tog, c.mat.lst},
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
	return mgr_.cur();
end

local function curs()
	return mgr_.curs();
end

-- local function cur()
	-- local m = nil
	-- if (mgr_.cur()) and (getmetatable(mgr_.cur())==stlent.Member) then 
		-- m = mgr_.cur()
	-- end
	-- return m;
-- end

-- local function curs()
	-- local ms = {}
	-- for i, v in pairs(mgr_.curs()) do
		-- if getmetatable(v)==stlent.Member then 
			-- table.insert(ms, v);
		-- end
	-- end
	-- return ms;
-- end

local function property_to_dlg(mem)
	if not mem then return end
	c.sect.lst.value = mem:get_section();
	c.mat.lst.value = mem:get_material();
	if mem:get_color() then
		mem.color = mem.color or {}
		c.cr.r.txt.value = mem:get_color().r
		c.cr.g.txt.value = mem:get_color().g
		c.cr.b.txt.value = mem:get_color().b
	end
--	mem.start_point = mem.start_point or {}
	if mem:get_start_pt() then
		c.s.txt.value = mem.start_node
		c.s.x.txt.value = mem:get_start_pt().x
		c.s.y.txt.value = mem:get_start_pt().y
		c.s.z.txt.value	= mem:get_start_pt().z
	end
--	mem.end_point = mem.end_point or {}
	if mem:get_end_pt() then
		c.e.txt.value = mem.end_node
		c.e.x.txt.value = mem:get_end_pt().x
		c.e.y.txt.value	= mem:get_end_pt().y
		c.e.z.txt.value = mem:get_end_pt().z
	end
end

local function property_to_mem(mem)
	if not mem then return end
	if c.sect.tog.value=="ON" then mem:set_section(c.sect.lst.value) end;
	if c.mat.tog.value=="ON" then mem:set_material(c.mat.lst.value) end;
	if c.cr.tog.value=="ON" then
		mem:set_color{
			r=tonumber(c.cr.r.txt.value) or 0,
			g=tonumber(c.cr.g.txt.value) or 0,
			b=tonumber(c.cr.b.txt.value) or 0
		};
		-- mem.color = mem.color or {}
		-- mem.color.r = c.cr.r.txt.value;
		-- mem.color.g = c.cr.g.txt.value;
		-- mem.color.b = c.cr.b.txt.value;
	end
	if c.s.tog.value=="ON" then 
--		mem.start_point = mem.start_point or {}
		mem.start_node = c.s.txt.value;
		mem:set_start_pt{
			x=tonumber(c.s.x.txt.value) or 0;
			y=tonumber(c.s.y.txt.value) or 0;
			z=tonumber(c.s.z.txt.value) or 0;
		};
--		mem.start_point.x = c.s.x.txt.value;
--		mem.start_point.y = c.s.y.txt.value;
--		mem.start_point.z = c.s.z.txt.value;		
	end
	if c.e.tog.value=="ON" then 
--		mem.end_point = mem.end_point or {}
		mem.end_node = c.e.txt.value;
		mem:set_end_pt{
			x=tonumber(c.e.x.txt.value) or 0;
			y=tonumber(c.e.y.txt.value) or 0;
			z=tonumber(c.e.z.txt.value) or 0;
		};
--		mem.end_point.x = c.e.x.txt.value;
--		mem.end_point.y = c.e.y.txt.value;	
--		mem.end_point.z = c.e.z.txt.value;
	end
end

local function property_to_mems(mems)
	for i, v in pairs(mems) do
		property_to_mem(v)
		v:show(true);
	end
end

local function on_apply()
--	property_to_mem(mgr_.default_member());
end

local function on_modify()
	property_to_mems(curs());
	mgr_.update();
--	stlent.draw_members(curs());
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
	control();
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

