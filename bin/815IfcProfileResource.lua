--	8. IFC Resource Layer 8.15 IfcProfileResource
setfenv(1,ifc)

--	8.15.2 Type

--	8.15.3 Entities
--R8.15.3.1
IFCARBITRARYCLOSEDPROFILEDEF = {param =1, name = "IFCARBITRARYCLOSEDPROFILEDEF"} --IfcArbitraryClosedProfileDef = {} 
--[[ENTITY IfcArbitraryClosedProfileDef  
 SUPERTYPE OF(IfcArbitraryProfileDefWithVoids)  
 SUBTYPE OF IfcProfileDef;  
	OuterCurve :  IfcCurve; 
 WHERE  
	WR1 :  OuterCurve.Dim = 2 
	WR2 :  NOT( IFCGEOMETRYRESOURCE.IFCLINE IN TYPEOF(OuterCurve)) 
	WR3 :  NOT( IFCGEOMETRYRESOURCE.IFCOFFSETCURVE2D IN TYPEOF(OuterCurve)) --]] 



function IFCARBITRARYCLOSEDPROFILEDEF:get_section(ents)
	--IFCARBITRARYCLOSEDPROFILEDEF(.AREA.,$,#245)
	self[3]:get_ent(ents)
end


function IFCARBITRARYCLOSEDPROFILEDEF:set_key(key)
	self.key = key;
	self.new_key = key;
	self.class_name = "IFCARBITRARYCLOSEDPROFILEDEF";
	return self;
end

function IFCARBITRARYCLOSEDPROFILEDEF:create_out_curves(info,db)
	local key  = get_key();
	local composite_curve = new(IFCCOMPOSITECURVE);
	composite_curve:set_key(key);
	composite_curve:set(info,db);
	
	push_ifc_data(composite_curve,db)
	
	return composite_curve;
end

function IFCARBITRARYCLOSEDPROFILEDEF:set(info,db)
	local profile_type = ".AREA.";
	local profile_name = "\$";
	local out_curve = self:create_out_curves(info,db);
	
	self[1] = profile_type;
	self[2] = profile_name;
	self[3] = out_curve	;
end
function IFCARBITRARYCLOSEDPROFILEDEF:create_slab_curves(info)
	--对于板，已经得到了所以的在xy平面上的二维点，所以直接生成数据即可
	local poly_line = ifcnew(IFCPOLYLINE);
	poly_line:set_pts(info.pts);
	return poly_line
	
end

function IFCARBITRARYCLOSEDPROFILEDEF:set_common(info)
	local profile_type = ".AREA.";
	local profile_name = "\$";
	
	local out_curve;
	if(Cur_Deal_Kind == Kind_Slab)then
		out_curve = self:create_slab_curves(info);
	end
	
	self[1] = profile_type;
	self[2] = profile_name;
	self[3] = out_curve	;
end



--R8.15.3.8
IFCCOMPOSITEPROFILEDEF = {param = 2, name = "IFCCOMPOSITEPROFILEDEF"} --IfcCompositeProfileDef = {}
--[[ENTITY IfcCompositeProfileDef  
 SUBTYPE OF IfcProfileDef;  
	Profiles :  SET [2:?] OF IfcProfileDef; 
	Label :  OPTIONAL IfcLabel; 
 WHERE  
	InvariantProfileType :  SIZEOF(QUERY(temp <* Profiles | temp.ProfileType <> 		Profiles[1].ProfileType)) = 0 
	NoRecursion :  SIZEOF(QUERY(temp <* Profiles | 	IFCPROFILERESOURCE.IFCCOMPOSITEPROFILEDEF IN TYPEOF(temp))) = 0 
END_ENTITY; --]] 

--R8.15.3.19 
IFCRECTANGLEPROFILEDEF = {param = 2, name = "IFCRECTANGLEPROFILEDEF"}
--[[ENTITY IfcRectangleProfileDef  
 SUPERTYPE OF(ONEOF(IfcRectangleHollowProfileDef, IfcRoundedRectangleProfileDef))  
 SUBTYPE OF IfcParameterizedProfileDef;  
 XDim :  IfcPositiveLengthMeasure; 
YDim :  IfcPositiveLengthMeasure; 
 
END_ENTITY; --]] 
function IFCRECTANGLEPROFILEDEF:set(center,width,height)
	self[1] = ".AREA.";
	self[2] = "$";
	self[3] = create_axis2_placement2d(center,{x=0,y=-1});--默认的direction
	self[4] = width;
	self[5] = height;
end
function IFCRECTANGLEPROFILEDEF:get_section(ents)
	local width = self[4];
	local height = self[5];
	local axis2 = self[3]:get_origin_dircet();
	local pt1 = {x = axis2.origin.x - width/2.0,y = axis2.origin.y + height/2.0,z=axis2.origin.z}
	local pt2 = {x = axis2.origin.x - width/2.0,y = axis2.origin.y - height/2.0,z=axis2.origin.z}
	local pt3 = {x = axis2.origin.x + width/2.0,y = axis2.origin.y - height/2.0,z=axis2.origin.z}
	local pt4 = {x = axis2.origin.x + width/2.0,y = axis2.origin.y + height/2.0,z=axis2.origin.z}
	local ln = {start_pt = pt1,end_pt = pt2};
	table.insert(ents,ln);
	ln = {start_pt = pt2,end_pt = pt3};
	table.insert(ents,ln);	
	ln = {start_pt = pt3,end_pt = pt4};
	table.insert(ents,ln);	
	ln = {start_pt = pt4,end_pt = pt1};
	table.insert(ents,ln);		
end



--R8.15.3.12
IFCISHAPEPROFILEDEF = {param = 7, name = "IFCISHAPEPROFILEDEF"} --IfcIShapeProfileDef = {}
--[[ENTITY IfcIShapeProfileDef  
SUBTYPE OF IfcParameterizedProfileDef;  
	OverallWidth :  IfcPositiveLengthMeasure; 
	OverallDepth :  IfcPositiveLengthMeasure; 
	WebThickness :  IfcPositiveLengthMeasure; 
	FlangeThickness :  IfcPositiveLengthMeasure; 
	FilletRadius :  OPTIONAL IfcNonNegativeLengthMeasure; 
	FlangeEdgeRadius :  OPTIONAL IfcNonNegativeLengthMeasure; 
	FlangeSlope :  OPTIONAL IfcPlaneAngleMeasure; 
WHERE  
	ValidFlangeThickness :  (2. * FlangeThickness) < OverallDepth 
	ValidWebThickness :  WebThickness < OverallWidth 
	ValidFilletRadius :  NOT(EXISTS(FilletRadius)) OR ((FilletRadius <= (OverallWidth - WebThickness)/2.) AND (FilletRadius <= (OverallDepth - (2. * FlangeThickness))/2.)) --]] 

--R8.15.3.15
IFCPARAMETERIZEDPROFILEDEF = {param = 1, name = "IFCPARAMETERIZEDPROFILEDEF"} --IfcParameterizedProfileDef = {}
--[[ENTITY IfcParameterizedProfileDef  
 ABSTRACT SUPERTYPE OF(ONEOF(IfcAsymmetricIShapeProfileDef, IfcCircleProfileDef, IfcCShapeProfileDef, IfcEllipseProfileDef, IfcIShapeProfileDef, IfcLShapeProfileDef, IfcRectangleProfileDef, IfcTrapeziumProfileDef, IfcTShapeProfileDef, IfcUShapeProfileDef, IfcZShapeProfileDef))  
 SUBTYPE OF IfcProfileDef;  
	Position :  OPTIONAL IfcAxis2Placement2D; --]]
 
--R8.15.3.16
IFCPROFILEDEF = {param =2, name = "IFCPROFILEDEF"} --IfcProfileDef = {ProfileType = IfcProfileTypeEnum, ProfileName = IfcLabel} 
--[[ENTITY IfcProfileDef  
 SUPERTYPE OF(ONEOF(IfcArbitraryClosedProfileDef, IfcArbitraryOpenProfileDef, IfcCompositeProfileDef, IfcDerivedProfileDef, IfcParameterizedProfileDef));  
	ProfileType :  IfcProfileTypeEnum; 
	ProfileName :  OPTIONAL IfcLabel; 
 INVERSE  
	HasExternalReference :  SET OF IfcExternalReferenceRelationship FOR 		RelatedResourceObjects; 
	HasProperties :  SET OF IfcProfileProperties FOR ProfileDefinition; --]]

setparent(IFCPROFILEDEF, IFCARBITRARYCLOSEDPROFILEDEF)			--R8.15.3.01
setparent(IFCPROFILEDEF, IFCCOMPOSITEPROFILEDEF)				--R8.15.3.08
setparent(IFCPARAMETERIZEDPROFILEDEF, IFCISHAPEPROFILEDEF)		--R8.15.3.12
setparent(IFCPARAMETERIZEDPROFILEDEF, IFCRECTANGLEPROFILEDEF)		--R8.15.3.19
setparent(IFCPROFILEDEF, IFCPARAMETERIZEDPROFILEDEF)			--R8.15.3.15

--[[
setparent(IFCPROFILEDEF, IFCCOMPOSITEPROFILEDEF)				--R8.15.3.08
setparent(IFCPROFILEDEF, IFCCOMPOSITEPROFILEDEF)				--R8.15.3.08
setparent(IFCPROFILEDEF, IFCCOMPOSITEPROFILEDEF)				--R8.15.3.08
setparent(IFCPROFILEDEF, IFCCOMPOSITEPROFILEDEF)				--R8.15.3.08
--]]
