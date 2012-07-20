package.cpath="?.dll;?51.dll";
module (...,package.seeall)
local steel_ = require("steel")



Member = {};
Member.__index = Member;

function Member:ready_draw()
	local dy = {}
	dy.id = self.id
	dy.highlight = self.highlight
	dy.sketch = self.sketch
	dy.circlen = circlen
	dy.section = self.section
	dy.beta = self.beta
	dy.start_point = self.start_point
	dy.end_point = self.end_point
	dy.color = self.color
	if self.start_node then
		dy.start_point = model.nodes[self.start_node] or dy.start_point
	end
	if self.end_node then
		dy.end_point = model.nodes[self.end_node] or dy.end_point
	end
	if self.color then
		dy.color = model.colors[self.color] or dy.color
	end
	return dy
end

function Member:draw()
	if not self then trace_out("Member:draw(), self is a nil\n") return end
	local obj = steel_.draw_member(self:ready_draw());
	if not obj then return end;
	add_obj(frm,obj);	
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

function Plate:draw()
	trace_out("Plate:draw()");
	local obj = steel_.draw_plate(self);
	if not obj then return end;
	add_obj(frm,obj);	
end

function draw_plate(pl)
	if not pl then	return end;
	if getmetatable(pl)~=Plate then return end;
	pl:draw()
end

function draw_entity(ent)
--	draw_member(ent);
--	draw_plate(ent);
	ent:draw()
end
