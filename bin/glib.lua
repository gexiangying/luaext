local glib = require "luaext.glib"
gh = glib.Ghandle(0,0)
local class = glib.GetClass(gh)
do
	local ln = {name="li"}
	glib.SetLink(gh,ln)
end
print(glib.GetLink(gh).name)

local function test_method()
	print("test_method")
end

glib.SetMethod(class,"test",test_method)
gh:test()


gh1 = glib.Ghandle(0,0)
gh1:test()
