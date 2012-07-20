local stl_model_ = require "steel_model"
local s2k_ = require "steel_s2k"
module (...,package.seeall)

local mem = {
	section = "H200*150*20*15";
	sketch = 0;
	color = {r=1,g=0,b=0};
	start_point = {x=0,y=-1000,z=0};
	end_point = {x=1000,y=-1000,z=0};
	beta = 0;
};

local pl = {
	sketch = "0";
	color = {r=1,g=0.5,b=0};
	points = {{700,-500,0}, {700,-1000,2000}, {100,500,2000}, {100,500,1500}, {100,1000,1500}, {100,1000,0}, {100,500,0};};
	thick = 500;
};
----

local function add_nodes()
	for k, v in pairs(s2k_.model.joints) do
		local nd = v.id
		local pt = {}
		pt.x = v.coord[1]*1000
		pt.y = v.coord[2]*1000
		pt.z = v.coord[3]*1000
		stl_model_.add_node(nd, pt)
	end
end

local function add_mems()
	for k, v in pairs(s2k_.model.members) do
		local m = {}
		m.start_point = {}
		m.end_point = {}
		m.section = "H200*150*9*2.3"
		m.color = {r=1,g=0.5,b=0}
		m.start_node = v.connected_joint_id[1]
		-- local jid = v.connected_joint_id[1]
		-- local jpt = s2k_.model.joints[jid].coord
		-- m.start_point.x = jpt[1]*1000
		-- m.start_point.y = jpt[2]*1000
		-- m.start_point.z = jpt[3]*1000
		m.end_node  = v.connected_joint_id[2]
		-- local jid = v.connected_joint_id[2]
		-- local jpt = s2k_.model.joints[jid].coord
		-- m.end_point.x = jpt[1]*1000
		-- m.end_point.y = jpt[2]*1000
		-- m.end_point.z = jpt[3]*1000
		stl_model_.add_member(m)
	end
end

local function add_pt(pts, cids)
	for k, v in pairs(cids) do
		local jpt = s2k_.model.joints[v].coord
		local pt = {}
		pt.x = jpt[1]*1000
		pt.y = jpt[2]*1000
		pt.z = jpt[3]*1000
		table.insert(pts, pt)
	end

end

local function add_pls()
	for k, v in pairs(s2k_.model.elements) do
		local p = {}
		p.color = {r=1,g=0,b=0.5}
		p.points = {}
		add_pt(p.points, v.connected_joint_id)
		p.thick = v.thick
		stl_model_.add_plate(p)
	end
end

--main--
function add()
	-- stl_model_.add_member(mem)
	add_nodes();
	add_mems()
	add_pls()
end
