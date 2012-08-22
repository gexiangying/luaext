---	IfcMember 20120707
--module (...,package.seeall)
package.path = "?.lua; ?;" 
local RUF = require "ReiUtilityFunctions" 
local R51 = require "51IfcKernel" 
local R54 = require "54IfcProductExtension" 
local R61 = require "61IfcSharedBldgElements" 
local R64 = require "64IfcSharedFacilitiesElements" 
local R81 = require "81IfcActorResource" 
local R85 = require "85IfcDateTimeResource" 
local R86 = require "86IfcExternalReferenceResource" 
local R87 = require "87IfcGeometricConstraintResource" 
local R89 = require "89IfcGeometryResource" 
local R810 = require "810IfcMaterialResource" 
local R811 = require "811IfcMeasureResource" 
local R815 = require "815IfcProfileResource" 
local R816 = require "816IfcPropertyResource" 
local R818 = require "818IfcRepresentationResource" 
local R821 = require "821IfcUtilityResource" 


function tablist (tabparameter, tabname)
--for treatment of paprmeter with record list
	--tabparameter = {}	--parameters with record list
	--tabname = {}			--linked table
	local string_length = #tabparameter  --take length of the parameter list
	local tab = {}
	for i=1, string_length do
		tab[i] = new(tabname)	
		tab[i]:set(tabparameter[i])	
	end
	return tab
end	

function datalist(tabparameter)
--for treatment of paprmeter with data list
	tabparameter = {}	--parameters with data list
	local string_length = #tabparameter  --take length of the parameter list
	local tab = {}
	for i=1, string_length do
		tab[i] = tabparameter[i]
	end
	return tab
end

function tablink (parameter, tabname)
--for treatment of paprmeter with single record
	--parameter =  single record number (string)
	--tabname = {}			--linked table
	local tab = new(tabname)
	tab:set(parameter)	
	return tab
end




--IfcMember
local a = tostring(getmetatable(?)) --get table name
if (a == string.upper(IfcBeam)) then
	local beam = new(IfcBeam)
	beam:set(temp[ID])
elseif (a == string.upper(IfcColumn)) then
	IfcColumn["12"].GlobalId 	= tostring(temp["ID"].p1)
	IfcColumn["ID"].OwnerHistory = recordlink(["ID"].p2, IfcOwnerHistory)
	IfcColumn["ID"].Name 		= tostring(temp["ID"].p3)
	IfcColumn["ID"].Description 	= tostring(temp["ID"].p4)
	IfcColumn["ID"].ObjectType 	= tostring(temp["ID"].p5)
	IfcColumn["ID"].ObjectPlacement = recordlink(temp["ID"].p6, IfcObjectPlacement)
	IfcColumn["ID"].Representation=recordlink(temp["ID"].p7,IfcProductRepresentation)
	IfcColumn["ID"].Tag = tostring(temp["ID"].p8)
	if (temp["ID"].p9) then
		IfcColumn["ID"].PredefinedType = temp["ID"].p9 --ENUMERATION
	end
elseif (a == string.upper(IfcMember)) then
	IfcMember["ID"].GlobalId 	= tostring(temp["ID"].p1)
	IfcMember["ID"].OwnerHistory = recordlink(temp["ID"].p2, IfcOwnerHistory)
	IfcMember["ID"].Name 		= tostring(temp["ID"].p3)
	IfcMember["ID"].Description 	= tostring(temp["ID"].p4)
	IfcMember["ID"].ObjectType 	= tostring(temp["ID"].p5)
	IfcMember["ID"].ObjectPlacement = recordlink(temp["ID"].p6, IfcObjectPlacement)
	IfcMember["ID"].Representation = recordlink(temp["ID"].p7,IfcProductRepresentation)
	IfcMember["ID"].Tag = tostring(temp["ID"].p8)
	if (temp["ID"].p9) then
		IfcMember["ID"].PredefinedType = temp["ID"].p9 --ENUMERATION
	end
-- new start

--for IfcProductRepresentation Entity ABSTRACT SUPERTYPE OF
--(ONEOF(IfcMaterialDefinitionRepresentation, IfcProductDefinitionShape)); 
elseif (a == string.upper(IfcMaterialDefinitionRepresentation)) then
	local i =1
	
elseif (a == string.upper(IfcProductRepresentation )) then
	IfcProductDefinitionShape["ID"].Name = tostring(temp["ID"].p1)
	IfcProductDefinitionShape["ID"].Description = tostring(temp["ID"].p2)
	IfcProductDefinitionShape["ID"].Representations=recordlist(temp["ID"].p3,IfcRepresentation)
	--for ENTITY IfcRepresentation  
	--ABSTRACT SUPERTYPE OF(ONEOF(IfcShapeModel, IfcStyleModel)); 
		--for ENTITY IfcShapeModel  
		--ABSTRACT SUPERTYPE OF(ONEOF(IfcShapeRepresentation, IfcTopologyRepresentation))  

elseif (a == string.upper(IfcShapeRepresentation)) then
	IfcShapeRepresentation["ID"].ContextOfItems = recordlink(temp["ID"].p1, IfcRepresentationContext)
	IfcShapeModel["ID"].RepresentationIdentifier = tostring(temp["ID"].p2)
	IfcShapeModel["ID"].RepresentationType = tostring(temp["ID"].p3)
	IfcShapeModel["ID"].Items =recordlist(temp["ID"].p4,IfcRepresentationItem)
elseif (a == string.upper(IfcRepresentationContext)) then
	if (temp["ID"].p1) then
		IfcRepresentationContext["ID"].ContextIdentifier = tostring(temp["ID"].p1)
	end
	if (temp["ID"].p2) then
		IfcRepresentationContext["ID"].ContextType = tostring(temp["ID"].p2)
	end

	
	IfcProductDefinitionShape 
	
--new start
elseif (a == string.upper(IfcRepresentationContext)) then
	if (temp["ID"].p1) then
		IfcRepresentationContext["ID"].ContextIdentifier = tostring(temp["ID"].p1)
	end


	if
	
	, IfcRepresentationContext)
	IfcRepresentationContext["ID"].RepresentationIdentifier = tostring(temp["ID"].p2)
	IfcRepresentationContext["ID"].RepresentationType = tostring(temp["ID"].p3)
	IfcRepresentationContext["ID"].Items =recordlist(temp["ID"].p4,IfcRepresentationItem)
elseif 


	
	
	
IfcProductRepresentation["ID"].Representations = recordlist (temp["ID"].p4, IfcRepresentation)


	
	
end




--sample
--[[local a = string(getmetatable(?))
if (a == "IFCBEAM") then
	IfcBeam["ID"].GlobalId 	= temp["ID"].["p1"]
	IfcBeam["ID"].OwnerHistory = temp["ID"].p2
	IfcBeam["ID"].Name 		= temp["ID"].p3
	IfcBeam["ID"].Description 	= temp["ID"].p4
	IfcBeam["ID"].ObjectType 	= tostring(temp["ID"].p5)
	local b = IfcBeam["ID"].ObjectPlacement = {}
	b[1] = tonumber(temp["ID"].p6.p1 --list[1:3]
	b[2] = tonumber(temp["ID"].p6.p2 --list[1:3]
	b[3] = tonumber(temp["ID"].p6.p3 --list[1:3]
	
	b = IfcBeam["ID"].Representation = {}	--list[1:?]
	local l = #temp["ID"].p7  --take lengh of the variable
	for i=1, l do
		b[i] = temp[ID].p7[i]
	end
	
	b = IfcBeam["ID"].ReferencedBy = new(IfcRelCoversBldgElements) --optional #Table	
	b:set(temp["ID"].p8)
		
	IfcBeam["ID"].Tag = temp["ID"].p9
	if (temp["ID"].p10) then
		IfcBeam["ID"].PredefinedType = temp["ID"].p10
	end--]]
	
end


--Create Joint


-- SetUp Materials

