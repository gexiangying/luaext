package.cpath="?.dll;?51.dll"
local luaext = require "luaext"
local iup = require "iuplua"
local iupcontrol = require( "iupluacontrols" )
local redis = require "luaredis"
local room = require "room"
--[[
local t = luaext.str_machine(teststr)
for k,v in ipairs(t) do
trace_out(" type = " .. v["type"] .. ", value = " .. v["str"] .. "\n")
end
--]]
--[[
-- redis new_redis(servername,portno)
-- string redis:info()
-- void redis:close() 
-- int redis:ping() 1=OK 0=error
-- int redis:del(key) 1=OK
-- int redis:hdel(key,field) number,0=error
-- string,int redis:get(key) 1=ok 0=error
-- int string redis:incr(key) str=error
-- int redis:set(key,value) 1=ok 0=error
-- int redis:hset(key,field,value) number,0=error
-- int redis:hkeys(key) 1=ok
-- string,int redis:hget(key,field) 1=ok
-- string redis:getline(size)
-- int redis:hgetall(key) 1=ok
-- int,error(string) redis:hincr(key,field)
-- int redis:subscribe() 0 = error
--]]
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
--luaext.test("hello",ID)
--[[
function add_obj(window,obj)
print(window)
print(obj.index)
end
--]]

function on_command(cmd,child)
	if(cmd == ID + 2 ) then 
		room.load_room_item()
	elseif(cmd == ID +3 )then
		set_lineframe(frm,1)
	elseif(cmd == ID + 4) then
		set_lineframe(frm,0)
	elseif(cmd == ID +5) then
		remove_toolbar(frm,11041)
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
--load_apx("1.apx")
--trace_out("hello" .. " world\n")


