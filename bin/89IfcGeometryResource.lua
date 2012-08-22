package.cpath="?;?.lua;?.dll"
local steel_ = require "steel"



--	8. IFC Resource Layer	--	8.9 IfcGeometryResource
setfenv(1,ifc)

local tools_ = require "steel_tools"
local gpt_ = require "g_pt"
local obj_tool_ = require "obj_tool"
local g_pt_ = require("g_pt")

--	8.9.2 Type
--R8.9.2.1
--IFCDIMENSIONCOUNT = 0  --IfcDimensionCount = 0		-- INTEGER  --WHERE	 WR1 :  { 0 < SELF <= 3 }  
--R8.9.2.7
--IFCAXIS2PLACEMENT = {}  --IfcAxis2Placement = {}	--	SELECT (IfcAxis2Placement2D, IfcAxis2Placement3D)

--8.9.3 Entities
--R8.9.3.1
IFCAXIS1PLACEMENT = {param = 1, name = "IFCAXIS1PLACEMENT"}  --IfcAxis1Placement = {Axis = IfcDirection}
--[[	ENTITY IfcAxis1Placement  
		SUBTYPE OF IfcPlacement;  
			Axis :  OPTIONAL IfcDirection; 
		DERIVE  
			Z :  IfcDirection := NVL (IfcNormalise(Axis), IfcRepresentationItem() || 	
					IfcGeometricRepresentationItem () || IfcDirection([0.0,0.0,1.0])); 
		WHERE  
			WR1 :  (NOT (EXISTS (Axis))) OR (Axis.Dim = 3) 
			WR2 :  SELF\IfcPlacement.Location.Dim = 3 
--]]

--R8.9.3.2
IFCAXIS2PLACEMENT2D = {param = 1, name = "IFCAXIS2PLACEMENT2D"}  --IfcAxis2Placement2D = {RefDirection = IfcDirection}

function IFCAXIS2PLACEMENT2D:get_origin_dircet()
	local ori = self[1]:get_value()
	local dir = self[2]:get_value()
	return { origin = ori ,dircet = dir }
end
function IFCAXIS2PLACEMENT2D:set(pt,direct)
	self[1] = create_cartesian_point(pt)
	self[2] = create_dircet(direct)
end


--R8.9.3.3
IFCAXIS2PLACEMENT3D = {param =2, name = "IFCAXIS2PLACEMENT3D"}  --IfcAxis2Placement3D = {}
--[[	ENTITY IfcAxis2Placement3D  
		SUBTYPE OF IfcPlacement;  
			Axis :  OPTIONAL IfcDirection; 
			RefDirection :  OPTIONAL IfcDirection; 
		DERIVE  
			P :  LIST [3:3] OF IfcDirection := IfcBuildAxes(Axis, RefDirection); 
 
		WHERE  
			WR1 :  SELF\IfcPlacement.Location.Dim = 3 
			WR2 :  (NOT (EXISTS (Axis))) OR (Axis.Dim = 3) 
			WR3 :  (NOT (EXISTS (RefDirection))) OR (RefDirection.Dim = 3) 
			WR4 :  (NOT (EXISTS (Axis))) OR (NOT (EXISTS (RefDirection))) OR
					(IfcCrossProduct(Axis,RefDirection).Magnitude > 0.0) 
			WR5 :  NOT ((EXISTS (Axis)) XOR (EXISTS (RefDirection))) 
--]]
function IFCAXIS2PLACEMENT3D:get_axis_z()
	local axis_z = self[1]:get_value()
	return axis_z
end
function IFCAXIS2PLACEMENT3D:get_axis_x()
	local axis_x = self[2]:get_value()
	return axis_x
end
function IFCAXIS2PLACEMENT3D:set_key(key)
	self.key = key
	self.new_key = key
	self.class_name = "IFCAXIS2PLACEMENT3D"
	return self
end
function IFCAXIS2PLACEMENT3D:set(info,db)
	
	return self
end

function IFCAXIS2PLACEMENT3D:set_origin()
	self[1] = create_cartesian_point({x=0,y=0,z=0});	
	self[2] = "$";	
	self[3] = "$";	
end


--[[
function IFCAXIS2PLACEMENT3D:get_axis()
	print(self[1])
	print(self[2])
	print(self[3])
en--]]

----
function IFCAXIS2PLACEMENT3D:axis(t)
	local pos = IFCPLACEMENT:get_param_count()+1;
	self[pos] =  ifcset(self[pos],t,IFCDIRECTION);
	return self[pos];
end

function IFCAXIS2PLACEMENT3D:ref_direction(t)
	local pos = IFCPLACEMENT:get_param_count()+2;
	self[pos] =  ifcset(self[pos],t,IFCDIRECTION);
	return self[pos];
end

function IFCAXIS2PLACEMENT3D:get_axis()
	local pos = IFCPLACEMENT:get_param_count();
	if tools_.ismet(IFCDIRECTION,self[pos+1]) then
		return self[pos+1];
	end
	if tools_.ismet(IFCDIRECTION,self.axis) then
		return self.axis;
	end
end

function IFCAXIS2PLACEMENT3D:get_ref_direction()
	local pos = IFCPLACEMENT:get_param_count();
	if tools_.ismet(IFCDIRECTION,self[pos+2]) then
		return self[pos+2];
	end
	if tools_.ismet(IFCDIRECTION,self.ref_direction) then
		return self.ref_direction;
	end
end

function IFCAXIS2PLACEMENT3D:set_gnormal_x(gx)
	self:ref_direction{}:set_gnormal(gx);
end

function IFCAXIS2PLACEMENT3D:set_gnormal_z(gz)
	self:axis{}:set_gnormal(gz);
end

function IFCAXIS2PLACEMENT3D:get_gnormal_x()
	local gpt = tools_.met(gpt_.Point,{x=1,y=0,z=0});
	if not self:get_ref_direction() then return gpt end;
	return self:get_ref_direction():get_gnormal();
end

--function IFCAXIS2PLACEMENT3D:get_gnormal_y()
--	local y = tools_.met(gpt_.Point,{x=0,y=1,z=0});
--	if not self:get_ref_direction() then return y end;
--	if not self:get_axis() then return y end;
--	local x = self:get_gnormal_x();
--	local z = self:get_gnormal_z();
--	y = gpt_.pt_multi(z,x)
--	return y;
--end

function IFCAXIS2PLACEMENT3D:get_gnormal_z()
	local gpt = tools_.met(gpt_.Point,{x=0,y=0,z=1});
	if not self:get_axis() then return gpt end;
	return self:get_axis():get_gnormal();
end

function IFCAXIS2PLACEMENT3D:get_gaxis()
	local gaxis = tools_.met(gpt_.g_axis, {
		base = self:get_gbase();
		x = self:get_gnormal_x();
		z = self:get_gnormal_z();
--		y = self:get_gnormal_y();
	});
	gaxis.y = gpt_.pt_multi(gaxis.z,gaxis.x)
	return gaxis;
end

function IFCAXIS2PLACEMENT3D:set_gaxis(t)
	self:set_gbase(t.base);
	self:set_gnormal_x(t.x);
	self:set_gnormal_z(t.z);
end

--gpt1,gpt2
function IFCAXIS2PLACEMENT3D:set_gaxis_by_x(t)
	tools_.met(gpt_.Point,t.pt1);
	tools_.met(gpt_.Point,t.pt2);
	self:set_gaxis(gpt_.set_gaxis_by_x(t));
end

----

function IFCAXIS2PLACEMENT3D:set_key(key)
	self.key = key;
	self.new_key = key;
	self.class_name = "IFCAXIS2PLACEMENT3D";
	return self;
end
function IFCAXIS2PLACEMENT3D:set(col_info)
	--self[1]
	return self;
end

--R8.9.3.4
IFCPOLYLINE = {param = 1, name = "IFCPOLYLINE"} --IfcPolyline = {}
--[[ENTITY IfcPolyline  
 SUBTYPE OF IfcBoundedCurve;  
	Points :  LIST [2:?] OF IfcCartesianPoint;	
 WHERE  
	WR41 :  SIZEOF(QUERY(Temp <* Points | Temp.Dim <> Points[1].Dim)) = 0 --]]


function IFCPOLYLINE:get_ent(ents)
	if(type(self[1]) == "table" )then
		for i=1 , #self[1]-1 do
			local s = self[1][i]:get_value()
			local e = self[1][i+1]:get_value()
			local ln =  {start_pt = s,end_pt =e}
			table.insert(ents,ln)				
		end	
	end	
end

function IFCPOLYLINE:create_surfaces(surfs)
	local surf = obj_tool_.Surface:new()	
	if(type(self[1]) == "table" )then
		for i=1 , #self[1]-1 do
			local s = self[1][i]:get_value()
			local e = self[1][i+1]:get_value()
			local ln =  {start_pt = s,end_pt =e}
			obj_tool_.add_line(s,e,surf)			
		end	
	end	
	table.insert(surfs,surf)
end

function IFCPOLYLINE:set_key(key)
	self.key = key;
	self.new_key = key;
	self.class_name = "IFCPOLYLINE";
	return self;
end
function IFCPOLYLINE:create_cartesian(pt,db)
	local key  = get_key();
	local cart_pt = new(IFCCARTESIANPOINT);
	cart_pt:set_key(key);
	cart_pt:set(pt,db);
	
	push_ifc_data(cart_pt,db);
	return cart_pt;


end

function IFCPOLYLINE:set(start_pt,end_pt,db)
	local segments = {}
	local start_key = self:create_cartesian(start_pt,db);
	local end_key = self:create_cartesian(end_pt,db);
	segments[1] = start_key
	segments[2] = end_key
	
	self[1] = segments
end

function IFCPOLYLINE:set_start_pt(pt)
	self[1][1]:set_point(pt)
end
function IFCPOLYLINE:get_start_pt()
	return self[1][1]:get_point()
end

function IFCPOLYLINE:set_end_pt(pt)
	self[1][2]:set_point(pt)
end
function IFCPOLYLINE:get_end_pt()
	return self[1][2]:get_point()
end
function IFCPOLYLINE:set_pts(pts)	
	local ps = {}
	for i=1,#pts do		
		ps[i] = create_cartesian_point(pts[i])
	end	
	self[1] = ps;
end


--R8.9.3.5
IFCBOUNDEDCURVE = {param = 0, name = "IFCBOUNDEDCURVE"} --IfcBoundedCurve = {}	
--[[ENTITY IfcBoundedCurve  
 ABSTRACT SUPERTYPE OF(ONEOF(IfcBSplineCurve, IfcCompositeCurve, IfcPolyline, IfcTrimmedCurve))  
 SUBTYPE OF IfcCurve;  --]]  

--R8.9.3.11
IFCCARTESIANPOINT = {param = 1, name = "IFCCARTESIANPOINT"}  --IfcCartesianPoint={}
--[[	ENTITY IfcCartesianPoint  
		SUBTYPE OF IfcPoint;  
			Coordinates :  LIST [1:3] OF IfcLengthMeasure; 
		DERIVE  
			Dim :  IfcDimensionCount := HIINDEX(Coordinates); 
		WHERE  
			WR1 :  HIINDEX(Coordinates) >= 2 --]]
function IFCCARTESIANPOINT:get_value()	
	return {x = self[1][1],y = self[1][2],z = self[1][3] or 0}
end

----
function IFCCARTESIANPOINT:coordinates(t)
	local pos = 1;
	self[pos] = ifcset(self[pos],t);
	return self[pos];
end

function IFCCARTESIANPOINT:get_coordinates()
	if type(self.coordinates)=="table" then return self.coordinates end
	return self[1];
end

function IFCCARTESIANPOINT:set_gpt(t)
	self:coordinates{};	
	self:coordinates()[1] = t.x;
	self:coordinates()[2] = t.y;
	self:coordinates()[3] = t.z;
end

function IFCCARTESIANPOINT:get_gpt()
	local gpt = tools_.met(gpt_.Point,{x=0,y=0,z=0});
	if not self:get_coordinates() then return gpt end;
	gpt.x = self:get_coordinates()[1];
	gpt.y = self:get_coordinates()[2];
	gpt.z = self:get_coordinates()[3];
	return gpt;
end
----
function IFCCARTESIANPOINT:set_key(key)
	self.key = key;
	self.new_key = key;
	self.class_name = "IFCCARTESIANPOINT";
	return self;
end

function IFCCARTESIANPOINT:set(pt,db)
	if(pt.z)then
		self[1] = {pt.x,pt.y,pt.z};
	else
		self[1] = {pt.x,pt.y};--z值不需要赋值
	end
end
function IFCCARTESIANPOINT:get_point()
	return {x = self[1][1],y = self[1][2],z = self[1][3]}
end
function IFCCARTESIANPOINT:set_point(pt)
	if (pt.z) then
		self[1][1] = pt.x
		self[1][2] = pt.y
		self[1][3] = pt.z
	else
		self[1][1] = pt.x
		self[1][2] = pt.y
	end

end




--R8.9.3.12
IFCCARTESIANTRANSFORMATIONOPERATOR = {param =4, name = "IFCCARTESIANTRANSFORMATIONOPERATOR"} --IfcCartesianTransformationOperator={}
--[[ENTITY IfcCartesianTransformationOperator  
 ABSTRACT SUPERTYPE OF(ONEOF(IfcCartesianTransformationOperator2D, IfcCartesianTransformationOperator3D))  
 SUBTYPE OF IfcGeometricRepresentationItem;  
	Axis1 :  OPTIONAL IfcDirection; 
	Axis2 :  OPTIONAL IfcDirection; 
	LocalOrigin :  IfcCartesianPoint; 
	Scale :  OPTIONAL REAL; 
 DERIVE  
	Scl :  REAL := NVL(Scale, 1.0); 
	Dim :  IfcDimensionCount := LocalOrigin.Dim; 
 WHERE  
	WR1 :  Scl > 0.0 --]]

--R8.9.3.15
IFCCARTESIANTRANSFORMATIONOPERATOR3D={param=1, name = "IFCCARTESIANTRANSFORMATIONOPERATOR3D"} --IfcCartesianTransformationOperator3D={}
--[[ENTITY IfcCartesianTransformationOperator3D  
 SUPERTYPE OF(IfcCartesianTransformationOperator3DnonUniform)  
 SUBTYPE OF IfcCartesianTransformationOperator;  
	Axis3 :  OPTIONAL IfcDirection; 
 DERIVE  
	U :  LIST [3:3] OF IfcDirection := IfcBaseAxis(3,SELF\IfcCartesianTransformationOperator.Axis1, SELF\IfcCartesianTransformationOperator.Axis2,Axis3); 
 WHERE  
	WR1 :  SELF\IfcCartesianTransformationOperator.Dim = 3 
	WR2 :  NOT(EXISTS(SELF\IfcCartesianTransformationOperator.Axis1)) OR (SELF\IfcCartesianTransformationOperator.Axis1.Dim = 3) 
	WR3 :  NOT(EXISTS(SELF\IfcCartesianTransformationOperator.Axis2)) OR (SELF\IfcCartesianTransformationOperator.Axis2.Dim = 3) 
	WR4 :  NOT(EXISTS(Axis3)) OR (Axis3.Dim = 3) --]]

--R8.9.3.17
IFCCIRCLE = {param = 1, name = "IFCCIRCLE"} --IfcCircle = {}
--[[ENTITY IfcCircle  
 SUBTYPE OF IfcConic;  
	Radius :  IfcPositiveLengthMeasure; --]]

function IFCCIRCLE:get_center()
	return self[1]:get_origin_dircet()
end
function IFCCIRCLE:get_radius()
	return self[2]	
end
function IFCCIRCLE:set(center,r)
	self[1] = create_axis2_placement2d(center,{x=1,y=0});
	self[2] = r;
end

--R8.9.3.18
IFCCOMPOSITECURVE = {param = 2, name = "IFCCOMPOSITECURVE"} --IfcCompositeCurve = {}
--[[ENTITY IfcCompositeCurve  
 SUPERTYPE OF(IfcCompositeCurveOnSurface)  
 SUBTYPE OF IfcBoundedCurve;  
	Segments :  LIST [1:?] OF IfcCompositeCurveSegment; 
	SelfIntersect :  LOGICAL; 
 DERIVE  
	NSegments :  INTEGER := SIZEOF(Segments); 
	ClosedCurve :  LOGICAL := Segments[NSegments].Transition <> Discontinuous; 
 WHERE  
	WR41 :  ((NOT ClosedCurve) AND (SIZEOF(QUERY(Temp <* Segments | Temp.Transition = Discontinuous)) = 1)) OR ((ClosedCurve) AND (SIZEOF(QUERY(Temp <* Segments | Temp.Transition = Discontinuous)) = 0)) 
	WR42 :  SIZEOF( QUERY( Temp <* Segments | Temp.Dim <> Segments[1].Dim)) = 0 --]] 


function IFCCOMPOSITECURVE:get_ent(ents)
	for i in ipairs(self[1]) do
		self[1][i]:get_ent(ents)	--可能存多个
	end
end


function IFCCOMPOSITECURVE:set_key(key)
	self.key = key;
	self.new_key = key;
	self.class_name = "IFCCOMPOSITECURVE";
	return self;
end
function IFCCOMPOSITECURVE:create_curve_line(start_pt,end_pt,db,curve_lines)
	local key = get_key();
	local start_pt = start_pt;
	local end_pt = end_pt;
	local composite_curve_segment = new(IFCCOMPOSITECURVESEGMENT);
	composite_curve_segment:set_key(key);
	composite_curve_segment:set(start_pt,end_pt,db);	
	
	push_ifc_data(composite_curve_segment,db);		
	table.insert(curve_lines,composite_curve_segment);	
end
function IFCCOMPOSITECURVE:create_curve_lines(info,db,curve_lines)
	--trace_out("g_section="..g_section.."\n");
	local sect = steel_.section_points(g_section~="" and g_section or info.section);
	if(not sect) then		
		sect = steel_.section_points("S-50*50*8");	
		trace_out("g_section = ".. tostring(g_section) .. "   or  " .. "info.section = ".. tostring(info.section) .. " ,this section isn't exist,please check it.\n");
	end
	for i=1,#sect.outer-1 do		
		self:create_curve_line(sect.outer[i],sect.outer[i+1],db,curve_lines);
	end
	self:create_curve_line(sect.outer[1],sect.outer[#sect.outer],db,curve_lines);
end
function IFCCOMPOSITECURVE:set(info,db)
	--主要函数，把截面的点全部生成
	local curve_lines = {}
	self:create_curve_lines(info,db,curve_lines)
	self[1] = curve_lines;
	self[2] = ".F.";
end


--R8.9.3.20
IFCCOMPOSITECURVESEGMENT = {param = 3, name = "IFCCOMPOSITECURVESEGMENT"} --IfcCompositeCurveSegment = {}
--[[ENTITY IfcCompositeCurveSegment  
 SUPERTYPE OF(IfcReparametrisedCompositeCurveSegment)  
 SUBTYPE OF IfcGeometricRepresentationItem;  
	Transition :  IfcTransitionCode; 
	SameSense :  BOOLEAN; 
	ParentCurve :  IfcCurve; 
 INVERSE  
	UsingCurves :  SET [1:?] OF IfcCompositeCurve FOR Segments; 
 DERIVE  
	Dim :  IfcDimensionCount := ParentCurve.Dim; 
 WHERE  
	WR1 :  ( IFCGEOMETRYRESOURCE.IFCBOUNDEDCURVE IN TYPEOF(ParentCurve)) --]]


function IFCCOMPOSITECURVESEGMENT:get_ent(ents)
	self[3]:get_ent(ents)
end


function IFCCOMPOSITECURVESEGMENT:set_key(key)
	self.key = key;
	self.new_key = key;
	self.class_name = "IFCCOMPOSITECURVESEGMENT";
	return self;
end

function IFCCOMPOSITECURVESEGMENT:create_polyline(start_pt,end_pt,db)
	local key  = get_key();
	local poly_line = new(IFCPOLYLINE);
	poly_line:set_key(key);
	poly_line:set(start_pt,end_pt,db);
	
	push_ifc_data(poly_line,db);
	return poly_line;
	
end
function IFCCOMPOSITECURVESEGMENT:set(start_pt,end_pt,db)
	local Transition = ".CONTINUOUS.";
	local SameSense = ".T.";
	local ParentCurve  = self:create_polyline(start_pt,end_pt,db);
	
	self[1] = Transition;
	self[2] = SameSense;
	self[3] = ParentCurve;
	return self
end


--R8.9.3.21
IFCCONIC = {param = 1, name = "IFCCONIC"} --IfcConic = {}
--[[ENTITY IfcConic  
 ABSTRACT SUPERTYPE OF(ONEOF(IfcCircle, IfcEllipse))  
 SUBTYPE OF IfcCurve;  
	Position :  IfcAxis2Placement; --]]

--R8.9.3.22  (father function do not considered)
IFCCURVE = {param =0, name = "IFCCURVE"}  --IfcCurve = {param = 0}
--[[	ENTITY IfcCurve  
		ABSTRACT SUPERTYPE OF(ONEOF(IfcBoundedCurve, IfcConic, IfcLine, IfcOffsetCurve2D, 
					IfcOffsetCurve3D, IfcPcurve))  
		SUBTYPE OF IfcGeometricRepresentationItem;  
		DERIVE  
			Dim :  IfcDimensionCount := IfcCurveDim(SELF); --]]

--R8.9.3.26
IFCDIRECTION = {param =1, name = "IFCDIRECTION"}  --IfcDirection = {DirectionRatios  = {}--LIST [2:3] OF REAL; 
--[[	ENTITY IfcDirection  
		SUBTYPE OF IfcGeometricRepresentationItem;  
			DirectionRatios :  LIST [2:3] OF REAL; 
		DERIVE  
			Dim :  IfcDimensionCount := HIINDEX(DirectionRatios); 
		WHERE  
			MagnitudeGreaterZero :  SIZEOF(QUERY(Tmp <* DirectionRatios | Tmp <> 0.0)) > 0 --]]
function IFCDIRECTION:get_value()
	return {x = self[1][1],y = self[1][2],z = self[1][3] or 0}
end


----
function IFCDIRECTION:direction_ratios(t)
	local pos = 1;
	self[pos] = ifcset(self[pos],t);
	return self[pos];
end

function IFCDIRECTION:get_direction_ratios()
	if type(self.direction_ratios)=="table" then return self.direction_ratios end;
	return self[1];
end

function IFCDIRECTION:set_gnormal(t)
	self:direction_ratios{};
	self:direction_ratios()[1] = t.x;
	self:direction_ratios()[2] = t.y;
	self:direction_ratios()[3] = t.z;
end

function IFCDIRECTION:get_gnormal()
	local gpt = new(gpt_.Point,{x=1,y=0,z=0});
	if not self:get_direction_ratios() then return gpt end;
	gpt.x = self:get_direction_ratios()[1];
	gpt.y = self:get_direction_ratios()[2];
	gpt.z = self:get_direction_ratios()[3];
	return gpt;
end
function IFCDIRECTION:set_key(key)
	self.key = key;
	self.new_key = key;
	self.class_name = "IFCDIRECTION";
	return self;
end

function IFCDIRECTION:set(x,y,z,db)
	self[1] = {x,y,z};
	return self
end
function IFCDIRECTION:set_pt(dir)
	if(dir.z)then
		self[1] = {dir.x,dir.y,dir.z};
	else
		self[1] = {dir.x,dir.y};--z值不需要赋值
	end
end




--R8.9.3.29
IFCGEOMETRICREPRESENTATIONITEM = {param = 0, name = "IFCGEOMETRICREPRESENTATIONITEM"}  --IfcGeometricRepresentationItem = {}			
--[[	ENTITY IfcGeometricRepresentationItem  
		ABSTRACT SUPERTYPE OF(ONEOF(IfcAnnotationFillArea, IfcBooleanResult, IfcBoundingBox, IfcCartesianPointList, IfcCartesianTransformationOperator, IfcCompositeCurveSegment, IfcCsgPrimitive3D, IfcCurve, IfcDefinedSymbol, IfcDirection, IfcDirectionList, IfcFaceBasedSurfaceModel, IfcFillAreaStyleHatching, IfcFillAreaStyleTiles, IfcFillAreaStyleTileSymbolWithStyle, IfcGeometricSet, IfcHalfSpaceSolid, IfcLightSource, IfcOneDirectionRepeatFactor, IfcPlacement, IfcPlanarExtent, IfcPoint, IfcSectionedSpine, IfcShellBasedSurfaceModel, IfcSolidModel, IfcSurface, IfcTessellatedItem, IfcTextLiteral, IfcVector))  
		SUBTYPE OF IfcRepresentationItem;  
--]]

--R8.9.3.30
IFCLINE = {param = 2, name = "IFCLINE"}
--[[ENTITY IfcLine  
 SUBTYPE OF IfcCurve;  
	Pnt :  IfcCartesianPoint; 
	Dir :  IfcVector; 
 WHERE  
	SameDim :  Dir.Dim = Pnt.Dim --]]

--R8.9.3.31
IFCMAPPEDITEM = {param =2, name = "IFCMAPPEDITEM"} --IfcMappedItem = {}
--[[ENTITY IfcMappedItem  
 SUBTYPE OF IfcRepresentationItem;  
	MappingSource :  IfcRepresentationMap; 
	MappingTarget :  IfcCartesianTransformationOperator; --]]

function IFCMAPPEDITEM:get_surface()
	print("IFCMAPPEDITEM:get_surface()")
	return self[1]:get_surface()
end
function IFCMAPPEDITEM:get_obj(objs)
	self[1]:get_obj(objs)
end
function IFCMAPPEDITEM:get_ent(ents)
	self[1]:get_ent(ents)
end
function IFCMAPPEDITEM:get_ent(ents)
	self[1]:get_ent(ents)
end
function IFCMAPPEDITEM:create_surfaces(surfs)
	self[1]:create_surfaces(surfs)
end

--R8.9.3.36
IFCPLACEMENT = {param = 1, name = "IFCPLACEMENT"}  --IfcPlacement = {Location = IfcCartesianPoint}
--[[	ENTITY IfcPlacement  
		ABSTRACT SUPERTYPE OF(ONEOF(IfcAxis1Placement, IfcAxis2Placement2D, 
								IfcAxis2Placement3D))  
		SUBTYPE OF IfcGeometricRepresentationItem;  
			Location :  IfcCartesianPoint; 
		DERIVE  
			Dim :  IfcDimensionCount := Location.Dim; --]]
function IFCPLACEMENT:get_origin()
	return self[1]:get_value()
end

----
function IFCPLACEMENT:get_param_count()
	return IFCPLACEMENT.param;
end

function IFCPLACEMENT:location(t)
	local pos = 1;
	self[pos] = ifcset(self[pos],t,IFCCARTESIANPOINT);
	return self[pos];
end

function IFCPLACEMENT:get_location()
	if tools_.ismet(IFCCARTESIANPOINT,self[1]) then 
		return self[1];
	end
	if tools_.ismet(IFCCARTESIANPOINT,self.location) then 
		return self.location;
	end
end

function IFCPLACEMENT:set_gbase(t)
	self:location{}:set_gpt(t);
end

function IFCPLACEMENT:get_gbase()
	local gpt = tools_.met(gpt_.Point,{x=0,y=0,z=0});
	if not self:get_location() then return gpt end;
	local gpt = self:get_location():get_gpt();
	return gpt;
end
----

--R8.9.3.38
IFCPOINT = {param = 0, name = "IFCPOINT"}  --IfcPoint = {}  
--[[	ENTITY IfcPoint  
		ABSTRACT SUPERTYPE OF(ONEOF(IfcCartesianPoint, IfcPointOnCurve, IfcPointOnSurface))  
		SUBTYPE OF IfcGeometricRepresentationItem;  --]] 
 
--R8.9.3.39
IFCPOINTONCURVE = {param = 2, name = "IFCPOINTONCURVE"}  --IfcPointOnCurve = {}
--[[	ENTITY IfcPointOnCurve  
		SUBTYPE OF IfcPoint;  
			BasisCurve :  IfcCurve; 
			PointParameter :  IfcParameterValue; 
		DERIVE  
			Dim :  IfcDimensionCount := BasisCurve.Dim; 
--]]

--R8.9.3.40
IFCPOINTONSURFACE  = {parem =3, name = "IFCPOINTONSURFACE"}  --IfcPointOnSurface = {}
--[[	ENTITY IfcPointOnSurface  
		SUBTYPE OF IfcPoint;  
			BasisSurface :  IfcSurface; 
			PointParameterU :  IfcParameterValue; 
			PointParameterV :  IfcParameterValue; 
		DERIVE  
			Dim :  IfcDimensionCount := BasisSurface.Dim; 
--]]

--R8.9.3.46
IFCREPRESENTATIONITEM = {param = 0, name = "IFCREPRESENTATIONITEM"}  --IfcRepresentationItem = {}
--[[	ENTITY IfcRepresentationItem  
		ABSTRACT SUPERTYPE OF(ONEOF(IfcGeometricRepresentationItem, IfcMappedItem, IfcStyledItem, IfcTopologicalRepresentationItem));  
		INVERSE  
			LayerAssignment :  SET [0:1] OF IfcPresentationLayerAssignment FOR AssignedItems; 
			StyledByItem :  SET [0:1] OF IfcStyledItem FOR Item; --]]

--R8.9.3.47
IFCREPRESENTATIONMAP = {param = 2, name = "IFCREPRESENTATIONMAP"} --IfcRepresentationMap = {}
--[[ENTITY IfcRepresentationMap;  
	MappingOrigin :  IfcAxis2Placement; 
	MappedRepresentation :  IfcRepresentation; 
 INVERSE  
	MapUsage :  SET OF IfcMappedItem FOR MappingSource; 
 WHERE  
	ApplicableMappedRepr :  IFCREPRESENTATIONRESOURCE.IFCSHAPEMODEL IN TYPEOF(MappedRepresentation) --]]
 
 

function IFCREPRESENTATIONMAP:create_surfaces(surfs)
	self[2]:create_surfaces(surfs)
end


--R8.9.3.48
IFCSURFACE = {param = 0, name = "IFCSURFACE"}  --IfcSurface = {}  --father function do not considered
--[[	ENTITY IfcSurface  
		ABSTRACT SUPERTYPE OF(ONEOF(IfcBoundedSurface, IfcElementarySurface, 
					IfcSweptSurface))  
		SUBTYPE OF IfcGeometricRepresentationItem;  
		DERIVE  
			Dim :  IfcDimensionCount := 3; --]]

--R8.9.3.52
IFCTRIMMEDCURVE = {param = 5, name = "IFCTRIMMEDCURVE"} --IfcTrimmedCurve = {}
--[[ENTITY IfcTrimmedCurve  
 SUBTYPE OF IfcBoundedCurve;  
	BasisCurve :  IfcCurve; 
	Trim1 :  SET [1:2] OF IfcTrimmingSelect; 
	Trim2 :  SET [1:2] OF IfcTrimmingSelect; 
	SenseAgreement :  BOOLEAN; 
	MasterRepresentation :  IfcTrimmingPreference; 
 WHERE  
	WR41 :  (HIINDEX(Trim1) = 1) OR (TYPEOF(Trim1[1]) <> TYPEOF(Trim1[2])) 
	WR42 :  (HIINDEX(Trim2) = 1) OR (TYPEOF(Trim2[1]) <> TYPEOF(Trim2[2])) 
	WR43 :  NOT( IFCGEOMETRYRESOURCE.IFCBOUNDEDCURVE IN TYPEOF(BasisCurve)) --]]
function IFCTRIMMEDCURVE:create_circle(center,r)
	local circle = ifcnew(IFCCIRCLE);
	circle:set(center,r)
	return 	circle;
end
function IFCTRIMMEDCURVE:set(center,r,start_angle,end_angle)
	self[1] = self:create_circle(center,r);
	local st = "IFCPARAMETERVALUE(" .. start_angle .. ")";	
	self[2] = {st};
	local ed = "IFCPARAMETERVALUE(" .. end_angle .. ")";	
	self[3] = {ed};
	self[4] = ".T.";
	self[5] = ".PARAMETER.";
	
end


function IFCTRIMMEDCURVE:get_ent(ents)
	local start_angle = self[2][1][1]
	local end_angle = self[3][1][1]
	local center = self[1]:get_center()
	local radius = self[1]:get_radius()	

	if (string.find(cur_ent_name,"IFCBEAM"))then
		start_angle = start_angle
		end_angle = end_angle
	else
		start_angle = start_angle+180
		end_angle = end_angle+180
	end
				

	local s_x = center.origin.x + radius * math.cos(start_angle*math.pi/180.0)
	local s_y = center.origin.y + radius * math.sin(start_angle*math.pi/180.0)
	local e_x = center.origin.x + radius * math.cos(end_angle*math.pi/180.0)
	local e_y = center.origin.y + radius * math.sin(end_angle*math.pi/180.0)	
	
	local st_pt = {x = s_x,y = s_y,z = 0}
	local en_pt = {x = e_x,y = e_y,z = 0}	

	local ln =  {start_pt = st_pt,end_pt =en_pt}
	table.insert(ents,ln)		
end

--R8.9.3.53
IFCVECTOR = {param = 2, name = "IFCVECTOR"}
--[[ENTITY IfcVector  
 SUBTYPE OF IfcGeometricRepresentationItem;  
	Orientation :  IfcDirection; 
	Magnitude :  IfcLengthMeasure; 
 DERIVE  
	Dim :  IfcDimensionCount := Orientation.Dim; 
 WHERE  
	WR1 :  Magnitude >= 0.0 --]]
 
setparent(IFCPLACEMENT, IFCAXIS1PLACEMENT)								--R8.9.3.01
setparent(IFCPLACEMENT, IFCAXIS2PLACEMENT2D)							--R8.9.3.02
setparent(IFCPLACEMENT, IFCAXIS2PLACEMENT3D)							--R8.9.3.03
setparent(IFCBOUNDEDCURVE, IFCPOLYLINE)									--R8.9.3.04
setparent(IFCCURVE, IFCBOUNDEDCURVE)									--R8.9.3.05
setparent(IFCPOINT, IFCCARTESIANPOINT)									--R8.9.3.11
setparent(IFCGEOMETRICREPRESENTATIONITEM, IFCCARTESIANTRANSFORMATIONOPERATOR)
																		--R8.9.3.12
setparent(IFCCARTESIANTRANSFORMATIONOPERATOR, IFCCARTESIANTRANSFORMATIONOPERATOR3D)
																		--R8.9.3.15
setparent(IFCCONIC, IFCCIRCLE)											--R8.9.3.17
setparent(IFCBOUNDEDCURVE, IFCCOMPOSITECURVE)							--R8.9.3.18
setparent(IFCGEOMETRICREPRESENTATIONITEM, IFCCOMPOSITECURVESEGMENT)		--R8.9.3.20
setparent(IFCCURVE, IFCCONIC)											--R8.9.3.21
setparent(IFCGEOMETRICREPRESENTATIONITEM, IFCCURVE)						--R8.9.3.22
setparent(IFCGEOMETRICREPRESENTATIONITEM, IFCDIRECTION)					--R8.9.3.26
setparent(IFCREPRESENTATIONITEM, IFCGEOMETRICREPRESENTATIONITEM)		--R8.9.3.29
setparent(IFCCURVE, IFCLINE)											--R8.9.3.30
setparent(IFCREPRESENTATIONITEM, IFCMAPPEDITEM)							--R8.9.3.31
setparent(IFCGEOMETRICREPRESENTATIONITEM, IFCPLACEMENT)					--R8.9.3.36
setparent(IFCGEOMETRICREPRESENTATIONITEM, IFCPOINT)						--R8.9.3.38
setparent(IFCPOINT, IFCPOINTONCURVE)									--R8.9.3.39
setparent(IFCPOINT, IFCPOINTONSURFACE)									--R8.9.3.40
setparent(IFCGEOMETRICREPRESENTATIONITEM, IFCSURFACE)					--R8.9.3.48
setparent(IFCBOUNDEDCURVE, IFCTRIMMEDCURVE)								--R8.9.3.52
setparent(IFCGEOMETRICREPRESENTATIONITEM, IFCVECTOR)					--R8.9.3.53

--[[
setparent(IFCPLACEMENT, IFCAXIS1PLACEMENT)								--R8.9.3.01
setparent(IFCPLACEMENT, IFCAXIS1PLACEMENT)								--R8.9.3.01
setparent(IFCPLACEMENT, IFCAXIS1PLACEMENT)								--R8.9.3.01
setparent(IFCPLACEMENT, IFCAXIS1PLACEMENT)								--R8.9.3.01
--]]

