local luaext = require "luaext"
--[[
a = luaext.encrypt("gexy")
print(a)
print(luaext.decrypt(a))
print(luaext.md5("gexy"))
local id = luaext.guid()
print(id)
--]]
local luaext_pipe = require "luaext.pipe"
local pipe = luaext_pipe.new("ipconfig /all")
--local pipe = luaext_pipe.new("bad")
if not pipe then 
	print("Create error!")
	return 
end

local macs = {}
repeat
	local line = pipe:getline()
	if line then
--		print(line)
		local mac = string.match(line,"%s+(%x%x%-%x%x%-%x%x%-%x%x%-%x%x%-%x%x)%s+")
		if mac then macs[mac] = true end
	end
until not line
for k,v in pairs(macs) do
	print(k)
end
print("------------------------------------")
pipe:closeout()
pipe:closein()
--print(luaext.mac())
local mac_str = luaext.mac()
print(mac_str)
macs = {}
string.gsub(mac_str,"(%x%x%-%x%x%-%x%x%-%x%x%-%x%x%-%x%x)\r\n",function(s)
	macs[s] = true
end)

for k,v in pairs(macs) do
	print(k)
end
