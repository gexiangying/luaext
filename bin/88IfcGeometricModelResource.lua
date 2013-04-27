--	8.	IFC Resource Layer	--	8.8 IfcGeometricModelResource
setfenv(1,ifc)

local obj_tool_ = require "obj_tool"
local g_pt_ = require("g_pt")

--	8.8.2	Type

-- 	8.8.3 Entities
--R8.8.3.12
IFCEXTRUDEDAREASOLID = {param = 2, name = "IFCEXTRUDEDAREASOLID"} --IfcExtrudedAreaSolid = {}
--[[ENTITY IfcExtrudedAreaSolid  
 SUPERTYPE OF(IfcExtrudedAreaSolidTapered)  
 SUBTYPE OF IfcSweptAreaSolid;  
	ExtrudedDirection :  IfcDirection; 
	Depth :  IfcPositiveLengthMeasure; 
 WHERE  
	ValidExtrusionDirection :  IfcDotProduct(IfcRepresentationItem() || IfcGeometricRepresentationItem() || IfcDirection([0.0,0.0,1.0]), SELF.ExtrudedDirection) <> 0.0 --]]  


--IFCARBITRARYCLOSEDPROFILEDEF
function IFCEXTRUDEDAREASOLID:create_arbitrary_closed_profile_surfaces(surfs)
	local ents = {}
	self[1]:get_section(ents)
	local position_axis = self[2]:get_gaxis()
	local direct = self[3]:get_value()
	local depth = self[4]
		
	--trace_out("ents'num = " .. #ents .. "\n")
	for k in pairs(ents) do
		local s = ents[k].start_pt
		local e = ents[k].end_pt
		local new_s = g_pt_.pt_polar_norm(s,depth,direct)	
		local new_e = g_pt_.pt_polar_norm(e,depth,direct)
		
		
		s = g_pt_.l2g(s,position_axis)
		e = g_pt_.l2g(e,position_axis)
		new_s = g_pt_.l2g(new_s,position_axis)
		new_e = g_pt_.l2g(new_e,position_axis)
		
	
		local surf = {}
		surf.lines  = {}
		obj_tool_.add_point(s,surf)
		obj_tool_.add_point(e,surf)
		obj_tool_.add_point(new_e,surf)
		obj_tool_.add_point(new_s,surf)
		
		local cur_pos = #surf.points
		table.insert(surf.lines,{cur_pos-3,cur_pos-2})	
		table.insert(surf.lines,{cur_pos-2,cur_pos-1})	
		table.insert(surf.lines,{cur_pos-1,cur_pos})	
		table.insert(surf.lines,{cur_pos,cur_pos-3})	
		
		--table.insert(surf.quadrangles,{cur_pos-3,cur_pos-2,cur_pos-1,cur_pos})	
		
		table.insert(surfs,surf)
		
	end	
end
function IFCEXTRUDEDAREASOLID:create_surfaces(surfs)
	if (Cur_Deal_Kind == "Kind_Rect_Slab")then--判断是矩形板
		self:create_arbitrary_closed_profile_surfaces(surfs);	
	elseif (Cur_Deal_Kind == "Kind_Slab")then--判断是拉伸板
		self:create_arbitrary_closed_profile_surfaces(surfs);
	else	
		self:create_arbitrary_closed_profile_surfaces(surfs);
	end

end
function IFCEXTRUDEDAREASOLID:set_key(key)
	self.key = key;
	self.new_key = key;
	self.class_name = "IFCEXTRUDEDAREASOLID";
	return self;
end

function IFCEXTRUDEDAREASOLID:create_direct(info,db)
	local key  = get_key();
	local direct = new(IFCDIRECTION);
	direct:set_key(key);

	direct:set(0,0,1,db);
	
	push_ifc_data(direct,db);
	return direct;
end
function IFCEXTRUDEDAREASOLID:get_depth(info,db)
	local len = 1;
	if(info.start_pt.y == "Yes")then
		len = 1;
	else
		--trace_out("get_depth start\n");
		len = g_pt_.pt_len(g_pt_.pt_minus(info.start_pt,info.end_pt));
		--trace_out("get_depth end\n");
	end
	return tostring(len);
end

function IFCEXTRUDEDAREASOLID:set(info,db)
	
	self:create_swept_area_solid (info,db)
	
	local direct_key = self:create_direct(info,db);
	local depth = self:get_depth(info,db);
	
	self[3] = direct_key
	self[4] = depth
end


function IFCEXTRUDEDAREASOLID:set_by_kind(info,kind_profile_def)
	self:create_swept_area_solid_by_kind(info,kind_profile_def)
	local direct_key = self:create_direct(info,get_db());
	local depth = self:get_depth(info,get_db());
	self[3] = direct_key
	self[4] = depth
end


function IFCEXTRUDEDAREASOLID:set_common(info)
	self:create_swept_area_solid_common(info)
	local direct_key = self:create_direct(info,get_db());
	local depth = self:get_depth(info,get_db());
	self[3] = direct_key
	self[4] = depth
end



--R8.8.3.14
IFCFACEBASEDSURFACEMODEL = {param = 1, name = "IFCFACEBASEDSURFACEMODEL"} --IfcFaceBasedSurfaceModel = {}
--[[ENTITY IfcFaceBasedSurfaceModel  
 SUBTYPE OF IfcGeometricRepresentationItem;  
 FbsmFaces :  SET [1:?] OF IfcConnectedFaceSet; 
 
 DERIVE  
 Dim :  IfcDimensionCount := 3; 
 --]]  
function IFCFACEBASEDSURFACEMODEL:create_connected_face_set(info)
	local connect_set = ifcnew(IFCCONNECTEDFACESET);	
	connect_set:set(info)
	return connect_set
end
function IFCFACEBASEDSURFACEMODEL:set(info)
	self[1] = { self:create_connected_face_set(info)}
end
--R8.8.3.30
IFCSOLIDMODEL = {param = 0, name = "IFCSOLIDMODEL"} --IfcSolidModel = {}
--[[ENTITY IfcSolidModel  
 ABSTRACT SUPERTYPE OF(ONEOF(IfcCsgSolid, IfcManifoldSolidBrep, IfcSweptAreaSolid, IfcSweptDiskSolid))  
 SUBTYPE OF IfcGeometricRepresentationItem;  
 DERIVE  
	Dim :  IfcDimensionCount := 3; --]] 


--R8.8.3.33
IFCSWEPTAREASOLID = {param = 2, name = "IFCSWEPTAREASOLID"}  --IfcSweptAreaSolid = {}
--[[ENTITY IfcSweptAreaSolid  
 ABSTRACT SUPERTYPE OF(ONEOF(IfcExtrudedAreaSolid, IfcFixedReferenceSweptAreaSolid, IfcRevolvedAreaSolid, IfcSurfaceCurveSweptAreaSolid))  
 SUBTYPE OF IfcSolidModel;  
	SweptArea :  IfcProfileDef; 
	Position :  IfcAxis2Placement3D; 
WHERE  
	WR22 :  SweptArea.ProfileType = IfcProfileTypeEnum.Area --]]

--IFC arbitrary closed profile def
function IFCSWEPTAREASOLID:create_swept_area(info,db)
	local key  = get_key();
	local arbitrary_profile = new(IFCARBITRARYCLOSEDPROFILEDEF);
	arbitrary_profile:set_key(key);
	arbitrary_profile:set(info,db);
	
	push_ifc_data(arbitrary_profile,db);

	return arbitrary_profile
end
function IFCSWEPTAREASOLID:create_position(info,db)
	local axis2_place3d = ifcnew(IFCAXIS2PLACEMENT3D);
	local gaxis = new(g_pt_.g_axis,{
		base = new(g_pt_.Point,{x=0,y=0,z=0});
		x = new(g_pt_.Point,{x=0,y=1,z=0});
		y = new(g_pt_.Point,{x=0,y=0,z=1});
		z = new(g_pt_.Point,{x=1,y=0,z=0});
	});
	axis2_place3d:set_gaxis(gaxis);
	return axis2_place3d;
end
function IFCSWEPTAREASOLID:create_swept_area_solid(info,db)
	local swept_area_key = self:create_swept_area(info,db);
	local position_key = self:create_position(info,db);
	
	self[1] = swept_area_key
	self[2] = position_key
	
end
function IFCSWEPTAREASOLID:create_rectangle_profile_def(info)
	local rect_profile = ifcnew(IFCRECTANGLEPROFILEDEF);
	rect_profile:set(info.center,info.width,info.height);
	local position = self:create_position(info,db); --可能与闭合体的方向求解方法不一样，注意切换
	return rect_profile,position;
end
function IFCSWEPTAREASOLID:create_swept_area_solid_by_kind(info,kind_profile_def)
	local pro_def;
	local position;
	if (kind_profile_def == Kind_Rectangle_Profile_Def) then
		pro_def,position = self:create_rectangle_profile_def(info);
	elseif (kind_profile_def == Kind_Arbitary_Closed_Profilee_Def)	then	
		pro_def = self:create_swept_area(info,db);
		position = self:create_position(info,db);
	end
	
	self[1] = pro_def
	self[2] = position
	
end
---根据实际的需要生成各种类型的体---------------------------------------------------------------------------
function IFCSWEPTAREASOLID:cretae_slab_profile(info)
	local arbitrary_profile = ifcnew(IFCARBITRARYCLOSEDPROFILEDEF);
	arbitrary_profile:set_common(info);
	return arbitrary_profile	
end
function IFCSWEPTAREASOLID:create_position_common(info,db)
	local axis2_place3d = ifcnew(IFCAXIS2PLACEMENT3D);
	local gaxis = new(g_pt_.g_axis,{
		base = new(g_pt_.Point,{x=0,y=0,z=0});
		x = new(g_pt_.Point,{x=1,y=0,z=0});
		y = new(g_pt_.Point,{x=0,y=1,z=0});
		z = new(g_pt_.Point,{x=0,y=0,z=1});
	});	
	axis2_place3d:set_gaxis(gaxis);
	return axis2_place3d;
end
function IFCSWEPTAREASOLID:create_swept_area_solid_common(info)
	local pro_def;	
	if(Cur_Deal_Kind == Kind_Slab)then
		pro_def = self:cretae_slab_profile(info);	
	end
	local position = self:create_position_common(info);
	
	
	self[1] = pro_def
	self[2] = position
	
end

setparent(IFCSWEPTAREASOLID, IFCEXTRUDEDAREASOLID) 				--R8.8.3.12
--setparent(IFCGEOMETRICREPRESENTATIONITEM, IFCSOLIDMODEL) 		--R8.8.3.30
setparent(IFCSOLIDMODEL, IFCSWEPTAREASOLID) 					--R8.8.3.33
