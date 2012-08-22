module (...,package.seeall)

local tools_ = require "steel_tools"
PI = 3.14159265358979;

--float-----------------------------
local fmin_ = 0.000001;
function fmin(p)
	fmin_ = p or fmin_;
	return fmin_;
end

function flt(a,b,p)
	fmin(p);
	return b - a > fmin_;
end

function fmt(a,b,p)
	return flt(b,a,p);
end

function fle(a,b,p)
	return not fmt(a,b,p);
end

function fme(a,b,p)
	return not flt(a,b,p);
end

function feq(a,b,p)
	return fle(a,b,p) and fme(a,b,p);
end

function fue(a,b,p)
	return not feq(a,b,p);
end


--point-----------------------------
Point = {};
Point.__index = Point;
Point.name = "Point";

function Point:new(t)
	if getmetatable(t)==Axis then return t end;
	t = t or {}
	self.__index = self;
	setmetatable(t,self);
	t:set();
	return t;
end

function Point:set(t)
	t = t or self;
	self.x = t.x or t[1] or self.x or 0;
	self.y = t.y or t[2] or self.y or 0;
	self.z = t.z or t[3] or self.z or 0;
	self[1],self[2],self[3] = nil,nil,nil;
end

function Point:origin()
	return Point:new{0,0,0};
end

Point.__eq = function (a,b)
	if fue(a.x,b.x) then return false end;
	if fue(a.y,b.y) then return false end;
	if fue(a.z,b.z) then return false end;
	return true;
end

Point.__add = function(a,b)
	local t = Point:new();
	t.x = a.x+b.x;
	t.y = a.y+b.y;
	t.z = a.z+b.z;
	return t;
end

Point.__sub = function(a,b)
	local t = Point:new();
	t.x = a.x-b.x;
	t.y = a.y-b.y;
	t.z = a.z-b.z;
	return t;
end

Point.__unm = function(a)
	local t = Point:new();
	t = t-a;
	return t;
end

function Point:rotate_x(beta)
	local a = beta * PI/180.0;
	local pt = tools_.deepcopy(self);
	self.x = pt.x;
	self.y = pt.y * math.cos(a) - pt.z * math.sin(a);
	self.z = pt.y * math.sin(a) + pt.z * math.cos(a);
	return self;
end

function Point:rotate_y(beta)
	local a = beta *PI/180.0;
	local pt = tools_.deepcopy(self);
	self.x = pt.x * math.cos(a) + pt.z * math.sin(a);
	self.y = pt.y;
	self.z = -pt.x * math.sin(a) + pt.z * math.cos(a);
	return self;
end

function Point:rotate_z(beta)
	local a = beta *PI/180.0;
	local pt = tools_.deepcopy(self);
	self.x = pt.x * math.cos(a) - pt.y * math.sin(a);
	self.y = pt.x * math.sin(a) + pt.y * math.cos(a);
	self.z = pt.z;
	return self;
end

function Point:scale(f)
	if not f then return self end;
	self.x = self.x*f;
	self.y = self.y*f;
	self.z = self.z*f;
	return self;
end

function Point:dot(pt)
	if not pt then return end;
	return ( self.x * pt.x+ self.y * pt.y + self.z * pt.z );
end

function Point:normalize()
	local len = math.sqrt(self:dot(self));
	if (len > 0.0) then
		self:scale(1/len);
		return self;
	end
end

function Point:multi(pt)
	if not pt then return end;
	local t = Point:new();
	t.x = self.y * pt.z - pt.y * self.z;
	t.y = self.z * pt.x - pt.z * self.x;
	t.z = self.x * pt.y - pt.x * self.y;
	-- t:normalize();
	return t;
end

Point.__mul = function(a,b)
	if type(b)=="number" then return a:scale(b) end;
	if getmetatable(b)==Point then return a:multi(b) end;
end

function Point:distance(pt)
	pt = Point:new(pt);
	return math.sqrt( (self.x-pt.x)*(self.x-pt.x) + (self.y-pt.y)*(self.y-pt.y) + (self.z-pt.z)*(self.z-pt.z) );
end

function Point:polarto(nor,len)
	local norm = Point:new(tools_.deepcopy(nor)):normalize();
	self.x = self.x + len * norm.x;
	self.y = self.y + len * norm.y;
	self.z = self.z + len * norm.z;
	return self;
end

--line-----------------------------
Line = {};
Line.__index = Line;
Line.name = "Line";

function Line:new(t)
	if getmetatable(t)==Axis then return t end;
	t = t or {}
	self.__index = self;
	setmetatable(t,self);
	t:set();
	return t;
end

function Line:set(t)
	t = t or self;
	self.pt1 = Point:new(self.pt1 or self[1] or {0,0,0});
	self.pt2 = Point:new(self.pt2 or self[2] or {0,0,0});
	self[1],self[2] = nil,nil;
end

--axis-----------------------------
Axis = {};
Axis.__index = Axis;
Axis.name = "Axis";

function Axis:new(t)
--	if getmetatable(t)==Axis then return t end;
	t = t or {};
	self.__index = self;
	setmetatable(t,self);
	t:set();
	return t;
end

-- function Axis:init(t)
	-- self.base = Point:new(t and t.base or {0,0,0});
	-- self.beta = t and t.beta or 0;
	-- self.x = Point:new(t and t.x or {1,0,0});
	-- self.y = Point:new(t and t.y or {0,1,0});
	-- self.z = Point:new(t and t.z or {0,0,1});
	-- return self;
-- end

function Axis:set(t)
	t = t or self;
	self:set_base(t.base);
	self:set_beta(t.beta);
	if t.x and t.z then self:set_xz_normal(t.x,t.z) return end;
	if t.x and t.y then self:set_xy_normal(t.x,t.y) return end;	
	if t.y and t.z then self:set_yz_normal(t.y,t.z) return end;	
	if t.x then self:set_x_normal(t.x) return end;
	if t.y then self:set_y_normal(t.y) return end;
	self:set_default_normal();
	return self;
end

function Axis:set_default_normal()
	self.x = Point:new{1,0,0};
	self.y = Point:new{0,1,0};
	self.z = Point:new{0,0,1};
	return self;
end


-- function Axis:base_point(t)
	-- if not t then return self.base end;
	-- if type(t)=="table" then t = Point:new(t) end;
	-- self.base = t;
	-- return self.base;
-- end

-- function Axis:beta_degree(t)
	-- if not t then return self.beta end;
	-- self.beta = t;
	-- return self.beta;
-- end

function Axis:set_base(pt)
	self.base = Point:new(pt);
	return self;
end

--degree
function Axis:set_beta(degree)
	self.beta = degree or 0;
	return self;
end


function Axis:set_xz_normal(x,z)
	if type(x)~="table" then return end;
	if type(z)~="table" then return end;
	x = Point:new(x);
	z = Point:new(z);
	self.x = x:normalize();
	self.z = z:normalize();
--	tools_.otrace(self);
	self.y = (self.z*self.x):normalize();
	self.z = (self.x*self.y):normalize();
	return self;
end

function Axis:set_xy_normal(x,y)
	if type(x)~="table" then return end;
	if type(y)~="table" then return end;
	x = Point:new(x);
	y = Point:new(y);
	self.x = x:normalize();
	self.y = y:normalize();
	self.z = (self.x*self.y):normalize();
	self.y = (self.z*self.x):normalize();
	return self;
end

function Axis:set_yz_normal(y,z)
	if type(y)~="table" then return end;
	if type(z)~="table" then return end;
	y = Point:new(y);
	z = Point:new(z);
	self.y = y:normalize();
	self.z = z:normalize();
	self.x = (self.y*self.z):normalize();
	self.z = (self.x*self.y):normalize();
	return self;
end

function Axis:set_x_normal(x)
	if type(x)~="table" then return end;
	local z = Point:new{0,0,1};
	x = Point:new(x):normalize();
	if x==z or x==-z then z = Point:new{0,1,0} end;
	self:set_xz_normal(x,z);
	return self;
end

function Axis:set_y_normal(y)
	if type(y)~="table" then return end;
	local z = Point:new{0,0,1};
	y = Point:new(y):normalize();
	z = y==z or y==-z and Point:new{1,0,0} or z;
	self:set_yz_normal(y,z);
	return self;
end

function Axis:set_x_line(ln)
	if type(ln)~="table" then return end;
	ln = Line:new(ln);
	self:set_base(ln.pt1);
	ln.pt2.x = ln.pt1==ln.pt2 and ln.pt1.x+1 or ln.pt2.x;
	self:set_x_normal(ln.pt2-ln.pt1);
	return self;
end

function Axis:set_offset_line(ln)
	if type(ln)~="table" then return end;
	ln = Line:new(ln);
	self:set_base(ln.pt2-ln.pt1);
	return self;
end

function Axis:check()
	if not tools_.ismet(Point,self.base) then error("base isn't a Point") return false end;
	if not tools_.ismet(Point,self.x) then error("x isn't a Point") return false end;
	if not tools_.ismet(Point,self.y) then error("y isn't a Point") return false end;
	if not tools_.ismet(Point,self.z) then error("z isn't a Point") return false end;
	if not type(self.beta)=="number" then error("beta isn't a number") return false end;
	return true;
end

function Axis:g2l(pt)
	self:check();
	local rt = Point:new();
	pt = Point:new(pt);
	pt = pt - self.base;
	rt.x = pt.x * self.x.x + pt.y * self.x.y + pt.z * self.x.z;
	rt.y = pt.x * self.y.x + pt.y * self.y.y + pt.z * self.y.z;
	rt.z = pt.x * self.z.x + pt.y * self.z.y + pt.z * self.z.z;
	rt:rotate_x(-self.beta);
	return rt;
end

function Axis:l2g(pt)
	self:check();
	local rt = Point:new();
	pt = Point:new(pt);
	pt = pt:rotate_x(self.beta);
	rt.x = pt.x * self.x.x + pt.y * self.y.x + pt.z * self.z.x;
	rt.y = pt.x * self.x.y + pt.y * self.y.y + pt.z * self.z.y;
	rt.z = pt.x * self.x.z + pt.y * self.y.z + pt.z * self.z.z;
	rt = rt + self.base;	
	return rt; 
end

function Axis:g2l_normal(nor)
	self:check();
	nor = Point:new(nor);
	nor = nor + self.base;
	nor = self:g2l(nor);
	return nor;
end

function Axis:l2g_normal(nor)
	self:check();
	nor = Point:new(nor);
	nor = self:l2g(nor);
	nor = nor - self.base;
	return nor;
end



























