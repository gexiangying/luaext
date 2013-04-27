--	8. IFC Resource Layer	--	8.21 IfcUtilityResource
setfenv(1,ifc)

--	8.21.2	Type

--R8.21.2.1 
--IFCGLOBALLYUNIQUEID = string --IfcGloballyUniqueId = string		--(Unique)		  	
--R8.21.2.2
--IFCCHANGEACTIONENUM = {} --IfcChangeActionEnum = { NOCHANGE, MODIFIED, ADDED, DELETED, NOTDEFINED}  
--R8.21.2.3 
--IFCSTATEENUM = {} --IfcStateEnum = { READWRITE, READONLY, LOCKED, READWRITELOCKED, READONLYLOCKED}	

--R8.21.3	Entities
--R8.21.3.1
IFCAPPLICATION = {param = 4, name = "IFCAPPLICATION"} --IfcApplication = {}
--[[	ENTITY IfcApplication;  
			ApplicationDeveloper :  IfcOrganization; 
			Version :  IfcLabel; 
			ApplicationFullName :  IfcLabel; 
			ApplicationIdentifier :  IfcIdentifier; 
		UNIQUE  
			UR1 :  ApplicationIdentifier; 
			UR2 :  ApplicationFullName, Version; --]]
function IFCAPPLICATION:set_key(key)
	self.key = key
	self.new_key = key
	self.class_name = "IFCAPPLICATION"
	return self
end

function IFCAPPLICATION:create_organization(info,db)
	local key = get_key();
	local org = new(IFCORGANIZATION);
	org:set_key(key);
	org:set(info,db)	
	
	push_ifc_data(org,db)
	return org
end


function IFCAPPLICATION:set(info,db)
	local ApplicationDeveloper = self:create_organization(info,db);
	local Version = "'2012'";
	local ApplicationFullName = "'Autodesk Revit Structure 2012'";
	local ApplicationIdentifier = "'Revit'";
	self[1] = ApplicationDeveloper
	self[2] = Version
	self[3] = ApplicationFullName
	self[4] = ApplicationIdentifier
 

end
--R8,21.3.2
IFCOWNERHISTORY = {param = 8, name = "IFCOWNERHISTORY"} --IfcOwnerHistory = {}	
--[[ENTITY IfcOwnerHistory;  
	OwningUser :  IfcPersonAndOrganization; 
	OwningApplication :  IfcApplication; 
	State :  OPTIONAL IfcStateEnum; 
	ChangeAction :  OPTIONAL IfcChangeActionEnum; 
	LastModifiedDate :  OPTIONAL IfcTimeStamp; 
	LastModifyingUser :  OPTIONAL IfcPersonAndOrganization; 
	LastModifyingApplication :  OPTIONAL IfcApplication; 
	CreationDate :  IfcTimeStamp; 
  WHERE  
	CorrectChangeAction :  (EXISTS(LastModifiedDate)) OR (NOT(EXISTS(LastModifiedDate)) AND NOT(EXISTS(ChangeAction))) OR (NOT(EXISTS(LastModifiedDate)) AND EXISTS(ChangeAction) AND (ChangeAction = IfcChangeActionEnum.NOTDEFINED)) 
END_ENTITY; --]] 
function IFCOWNERHISTORY:set_key(key)
	self.key = key
	self.new_key = key
	self.class_name = "IFCOWNERHISTORY"
	return self
end
function IFCOWNERHISTORY:create_person_organization(info,db)
	local key = get_key();
	local person_orig = new(IFCPERSONANDORGANIZATION);
	person_orig:set_key(key);
	person_orig:set(info,db)	
	
	push_ifc_data(person_orig,db)

	return person_orig

end
function IFCOWNERHISTORY:create_application(info,db)
	local key = get_key();
	local app = new(IFCAPPLICATION);
	app:set_key(key);
	app:set(info,db)	
	
	push_ifc_data(app,db)

	return app

end

function IFCOWNERHISTORY:set(info,db)
	local OwningUser = self:create_person_organization(info,db); 
	local OwningApplication = self:create_application(info,db); 
	local State = "$"; 
	local ChangeAction  = ".NOCHANGE."; 
	local LastModifiedDate = "$"; 
	local LastModifyingUser = "$"; 
	local LastModifyingApplication = "$"; 
	local CreationDate = 0; 
 
	self[1] = OwningUser
	self[2] = OwningApplication
	self[3] = State
	self[4] = ChangeAction
	self[5] = LastModifiedDate
	self[6] = LastModifyingUser
	self[7] = LastModifyingApplication
	self[8] = CreationDate

end
