1.	draw_member	
功能：绘制构件
参数：构件表（只读）
返回：对象表
示例：
	stl = require("steel");
	h = {
		section = "H200*150*20*15";
		color = {r=1,g=0,b=0};
		startpt = {x=0,y=0,z=0};
		endpt = {800,0,0};
		beta = 45;
	};
	o = stl.draw_member(h);
	add_obj(frm,o);
	

2.	edit_member_property	
功能：编辑构件属性（弹出对话框）
参数：构件表（读写）
返回：无
示例：
	stl = require("steel");
	h = {
		section = "H200*150*20*15";
		color = {1,0,0};
		startpt = {x=0,y=0,z=0};
		endpt = {800,0,0};
	};
	stl.edit_member_property(h);

