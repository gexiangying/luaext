--	8. IFC Resource Layer	--	8.7 IfcGeometricConstraintResource
setfenv(1,ifc)

local tools_ = require "steel_tools"

--	8.7.2 Type
--R8.7.2.1
--IFCCURVEOREDGECURVE
--[[TYPE IfcCurveOrEdgeCurve = SELECT (  
	IfcBoundedCurve, 
	IfcEdgeCurve);  
END_TYPE;  --]]

--R8.7.2.2
--IFCGRIDPLACEMENTDIRECTIONSELECT = {}  --IfcGridPlacementDirectionSelect = {}	--select(IfcVirtualGridIntersection, IfcDirection)  

--R8.7.2.3
--IFCPOINTORVERTEXPOINT
--[[TYPE IfcPointOrVertexPoint = SELECT (  
 IfcPoint, 
IfcVertexPoint);  
END_TYPE;--]]

--R8.7.2.4
--[[TYPE IfcSolidOrShell = SELECT (  
 IfcSolidModel, 
IfcClosedShell);  
END_TYPE;  --]]

--R8.7.2.5
--IFCSURFACEORFACESURFACE
--[[TYPE IfcSurfaceOrFaceSurface = SELECT (  
 IfcSurface, 
IfcFaceSurface, 
IfcFaceBasedSurfaceModel);  
END_TYPE;  --]]

--	8.7.3 Entities
--R8.7.3.1
IFCCONNECTIONCURVEGEOMETRY = {param =2, name = "IFCCONNECTIONCURVEGEOMETRY"} 
--[[ENTITY IfcConnectionCurveGeometry  
 SUBTYPE OF IfcConnectionGeometry;  
	CurveOnRelatingElement :  IfcCurveOrEdgeCurve; 
	CurveOnRelatedElement :  OPTIONAL IfcCurveOrEdgeCurve; --]]

--R8.7.3.2
IFCCONNECTIONGEOMETRY = {param =0, name = "IFCCONNECTIONGEOMETRY"} 
--[[ENTITY IfcConnectionGeometry  
 ABSTRACT SUPERTYPE OF(ONEOF(IfcConnectionCurveGeometry, IfcConnectionPointGeometry, IfcConnectionSurfaceGeometry, IfcConnectionVolumeGeometry));  --]]

--R8.7.3.3
IFCCONNECTIONPOINTECCENTRICITY = {param =3, name = "IFCCONNECTIONPOINTECCENTRICITY"} 
--[[ENTITY IfcConnectionPointEccentricity  
 SUBTYPE OF IfcConnectionPointGeometry;  
	EccentricityInX :  OPTIONAL IfcLengthMeasure; 
	EccentricityInY :  OPTIONAL IfcLengthMeasure; 
	EccentricityInZ :  OPTIONAL IfcLengthMeasure; --]]

--R8.7.3.4
IFCCONNECTIONPOINTGEOMETRY = {param =2, name = "IFCCONNECTIONPOINTGEOMETRY"} 
--[[ENTITY IfcConnectionPointGeometry  
 SUPERTYPE OF(IfcConnectionPointEccentricity)  
 SUBTYPE OF IfcConnectionGeometry;  
	PointOnRelatingElement :  IfcPointOrVertexPoint; 
	PointOnRelatedElement :  OPTIONAL IfcPointOrVertexPoint; --]]

--R8.7.3.5
IFCCONNECTIONSURFACEGEOMETRY = {param =2, name = "IFCCONNECTIONSURFACEGEOMETRY"} 
--[[ENTITY IfcConnectionSurfaceGeometry  
 SUBTYPE OF IfcConnectionGeometry;  
	SurfaceOnRelatingElement :  IfcSurfaceOrFaceSurface; 
	SurfaceOnRelatedElement :  OPTIONAL IfcSurfaceOrFaceSurface; --]]

--R8.7.3.6
IFCCONNECTIONVOLUMEGEOMETRY = {param =2, name = "IFCCONNECTIONVOLUMEGEOMETRY"} 
--[[ENTITY IfcConnectionVolumeGeometry  
 SUBTYPE OF IfcConnectionGeometry;  
	VolumeOnRelatingElement :  IfcSolidOrShell; 
	VolumeOnRelatedElement :  OPTIONAL IfcSolidOrShell; --]]


--R8.7.3.7
IFCGRIDAXIS = {param =3, name = "IFCGRIDAXIS"}  --IfcGridAxis = {}
--[[	ENTITY IfcGridAxis;  
			AxisTag :  OPTIONAL IfcLabel; 
			AxisCurve :  IfcCurve; 
			SameSense :  IfcBoolean; 
		INVERSE  
			PartOfW :  SET [0:1] OF IfcGrid FOR WAxes; 
			PartOfV :  SET [0:1] OF IfcGrid FOR VAxes; 
			PartOfU :  SET [0:1] OF IfcGrid FOR UAxes; 
			HasIntersections :  SET OF IfcVirtualGridIntersection FOR IntersectingAxes; 
		WHERE  
			WR1 :  AxisCurve.Dim = 2 
			WR2 :  (SIZEOF(PartOfU)=1) XOR (SIZEOF(PartOfV)=1) XOR (SIZEOF(PartOfW)=1) --]]

--R8.7.3.8
IFCGRIDPLACEMENT = {param = 2, name = "IFCGRIDPLACEMENT"}  --IfcGridPlacement = {}
--[[	ENTITY IfcGridPlacement  
		SUBTYPE OF IfcObjectPlacement;  
			PlacementLocation :  IfcVirtualGridIntersection; 
			PlacementRefDirection :  OPTIONAL IfcGridPlacementDirectionSelect; --]]

--R8.7.3.9
IFCLOCALPLACEMENT = {param = 2, name = "IFCLOCALPLACEMENT"}  --IfcLocalPlacement = {}   
--[[	ENTITY IfcLocalPlacement  
		SUBTYPE OF IfcObjectPlacement;  
			PlacementRelTo :  OPTIONAL IfcObjectPlacement; 
			RelativePlacement :  IfcAxis2Placement; 
		WHERE  
			WR21 :  IfcCorrectLocalPlacement(RelativePlacement, PlacementRelTo)  --]]

function IFCLOCALPLACEMENT:get_axis()
	local axis = {}--axis = {origin = {x=0,y=0,z=0},x_axis = {x=0,y=0,z=0},z_axis = {x=0,y=0,z=0}}
	--self[1]
	--self[2]
	return axis
end

----
function IFCLOCALPLACEMENT:placement_relto(t)
	local pos = 1;
	self[pos] = ifcset(self[pos],t,IFCLOCALPLACEMENT);
	return self[pos];
end

--function IFCLOCALPLACEMENT:get_placement_relto()
--	if tools_.ismet(IFCLOCALPLACEMENT,self.placement_relto) then 
--		return self.placement_relto;
--	end
--	if tools_.ismet(IFCLOCALPLACEMENT,self[1]) then 
--		return self[1];
--	end
--end

function IFCLOCALPLACEMENT:relative_placement(t)
	local pos = 2;
	self[pos] = ifcset(self[pos],t,IFCAXIS2PLACEMENT3D);
	return self[pos];
end

--function IFCLOCALPLACEMENT:get_relative_placement()
--	if tools_.ismet(IFCAXIS2PLACEMENT3D,self.relative_placement) then 
--		return self.relative_placement;
--	end
--	if tools_.ismet(IFCAXIS2PLACEMENT3D,self[2]) then 
--		return self[2];
--	end
--end


function IFCLOCALPLACEMENT:set_gaxis(t)
	self:placement_relto("$");
	self:relative_placement{}:set_gaxis(t);
end

--pt1,pt2
function IFCLOCALPLACEMENT:set_gaxis_by_x(t)
	self:placement_relto("$");
	self:relative_placement{}:set_gaxis_by_x(t);
end


function IFCLOCALPLACEMENT:get_gaxis()
	if not tools_.ismet(IFCPLACEMENT,self:relative_placement()) then 
		return 
	end
	local the = self:relative_placement():get_gaxis();
--	if not self:get_placement_relto() or self:get_placement_relto()=="$" then 
	if not tools_.ismet(IFCLOCALPLACEMENT,self:placement_relto()) then 
		return the;
	end
	
	local relto = self:placement_relto():get_gaxis();
	if not relto then return the end;
	the:l2g(relto);
	return the;
end





----

--R8.7.3.10

IFCOBJECTPLACEMENT = {param = 0, name = "IFCOBJECTPLACEMENT"}  --IfcObjectPlacement = {} 
--[[	ENTITY IfcObjectPlacement  
		ABSTRACT SUPERTYPE OF(ONEOF(IfcGridPlacement, IfcLocalPlacement));  
		INVERSE  
			PlacesObject :  SET [1:?] OF IfcProduct FOR ObjectPlacement; 
			ReferencedByPlacements :  SET OF IfcLocalPlacement FOR PlacementRelTo;--]] 

--R8.7.3.11 
IFCVIRTUALGRIDINTERSECTION = {param = 2, name = "IFCVIRTUALGRIDINTERSECTION"}  	--IfcVirtualGridIntersection={}
--[[	ENTITY IfcVirtualGridIntersection;  
			IntersectingAxes :  LIST [2:2] OF UNIQUE IfcGridAxis; 
			OffsetDistances :  LIST [2:3] OF IfcLengthMeasure; --]]

setparent(IFCCONNECTIONGEOMETRY, IFCCONNECTIONCURVEGEOMETRY)			--R8.7.3.01
setparent(IFCCONNECTIONPOINTGEOMETRY, IFCCONNECTIONPOINTECCENTRICITY)	--R8.7.3.03
setparent(IFCCONNECTIONGEOMETRY, IFCCONNECTIONPOINTGEOMETRY)			--R8.7.3.04
setparent(IFCCONNECTIONGEOMETRY, IFCCONNECTIONVOLUMEGEOMETRY)			--R8.7.3.06
setparent(IFCCONNECTIONGEOMETRY, IFCCONNECTIONSURFACEGEOMETRY)			--R8.7.3.05
setparent(IFCOBJECTPLACEMENT, IFCGRIDPLACEMENT)							--R8.7.3.08
setparent(IFCOBJECTPLACEMENT, IFCLOCALPLACEMENT)						--R8.7.3.09
