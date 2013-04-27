
setfenv(1,ifc)

--module (...,package.seeall)

function new(tab, o)
	o = o or {}
	setmetatable(o, tab)
	tab.__index = tab
	return o
end

function setparent(parent, child)
	parent.__index = parent
	setmetatable(child, parent)
end

function tablist (tabparameter, tabname)
--for treatment of paprmeter with record list
	--tabparameter = {}	--parameters with record list
	--tabname = {}			--linked table
	local string_length = #tabparameter  --take length of the parameter list
	local tab = {}
	for i=1, string_length do
		tab[i] = new(tabname)	
		tab[i]:set(tabparameter[i])	
	end
	return tab
end	
function datalist(tabparameter)
--for treatment of paprmeter with data list
	tabparameter = {}	--parameters with data list
	local string_length = #tabparameter  --take length of the parameter list
	local tab = {}
	for i=1, string_length do
		tab[i] = tabparameter[i]
	end
	return tab
end
function tablink (parameter, tabname)
--for treatment of paprmeter with single record
	--parameter =  single record number (string)
	--tabname = {}			--linked table
	local tab = new(tabname)
	tab:set(parameter)	
	return tab
end
function tabselect (parameter)
--for treatment of paprmeter which is a selected table
	--parameter = single record parameter with table name of parameter.class_name (string)
	local tab = new(_G[parameter.class_name])
	return tab
end

