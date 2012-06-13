package.cpath="?.dll"
local luaext = require "luaext"
model = {lk = {0.011707,-356.0,-68.0,-1.0},
texs={
{"images/mb04.bmp","REPEAT_TEXTURE"},
{"images/rosewd.bmp","REPEAT_TEXTURE"},
{"images/pine.bmp","REPEAT_TEXTURE"},
{"images/sunset.bmp","REPEAT_TEXTURE"},
{"images/lack2.bmp","REPEAT_TEXTURE"},
{"images/128x128_1.bmp","REPEAT_TEXTURE"},
{"images/128x128_4.bmp","REPEAT_TEXTURE"},
{"images/128x128_3.bmp","REPEAT_TEXTURE"},
{"images/128x128_2.bmp","REPEAT_TEXTURE"},
{"images/kb.bmp","REPEAT_TEXTURE"},
},
objects = {},
}
local number = 2
--luaext.test("hello",ID)

--[[
function add_obj(window,obj)
print(window)
print(obj.index)
end
--]]
local function load_apx(name)
local f = io.open(name,"r")
while true do
local line = f:read("*line")
if not line then break end
local objnum = string.find(line,"ObjectNum")
if(objnum ) then 
local tri = 0
local pointn = 0
local quadric = 0
local surfn = 0
local texid = 0
line = f:read("*line") --object
local obj_index = tonumber(string.match(line,"(%d+)"))
line = f:read("*line") --surfacen
surfn = tonumber(string.match(line,"(%d+)"))
model.objects[#model.objects + 1] = {}
local obj = model.objects[#model.objects]
obj.index = obj_index
obj.surfaces = {}
local surfaces = obj.surfaces
for i = 1 ,surfn do
line = f:read("*line") -- surface
line = f:read("*line") -- tex
texid = tonumber(string.match(line,"(%d+)"))
line = f:read("*line") --pointnum
pointn = tonumber(string.match(line,"(%d+)"))
line = f:read("*line") -- tri
tri = tonumber(string.match(line,"(%d+)"))
line = f:read("*line") --quadric
quadric = tonumber(string.match(line,"(%d+)"))
surfaces[#surfaces +1] = {}
local s = surfaces[#surfaces]
--print( "surfacen = " .. i .. "  texid=" .. texid .. "  pointn=" .. pointn .. "  tri=" .. tri .. "  quadric=" .. quadric)
s.textured = texid
s.lines = {{1,2},{2,3}}
s.points = {}
s.triangles = {}
s.quadrangles = {}
for k =1 , pointn do
line = f:read("*line") --point line
s.points[k] = {}
r,g,b,u,v,x,y,z = string.match(line,"([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+)")
--print(r .. " " .. g .. " " .. b .. " " .. u .. " " .. v .. " " .. x .. " " .. y .. " " .. z)
s.points[k][1] = tonumber(r)
s.points[k][2] = tonumber(g)
s.points[k][3] = tonumber(b)
s.points[k][4] = tonumber(u)
s.points[k][5] = tonumber(v)
s.points[k][6] = tonumber(x) * 1000.0
s.points[k][7] = tonumber(y) * 1000.0
s.points[k][8] = tonumber(z) * 1000.0
end
for k = 1,tri do
line = f:read("*line")
s.triangles[k] = {}
p1,p2,p3 = string.match(line,"(%d+) (%d+) (%d+) ")
s.triangles[k][1] = tonumber(p1) + 1
s.triangles[k][2] = tonumber(p2) + 1
s.triangles[k][3] = tonumber(p3) + 1
end
for k=1,quadric do
line = f:read("*line")
s.quadrangles[k] = {}
p1,p2,p3,p4 = string.match(line,"(%d+) (%d+) (%d+) (%d+)")
s.quadrangles[k][1] = tonumber(p1) + 1
s.quadrangles[k][2] = tonumber(p2) + 1
s.quadrangles[k][3] = tonumber(p3) + 1
s.quadrangles[k][4] = tonumber(p4) + 1
end --for quadric
end --end surface loop
add_obj(frm,obj);
end --objnum
end --while
end --function

function on_command(cmd,child)
if(cmd == ID + 2 and number < 27) then 
local apxname = number .. ".apx"
number = number + 1
load_apx(apxname)
elseif(cmd == ID +3 )then
set_lineframe(frm,1)
elseif(cmd == ID + 4) then
set_lineframe(frm,0)
else luaext.msg("on_command",tostring(cmd))
end
end

function select_main(index)
luaext.msg("select",tostring(index))
end
load_apx("1.apx")


