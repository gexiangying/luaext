module(...,package.seeall)

--[[
function add_obj(window,obj)
print(window)
print(obj.index)
end
--]]
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
-- void scene_addobj(scene,obj)
-- void scene_delobj(scene,obj)
-- int is_ctr_down()
-- void crt_toolbar(frm,toolbar)
-- void remove_toolbar(frm,id)
-- TBSTATE_ENABLED BTNS_BUTTON BTNS_SEP
-- add_menu(frm,{name=,items = { { id=,name=},}})
-- horwindow(frm)
-- verwindow(frm)
-- caswindow(frm)
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

	obj1 = {
		index = 1,
		surfaces = {
			{
				textured = 0,
				points = {
					{1.0,0.0,0.0,0.0,0.0,0,0,0},
					{1.0,0.0,0.0,0.0,0.0,1000,0,0},
					{1.0,0.0,0.0,0.0,0.0,1000,1000,0},
					{1.0,0.0,0.0,0.0,0.0,0,1000,0},
					{0.0,1.0,1.0,0.0,0.0,0,0,1000},
					{0.0,1.0,1.0,0.0,0.0,1000,0,1000},
					{0.0,1.0,1.0,0.0,0.0,1000,1000,1000},
					{0.0,1.0,1.0,0.0,0.0,0,1000,1000},
				},	
				triangles = {},
				quadrangles = {
					{1,2,6,5},
					{2,3,7,6},
					{3,4,8,7},
					{1,5,8,4},
					{1,4,3,2},
					{5,6,7,8},
				},
			},
		},
	}

obj2 = {
		index = 2,
		surfaces = {
			{
				textured = 0,
				points = {
					{0.5,0.5,0.5,0.0,0.0,500,100,100},
					{0.5,0.5,0.5,0.0,0.0,1500,100,100},
					{0.5,0.5,0.5,0.0,0.0,1500,900,100},
					{0.5,0.5,0.5,0.0,0.0,500,900,100},
					{0.0,0.0,0.0,0.0,0.0,500,100,900},
					{0.0,0.0,0.0,0.0,0.0,1500,100,900},
					{0.0,0.0,0.0,0.0,0.0,1500,900,900},
					{0.0,0.0,0.0,0.0,0.0,500,900,900},
				},	
				triangles = {},
				quadrangles = {
					{1,2,6,5},
					{2,3,7,6},
					{3,4,8,7},
					{1,5,8,4},
					{1,4,3,2},
					{5,6,7,8},
				},
			},
		},
	}
obj3 = {
		index = 3,
		surfaces = {
			{
				textured = 0,
				points = {
					{0.0,0.0,0.0,0.0,0.0,0,0,0},
					{0.0,0.0,0.0,0.0,0.0,1000,0,0},
					{0.0,0.0,0.0,0.0,0.0,1000,1000,0},
					{0.0,0.0,0.0,0.0,0.0,0,1000,0},
					{0.0,0.0,0.0,0.0,0.0,0,0,1000},
					{0.0,0.0,0.0,0.0,0.0,1000,0,1000},
					{0.0,0.0,0.0,0.0,0.0,1000,1000,1000},
					{0.0,0.0,0.0,0.0,0.0,0,1000,1000},
				},	
			lines = { {1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,5},{2,6},{3,7},{4,8},},	
			},
		},
	}


obj4 = {
		index = 4,
		surfaces = {
			{
				textured = 0,
				points = {
					{0.0,0.0,0.0,0.0,0.0,500,100,100},
					{0.0,0.0,0.0,0.0,0.0,1500,100,100},
					{0.0,0.0,0.0,0.0,0.0,1500,900,100},
					{0.0,0.0,0.0,0.0,0.0,500,900,100},
					{0.0,0.0,0.0,0.0,0.0,500,100,900},
					{0.0,0.0,0.0,0.0,0.0,1500,100,900},
					{0.0,0.0,0.0,0.0,0.0,1500,900,900},
					{0.0,0.0,0.0,0.0,0.0,500,900,900},
				},	
			lines = { {1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,5},{2,6},{3,7},{4,8},},	
			},
		},
	}

