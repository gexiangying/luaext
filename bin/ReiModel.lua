package.cpath="?;?.lua;?.dll"




module (...,package.seeall)

local rei_obj = require "ReiObject"
local rei_structure = require "ReiStructure"


Group = {
			group_geometrys={},		--���������������-ReiGroupGeometry
			group_jnts={},		--�ڵ��������-ReiGroupJoint
			group_members={},		--�����������-ReiGroupMember
			group_elements={},		--�嵥Ԫ�������-ReiGroupElement
			group_solids={},		--���嵥Ԫ�������-ReiGroupSolid
			group_load_cases={},		--���ع����������-ReiGroupLoadCase
			
}
Support = {
			--֧��
			support_pinneds={}, 	--֧������-ReiBoundarySupportPinned �ڵ�½�֧��
			support_fixeds={}, 	--֧������-ReiBoundarySupportFixed �ڵ�̶�֧��
			support_spring_factors={}, 	--֧������-ReiBoundarySupportSpringFactor ����֧���뵯��ϵ��
			support_spring_mats={}, 	--֧������-ReiBoundarysupportSpringMat ƽ���������ϵ��
	
			support_allocate  = { },
			
}
Load = {
			
			load_points={}, 		--���ؼ���-�����ڵ�����ϵĺ��� ReiLoadObjectPoint
			load_lines={}, 		--���ؼ���-�������߶����ϵĺ��� ReiLoadObjectLine
			load_members={}, 		--���ؼ���-������Member�����ϵĺ��� ReiLoadObjectMember
			
			
			loading_allocate  = { },
			
			
			load_cases={},--���ع����� ReiLoadCase
			load_case_allocate  = { },
			
			load_combinations={},--������Ϲ����� ReiLoadCombination
			load_combination_allocate  = { },
			
			
}


ReiModel = {	
			rei_project={},		--��������-
			
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
			
			
			
			nodes={},		--�ڵ�node����-ReiGeoShapeCoordinate			
			mems={},		--��������-ReiObjectMember
			
			elements={},		--��Ԫ����-elements			

			mems_property={},		--����ָ������-mems property		
			elements_property={},		--��Ԫָ������-elements property		
			
			
			
			supports = {},		--Support
			loads = {},		--Load		
	
			groups = {},		--Group
		
			section_collect = {},--�趨��������� ReiSectionCollect
			
			
			points={},		--�㼯��-ReiObjectPoint --��ʱ����
			lines={},		--�߼���-ReiObjectLine --��ʱ����
			displacements={}		--�ڵ�λ��-ReiGeoShapeDisplacement --��ʱ����		  
			
			
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
--ʵ�õĺ���





