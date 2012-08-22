module(...,package.seeall)

local section_ = require "steel_section";
local tools_ = require "steel_tools"
local geo_ = require "steel_geometry"
local obj_ = require "steel_object"

Mode = {name="Mode"};
Mode.__index = Mode;

----color----
function Mode:set_color(cr)
	cr = cr or {r=1,g=0,b=0}
	self.real_color = cr;
end

local function color_scale(cr,f)
	local newcr = {};
	newcr.r = cr.r*f;
	newcr.g = cr.g*f;
	newcr.b = cr.b*f;
	return newcr;
end

function color_rand(i)
	return ((i%4)+(i%2)*2)*2;
end
function color_default(i)
	return 0;
end
function color_section(i)
	return 20;
end
function color_outer_cirle(i)
	return 10;
end
function color_outer_side(i)
	i = color_rand(i);
	return i;
end
function color_inner_cirle(i)
	return 30;
end
function color_inner_side(i)
	i = color_rand(i)+30;
	return i;
end

function Mode:color_factor(i)
	self.color_pos = self.color_pos or color_default;
	i = self.color_pos(i);
	local denominator = 100;
	return (denominator-i)/denominator;
end 

function Mode:change_color(i)
--	i=i+1;
	local f = self:color_factor(i);
	self.color = color_scale(self.real_color,f);
end


----loop----
local function loop_area_points(pts,f,args)
	if not pts then return end;
	for k,v in ipairs(pts) do
		f(v,args);
	end
end

local function loop_area_inners(area,f,args)
	if not area or area.inners then
		for k,v in ipairs(area.inners) do
			loop_area_points(v,f,args);
		end
	end
end

local function loop_area_outer(area,f,args)
--	if not area or not area.outer then return end;
	if not area then return end;
	area.outer = area.outer or {};
	loop_area_points(area.outer,f,args);
end

local function loop_area_base(area,f,args)
--	if not area then return end;
	area.base = area.base or {0,0,0};
	f(area.base,args)
end

local function loop_area_xyz(area,f,args)
	loop_area_base(area,f,args);
	loop_area_outer(area,f,args);
	loop_area_inners(area,f,args);
end

-- local function point_new(v,args)
	-- geo_.Point:new(v);
-- end
-- function Mode:met_area(sd)
	-- sd.bottom = sd.bottom or {};
	-- self.top = self.top or {};
	-- self:loop_area_point(sd.bottom,point_new);
	-- self:loop_area_point(self.top,point_new);
-- end

-- function Mode:top_polarto(sd)
	-- if not sd.length then return end;
	-- sd.direction = sd.direction or {0,0,1};
	-- if not self.top or not self.top.base then return end;
	-- self:loop_area_point(self.top,point_new_polarto,{sd.direction,sd.length});
-- end

-- function Mode:set_top(sd)
	-- sd.bottom = sd.bottom or {};
	-- self.top = sd.top or tools_.deepcopy(sd.bottom);
	-- self:met_area(sd);
	-- self:top_polarto(sd);
-- end

----adjust----
local function point_new_polarto(v,args)
	geo_.Point:new(v):polarto(args[1],args[2]);
end

local function adjust_area(t, sd, area)
	if type(sd[area])~="table" then sd[area] = {} end;
	if type(sd[area].base)~="table" then sd[area].base = {0,0,0} end;
	if type(sd[area].outer)~="table" then t.mode = Line end;
end

local function adjust(t)
	if not t then error("solid, arg is a nil") return end;
	if not t.solid then error("solid, arg.solid is a nil") return end;
	if getmetatable(t.mode)~=Mode then t.mode = Line end;
	adjust_area(t,t.solid,"bottom");
	t.run = tools_.met(t.mode);
	t.run.top = t.solid.top or tools_.deepcopy(t.solid.bottom);
	adjust_area(t,t.run,"top");
end

local function adjust_extrude(t)
	adjust(t);
	t.solid.length = t.solid.length or 0;
	if type(t.solid.direction)~="table" then t.solid.direction = {0,0,1} end;
	loop_area_xyz(t.run.top,point_new_polarto,{t.solid.direction,t.solid.length});
end

local function adjust_revolve(t)
	adjust(t);
end

----object----
function Mode:create_objcet(sd)
	local obj = {};
	obj.index = sd.id;
	return obj;
end

function Mode:object_add_surface(obj)
	obj.surfaces = obj.surfaces or {}
	local k = #obj.surfaces+1;
	local v = {textured=0};
	obj.surfaces[k] = v;
	self:change_color(k);
	return k,v;
end

function Mode:surface_add_point(sf, pt)
	pt = geo_.Point:new(pt);
	sf.points = sf.points or {};
	for k,v in ipairs(sf.points) do
		local it = geo_.Point:new{v[6],v[7],v[8]};
		if pt==it then return k end;
	end
	local k = #sf.points+1;
	local v = {self.color.r,self.color.g,self.color.b, 0,0, pt.x,pt.y,pt.z};
	sf.points[k] = v;
	return k;
end

----surface----
function Mode:surface_add_line(sf,id1,id2)
	if not id1 or not id2 then return end;
	sf.lines = sf.lines or {};
	table.insert(sf.lines,{id1,id2});
end

function Mode:surface_add_outer(sf,ids)
	if type(ids)~="table" then return end;
	sf.outer = sf.outer or {};
	for k,v in pairs(ids) do
		table.insert(sf.outer,v);
	end
end

function Mode:side(sf,bs,ts)
	local b1 = bs[1] and self:surface_add_point(sf,bs[1]);
	local b2 = bs[2] and self:surface_add_point(sf,bs[2]);
	local t1 = ts[1] and self:surface_add_point(sf,ts[1]);
	local t2 = ts[2] and self:surface_add_point(sf,ts[2]);
	return b1,b2,t1,t2;
end

function Mode:sides(obj,bs,ts)
	local bn,tn = table.getn(bs),table.getn(ts);
	local bk,tk=1,1;
	while bk<=bn and tk<=tn do
		local bv,tv = {},{};
		bv[1],tv[1] = bs[bk],ts[tk];
		if bk/bn<=tk/tn then 
			bk = bk + 1;
			bv[2] = bs[bk] or bs[1];
		end
		if  bk/bn>=tk/tn then 
			tk = tk + 1;
			tv[2] = ts[tk] or ts[1];
		end
		local sk,sv = self:object_add_surface(obj);
		self:side(sv,bv,tv);
	end
end

function Mode:allsides(obj,sd)
	if type(sd.bottom.outer)~="table" or type(self.top.outer)~="table" then error("bottom or top's outer is wrong") end;
	self.color_pos = sd.bottom.outer.circle and color_outer_cirle or color_outer_side;
	self:sides(obj,sd.bottom.outer,self.top.outer);
	if type(sd.bottom.inners)~="table" or type(self.top.inners)~="table" then return end;
	local bn,tn = table.getn(sd.bottom.inners),table.getn(self.top.inners);
	local k=1;
	while k<=bn and k<=tn do
		local bv,tv = sd.bottom.inners[k],self.top.inners[k];
		self.color_pos = bv.circle and color_inner_cirle or color_inner_side;
		self:sides(obj,bv,tv);
		k = k+1;
	end
end

function Mode:surface_add_points_index(sf,tab,key,pts)
	if not pts then return end;
	tab[key] = tab[key] or {};
	for k,v in ipairs(pts) do
		local id = self:surface_add_point(sf,v);
		table.insert(tab[key],id);
	end
end

-- function surface_add_outer_point_id(v,args)
	-- local cr,sf = args.color,args.surface;
	-- local pt = {cr.r,cr.g,cr.b, 0,0, v.x,v.y,v.z};
	-- local id = surface_add_point(pt);
	-- sf.outer = sf.outer or {};
	-- table.insert(sf.outer,id);
-- end
function Mode:section(obj,sect)
	local sk,sv = self:object_add_surface(obj);
	if type(sv)~="table" then error("surface is a nil") end;	
	self:surface_add_points_index(sv,sv,"outer",sect.outer);
	if type(sect.inners)~="table" then return end;
	sv.inners = sv.inners or {};
	for k,v in pairs(sect.inners) do
		self:surface_add_points_index(sv,sv.inners,k,v);
	end
	-- self:loop_section_outer(sect.outer,surface_add_point_id_outer,{color=self.color,surface=sv});
end

function Mode:sections(obj,sd)
	self.color_pos = color_section;
	self:section(obj,sd.bottom);
	self:section(obj,self.top);
end


Line = {name="Line"};
Line.__index = Line;
setmetatable(Line,Mode);
function Line:extrude(sd)
	self:set_color(sd.color);
--	self:set_top(sd);
	local obj = self:create_objcet(sd);
	local k,v = self:object_add_surface(obj,sd.color);
	local id1 = self:surface_add_point(v,sd.bottom.base);
	local id2 = self:surface_add_point(v,self.top.base);
	self:surface_add_line(v,id1,id2);
	return obj;
end
function Line:revolve(sd)
	self:set_color(sd.color);
--	self:set_top(sd);
	local obj = self:create_objcet(sd);
	local k,v = self:object_add_surface(obj,sd.color);
	local id1 = self:surface_add_point(v,sd.bottom.base);
	local id2 = self:surface_add_point(v,self.top.base);
	self:surface_add_line(v,id1,id2);
	return obj;
end

Frame = {name="Frame"};
Frame.__index = Frame;
setmetatable(Frame,Mode);

function Frame:side(sf,bs,ts)
	local b1,b2,t1,t2 = Mode.side(self,sf,bs,ts);
	self:surface_add_line(sf,b1,b2);
	self:surface_add_line(sf,b2,t2);
	self:surface_add_line(sf,t2,t1);
	self:surface_add_line(sf,t1,b1);
end

function Frame:extrude(sd)
	self:set_color(sd.color);
--	self:set_top(sd);
	local obj = self:create_objcet(sd);
	self:allsides(obj,sd);
	return obj;
end

Render = {name="Render"};
Render.__index = Render;
setmetatable(Render,Mode);

function Render:side(sf,bs,ts)
	local b1,b2,t1,t2 = Mode.side(self,sf,bs,ts);
	self:surface_add_outer(sf,{b1,b2,t2,t1});
end

function Render:extrude(sd)
	self:set_color(sd.color);
--	self:set_top(sd);
	local obj = self:create_objcet(sd);
	self:allsides(obj,sd);
	self:sections(obj,sd);
	return obj;
end

----private----
-- local function loop_object_surface(sur, f, args)
	-- for k,v in pairs(sur.points) do
		-- f(v,args);
	-- end
-- end
-- local function loop_objcet_coord(obj, f, args)
	-- for k,v in pairs(obj.surfaces) do
		-- loop_object_surface(v,f,args);
	-- end
-- end

local function x_position()
	local pos = {
		base = {0,0,0};
		beta = 0;
		x = {0,1,0};
		y = {0,0,1};
		z = {1,0,0};
	};
	return pos;
end

-- local function l2g_object_surface_point(pt, args)
	-- local axis = geo_.Axis:new(args[1]);
	-- local axis = (args[1]);
	-- local tmp = {pt[6],pt[7],pt[8]};
	-- tmp = geo_.Point:new(tmp);
	-- tmp = axis:l2g(tmp);
	-- pt[6] = tmp.x;
	-- pt[7] = tmp.y;
	-- pt[8] = tmp.z;
-- end
-- function l2g_object(obj, pos)
	-- loop_objcet_coord(obj, l2g_object_surface_point, {pos});
-- end

-- function moveto_position(obj, pos)
	-- pos = geo_.Axis:new(pos or x_position());
	-- l2g_object(obj,pos or x_position());
	-- return obj;
-- end

function moveto(t,obj)
	obj_.coord_l2g(obj, t.solid.position or x_position());
	-- local axis = geo_.Axis:new();
	-- if type(t.placement)=="table" then axis:set(t.placement) end
	if type(t.placement)=="table" then
		local axis = geo_.Axis:new(t.placement);
		obj_.coord_l2g(obj, axis);
	end
	return obj;
end

----------main---------------------------------------------------
--t={
--	index=;
--	mode=Line/Frame/Render;
--	solid={
--		color={r=1,g=0,b=0};
--		bottom={
--			outer={},
--			inters={{},{}};
--		};
--		top={};
--		direction={};
--		length=10000;
--		position = {};
--	};
--	placement = {};
--};
function extrude(t)
	adjust_extrude(t);
	local obj = t.run:extrude(t.solid);
	return moveto(t,obj);
end

--t={
--	index=;
--	mode=Line/Frame/Render;
--	solid={
--		color={r=1,g=0,b=0};
--		bottom={
--			outer={},
--			inters={{},{}};
--		};
--		top={};
--		line={};
--		angle=10000;
--		position = {};
--	};
--};
function revolve(t)
	adjust_revolve(t);
	local obj = t.run_mode:revolve(t.solid);
	return moveto(t,obj);
end

----------------------------
--arg = {
--	mode = ;
--	section = "";
--	section2 = "";
--	color = {r=,g=,b=};
--	pt1 = ;
--	pt2 = ;
--};
function member(arg)
	arg.section2 = arg.section2 or arg.section;
	local bouter,binners = section_.profile(arg.section);
	local touter,tinners = section_.profile(arg.section2);
	return extrude{
		mode = arg.mode;
		solid = {
			color = arg.color;
			length = geo_.Point:new(arg.pt1):distance(arg.pt2);
			bottom = {
				outer = bouter;
				inners = binners;
			};
			top = {
				outer = touter;
				inners = tinners;
			};
		};
		placement = geo_.Axis:new():set_x_line{arg.pt1,arg.pt2};
	};
end

