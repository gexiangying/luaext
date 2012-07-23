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

function OBJ:new(o)
	o = o or {}
	count = count + 1
	o.index = count 
	self.__index = self
	setmetatable(o,self)
	return o
end
function OBJ:add_obj(fun,t)
	t = t or {}
	if(t[self]) then return end
	fun(self)
	t[self] = true
	if(self.composed) then
		self.composed.a.hide = 1
		self.composed.b.hide = 1
		self.composed.a:add_obj(fun,t)
    self.composed.b:add_obj(fun,t)
	end
end
--[[
local obj1 = OBJ:new()
local obj2 = OBJ:new()
local obj3 = (obj1 + obj2) * (obj1 - obj2)
local function test(o)
  print("index = " .. o.index)
end
obj3:add_obj(test)
--]]
