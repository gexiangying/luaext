module (...,package.seeall)


function trace_pt(v)
	trace_out("x = " .. v.x  .." ,y = " .. v.y .. " ,z = "  .. v.z  .. "\n")
end
function trace_pts(pts)
	for i=1,#pts do
		trace_out("id = " .. i .."   x = " .. pts[i][6]  .." ,y = " ..  pts[i][7] .. " ,z = "  .. pts[i][8]  .. "\n")
	end	
end
function trace_lines(vs)
	for i=1,#vs do
		trace_out("id =  " .. i .."   start_id = " ..vs[i][1] .. "   end_id = " .. vs[i][2] .. "\n")
	end	
end
function trace_triangles(vs)
	trace_out("triangles\n")
	for i=1,#vs do
		trace_out("id =  " .. i .."   one_id = " ..vs[i][1] .. "   two_id = " .. vs[i][2].. "  three_id = " .. vs[i][3] .. "\n")
	end	
end
function trace_quadrangles(vs)
	trace_out("quadrangles\n")
	for i=1,#vs do
		trace_out("id = " .. i .."   one_id = " ..vs[i][1] .. "   two_id = " .. vs[i][2].. "   three_id = " .. vs[i][3] .. "   four_id = " .. vs[i][4] .. "\n")
	end	
end



function trace_obj(obj)
	trace_out("obj info start"  .. "\n")
	trace_out("\tindex = " .. obj.index  .. "\n")
	trace_out("\tsurfaces 'num  = " .. #obj.surfaces   .. "\n")
	for i=1,#obj.surfaces do
		trace_pts(obj.surfaces[i].points)
		trace_lines(obj.surfaces[i].lines)
		--trace_triangles(obj.surfaces[i].triangles)
		--trace_quadrangles(obj.surfaces[i].quadrangles)
	end
	
	trace_out("obj info end"  .. "\n")
end

function trace_axis(v)
	trace_out("axis info  = \n")
	trace_pt(v.base)
	trace_pt(v.x)
	trace_pt(v.y)
	trace_pt(v.z)
	
end



function print_pt(v)
	print("x = " .. v.x  .." ,y = " .. v.y .. " ,z = "  .. v.z  .. "\n")
end

function warning(info)
	if trace_out then
		trace_out(info .. "\n")
	else
		print(info);
	end
end


