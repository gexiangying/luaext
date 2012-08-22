--	8.	IFC Resource Layer	--	8.1 IfcActorResource
require "86IfcExternalReferenceResource" 
setfenv(1,ifc)

--	8.1.2	Type
--R8.1.2.1
--IFCADDRESSTYPEENUM = {}  --IfcAddressTypeEnum = {OFFICE, SITE, HOME, DISTRIBUTIONPOINT, USERDEFINED}
--R8.1.2.2
--IFCROLEENUM = {}  --IfcRoleEnum = { SUPPLIER, 
--[[			MANUFACTURER, 
				CONTRACTOR, 
				SUBCONTRACTOR, 
				ARCHITECT, 
				STRUCTURALENGINEER, 
				COSTENGINEER, 
				CLIENT, 
				BUILDINGOWNER, 
				BUILDINGOPERATOR, 
				MECHANICALENGINEER, 
				ELECTRICALENGINEER, 
				PROJECTMANAGER, 
				FACILITIESMANAGER, 
				CIVILENGINEER, 
				COMMISSIONINGENGINEER, 
				ENGINEER, 
				OWNER, 
				CONSULTANT, 
				CONSTRUCTIONMANAGER, 
				FIELDCONSTRUCTIONMANAGER, 
				RESELLER, 
				USERDEFINED	}--]]						  

--R8.1.2.3
--IFCACTORSELECT = {}  --IfcActorSelect = {}		--SELECT (IfcOrganization, IfcPerson, IfcPersonAndOrganization);  

--	8.1.3	Entities
--R8.1.3.1
IFCACTORROLE = {param = 3, name = "IFCACTORROLE"}  --IfcActorRole = {}		 
--[[	ENTITY IfcActorRole;  
			Role :  IfcRoleEnum; 
			UserDefinedRole :  OPTIONAL IfcLabel; 
			Description :  OPTIONAL IfcText; 
		INVERSE  
			HasExternalReference :  SET OF IfcExternalReferenceRelationship FOR RelatedResourceObjects; 
		WHERE  
			WR1 :  (Role <> IfcRoleEnum.USERDEFINED) OR ((Role = IfcRoleEnum.USERDEFINED) AND EXISTS(SELF.UserDefinedRole)) 
--]]

--R8.1.3.2
IFCADDRESS = {param = 3, name = "IFCADDRESS"}  --IfcAddress = {}		 
--[[	ENTITY IfcAddress  
		ABSTRACT SUPERTYPE OF(ONEOF(IfcPostalAddress, IfcTelecomAddress));  
			Purpose :  OPTIONAL IfcAddressTypeEnum; 
			Description :  OPTIONAL IfcText; 
			UserDefinedPurpose :  OPTIONAL IfcLabel; 
		INVERSE  
			OfPerson :  SET OF IfcPerson FOR Addresses; 
			OfOrganization :  SET OF IfcOrganization FOR Addresses; 
		WHERE  
			WR1 :  (NOT(EXISTS(Purpose))) OR ((Purpose <> IfcAddressTypeEnum.USERDEFINED) OR ((Purpose = IfcAddressTypeEnum.USERDEFINED) AND EXISTS(SELF.UserDefinedPurpose))) 
--]] 

--R8.1.3.3
IFCORGANIZATION = {param = 5, name = "IFCORGANIZATION"}  -- IfcOrganization = {}
--[[	ENTITY IfcOrganization;  
			Identification :  OPTIONAL IfcIdentifier; 
			Name :  IfcLabel; 
			Description :  OPTIONAL IfcText; 
			Roles :  OPTIONAL LIST [1:?] OF IfcActorRole; 
			Addresses :  OPTIONAL LIST [1:?] OF IfcAddress; 
		INVERSE  
			IsRelatedBy :  SET OF IfcOrganizationRelationship FOR RelatedOrganizations; 
			Relates :  SET OF IfcOrganizationRelationship FOR RelatingOrganization; 
			Engages :  SET OF IfcPersonAndOrganization FOR TheOrganization; --]]
function IFCORGANIZATION:set_key(key)
	self.key = key
	self.new_key = key
	self.class_name = "IFCORGANIZATION"
	return self
end

function IFCORGANIZATION:set(info,db)
	local Identification = "$"; 
	local Name = "'Autodesk Revit Structure 2012'"; 
	local Description = "$"; 
	local Roles = "$"; 
	local Addresses = "$"; 
 	self[1] = Identification
	self[2] = Name
	self[3] = Description
	self[4] = Roles
	self[5] = Addresses
 

end
function IFCORGANIZATION:set_kind2(info,db)
	local Identification = "$"; 
	local Name = "''"; 
	local Description = "''"; 
	local Roles = "$"; 
	local Addresses = "$"; 
 	self[1] = Identification
	self[2] = Name
	self[3] = Description
	self[4] = Roles
	self[5] = Addresses
 

end
--R8.1.3.4
IFCORGANIZATIONRELATIONSHIP = {param = 2, name = "IFCORGANIZATIONRELATIONSHIP"}
--[[ENTITY IfcOrganizationRelationship  
 SUBTYPE OF IfcResourceLevelRelationship;  
	RelatingOrganization :  IfcOrganization; 
	RelatedOrganizations :  SET [1:?] OF IfcOrganization; --]]

--R8.1.3.5
IFCPERSON = {param = 8, name = "IFCPERSON"}  --IfcPerson = {}
--[[	ENTITY IfcPerson;  
			Identification :  OPTIONAL IfcIdentifier; 
			FamilyName :  OPTIONAL IfcLabel; 
			GivenName :  OPTIONAL IfcLabel; 
			MiddleNames :  OPTIONAL LIST [1:?] OF IfcLabel; 
			PrefixTitles :  OPTIONAL LIST [1:?] OF IfcLabel; 
			SuffixTitles :  OPTIONAL LIST [1:?] OF IfcLabel; 
			Roles :  OPTIONAL LIST [1:?] OF IfcActorRole; 
			Addresses :  OPTIONAL LIST [1:?] OF IfcAddress; 
		INVERSE  
			EngagedIn :  SET OF IfcPersonAndOrganization FOR ThePerson; 
		WHERE  
			IdentifiablePerson :  EXISTS(Identification) OR EXISTS(FamilyName) OR EXISTS(GivenName) --]]
function IFCPERSON:set_key(key)
	self.key = key
	self.new_key = key
	self.class_name = "IFCPERSON"
	return self
end
function IFCPERSON:set(info,db)
	local Identification = "\$";
	local FamilyName = "\$";
	local GivenName = "'Administrator'"; 
	local MiddleNames = "\$";
	local PrefixTitles = "\$";
	local SuffixTitles = "\$";
	local Roles = "\$";
	local Addresses  = "\$";
 
 
	self[1] = Identification
	self[2] = FamilyName
	self[3] = GivenName
	self[4] = MiddleNames
	self[5] = PrefixTitles
	self[6] = SuffixTitles
	self[7] = Roles
	self[8] = Addresses
end


--R8.1.3.6
IFCPERSONANDORGANIZATION = {param = 3, name = "IFCPERSONANDORGANIZATION"}  --IfcPersonAndOrganization = {}
--[[	ENTITY IfcPersonAndOrganization;  
			ThePerson :  IfcPerson; 
			TheOrganization :  IfcOrganization; 
			Roles :  OPTIONAL LIST [1:?] OF IfcActorRole; --]]

function IFCPERSONANDORGANIZATION:set_key(key)
	self.key = key
	self.new_key = key
	self.class_name = "IFCPERSONANDORGANIZATION"
	return self
end
function IFCPERSONANDORGANIZATION:create_person(info,db)
	local key = get_key();
	local person = new(IFCPERSON);
	person:set_key(key);
	person:set(info,db)	
	
	push_ifc_data(person,db)

	return person

end
function IFCPERSONANDORGANIZATION:create_organization(info,db)
	local key = get_key();
	local org = new(IFCORGANIZATION);
	org:set_key(key);
	org:set_kind2(info,db)	
	
	push_ifc_data(org,db)

	return org

end


function IFCPERSONANDORGANIZATION:set(info,db)
	local ThePerson = self:create_person(info,db); 
	local TheOrganization = self:create_organization(info,db); 
	local Roles = "\$"; 
	
 
	self[1] = ThePerson
	self[2] = TheOrganization
	self[3] = Roles
end

--R8.1.3.7 
IFCPOSTALADDRESS = {param = 7, name = "IFCPOSTALADDRESS"}  --IfcPostalAddress = {}
--[[	ENTITY IfcPostalAddress  
			SUBTYPE OF IfcAddress;  
			InternalLocation :  OPTIONAL IfcLabel; 
			AddressLines :  OPTIONAL LIST [1:?] OF IfcLabel; 
			PostalBox :  OPTIONAL IfcLabel; 
			Town :  OPTIONAL IfcLabel; 
			Region :  OPTIONAL IfcLabel; 
			PostalCode :  OPTIONAL IfcLabel; 
			Country :  OPTIONAL IfcLabel; 
		WHERE  
			WR1 :  EXISTS (InternalLocation) OR EXISTS (AddressLines) OR EXISTS (PostalBox) OR EXISTS (PostalCode) OR EXISTS (Town) OR EXISTS (Region) OR EXISTS (Country) --]]
function IFCPOSTALADDRESS:set()
	self[1] = "$";
	self[2] = "$";
	self[3] = "$";
	self[4] = "$";
	
	self[5] = "'\\X\\C7\\X\\EB\\X\\D4\\X\\DA\\X\\B4\\X\\CB\\X\\B4\\X\\A6\\X\\CA\\X\\E4\\X\\C8\\X\\EB\\X\\B5\\X\\D8\\X\\D6\\X\\B7'";
	self[6] = "$";
	self[7] = "'\\X\\D6\\X\\D0\\X\\B9\\X\\FA\\X\\B1\\X\\B1\\X\\BE\\X\\A9'";
	self[8] = "''";
	self[9] = "''";
	self[10] = "''";
end
--R8.1.3.8
IFCTELECOMADDRESS = {param = 6, name = "IFCTELECOMADDRESS"}  --IfcTelecomAddress = {}
--[[	ENTITY IfcTelecomAddress  
		SUBTYPE OF IfcAddress;  
			TelephoneNumbers :  OPTIONAL LIST [1:?] OF IfcLabel; 
			FacsimileNumbers :  OPTIONAL LIST [1:?] OF IfcLabel; 
			PagerNumber :  OPTIONAL IfcLabel; 
			ElectronicMailAddresses :  OPTIONAL LIST [1:?] OF IfcLabel; 
			WWWHomePageURL :  OPTIONAL IfcURIReference; 
			MessagingIDs :  OPTIONAL LIST [1:?] OF IfcURIReference; 
		 WHERE  
			MinimumDataProvided :  EXISTS (TelephoneNumbers) OR EXISTS (PagerNumber) OR EXISTS (FacsimileNumbers) OR EXISTS (ElectronicMailAddresses) OR EXISTS (WWWHomePageURL) OR EXISTS (MessagingIDs) --]]		 

setparent(IFCRESOURCELEVELRELATIONSHIP, IFCORGANIZATIONRELATIONSHIP)	--R8.1.3.04
setparent(IFCADDRESS, IFCPOSTALADDRESS)									--R8.1.3.07
setparent(IFCADDRESS, IFCTELECOMADDRESS)								--R8.1.3.08
