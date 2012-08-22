--ReiOperate(��������������)	20120615
package.path = "?;?.lua"
local rei_structure = require "ReiStructure"


module (...,package.seeall)

ReiOperate = {start = "",				--���������ָ��
			  modeltype = "SPACE_FRAME",
			  control = "",
			  name = "",
			  title = "",
			  input_width = "",
			  output_width = "",
			  modeltype = "SPACE_FRAME"
			  
			  }
--[[˵����
modeltype ֻ���������µ�����
SPACE_FRAME 		�� �ռ��ܽṹ
SPACE_TRUSS 		�� �ռ���ܽṹ
PLANE_FRAME 		�� ƽ���ܽṹ
PLANE_TRUSS 		�� ƽ����ܽṹ
FLOOR		   		�� ¥��ṹ
AXIS SYMMETRY		�� ��Գƽṹ--]]

--ReiOperateAnalysisMethod
function ReiOperate:set_start(start)
	self.start = start
	return self
end
function ReiOperate:set_modeltype(modeltype)
	self.modeltype = modeltype
	return self
end

ReiParameter = {timestep = 0.0,
				frequencynumber = 1,
				modenumber = 1,
				}

--perform
--ReiPrint = {}
function ReiParameter:set_timestep(timestep)
	self.timestep = timestep
	return self
end
function ReiParameter:set_frequencynumber(frequencynumber)
	self.frequencynumber = frequencynumber
	return self
end
function ReiParameter:set_modenumber(modenumber)
	self.modenumber = modenumber
	return self
end
