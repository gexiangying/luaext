1.	draw_member	
���ܣ����ƹ���
������������ֻ����
���أ������
ʾ����
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
���ܣ��༭�������ԣ������Ի���
��������������д��
���أ���
ʾ����
	stl = require("steel");
	h = {
		section = "H200*150*20*15";
		color = {1,0,0};
		startpt = {x=0,y=0,z=0};
		endpt = {800,0,0};
	};
	stl.edit_member_property(h);

