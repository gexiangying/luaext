package.cpath="?.dll;?51.dll"
local luaext = require "luaext"
local iup = require "iuplua"
local iupcontrol = require( "iupluacontrols" )
local redis = require "luaredis"
local room = require "room"
local test = require "test"
local interface = require "interface"
interface.create_menu()
interface.create_toolbar()
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
function on_command(cmd,child)
	if(cmd == ID + 2 ) then 
		room.load_room_item()
	elseif(cmd == ID +3 )then
		set_lineframe(frm,1)
	elseif(cmd == ID + 4) then
		set_lineframe(frm,0)
	elseif(cmd == ID +5) then
		remove_toolbar(frm,11041)
	elseif(cmd == ID +6) then
		test.test_iup()
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


