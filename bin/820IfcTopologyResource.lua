--	8.	IFC Resource Layer	--	8.20 IfcTopologyResource
setfenv(1,ifc)

--	8.20.2	Type
--R8.20.2.01
IFCSHELL = {IFCCLOSEDSHELL = true, IFCOPENSHELL = true}  

-- 	8.20.3 Entities
--R8.20.3.01
IFCADVANCEDFACE = {param = 0, name = "IFCADVANCEDFACE"}
--[[ENTITY IfcAdvancedFace  
 SUBTYPE OF IfcFaceSurface;  
 WHERE  
	ApplicableSurface :  SIZEOF ( [ IFCGEOMETRYRESOURCE.IFCELEMENTARYSURFACE , IFCGEOMETRYRESOURCE.IFCSWEPTSURFACE , IFCGEOMETRYRESOURCE.IFCBSPLINESURFACE ] * TYPEOF(SELF\IfcFaceSurface.FaceSurface)) = 1 
	RequiresEdgeCurve :  SIZEOF(QUERY (ElpFbnds <* QUERY (Bnds <* SELF\IfcFace.Bounds | IFCTOPOLOGYRESOURCE.IFCEDGELOOP IN TYPEOF(Bnds.Bound)) | NOT (SIZEOF (QUERY (Oe <* ElpFbnds.Bound\IfcEdgeLoop.EdgeList | NOT( IFCTOPOLOGYRESOURCE.IFCEDGECURVE IN TYPEOF(Oe\IfcOrientedEdge.EdgeElement) ))) = 0 ))) = 0 
	ApplicableEdgeCurves :  SIZEOF(QUERY (ElpFbnds <* QUERY (Bnds <* SELF\IfcFace.Bounds | IFCTOPOLOGYRESOURCE.IFCEDGELOOP IN TYPEOF(Bnds.Bound)) | NOT (SIZEOF (QUERY (Oe <* ElpFbnds.Bound\IfcEdgeLoop.EdgeList | NOT (SIZEOF ([ IFCGEOMETRYRESOURCE.IFCLINE , IFCGEOMETRYRESOURCE.IFCCONIC , IFCGEOMETRYRESOURCE.IFCPOLYLINE , IFCGEOMETRYRESOURCE.IFCBSPLINECURVE ] * TYPEOF(Oe\IfcOrientedEdge.EdgeElement\IfcEdgeCurve.EdgeGeometry)) = 1 ) )) = 0 ))) = 0 --]]
	
--R8.20.3.02
IFCCLOSEDSHELL = {param = 0, name = "IFCCLOSEDSHELL"}
--[[ENTITY IfcClosedShell  
 SUBTYPE OF IfcConnectedFaceSet;  --]]
 
--R8.20.3.03
IFCCONNECTEDFACESET = {param = 1, name = "IFCCONNECTEDFACESET"}
--[[function IFCCONNECTEDFACESET:check()
	IFCTOPOLOGICALREPRESENTATIONITEM.check(self)
	check_list_supply(self[1], 3, "IFCFACE", "IfcConnectedFaceSet", "CfsFaces")
end
ENTITY IfcConnectedFaceSet  
 SUPERTYPE OF(ONEOF(IfcClosedShell, IfcOpenShell))  
 SUBTYPE OF IfcTopologicalRepresentationItem;  
	CfsFaces :  SET [1:?] OF IfcFace; --]]
function IFCCONNECTEDFACESET:create_face(info)
	local face = ifcnew(IFCFACE);
	face:set(info)
	return face;
end
local function create_test_faces()
	--local st = info.start_pt;
	--local ed = info.end_pt;
	local fs = { 
					{ points = { {x=0,y=0,z=100},{x=50,y=0,z=100} ,{x=100,y=50,z=100},{x=100,y=100,z=100}  }},
					{ points = { {x=150,y=0,z=100},{x=200,y=0,z=100} ,{x=100,y=100,z=100} ,{x=100,y=50,z=100} }},
					{ points = { {x=0,y=0,z=-100},{x=50,y=0,z=-100} ,{x=100,y=50,z=-100} ,{x=100,y=100,z=-100} }},
					{ points = { {x=150,y=0,z=-100},{x=200,y=0,z=-100} ,{x=100,y=100,z=-100} ,{x=100,y=50,z=-100} }},
	
					{ points = { {x=0,y=0,z=100}, {x=0,y=0,z=-100} ,{x=50,y=0,z=-100},{x=50,y=0,z=100}}},
					{ points = { {x=150,y=0,z=100},{x=150,y=0,z=-100},{x=200,y=0,z=-100},{x=200,y=0,z=100}} },
				}
	return fs;
end
function IFCCONNECTEDFACESET:create_faces(faces,info)
	--NEED_ADD-----------------------------------------	
	--此时根据start点，end点计算出所有的面face，点存在info.points中
	local fs = create_test_faces();	
	for i=1,#fs do
		local face = self:create_face(fs[i]);
		table.insert(faces,face);
	end
	
end
function IFCCONNECTEDFACESET:set(info)
	local faces = {}
	self:create_faces(faces,info)
	self[1] = faces;
end
--R8.20.3.04
IFCEDGE = {param = 2, name = "IFCEDGE"}
--[[ENTITY IfcEdge  
 SUPERTYPE OF(ONEOF(IfcEdgeCurve, IfcOrientedEdge, IfcSubedge))  
 SUBTYPE OF IfcTopologicalRepresentationItem;  
	EdgeStart :  IfcVertex; 
	EdgeEnd :  IfcVertex; --]]
 
--R8.20.3.05
IFCEDGECURVE = {param = 2, name = "IFCEDGECURVE"}
--[[ENTITY IfcEdgeCurve  
 SUBTYPE OF IfcEdge;  
	EdgeGeometry :  IfcCurve; 
	SameSense :  BOOLEAN; --]]

--R8.20.3.06
IFCEDGELOOP = {param = 1, name = "IFCEDGELOOP"}
--[[ENTITY IfcEdgeLoop  
 SUBTYPE OF IfcLoop;  
	EdgeList :  LIST [1:?] OF IfcOrientedEdge; 
 DERIVE  
	Ne :  INTEGER := SIZEOF(EdgeList); 
 WHERE  
	WR1 :  (EdgeList[1].EdgeStart) :=: (EdgeList[Ne].EdgeEnd) 
	WR2 :  IfcLoopHeadToTail(SELF) --]]

--R8.20.3.07
IFCFACE = {param = 1, name = "IFCFACE"}
--[[ENTITY IfcFace  
 SUPERTYPE OF(IfcFaceSurface)  
 SUBTYPE OF IfcTopologicalRepresentationItem;  
	Bounds :  SET [1:?] OF IfcFaceBound; 
 WHERE  
	WR1 :  SIZEOF(QUERY(temp <* Bounds | IFCGEOMETRYRESOURCE.IFCFACEOUTERBOUND IN TYPEOF(temp))) <= 1 --]]
function IFCFACE:create_face_outer_bound(info)
	local face_outer = ifcnew(IFCFACEOUTERBOUND);
	face_outer:set(info)
	return face_outer
end
function IFCFACE:set(info)
	local fs = {}
	local face_out_bound = self:create_face_outer_bound(info);
	table.insert(fs,face_out_bound);
	self[1] = fs
	
end
--R8.20.3.08
IFCFACEBOUND = {param = 2, name = "IFCFACEBOUND"}
--[[ENTITY IfcFaceBound  
 SUPERTYPE OF(IfcFaceOuterBound)  
 SUBTYPE OF IfcTopologicalRepresentationItem;  
	Bound :  IfcLoop; 
	Orientation :  BOOLEAN; --]]
function IFCFACEBOUND:create_poly_loop(info)
	local poly_loop = ifcnew(IFCPOLYLOOP);
	poly_loop:set(info.points)
	return poly_loop
end

function IFCFACEBOUND:set(info)
	local poly_loop = self:create_poly_loop(info);
	self[1] = poly_loop
	self[2] = ".T."
	
end
--R8.20.3.09
IFCFACEOUTERBOUND = {param = 0, name = "IFCFACEOUTERBOUND"}
--[[ENTITY IfcFaceOuterBound  
 SUBTYPE OF IfcFaceBound;  --]]

--R8.20.3.10
IFCFACESURFACE = {param = 2, name = "IFCFACESURFACE"}
--[[ENTITY IfcFaceSurface  
 SUPERTYPE OF(IfcAdvancedFace)  
 SUBTYPE OF IfcFace;  
	FaceSurface :  IfcSurface; 
	SameSense :  BOOLEAN; --]]

--R8.20.3.11
IFCLOOP = {param = 0, name = "IFCLOOP"}
--[[ENTITY IfcLoop  
 SUPERTYPE OF(ONEOF(IfcEdgeLoop, IfcPolyLoop, IfcVertexLoop))  
 SUBTYPE OF IfcTopologicalRepresentationItem; --]]

--R8.20.3.12
IFCOPENSHELL = {param = 0, name = "IFCOPENSHELL"}
--[[ENTITY IfcOpenShell  
 SUBTYPE OF IfcConnectedFaceSet;  --]]

--R8.20.3.13
IFCORIENTEDEDGE = {param = 2, name = "IFCORIENTEDEDGE"}
--[[ENTITY IfcOrientedEdge  
 SUBTYPE OF IfcEdge;  
	EdgeElement :  IfcEdge; 
	Orientation :  BOOLEAN; 
 DERIVE  
	SELF\IfcEdge.EdgeStart :  IfcVertex := IfcBooleanChoose (Orientation, EdgeElement.EdgeStart, EdgeElement.EdgeEnd); 
	SELF\IfcEdge.EdgeEnd :  IfcVertex := IfcBooleanChoose (Orientation, EdgeElement.EdgeEnd, EdgeElement.EdgeStart); 
 WHERE  
	WR1 :  NOT( IFCTOPOLOGYRESOURCE.IFCORIENTEDEDGE IN TYPEOF(EdgeElement)) --]]

--R8.20.3.14
IFCPATH = {param = 1, name = "IFCPATH"}
--[[ENTITY IfcPath  
 SUBTYPE OF IfcTopologicalRepresentationItem;  
	EdgeList :  LIST [1:?] OF UNIQUE IfcOrientedEdge; 
 WHERE  
	WR1 :  IfcPathHeadToTail(SELF) --]]

--R8.20.3.15
IFCPOLYLOOP = {param = 1, name = "IFCPOLYLOOP"}
--[[ENTITY IfcPolyLoop  
 SUBTYPE OF IfcLoop;  
	Polygon :  LIST [3:?] OF UNIQUE IfcCartesianPoint; 
 WHERE  
	WR21 :  SIZEOF(QUERY(Temp <* Polygon | Temp.Dim <> Polygon[1].Dim)) = 0 --]]
function IFCPOLYLOOP:create_cartesian_points(points,pts)
	for i=1,#points do
		local pt = create_cartesian_point(points[i])
		pts[i] = pt;
	end
end
function IFCPOLYLOOP:set(points)
	local pts = {};
	self:create_cartesian_points(points,pts); 
	self[1] = pts;
	
end

--R8.20.3.16
IFCSUBEDGE = {param = 1, name = "IFCSUBEDGE"}
--[[ENTITY IfcSubedge  
 SUBTYPE OF IfcEdge;  
	ParentEdge :  IfcEdge; --]]

--R8.20.3.17
IFCTOPOLOGICALREPRESENTATIONITEM = {param = 0, name = "IFCTOPOLOGICALREPRESENTATIONITEM"}
--[[ENTITY IfcTopologicalRepresentationItem  
 ABSTRACT SUPERTYPE OF(ONEOF(IfcConnectedFaceSet, IfcEdge, IfcFace, IfcFaceBound, IfcLoop, IfcPath, IfcVertex))  
 SUBTYPE OF IfcRepresentationItem; --]]

--R8.20.3.18
IFCVERTEX = {param = 0, name = "IFCVERTEX"}
--[[ENTITY IfcVertex  
 SUPERTYPE OF(IfcVertexPoint)  
 SUBTYPE OF IfcTopologicalRepresentationItem;  --]]

--R8.20.3.19
IFCVERTEXLOOP = {param = 1, name = "IFCVERTEXLOOP"}
--[[ENTITY IfcVertexLoop  
 SUBTYPE OF IfcLoop;  
	LoopVertex :  IfcVertex; --]]

--R8.20.3.20
IFCVERTEXPOINT = {param = 1, name = "IFCVERTEXPOINT"}
--[[ENTITY IfcVertexPoint  
 SUBTYPE OF IfcVertex;  
	VertexGeometry :  IfcPoint; --]]

setparent(IFCFACESURFACE, IFCADVANCEDFACE)								--R8.20.3.01
setparent(IFCCONNECTEDFACESET, IFCCLOSEDSHELL)							--R8.20.3.02
setparent(IFCTOPOLOGICALREPRESENTATIONITEM, IFCCONNECTEDFACESET)		--R8.20.3.03
setparent(IFCTOPOLOGICALREPRESENTATIONITEM, IFCEDGE)					--R8.20.3.04
setparent(IFCEDGE, IFCEDGECURVE)										--R8.20.3.05
setparent(IFCLOOP, IFCEDGELOOP)											--R8.20.3.06
setparent(IFCTOPOLOGICALREPRESENTATIONITEM, IFCFACE)					--R8.20.3.07
setparent(IFCTOPOLOGICALREPRESENTATIONITEM, IFCFACEBOUND)				--R8.20.3.08
setparent(IFCFACEBOUND, IFCFACEOUTERBOUND)								--R8.20.3.09
setparent(IFCFACE, IFCFACESURFACE)										--R8.20.3.10
setparent(IFCTOPOLOGICALREPRESENTATIONITEM, IFCLOOP)					--R8.20.3.11
setparent(IFCCONNECTEDFACESET, IFCOPENSHELL)							--R8.20.3.12
setparent(IFCEDGE, IFCORIENTEDEDGE)										--R8.20.3.13
setparent(IFCTOPOLOGICALREPRESENTATIONITEM, IFCPATH)					--R8.20.3.14
setparent(IFCLOOP, IFCPOLYLOOP)											--R8.20.3.15
setparent(IFCEDGE, IFCSUBEDGE)											--R8.20.3.16
setparent(IFCREPRESENTATIONITEM, IFCTOPOLOGICALREPRESENTATIONITEM)		--R8.20.3.17
setparent(IFCTOPOLOGICALREPRESENTATIONITEM, IFCVERTEX)					--R8.20.3.18
setparent(IFCLOOP, IFCVERTEXLOOP)										--R8.20.3.19
setparent(IFCVERTEX, IFCVERTEXPOINT)									--R8.20.3.20


