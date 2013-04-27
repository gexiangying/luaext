package.cpath="?.dll;?51.dll";
local iup = require "iuplua"
local iupcontrol = require( "iupluacontrols" )
local luaext = require "luaext"
local mgr_ = require("steel_mgr");
module (...,package.seeall)

local file_dlg  = require "iup_filedlg"

local dlg = nil;
local dlg_info = {};
local c = {};
dlg_info.title = "Setting";
dlg_info.ents_kind= {"IfcBeam","IfcSlab"};
dlg_info.show_kind = {"LineFrame","Solid"};
dlg_info.htipw = 80;

setting_info = {["renderdraw"]="ON",["lineframe"]="ON",}


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
	tab[key].tog = iup.toggle{title=tip;size=wid and wid.."x";value = "ON"}
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


local function init_stl_bn()
	ok 		= iup.button{title="OK"		,rastersize="60X30"};
	cancel 	= iup.button{title="Cancel"	,rastersize="60X30"};
end

local function init_ctrl_entity_kind()
	
	
	add_tog{tab=c,key="ifcbeam",tip="IfcBeam",wid=dlg_info.htipw};
	add_tog{tab=c,key="ifcslab",tip="ifcslab",wid=dlg_info.htipw};
	break_line = iup.label{title="-----------------------------------------------------------------------------",size=250}
	
	add_tog{tab=c,key="lineframe",tip="Line Frame Draw",wid=dlg_info.htipw};
	add_tog{tab=c,key="renderdraw",tip="Render Draw",wid=dlg_info.htipw};
	break_line_2 = iup.label{title="-----------------------------------------------------------------------------",size=250}
	
	set_path_button  = iup.button{title="SetPath",rastersize="80X20"};
	set_path_text =  iup.text{expand="HORIZONTAL",rastersize="150X21"}
	
end

local function ctrl()
	init_ctrl_entity_kind();

	init_stl_bn();
end

local function tabs()
	local page1 = iup.vbox{		
		iup.hbox{c.ifcbeam.tog},
		iup.hbox{c.ifcslab.tog},
		iup.hbox{break_line},		
		iup.hbox{c.lineframe.tog},
		iup.hbox{c.renderdraw.tog},
		iup.hbox{break_line_2},		
		iup.hbox{set_path_button,set_path_text},
		
	};
	page1.tabtitle = "Common";
	
	return iup.tabs{page1};
end

local function face()
	dlg = iup.dialog
	{
		iup.vbox
		{
			tabs();
			iup.hbox{ok,cancel};
			margin="10x10";
			alignment="ARIGHT"
		};
		title=dlg_info.title;
		size="320x";
	}
end

local function cur()
	return mgr_.cur();
end

local function curs()
	return mgr_.curs();
end
local function on_cancel()
	dlg:hide();
end
local function on_ok()
	setting_info["ifcbeam"] = c.ifcbeam.tog.value;
	setting_info["ifcslab"] = c.ifcslab.tog.value;
	
	setting_info["lineframe"] = c.lineframe.tog.value;
	setting_info["renderdraw"] = c.renderdraw.tog.value;
	
	if(setting_info["save_file"] and setting_info["save_file"] ~= "")then
		dlg:hide();
	else
		iup.Message("Warning : ","the file saving path isn't set.please set it.");			
	end
end
local function on_set_path_button()
	local file_path = file_dlg.save_file_dlg("ifc");
	trace_out(file_path .. "\n");
	set_path_text.value = file_path;
	setting_info["save_file"] = file_path;
	
end

local function msg()
	function ok:action()
		on_ok();
	end
	function cancel:action()
		on_cancel();
	end
	function set_path_button:action()
		on_set_path_button();
	end
end

local function show()
	dlg:show() 
end

local function init()
	ctrl();
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

