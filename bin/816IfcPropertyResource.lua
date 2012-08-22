--	8. IFC Resource Layer	--	8.16 IfcPropertyResource
setfenv(1,ifc)

--	8.16.2 Type

--	8.16.3 Entities
--R8.16.3.1
IFCCOMPLEXPROPERTY = {param = 2, name = "IFCCOMPLEXPROPERTY"} --IfcComplexProperty = {}
--[[ENTITY IfcComplexProperty  
 SUBTYPE OF IfcProperty;  
	UsageName :  IfcIdentifier; 
	HasProperties :  SET [1:?] OF IfcProperty; 
 WHERE  
	WR21 :  SIZEOF(QUERY(temp <* HasProperties | SELF :=: temp)) = 0 
	WR22 :  IfcUniquePropertyName(HasProperties) --]]

--R8.16.3.4
IFCPROPERTY = {param =2, name = "IFCPROPERTY"} --IfcProperty = {}  
--[[	ENTITY IfcProperty  
		ABSTRACT SUPERTYPE OF(ONEOF(IfcComplexProperty, IfcSimpleProperty))  
		SUBTYPE OF IfcPropertyAbstraction;  
			Name :  IfcIdentifier; 
			Description :  OPTIONAL IfcText; 
		INVERSE  
			PartOfPset :  SET OF IfcPropertySet FOR HasProperties; 
			PropertyForDependance :  SET OF IfcPropertyDependencyRelationship FOR DependingProperty; 
			PropertyDependsOn :  SET OF IfcPropertyDependencyRelationship FOR DependantProperty; 
			PartOfComplex :  SET OF IfcComplexProperty FOR HasProperties; 	--]]

--R8.16.3.5
IFCPROPERTYABSTRACTION = {param = 0, name = "IFCPROPERTYABSTRACTION"} --IfcPropertyAbstraction = {}
--[[	ENTITY IfcPropertyAbstraction  
		ABSTRACT SUPERTYPE OF(ONEOF(IfcExtendedProperties, IfcPreDefinedProperties, IfcProperty, IfcPropertyEnumeration));  
		INVERSE  
			HasExternalReferences :  SET OF IfcExternalReferenceRelationship FOR RelatedResourceObjects; 
--]]
function IFCPROPERTY:set(name,descript)
	self[1] = name;
	self[2] = descript;
end
--R8.16.3.12
IFCPROPERTYSINGLEVALUE = {param = 2, name = "IFCPROPERTYSINGLEVALUE"} --IfcPropertySingleValue = {}
--[[ENTITY IfcPropertySingleValue  
 SUBTYPE OF IfcSimpleProperty;  
	NominalValue :  OPTIONAL IfcValue; 
	Unit :  OPTIONAL IfcUnit; --]]

function IFCPROPERTYSINGLEVALUE:set(name,descript,val,unit)
	IFCPROPERTY.set(self,name,descript);
	self[3] = val
	self[4] = unit
end

--R8.16.3.14
IFCSIMPLEPROPERTY = {param = 0, name = "IFCSIMPLEPROPERTY"} --IfcSimpleProperty = {}
--[[ENTITY IfcSimpleProperty  
 ABSTRACT SUPERTYPE OF(ONEOF(IfcPropertyBoundedValue, IfcPropertyEnumeratedValue, IfcPropertyListValue, IfcPropertyReferenceValue, IfcPropertySingleValue, IfcPropertyTableValue))  
 SUBTYPE OF IfcProperty; --]]

setparent(IFCPROPERTY, IFCCOMPLEXPROPERTY)								--R8.16.3.01
setparent(IFCPROPERTYABSTRACTION, IFCPROPERTY)							--R8.16.3.04
setparent(IFCSIMPLEPROPERTY, IFCPROPERTYSINGLEVALUE)					--R8.16.3.12
setparent(IFCPROPERTY, IFCSIMPLEPROPERTY)								--R8.16.3.14


--[[
setparent(IFCPROPERTYABSTRACTION, IFCPROPERTY)							--R8.16.3.04
setparent(IFCPROPERTYABSTRACTION, IFCPROPERTY)							--R8.16.3.04
setparent(IFCPROPERTYABSTRACTION, IFCPROPERTY)							--R8.16.3.04
setparent(IFCPROPERTYABSTRACTION, IFCPROPERTY)							--R8.16.3.04
setparent(IFCPROPERTYABSTRACTION, IFCPROPERTY)							--R8.16.3.04
setparent(IFCPROPERTYABSTRACTION, IFCPROPERTY)							--R8.16.3.04
--]]

