--ReiObject(对象定义类)
package.path = "?;?.lua"
local rei_structure = require "ReiStructure"

module (...,package.seeall)



--组或系列对象
ReiGroup = {name = "",		--由用户指定用来代表序列的名称
			list = {}	}	--列表或已定义的Group系列

function ReiGroup:set_name(name)
	self.name = name
	return self
end
function ReiGroup:set_list(list)
	self.list = list
	return self
end

--几何特征组或序列
ReiGroupGeometry = {}
--节点组或序列					
ReiGroupJoint = {}
--构件组或序列
ReiGroupMember = {}
--板单元组或序列
ReiGroupElement = {}
--块体单元组或序列
ReiGroupSolid = {}
--梁构件组或序列
ReiGroupBeam = {}
--柱构件组或序列
ReiGroupColumn = {}
--荷载工况组或序列
ReiGroupLoadCase = {}



rei_structure.setparent(ReiGroup, ReiGroupGeometry)
rei_structure.setparent(ReiGroup, ReiGroupJoint)
rei_structure.setparent(ReiGroup, ReiGroupMember)
rei_structure.setparent(ReiGroup, ReiGroupSolid)
rei_structure.setparent(ReiGroup, ReiGroupBeam)
rei_structure.setparent(ReiGroup, ReiGroupColumn)
rei_structure.setparent(ReiGroup, ReiGroupLoadCase)

--构件关联关系类
ReiObjectIncidence = {incidence = {}}
rei_structure.setparent(rei_structure.ReiRoot, ReiObjectIncidence)

function ReiObjectIncidence:set_incidence(incidence)
	self.incidence = incidence
	return self
end

--构件关联点的标号
ReiObjectIncidence2 = {}	--具有2个点
ReiObjectIncidence4 = {}	--具有4个点
ReiObjectIncidence8 = {}	--具有8个点

rei_structure.setparent(ReiObjectIncidence, ReiObjectIncidence2)
rei_structure.setparent(ReiObjectIncidence, ReiObjectIncidence4)
rei_structure.setparent(ReiObjectIncidence, ReiObjectIncidence8)

--各种对象的数据结构
--ReiObject = {property  = {}} 			--截面ReiPrpoerty,这一个
ReiObject = { 			number_id = 0,			section  = {},              material  = {}, 			--截面ReiPrpoerty,这一个
			 
			 a = 1,
			 incidence = {}	}	--构件关联信息(连接编号)ReiObjectIncidence
rei_structure.setparent(rei_structure.ReiRoot, ReiObject)


function ReiObject:set_incidence(incidence)
	self.incidence = incidence
	return self
end



ReiObjectPoint = {x=0.0,y=0.0,z=0.0}		--点对象
ReiObjectLine = {start={},ed={}}		--直线线对象

ReiObjectMember = {	}	--Member对象
					
					
ReiObjectBeam = {}		--梁构件对象
ReiObjectColumn = {}	--柱构件对象
--Element对象
--Solid对象
rei_structure.setparent(ReiObject, ReiObjectPoint)
rei_structure.setparent(ReiObject, ReiObjectLine)
rei_structure.setparent(ReiObject, ReiObjectMember)
rei_structure.setparent(ReiObject, ReiObjectBeam)
rei_structure.setparent(ReiObject, ReiObjectColumn)

--ReiObjectMember start--------------------------------------------------------




--ReiObjectMember end--------------------------------------------------------


ReiProject = {
	control = "",
	message = ""

}