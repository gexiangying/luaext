package.cpath="?;?.lua;?.dll"
local luaext = require "luaext"

setfenv(1,ifc)

function create_global_id(db)
	return "\'" .. luaext.guid() .. "\'"
end

--g_max_key = 10000

function get_max_key(db)
	local max_key = 1	
	for k in pairs(db) do
		local id = string.sub(db[k].key,2,-1);
		if( max_key < tonumber(id))then
			max_key = tonumber(id)
		end	
	end
	return max_key
end
function get_key()
	--local key = find_max_key()
	--print("cur create key = " .. g_max_key)
	g_max_key = g_max_key or get_max_key(get_db());
	
	local key = string.format("#%s",g_max_key);
	g_max_key = g_max_key + 1;
	return key;
end

function get_db()
	return ifc_tab.ifc_datas;
end
function get_ifc_tab()
	return ifc_tab;
end
function get_entity(key)
	return get_db()[key]	
end

function find_db()
	local pos = "";
	return pos;
end

function push_ifc_data(item,db)
	
	db = db or get_db();
	local ifc_data = {}
	ifc_data.key = item.key
	if(item.new_key) then
		ifc_data.new_key = item.new_key
	else		
		ifc_data.new_key = item.key
	end
	ifc_data.class_name = item.class_name 
	ifc_data.name = item.class_name 
	ifc_data.result = {}
	ifc_data.result = item	
	db[ifc_data.key] = 	ifc_data
	--table.insert(db,ifc_data)
end

function cannew(o)
--	if not o then return true end;
	if type(o)=="table" then return true end;
	return false;
end

function ifcnew(T,o)
	o = new(T,o);
	local key = get_key();
	o.key = key;
	o.new_key = key;
	o.class_name = T.name;
	push_ifc_data(o,get_db());
	return o;
end

function ifcset(o, t, T)
	if T and type(t)=="table" then
		t = ifcnew(T,t);
	end
	if t then o = t end;
	return o;
end


function get_ent_by_name(name)
	local db = get_db()
	for k in pairs(db) do
		if (db[k].name == name)then
			return db[k].result
		end
	end
	return nil
end

function get_ent_by_para(name,para_val,para_pos)
	local db = get_db()
	for k in pairs(db) do
		if (db[k].name == name)then
			--print(db[k].result[para_pos])
			--print(para_val)
			if(string.find(db[k].result[para_pos],para_val))then
				return db[k].result
			end
		end
	end
	return nil
end

function number_ifc(ifc_data)
	local global_id = 1
	for k in pairs(ifc_data) do
		if (ifc_data[k].key) then
			local new_key = string.format("#%d",global_id)
			ifc_data[k].result.new_key = new_key
			ifc_data[k].new_key = new_key
			global_id = global_id + 1
		end
	end	
end

function get_members(datas,mems)
	
	for k ,v in pairs(datas) do		
		if (v.class_name == "IFCBEAM") then
			table.insert(mems,v)	
		elseif (v.class_name == "IFCCOLUMN") then
			table.insert(mems,v)		
		elseif (v.class_name == "IFCSLAB") then
			--table.insert(mems,v)		
		else
		end
		
	end
end












