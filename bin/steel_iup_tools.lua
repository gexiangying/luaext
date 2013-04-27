package.cpath="?.dll;?51.dll";
local iup = require "iuplua"
local iupcontrol = require( "iupluacontrols" )
module (...,package.seeall)

-- local function myfenv(t)
	-- setmetatable(t, {__index=_G})
	-- setfenv(2,t)
-- end

--tab, key
local function add_tab_key(t)
	t.tab = t.tab or {}
	t.tab[t.key] = t.tab[t.key] or {}
end

--tab, key, tip, wid
function add_lab(t)
	add_tab_key{tab=t.tab,key=t.key}
	t.tab[t.key].lab = iup.label{title=t.tip;size=t.wid and t.wid.."x"}
end

--tab, key, tip, wid
function add_tog(t)
	add_tab_key{tab=t.tab,key=t.key}
	t.tab[t.key].tog = iup.toggle{title=t.tip;size=t.wid and t.wid.."x"}
end

--tab, key, 
function add_txt(t)
	add_tab_key{tab=t.tab,key=t.key}
	t.tab[t.key].txt = iup.text{expand="HORIZONTAL"}
end

--tab, key, 
function add_pwd(t)
	add_tab_key{tab=t.tab,key=t.key}
	t.tab[t.key].txt = iup.text{expand="HORIZONTAL",password="YES"}
end

--tab, key, its
function add_lst(t)
	add_tab_key{tab=t.tab,key=t.key}
	local lst = {expand="HORIZONTAL",editbox="YES",dropdown="YES",visible_items=20}
	for i, v in ipairs(t.its) do
		table.insert(lst,v)
	end
	t.tab[t.key].lst = iup.list(lst);
end
