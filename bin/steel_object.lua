module(...,package.seeall)

local object_ = require("object");
local tools_ = require("steel_tools");
local geo_ = require("steel_geometry");

----loop----
local function loop_point_object_surface(sur, f, args)
	for k,v in pairs(sur.points) do
		f(v, args);
	end
end

local function loop_point_object(obj, f, args)
	for k,v in pairs(obj.surfaces) do
		loop_point_object_surface(v, f, args);
	end
end


----callback----
local function rgb_scale(pt, args)
	local coe = args[1];
	pt[1] = pt[1]*coe;
	pt[2] = pt[2]*coe;
	pt[3] = pt[3]*coe;
end

local function number_hightlight(num)
	num = num<0 and 0 or num;
	num = num>1 and 1 or num;
	num = num>0.6 and num/2 or num;
	num = num<=0.6 and num+(1-num)/2 or num;
end
local function rgb_highlight(pt)
	pt[1] = number_hightlight(pt[1]);
	pt[2] = number_hightlight(pt[2]);
	pt[3] = number_hightlight(pt[3]);
end

local function xyz_l2g(pt, args)
	local axis = geo_.Axis:new(args[1]);
	local p = {pt[6], pt[7], pt[8]};
	p = axis:l2g(p);
	pt[6] = p.x;
	pt[7] = p.y;
	pt[8] = p.z;
end

----------main--------------------------------------
function update(scene)
	scene_onpaint(scene);
end

function show(obj, scene)
--	add_obj(frm,obj);
	local id = obj.index;
	obj = object_.OBJ:new(obj);
	obj.index = id;
	obj:add_obj(add_2_model);
	scene_addobj(scene,obj);	
end

function color_scale(obj, coe)
	loop_point_object(obj, rgb_scale, {coe});
	return obj;
end

function color_hightlight(obj)
	loop_point_object(obj, rgb_highlight);
	return obj;
end

function coord_l2g(obj, axis)
	loop_point_object(obj, xyz_l2g, {axis});
	return obj;
end

