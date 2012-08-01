module(...,package.seeall)

function load_apx(name)
	local f = io.open(name,"r")
	local obj = {}
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
--			model.objects[#model.objects + 1] = {}
--			local obj = model.objects[#model.objects]
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
				--s.outer = { 1,2,3,4}
				--s.inners= { {1,2,3},{2,3,4}}
				--s.texts = { {ptno=1,r=1,g=0,b=0,str="str1"},{ptno=2,r=1,g=0,b=0,str="str2≤‚ ‘"}}
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
			--add_obj(frm,obj);
		end --objnum
	end --while
return obj
end --function

local items = 1
function load_room_item()
if items == 27 then return end
	local apxname = "room/" .. tostring(items) .. ".apx"
	items = items + 1
	return load_apx(apxname)
end

function room_textures()
	texs={
				"images/mb04.bmp",
				"images/rosewd.bmp",
				"images/pine.bmp",
				"images/sunset.bmp",
				"images/lack2.bmp",
				"images/128x128_1.bmp",
				"images/128x128_4.bmp",
				"images/128x128_3.bmp",
				"images/128x128_2.bmp",
				"images/kb.bmp",
			}
	for k,v in ipairs(texs) do
		local texture = object.TEXTURE:new{name = v}	
		add_texture(frm,texture)
	end
end

function init()
	items = 1	
end
room_t = {
--	rotate = { x = -356.0, y = -68.0, z = -1.0},
	rotate = luapt.new(-356.0,-78.0,-1.0),
	cen = 	luapt.new(),
	scale = 0.011707,
	ortho = 0,
	clip = { pt = luapt.new() , x = luapt.normx() , z = luapt.normz() }	
	--clip = { pt = { x = 0.0, y = 0.0, z = 0.0}, x = { x = 1.0 , y = 0.0 , z = 0.0 }, z = { x =0.0 , y = 0.0, z = 1.0},}
}
