--lua base function
--interface----------------- 
--函数：new(tab,o) 
--功能：新建类

--函数：set_parent(parent,child)
--功能：设置子类

--函数：create_class(...)
--功能：实现多继承

--函数：save_table (table_name,o)
--功能：保存无环的表

--函数：save_table_loop(table_name,o,file_name)
--功能：保存有环的表

--函数：link_str(tab)
--功能：把数组的值连接一整个字符串



--[[
--打开表的例子
local file_path = filedialog.get_file_dlg()
lua.open_table(file_path)	
--保存有环表的例子		
local file_path = filedialog.save_file_dlg()
lua.save_table_loop("model",model,file_path)	

--]]


----------------------------



module (...,package.seeall)

function new(tab,o)
	o = o or {}
	setmetatable(o,tab)
	tab.__index = tab
	return o
end



function set_parent(parent,child)
	parent.__index = parent
	setmetatable(child,parent)
end


local function search(k,plist)
	for i=1, #plist do
		local v = plist[i][k]
		if v then return v end
	end
end

function create_class(...)
	local c = {}
	local parents = {...}
	setmetatable(c,{__index = function (t,k)
	return search(k,parents)
	end})
	
	c.__index = c
	function c:new(o)
	o = o or {}
	setmetatable(o,c)
	return o
	end
	return c
end


local function save_tab (o)
	--tab_str = get_tab_str(tab_num)	
	if type(o) == "number" then
		io.write(o)
	elseif type(o) == "string" then
		io.write(string.format("%q", o))
	elseif type(o) == "table" then
		io.write("{\n")
		for k,v in pairs(o) do
			--io.write(" ", k, " = ")
			io.write(" ["); save_tab(k); io.write("] = ")
			--tab_num = tab_num + 1
			save_tab(v)
			io.write(",\n")
		end
		io.write("}\n")
	else
		error("cannot serialize a " .. type(o))
	end
end

--保存无环的table--
function save_table(table_name,o,file_name)
	io.output(file_name)	
	io.write(table_name.."=")
	save_tab(o)
	io.close()
end




local function basicSerialize (o)
	if type(o) == "number" then
		return tostring(o)
	else		-- assume it is a string
		return string.format("%q", o)
	end
end

local function save_table_loc(tab_name,tab,  saved)
	saved = saved or {}			-- initial value
	io.write(tab_name, " = ")
	if type(tab) == "number" or type(tab) == "string" then
		io.write(basicSerialize(tab), "\n")
	elseif type(tab) == "table" then
		if saved[tab] then		-- value already saved?
			-- use its previous name
			io.write(saved[tab], "\n")
		else
			saved[tab] = tab_name	-- save name for next time
			io.write("{}\n")		-- create a new table
			for k,v in pairs(tab) do	-- save its fields
				local fieldname = string.format("%s[%s]", tab_name,basicSerialize(k))
				save_table_loc(fieldname, v, saved)
			end
		end
	else
		error("cannot save a " .. type(tab))
	end
end
--保存有环的table--
function save_table_loop(table_name,o,file_name)
	saved = {}	
	io.output(file_name)	
	save_table_loc(table_name,o,saved)	
	io.close()
end























--把数组的值连接一整个字符串--
function link_str(tab)
	num = table.getn(tab)
	local t = {}
	for i=1,num do
		t[#t+1]	 = tab[i]
	end			
	s = table.concat(t, " ")
    return s
end


function open_table(file_name)

	dofile(file_name)
	num = table.getn(model.objects)
	for i=1,num do
	add_obj(frm,model.objects[i])	
	end
	
end
function clear_model(model)
	model = {}
	num = table.getn(model.objects)
	for i=1,num do
	add_obj(frm,model.objects[i])	
	end
	
end


