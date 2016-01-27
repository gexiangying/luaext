local luaext = require "luaext"
a = luaext.encrypt("gexy")
print(a)
print(luaext.decrypt(a))
print(luaext.md5("gexy"))
local id = luaext.guid()
print(id)

local luaext_pipe = require "luaext.pipe"
local pipe = luaext_pipe.new("lua -v")
repeat
	local line = pipe:getline()
	if line then
		print(line)
	end
until not line
assert(pipe)
pipe:closeout()
pipe:closein()
