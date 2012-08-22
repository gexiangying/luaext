package.cpath="?;?.lua;?.dll"




module (...,package.seeall)

local rei_obj = require "ReiObject"
local rei_structure = require "ReiStructure"


Group = {
			group_geometrys={},		--几何特征组或序列-ReiGroupGeometry
			group_jnts={},		--节点组或序列-ReiGroupJoint
			group_members={},		--构件组或序列-ReiGroupMember
			group_elements={},		--板单元组或序列-ReiGroupElement
			group_solids={},		--块体单元组或序列-ReiGroupSolid
			group_load_cases={},		--荷载工况组或序列-ReiGroupLoadCase
			
}
Support = {
			--支座
			support_pinneds={}, 	--支座集合-ReiBoundarySupportPinned 节点铰接支座
			support_fixeds={}, 	--支座集合-ReiBoundarySupportFixed 节点固定支座
			support_spring_factors={}, 	--支座集合-ReiBoundarySupportSpringFactor 弹性支撑与弹簧系数
			support_spring_mats={}, 	--支座集合-ReiBoundarysupportSpringMat 平面基础弹簧系数
	
			support_allocate  = { },
			
}
Load = {
			
			load_points={}, 		--荷载集合-作用于点对象上的荷载 ReiLoadObjectPoint
			load_lines={}, 		--荷载集合-作用于线对象上的荷载 ReiLoadObjectLine
			load_members={}, 		--荷载集合-作用于Member对象上的荷载 ReiLoadObjectMember
			
			
			loading_allocate  = { },
			
			
			load_cases={},--荷载工况类 ReiLoadCase
			load_case_allocate  = { },
			
			load_combinations={},--荷载组合工况类 ReiLoadCombination
			load_combination_allocate  = { },
			
			
}


ReiModel = {	
			rei_project={},		--工程设置-
			
			operate = {},
			name = "",
			parameter1 = "",
			etabs = {frame_sections = {},
					point_coordinates = {},
					stories = { },
					grids = { },
					controls = {},
					line_connectivities = {},
					area_connectivities = {},
					line_assigns = {},
					point_assigns = {},
					area_assigns = {},
					},
			midas = {
					 joint_coordinates = {},
					 element_connectivities = {},
					},
			
			
			
			nodes={},		--节点node集合-ReiGeoShapeCoordinate			
			mems={},		--构件集合-ReiObjectMember
			
			elements={},		--单元集合-elements			

			mems_property={},		--构件指定属性-mems property		
			elements_property={},		--单元指定属性-elements property		
			
			
			
			supports = {},		--Support
			loads = {},		--Load		
	
			groups = {},		--Group
		
			section_collect = {},--设定截面表数据 ReiSectionCollect
			
			
			points={},		--点集合-ReiObjectPoint --暂时不用
			lines={},		--线集合-ReiObjectLine --暂时不用
			displacements={}		--节点位移-ReiGeoShapeDisplacement --暂时不用		  
			
			
}




rei_model = rei_structure.new(ReiModel)


function ReiModel:push_jnt(v)
	table.insert(joints,v)	
	
end
function ReiModel:push_mem(v)
	table.insert(mems,v)	
end
function ReiModel:push_group(v)
	table.insert(groups,v)	
end

function ReiModel:push_support(v)
	table.insert(supports,v)	
end
function ReiModel:push_load(v)
	table.insert(loads,v)	
end



function ReiModel:open_staad(file_name,rei_model)
	
end

function ReiModel:save_staad(file_name,rei_model)
	
end

------------------------------------------------------------
--实用的函数





