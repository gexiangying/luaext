package.cpath="?.dll;?51.dll"
local luaext = require "luaext"
local iup = require "iuplua"
local iupcontrol = require( "iupluacontrols" )
local redis = require "luaredis"
local interface = require "interface"
interface.create_menu()
interface.create_toolbar()
-- ID frm 
-- add_obj(frm,o)
-- remove_obj(frm,objindex)
-- set_lineframe(frm,flag=0 or 1)
-- trace_out(str)
-- x,y,z client_2_world(scene,x,y)
-- scene_select(scene,x,y,w,h,single)
-- scene* new_child(frm,title)
-- void scene_clip(scene,x1,y1,z1,x2,y2,z2)
-- void scene_onpain(scene)
-- void scene_scale(scene,scale)
-- void scene_cen(scene,x,y,z)
-- void scene_rotate(scene,x,y,z)
-- void scene_offset(scene,x,y,z)
-- void scene_ortho(scene,0 or 1)
-- int is_ctr_down()
-- void crt_toolbar(frm,toolbar)
-- void remove_toolbar(frm,id)
-- TBSTATE_ENABLED BTNS_BUTTON BTNS_SEP
-- add_menu(frm,{name=,items = { { id=,name=},}})
function test_iup()
	text_location = iup.text{expand="HORIZONTAL", id="text_location"}
	btn_browse = iup.button{title="Browse", rastersize="x22",id="btn_browse"}
	multi = iup.multiline{expand="YES"}
	dlg = iup.dialog
	{
	    iup.vbox
	    {
	        iup.label{title="Location:"},
	        iup.hbox
	        {
	            text_location,
	            btn_browse
	            ; margin="0x0"
	        },
	        iup.label{title="Text:"},
					--multi = iup.multiline{expand="YES"},
					multi,
	    }
	    ;title="iuplua sample", size="200x100", margin="10x10"
	}
	
	function btn_browse:action()
	    local dlg = iup.filedlg{dialogtype="DIR"}
	    dlg:popup()
	    if dlg.status == "0" then
	        text_location.value = dlg.value
	    end
	end
	
	--dlg:show()
	dlg:show()
	iup.MainLoop()
end

function test_iup2()
	res, name = iup.GetParam("Title", nil,
	    "Give your name: %s\n","")
	iup.Message("Hello!",name)
end

select_ary = {}
model = {	lk = {0.011707,-356.0,-68.0,-1.0},
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
		--set_lineframe(frm,0)
		remove_toolbar(frm,11041)
	elseif(cmd == ID + 5) then
		set_singleselect(child)
	elseif(cmd == ID + 6) then
		set_mulselect(child)
		--new_child(frm,"formlua")
		--test_iup2()
	else luaext.msg("on_command",tostring(cmd))
	end
end

function begin_select(ctrlkey)
	if(ctrlkey == 0) then
		select_ary = {}
	else
		select_ary.ctrlkey = true
	end
end

function end_select()
end

local function trace_select()
	trace_out("select_ary[] = ")
	for k,v in pairs(select_ary) do
		trace_out( k .. " ")
	end
	trace_out("\n")
end

function select_main(index)
	--luaext.msg("select",tostring(index))
	if(select_ary.ctrlkey and select_ary[index]) then
		select_ary[index] =  nil
	else
		select_ary[index] = true
	end
	trace_select()
end

function select_sub(mainindex,subindex)
	if(select_ary[mainindex]) then
		select_ary[mainindex][subindex] = {}
	end
end

function on_lbuttondown(scene,flags,x,y)
--	trace_out("lua:on_lbuttondown()\n")
scene_select(scene,x,y,10,10,1)
end

function on_lbuttonup(scene,flags,x,y)
	trace_out("lua:on_lbuttonup()\n")
end

function on_mousemove(scene,flags,x,y)
	x1,y1,z1 = client_2_world(scene,x,y)
	str = string.format("(%f%f%f)\n",x1,y1,z1)
--	trace_out("lua:on_mousemoven" .. str )
end
load_apx("1.apx")
--trace_out("hello" .. " world\n")


