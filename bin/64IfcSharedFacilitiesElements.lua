--	6. IFC Shared Layer		--	6.4 IfcSharedFacilitiesElements
setfenv(1,ifc)

--	6.4.2 Type
--R6.4.2.3
--IFCOCCUPANTTYPEENUM = {}  --IfcOccupantTypeEnum = {	ASSIGNEE, ASSIGNOR, LESSEE, LESSOR, LETTINGAGENT, OWNER, TENANT, USERDEFINED, NOTDEFINED	}  

--	6.4.3 Entities
--R6.4.3.5
IFCOCCUPANT = {param = 1, name = "IFCOCCUPANT"}  --IfcOccupant = {PredefinedType = IfcOccupantTypeEnum}
--[[	ENTITY IfcOccupant  
		SUBTYPE OF IfcActor;  
			PredefinedType :  OPTIONAL IfcOccupantTypeEnum; 
		WHERE  
			WR31 :  NOT(PredefinedType = IfcOccupantTypeEnum.USERDEFINED) OR EXISTS(SELF\IfcObject.ObjectType) 
--]]

setparent(IFCACTOR, IFCOCCUPANT)									--R6.4.3.05