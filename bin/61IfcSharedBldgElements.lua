--	6.	IFC Shared Layer	--	6.1	IfcSharedBldgElements
setfenv(1,ifc)

--	6.1.2	Type
--R6.1.2.1
--IFCBEAMTYPEENUM = {}  --IfcBeamTypeEnum = {BEAM, JOIST, HOLLOWCORE, LINTEL, SPANDREL, T_BEAM, USERDEFINED, NOTDEFINED}
--R6.1.2.5
--IFCCOLUMNTYPEENUM = {}  --IfcColumnTypeEnum = {COLUMN, USERDEFINED, NOTDEFINED}
--R6.1.2.11
--IFCMEMBERTYPEENUM = {}  --IfcMemberTypeEnum = {BRACE, CHORD, COLLAR, MEMBER, MULLION, PLATE, POST, PURLIN, RAFTER, STRINGER, STRUT, STUD, USERDEFINED, NOTDEFINED}

--6.1.3	Entities
--R6.1.3.1
IFCBEAM = {parame = 1, name = "IFCBEAM"}  --IfcBeam = {PredefinedType = IfcBeamTypeEnum} 
--[[ENTITY IfcBeam  
 SUPERTYPE OF(IfcBeamStandardCase)  
 SUBTYPE OF IfcBuildingElement;  
	PredefinedType :  OPTIONAL IfcBeamTypeEnum; 
 WHERE  
	CorrectPredefinedType :  NOT(EXISTS(PredefinedType)) OR (PredefinedType <> 	IfcBeamTypeEnum.USERDEFINED) OR ((PredefinedType = IfcBeamTypeEnum.USERDEFINED) AND 	EXISTS (SELF\IfcObject.ObjectType)) 
	CorrectTypeAssigned :  NOT(EXISTS(IsTypedBy)) OR ( IFCSHAREDBLDGELEMENTS.IFCBEAMTYPE IN TYPEOF(IsTypedBy[1].RelatingType)) 
END_ENTITY;--]] 
function IFCBEAM:set_key(key)
	self.key = key
	self.new_key = key
	self.class_name = "IFCBEAM"
	return self
end
--The tag (or label) identifier at the particular instance of a product, 
--e.g. the serial number, or the position number. It is the identifier at the occurrence level
g_id  = 1000
function IFCBEAM:set_tag(info)
	local v = {}	
	local id = "' "..g_id .. "'"	
	--self[8] = IFCIDENTIFIER(v)
	
	self[8] = id;
	g_id = g_id + 1;
	return self[8]
end
function IFCBEAM:set_object_type(info)
	self[5] = "\'H-Wide Flange Beams:H300x150x6.5:90959\'"
	local v = {}
	v[1] = "\'H-Wide Flange Beams:H300x150x6.5:90959\'"
	--self[5] = IFCLABEL(v)
	return self[5]
end

function IFCBEAM:get_object()
	return self:get_object_t();
end

--R6.1.3.2
IFCBEAMSTANDARDCASE = {param =0, name = "IFCBEAMSTANDARDCASE"}  --IfcBeamStandardCase = {}  
--[[ENTITY IfcBeamStandardCase  
 SUBTYPE OF IfcBeam;  
 WHERE  
	HasMaterialProfileSetUsage :  SIZEOF (QUERY(temp <* USEDIN(SELF, IFCKERNEL.IFCRELASSOCIATES.RELATEDOBJECTS ) | ( IFCPRODUCTEXTENSION.IFCRELASSOCIATESMATERIAL IN TYPEOF(temp)) AND ( IFCMATERIALRESOURCE.IFCMATERIALPROFILESETUSAGE IN TYPEOF(temp.RelatingMaterial)) )) = 1 
END_ENTITY;--]]

--R6.1.3.3
IFCBEAMTYPE = {param = 1, name = "IFCBEAMTYPE"} --IfcBeamType = {}
--[[ENTITY IfcBeamType  
 SUBTYPE OF IfcBuildingElementType;  
	PredefinedType :  IfcBeamTypeEnum; 
 WHERE  
	CorrectPredefinedType :  (PredefinedType <> IfcBeamTypeEnum.USERDEFINED) OR ((PredefinedType = IfcBeamTypeEnum.USERDEFINED) AND EXISTS(SELF\IfcElementType.ElementType)) --]]
 
--R6.1.3.9
IFCCOLUMN = {param = 1, name = "IFCCOLUMN"}  --IfcColumn = {PredefinedType = IfcColumnTypeEnum}  
--[[ENTITY IfcColumn  
 SUPERTYPE OF(IfcColumnStandardCase)  
 SUBTYPE OF IfcBuildingElement;  
	PredefinedType :  OPTIONAL IfcColumnTypeEnum; 
 WHERE  
	CorrectPredefinedType :  NOT(EXISTS(PredefinedType)) OR (PredefinedType <> 	IfcColumnTypeEnum.USERDEFINED) OR ((PredefinedType = IfcColumnTypeEnum.USERDEFINED) AND EXISTS (SELF\IfcObject.ObjectType)) 
	CorrectTypeAssigned :  NOT(EXISTS(IsTypedBy)) OR ( IFCSHAREDBLDGELEMENTS.IFCCOLUMNTYPE IN TYPEOF(IsTypedBy[1].RelatingType)) 
END_ENTITY;  --]]

function IFCCOLUMN:set_tag(info)
	self[8] = "'132062'"
	local v = {}
	v[1] = "\'132062\'"
	--self[8] = IFCIDENTIFIER(v)
	
	return self[8]
end
function IFCCOLUMN:set_object_type(info)
	self[5] = "\'H300x150x6.5\'"
	local v = {}
	v[1] = "\'H300x150x6.5\'"
	--self[5] = IFCLABEL(v)
	return self[5]
end
function IFCCOLUMN:set_key(key)
	self.key = key
	self.new_key = key
	self.class_name = "IFCCOLUMN"
	return self
end

function IFCCOLUMN:get_object()
	return self:get_object_t();
end


--R6.1.3.10
IFCCOLUMNSTANDARDCASE = {param =0, name = "IFCCOLUMNSTANDARDCASE"}  --IfcColumnStandardCase = {}  
--[[ENTITY IfcColumnStandardCase  
 SUBTYPE OF IfcColumn;  
 WHERE  
	HasMaterialProfileSetUsage :  SIZEOF (QUERY(temp <* USEDIN(SELF, IFCKERNEL.IFCRELASSOCIATES.RELATEDOBJECTS ) | ( IFCPRODUCTEXTENSION.IFCRELASSOCIATESMATERIAL IN TYPEOF(temp)) AND ( IFCMATERIALRESOURCE.IFCMATERIALPROFILESETUSAGE IN TYPEOF(temp.RelatingMaterial)) )) = 1 
END_ENTITY;  --]]

--R6.1.3.11
IFCCOLUMNTYPE = {param = 1, name = "IFCCOLUMNTYPE"} --IfcColumnType = {}
--[[ENTITY IfcColumnType  
 SUBTYPE OF IfcBuildingElementType;  
	PredefinedType :  IfcColumnTypeEnum; 
 WHERE  
	CorrectPredefinedType :  (PredefinedType <> IfcColumnTypeEnum.USERDEFINED) OR ((PredefinedType = IfcColumnTypeEnum.USERDEFINED) AND EXISTS(SELF\IfcElementType.ElementType)) --]]

--R6.1.3.19
IFCMEMBER = {param = 1, name = "IFCMEMBER"}  --IfcMember = {PredefinedType = IfcMemberTypeEnum}
--[[	ENTITY IfcMember  
		SUPERTYPE OF(IfcMemberStandardCase)  
		SUBTYPE OF IfcBuildingElement;  
			PredefinedType :  OPTIONAL IfcMemberTypeEnum; 
		WHERE  
			CorrectPredefinedType :  NOT(EXISTS(PredefinedType)) OR (PredefinedType <> IfcMemberTypeEnum.USERDEFINED) OR ((PredefinedType = IfcMemberTypeEnum.USERDEFINED) AND EXISTS (SELF\IfcObject.ObjectType)) 
			CorrectTypeAssigned :  NOT(EXISTS(IsTypedBy)) OR ( IFCSHAREDBLDGELEMENTS.IFCMEMBERTYPE IN TYPEOF(IsTypedBy[1].RelatingType)) 
--]]

--R6.1.3.20
IFCMEMBERSTANDARDCASE = {param =0, name = "IFCMEMBERSTANDARDCASE"}  --IfcMemberStandardCase = {}
--[[	ENTITY IfcMemberStandardCase  
		SUBTYPE OF IfcMember;  
		WHERE  
			HasMaterialProfileSetUsage :  SIZEOF (QUERY(temp <* USEDIN(SELF, IFCKERNEL.IFCRELASSOCIATES.RELATEDOBJECTS ) | ( IFCPRODUCTEXTENSION.IFCRELASSOCIATESMATERIAL IN TYPEOF(temp)) AND ( IFCMATERIALRESOURCE.IFCMATERIALPROFILESETUSAGE IN TYPEOF(temp.RelatingMaterial)) )) = 1 
--]]

--R6.1.3.38
IFCSLAB = {param =1, name = "IFCSLAB"}
--[[ENTITY IfcSlab  
 SUPERTYPE OF(ONEOF(IfcSlabElementedCase, IfcSlabStandardCase))  
 SUBTYPE OF IfcBuildingElement;  
 PredefinedType :  OPTIONAL IfcSlabTypeEnum; 
 
 WHERE  
 CorrectPredefinedType :  NOT(EXISTS(PredefinedType)) OR (PredefinedType <> IfcSlabTypeEnum.USERDEFINED) OR ((PredefinedType = IfcSlabTypeEnum.USERDEFINED) AND EXISTS (SELF\IfcObject.ObjectType)) 
CorrectTypeAssigned :  NOT(EXISTS(IsTypedBy)) OR ( IFCSHAREDBLDGELEMENTS.IFCSLABTYPE IN TYPEOF(IsTypedBy[1].RelatingType)) 
--]] 
function IFCSLAB:set_predefined_type()
	self[9] = ".FLOOR."
end
function IFCSLAB:set_tag(info)
	local id = "' "..g_id .. "'"
	self[8] = id;
	g_id = g_id + 1;
	return self[8]
end
function IFCSLAB:set_object_type(info)
	self[5] = "'\\X\\BB\\X\\F9\\X\\B4\\X\\A1\\X\\B5\\X\\D7\\X\\B0\\X\\E5:300mm \\X\\BB\\X\\F9\\X\\B4\\X\\A1\\X\\B5\\X\\D7\\X\\B0\\X\\E5'"
	return self[5]
end



setparent(IFCBUILDINGELEMENT, IFCBEAM)							--R6.1.3.01
--setparent(IFCBEAM, IFCBEAMSTANDARDCASE)							--R6.1.3.02
setparent(IFCBUILDINGELEMENTTYPE, IFCBEAMTYPE)					--R6.1.3.03
setparent(IFCBUILDINGELEMENT, IFCCOLUMN)						--R6.1.3.09
setparent(IFCCOLUMN, IFCCOLUMNSTANDARDCASE)						--R6.1.3.10
setparent(IFCBUILDINGELEMENTTYPE, IFCCOLUMNTYPE)				--R6.1.3.11
setparent(IFCBUILDINGELEMENT, IFCMEMBER)						--R6.1.3.19
setparent(IFCMEMBER, IFCMEMBERSTANDARDCASE)						--R6.1.3.20

setparent(IFCBUILDINGELEMENT, IFCSLAB)						--R6.1.3.38

--[[
setparent(IFCBUILDINGELEMENT, IFCCOLUMN)						--R6.1.3.09
setparent(IFCCOLUMN, IFCCOLUMNSTANDARDCASE)						--R6.1.3.10
setparent(IFCBUILDINGELEMENT, IFCMEMBER)						--R6.1.3.19
setparent(IFCMEMBER, IFCMEMBERSTANDARDCASE)						--R6.1.3.20
--]]


