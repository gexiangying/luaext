module(...,package.seeall)
--[[
object={
	index = 1,
	surfaces = {
		{points={r,g,b,u,v,x,y,z},lines={},triangles={},quadrangles={},outer={1,2,3,4},inners={{},{}},texts={{ptno=1,r,g,b,str},{},},},
		{},
	},
}
--]]
--
count = 0
LOCALPLACE = { base = { x = 0.0, y = 0.0, z = 0.0}, x = { x =1.0,y=0.0,z=0.0},z = { x = 0.0,y=0.0,z = 1.0},beta = 0.0}
function LOCALPLACE:new(o)
	o = o or {}
	self.__index = self;
	setmetatable(o,self);
	return o;
end
function LOCALPLACE:translate(x,y,z)
	self.base = { ["x"] = x,["y"] = y,["z"] = z}
end

OBJ = {}
OBJ.__add = function (a,b)
	local t = OBJ:new()
	t.composed = { ["a"] = a, ["b"] = b, op = 2}
	return t
end

OBJ.__sub = function (a,b)
	local t = OBJ:new()
	t.composed = {["a"] = a,["b"] = b, op = 3}
	return t
end

OBJ.__mul = function(a,b)
	local t = OBJ:new()
	t.composed = {["a"] = a,["b"] = b, op = 1}
	return t
end
function OBJ:clone()
	local t = OBJ:new()
	t.composed = {["a"] = self,op = 0}
	return t
end
function OBJ:new(o)
	o = o or {}
	count = count + 1
	o.index = count 
	self.__index = self
	setmetatable(o,self)
	return o
end
function OBJ:rotatex(beta)
	self.localplacement = LOCALPLACE:new(self.localplacement)
	self.localplacement["beta"] = beta
end
function OBJ:translate(x,y,z)
	self.localplacement = LOCALPLACE:new(self.localplacement)
	self.localplacement:translate(x,y,z)	
end
function OBJ:add_obj(fun,t)
	t = t or {}
	if(t[self]) then return end
	fun(self)
	t[self] = true
	if(self.composed) then
--		self.composed.a.hide = 1
		self.composed.a:add_obj(fun,t)
		if(self.composed.b) then
--			self.composed.b.hide = 1
			self.composed.b:add_obj(fun,t)
		end
	end
end
--[[
local obj1 = OBJ:new()
local obj2 = OBJ:new()
local obj3 = (obj1 + obj2) 
local function test(o)
  print("index = " .. o.index)
end
obj3:translate(2000.0,0.0,0.0)
--obj3:add_obj(test)
--]]
texcount = 0
REPEAT_TEXTURE = 1
CLAMP_TEXTURE = 0
TEXTURE = { ["type"] = REPEAT_TEXTURE}
function TEXTURE:new(o)
	o = o or {}
  self.__index = self
	texcount = texcount + 1
	o.index = texcount
	setmetatable(o,self)	
	return o
end
