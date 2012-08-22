local luaext = require("luaext");
local tools_  = require("steel_tools");
local stl_ent_ = require("steel_entity");
-- local ifc_ = require "ifc"
module (...,package.seeall)


model = model or {}


model.db = model.db or {};
model.nodes = model.nodes or {};
model.colors = model.colors or {};

--float---------------------------------------------
local fmin_ = 0.0001

function fequ(a, b)
	if a-b<fmin_ and b-a<fmin_ then
		return true
	end
	return false
end

--point---------------------------------------------
function equ_point(a, b)
	if not fequ(a.x,b.x) then return false end
	if not fequ(a.y,b.y) then return false end
	if not fequ(a.z,b.z) then return false end
end
-----------------------------------------------


function add_node(nd, pt)
	-- trace_out("model.nodes["..nd.."]=".."("..pt.x..","..pt.y..","..pt.z..")\n")
	if not pt then return end
	model.nodes = model.nodes or {}
	if nd then model.nodes[nd] = pt; return nd end
	for k, v in pairs(model.nodes) do
		if equ_point(pt, v) then
			return nd
		end
	end
	nd = #model.nodes+1
	model.nodes[nd] = pt
	return nd
end

function get_select_ary_index(id)
	return select_ary[id]
end

local default_ = {
	member = {
		section = "H200*150*20*15";
		material = "SS400";
		start_point = {x=0,y=0,z=0};
		end_point = {z=100,y=0,z=0};
		beta = 0;
		color = {r=1,g=0,b=0};
		sketch = 0;
	},
	plate = {
		material = "SS400";
		points = {{700,-500,0}, {700,-1000,2000}, {100,500,2000}, {100,500,1500}, {100,1000,1500}, {100,1000,0}, {100,500,0};};
		thick = 500;
		color = {r=1,g=0.5,b=0};
		sketch = "0";
	},
}

function default_member()
	return default_.member;
end

function set_default_member_start(x,y,z)
	default_.member.start_point.x=x
	default_.member.start_point.y=y
	default_.member.start_point.z=z
end

function set_default_member_end(x,y,z)
	default_.member.end_point.x=x
	default_.member.end_point.y=y
	default_.member.end_point.z=z
end

function add_default_member()
	add_member(default_.member);
end

function new_id()
	if not model.maxid then model.maxid = 0  end;
	model.maxid = model.maxid+1;
	return model.maxid;
end

function cur_scene(sc)
	model.cur_scene = sc or model.cur_scene;
	return model.cur_scene;
end

function cur()
	if model.curid then 
		return model.db[model.curid]
	else
		local i = #select_ary
		if i and i~=0 then return model.db[i] end
		for i, v in pairs(select_ary) do
			return model.db[i]
		end
		return nil;
	end;
end

function curs()
	local mems = {}
	for i, v in pairs(select_ary) do
		table.insert(mems, model.db[i])
	end
	return mems
end

function del()
	local obj = {};
	obj.index = cur().id;
	obj.surfaces = {};
	model.db[model.curid] = nil;
	add_obj(frm,obj);
end

function model_update()
	for i, v in ipairs(model.db) do
		stl_ent_.draw_entity(v);
	end
end


function model_singleline(singleline)
	for i, v in ipairs(model.db) do
		v.sketch = singleline;
	end
	model_update();
end    

function model_select_ary(light)
	for i in pairs(select_ary) do
		model.db[i].highlight = light;
		dwaw_entity(model.db[i]);
	end
	if not light then select_ary = {} end
end

function trace_select_ary()
	local msg = ""
	for i, v in pairs(select_ary) do
		msg = msg..","..tostring(i)
	end
	luaext.msg("trace_select_ary",msg)
end
function model_select(id, light)
	model.curid = light and id;
	select_ary[id] = light;
	model.db[id].highlight = light;
	--stl_ent_.draw_entity(model.db[id]);
	model.db[id]:draw();
end

function add_ent(ent)
	local newid = new_id();
	model.db[newid] = tools_.deepcopy(ent)
	model.db[newid].id = newid;
	model.db[newid].scene = cur_scene();
	model_select(newid, nil);
end

function add_member(mem)
	mem = mem or model.default_member;
	tools_.met(stl_ent_.Member, mem);
	add_ent(mem);
--	stl_ent_.draw_entity(cur());
end

function add_member_type(type)
--	trace_out("steel_model:add_member_type(scene),scene = "..scene or "nil".."\n")
	mem = require("steel_case_"..type).member;
	add_member(mem);
end

function add_plate(pl)
	pl = pl or default_.plate;
	tools_.met(stl_ent_.Plate, pl);
	add_ent(pl);
--	stl_ent_.draw_entity(cur());
end

function add_other(ent)
	tools_.met(stl_ent_.Entity, ent);
	add_ent(ent);
end

-- function add_ifc(t)
	-- tools_.ofile(t, "ifc");
	-- add_ent(t);
-- end

