--	ReiStructure 20120615

module (...,package.seeall)



function new(tab, o)
	o = o or {}
	tab.__index = tab
	setmetatable(o, tab)
	return o
end

function setparent(parent, child)
	parent.__index = parent
	setmetatable(child, parent)
end

--ReiSetUp(设置信息)
--根表
ReiRoot = {	id = "",
			name = "",
			unit = {} --ReiUnitSet
			}
--单位设置
ReiUnitSet = {	unitID		= "",
				length 		= "METER", 		--INCHES; FEET; METER; CM; MMS; DME; KM
				force 		= "KG", 		--KIP；POUND；KG；MTON；NEWTON；KNS；MNS；DNS
				times 		= "SECOND",		--HOUR; MINUTE; SECOND
				angle 		= "DEGREE",		--DEGREE; RADIAN
				frequency	= "HZ"		}	--HZ; KHZ; MHZ


