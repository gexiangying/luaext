1.	draw_member	
���ܣ����ƹ���
������������ֻ����
���أ������
ʾ����
	local steel = require("steel");
	local mem = {
		section = "H200*150*20*15";
		color = {r=1,g=0,b=0};
		startpt = {x=0,y=0,z=0};
		endpt = {800,0,0};
		beta = 45;
	};
	local obj = steel.draw_member(mem);
	add_obj(frm,obj);
	

2.	draw_plate	
���ܣ����ư�
������������ֻ����
���أ������
ʾ����
	local steel = require("steel");
	local pl = {
		sketch = "0";
		color = {r=1,g=0.5,b=0};
		points = {{700,-500,0}, {700,-1000,2000}, {100,500,2000}, {100,500,1500}, {100,1000,1500}, {100,1000,0}, {100,500,0};};
		thick = 500;
	};
	local obj = steel.draw_plate(pl);
	add_obj(frm,obj);

