--	8.	IFC Resource Layer	--	8.14 IfcPresentationOrganizationResource
setfenv(1,ifc)

--	8.14.2	Type

-- 	8.14.3 Entities
--R8.14.3.9
IFCPRESENTATIONLAYERASSIGNMENT = {param =4, name = "IFCPRESENTATIONLAYERASSIGNMENT"} 
--IfcPresentationLayerAssignment = {}
--[[ENTITY IfcPresentationLayerAssignment  
 SUPERTYPE OF(IfcPresentationLayerWithStyle);  
	Name :  IfcLabel; 
	Description :  OPTIONAL IfcText; 
	AssignedItems :  SET [1:?] OF IfcLayeredItem; 
	Identifier :  OPTIONAL IfcIdentifier; 
 WHERE  
	 ApplicableItems :  SIZEOF(QUERY(temp <* AssignedItems | ( SIZEOF(TYPEOF(temp) * [ IFCREPRESENTATIONRESOURCE.IFCSHAPEREPRESENTATION , IFCGEOMETRYRESOURCE.IFCGEOMETRICREPRESENTATIONITEM , IFCGEOMETRYRESOURCE.IFCMAPPEDITEM ]) = 1) )) = SIZEOF(AssignedItems) --]]

--R8.14.3.10
IFCPRESENTATIONLAYERWITHSTYLE = {param = 4, name = "IFCPRESENTATIONLAYERWITHSTYLE"} --IfcPresentationLayerWithStyle = {}
--[[ENTITY IfcPresentationLayerWithStyle  
 SUBTYPE OF IfcPresentationLayerAssignment;  
	LayerOn :  LOGICAL; 
	LayerFrozen :  LOGICAL; 
	LayerBlocked :  LOGICAL; 
	LayerStyles :  SET OF IfcPresentationStyle; 
 WHERE  
	 ApplicableOnlyToItems :  SIZEOF(QUERY(temp <* AssignedItems | ( SIZEOF(TYPEOF(temp) * [ IFCGEOMETRYRESOURCE.IFCGEOMETRICREPRESENTATIONITEM , IFCGEOMETRYRESOURCE.IFCMAPPEDITEM ]) = 1) )) = SIZEOF(AssignedItems) --]]	 
	 
 
setparent(IFCPRESENTATIONLAYERASSIGNMENT, IFCPRESENTATIONLAYERWITHSTYLE)	--R8.14.3.10


--[[
setparent(IfcPresentationLayerWithStyle, IFCPRESENTATIONLAYERASSIGNMENT)	--R8.14.3.09
setparent(IfcPresentationLayerWithStyle, IFCPRESENTATIONLAYERASSIGNMENT)	--R8.14.3.09
setparent(IfcPresentationLayerWithStyle, IFCPRESENTATIONLAYERASSIGNMENT)	--R8.14.3.09
setparent(IfcPresentationLayerWithStyle, IFCPRESENTATIONLAYERASSIGNMENT)	--R8.14.3.09
setparent(IfcPresentationLayerWithStyle, IFCPRESENTATIONLAYERASSIGNMENT)	--R8.14.3.09
setparent(IfcPresentationLayerWithStyle, IFCPRESENTATIONLAYERASSIGNMENT)	--R8.14.3.09
setparent(IfcPresentationLayerWithStyle, IFCPRESENTATIONLAYERASSIGNMENT)	--R8.14.3.09
setparent(IfcPresentationLayerWithStyle, IFCPRESENTATIONLAYERASSIGNMENT)	--R8.14.3.09
setparent(IfcPresentationLayerWithStyle, IFCPRESENTATIONLAYERASSIGNMENT)	--R8.14.3.09
--]]


