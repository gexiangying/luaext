--	8.	IFC Resource Layer	--	8.17 IfcQuantityResource
setfenv(1,ifc)

-- 	8.17.2 Entities
--R8.17.2.2
IFCPHYSICALQUANTITY = {param = 2, name = "IFCPHYSICALQUANTITY"} --IfcPhysicalQuantity = {}
--[[ENTITY IfcPhysicalQuantity  
 ABSTRACT SUPERTYPE OF(ONEOF(IfcPhysicalComplexQuantity, IfcPhysicalSimpleQuantity));  
	Name :  IfcLabel; 
	Description :  OPTIONAL IfcText; 
 INVERSE  
	HasExternalReferences :  SET OF IfcExternalReferenceRelationship FOR RelatedResourceObjects; 
	PartOfComplex :  SET OF IfcPhysicalComplexQuantity FOR HasQuantities; --]]

--R8.17.2.3
IFCPHYSICALSIMPLEQUANTITY = {param = 1, name = "IFCPHYSICALSIMPLEQUANTITY"} --IfcPhysicalSimpleQuantity = {}
--[[ENTITY IfcPhysicalSimpleQuantity  
 ABSTRACT SUPERTYPE OF(ONEOF(IfcQuantityArea, IfcQuantityCount, IfcQuantityLength, IfcQuantityTime, IfcQuantityVolume, IfcQuantityWeight))  
 SUBTYPE OF IfcPhysicalQuantity;  
	Unit :  OPTIONAL IfcNamedUnit; --]]

--R8.17.2.4
IFCQUANTITYAREA = {param = 2, name = "IFCQUANTITYAREA"} --IfcQuantityArea = {}
--[[ENTITY IfcQuantityArea  
 SUBTYPE OF IfcPhysicalSimpleQuantity;  
	AreaValue :  IfcAreaMeasure; 
	Formula :  OPTIONAL IfcLabel; 
 WHERE  
	WR21 :  NOT(EXISTS(SELF\IfcPhysicalSimpleQuantity.Unit)) OR (SELF\IfcPhysicalSimpleQuantity.Unit.UnitType = IfcUnitEnum.AREAUNIT) 
	WR22 :  AreaValue >= 0. --]]

--R8.17.2.6
IFCQUANTITYLENGTH = {param = 2, name = "IFCQUANTITYLENGTH"} --IfcQuantityLength = {}
--[[ENTITY IfcQuantityLength  
 SUBTYPE OF IfcPhysicalSimpleQuantity;  
	LengthValue :  IfcLengthMeasure; 
	Formula :  OPTIONAL IfcLabel; 
 WHERE  
	WR21 :  NOT(EXISTS(SELF\IfcPhysicalSimpleQuantity.Unit)) OR (SELF\IfcPhysicalSimpleQuantity.Unit.UnitType = IfcUnitEnum.LENGTHUNIT) 
	WR22 :  LengthValue >= 0. --]]

--R8.17.2.8
IFCQUANTITYVOLUME = {param =2, name = "IFCQUANTITYVOLUME"} --IfcQuantityVolume = {}
--[[ENTITY IfcQuantityVolume  
 SUBTYPE OF IfcPhysicalSimpleQuantity;  
	VolumeValue :  IfcVolumeMeasure; 
	Formula :  OPTIONAL IfcLabel; 
 WHERE  
	WR21 :  NOT(EXISTS(SELF\IfcPhysicalSimpleQuantity.Unit)) OR (SELF\IfcPhysicalSimpleQuantity.Unit.UnitType = IfcUnitEnum.VOLUMEUNIT) 
	WR22 :  VolumeValue >= 0. --]]

--R8.17.2.9
IFCQUANTITYWEIGHT = {param = 2, name = "IFCQUANTITYWEIGHT"} --IfcQuantityWeight = {}
--[[ENTITY IfcQuantityWeight  
 SUBTYPE OF IfcPhysicalSimpleQuantity;  
	WeightValue :  IfcMassMeasure; 
	Formula :  OPTIONAL IfcLabel; 
 WHERE  
	WR21 :  NOT(EXISTS(SELF\IfcPhysicalSimpleQuantity.Unit)) OR (SELF\IfcPhysicalSimpleQuantity.Unit.UnitType = IfcUnitEnum.MASSUNIT) 
	WR22 :  WeightValue >= 0. --]]



setparent(IFCPHYSICALQUANTITY, IFCPHYSICALSIMPLEQUANTITY)				--R8.17.2.03
setparent(IFCPHYSICALSIMPLEQUANTITY, IFCQUANTITYAREA)					--R8.17.2.04
setparent(IFCPHYSICALSIMPLEQUANTITY, IFCQUANTITYLENGTH)					--R8.17.2.06
setparent(IFCPHYSICALSIMPLEQUANTITY, IFCQUANTITYVOLUME)					--R8.17.2.08
setparent(IFCPHYSICALSIMPLEQUANTITY, IFCQUANTITYWEIGHT)					--R8.17.2.09


--[[
setparent(IfcPhysicalSimpleQuantity, IFCQUANTITYLENGTH)					--R8.17.2.06
setparent(IfcPhysicalSimpleQuantity, IFCQUANTITYLENGTH)					--R8.17.2.06
setparent(IfcPhysicalSimpleQuantity, IFCQUANTITYLENGTH)					--R8.17.2.06
setparent(IfcPhysicalSimpleQuantity, IFCQUANTITYLENGTH)					--R8.17.2.06
setparent(IfcPhysicalSimpleQuantity, IFCQUANTITYLENGTH)					--R8.17.2.06
setparent(IfcPhysicalSimpleQuantity, IFCQUANTITYLENGTH)					--R8.17.2.06
--]]



