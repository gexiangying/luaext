
local gpt_ = require "g_pt"

require "ifc"
setfenv(1,ifc)

Kind_Beam = "Kind_Beam";
Kind_Slab = "Kind_Slab";
Kind_Slab = "Kind_Rect_Slab";
Cur_Deal_Kind = Kind_Beam;
g_section = "";

--get_placement start--------------------------------------
local function create_local_placement(col_info,db)
	local key	
	--IFCLOCALPLACEMENT  这些类可以先查找是否相等的，有相等的可以直接拿过来使用其key值
	--IFCAXIS2PLACEMENT3D
	return key
end
local function set_local_placement(col,col_info,db)	
	local key = create_local_placement(col_info,db)
	if key then
		self[6] = key
	end
end
--get_placement end--------------------------------------
local function create_prop_single_val(name,val,list)
	local prop_single_val = ifcnew(ifc.IFCPROPERTYSINGLEVALUE);
	--name = string.gsub(name,"\\","\\\\");
	--val = string.gsub(val,"\\","\\\\");	
	prop_single_val:set(name,"$",val,"$");
	table.insert(list,prop_single_val);	
end
local function create_property_set(list,info)
	local property_set = ifcnew(ifc.IFCPROPERTYSET);
	property_set:set(list,info)
	return property_set
	
end
local function create_rel_define(ent,name,FUN)
	local rel_define = ifcnew(ifc.IFCRELDEFINESBYPROPERTIES);
	local list = {};	
	FUN(list)	
	
	--name = string.gsub(name,"\\","\\\\");
	
	local info1 = {root_name = name}
	local prop_set = create_property_set(list,info1);	
	local info = {root_name = "$"}
	rel_define:set(ent,prop_set,info);	

end
local function create_prop_single_vals_matfinish(list)	
	create_prop_single_val("'\\X\\BD\\X\\C7\\X\\B6\\X\\C8'","IFCPLANEANGLEMEASURE(0.)",list);
	create_prop_single_val("'\\X\\B5\\X\\A5\\X\\CF\\X\\DF\\X\\CA\\X\\BE\\X\\D2\\X\\E2\\X\\B7\\X\\FB\\X\\BA\\X\\C5\\X\\CE\\X\\BB\\X\\D6\\X\\C3'","IFCINTEGER(0)",list);
	create_prop_single_val("'\\X\\BC\\X\\F4\\X\\C7\\X\\D0\\X\\B3\\X\\A4\\X\\B6\\X\\C8'","IFCLENGTHMEASURE(1800.000000000001)",list);
	create_prop_single_val("'\\X\\BD\\X\\E1\\X\\B9\\X\\B9\\X\\D3\\X\\C3\\X\\CD\\X\\BE'","IFCINTEGER(6)",list);
	create_prop_single_val("'\\X\\C6\\X\\F4\\X\\D3\\X\\C3\\X\\B7\\X\\D6\\X\\CE\\X\\F6\\X\\C4\\X\\A3\\X\\D0\\X\\CD'","IFCBOOLEAN(.T.)",list);

end
--1
local function create_materials_finishes(ent)
	create_rel_define(ent,"'PSet_Revit_\\X\\BD\\X\\E1\\X\\B9\\X\\B9'",create_prop_single_vals_matfinish);	
end



local function create_prop_single_vals_constraints(list)
	create_prop_single_val("'\\X\\C6\\X\\F0\\X\\B5\\X\\E3\\X\\D1\\X\\D3\\X\\C9\\X\\EC'","IFCLENGTHMEASURE(-12.5)",list);
	create_prop_single_val("'\\X\\D6\\X\\D5\\X\\B5\\X\\E3\\X\\D1\\X\\D3\\X\\C9\\X\\EC'","IFCLENGTHMEASURE(-12.5)",list);

end
--2
local function create_constraints(ent)
	create_rel_define(ent,"'PSet_Revit_\\X\\B9\\X\\B9\\X\\D4\\X\\EC'",create_prop_single_vals_constraints);	
end

local function create_prop_single_vals_structural(list)
	create_prop_single_val("'\\X\\C6\\X\\F0\\X\\B5\\X\\E3\\X\\D1\\X\\D3\\X\\C9\\X\\EC\\X\\BC\\X\\C6\\X\\CB\\X\\E3'","IFCLENGTHMEASURE(3000.)",list);
	create_prop_single_val("'\\X\\C6\\X\\F0\\X\\B5\\X\\E3\\X\\D1\\X\\D3\\X\\C9\\X\\EC\\X\\BC\\X\\C6\\X\\CB\\X\\E3'","IFCLENGTHMEASURE(3000.)",list);
end
--3
local function create_structural(ent)
	create_rel_define(ent,"'PSet_Revit_\\X\\C6\\X\\E4\\X\\CB\\X\\FB'",create_prop_single_vals_structural);	
end

local function create_prop_single_vals_dims(list)
	create_prop_single_val("'\\X\\B2\\X\\CE\\X\\D5\\X\\D5\\X\\B1\\X\\EA\\X\\B8\\X\\DF'","IFCLABEL('\\X\\B1\\X\\EA\\X\\B8\\X\\DF 2')",list);
	create_prop_single_val("'\\X\\B9\\X\\A4\\X\\D7\\X\\F7\\X\\C6\\X\\BD\\X\\C3\\X\\E6'","IFCLABEL('\\X\\B1\\X\\EA\\X\\B8\\X\\DF : \\X\\B1\\X\\EA\\X\\B8\\X\\DF 2')",list);
	create_prop_single_val("'\\X\\C6\\X\\F0\\X\\B5\\X\\E3\\X\\B1\\X\\EA\\X\\B8\\X\\DF\\X\\C6\\X\\AB\\X\\D2\\X\\C6'","IFCLENGTHMEASURE(0.)",list);
	create_prop_single_val("'\\X\\D6\\X\\D5\\X\\B5\\X\\E3\\X\\B1\\X\\EA\\X\\B8\\X\\DF\\X\\C6\\X\\AB\\X\\D2\\X\\C6'","IFCLENGTHMEASURE(0.)",list);
	create_prop_single_val("'Z \\X\\B7\\X\\BD\\X\\CF\\X\\F2\\X\\B6\\X\\D4\\X\\D5\\X\\FD'","IFCINTEGER(0)",list);
	create_prop_single_val("'Z \\X\\B7\\X\\BD\\X\\CF\\X\\F2\\X\\C6\\X\\AB\\X\\D2\\X\\C6\\X\\D6\\X\\B5'","IFCLENGTHMEASURE(0.)",list);
	create_prop_single_val("'\\X\\B2\\X\\E0\\X\\CF\\X\\F2\\X\\B6\\X\\D4\\X\\D5\\X\\FD'","IFCINTEGER(0)",list);
	create_prop_single_val("'\\X\\B7\\X\\BD\\X\\CF\\X\\F2'",",IFCINTEGER(0)",list);
	create_prop_single_val("'\\X\\BA\\X\\E1\\X\\BD\\X\\D8\\X\\C3\\X\\E6\\X\\D0\\X\\FD\\X\\D7\\X\\AA'","IFCPLANEANGLEMEASURE(0.)",list);
end
--4
local function create_dimensions(ent)
	create_rel_define(ent,"'PSet_Revit_\\X\\CF\\X\\DE\\X\\D6\\X\\C6\\X\\CC\\X\\F5\\X\\BC\\X\\FE'",create_prop_single_vals_dims);		
end
local function create_prop_single_vals_type_dims(list)
	create_prop_single_val("'b'","IFCLENGTHMEASURE(165.)",list);
	create_prop_single_val("'h'","IFCVOLUMEMEASURE(303.4)",list);
	create_prop_single_val("'r'","IFCVOLUMEMEASURE(8.9)",list);
	create_prop_single_val("'s'","IFCVOLUMEMEASURE(6.)",list);
	create_prop_single_val("'t'","IFCVOLUMEMEASURE(10.5)",list);
end

--5
local function create_type_dimensions(ent)
	create_rel_define(ent,"'PSet_Revit_Type_\\X\\B3\\X\\DF\\X\\B4\\X\\E7\\X\\B1\\X\\EA\\X\\D7\\X\\A2'",create_prop_single_vals_type_dims);	
end

local function create_prop_single_vals_type_identity_data(list)
	create_prop_single_val("'\\X\\B2\\X\\BF\\X\\BC\\X\\FE\\X\\CB\\X\\B5\\X\\C3\\X\\F7'","IFCLABEL('')",list);
	create_prop_single_val("'\\X\\B2\\X\\BF\\X\\BC\\X\\FE\\X\\B4\\X\\FA\\X\\C2\\X\\EB'","IFCLABEL('')",list);
	create_prop_single_val("'OmniClass \\X\\B1\\X\\E0\\X\\BA\\X\\C5'","IFCLABEL('')",list);
	create_prop_single_val("'OmniClass \\X\\B1\\X\\EA\\X\\CC\\X\\E2'","IFCLABEL('')",list);
end
--#155=IFCPROPERTYSINGLEVALUE('\X\B2\X\BF\X\BC\X\FE\X\CB\X\B5\X\C3\X\F7',$,IFCLABEL(''),$);
--#156=IFCPROPERTYSINGLEVALUE('\X\B2\X\BF\X\BC\X\FE\X\B4\X\FA\X\C2\X\EB',$,IFCLABEL(''),$);
--#157=IFCPROPERTYSINGLEVALUE('OmniClass \X\B1\X\E0\X\BA\X\C5',$,IFCLABEL(''),$);
--#158=IFCPROPERTYSINGLEVALUE('OmniClass \X\B1\X\EA\X\CC\X\E2',$,IFCLABEL(''),$);
--6
local function create_type_identity_data(ent)
	create_rel_define(ent,"'PSet_Revit_Type_\\X\\B1\\X\\EA\\X\\CA\\X\\B6\\X\\CA\\X\\FD\\X\\BE\\X\\DD'",create_prop_single_vals_type_identity_data);		
end

local function create_trimmed_curve(ent)
--#144=IFCTRIMMEDCURVE(#171,(IFCPARAMETERVALUE(90)),(IFCPARAMETERVALUE(180)),.T.,.PARAMETER.);
	
end
local function create_contained_inspatial_structure(ent)
	local rel_contained_inspatial = ifcnew(ifc.IFCRELCONTAINEDINSPATIALSTRUCTURE);
	local info = {root_name = "$"}
	rel_contained_inspatial:set(ent,info);	


end
--[[local function create_project()
	local project = ifcnew(ifc.IFCPROJECT);
	local info = {root_name = "'Project Number'"}
	project:set(info);	
	
end--]]



local function create_reldefine_by_property(ent)
--[[	create_materials_finishes(ent);
	create_constraints(ent);
	create_structural(ent);
	create_dimensions(ent);
	create_type_dimensions(ent);
	create_type_identity_data(ent);
	
	create_trimmed_curve(ent);
--]]	
	create_contained_inspatial_structure(ent);
	
end
local function create_contained_inspatial_struct(ents)
	--aljsdf;lasdjf;lasdjfasldkjf
	local contained_db = get_ent_by_name("IFCRELCONTAINEDINSPATIALSTRUCTURE");
	if(contained_db)then
		return contained_db;
	else	
		local contained = ifcnew(ifc.IFCRELCONTAINEDINSPATIALSTRUCTURE);
		local info = {root_name = "$"}	;	
		contained:set(ents,info);	
	end
	
end
function create_column(col_info,db)	
	local key  = get_key()
	local col = ifc.new(ifc.IFCCOLUMN)
	
	local parent = getmetatable(col)
	col:set_key(key)
	
	col:set_root(col_info,db)
	col:set_object_type(col_info)
	
	
	

	col:set_gaxis_by_x{pt1 = col_info.start_pt,pt2 = col_info.end_pt};
	
	col:set_product_shape(col_info,db)	
	col:set_tag(col_info)	
	
	push_ifc_data(col,db);	
	
	--create_reldefine_by_property(col);
	--create_project();
	create_contained_inspatial_struct(col);
	return key	
end


function create_beam(info,db)
	local beam = ifcnew(ifc.IFCBEAM)
	beam:set_root(info,db)
	beam:set_object_type(info)
	beam:set_gaxis_by_x{pt1 = info.start_pt,pt2 = info.end_pt};
	beam:set_product_shape(info,db)	;
	beam:set_tag(info);	
	
	beam.section = info.section;
	g_section = info.section;
	
	beam.material = info.material;
	

	return beam.key	
end

function create_member_by_surfaces(info)
	local beam = ifcnew(ifc.IFCBEAM);
	beam:set_root(info)
	beam:set_object_type(info)
	beam:set_gaxis_by_x{pt1 = info.start_pt,pt2 = info.end_pt};
	beam:set_product_shape_surfaces(info)	
	beam:set_tag(info)	

	create_project();
	create_rel_aggregates();	
	create_contained_inspatial_struct(beam);

end

function create_assist_info(db)
	create_project();
	create_rel_aggregates();	
	
	local members = {}
	get_members(db,members);
	create_contained_inspatial_struct(members);
		
			
	
end
function create_slab(info)
	Cur_Deal_Kind = Kind_Slab;
	local slab = ifcnew(ifc.IFCSLAB);
	slab:set_root(info,db);
	slab:set_object_type(info);
	slab:set_gaxis_by_x{pt1 = info.start_pt,pt2 = info.end_pt};
	slab:set_product_shape_slab(info)	;
	slab:set_tag(info);	
	slab:set_predefined_type();	
	g_section = info.section;
end
--此info中必须含有info｛pts={ {x=,y=,z=},{x=,y=,z=}}｝
function create_slab_by_pts(info,axis)	
	Cur_Deal_Kind = Kind_Slab;
	local slab = ifcnew(ifc.IFCSLAB);
	slab:set_root(info,db);
	slab:set_object_type(info);
	--需要计算反推变换矩阵
	slab:set_gaxis(axis);
	slab:set_product_shape_common(info)	;
	slab:set_tag(info);	
	slab:set_predefined_type();	

end



