
package.cpath="?.dll;?51.dll";
local iup = require "iuplua"
local iupcontrol = require( "iupluacontrols" )
local luaext = require "luaext"
local iupt_ = require "steel_iup_tools"
module (...,package.seeall)

local dlg = nil;
local s = {};
local c = {};
s.title = "User";
s.htipw = 50;


local function init_control_name()
	iupt_.add_lab{tab=c,key="name",tip="UserName",wid=50};
	iupt_.add_txt{tab=c,key="name"}
end

local function init_control_pass()
	iupt_.add_lab{tab=c,key="pass",tip="Password",wid=50};
	iupt_.add_pwd{tab=c,key="pass"}
end


local function init_stl_bn()
	ok 		= iup.button{title="OK"		,rastersize="60X30"};
	cancel 	= iup.button{title="Cancel"	,rastersize="60X30"};
end

local function control()
	init_control_name();
	init_control_pass();
	init_stl_bn();
end

local function tabs()
	local page1 = iup.vbox{
		iup.hbox{c.name.lab, c.name.txt},
		iup.hbox{c.pass.lab, c.pass.txt},
	};
	page1.tabtitle = "User";
	
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
		title=s.title;
		size="320x";
	}
end

local function on_ok()
	local name,pass = c.name.txt.value,c.pass.txt.value;
	if login(name,pass) then return true end;
end

local function on_cancel()
	dlg:hide();
end

local function msg()
	function ok:action()
		if on_ok() then on_cancel() return true end
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

