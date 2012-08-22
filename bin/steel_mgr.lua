module (...,package.seeall)

local tools_ = require "steel_tools"
local obj_ = require "steel_object"

db_ = db_ or {};
sels_ = sels_ or {};
curid_ = nil;
cur_scene_ = nil;
--is_offset_ = nil;


local function db_add(ent)
	ent.mgrid = ent.mgrid or #db_+1; 
	db_[ent.mgrid] = ent;
end

local function show_index(id, light)
	db_[id]:show(light);
end

local function del_index(id)
	select(id,nil);
	db_[id] = nil;
	local obj = {index=id};
	show_object(obj);
end

----------public--------------------------------------------------------
function update()
	obj_.update(cur_scene_);
end

function show_object(obj)
	obj_.show(obj, cur_scene_);
end

function cur_offset_object(axis)
	for k,v in pairs(curs()) do
		v:offset_object(axis);
		v:show(true);
	end
	update();
end
--entity:	1,pop_property_dlg(); 2,show(light); 3offset_object(axis)
function add(ent)
	if not ent then return end;
	db_add(ent);
	ent:show();
end

function del()
	for k,v in pairs(sels_) do
		del_index(k);
	end
end

function is_select(id)
--	if sels_[id] then trace_out("Y\n") else trace_out("N\n") end;
	return sels_[id]
end

function select(id, light)
	curid_ = light and id;
	sels_[id] = light;
	show_index(id,light);
end

function select_all()
	for k,v in pairs(db_) do
		select(k,true);
	end
end

function select_none()
	for k,v in pairs(sels_) do
		select(k,nil);
	end
end

function select_reverse()
	for k,v in pairs(db_) do
		select(k, not is_select(k));
	end
end

function pop_property_dlg()
	return cur() 
--	and type(cur().pop_property_dlg)=="function"
	and cur():pop_property_dlg()
--	or require("steel_property_dlg").pop();
end

function cur()
	if curid_ then 
		return db_[curid_];
	else
		local i = #sels_;
		if i and i~=0 then return db_[i] end
		for i, v in pairs(sels_) do
			return db_[i]
		end
		return nil;
	end;
end

function curs()
	local mems = {}
	for i, v in pairs(sels_) do
		table.insert(mems, db_[i])
	end
	return mems
end

function cur_scene(sc)
	cur_scene_ = sc;
	return cur_scene_;
end

