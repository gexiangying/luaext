--	8.	IFC Resource Layer	--	8.12 IfcPresentationAppearanceResource
setfenv(1,ifc)

--	8.12.2	Type
--R8.11.2.71 
function IFCRATIOMEASURE(o) --IfcRatioMeasure = REAL;
	o.class_name = "IFCRATIOMEASURE"
	o.style = "REAL"
	return o
end

-- 	8.12.3 Entities
--R8.12.3.2
IFCCOLOURRGB = {param = 3, name = "IFCCOLOURRGB"} --IfcColourRgb = {}
--[[ENTITY IfcColourRgb  
 SUBTYPE OF IfcColourSpecification;  
	Red :  IfcNormalisedRatioMeasure; 
	Green :  IfcNormalisedRatioMeasure; 
	Blue :  IfcNormalisedRatioMeasure; --]]

--R8.12.3.4
IFCCOLOURSPECIFICATION = {param = 1, name = "IFCCOLOURSPECIFICATION"} --IfcColourSpecification = {}
--[[ENTITY IfcColourSpecification  
 ABSTRACT SUPERTYPE OF(IfcColourRgb)  
 SUBTYPE OF IfcPresentationItem;  
	Name :  OPTIONAL IfcLabel; --]]

--R8.13.3.7
IFCPRESENTATIONITEM = {param = 0, name = "IFCPRESENTATIONITEM"} --IfcPresentationItem = {}
--[[ENTITY IfcPresentationItem  
 ABSTRACT SUPERTYPE OF(ONEOF(IfcColourRgbList, IfcColourSpecification, IfcCurveStyleFont, IfcCurveStyleFontAndScaling, IfcCurveStyleFontPattern, IfcIndexedColourMap, IfcPreDefinedItem, IfcSurfaceStyleLighting, IfcSurfaceStyleRefraction, IfcSurfaceStyleShading, IfcSurfaceStyleWithTextures, IfcSurfaceTexture, IfcTextStyleForDefinedFont, IfcTextStyleTextModel, IfcTextStyleWithBoxCharacteristics, IfcTextureCoordinate, IfcTextureVertex, IfcTextureVertexList));  --]]

--R8.12.3.29
IFCPRESENTATIONSTYLE = {param = 1, name = "IFCPRESENTATIONSTYLE"} --IfcPresentationStyle = {}
--[[ENTITY IfcPresentationStyle  
 ABSTRACT SUPERTYPE OF(ONEOF(IfcCurveStyle, IfcFillAreaStyle, IfcSurfaceStyle, IfcSymbolStyle, IfcTextStyle));  
	Name :  OPTIONAL IfcLabel; --]]

--R8.12.3.30
IFCPRESENTATIONSTYLEASSIGNMENT = {param = 1, name = "IFCPRESENTATIONSTYLEASSIGNMENT"} --IfcPresentationStyleAssignment = {}
--[[ENTITY IfcPresentationStyleAssignment;  
	Styles :  SET [1:?] OF IfcPresentationStyleSelect; --]]

--R8.12.3.31
IFCSTYLEDITEM ={param = 3, name = "IFCSTYLEDITEM"} --IfcStyledItem = {}
--[[ENTITY IfcStyledItem  
 SUBTYPE OF IfcRepresentationItem;  
	Item :  OPTIONAL IfcRepresentationItem; 
	Styles :  SET [1:?] OF IfcStyleAssignmentSelect; 
	Name :  OPTIONAL IfcLabel; 
 WHERE  
	ApplicableItem :  NOT( IFCPRESENTATIONAPPEARANCERESOURCE.IFCSTYLEDITEM IN TYPEOF(Item))--]]

--R8.12.3.32
IFCSURFACESTYLE = {param =2, name = "IFCSURFACESTYLE"} --IfcSurfaceStyle = {}
--[[ENTITY IfcSurfaceStyle  
 SUBTYPE OF IfcPresentationStyle;  
	Side :  IfcSurfaceSide; 
	Styles :  SET [1:5] OF IfcSurfaceStyleElementSelect; 
 WHERE  
	WR11 :  SIZEOF(QUERY(Style <* SELF.Styles | IFCPRESENTATIONAPPEARANCERESOURCE.IFCSURFACESTYLESHADING IN TYPEOF(Style) )) <= 1 
	WR12 :  SIZEOF(QUERY(Style <* SELF.Styles | IFCPRESENTATIONAPPEARANCERESOURCE.IFCSURFACESTYLELIGHTING IN TYPEOF(Style) )) <= 1 
	WR13 :  SIZEOF(QUERY(Style <* SELF.Styles | IFCPRESENTATIONAPPEARANCERESOURCE.IFCSURFACESTYLEREFRACTION IN TYPEOF(Style) )) <= 1 
	WR14 :  SIZEOF(QUERY(Style <* SELF.Styles | IFCPRESENTATIONAPPEARANCERESOURCE.IFCSURFACESTYLEWITHTEXTURES IN TYPEOF(Style) )) <= 1 
	WR15 :  SIZEOF(QUERY(Style <* SELF.Styles | IFCPRESENTATIONAPPEARANCERESOURCE.IFCEXTERNALLYDEFINEDSURFACESTYLE IN TYPEOF(Style) )) <= 1 --]]

 --R8.12.3.35
IFCSURFACESTYLERENDERING = {param = 8, name = "IFCSURFACESTYLERENDERING"} --IfcSurfaceStyleRendering = {}
--[[ENTITY IfcSurfaceStyleRendering  
 SUBTYPE OF IfcSurfaceStyleShading;  
	Transparency :  OPTIONAL IfcNormalisedRatioMeasure; 
	DiffuseColour :  OPTIONAL IfcColourOrFactor; 
	TransmissionColour :  OPTIONAL IfcColourOrFactor; 
	DiffuseTransmissionColour :  OPTIONAL IfcColourOrFactor; 
	ReflectionColour :  OPTIONAL IfcColourOrFactor; 
	SpecularColour :  OPTIONAL IfcColourOrFactor; 
	SpecularHighlight :  OPTIONAL IfcSpecularHighlightSelect; 
	ReflectanceMethod :  IfcReflectanceMethodEnum; --]]

--R8.12.3.36
IFCSURFACESTYLESHADING = {param = 1, name = "IFCSURFACESTYLESHADING"} --IfcSurfaceStyleShading = {}
--[[ENTITY IfcSurfaceStyleShading  
 SUPERTYPE OF(IfcSurfaceStyleRendering)  
 SUBTYPE OF IfcPresentationItem;  
	SurfaceColour :  IfcColourRgb; --]]
	
	
setparent(IFCCOLOURSPECIFICATION, IFCCOLOURRGB)							--R8.12.3.02
setparent(IFCPRESENTATIONITEM, IFCCOLOURSPECIFICATION)					--R8.12.3.04
setparent(IFCREPRESENTATIONITEM, IFCSTYLEDITEM)							--R8.12.3.31
setparent(IFCPRESENTATIONSTYLE, IFCSURFACESTYLE)						--R8.12.3.32
setparent(IFCSURFACESTYLESHADING, IFCSURFACESTYLERENDERING)				--R8.12.3.35
setparent(IFCPRESENTATIONITEM, IFCSURFACESTYLESHADING)					--R8.12.3.36

--[[
setparent(IfcColourSpecification, IFCCOLOURRGB)							--R8.12.3.02
setparent(IfcColourSpecification, IFCCOLOURRGB)							--R8.12.3.02
setparent(IfcColourSpecification, IFCCOLOURRGB)							--R8.12.3.02
setparent(IfcColourSpecification, IFCCOLOURRGB)							--R8.12.3.02
setparent(IfcColourSpecification, IFCCOLOURRGB)							--R8.12.3.02
setparent(IfcColourSpecification, IFCCOLOURRGB)							--R8.12.3.02
--]]