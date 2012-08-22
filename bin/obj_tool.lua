package.cpath="?;?.lua;?.dll"

module (...,package.seeall)

Surface = {
	points={},
	lines={},
	triangles={},
	quadrangles={},
	outer={},
	inners={},
	texts={},
}
function Surface:new()	
	o = o or {}
	setmetatable(o, Surface)
	Surface.__index = Surface
	o.index = 1
	o.points ={}
	o.lines ={}
	o.triangles={}
	o.quadrangles={}
	o.outer={}
	o.inners={}
	o.texts={}
	return o
end


Object={
	index = 1,
	surfaces = {},
}

function Object:new()	
	o = o or {}
	setmetatable(o, Object)
	Object.__index = Object
	o.index = 1
	o.surfaces = {}
	return o
end

function add_line(s,e,surface)
	surface = surface or {}
	local pt_s = {1,0,0,0,0,s.x,s.y,s.z}
	local pt_e = {1,0,0,0,0,e.x,e.y,e.z}
	surface.points = surface.points or {}
	table.insert(surface.points,pt_s)
	table.insert(surface.points,pt_e)
	
	local pos_e = table.getn(surface.points)
	surface.lines = surface.lines or {}
	table.insert(surface.lines,{pos_e-1,pos_e})	
end
function add_point(pt,surface)
	local s = {1,0,0,0,0,pt.x,pt.y,pt.z}
	surface.points = surface.points or {}
	table.insert(surface.points,s)
end




function add_triangle(pts,obj)
	
	
end

function add_quadrangle(pts,obj)
	
	
end


function create_line(start_pt,end_pt,obj)
	obj.index = obj.index or 1000
	obj.surfaces = {}
	local pt_s = {1,0,0,0,0,start_pt.x,start_pt.y,start_pt.z}
	local pt_e = {1,0,0,0,0,end_pt.x,end_pt.y,end_pt.z}
	obj.surfaces[1].points = {}
	obj.surfaces[1].lines = {}
	obj.surfaces[1].points = {pt_s,pt_e}
	obj.surfaces[1].lines = {{1,2}}
		
end









