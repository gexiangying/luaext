package.cpath="?.dll;?51.dll";
module (...,package.seeall)
local object_ = require("object")
local tools_ = require("steel_tools")
local mgr_ = require("steel_mgr");
local obj_ = require("steel_object");
local ifc_ = require "ifc";


Entity = {};
Entity.__index = Entity;
tools_.met(ifc_.IFCPRODUCT,Entity);


function Entity:new(t)
	if getmetatable(t)==Entity then return end;
	t = t or {};
	Entity.__index = Entity;
	setmetatable(t,Entity);
	return t;
end

function Entity:get_start_pt()
	return self.start_pt;
end
function Entity:set_start_pt(pt)
	self.start_pt = pt;
end

function Entity:get_end_pt()
	return self.end_pt;
end
function Entity:set_end_pt(pt)
	self.end_pt = pt;
end


-- function Entity:get_section()
	-- return self["section"]	
-- end
-- function Entity:set_section(str)
	-- self["section"] = str
-- end

-- function Entity:get_material()
	-- return self["material"]	
-- end
-- function Entity:set_material(str)
	-- self["material"] = str
-- end

-- function Entity:get_color()
	-- return self.color
-- end
-- function Entity:set_color(cr)
	-- self.color = cr
-- end

-- function Entity:pop_property_dlg()
	-- require("steel_property_dlg").pop();
-- end

-- function Entity:modified()
	-- self.object = nil;
-- end

function Entity:get_object()
	self.object =  self.object or solid_.member{
		mode = solid_.Render;
		section = self:get_section() or "H-50*20*5*3";
		color = self:get_color() or {r=1,g=0,b=0};
		pt1 = self:get_start_pt() or {0,0,0};
		pt2 = self:get_end_pt() or {0,0,0};
	};
	local obj = tools_.deepcopy(self.object);
	return obj;
end

-- function Entity:show(light)
	-- local obj = light and self:get_object() or obj_.color_scale(tools_.deepcopy(self:get_object()),0.7);
	-- obj.index = self.mgrid;
	-- mgr_.show_object(obj);
-- end



-----------------------------------------------------------
--[[
function Entity:ent_add_obj(obj)
	add_obj(frm,obj);
	-- obj = object_.OBJ:new(obj);
	-- obj.index = self.id;
	-- obj:add_obj(add_2_model);
	-- scene_addobj(self.scene,obj);	
end

function Entity:draw()
	if self.object then
		self.object.index = self.id;
		self:ent_add_obj(self.object);	
	end
end





Member = {};
Member.__index = Member;
tools_.met(Entity,Member);

function Member:ready_draw()
	local dy = {}
	dy.id = self.id
	dy.highlight = self.highlight
	dy.sketch = self.sketch
	dy.circlen = circlen
	dy.section = self.section
	dy.beta = self.beta
	dy.color = self.color
	dy.start_point = self.start_point
	dy.end_point = self.end_point
	if self.color then
		dy.color = model.colors[self.color] or dy.color
	end
	if self.start_node then
		dy.start_point = model.nodes[self.start_node] or dy.start_point
	end
	if self.end_node then
		dy.end_point = model.nodes[self.end_node] or dy.end_point
	end
	return dy
end

function Member:draw()
	local obj = steel_.draw_member(self:ready_draw());
	if not obj then return end;
	self:ent_add_obj(obj);
	-- obj = object.OBJ:new(obj);
	-- obj.index = self.id;
	-- obj:add_obj(add_2_model);
	-- scene_addobj(self.scene,obj);	
end

function draw_member(mem)
	if not mem then trace_out("draw_member(mem), mem is a nil\n") return end;
	if getmetatable(mem)~=Member then trace_out("draw_member(mem), mem isn't a Member\n") return end;
	mem:draw()
end

function draw_members(mems)
	for k, v in pairs(mems) do
		draw_member(v)
	end
end


Plate = {};
Plate.__index = Plate;
tools_.met(Entity,Plate);

function Plate:ready_draw()
	local dy = {}
	dy.id = self.id
	dy.highlight = self.highlight
	dy.sketch = self.sketch
	dy.color = self.color
	dy.thick = self.thick;
	if self.color then
		dy.color = model.colors[self.color] or dy.color
	end
	dy.points = self.points or {}
	if self.nodes then
		dy.points = {};
		for k,v in pairs(self.nodes) do
			table.insert(dy.points,model.nodes[v]);
		end
	end
	return dy
end

function Plate:draw()
	local obj = steel_.draw_plate(self:ready_draw());
	if not obj then return end;
	self:ent_add_obj(obj);
	-- obj = object.OBJ:new(obj);
	-- obj.index = self.id;
	-- obj:add_obj(add_2_model);
	-- scene_addobj(self.scene,obj);	
end

function draw_plate(pl)
	if not pl then	return end;
	if getmetatable(pl)~=Plate then return end;
	pl:draw()
end

function draw_entity(ent)
--	draw_member(ent);
--	draw_plate(ent);
--	ent:draw()
end
--]]

