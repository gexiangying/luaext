--	5. IFC Core Layer	--	5.1 IfcKernel
--module (...,package.seeall)
setfenv(1,ifc)
require "IfcDatabase"

local solid_ = require "steel_solid"
local tools_ = require "steel_tools"
local gpt_ = require "g_pt"
local obj_tool_ = require "obj_tool"
local ifc_exportifc_dlg = require "iup_exportifc_dlg"

--	5.1.2 Type
--[[R5.1.2.1c
--IfcComplexPropertyTemplateTypeEnum = ENUMERATION OF {P_COMPLEX, Q_COMPLEX} 
--R5.1.2.2c
--IfcObjectTypeEnum = ENUMERATION OF {PRODUCT, PROCESS, CONTROL, RESOURCE, ACTOR, GROUP, --PROJECT, NOTDEFINED}
--R5.1.2.3c
IfcPropertySetTemplateTypeEnum = ENUMERATION OF {PSET_TYPEDRIVENONLY, PSET_TYPEDRIVENOVERRIDE, PSET_OCCURRENCEDRIVEN, PSET_PERFORMANCEDRIVEN, QTO_TYPEDRIVENONLY, QTO_TYPEDRIVENOVERRIDE, QTO_OCCURRENCEDRIVEN, NOTDEFINED}
--R5.1.2.4c
IfcSimplePropertyTemplateTypeEnum = ENUMERATION OF {P_SINGLEVALUE, P_ENUMERATEDVALUE, P_BOUNDEDVALUE, P_LISTVALUE, P_TABLEVALUE, P_REFERENCEVALUE, Q_LENGTH, Q_AREA, Q_VOLUME, Q_COUNT, Q_WEIGHT, Q_TIME}
--R5.1.2.5c
--IfcDefinitionSelect = SELECT {IfcObjectDefinition, IfcPropertyDefinition}
--R5.1.2.6c
--IfcProcessSelect = SELECT (IfcProcess, IfcTypeProcess)
--R5.1.2.7c
--IfcProductSelect = SELECT (IfcProduct, IfcTypeProduct)
--R5.1.2.8c
--IfcResourceSelect = SELECT (IfcResource, IfcTypeResource)--]]
--5.1.3 Entities
--R5.1.3.1
IFCACTOR = {param = 1, name = "IFCACTOR"}  --IfcActor
--[[ENTITY IfcActor  
		SUPERTYPE OF(IfcOccupant)  
		SUBTYPE OF IfcObject;  
			TheActor :  IfcActorSelect; 
		INVERSE  
			IsActingUpon :  SET OF IfcRelAssignsToActor FOR RelatingActor; 
--]]
--R5.1.3.2
IFCCOMPLEXPROPERTYTEMPLATE = {param = 3, name = "IFCCOMPLEXPROPERTYTEMPLATE"} --IfcComplexPropertyTemplate = {}
--[[ENTITY IfcComplexPropertyTemplate  
 SUBTYPE OF IfcPropertyTemplate;  
	UsageName :  OPTIONAL IfcLabel; 
	TemplateType :  OPTIONAL IfcComplexPropertyTemplateTypeEnum; 
	HasPropertyTemplates :  OPTIONAL SET [1:?] OF IfcPropertyTemplate; 
 WHERE  
	UniquePropertyNames :  IfcUniquePropertyTemplateNames(HasPropertyTemplates) 
	NoSelfReference :  SIZEOF(QUERY(temp <* HasPropertyTemplates | SELF :=: temp)) = 0 
END_ENTITY;--]]  


--R5.1.3.3
IFCCONTEXT = {param = 5, name = "IFCCONTEXT"}	--IfcContext
--[[ENTITY IfcContext  
		ABSTRACT SUPERTYPE OF(ONEOF(IfcProject, IfcProjectLibrary))  
		SUBTYPE OF IfcObjectDefinition;  
			ObjectType :  OPTIONAL IfcLabel; 
			LongName :  OPTIONAL IfcLabel; 
			Phase :  OPTIONAL IfcLabel; 
			RepresentationContexts :  OPTIONAL SET [1:?] OF IfcRepresentationContext; 
			UnitsInContext :  OPTIONAL IfcUnitAssignment; 
		INVERSE  
			IsDefinedBy :  SET [0:?] OF IfcRelDefinesByProperties FOR RelatedObjects; 
			Declares :  SET OF IfcRelDeclares FOR RelatingContext; --]] 
function IFCCONTEXT:create_geometric_represent(geometric_represents)
	local geo = create_geo_rep_context("'Model'");
	if(geo)then
		table.insert(geometric_represents,geo)		
	else
		local geometric_represent = ifcnew(ifc.IFCGEOMETRICREPRESENTATIONCONTEXT);
		local info = {}
		geometric_represent:set("'Model'",get_db());	
		table.insert(geometric_represents,geometric_represent)
			
	end
	
	
	local geo2 = create_geo_rep_context("'Annotation'");
	if(geo2)then
		table.insert(geometric_represents,geo2)		
	else
		local geo2 = ifcnew(ifc.IFCGEOMETRICREPRESENTATIONCONTEXT);
		local info = {}
		geo2:set("'Annotation'",get_db());	
		table.insert(geometric_represents,geo2)
	end
end
function IFCCONTEXT:create_unit_assignment()
	local unit_assignment = ifcnew(ifc.IFCUNITASSIGNMENT);
	unit_assignment:set()

	return unit_assignment
end
function IFCCONTEXT:set(info)
	self:set_root(info)
	self[5] = "$"
	self[6] = "''"
	self[7] = "'Project Status'"
	local geometric_represents = {}
	self:create_geometric_represent(geometric_represents)
	self[8] = geometric_represents
	self[9] = self:create_unit_assignment()
end
--[[
#23=IFCUNITASSIGNMENT((#15,#16,#17,#21,#22));
--]]
--R5.1.3.6
IFCOBJECT = {param = 1, name = "IFCOBJECT"}  --IfcObject = {ObjectType = IfcLabel}
--[[	ENTITY IfcObject  
		ABSTRACT SUPERTYPE OF(ONEOF(IfcActor, IfcControl, IfcGroup, IfcProcess, IfcProduct, IfcResource))  
		SUBTYPE OF IfcObjectDefinition;  
			ObjectType :  OPTIONAL IfcLabel; 
		INVERSE  
			IsDeclaredBy :  SET [0:1] OF IfcRelDefinesByObject FOR RelatedObjects; 
			Declares :  SET OF IfcRelDefinesByObject FOR RelatingObject; 
			IsTypedBy :  SET [0:1] OF IfcRelDefinesByType FOR RelatedObjects; 
			IsDefinedBy :  SET OF IfcRelDefinesByProperties FOR RelatedObjects; --]]

--R5.1.3.7
IFCOBJECTDEFINITION = {param = 0, name = "IFCOBJECTDEFINITION"}  --IfcObjectDefinition = {}
--[[	ENTITY IfcObjectDefinition  
		ABSTRACT SUPERTYPE OF(ONEOF(IfcContext, IfcObject, IfcTypeObject))  
		SUBTYPE OF IfcRoot;  
		INVERSE  
			HasAssignments :  SET OF IfcRelAssigns FOR RelatedObjects; 
			Nests :  SET [0:1] OF IfcRelNests FOR RelatedObjects; 
			IsNestedBy :  SET OF IfcRelNests FOR RelatingObject; 
			HasContext :  SET [0:1] OF IfcRelDeclares FOR RelatedDefinitions; 
			IsDecomposedBy :  SET OF IfcRelAggregates FOR RelatingObject; 
			Decomposes :  SET [0:1] OF IfcRelAggregates FOR RelatedObjects; 
			HasAssociations :  SET OF IfcRelAssociates FOR RelatedObjects; --]]  

--R5.1.3.10
IFCPRODUCT = {param = 2, name = "IFCPRODUCT"} --IfcProduct = {}
--[[	ENTITY IfcProduct  
		ABSTRACT SUPERTYPE OF(ONEOF(IfcAnnotation, IfcElement, IfcGrid, IfcPort, IfcProxy, IfcSpatialElement, IfcStructuralActivity, IfcStructuralItem))  
		SUBTYPE OF IfcObject;  
			ObjectPlacement :  OPTIONAL IfcObjectPlacement; 
			Representation :  OPTIONAL IfcProductRepresentation; 
		INVERSE  
			ReferencedBy :  SET OF IfcRelAssignsToProduct FOR RelatingProduct; 
 
		WHERE  
			WR1 :  (EXISTS(Representation) AND EXISTS(ObjectPlacement)) OR (EXISTS(Representation) AND (NOT( IFCREPRESENTATIONRESOURCE.IFCPRODUCTDEFINITIONSHAPE IN TYPEOF(Representation)))) OR (NOT(EXISTS(Representation)))  
--]] 
Kind_Rectangle_Profile_Def = "Rectangle_Profile_Def"; --IFCRECTANGLEPROFILEDEF
Kind_Arbitary_Closed_Profilee_Def = "Arbitary_Closed_Profilee_Def"; --IFCARBITRARYCLOSEDPROFILEDEF

function IFCPRODUCT:get_axis()
	local s = self
	local cur_class = new(IFCPRODUCT)
	local pos = cur_class:get_parent_pos()
	print("pos = " .. pos)
	--trace_out("$$ Start $$$$$$$$$$$$$$$$$\n");
	local gaxis = self[pos-1]:get_gaxis();
	
	
	--tools_.trace(gaxis, "gaxis");
	--trace_out("$$ End $$$$$$$$$$$$$$$$$\n");
	return gaxis;
--	return self[pos-1]:get_gaxis() --该类位于总数据表中是两个值，第6个变量是localplacement
end



function IFCPRODUCT:get_obj(obj)
	local cur_class = new(IFCPRODUCT)
	local pos = cur_class:get_parent_pos()
	--print("pos = " .. pos)
	self[pos]:get_obj(obj) 	
end
--IfcAxis2Placement3D
function IFCPRODUCT:create_world_coord_sys(col_info,db)
	local key  = get_key()
	local world_coord_sys = new(IFCAXIS2PLACEMENT3D)
	world_coord_sys:set_key(key)
	world_coord_sys:set(col_info,db)
	
	push_ifc_data(world_coord_sys,db);	
	return world_coord_sys
end

--#27=ifc geometric  representation  context ($,'Model',3,1.E-006,#26,$);
function IFCPRODUCT:create_contextofitems(col_info,db)
	--判断有无，再创建
	local geo = create_geo_rep_context("'Model'");
	if(geo)then
		return geo;	
	else
		local geo_rep_context = ifcnew(IFCGEOMETRICREPRESENTATIONCONTEXT);
		geo_rep_context:set("'Model'",db)
		return geo_rep_context
	end
	
	
	
end
function IFCPRODUCT:create_extrudend_area_solid(col_info,db,items_keys)
	local key  = get_key()
	local extrudend_solid = new(IFCEXTRUDEDAREASOLID)
	extrudend_solid:set_key(key)
	
	extrudend_solid:set(col_info,db)	
	
	push_ifc_data(extrudend_solid,db)
	
	items_keys[1] = extrudend_solid
	--return key
end
--#44=IFCSHAPEREPRESENTATION(#27,'Axis','Curve2D',(#43));
function IFCPRODUCT:create_shape_repesent(col_info,db)
	--此处可以生成多种表现方式，当前只生成一种	
	local key  = get_key()
	local shape_repesent = new(IFCSHAPEREPRESENTATION)
	shape_repesent:set_key(key)
	
	local context_key = self:create_contextofitems(col_info,db)--判断有无，再创建
	
	
	
	local identifier = "\'Body\'"
	local type = "'MappedRepresentation'"
	local items_keys = {};
	
	self:create_extrudend_area_solid(col_info,db,items_keys)	
	shape_repesent:set(context_key,identifier,type,items_keys)	
	
	push_ifc_data(shape_repesent,db)
	
	return shape_repesent
end
--#44=IFCSHAPEREPRESENTATION(#27,'Axis','Curve2D',(#43));
function IFCPRODUCT:create_polyline_shape(col_info,db,items_keys)
	local key  = get_key()
	local polyline = new(IFCPOLYLINE)
	polyline:set_key(key)
	
	polyline:set(col_info.start_pt,col_info.end_pt,db)	
	
	push_ifc_data(polyline,db)
	
	items_keys[1] = polyline
end
function IFCPRODUCT:create_axis_repesent(col_info,db)
	local shape_repesent = ifcnew(IFCSHAPEREPRESENTATION)
	local context_key = self:create_contextofitems(col_info,db)--判断有无，再创建
	local identifier = "\'Axis\'"
	local type = "'Curve2D'"
	local items_keys = {};
	self:create_polyline_shape(col_info,db,items_keys)	
	shape_repesent:set(context_key,identifier,type,items_keys)	
	return shape_repesent
end
--#128=IFCPRODUCTDEFINITIONSHAPE($,$,(#127));
function IFCPRODUCT:create_product_shap(col_info,db)
	local key  = get_key()
	local product_shap = new(IFCPRODUCTDEFINITIONSHAPE)
	product_shap:set_key(key)
	
	local dofiles = {}
	
--[[	
	if (ifc_exportifc_dlg.setting_info["renderdraw"] == "ON")then
		--面模式
		local shape_repesent = self:create_shape_repesent(col_info,db);
		dofiles[#dofiles] = shape_repesent;
	end
	if (ifc_exportifc_dlg.setting_info["lineframe"] == "ON")then
		--轴线模式
		local axis_repesent = self:create_axis_repesent(col_info,db);
		dofiles[#dofiles] = axis_repesent;
	end	
	--]]	
	
	local shape_repesent = self:create_shape_repesent(col_info,db);
	dofiles[1] = shape_repesent
	
	local axis_repesent = self:create_axis_repesent(col_info,db);
	dofiles[2] = axis_repesent	
	
	--需要处理只绘制线的方式	
	product_shap:set("\$","\$",dofiles)		
	push_ifc_data(product_shap,db)
	
	return product_shap
end

function IFCPRODUCT:set_product_shape(col_info,db)
	
	local key = self:create_product_shap(col_info,db)
	if key then
		self[7] = key
	end
	
end
----处理板-------------------------
function IFCPRODUCT:create_extrudend_area_solid_slab(info,items_keys,kind_profile_def)
	local extrudend_solid = ifcnew(IFCEXTRUDEDAREASOLID);
	extrudend_solid:set_by_kind(info,kind_profile_def);	
	items_keys[1] = extrudend_solid;
end


function IFCPRODUCT:create_shape_repesentation_slab(identifier,type_kind,info)
	local shape_repesent = ifcnew(IFCSHAPEREPRESENTATION);
	local context_key = self:create_contextofitems(info,db);--判断有无，再创建
	local items_keys = {};
	self:create_extrudend_area_solid_slab(info,items_keys,Kind_Rectangle_Profile_Def);	
	shape_repesent:set(context_key,identifier,type_kind,items_keys);	
	return shape_repesent;
end
function IFCPRODUCT:create_product_shap_slab(info)
	local product_shap = ifcnew(IFCPRODUCTDEFINITIONSHAPE);	
	local dofiles = {};
	local shape_repesent = self:create_shape_repesentation_slab("'Body'","'SweptSolid'",info);
	dofiles[1] = shape_repesent;	
	product_shap:set("$","$",dofiles);	
	return product_shap;
end


function IFCPRODUCT:set_product_shape_slab(info)
	local product_shape = self:create_product_shap_slab(info)
	if product_shape then
		self[7] = product_shape
	end
	
end
----end处理板-------------------------

----利用点来生成板-------------------------
function IFCPRODUCT:create_extrudend_area_solid_common(info,items_keys)
	local extrudend_solid = ifcnew(IFCEXTRUDEDAREASOLID);
	extrudend_solid:set_common(info);	
	items_keys[1] = extrudend_solid;
end
function IFCPRODUCT:create_shape_repesentation_common(identifier,type_kind,info)
	local shape_repesent = ifcnew(IFCSHAPEREPRESENTATION);
	local context_key = self:create_contextofitems(info,db);
	local items_keys = {};
	self:create_extrudend_area_solid_common(info,items_keys);	
	shape_repesent:set(context_key,identifier,type_kind,items_keys);	
	return shape_repesent;
end
function IFCPRODUCT:create_product_shap_common(info)
	local product_shap = ifcnew(IFCPRODUCTDEFINITIONSHAPE);	
	local dofiles = {};
	--加入判断，当前是什么类型就生成什么类型Cur_Deal_Kind
	local shape_repesent = self:create_shape_repesentation_common("'Body'","'SweptSolid'",info);
	dofiles[1] = shape_repesent;	
	product_shap:set("$","$",dofiles);	
	return product_shap;	
end
function IFCPRODUCT:set_product_shape_common(info)
	local product_shape = self:create_product_shap_common(info)
	if product_shape then
		self[7] = product_shape
	end
	
end


----end利用点来生成板-------------------------
function IFCPRODUCT:local_placement(t)
	local pos = new(IFCPRODUCT):get_parent_pos()-1;
	self[pos] = ifcset(self[pos],t,IFCLOCALPLACEMENT);
	return self[pos];
end

function IFCPRODUCT:set_gaxis(t)
	if not t then self:local_placement("$") return end;
	self:local_placement{}:set_gaxis(t);
	--tools_.ocmd(self:local_placement(), "LocalPlacement");
end

--pt1,pt2
function IFCPRODUCT:set_gaxis_by_x(t)
	if not t then self:local_placement("$") return end;
	self:local_placement{}:set_gaxis_by_x(t);
end

----
function IFCPRODUCT:get_start_pt()
	local pos = new(IFCPRODUCT):get_parent_pos()
	print(self[pos])
	if(self[pos])then
		return self[pos]:get_start_pt();
	else
		trace_out("IFCPRODUCT:get_start_pt(pt) error.\n")
		return {x=0,y=0,z=0}
	end	 	
	
end
function IFCPRODUCT:set_start_pt(pt)
	local pos = new(IFCPRODUCT):get_parent_pos()
	if(self[pos])then
		self[pos]:set_start_pt(pt) 	
	else
		self[pos]:set_start_pt({x=0,y=0,z=0}) ;
		trace_out("IFCPRODUCT:set_start_pt(pt) error.\n")
	end	 	
	
end
function IFCPRODUCT:get_end_pt()
	local pos = new(IFCPRODUCT):get_parent_pos()
	if(self[pos])then
		return self[pos]:get_end_pt() 	
	else
		trace_out("IFCPRODUCT:get_end_pt(pt) error.\n")
		return {x=0,y=0,z=0}
	end	 	
	
end
function IFCPRODUCT:set_end_pt(pt)
	local pos = new(IFCPRODUCT):get_parent_pos()
	if(self[pos])then
		self[pos]:set_end_pt(pt) 	
	else
		trace_out("IFCPRODUCT:set_end_pt(pt) error.\n")
		self[pos]:set_end_pt({x=0,y=0,z=0}) 
	end	 	
	
end

function IFCPRODUCT:get_section()
	return self["section"]	
end
function IFCPRODUCT:set_section(str)
	self["section"] = str
end

function IFCPRODUCT:get_material()
	return self.material	
end
function IFCPRODUCT:set_material(str)
	self.material = str
end

function IFCPRODUCT:get_color()
	return self.color
end
function IFCPRODUCT:set_color(cr)
	self.color = cr
end
--------
function IFCPRODUCT:pop_property_dlg()
	require("steel_property_dlg").pop();
end

function IFCPRODUCT:get_object_t()
	return solid_.member{
		mode = solid_.Render;
		section = self:get_section() or "H-50*20*5*3";
		color = self:get_color() or {r=1,g=0,b=0};
		pt1 = self:get_start_pt() or {0,0,0};
		pt2 = self:get_end_pt() or {0,0,0};
	};
end

function IFCPRODUCT:get_object_z()
	local axis = self:get_axis();
	local obj  = obj_tool_.Object:new()
	g_section = self.section;
	self:get_obj(obj)
	require("steel_object").coord_l2g(obj,axis);
	return obj;
end

function IFCPRODUCT:get_object()
	return self:get_object_t();
end

function IFCPRODUCT:show(light)
	local obj = light and self:get_object() or require("steel_object").color_scale(self:get_object(),0.5);
	-- local obj = light and self:get_object() or require("steel_object").color_scale(self:get_object(),0.5);
	tools_.otrace(self.object_placement, "self.object_placement");
	require("steel_object").coord_l2g(obj,self.object_placement);
	obj.index = self.mgrid;
	require("steel_mgr").show_object(obj);
end

function IFCPRODUCT:offset_object(axis)
	self.object_placement = axis;
end

--使用面的方式来生成构件-----------------------------------------------------
function IFCPRODUCT:create_trimmed_curve(info,items_keys)
	local trim_curve = ifcnew(IFCTRIMMEDCURVE);	
	trim_curve:set(info.center,info.r,info.start_angle,info.end_angle);
	table.insert(items_keys,trim_curve);
end
function IFCPRODUCT:create_axis_repesent_trim_curve(info,db)
	local shape_repesent = ifcnew(IFCSHAPEREPRESENTATION);	

	local context_key = create_contextofitems("'Model'") 
	local identifier = "'Axis'"
	local type_ = "'Curve2D'"
	local items_keys = {};	
	--画轴线方式
	self:create_trimmed_curve(info,items_keys);
		
	shape_repesent:set(context_key,identifier,type_,items_keys);	
	return shape_repesent	
end

function IFCPRODUCT:create_face_based_surface_model(info,items_keys)
	local face_based_sur_model = ifcnew(IFCFACEBASEDSURFACEMODEL);	
	face_based_sur_model:set(info)
	table.insert(items_keys,face_based_sur_model)
end
function IFCPRODUCT:create_shape_repesent_surfaces(info)
	local shape_repesent = ifcnew(IFCSHAPEREPRESENTATION);	

	local context_key = create_contextofitems("'Model'") 
	local identifier = "'Body'"
	local type_ = "'SurfaceModel'"
	local items_keys = {};	
	self:create_face_based_surface_model(info,items_keys);
		
	shape_repesent:set(context_key,identifier,type_,items_keys);	
	return shape_repesent	
end
function IFCPRODUCT:create_product_shap_surfaces(info)
	local product_shap = ifcnew(IFCPRODUCTDEFINITIONSHAPE);
		
	local dofiles = {};
--[[	
	if (ifc_exportifc_dlg.setting_info["renderdraw"] == "ON")then
		--面模式
		local shape_repesent = self:create_shape_repesent_surfaces(info);
		dofiles[#dofiles+1] = shape_repesent;
	end
	if (ifc_exportifc_dlg.setting_info["lineframe"] == "ON")then
		--轴线模式
		local axis_repesent = self:create_axis_repesent_trim_curve(info,db);
		dofiles[#dofiles+1] = axis_repesent;
	end
	
--]]	
	--面模式
	local shape_repesent = self:create_shape_repesent_surfaces(info);
	dofiles[1] = shape_repesent
	--轴线模式
	
	local axis_repesent = self:create_axis_repesent_trim_curve(info,db);
	dofiles[2] = axis_repesent	


	product_shap:set("\$","\$",dofiles)		
	
	return product_shap
end
function IFCPRODUCT:set_product_shape_surfaces(info)
	
	local product = self:create_product_shap_surfaces(info,db)
	if product then
		self[7] = product
	end
	
end
--R5.1.3.11
IFCPROJECT = {param = 0, name = "IFCPROJECT"}  --IfcProject = {}  
--[[	ENTITY IfcProject  
		SUBTYPE OF IfcContext;  
		WHERE  
			HasName :  EXISTS(SELF\IfcRoot.Name) 
			CorrectContext :  NOT(EXISTS(SELF\IfcContext.RepresentationContexts)) OR (SIZEOF(QUERY(Temp <* SELF\IfcContext.RepresentationContexts | IFCREPRESENTATIONRESOURCE.IFCGEOMETRICREPRESENTATIONSUBCONTEXT IN TYPEOF(Temp) )) = 0) 
			NoDecomposition :  SIZEOF(SELF\IfcObjectDefinition.Decomposes) = 0 
			HasOwnerHistory :  EXISTS(SELF\IfcRoot.OwnerHistory) 
--]]

--R5.1.3.12
IFCPROJECTLIBRARY = {param = 0, name = "IFCPROJECTLIBRARY"}  --IfcProjectLibrary = {}  
--[[	ENTITY IfcProjectLibrary  
		SUBTYPE OF IfcContext;  
--]]

--R5.1.3.13 
IFCPROPERTYDEFINITION = {param = 0, name = "IFCPROPERTYDEFINITION"}  --IfcPropertyDefinition = {}  
--[[	ENTITY IfcPropertyDefinition  
		ABSTRACT SUPERTYPE OF(ONEOF(IfcPropertySetDefinition, IfcPropertyTemplateDefinition))  
		SUBTYPE OF IfcRoot;  
		INVERSE  
			HasContext :  SET [0:1] OF IfcRelDeclares FOR RelatedDefinitions; 
			HasAssociations :  SET OF IfcRelAssociates FOR RelatedObjects; --]]

--R5.1.3.14
IFCPROPERTYSET = {param = 1, name = "IFCPROPERTYSET"}  --IfcPropertySet = {} 
--[[	ENTITY IfcPropertySet  
		SUBTYPE OF IfcPropertySetDefinition;  
			HasProperties :  SET [1:?] OF IfcProperty; 
		WHERE  
			ExistsName :  EXISTS(SELF\IfcRoot.Name) 
			UniquePropertyNames :  IfcUniquePropertyName(HasProperties) 	--]]
function IFCPROPERTYSET:set_key(key)
	self.key = key;
	self.new_key = key;
	self.class_name = "IFCPROPERTYSET";
	return self;
end
function IFCPROPERTYSET:set(list,info)
	self:set_root(info)
	self[5] = list
	return self;
end

--R5.1.3.15 
IFCPROPERTYSETDEFINITION = {param = 0, name = "IFCPROPERTYSETDEFINITION"}  --IfcPropertySetDefinition = {} 
--[[	ENTITY IfcPropertySetDefinition  
		ABSTRACT SUPERTYPE OF(ONEOF(IfcPreDefinedPropertySet, IfcPropertySet, IfcQuantitySet))  
		SUBTYPE OF IfcPropertyDefinition;  
		INVERSE  
			DefinesType :  SET OF IfcTypeObject FOR HasPropertySets; 
			IsDefinedBy :  SET OF IfcRelDefinesByTemplate FOR RelatedPropertySets; 
			DefinesOccurrence :  SET [0:1] OF IfcRelDefinesByProperties FOR RelatingPropertyDefinition; 
--]]			 

--R5.1.3.17
IFCPROPERTYTEMPLATE = {param = 0, name = "IFCPROPERTYTEMPLATE"}  --IfcPropertyTemplate = {}
--[[ENTITY IfcPropertyTemplate  
 ABSTRACT SUPERTYPE OF(ONEOF(IfcComplexPropertyTemplate, IfcSimplePropertyTemplate))  
 SUBTYPE OF IfcPropertyTemplateDefinition;  
INVERSE  
	PartOfComplexTemplate :  SET OF IfcComplexPropertyTemplate FOR HasPropertyTemplates; 
	PartOfPsetTemplate :  SET OF IfcPropertySetTemplate FOR HasPropertyTemplates; --]]  

--R5.1.3.18
IFCPROPERTYTEMPLATEDEFINITION = {param = 0, name = "IFCPROPERTYTEMPLATEDEFINITION"} --IfcPropertyTemplateDefinition = {}
--[[ENTITY IfcPropertyTemplateDefinition  
 ABSTRACT SUPERTYPE OF(ONEOF(IfcPropertySetTemplate, IfcPropertyTemplate))  
 SUBTYPE OF IfcPropertyDefinition; --]]  

--R5.1.3.20
IFCQUANTITYSET = {param = 0, name = "IFCQUANTITYSET"} --IfcQuantitySet = {}
--[[ENTITY IfcQuantitySet  
 ABSTRACT SUPERTYPE OF(IfcElementQuantity)  
 SUBTYPE OF IfcPropertySetDefinition; --]]

--R5.1.3.21
IFCRELAGGREGATES = {param = 2, name = "IFCRELAGGREGATES"}  --IfcRelAggregates = {}
--[[ENTITY IfcRelAggregates  
 SUBTYPE OF IfcRelDecomposes;  
	RelatingObject :  IfcObjectDefinition; 
	RelatedObjects :  SET [1:?] OF IfcObjectDefinition; 
 WHERE  
 NoSelfReference:SIZEOF(QUERY(Temp <* RelatedObjects | RelatingObject :=: Temp)) = 0--]] 
function IFCRELAGGREGATES:set(obj_ing,objs_ed)
	local info = {root_name = "$"}
	self:set_root(info)	
	self[5] = obj_ing;
	self[6] = objs_ed;
end
--R5.1.3.30
IFCRELASSOCIATES = {param = 1, name = "IFCRELASSOCIATES"} --IfcRelAssociates = {}
--[[ENTITY IfcRelAssociates  
 ABSTRACT SUPERTYPE OF(ONEOF(IfcRelAssociatesApproval, IfcRelAssociatesClassification, IfcRelAssociatesConstraint, IfcRelAssociatesDocument, IfcRelAssociatesLibrary, IfcRelAssociatesMaterial))  
 SUBTYPE OF IfcRelationship;  
	RelatedObjects :  SET [1:?] OF IfcDefinitionSelect; --]]

--R5.1.3.34
IFCRELATIONSHIP = {param = 0, name = "IFCRELATIONSHIP"}  --IfcRelationship = {}
--[[ENTITY IfcRelationship  
 ABSTRACT SUPERTYPE OF(ONEOF(IfcRelAssigns, IfcRelAssociates, IfcRelConnects, IfcRelDeclares, IfcRelDecomposes, IfcRelDefines))  
 SUBTYPE OF IfcRoot;  --]]

--R5.1.3.35
IFCRELCONNECTS = {param = 0, name = "IFCRELCONNECTS"} --IfcRelConnects = {}
--[[ENTITY IfcRelConnects  
 ABSTRACT SUPERTYPE OF(ONEOF(IfcRelConnectsElements, IfcRelConnectsPorts, IfcRelConnectsPortToElement, IfcRelConnectsStructuralActivity, IfcRelConnectsStructuralMember, IfcRelContainedInSpatialStructure, IfcRelCoversBldgElements, IfcRelCoversSpaces, IfcRelFillsElement, IfcRelFlowControlElements, IfcRelInterferesElements, IfcRelReferencedInSpatialStructure, IfcRelSequence, IfcRelServicesBuildings, IfcRelSpaceBoundary))  
 SUBTYPE OF IfcRelationship;  --]]

--R5.1.3.37
IFCRELDECOMPOSES = {param = 0, name = "IFCRELDECOMPOSES"}  --IfcRelDecomposes = {}
--[[ENTITY IfcRelDecomposes  
 ABSTRACT SUPERTYPE OF(ONEOF(IfcRelAggregates, IfcRelNests, IfcRelProjectsElement, IfcRelVoidsElement))  
 SUBTYPE OF IfcRelationship; --]] 

--R5.1.3.38
IFCRELDEFINES = {param = 0, name = "IFCRELDEFINES"} --IfcRelDefines = {}
--[[ENTITY IfcRelDefines  
 ABSTRACT SUPERTYPE OF(ONEOF(IfcRelDefinesByObject, IfcRelDefinesByProperties, IfcRelDefinesByTemplate, IfcRelDefinesByType))  
 SUBTYPE OF IfcRelationship;  --]]

--R5.1.3.40
IFCRELDEFINESBYPROPERTIES = {param = 2, name = "IFCRELDEFINESBYPROPERTIES"} --IfcRelDefinesByProperties = {}
--[[ENTITY IfcRelDefinesByProperties  
 SUBTYPE OF IfcRelDefines;  
	RelatedObjects :  SET [1:?] OF IfcObjectDefinition; 
	RelatingPropertyDefinition :  IfcPropertySetDefinition; --]]

function IFCRELDEFINESBYPROPERTIES:set_key(key)
	self.key = key;
	self.new_key = key;
	self.class_name = "IFCRELDEFINESBYPROPERTIES";
	return self;
end
function IFCRELDEFINESBYPROPERTIES:set(ent,prop_set,info)
	self:set_root(info)
	self[5] = {ent}
	self[6] = prop_set
	return self;
end


--R5.1.3.42
IFCRELDEFINESBYTYPE = {param = 2, name = "IFCRELDEFINESBYTYPE"} --IfcRelDefinesByType = {}
--[[ENTITY IfcRelDefinesByType  
 SUBTYPE OF IfcRelDefines;  
	RelatedObjects :  SET [1:?] OF IfcObject; 
	RelatingType :  IfcTypeObject; --]]


--R5.1.3.45
IFCROOT = {param = 4, name = "IFCROOT"}  --IfcRoot = {}
--[[ENTITY IfcRoot  
 ABSTRACT SUPERTYPE OF(ONEOF(IfcObjectDefinition, IfcPropertyDefinition, IfcRelationship));  
	GlobalId :  IfcGloballyUniqueId; 
	OwnerHistory :  OPTIONAL IfcOwnerHistory; 
	Name :  OPTIONAL IfcLabel; 
	Description :  OPTIONAL IfcText; 
 UNIQUE  
	UR1 :  GlobalId; 
END_ENTITY;  
--	IfcRoot is the most abstract and root class for all IFC entity definitions that roots in the kernel or in subsequent layers of the IFC object model. It is therefore the common supertype of all IFC entities, beside those defined in an IFC resource schema. All entities that are subtypes of IfcRoot can be used independently, whereas resource schema entities, that are not subtypes of IfcRoot, are not supposed to be independent entities.
--]]
function IFCROOT:get_root_info()
	local info = {}
	info.GlobalId = self[1]
	info.OwnerHistory = self[2]
	info.Name = self[3]
	info.Description = self[4]
	return info
end
function IFCROOT:get_parent_pos(num)
	num = num or 0
	local parent = getmetatable(self)
	if(parent) then 
		num = parent:get_parent_pos(num + parent.param)
	end
	return num	 
end

function IFCROOT:create_owner_story(db)
	local owner = get_ent_by_name("IFCOWNERHISTORY");
	if (owner) then
		return owner	
	else
		local key = get_key();
		local owner_history = new(IFCOWNERHISTORY);
		owner_history:set_key(key);
		owner_history:set(info,db)	
		
		push_ifc_data(owner_history,db)
	--	return key
		return owner_history	
	end
	
end
function IFCROOT:get_owner_story(db)
	return self:create_owner_story(db)
	--local owner = find_db()
	--if(not owner) then
	--	owner = create_owner_story(db)
	--end
	--return owner	
end
function IFCROOT:get_name()	
	local name = "\'H-Wide Flange-Column:H300x150x6.5:H300x150x6.5:132062\'"
	return name
end
function IFCROOT:set_root(info,db)	
	local global_id = create_global_id()
	local owner_story = self:get_owner_story(db)--去取，如果没有需要创建
	local name = info.root_name or self:get_name()
	local description = "\$"	
	self[1] = 	global_id
	self[2] = 	owner_story
	self[3] = 	name
	self[4] = 	description
end
--[[function IFCROOT:get_parent_pos(num,sign)
	num = num or 0
	local parent = getmetatable(self)
	if(parent) then 
		if sign then
			num = num + parent.param
		else
			num = num
			sign = true
		end
		num = parent:get_parent_pos(num,sign)
	end
	return num	 
end

--]]
--R5.1.3.47
IFCTYPEOBJECT = {param = 2, name = "IFCTYPEOBJECT"}  --IfcTypeObject = {}
--[[	ENTITY IfcTypeObject  
		SUPERTYPE OF(ONEOF(IfcTypeProcess, IfcTypeProduct, IfcTypeResource))  
		SUBTYPE OF IfcObjectDefinition;  
			ApplicableOccurrence :  OPTIONAL IfcIdentifier; 
			HasPropertySets :  OPTIONAL SET [1:?] OF IfcPropertySetDefinition; 
		INVERSE  
			Types :  SET [0:1] OF IfcRelDefinesByType FOR RelatingType; 
		WHERE  
			WR1 :  EXISTS(SELF\IfcRoot.Name) 
--]]

setparent(IFCOBJECT, IFCACTOR)									--R5.1.3.01
setparent(IFCPROPERTYTEMPLATE, IFCCOMPLEXPROPERTYTEMPLATE)		--R5.1.3.02
setparent(IFCOBJECTDEFINITION, IFCCONTEXT)						--R5.1.3.03
setparent(IFCOBJECTDEFINITION, IFCOBJECT)						--R5.1.3.06
setparent(IFCROOT, IFCOBJECTDEFINITION)							--R5.1.3.07
setparent(IFCOBJECT, IFCPRODUCT)								--R5.1.3.10
setparent(IFCCONTEXT, IFCPROJECTLIBRARY)						--R5.1.3.12
setparent(IFCROOT, IFCPROPERTYDEFINITION)						--R5.1.3.13
setparent(IFCPROPERTYSETDEFINITION, IFCPROPERTYSET)				--R5.1.3.14
setparent(IFCPROPERTYDEFINITION, IFCPROPERTYSETDEFINITION) 		--R5.1.3.15
setparent(IFCPROPERTYTEMPLATEDEFINITION, IFCPROPERTYTEMPLATE)	--R5.1.3.17
setparent(IFCPROPERTYDEFINITION, IFCPROPERTYTEMPLATEDEFINITION)	--R5.1.3.18
setparent(IFCPROPERTYSETDEFINITION, IFCQUANTITYSET) 			--R5.1.3.20
setparent(IFCRELDECOMPOSES, IFCRELAGGREGATES)					--R5.1.3.21
setparent(IFCRELATIONSHIP, IFCRELASSOCIATES)					--R5.1.3.30
setparent(IFCROOT, IFCRELATIONSHIP)								--R5.1.3.34
setparent(IFCRELATIONSHIP, IFCRELCONNECTS)						--R5.1.3.35
setparent(IFCRELATIONSHIP, IFCRELDECOMPOSES)					--R5.1.3.37
setparent(IFCRELATIONSHIP, IFCRELDEFINES)						--R5.1.3.38
setparent(IFCRELDEFINES, IFCRELDEFINESBYPROPERTIES)				--R5.1.3.40
setparent(IFCRELDEFINES, IFCRELDEFINESBYTYPE)					--R5.1.3.42
setparent(IFCOBJECTDEFINITION, IFCTYPEOBJECT)					--R5.1.3.47

setparent(IFCCONTEXT, IFCPROJECT)								--R5.1.3.11


--[[
setparent(IFCPROPERTYTEMPLATEDEFINITION, IFCPROPERTYTEMPLATE)	--R5.1.3.00
setparent(IFCPROPERTYTEMPLATEDEFINITION, IFCPROPERTYTEMPLATE)	--R5.1.3.00
setparent(IFCPROPERTYTEMPLATEDEFINITION, IFCPROPERTYTEMPLATE)	--R5.1.3.00
setparent(IFCPROPERTYTEMPLATEDEFINITION, IFCPROPERTYTEMPLATE)	--R5.1.3.00
setparent(IFCPROPERTYTEMPLATEDEFINITION, IFCPROPERTYTEMPLATE)	--R5.1.3.00
setparent(IFCPROPERTYTEMPLATEDEFINITION, IFCPROPERTYTEMPLATE)	--R5.1.3.00
setparent(IFCPROPERTYTEMPLATEDEFINITION, IFCPROPERTYTEMPLATE)	--R5.1.3.00
setparent(IFCPROPERTYTEMPLATEDEFINITION, IFCPROPERTYTEMPLATE)	--R5.1.3.00
--]]

