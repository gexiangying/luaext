--ReiLoad(荷载类)	20120615
package.path = "?;?.lua"
local rei_structure = require "ReiStructure"
local g_pt = require "g_pt"

module (...,package.seeall)
--荷载数值类
ReiLoadValue = {number_id = 0,value = {}}
rei_structure.setparent(rei_structure.ReiRoot, ReiLoadValue)

function ReiLoadValue:set_value(value)
	self.value = value
	return self
end

--集中荷载类型
ReiLoadValueConcentrate = {} 	--value = 0.0 荷载数值(注意荷载的正负方向）
--线性分布荷载类型
ReiLoadValueUniform = {}		--value = f1,f2(起点和终点的荷载数值，缺省f2为均匀荷载)
--梯形分布荷载类型
ReiLoadValueTrapeziform = {}	--value = f1,f2（起点和终点的荷载数值，缺省f2为三角荷载)
--2D均匀分布荷载类型
ReiLoadValuePressure = {}		--value = 0.0}	--f1, 荷载数值
--温度荷载类型
ReiLoadValueTemperature = {}	--value = f1，f2，f4（见有关说明）
--[[说明： 
f1 = 可引起构件轴线伸长或结构单元体积均匀膨胀的温度改变量， 
f2 = 构件或结构单元顶部和底部的温差[顶部温度（Ttop surface）-底部温度（Tbottom surface）]。
		如果省略了f2 ，则不考虑弯曲变形（局部Y轴，构件/板）。
f4 = 构件从一个面到另一个面的温度差（局部Z轴，构件）。--]]

--构件的应变荷载类型
ReiLoadValueStrain = {} 	--因结构制造误差等引起构件初始轴线伸长(+),或缩短(-)
--构件的单位长度内应变荷载
ReiLoadValueStrainRate = {}	--构件单位长度内初始轴线伸长(为正)或缩短(为负)
--自重荷载类型
ReiLoadValueSelfweight = {}	--自重荷载系数，一般情况下value = 1.0
	
rei_structure.setparent(ReiLoadValue, ReiLoadValueConcentrate)
rei_structure.setparent(ReiLoadValue, ReiLoadValueUniform)
rei_structure.setparent(ReiLoadValue, ReiLoadValueTrapeziform)
rei_structure.setparent(ReiLoadValue, ReiLoadValuePressure)
rei_structure.setparent(ReiLoadValue, ReiLoadValueTemperature)
rei_structure.setparent(ReiLoadValue, ReiLoadValueStrain)
rei_structure.setparent(ReiLoadValue, ReiLoadValueStrainRate)
rei_structure.setparent(ReiLoadValue, ReiLoadValueSelfweight)
----------------------------------------------------------------------------------
--荷载作用位置类
ReiLoadLocation = {location = {}}
rei_structure.setparent(rei_structure.ReiRoot, ReiLoadLocation)

function ReiLoadLocation:set_location(location)
	self.location = location
	return self
end

ReiLoadLocation1 = {}	--具有1个参数的位置定义location = {}
--[[目前应用: 集中荷载作用点距构件起始端的距离--]]
ReiLoadLocation2 = {f4,f5}	--具有2个参数的位置定义location = {}
--[[目前应用: f4,f5(均布荷载作用域起终点位置,缺省为全跨荷载)--]]
ReiLoadLocation3 = {}	--具有3个参数的位置定义location = {}
--[[目前应用: Nil--]]
ReiLoadLocation4 = {}	--具有4个参数的位置定义
--[[目前应用: 2D构件－f4,f5,f6,f7梯形分布荷载作用区域,缺省f7为三角荷载
			  3D单元－x1,y1,x2,y2(荷载作用区域,缺省为作用在整个单元)。
					  若只有给出x1,y1,则假定荷载是作为集中荷载作用在指定点上--]]
ReiLoadLocation5 = {}	--具有5个参数的位置定义
--[[目前应用: Nil--]]
rei_structure.setparent(ReiLoadLocation, ReiLoadLocation1)
rei_structure.setparent(ReiLoadLocation, ReiLoadLocation2)
rei_structure.setparent(ReiLoadLocation, ReiLoadLocation3)
rei_structure.setparent(ReiLoadLocation, ReiLoadLocation4)
rei_structure.setparent(ReiLoadLocation, ReiLoadLocation5)
-----------------------------------------------------------------------------------
--作用于对象上的荷载类
ReiLoadObject = {
		
		load_type  	= "FX",				--荷载种类(FX,FY,FZ,MX,MY,MZ,TE,ST,SR)
		direction 	= "X",				--荷载作用方向(x,y,z,X,Y,Z,GX,GY,GZ,PX,PY,PZ)
		location 	= {},	--荷载作用位置ReiLoadLocation
		loadvalue 	= {}		--荷载数值ReiLoadValue
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



ReiLoadObjectPoint 	= {}	--作用于点对象上的荷载
ReiLoadObjectLine 	= {}	--作用于线对象上的荷载
ReiLoadObjectMember = {}	--作用于Member对象上的荷载
ReiLoadObjectBeam 	= {}	--作用于梁构件对象上的荷载
ReiLoadObjectColumn = {}	--作用于柱构件对象上的荷载
rei_structure.setparent(ReiLoadObject, ReiLoadObjectPoint)
rei_structure.setparent(ReiLoadObject, ReiLoadObjectLine)
rei_structure.setparent(ReiLoadObject, ReiLoadObjectMember)
rei_structure.setparent(ReiLoadObject, ReiLoadObjectBeam)
rei_structure.setparent(ReiLoadObject, ReiLoadObjectColumn)
--[[说明：

--作用于节点或杆件上的集中荷载类型
= {	direction = "X", 	--荷载作用方向: X,Y,Z,GX,GY,GZ,PX,PY,PZ
						--（局部坐标，整体坐标，投影坐标任选一）
	loadtype  = "FX",	--荷载类型: FX，FY，FZ，MX，MY，MZ（单选）
	loadvalue = 0.0,	--荷载数值(注意荷载的正负方向）
	location  = 0.0	}	--荷载作用点距构件起始端的距离
--direction =  荷载作用方向；X，Y，Z表示荷载作用在构件局部坐标系中的方向， GX，GY，GZ表示荷载作用在构件整体坐标系中的方向；如果荷载在相应于整体坐标轴方向上沿着构件的投影长度分布，那么要用PX，PY，PZ代替GX，GY，GZ。这时，荷载作用的起始点和终点是沿构件的投影长度来确定的而不是构件本身的长度来确定的。

--沿着杆件线性分布荷载类型
= {	direction = "X", 	--荷载作用方向: X，Y，Z，GX，GY，GZ，PX，PY，PZ
						--（局部坐标，整体坐标，投影坐标任选一）
	loadtype  = "FX",	--荷载类型: FX，FY，FZ，MX，MY，MZ（单选）
	loadvalue = {},	--f1，f2（起点和终点的荷载数值，缺省f2表示为均匀荷载)
	location  = {}}	--f4，f5（荷载作用区域起点和终点的位置，缺省为全跨荷载）

--沿着杆件梯形分布荷载类型
= {	direction = "X", 	--荷载作用方向: X，Y，Z，GX，GY，GZ，PX，PY，PZ
						--（局部坐标，整体坐标，投影坐标任选一）
	loadtype  = "FX",	--荷载类型: FX，FY，FZ，MX，MY，MZ（单选）
	loadvalue = {},	--f1,f2（起点和终点的荷载数值，缺省f2为三角荷载)
	location  = {}}	--f4，f5，f6，f7（荷载作用区域，缺省f7为三角荷载）

--作用于板单元的均匀分布荷载类型
= {	direction = "GX", 	--荷载作用方向: GX，GY，GZ，PX，PY，PZ
	loadvalue = 0.0,	--f1, 荷载数值
	location  = {}}		--x1,y1,x2,y2（荷载作用区域,缺省为作用在整个单元上的）
									--若只有给出x1,y1, 则假定荷载是作为集中荷载作用在指定点上

--作用于板单元的梯形分布荷载类型
= {	direction = "x", 	--荷载作用方向: x, y（见有关说明）
	loadvalue = {}}		--f2，f3, 荷载数值（见有关说明）

--作用于板或构件上的温度荷载类型
= {	loadvalue = {}}		--f1，f2，f4（见有关说明）
说明：
f1 = 可引起构件轴线伸长或结构单元体积均匀膨胀的温度改变量， 
f2 = 构件或结构单元顶部和底部的温差[顶部温度（Ttop surface）-底部温度（Tbottom surface）]。
		如果省略了f2 ，则不考虑弯曲变形（局部Y轴，构件/板）。
f4 = 构件从一个面到另一个面的温度差（局部Z轴，构件）。

--作用于构件上的应变荷载类型
= {	loadvalue  = 0.0}	--由于结构制造误差等原因而引起构件的初始轴线伸长(为正)或缩短(为负)

--作用于构件上的单位长度内应变荷载
= {	loadvalue  = 0.0}	--构件单位长度内初始轴线伸长（为正）或缩短（为负）
					 
--作用于整个结构的自重荷载类型
= {	direction = "X"}			--X，Y，Z（自重荷载作用方向，单选）
--]]
------------------------------------------------------------------------------------
--作用于整体结构上的荷载类
ReiLoadWhole = {load_type  	= "GV",				--荷载类型(GV)
				load_value 	=  {} }		--荷载数值ReiLoadValue
rei_structure.setparent(rei_structure.ReiRoot, ReiLoadWhole)

function ReiLoadWhole:set_loadtype(load_type)
	self.load_type = load_type
	return self
end

function ReiLoadWhole:set_loadvalue(load_value)
	self.load_value = load_value
	return self
end


ReiLoadWholeSelfweight = {}	--作用于整体结构的自重荷载
rei_structure.setparent(ReiLoadWhole, ReiLoadWholeSelfweight)
------------------------------------------------------------------------------------
----荷载工况类
ReiLoadCase = {	factor 		= {},				--荷载乘子(放大系数，包括正负号) 
				object_load 	=  {}, 	--对象荷载(与荷载乘子相对应)ReiLoadObject
				whole_load 	=  {}}		--整体荷载(与荷载乘子相对应)ReiLoadWhole
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
--荷载组合工况类
ReiLoadCombination = {	list 		= {},		--参与组合的荷载工况序列
						coefficient	= {},		--荷载组合系数列表，与list的顺序相对应
						SRSSmultiple= {}	}	--见如下说明
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


--[[说明：
1.	coefficient = 组合系数列表，与list的个数相等，且必须与list序列中的成员一一对应。
2.	SRSSmultiple = 采用SRSS组合时SRSS荷载组合结果的乘子系数序列，与list的个数相等，
		且必须与list序列中的成员一一对应，缺省值为零。如果某一荷载工况的这一系数为零，
		则表示该荷载工况不参与SRSS组合方式，且该基本荷载工况仅与由其他荷载工况
		进行SRSS组合后的结果进行代数叠加（具体见如下介绍）。
	SRSS荷载组合方式介绍：
		如果系列中某一SRSSmultiple为零，则与之相对应的基本荷载工况分析结果将参与代数叠加。
		如果序列中某一SRSSmultiple非零，则与之相对应的基本荷载工况分析结果将采用SRSS方式叠加。
--]]
--EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
--BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB

--几号load作用于构件list中
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


