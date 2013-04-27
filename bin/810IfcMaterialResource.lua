--	8. IFC Resource Layer 8.10 IfcMaterialResource
setfenv(1,ifc)

--	8.10.2 Type

--	8.10.3 Entities
----R8.10.3.1
IFCMATERIAL = {param = 3, name = "IFCMATERIAL"}  --IfcMaterial = {}
--[[ENTITY IfcMaterial  
 SUBTYPE OF IfcMaterialDefinition;  
	Name :  IfcLabel; 
	Description :  OPTIONAL IfcText; 
	Category :  OPTIONAL IfcLabel; 
 INVERSE  
	HasRepresentation :  SET [0:1] OF IfcMaterialDefinitionRepresentation FOR 
		RepresentedMaterial; 
	IsRelatedWith :  SET OF IfcMaterialRelationship FOR RelatedMaterials; 
	RelatesTo :  SET [0:1] OF IfcMaterialRelationship FOR RelatingMaterial; 
END_ENTITY;--]]

--R8.10.3.3
IFCMATERIALCONSTITUENT = {param =5, name = "IFCMATERIALCONSTITUENT"}  --IfcMaterialConstituent = {} 
--[[ENTITY IfcMaterialConstituent  
 SUBTYPE OF IfcMaterialDefinition;  
	Name :  OPTIONAL IfcLabel; 
	Description :  OPTIONAL IfcText; 
	Material :  IfcMaterial; 
	Fraction :  OPTIONAL IfcNormalisedRatioMeasure; 
	Category :  OPTIONAL IfcLabel; 
 INVERSE  
	ToMaterialConstituentSet :  IfcMaterialConstituentSet FOR MaterialConstituents; 
END_ENTITY; --]] 

--R8.10.3.4
IFCMATERIALCONSTITUENTSET = {param = 3, name = "IFCMATERIALCONSTITUENTSET"}  --IfcMaterialConstituentSet = {} 
--[[ENTITY IfcMaterialConstituentSet  
 SUBTYPE OF IfcMaterialDefinition;  
	Name :  OPTIONAL IfcLabel; 
	Description :  OPTIONAL IfcText; 
	MaterialConstituents :  OPTIONAL SET [1:?] OF IfcMaterialConstituent; 
END_ENTITY;--]]  

-- R8.10.3.5
IFCMATERIALDEFINITION = {param =0, name = "IFCMATERIALDEFINITION"}  --IfcMaterialDefinition = {} 
--[[ENTITY IfcMaterialDefinition  
 ABSTRACT SUPERTYPE OF(ONEOF(IfcMaterial, IfcMaterialConstituent, 
	IfcMaterialConstituentSet, IfcMaterialLayer, IfcMaterialLayerSet, IfcMaterialProfile, 
	IfcMaterialProfileSet));  
 INVERSE  
	AssociatedTo :  SET [0:?] OF IfcRelAssociatesMaterial FOR RelatingMaterial; 
	HasExternalReferences :  SET OF IfcExternalReferenceRelationship FOR 	
		RelatedResourceObjects; 
	HasProperties :  SET OF IfcMaterialProperties FOR Material; 
END_ENTITY;  --]]

--R8.10.3.6
IFCMATERIALLAYER = {param = 7, name = "IFCMATERIALLAYER"}  --IfcMaterialLayer = {} 
--[[ENTITY IfcMaterialLayer  
 SUPERTYPE OF(IfcMaterialLayerWithOffsets)  
 SUBTYPE OF IfcMaterialDefinition;  
	Material :  OPTIONAL IfcMaterial; 
	LayerThickness :  IfcNonNegativeLengthMeasure; 
	IsVentilated :  OPTIONAL IfcLogical; 
	Name :  OPTIONAL IfcLabel; 
	Description :  OPTIONAL IfcText; 
	Category :  OPTIONAL IfcLabel; 
	Priority :  OPTIONAL IfcNormalisedRatioMeasure; 
 INVERSE  
	ToMaterialLayerSet :  IfcMaterialLayerSet FOR MaterialLayers; 
END_ENTITY; --]] 

--R8.10.3.7
IFCMATERIALLAYERSET = {param = 3, name = "IFCMATERIALLAYERSET"}  --IfcMaterialLayerSet = {} 
--[[ENTITY IfcMaterialLayerSet  
 SUBTYPE OF IfcMaterialDefinition;  
	MaterialLayers :  LIST [1:?] OF IfcMaterialLayer; 
	LayerSetName :  OPTIONAL IfcLabel; 
	Description :  OPTIONAL IfcText; 
 DERIVE  
	TotalThickness :  IfcLengthMeasure := IfcMlsTotalThickness(SELF); 
END_ENTITY; --]] 

--R8.10.3.8 
IFCMATERIALLAYERSETUSAGE = {param = 5, name = "IFCMATERIALLAYERSETUSAGE"} 
--[[ENTITY IfcMaterialLayerSetUsage  
 SUBTYPE OF IfcMaterialUsageDefinition;  
 ForLayerSet :  IfcMaterialLayerSet; 
LayerSetDirection :  IfcLayerSetDirectionEnum; 
DirectionSense :  IfcDirectionSenseEnum; 
OffsetFromReferenceLine :  IfcLengthMeasure; 
ReferenceExtent :  OPTIONAL IfcPositiveLengthMeasure; 
 
END_ENTITY;  
--]]



--R8.10.3.11
IFCMATERIALPROFILE = {param =6, name = "IFCMATERIALPROFILE"}  --IfcMaterialProfile = {}  
--[[ENTITY IfcMaterialProfile  
 SUPERTYPE OF(IfcMaterialProfileWithOffsets)  
 SUBTYPE OF IfcMaterialDefinition;  
	Name :  OPTIONAL IfcLabel; 
	Description :  OPTIONAL IfcText; 
	Material :  OPTIONAL IfcMaterial; 
	Profile :  IfcProfileDef; 
	Priority :  OPTIONAL IfcNormalisedRatioMeasure; 
	Category :  OPTIONAL IfcLabel; 
 INVERSE  
	ToMaterialProfileSet :  IfcMaterialProfileSet FOR MaterialProfiles; 
END_ENTITY; --]] 

--R8.10.3.12
IFCMATERIALPROFILESET = {param =4, name = "IFCMATERIALPROFILESET"}  --IfcMaterialProfileSet = {} 
--[[ENTITY IfcMaterialProfileSet  
 SUBTYPE OF IfcMaterialDefinition;  
	Name :  OPTIONAL IfcLabel; 
	Description :  OPTIONAL IfcText; 
	MaterialProfiles :  LIST [1:?] OF IfcMaterialProfile; 
	CompositeProfile :  OPTIONAL IfcCompositeProfileDef; 
END_ENTITY;--]]  

setparent(IFCMATERIALDEFINITION, IFCMATERIAL)						--R8.10.3.01
setparent(IFCMATERIALDEFINITION, IFCMATERIALCONSTITUENT)			--R8.10.3.03
setparent(IFCMATERIALDEFINITION, IFCMATERIALCONSTITUENTSET) 		--R8.10.3.04
setparent(IFCMATERIALDEFINITION, IFCMATERIALLAYER)  				--R8.10.3.06
setparent(IFCMATERIALDEFINITION, IFCMATERIALLAYERSET)  				--R8.10.3.07
setparent(IFCMATERIALDEFINITION, IFCMATERIALPROFILE)				--R8.10.3.11  
setparent(IFCMATERIALDEFINITION, IFCMATERIALPROFILESET)  			--R8.10.3.12

setparent(IFCMATERIALDEFINITION, IFCMATERIALLAYERSETUSAGE)  			--R8.10.3.8













