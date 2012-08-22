package.cpath="?;?.lua;?.dll"

--module (...,package.seeall)

require "ifc"

setfenv(1,ifc)


local obj_tool_ = require "obj_tool"

function get_columns(datas,mems)
	for k ,v in pairs(datas) do
		if (v.class_name == "IFCBEAM") then
			table.insert(mems,v)		
		elseif (v.class_name == "IFCCOLUMN") then
			table.insert(mems,v)		
		elseif (v.class_name == "IFCSLAB") then
			table.insert(mems,v)		
		else
		end
		
	end
end

	

Column = { 				axis = {origin = {},x_axis = {},z_axis = {}},
			surface = {
						vertexs = {},
						direct = {},
						len = 0.0
				}
}

function get_column(col)
	local column = {}
	if (col[6])then
		column.axis = col[6]:get_axis()	
	end
	if (col[7])then
		column.surface = col[7]:get_surface()	
	end
	return column;
end




function draw_ifc_model(datas)
	local cols ={}
	get_columns(datas,cols)

	for k in pairs(cols) do					
		local obj  = new(obj_tool_.Object)
		cols[k].result:get_obj(obj)
	end
	print("draw ok")
end







