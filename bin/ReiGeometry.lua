--ReiGeometry(������Ϣ��)	20120615
package.path = "?;?.lua"
local rei_structure = require "ReiStructure"

module (...,package.seeall)

--�������������������
ReiGeoShape = {system 	   	= "CARTESIAN", 	--CARTESIAN, SPHERICAL, CYLINDRICAL
			   dimension  	= 3,		  	--1, 2, 3 (1ά��2ά��3ά������ϵ)
			   number_id 	= 0,		  	--��Ż�����б�
			   value_list	= {3,4,5}		}	--CARTESIAN����ϵ�µ�x, y, z ���������ֵ
											--SPHERICAL����ϵ�µ�R, Ct, Z���������ֵ
											--CYLINDRICAL����ϵ�µ�R, Y, Ct���������ֵ
rei_structure.setparent(rei_structure.ReiRoot, ReiGeoShape)

function ReiGeoShape:set_system(system)
	self.system = system
	return self
end
function ReiGeoShape:set_dimension(dimension)
	self.dimension = dimension
	return self
end
function ReiGeoShape:set_numberlist(numberlist)
	self.numberlist = numberlist
	return self
end
function ReiGeoShape:set_valuelist(valuelist)
	self.valuelist = valuelist
	return self
end


ReiGeoShapeCoordinate = {}		--�ڵ�����
ReiGeoShapeAspect = {}			--��ʽ����
ReiGeoShapeDisplacement = {}		--�ڵ�λ��

rei_structure.setparent(ReiGeoShape, ReiGeoShapeCoordinate)
rei_structure.setparent(ReiGeoShape, ReiGeoShapeAspect)
rei_structure.setparent(ReiGeoShape, ReiGeoShapeDisplacement)

--�����
ReiGeoOrientation = {angle = {ax=0.0, ay=0.0, az=0.0}}	--������˵����ȱʡֵΪ�㣩
--ax, ay, az = �ֱ��ʾ�ڵ�������������x, y, ��z����ļнǣ����ڶ�����б����ľֲ����ꡣ
rei_structure.setparent(rei_structure.ReiRoot, ReiGeoOrientation)

function ReiGeoOrientation:set_angle(angle)
	self.angle = angle
	return self
end


