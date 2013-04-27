--ReiOperate(基本操作命令类)	20120615
package.path = "?;?.lua"
local rei_structure = require "ReiStructure"


module (...,package.seeall)

ReiOperate = {start = "",				--启动程序的指令
			  modeltype = "SPACE_FRAME",
			  control = "",
			  name = "",
			  title = "",
			  input_width = "",
			  output_width = "",
			  modeltype = "SPACE_FRAME"
			  
			  }
--[[说明：
modeltype 只允许是如下的内容
SPACE_FRAME 		＝ 空间框架结构
SPACE_TRUSS 		＝ 空间桁架结构
PLANE_FRAME 		＝ 平面框架结构
PLANE_TRUSS 		＝ 平面桁架结构
FLOOR		   		＝ 楼板结构
AXIS SYMMETRY		＝ 轴对称结构--]]

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
