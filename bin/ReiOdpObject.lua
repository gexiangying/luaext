package.cpath="?;?.lua;?.dll"

local rei_structure = require "ReiStructure"

module (...,package.seeall)

ReiOdpMember = {
	section = "H200*150*20*15",
	material = "SS400",
	color = { r=1,g=0,b=0 },
	sketch = 0,
	start_pt = { x=0,y=0,z=0 },
	end_pt = { x=0,y=0,z=0},
	length = 0,
	beta = 0,
	start_node = 1,
	end_node = 2,

	loads = {} --ReiLoadObjectMember ¼¯ºÏ
 


}

function get_odpmem(mem,nodes)
	local odp_mem = rei_structure.new(ReiOdpMember)
	odp_mem.section = mem.section
	odp_mem.color = mem.color
	odp_mem.sketch = mem.sketch
	odp_mem.beta = mem.beta
	

--[[
	odp_mem.section = "H200*150*20*15"
	odp_mem.color = {r=1,g=0,b=0 }
	odp_mem.sketch = 0
	odp_mem.beta = 0
--]]



	odp_mem.start_node = mem.incidence[1]
	odp_mem.end_node = mem.incidence[2]
		
	odp_mem.start_pt.x = nodes[odp_mem.start_node].value_list[1]
	odp_mem.start_pt.y = nodes[odp_mem.start_node].value_list[2]
	odp_mem.start_pt.z = nodes[odp_mem.start_node].value_list[3]
	
	odp_mem.end_pt.x = nodes[odp_mem.end_node].value_list[1]
	odp_mem.end_pt.y = nodes[odp_mem.end_node].value_list[2]
	odp_mem.end_pt.z = nodes[odp_mem.end_node].value_list[3]
	
	
	
	
	
	return odp_mem
end