--ReiLoad(������)	20120615
package.path = "?;?.lua"
local rei_structure = require "ReiStructure"
local g_pt = require "g_pt"

module (...,package.seeall)
--������ֵ��
ReiLoadValue = {number_id = 0,value = {}}
rei_structure.setparent(rei_structure.ReiRoot, ReiLoadValue)

function ReiLoadValue:set_value(value)
	self.value = value
	return self
end

--���к�������
ReiLoadValueConcentrate = {} 	--value = 0.0 ������ֵ(ע����ص���������
--���Էֲ���������
ReiLoadValueUniform = {}		--value = f1,f2(�����յ�ĺ�����ֵ��ȱʡf2Ϊ���Ⱥ���)
--���ηֲ���������
ReiLoadValueTrapeziform = {}	--value = f1,f2�������յ�ĺ�����ֵ��ȱʡf2Ϊ���Ǻ���)
--2D���ȷֲ���������
ReiLoadValuePressure = {}		--value = 0.0}	--f1, ������ֵ
--�¶Ⱥ�������
ReiLoadValueTemperature = {}	--value = f1��f2��f4�����й�˵����
--[[˵���� 
f1 = �����𹹼������쳤��ṹ��Ԫ����������͵��¶ȸı����� 
f2 = ������ṹ��Ԫ�����͵ײ����²�[�����¶ȣ�Ttop surface��-�ײ��¶ȣ�Tbottom surface��]��
		���ʡ����f2 ���򲻿����������Σ��ֲ�Y�ᣬ����/�壩��
f4 = ������һ���浽��һ������¶Ȳ�ֲ�Z�ᣬ��������--]]

--������Ӧ���������
ReiLoadValueStrain = {} 	--��ṹ�����������𹹼���ʼ�����쳤(+),������(-)
--�����ĵ�λ������Ӧ�����
ReiLoadValueStrainRate = {}	--������λ�����ڳ�ʼ�����쳤(Ϊ��)������(Ϊ��)
--���غ�������
ReiLoadValueSelfweight = {}	--���غ���ϵ����һ�������value = 1.0
	
rei_structure.setparent(ReiLoadValue, ReiLoadValueConcentrate)
rei_structure.setparent(ReiLoadValue, ReiLoadValueUniform)
rei_structure.setparent(ReiLoadValue, ReiLoadValueTrapeziform)
rei_structure.setparent(ReiLoadValue, ReiLoadValuePressure)
rei_structure.setparent(ReiLoadValue, ReiLoadValueTemperature)
rei_structure.setparent(ReiLoadValue, ReiLoadValueStrain)
rei_structure.setparent(ReiLoadValue, ReiLoadValueStrainRate)
rei_structure.setparent(ReiLoadValue, ReiLoadValueSelfweight)
----------------------------------------------------------------------------------
--��������λ����
ReiLoadLocation = {location = {}}
rei_structure.setparent(rei_structure.ReiRoot, ReiLoadLocation)

function ReiLoadLocation:set_location(location)
	self.location = location
	return self
end

ReiLoadLocation1 = {}	--����1��������λ�ö���location = {}
--[[ĿǰӦ��: ���к������õ�๹����ʼ�˵ľ���--]]
ReiLoadLocation2 = {f4,f5}	--����2��������λ�ö���location = {}
--[[ĿǰӦ��: f4,f5(�����������������յ�λ��,ȱʡΪȫ�����)--]]
ReiLoadLocation3 = {}	--����3��������λ�ö���location = {}
--[[ĿǰӦ��: Nil--]]
ReiLoadLocation4 = {}	--����4��������λ�ö���
--[[ĿǰӦ��: 2D������f4,f5,f6,f7���ηֲ�������������,ȱʡf7Ϊ���Ǻ���
			  3D��Ԫ��x1,y1,x2,y2(������������,ȱʡΪ������������Ԫ)��
					  ��ֻ�и���x1,y1,��ٶ���������Ϊ���к���������ָ������--]]
ReiLoadLocation5 = {}	--����5��������λ�ö���
--[[ĿǰӦ��: Nil--]]
rei_structure.setparent(ReiLoadLocation, ReiLoadLocation1)
rei_structure.setparent(ReiLoadLocation, ReiLoadLocation2)
rei_structure.setparent(ReiLoadLocation, ReiLoadLocation3)
rei_structure.setparent(ReiLoadLocation, ReiLoadLocation4)
rei_structure.setparent(ReiLoadLocation, ReiLoadLocation5)
-----------------------------------------------------------------------------------
--�����ڶ����ϵĺ�����
ReiLoadObject = {
		
		load_type  	= "FX",				--��������(FX,FY,FZ,MX,MY,MZ,TE,ST,SR)
		direction 	= "X",				--�������÷���(x,y,z,X,Y,Z,GX,GY,GZ,PX,PY,PZ)
		location 	= {},	--��������λ��ReiLoadLocation
		loadvalue 	= {}		--������ֵReiLoadValue
				}
rei_structure.setparent(rei_structure.ReiRoot, ReiLoadObject)

function ReiLoadLocation:set_location(location)
	self.location = location
	return self
end

function ReiLoadObject:set_loadtype(load_type)
	self.load_type = load_type
	return self
end
function ReiLoadObject:set_direction(direction)
	self.direction = direction
	return self
end



ReiLoadObjectPoint 	= {}	--�����ڵ�����ϵĺ���
ReiLoadObjectLine 	= {}	--�������߶����ϵĺ���
ReiLoadObjectMember = {}	--������Member�����ϵĺ���
ReiLoadObjectBeam 	= {}	--�����������������ϵĺ���
ReiLoadObjectColumn = {}	--�����������������ϵĺ���
rei_structure.setparent(ReiLoadObject, ReiLoadObjectPoint)
rei_structure.setparent(ReiLoadObject, ReiLoadObjectLine)
rei_structure.setparent(ReiLoadObject, ReiLoadObjectMember)
rei_structure.setparent(ReiLoadObject, ReiLoadObjectBeam)
rei_structure.setparent(ReiLoadObject, ReiLoadObjectColumn)
--[[˵����

--�����ڽڵ��˼��ϵļ��к�������
= {	direction = "X", 	--�������÷���: X,Y,Z,GX,GY,GZ,PX,PY,PZ
						--���ֲ����꣬�������꣬ͶӰ������ѡһ��
	loadtype  = "FX",	--��������: FX��FY��FZ��MX��MY��MZ����ѡ��
	loadvalue = 0.0,	--������ֵ(ע����ص���������
	location  = 0.0	}	--�������õ�๹����ʼ�˵ľ���
--direction =  �������÷���X��Y��Z��ʾ���������ڹ����ֲ�����ϵ�еķ��� GX��GY��GZ��ʾ���������ڹ�����������ϵ�еķ��������������Ӧ�����������᷽�������Ź�����ͶӰ���ȷֲ�����ôҪ��PX��PY��PZ����GX��GY��GZ����ʱ���������õ���ʼ����յ����ع�����ͶӰ������ȷ���Ķ����ǹ�������ĳ�����ȷ���ġ�

--���Ÿ˼����Էֲ���������
= {	direction = "X", 	--�������÷���: X��Y��Z��GX��GY��GZ��PX��PY��PZ
						--���ֲ����꣬�������꣬ͶӰ������ѡһ��
	loadtype  = "FX",	--��������: FX��FY��FZ��MX��MY��MZ����ѡ��
	loadvalue = {},	--f1��f2�������յ�ĺ�����ֵ��ȱʡf2��ʾΪ���Ⱥ���)
	location  = {}}	--f4��f5�������������������յ��λ�ã�ȱʡΪȫ����أ�

--���Ÿ˼����ηֲ���������
= {	direction = "X", 	--�������÷���: X��Y��Z��GX��GY��GZ��PX��PY��PZ
						--���ֲ����꣬�������꣬ͶӰ������ѡһ��
	loadtype  = "FX",	--��������: FX��FY��FZ��MX��MY��MZ����ѡ��
	loadvalue = {},	--f1,f2�������յ�ĺ�����ֵ��ȱʡf2Ϊ���Ǻ���)
	location  = {}}	--f4��f5��f6��f7��������������ȱʡf7Ϊ���Ǻ��أ�

--�����ڰ嵥Ԫ�ľ��ȷֲ���������
= {	direction = "GX", 	--�������÷���: GX��GY��GZ��PX��PY��PZ
	loadvalue = 0.0,	--f1, ������ֵ
	location  = {}}		--x1,y1,x2,y2��������������,ȱʡΪ������������Ԫ�ϵģ�
									--��ֻ�и���x1,y1, ��ٶ���������Ϊ���к���������ָ������

--�����ڰ嵥Ԫ�����ηֲ���������
= {	direction = "x", 	--�������÷���: x, y�����й�˵����
	loadvalue = {}}		--f2��f3, ������ֵ�����й�˵����

--�����ڰ�򹹼��ϵ��¶Ⱥ�������
= {	loadvalue = {}}		--f1��f2��f4�����й�˵����
˵����
f1 = �����𹹼������쳤��ṹ��Ԫ����������͵��¶ȸı����� 
f2 = ������ṹ��Ԫ�����͵ײ����²�[�����¶ȣ�Ttop surface��-�ײ��¶ȣ�Tbottom surface��]��
		���ʡ����f2 ���򲻿����������Σ��ֲ�Y�ᣬ����/�壩��
f4 = ������һ���浽��һ������¶Ȳ�ֲ�Z�ᣬ��������

--�����ڹ����ϵ�Ӧ���������
= {	loadvalue  = 0.0}	--���ڽṹ��������ԭ������𹹼��ĳ�ʼ�����쳤(Ϊ��)������(Ϊ��)

--�����ڹ����ϵĵ�λ������Ӧ�����
= {	loadvalue  = 0.0}	--������λ�����ڳ�ʼ�����쳤��Ϊ���������̣�Ϊ����
					 
--�����������ṹ�����غ�������
= {	direction = "X"}			--X��Y��Z�����غ������÷��򣬵�ѡ��
--]]
------------------------------------------------------------------------------------
--����������ṹ�ϵĺ�����
ReiLoadWhole = {load_type  	= "GV",				--��������(GV)
				load_value 	=  {} }		--������ֵReiLoadValue
rei_structure.setparent(rei_structure.ReiRoot, ReiLoadWhole)

function ReiLoadWhole:set_loadtype(load_type)
	self.load_type = load_type
	return self
end

function ReiLoadWhole:set_loadvalue(load_value)
	self.load_value = load_value
	return self
end


ReiLoadWholeSelfweight = {}	--����������ṹ�����غ���
rei_structure.setparent(ReiLoadWhole, ReiLoadWholeSelfweight)
------------------------------------------------------------------------------------
----���ع�����
ReiLoadCase = {	factor 		= {},				--���س���(�Ŵ�ϵ��������������) 
				object_load 	=  {}, 	--�������(����س������Ӧ)ReiLoadObject
				whole_load 	=  {}}		--�������(����س������Ӧ)ReiLoadWhole
rei_structure.setparent(rei_structure.ReiRoot, ReiLoadCase)

function ReiLoadCase:set_factor(factor)
	self.factor = factor
	return self
end
function ReiLoadCase:set_object_load(object_load)
	self.object_load = object_load
	return self
end
function ReiLoadCase:set_whole_load(whole_load)
	self.whole_load = whole_load
	return self
end


----------------------------------------------------------------------------------
--������Ϲ�����
ReiLoadCombination = {	list 		= {},		--������ϵĺ��ع�������
						coefficient	= {},		--�������ϵ���б���list��˳�����Ӧ
						SRSSmultiple= {}	}	--������˵��
rei_structure.setparent(rei_structure.ReiRoot, ReiLoadCombination)

function ReiLoadCombination:set_list(list)
	self.list = list
	return self
end
function ReiLoadCombination:set_coefficient(coefficient)
	self.coefficient = coefficient
	return self
end
function ReiLoadCombination:set_SRSSmultiple(SRSSmultiple)
	self.SRSSmultiple = SRSSmultiple
	return self
end


--[[˵����
1.	coefficient = ���ϵ���б���list�ĸ�����ȣ��ұ�����list�����еĳ�Աһһ��Ӧ��
2.	SRSSmultiple = ����SRSS���ʱSRSS������Ͻ���ĳ���ϵ�����У���list�ĸ�����ȣ�
		�ұ�����list�����еĳ�Աһһ��Ӧ��ȱʡֵΪ�㡣���ĳһ���ع�������һϵ��Ϊ�㣬
		���ʾ�ú��ع���������SRSS��Ϸ�ʽ���Ҹû������ع����������������ع���
		����SRSS��Ϻ�Ľ�����д������ӣ���������½��ܣ���
	SRSS������Ϸ�ʽ���ܣ�
		���ϵ����ĳһSRSSmultipleΪ�㣬����֮���Ӧ�Ļ������ع����������������������ӡ�
		���������ĳһSRSSmultiple���㣬����֮���Ӧ�Ļ������ع����������������SRSS��ʽ���ӡ�
--]]
--EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
--BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB

--����load�����ڹ���list��
Loading_Allocate ={ load_id = "",list = {} }
rei_structure.setparent(rei_structure.ReiRoot, Loading_Allocate)

Load_Case_Allocate ={ load_id = "",list = {}  }
rei_structure.setparent(rei_structure.ReiRoot, Load_Case_Allocate)

Load_Combination_Allocate ={ load_id = "",list = {} }
rei_structure.setparent(rei_structure.ReiRoot, Load_Combination_Allocate)



function draw_load(rei_model,mem,point_load,index)
	local obj = {}
	obj.index = index
	obj.surfaces = {}
	--obj.surfaces.points = {}
	obj.surfaces[1] = {}
	obj.surfaces[1].points = {}
	obj.surfaces[1].lines = {}
	obj.surfaces[1].triangles = {}
	obj.surfaces[1].quadrangles = {}
	
	dis = 100
	st_x = rei_model.nodes[mem.incidence[1]].value_list [1] 
	st_y = rei_model.nodes[mem.incidence[1]].value_list [2]  + dis
	st_z = rei_model.nodes[mem.incidence[1]].value_list [3] 
	
	end_x = rei_model.nodes[mem.incidence[2]].value_list [1] 
	end_y = rei_model.nodes[mem.incidence[2]].value_list [2]  + dis
	end_z = rei_model.nodes[mem.incidence[2]].value_list [3] 
	
	st_y_down = st_y - 200	
	arrow_h = 20
	
	pt_s = {x = st_x, y = st_y, z = st_z}
	pt_e = {x = end_x, y = end_y, z = end_z}
	pt_s_1 = {x = st_x,y = st_y - dis,z = st_z}
	pt_e_1 = {x = end_x,y = end_y - dis,z = end_z}
	
	pt_s_1_arrow_l = {x = st_x + arrow_h ,y = st_y - dis + arrow_h ,y,z = st_z}
	pt_s_1_arrow_r = {x = st_x - arrow_h ,y = st_y - dis + arrow_h ,y,z = st_z}
	
	pt_e_1_arrow_l = {x = end_x + arrow_h,y = end_y - dis + arrow_h,z = end_z}
	pt_e_1_arrow_r = {x = end_x - arrow_h,y = end_y - dis + arrow_h,z = end_z}

	
	
	
	obj.surfaces[1].points = { {0,1,0,0,0,pt_s.x,pt_s.y,pt_s.z},
								{0,1,0,0,0,pt_e.x,pt_e.y,pt_e.z},
								{0,1,0,0,0,pt_s_1.x,pt_s_1.y,pt_s_1.z},
								{0,1,0,0,0,pt_e_1.x,pt_e_1.y,pt_e_1.z},
								{0,1,0,0,0,pt_s_1_arrow_l.x,pt_s_1_arrow_l.y,pt_s_1_arrow_l.z},
								{0,1,0,0,0,pt_s_1_arrow_r.x,pt_s_1_arrow_r.y,pt_s_1_arrow_r.z},
								{0,1,0,0,0,pt_e_1_arrow_l.x,pt_e_1_arrow_l.y,pt_e_1_arrow_l.z},
								{0,1,0,0,0,pt_e_1_arrow_r.x,pt_e_1_arrow_r.y,pt_e_1_arrow_r.z}
								
								}
	obj.surfaces[1].lines = {{1,2},{1,3},{2,4},{3,5},{3,6},{4,7},{4,8}}
	
	return obj	
end


