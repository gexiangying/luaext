--	8. IFC Resource Layer	--	8.18 IfcRepresentationResource
--	8. IFC Resource Layer	--	8.18 IfcRepresentationResource
setfenv(1,ifc)

local obj_tool_ = require "obj_tool"

local gpt_ = require "g_pt"

--	8.18.2 Type

--R8.18.2.1
--[[IFCGEOMETRICPROJECTIONENUM = {} --IfcGeometricProjectionEnum = {  
								GRAPH_VIEW, 
								SKETCH_VIEW, 
								MODEL_VIEW, 
								PLAN_VIEW, 
								REFLECTED_PLAN_VIEW, 
								SECTION_VIEW, 
								ELEVATION_VIEW, 
								USERDEFINED, 
								NOTDEFINED			}--]] 

--8.18.3 Entities
--R8.18.3.3
IFCGEOMETRICREPRESENTATIONCONTEXT = {param = 4, name = "IFCGEOMETRICREPRESENTATIONCONTEXT"} --IfcGeometricRepresentationContext = {}
--[[	ENTITY IfcGeometricRepresentationContext  
		SUPERTYPE OF(IfcGeometricRepresentationSubContext)  
		SUBTYPE OF IfcRepresentationContext;  
			CoordinateSpaceDimension :  IfcDimensionCount; 
			Precision :  OPTIONAL REAL; 
			WorldCoordinateSystem :  IfcAxis2Placement; 
			TrueNorth :  OPTIONAL IfcDirection; 
		INVERSE  
			HasSubContexts :  SET OF IfcGeometricRepresentationSubContext FOR ParentContext; 
		WHERE  
			WR11 :  NOT(EXISTS(TrueNorth)) OR (HIINDEX(TrueNorth.DirectionRatios) = 2)--]]

function IFCGEOMETRICREPRESENTATIONCONTEXT:set_key(key)
	self.key = key
	self.new_key = key
	self.class_name = "IFCGEOMETRICREPRESENTATIONCONTEXT"
	return self
end
function IFCGEOMETRICREPRESENTATIONCONTEXT:create_axis2_place3d(info,db)
	local axis2_place3d = ifcnew(IFCAXIS2PLACEMENT3D)
	axis2_place3d:set_origin();
	return axis2_place3d
end
function IFCGEOMETRICREPRESENTATIONCONTEXT:set(context,db)
	local context_identifier = "\$";
	local context_type = context;
	
	--local represent_context = new(represent_context)
	self:set_represent_context(context_identifier,context_type)

	local coordinate_space_dimension = "3";
	local precision = "1.E-006";
	local world_coordinate_system = self:create_axis2_place3d(info,db);
	local true_north = "\$";
	
	self[3] = coordinate_space_dimension;
	self[4] = precision;
	self[5] = world_coordinate_system;
	self[6] = true_north;
	
	
	return self
end




--R8.18.3.4
IFCGEOMETRICREPRESENTATIONSUBCONTEXT = {param = 4, name = "IFCGEOMETRICREPRESENTATIONSUBCONTEXT"} 
--IfcGeometricRepresentationSubContext = {}
--[[	ENTITY IfcGeometricRepresentationSubContext  
		SUBTYPE OF IfcGeometricRepresentationContext;  
			ParentContext :  IfcGeometricRepresentationContext; 
			TargetScale :  OPTIONAL IfcPositiveRatioMeasure; 
			TargetView :  IfcGeometricProjectionEnum; 
			UserDefinedTargetView :  OPTIONAL IfcLabel; 
		INVERSE  
			CoordinateSpaceDimension : IfcDimensionCount FOR IfcGeometricRepresentationContext; 
			TrueNorth :  IfcDirection FOR IfcGeometricRepresentationContext; 
			Precision :  REAL FOR IfcGeometricRepresentationContext; 
		DERIVE  
			SELF\IfcGeometricRepresentationContext.WorldCoordinateSystem : 
			 			IfcAxis2Placement := ParentContext.WorldCoordinateSystem; 
			SELF\IfcGeometricRepresentationContext.CoordinateSpaceDimension : 
						IfcDimensionCount := ParentContext.CoordinateSpaceDimension; 
			SELF\IfcGeometricRepresentationContext.TrueNorth :  IfcDirection := 
						NVL(ParentContext.TrueNorth, 
			SELF\IfcGeometricRepresentationContext.WorldCoordinateSystem.P[2]); 
			SELF\IfcGeometricRepresentationContext.Precision :  REAL := 
						NVL(ParentContext.Precision,1.E-5); 
		WHERE  
			WR31 :  NOT( IFCREPRESENTATIONRESOURCE.IFCGEOMETRICREPRESENTATIONSUBCONTEXT 
								IN TYPEOF(ParentContext)) 
			WR32 :  (TargetView <> IfcGeometricProjectionEnum.USERDEFINED) OR ((TargetView = 
								IfcGeometricProjectionEnum.USERDEFINED) AND 
								EXISTS(UserDefinedTargetView))  --]]

--R8.18.3.6
IFCMATERIALDEFINITIONREPRESENTATION = {param =1, name = "IFCMATERIALDEFINITIONREPRESENTATION"} --IfcMaterialDefinitionRepresentation = {}  
--[[ENTITY IfcMaterialDefinitionRepresentation  
 SUBTYPE OF IfcProductRepresentation;  
	RepresentedMaterial :  IfcMaterial; 
 WHERE  
	OnlyStyledRepresentations :  SIZEOF(QUERY(temp <* Representations | (NOT( IFCREPRESENTATIONRESOURCE.IFCSTYLEDREPRESENTATION IN TYPEOF(temp))) )) = 0  --]] 

--R8.18.3.7
IFCPRODUCTDEFINITIONSHAPE = {param =0, name = "IFCPRODUCTDEFINITIONSHAPE"} --IfcProductDefinitionShape = {}
--[[  ENTITY IfcProductDefinitionShape  
 SUBTYPE OF IfcProductRepresentation;  
 INVERSE  
 ShapeOfProduct :  SET [1:?] OF IfcProduct FOR Representation; 
HasShapeAspects :  SET OF IfcShapeAspect FOR PartOfProductDefinitionShape; 
 
 WHERE  
 OnlyShapeModel :  SIZEOF(QUERY(temp <* Representations | (NOT( IFCREPRESENTATIONRESOURCE.IFCSHAPEMODEL IN TYPEOF(temp))) )) = 0 
 
END_ENTITY;  
--]]
function IFCPRODUCTDEFINITIONSHAPE:set_key(key)
	self.key = key
	self.new_key = key
	self.class_name = "IFCPRODUCTDEFINITIONSHAPE"
	return self
end



--R8.18.3.8
IFCPRODUCTREPRESENTATION = {param =3, name = "IFCPRODUCTREPRESENTATION"} --IfcProductRepresentation = {}  
--[[	ENTITY IfcProductRepresentation  
		ABSTRACT SUPERTYPE OF(ONEOF(IfcMaterialDefinitionRepresentation, 
									IfcProductDefinitionShape));  
			Name :  OPTIONAL IfcLabel; 
			Description :  OPTIONAL IfcText; 
			Representations :  LIST [1:?] OF IfcRepresentation; --]]
		

local function 	push_all(son,all)
	if(not son) then return end
	for k in pairs(son) do
		table.insert(all,son[k])
	end
end		

function IFCPRODUCTREPRESENTATION:get_obj(obj)
	if(type(self[3]) == "table") then
		for k in pairs(self[3]) do
			local surfs = {}
			self[3][k]:create_surfaces(surfs)			
			push_all(surfs,obj.surfaces)
		end
	end		
	return obj	
end

function IFCPRODUCTREPRESENTATION:set_key(key)
	self.key = key
	self.new_key = key
	self.class_name = "IFCPRODUCTREPRESENTATION"
	return self
end

function IFCPRODUCTREPRESENTATION:set(name,description,shape_repesent_keys)	
	self[1] = name
	self[2] = name
	self[3] = shape_repesent_keys
	return self
end

function IFCPRODUCTREPRESENTATION:get_start_pt()
	if(type(self[3]) == "table") then
		for k in pairs(self[3]) do
			local pt = self[3][k]:get_start_pt()	
			if(pt)then
				return pt;
			end		
		end
	end		
end
function IFCPRODUCTREPRESENTATION:set_start_pt(pt)
	if(type(self[3]) == "table") then
		for k in pairs(self[3]) do
			self[3][k]:set_start_pt(pt)			
		end
	end		
end

function IFCPRODUCTREPRESENTATION:get_end_pt()
	if(type(self[3]) == "table") then
		for k in pairs(self[3]) do
			local pt = self[3][k]:get_end_pt()	
			if(pt)then
				return pt;
			end		
		end
	end		
end
function IFCPRODUCTREPRESENTATION:set_end_pt(pt)
	if(type(self[3]) == "table") then
		for k in pairs(self[3]) do
			self[3][k]:set_end_pt(pt)			
		end
	end		
end



--R8.18.3.10 
IFCREPRESENTATION = {param = 4, name = "IFCREPRESENTATION"} --IfcRepresentation = {}    
--[[	ENTITY IfcRepresentation  
		ABSTRACT SUPERTYPE OF(ONEOF(IfcShapeModel, IfcStyleModel));  
			ContextOfItems :  IfcRepresentationContext; 
			RepresentationIdentifier :  OPTIONAL IfcLabel; 
			RepresentationType :  OPTIONAL IfcLabel; 
			Items :  SET [1:?] OF IfcRepresentationItem; 
		INVERSE  
			RepresentationMap :  SET [0:1] OF IfcRepresentationMap FOR MappedRepresentation; 
			LayerAssignments :  SET OF IfcPresentationLayerAssignment FOR AssignedItems; 
			OfProductRepresentation :  SET OF IfcProductRepresentation FOR Representations; --]] 

function IFCREPRESENTATION:create_surfaces(surfs)
	if(type(self[4]) == "table") then
		for k in pairs(self[4]) do
			if(string.find(self[2],"Axis"))then
				--trace_out("axis style isn't draw.\n")
			else				
				self[4][k]:create_surfaces(surfs)
			end
			--trace_out("IfcRepresentation surf num = " ..#surfs .. "\n")
		end
	end	
end

function IFCREPRESENTATION:set(context_key,identifier,type,items_keys)
	self[1] = context_key;
	self[2] = identifier;
	self[3] = type;
	self[4] = items_keys;
	return self;
end

function IFCREPRESENTATION:set_start_pt(pt)
	--需要重新改变截面的值，需要重新绘制，按照新的点进行所有的截面，方向，拉伸长度的改变。
	if(string.find(self[2],"Axis"))then
		if(self[4][1])then
			self[4][1]:set_start_pt(pt)		
		end
	end
end
function IFCREPRESENTATION:get_start_pt()
	if(string.find(self[2],"Axis"))then
		if(self[4][1])then
			return self[4][1]:get_start_pt()		
		end
	else
		return nil
	end
end

function IFCREPRESENTATION:set_end_pt(pt)
	--需要重新改变截面的值，需要重新绘制，按照新的点进行所有的截面，方向，拉伸长度的改变。
	if(string.find(self[2],"Axis"))then
		if(self[4][1])then
			self[4][1]:set_end_pt(pt)		
		end
	end
end
function IFCREPRESENTATION:get_end_pt()
	if(string.find(self[2],"Axis"))then
		if(self[4][1])then
			return self[4][1]:get_end_pt()		
		end
	else
		return nil
	end
end

--R8.18.3.11
IFCREPRESENTATIONCONTEXT = {param = 2, name = "IFCREPRESENTATIONCONTEXT"} --IfcRepresentationContext = {}
--[[	ENTITY IfcRepresentationContext  
		ABSTRACT SUPERTYPE OF(IfcGeometricRepresentationContext);  
			ContextIdentifier :  OPTIONAL IfcLabel; 
			ContextType :  OPTIONAL IfcLabel; 
		INVERSE  
			RepresentationsInContext :  SET OF IfcRepresentation FOR ContextOfItems; --]]
--R8.18.3.13

function IFCREPRESENTATIONCONTEXT:set_represent_context(context_identifier,context_type)
	self[1] = context_identifier
	self[2] = context_type
end


IFCSHAPEMODEL = {param = 0, name = "IFCSHAPEMODEL"} --IfcShapeModel = {}
--[[ENTITY IfcShapeModel  
 ABSTRACT SUPERTYPE OF(ONEOF(IfcShapeRepresentation, IfcTopologyRepresentation))  
 SUBTYPE OF IfcRepresentation;  
 INVERSE  
	OfShapeAspect :  SET [0:1] OF IfcShapeAspect FOR ShapeRepresentations; 
 WHERE  
	WR11 :  (SIZEOF(SELF\IfcRepresentation.OfProductRepresentation) = 1) XOR (SIZEOF(SELF\IfcRepresentation.RepresentationMap) = 1) XOR (SIZEOF(OfShapeAspect) = 1) --]] 
 
--R8.18.3.14
IFCSHAPEREPRESENTATION = {param = 0, name = "IFCSHAPEREPRESENTATION"}  --IfcShapeRepresentation = {}
--[[ENTITY IfcShapeRepresentation  
 SUBTYPE OF IfcShapeModel;  
 WHERE  
	WR21 :  IFCREPRESENTATIONRESOURCE.IFCGEOMETRICREPRESENTATIONCONTEXT IN TYPEOF(SELF\IfcRepresentation.ContextOfItems) 
	WR22 :  SIZEOF(QUERY(temp <* Items | ( IFCTOPOLOGYRESOURCE.IFCTOPOLOGICALREPRESENTATIONITEM IN TYPEOF(temp)) AND (NOT(SIZEOF( [ IFCTOPOLOGYRESOURCE.IFCVERTEXPOINT , IFCTOPOLOGYRESOURCE.IFCEDGECURVE , IFCTOPOLOGYRESOURCE.IFCFACESURFACE ] * TYPEOF(temp)) = 1)) )) = 0 
	WR23 :  EXISTS(SELF\IfcRepresentation.RepresentationType) 
	WR24 :  IfcShapeRepresentationTypes(SELF\IfcRepresentation.RepresentationType, SELF\IfcRepresentation.Items) --]]  

--[[function IFCSHAPEREPRESENTATION:get_shapes()
	print (ddd)
end
--]]
function IFCSHAPEREPRESENTATION:set_key(key)
	self.key = key;
	self.new_key = key;
	self.class_name = "IFCSHAPEREPRESENTATION";
	return self;
end



setparent(IFCREPRESENTATIONCONTEXT, IFCGEOMETRICREPRESENTATIONCONTEXT)		--R8.18.3.03
setparent(IFCGEOMETRICREPRESENTATIONCONTEXT, IFCGEOMETRICREPRESENTATIONSUBCONTEXT)
																			--R8.18.3.04
setparent(IFCPRODUCTREPRESENTATION, IFCMATERIALDEFINITIONREPRESENTATION) 	--R8.18.3.06
setparent(IFCPRODUCTREPRESENTATION, IFCPRODUCTDEFINITIONSHAPE)  			--R8.18.3.07
setparent(IFCREPRESENTATION, IFCSHAPEMODEL)  								--R8.18.3.13
setparent(IFCSHAPEMODEL, IFCSHAPEREPRESENTATION)  							--R8.18.3.14


