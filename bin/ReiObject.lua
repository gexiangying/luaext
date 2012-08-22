--ReiObject(��������)
package.path = "?;?.lua"
local rei_structure = require "ReiStructure"

module (...,package.seeall)



--���ϵ�ж���
ReiGroup = {name = "",		--���û�ָ�������������е�����
			list = {}	}	--�б���Ѷ����Groupϵ��

function ReiGroup:set_name(name)
	self.name = name
	return self
end
function ReiGroup:set_list(list)
	self.list = list
	return self
end

--���������������
ReiGroupGeometry = {}
--�ڵ��������					
ReiGroupJoint = {}
--�����������
ReiGroupMember = {}
--�嵥Ԫ�������
ReiGroupElement = {}
--���嵥Ԫ�������
ReiGroupSolid = {}
--�������������
ReiGroupBeam = {}
--�������������
ReiGroupColumn = {}
--���ع����������
ReiGroupLoadCase = {}



rei_structure.setparent(ReiGroup, ReiGroupGeometry)
rei_structure.setparent(ReiGroup, ReiGroupJoint)
rei_structure.setparent(ReiGroup, ReiGroupMember)
rei_structure.setparent(ReiGroup, ReiGroupSolid)
rei_structure.setparent(ReiGroup, ReiGroupBeam)
rei_structure.setparent(ReiGroup, ReiGroupColumn)
rei_structure.setparent(ReiGroup, ReiGroupLoadCase)

--����������ϵ��
ReiObjectIncidence = {incidence = {}}
rei_structure.setparent(rei_structure.ReiRoot, ReiObjectIncidence)

function ReiObjectIncidence:set_incidence(incidence)
	self.incidence = incidence
	return self
end

--����������ı��
ReiObjectIncidence2 = {}	--����2����
ReiObjectIncidence4 = {}	--����4����
ReiObjectIncidence8 = {}	--����8����

rei_structure.setparent(ReiObjectIncidence, ReiObjectIncidence2)
rei_structure.setparent(ReiObjectIncidence, ReiObjectIncidence4)
rei_structure.setparent(ReiObjectIncidence, ReiObjectIncidence8)

--���ֶ�������ݽṹ
--ReiObject = {property  = {}} 			--����ReiPrpoerty,��һ��
ReiObject = { 			number_id = 0,			section  = {},              material  = {}, 			--����ReiPrpoerty,��һ��
			 
			 a = 1,
			 incidence = {}	}	--����������Ϣ(���ӱ��)ReiObjectIncidence
rei_structure.setparent(rei_structure.ReiRoot, ReiObject)


function ReiObject:set_incidence(incidence)
	self.incidence = incidence
	return self
end



ReiObjectPoint = {x=0.0,y=0.0,z=0.0}		--�����
ReiObjectLine = {start={},ed={}}		--ֱ���߶���

ReiObjectMember = {	}	--Member����
					
					
ReiObjectBeam = {}		--����������
ReiObjectColumn = {}	--����������
--Element����
--Solid����
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