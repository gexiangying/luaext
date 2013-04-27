--ReiGeometry(几何信息类)	20120615
package.path = "?;?.lua"
local rei_structure = require "ReiStructure"

module (...,package.seeall)

--以坐标点描述的数据类
ReiGeoShape = {system 	   	= "CARTESIAN", 	--CARTESIAN, SPHERICAL, CYLINDRICAL
			   dimension  	= 3,		  	--1, 2, 3 (1维，2维或3维坐标体系)
			   number_id 	= 0,		  	--编号或序号列表
			   value_list	= {3,4,5}		}	--CARTESIAN坐标系下的x, y, z 方向的坐标值
											--SPHERICAL坐标系下的R, Ct, Z方向的坐标值
											--CYLINDRICAL坐标系下的R, Y, Ct方向的坐标值
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


ReiGeoShapeCoordinate = {}		--节点坐标
ReiGeoShapeAspect = {}			--样式表述
ReiGeoShapeDisplacement = {}		--节点位移

rei_structure.setparent(ReiGeoShape, ReiGeoShapeCoordinate)
rei_structure.setparent(ReiGeoShape, ReiGeoShapeAspect)
rei_structure.setparent(ReiGeoShape, ReiGeoShapeDisplacement)

--方向角
ReiGeoOrientation = {angle = {ax=0.0, ay=0.0, az=0.0}}	--见如下说明（缺省值为零）
--ax, ay, az = 分别表示节点在整体坐标下x, y, 和z方向的夹角，用于定义倾斜方向的局部坐标。
rei_structure.setparent(rei_structure.ReiRoot, ReiGeoOrientation)

function ReiGeoOrientation:set_angle(angle)
	self.angle = angle
	return self
end


