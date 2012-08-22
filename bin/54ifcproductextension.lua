--	5. IFC Core Layer	--	5.4 IfcProductExtension
local gpt_ = require "g_pt"
--module (...,package.seeall)
setfenv(1,ifc)

--	5.4.2 Type

--R5.4.3 Entities
--R5.4.3.2
IFCBUILDING = {param =3, name = "IFCBUILDING"} --IfcBuilding = {}
--[[ENTITY IfcBuilding  
 SUBTYPE OF IfcSpatialStructureElement;  
	ElevationOfRefHeight :  OPTIONAL IfcLengthMeasure; 
	ElevationOfTerrain :  OPTIONAL IfcLengthMeasure; 
	BuildingAddress :  OPTIONAL IfcPostalAddress; --]]
function IFCBUILDING:set(info)
	self:set_root(info)
	self[5] = "$";
	self[6] = create_geo_rep_context("'Model'");
	self[7] = "$";
	self[8] = "$";
	self[9] =  ".ELEMENT.";
	self[10] = "$";
	self[11] = "$";
	self[12] = create_postal_address();
end
--R5.4.3.3
IFCBUILDINGELEMENT = {param = 0, name = "IFCBUILDINGELEMENT"}  --IfcBuildingElement = {}
--[[	ENTITY IfcBuildingElement  
		ABSTRACT SUPERTYPE OF(ONEOF(IfcBeam, IfcBuildingElementProxy, IfcChimney, IfcColumn, IfcCovering, IfcCurtainWall, IfcDoor, IfcFooting, IfcMember, IfcPile, IfcPlate, IfcRailing, IfcRamp, IfcRampFlight, IfcRoof, IfcShadingDevice, IfcSlab, IfcStair, IfcStairFlight, IfcWall, IfcWindow))  
		SUBTYPE OF IfcElement;  
		INVERSE  
			HasCoverings :  SET OF IfcRelCoversBldgElements FOR RelatingBuildingElement; 
		WHERE  
			MaxOneMaterialAssociation :  SIZEOF (QUERY(temp <* SELF\IfcObjectDefinition.HasAssociations | IFCPRODUCTEXTENSION.IFCRELASSOCIATESMATERIAL IN TYPEOF(temp) )) <= 1 
--]] 

--R5.4.3.4
IFCBUILDINGELEMENTTYPE = {param = 0, name = "IFCBUILDINGELEMENTTYPE"} --IfcBuildingElementType = {}
--[[ENTITY IfcBuildingElementType  
 ABSTRACT SUPERTYPE OF(ONEOF(IfcBeamType, IfcBuildingElementProxyType, IfcChimneyType, IfcColumnType, IfcCoveringType, IfcCurtainWallType, IfcDoorType, IfcFootingType, IfcMemberType, IfcPileType, IfcPlateType, IfcRailingType, IfcRampFlightType, IfcRampType, IfcRoofType, IfcShadingDeviceType, IfcSlabType, IfcStairFlightType, IfcStairType, IfcWallType, IfcWindowType))  
 SUBTYPE OF IfcElementType;  --]]

--R5.4.3.5
IFCBUILDINGSTOREY = {param =1, name = "IFCBUILDINGSTOREY"} --IfcBuildingStorey = {}
--[[ENTITY IfcBuildingStorey  
 SUBTYPE OF IfcSpatialStructureElement;  
	Elevation :  OPTIONAL IfcLengthMeasure; --]]  
function IFCBUILDINGSTOREY:create_local_placement()
	local local_placement = ifcnew(ifc.IFCLOCALPLACEMENT);
	local gaxis = new(gpt_.g_axis,{
		base = new(gpt_.g_pt,{x=0,y=0,z=0});
		x = new(gpt_.g_pt,{x=1,y=0,z=0});
		y = new(gpt_.g_pt,{x=0,y=1,z=0});
		z = new(gpt_.g_pt,{x=0,y=0,z=1});
	});

	local_placement:set_gaxis(gaxis);
	return local_placement
end
function IFCBUILDINGSTOREY:set(info)
--#37=IFCBUILDINGSTOREY('0fSxnmXkb3HAeaD5MFnDv$',#31,'\X\B1\X\EA\X\B8\X\DF 1',$,$,#36,$,$,.ELEMENT.,0.);
--#36=IFCLOCALPLACEMENT(#25,#35);
	self:set_root(info)
	self[5] = "$";
	self[6] = create_local_placement();
	self[7] = "$";
	self[8] = "$";
	self[9] = ".ELEMENT.";
	self[10] = "0.";
	
end
--R5.4.3.8
IFCELEMENT = {param = 1, name = "IFCELEMENT"}  --IfcElement = {Tag = IfcIdentifier}
--[[	ENTITY IfcElement  
		ABSTRACT SUPERTYPE OF(ONEOF(IfcBuildingElement, IfcDistributionElement, IfcElementAssembly, IfcElementComponent, IfcFeatureElement, IfcFurnishingElement, IfcGeographicElement, IfcTransportElement, IfcVirtualElement))  
		SUBTYPE OF IfcProduct;  
			Tag :  OPTIONAL IfcIdentifier; 
		INVERSE  
			FillsVoids :  SET [0:1] OF IfcRelFillsElement FOR RelatedBuildingElement; 
			ConnectedTo :  SET OF IfcRelConnectsElements FOR RelatingElement; 
			IsInterferedByElements :  SET OF IfcRelInterferesElements FOR RelatedElement; 
			InterferesElements :  SET OF IfcRelInterferesElements FOR RelatingElement; 
			HasProjections :  SET OF IfcRelProjectsElement FOR RelatingElement; 
			ReferencedInStructures :  SET OF IfcRelReferencedInSpatialStructure FOR RelatedElements; 
			HasOpenings :  SET OF IfcRelVoidsElement FOR RelatingElement; 
			IsConnectionRealization :  SET OF IfcRelConnectsWithRealizingElements FOR RealizingElements; 
			ProvidesBoundaries :  SET OF IfcRelSpaceBoundary FOR RelatedBuildingElement; 
			ConnectedFrom :  SET OF IfcRelConnectsElements FOR RelatedElement; 
			ContainedInStructure :  SET [0:1] OF IfcRelContainedInSpatialStructure FOR RelatedElements; 
--]]

--R5.4.3.11
IFCELEMENTQUANTITY = {param = 2, name = "IFCELEMENTQUANTITY"} --IfcElementQuantity = {}
--[[ENTITY IfcElementQuantity  
 SUBTYPE OF IfcQuantitySet;  
	MethodOfMeasurement :  OPTIONAL IfcLabel; 
	Quantities :  SET [1:?] OF IfcPhysicalQuantity; 
 WHERE  
	UniqueQuantityNames :  IfcUniqueQuantityNames(Quantities) --]]

--R5.4.3.12
IFCELEMENTTYPE = {param = 1, name = "IFCELEMENTTYPE"} --IfcElementType = {}
--[[ENTITY IfcElementType  
 ABSTRACT SUPERTYPE OF(ONEOF(IfcBuildingElementType, IfcDistributionElementType, IfcElementAssemblyType, IfcElementComponentType, IfcFurnishingElementType, IfcGeographicElementType, IfcTransportElementType))  
 SUBTYPE OF IfcTypeProduct;  
	ElementType :  OPTIONAL IfcLabel;--]]

--R5.4.3.27
IFCRELASSOCIATESMATERIAL = {param = 1, name = "IFCRELASSOCIATESMATERIAL"} --IfcRelAssociatesMaterial = {}
--[[ENTITY IfcRelAssociatesMaterial  
 SUBTYPE OF IfcRelAssociates;  
	RelatingMaterial :  IfcMaterialSelect; 
 WHERE  
	 NoVoidElement :  SIZEOF(QUERY(temp <* SELF\IfcRelAssociates.RelatedObjects | ( IFCPRODUCTEXTENSION.IFCFEATUREELEMENTSUBTRACTION IN TYPEOF(temp)) OR ( IFCPRODUCTEXTENSION.IFCVIRTUALELEMENT IN TYPEOF(temp)) )) = 0 
	AllowedElements :  SIZEOF(QUERY(temp <* SELF\IfcRelAssociates.RelatedObjects | ( SIZEOF(TYPEOF(temp) * [ IFCPRODUCTEXTENSION.IFCELEMENT , IFCPRODUCTEXTENSION.IFCELEMENTTYPE , IFCSHAREDBLDGELEMENTS.IFCWINDOWSTYLE , IFCSHAREDBLDGELEMENTS.IFCDOORSTYLE , IFCSTRUCTURALANALYSISDOMAIN.IFCSTRUCTURALMEMBER , IFCPRODUCTEXTENSION.IFCPORT ]) = 0) )) = 0 --]]

--R5.4.3.32
IFCRELCONTAINEDINSPATIALSTRUCTURE = {param =2, name = "IFCRELCONTAINEDINSPATIALSTRUCTURE"}  --IfcRelContainedInSpatialStructure = {}
--[[ENTITY IfcRelContainedInSpatialStructure  
 SUBTYPE OF IfcRelConnects;  
	RelatedElements :  SET [1:?] OF IfcProduct; 
	RelatingStructure :  IfcSpatialStructureElement; 
 WHERE  
	WR31 :  SIZEOF(QUERY(temp <* RelatedElements | IFCPRODUCTEXTENSION.IFCSPATIALSTRUCTUREELEMENT IN TYPEOF(temp))) = 0 --]] 
function IFCRELCONTAINEDINSPATIALSTRUCTURE:create_building_history()
	local his = get_ent_by_name("IFCBUILDINGSTOREY");
	if(his)then
		return his;
	else	
		local history = ifcnew(ifc.IFCBUILDINGSTOREY);
		local info = {root_name = "'\\X\\B1\\X\\EA\\X\\B8\\X\\DF 1'"}
		history:set(info);
		return history
	end

end
function IFCRELCONTAINEDINSPATIALSTRUCTURE:set(ents,info)
	self:set_root(info)
--[[	local str = "";	
	for k in pairs(ents) do
		str = str .. ents[k].key	
		str = str .. ",";
	end
	str = string.sub(str,1,#str-1);
	str = "(" .. str .. ")";
	self[5] = str;
--]]
	local es = {}
	for k in pairs(ents) do
		table.insert(es,ents[k].result);
	end

	self[5] = es;
	self[6] = self:create_building_history()
	return self;
end
--R5.4.3.42
IFCSITE = {param =5, name = "IFCSITE"} --IfcSite = {}
--[[ENTITY IfcSite  
 SUBTYPE OF IfcSpatialStructureElement;  
	RefLatitude :  OPTIONAL IfcCompoundPlaneAngleMeasure; 
	RefLongitude :  OPTIONAL IfcCompoundPlaneAngleMeasure; 
	RefElevation :  OPTIONAL IfcLengthMeasure; 
	LandTitleNumber :  OPTIONAL IfcLabel; 
	SiteAddress :  OPTIONAL IfcPostalAddress; --]]
function IFCSITE:set(info)
	self:set_root(info)
	self[5] = "''";
	self[6] = create_local_placement();
	self[7] = "$";
	self[8] = "$";
	self[9] = ".ELEMENT.";
	self[10] = "(39,54,57,601318)";
	self[11] = "(116,25,58,795166)";
	self[12] = "-0.";
	self[13] = "$";
	self[14] = "$";
		
end
--R5.4.3.45
IFCSPATIALELEMENT = {param =1, name = "IFCSPATIALELEMENT"} --IfcSpatialElement = {}
--[[ENTITY IfcSpatialElement  
 ABSTRACT SUPERTYPE OF(ONEOF(IfcExternalSpatialStructureElement, IfcSpatialStructureElement, IfcSpatialZone))  
 SUBTYPE OF IfcProduct;  
	LongName :  OPTIONAL IfcLabel; 
 INVERSE  
	ServicedBySystems :  SET OF IfcRelServicesBuildings FOR RelatedBuildings; 
	ReferencesElements :  SET OF IfcRelReferencedInSpatialStructure FOR RelatingStructure; --]]	
	
--R5.4.3.47
IFCSPATIALSTRUCTUREELEMENT = {param =1, name = "IFCSPATIALSTRUCTUREELEMENT"} --IfcSpatialStructureElement = {}
--[[ENTITY IfcSpatialStructureElement  
 ABSTRACT SUPERTYPE OF(ONEOF(IfcBuilding, IfcBuildingStorey, IfcSite, IfcSpace))  
 SUBTYPE OF IfcSpatialElement;  
	CompositionType :  OPTIONAL IfcElementCompositionEnum; 
 INVERSE  
	ContainsElements :  SET OF IfcRelContainedInSpatialStructure FOR RelatingStructure; 
 WHERE  
	WR41 :  (HIINDEX(SELF\IfcObjectDefinition.Decomposes) = 1) AND ( IFCKERNEL.IFCRELAGGREGATES IN TYPEOF(SELF\IfcObjectDefinition.Decomposes[1])) AND (( IFCKERNEL.IFCPROJECT IN TYPEOF (SELF\IfcObjectDefinition.Decomposes[1].RelatingObject)) OR ( IFCPRODUCTEXTENSION.IFCSPATIALSTRUCTUREELEMENT IN TYPEOF (SELF\IfcObjectDefinition.Decomposes[1].RelatingObject)) ) --]]

--R5.4.3.49
IFCTYPEPRODUCT = {param = 2, name = "IFCTYPEPRODUCT"} --IfcTypeProduct = {}
--[[ENTITY IfcTypeProduct  
 SUPERTYPE OF(ONEOF(IfcDoorStyle, IfcElementType, IfcSpatialElementType, IfcWindowStyle))  
 SUBTYPE OF IfcTypeObject;  
	RepresentationMaps :  OPTIONAL LIST [1:?] OF UNIQUE IfcRepresentationMap; 
	Tag :  OPTIONAL IfcLabel; 
 INVERSE  
	ReferencedBy :  SET OF IfcRelAssignsToProduct FOR RelatingProduct; 
 WHERE  
	ApplicableOccurrence :  NOT(EXISTS(SELF\IfcTypeObject.Types[1])) OR (SIZEOF(QUERY(temp <* SELF\IfcTypeObject.Types[1].RelatedObjects | NOT( IFCKERNEL.IFCPRODUCT IN TYPEOF(temp))) ) = 0) --]]
 
 

setparent(IFCSPATIALSTRUCTUREELEMENT, IFCBUILDING)						--R5.4.3.02
setparent(IFCELEMENT, IFCBUILDINGELEMENT)								--R5.4.3.03
setparent(IFCELEMENTTYPE, IFCBUILDINGELEMENTTYPE)						--R5.4.3.04
setparent(IFCSPATIALSTRUCTUREELEMENT, IFCBUILDINGSTOREY)				--R5.4.3.05
setparent(IFCPRODUCT, IFCELEMENT)										--R5.4.3.08
setparent(IFCQUANTITYSET, IFCELEMENTQUANTITY)							--R5.4.3.11
setparent(IFCTYPEPRODUCT, IFCELEMENTTYPE)								--R5.4.3.12
setparent(IFCRELASSOCIATES, IFCRELASSOCIATESMATERIAL)					--R5.4.3.27
setparent(IFCRELCONNECTS, IFCRELCONTAINEDINSPATIALSTRUCTURE)			--R5.4.3.32
setparent(IFCSPATIALSTRUCTUREELEMENT, IFCSITE)							--R5.4.3.42
setparent(IFCPRODUCT, IFCSPATIALELEMENT)								--R5.4.3.45
setparent(IFCSPATIALELEMENT, IFCSPATIALSTRUCTUREELEMENT)				--R5.4.3.47
setparent(IFCTYPEOBJECT, IFCTYPEPRODUCT)								--R5.4.3.49


--[[
setparent(IFCSPATIALELEMENT, IFCSPATIALSTRUCTUREELEMENT)				--R5.4.3.00
setparent(IFCSPATIALELEMENT, IFCSPATIALSTRUCTUREELEMENT)				--R5.4.3.00
setparent(IFCSPATIALELEMENT, IFCSPATIALSTRUCTUREELEMENT)				--R5.4.3.00
setparent(IFCSPATIALELEMENT, IFCSPATIALSTRUCTUREELEMENT)				--R5.4.3.00
setparent(IFCSPATIALELEMENT, IFCSPATIALSTRUCTUREELEMENT)				--R5.4.3.00
setparent(IFCSPATIALELEMENT, IFCSPATIALSTRUCTUREELEMENT)				--R5.4.3.00
setparent(IFCSPATIALELEMENT, IFCSPATIALSTRUCTUREELEMENT)				--R5.4.3.00
setparent(IFCSPATIALELEMENT, IFCSPATIALSTRUCTUREELEMENT)				--R5.4.3.00
--]]


