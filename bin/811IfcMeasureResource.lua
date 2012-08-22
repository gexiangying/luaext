--	8. IFC Resource Layer 8.11 IfcMeasureResource
setfenv(1,ifc)

--8.11.2	Type
--R8.11.2.1
function IFCABSORBEDDOSEMEASURE(o)  --IfcAbsorbedDoseMeasure = REAL; 
	o.class_name = "IFCABSORBEDDOSEMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.2
function IFCACCELERATIONMEASURE(o)  --IfcAccelerationMeasure = REAL; 
	o.class_name = "IFCACCELERATIONMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.3
function IFCAMOUNTOFSUBSTANCEMEASURE(o)  --IfcAmountOfSubstanceMeasure = REAL; 
	o.class_name = "IFCAMOUNTOFSUBSTANCEMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.4
function IFCANGULARVELOCITYMEASURE(o)  --IfcAngularVelocityMeasure = REAL; 
	o.class_name = "IFCANGULARVELOCITYMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.5
function IFCAREAMEASURE(o)  --IfcAreaMeasure = REAL; 
	o.class_name = "IFCAREAMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.6
function IFCBOOLEAN(o)  --IfcBoolean = BOOLEAN;  
	o.class_name = "IFCBOOLEAN"
	o.style = "BOOLEAN"
	return o
end

--R8.11.2.7
function IFCCOMPLEXNUMBER(o)  --IfcComplexNumber = ARRAY [1:2] OF REAL; 
	o.class_name = "IFCCOMPLEXNUMBER"
	o.style = "ARRAY [1:2] OF REAL"
	return o
end

--R8.11.2.8
function IFCCOMPOUNDPLANEANGLEMEASURE(o) --IfcCompoundPlaneAngleMeasure = LIST[3:4] OF INTEGER;  
	o.class_name = "IFCCOMPOUNDPLANEANGLEMEASURE"
	o.style = "LIST[3:4] OF INTEGER"
	return o
end
--[[TYPE IfcCompoundPlaneAngleMeasure = LIST [3:4] OF INTEGER;  
  WHERE  
	MinutesInRange :  ABS(SELF[2]) < 60  
	SecondsInRange :  ABS(SELF[3]) < 60  
	MicrosecondsInRange :  (SIZEOF(SELF) = 3) OR (ABS(SELF[4]) < 1000000)  
	ConsistentSign :  ((SELF[1] >= 0) AND (SELF[2] >= 0) AND (SELF[3] >= 0) AND ((SIZEOF(SELF) = 3) OR (SELF[4] >= 0))) OR ((SELF[1] <= 0) AND (SELF[2] <= 0) AND (SELF[3] <= 0) AND ((SIZEOF(SELF) = 3) OR (SELF[4] <= 0)))  
END_TYPE; --]]

--R8.11.2.9
function IFCCONTEXTDEPENDENTMEASURE(o) --IfcContextDependentMeasure = REAL; 
	o.class_name = "IFCCONTEXTDEPENDENTMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.10
function IFCCOUNTMEASURE(o) --IfcCountMeasure = NUMBER; 
	o.class_name = "IFCCOUNTMEASURE"
	o.style = "NUMBER"
	return o
end

--R8.11.2.11
function IFCCURVATUREMEASURE(o) --IfcCurvatureMeasure = REAL; 
	o.class_name = "IFCCURVATUREMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.12
function IFCDESCRIPTIVEMEASURE(o) --IfcDescriptiveMeasure = STRING; 
	o.class_name = "IFCDESCRIPTIVEMEASURE"
	o.style = "STRING"
	return o
end

--R8.11.2.13
function IFCDOSEEQUIVALENTMEASURE(o) --IfcDoseEquivalentMeasure = REAL; 
	o.class_name = "IFCDOSEEQUIVALENTMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.14
function IFCDYNAMICVISCOSITYMEASURE(o) --IfcDynamicViscosityMeasure = REAL; 
	o.class_name = "IFCDYNAMICVISCOSITYMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.15
function IFCELECTRICCAPACITANCEMEASURE(o) --IfcElectricCapacitanceMeasure = REAL; 
	o.class_name = "IFCELECTRICCAPACITANCEMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.16
function IFCELECTRICCHANGEMEASURE(o) --IfcElectricChargeMeasure = REAL; 
	o.class_name = "IFCELECTRICCHANGEMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.17
function IFCELECTRICCONDUCTANCEMEASURE(o) --IfcElectricConductanceMeasure = REAL; 
	o.class_name = "IFCELECTRICCONDUCTANCEMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.18
function IFCELECTRICCURRENTMEASURE(o) --IfcElectricCurrentMeasure = REAL; 
	o.class_name = "IFCELECTRICCURRENTMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.19
function IFCELECTRICRESISTANCEMEASURE(o) --IfcElectricResistanceMeasure = REAL; 
	o.class_name = "IFCELECTRICRESISTANCEMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.20
function IFCELECTRICVOLTAGEMEASURE(o) --IfcElectricVoltageMeasure = REAL; 
	o.class_name = "IFCELECTRICVOLTAGEMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.21
function IFCENERGYMEASURE(o) --IIfcEnergyMeasure = REAL; 
	o.class_name = "IFCENERGYMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.22
function IFCFORCEMEASURE(o) --IfcForceMeasure = REAL;  
	o.class_name = "IFCFORCEMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.23
function IFCFREQUENCYMEASURE(o) --IfcFrequencyMeasure = REAL;   
	o.class_name = "IFCFREQUENCYMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.24
function IFCHEATFLUXDENSITYMEASURE(o) --IfcHeatFluxDensityMeasure = REAL; 
	o.class_name = "IFCHEATFLUXDENSITYMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.25
function IFCHEATINGVALUEMEASURE(o) --IfcHeatingValueMeasure = REAL; 
	o.class_name = "IFCHEATINGVALUEMEASURE"
	o.style = "REAL"
	return o
end
--[[TYPE IfcHeatingValueMeasure = REAL;  
  WHERE  WR1 :  SELF > 0.  --]]

--R8.11.2.26
function IFCIDENTIFIER(o) --IfcIdentifier = STRING (255);  
	o.class_name = "IFCIDENTIFIER"
	o.style = "STRING (255)"
	return o
end
function get_col_type() --IfcIdentifier = STRING (255);  
	local t = ""
	return t
end



--R8.11.2.27
function IFCILLUMINANCEMEASURE(o) --IfcIlluminanceMeasure = REAL; 
	o.class_name = "IFCILLUMINANCEMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.28
function IFCINDUCTANCEMEASURE(o) --IfcInductanceMeasure = REAL; 
	o.class_name = "IFCINDUCTANCEMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.29
function IFCINTEGER(o)  --IfcInteger = INTEGER;  
	o.class_name = "IFCINTEGER"
	o.style = "INTEGER"
	return o
end

--R8.11.2.30
function IFCINTEGERCOUNTRATEMEASURE(o)  --IfcIntegerCountRateMeasure = INTEGER; 
	o.class_name = "IFCINTEGERCOUNTRATEMEASURE"
	o.style = "INTEGER"
	return o
end

--R8.11.2.31
function IFCIONCONCENTRATIONMEASURE(o)  --IfcIonConcentrationMeasure = REAL; 
	o.class_name = "IFCIONCONCENTRATIONMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.32
function IFCISOTHERMALMOISTURECAPACITYMEASURE(o) --IfcIsothermalMoistureCapacityMeasure = REAL; 
	o.class_name = "IFCISOTHERMALMOISTURECAPACITYMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.33
function IFCKINEMATICVISCOSITYMEASURE(o) --IfcKinematicViscosityMeasure = REAL;  
	o.class_name = "IFCKINEMATICVISCOSITYMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.34
function IFCLABEL(o)  --IfcLabel = STRING (255); 
	o.class_name = "IFCLABEL"
	o.style = "STRING (255)"
	return o
end

--R8.11.2.35
function IFCLENGTHMEASURE(o)  --IfcLengthMeasure = REAL; 
	o.class_name = "IFCLENGTHMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.36
function IFCLINEARFORCEMEASURE(o)  --IfcLinearForceMeasure = REAL 
	o.class_name = "IFCLINEARFORCEMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.37
function IFCLINEARMOMENTMEASURE(o)  --IfcLinearMomentMeasure = REAL;  
	o.class_name = "IFCLINEARMOMENTMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.38
function IFCLINEARSTIFFNESSMEASURE(o)  --IfcLinearStiffnessMeasure = REAL; 
	o.class_name = "IFCLINEARSTIFFNESSMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.39
function IFCLINEARVELOCITYMEASURE(o)  --IfcLinearVelocityMeasure = REAL;  
	o.class_name = "IFCLINEARVELOCITYMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.40
function IFCLOGICAL(o)  --IfcLogical = LOGICAL;   
	o.class_name = "IFCLOGICAL"
	o.style = "LOGICAL"
	return o
end

--R8.11.2.41
function IFCLUMINOUSFLUXMEASURE(o)  --IfcLuminousFluxMeasure = REAL; 
	o.class_name = "IFCLUMINOUSFLUXMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.42
function IFCLUMINOUSINTENSITYDISTRIBUTIONMEASURE(o)  --IfcLuminousIntensityDistributionMeasure = REAL; 
	o.class_name = "IFCLUMINOUSINTENSITYDISTRIBUTIONMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.43
function IFCLUMINOUSINTENSITYMEASURE(o)  --IfcLuminousIntensityMeasure = REAL; 
	o.class_name = "IFCLUMINOUSINTENSITYMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.44
function IFCMAGNETICFLUXDENSITYMEASURE(o)  --IfcMagneticFluxDensityMeasure = REAL; 
	o.class_name = "IFCMAGNETICFLUXDENSITYMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.45
function IFCMAGNETICFLUXMEASURE(o)  --IfcMagneticFluxMeasure = REAL; 
	o.class_name = "IFCMAGNETICFLUXMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.46
function IFCMASSDENSITYMEASURE(o)  --IfcMassDensityMeasure = REAL; 
	o.class_name = "IFCMASSDENSITYMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.47
function IFCMASSFLOWRATEMEASURE(o)  --IfcMassFlowRateMeasure = REAL; 
	o.class_name = "IFCMASSFLOWRATEMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.48
function IFCMASSMEASURE(o)  --IfcMassMeasure = REAL; 
	o.class_name = "IFCMASSMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.49
function IFCMASSPERLENGTHMEASURE(o)  --IfcMassPerLengthMeasure = REAL; 
	o.class_name = "IFCMASSPERLENGTHMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.50
function IFCMODULUSOFELASTICITYMEASURE(o)  --IfcModulusOfElasticityMeasure = REAL; 
	o.class_name = "IFCMODULUSOFELASTICITYMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.51
function IFCMODULUSOFLINEARSUBGRADEREACTIONMEASURE(o)  --IfcModulusOfLinearSubgradeReactionMeasure = REAL; 
	o.class_name = "IFCMODULUSOFLINEARSUBGRADEREACTIONMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.52
function IFCMODULUSOFROTATIONALSUBGRADEREACTIONMEASURE(o)  --IfcModulusOfRotationalSubgradeReactionMeasure = REAL; 
	o.class_name = "IFCMODULUSOFROTATIONALSUBGRADEREACTIONMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.53
function IFCMODULUSOFSUBGRADEREACTIONMEASURE(o)  --IfcModulusOfSubgradeReactionMeasure = REAL; 
	o.class_name = "IFCMODULUSOFSUBGRADEREACTIONMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.54
function IFCMOISTUREDIFFUSIVITYMEASURE(o)  --IfcMoistureDiffusivityMeasure = REAL; 
	o.class_name = "IFCMOISTUREDIFFUSIVITYMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.55
function IFCMOLECULARWEIGHTMEASURE(o)  --IfcMolecularWeightMeasure = REAL; 
	o.class_name = "IFCMOLECULARWEIGHTMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.56
function IFCMOMENTOFINERTIAMEASURE(o)  --IfcMomentOfInertiaMeasure = REAL; 
	o.class_name = "IFCMOMENTOFINERTIAMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.57
function IFCMONETARYMEASURE(o)  --IfcMonetaryMeasure = REAL; 
	o.class_name = "IFCMONETARYMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.58
function IFCNONNEGATIVELENGTHMEASURE(o)  --IfcNonNegativeLengthMeasure = IfcLengthMeasure
	o.class_name = "IFCNONNEGATIVELENGTHMEASURE"
	o.style = "IFCLENGTHMEASURE"
	return o
end
--[[TYPE IfcNonNegativeLengthMeasure = IfcLengthMeasure;  
  WHERE  NotNegative :  SELF >= 0. --]]

--R8.11.2.59
function IFCNORMALISEDRATIOMEASURE(o)  --IfcNormalisedRatioMeasure = IfcRatioMeasure;  
	o.class_name = "IFCNORMALISEDRATIOMEASURE"
	o.style = "IFCRATIOMEASURE"
	return o
end
--[[TYPE IfcNormalisedRatioMeasure = IfcRatioMeasure;  
  WHERE  WR1 :  {0.0 <= SELF <= 1.0} --]]

--R8.11.2.60
function IFCNUMERICMEASURE(o)  --IfcNumericMeasure = NUMBER; 
	o.class_name = "IFCNUMERICMEASURE"
	o.style = "NUMBER"
	return o
end

--R8.11.2.61
function IFCPARAMETERVALUE(o)  --IfcParameterValue = REAL; 
	o.class_name = "IFCPARAMETERVALUE"
	o.style = "REAL"
	return o
end

--R8.11.2.62
function IFCPHMEASURE(o)  --IfcPHMeasure = REAL;  
	o.class_name = "IFCPHMEASURE"
	o.style = "REAL"
	return o
end
--[[TYPE IfcPHMeasure = REAL;  
  WHERE  WR21 :  {0.0 <= SELF <= 14.0} --]]

--R8.11.2.63
function IFCPLANARFORCEMEASURE(o)  --IfcPlanarForceMeasure = REAL; 
	o.class_name = "IFCPLANARFORCEMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.64
function IFCPLANEANGLEMEASURE(o)  --IfcPlaneAngleMeasure = REAL;  
	o.class_name = "IFCPLANEANGLEMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.65
function IFCPOSITIVELENGTHMEASURE(o)  --IfcPositiveLengthMeasure = IfcLengthMeasure;  
	o.class_name = "IFCPOSITIVELENGTHMEASURE"
	o.style = "IFCLENGTHMEASURE"
	return o
end
--[[TYPE IfcPositiveLengthMeasure = IfcLengthMeasure;  
  WHERE  WR1 :  SELF > 0. --]]

--R8.11.2.66
function IFCPOSITIVEPLANEANGLEMEASURE(o)  --IfcPositivePlaneAngleMeasure = IfcPlaneAngleMeasure;  
	o.class_name = "IFCPOSITIVEPLANEANGLEMEASURE"
	o.style = "IFCPLANEANGLEMEASURE"
	return o
end
--[[TYPE IfcPositivePlaneAngleMeasure = IfcPlaneAngleMeasure;  
  WHERE  WR1 :  SELF > 0. --]]

--R8.11.2.67
function IFCPOSITIVERATIOMEASURE(o)  --IfcPositiveRatioMeasure = IfcRatioMeasure;  
	o.class_name = "IFCPOSITIVERATIOMEASURE"
	o.style = "IFCRATIOMEASURE"
	return o
end
--[[TYPE IfcPositiveRatioMeasure = IfcRatioMeasure;  
  WHERE  WR1 :  SELF > 0.  --]]

--R8.11.2.68
function IFCPOWERMEASURE(o)  --IfcPowerMeasure = REAL; 
	o.class_name = "IFCPOWERMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.69
function IFCPRESSUREMEASURE(o)  --IfcPressureMeasure = REAL; 
	o.class_name = "IFCPRESSUREMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.70
function IFCRADIOACTIVITYMEASURE(o)  --IfcRadioActivityMeasure = REAL; 
	o.class_name = "IFCRADIOACTIVITYMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.71
function IFCRATIOMEASURE(o)  --IfcRatioMeasure = REAL; 
	o.class_name = "IFCRATIOMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.72
function IFCREAL(o)  --IfcReal = REAL;   
	o.class_name = "IFCREAL"
	o.style = "REAL"
	return o
end

--R8.11.2.73
function IFCROTATIONALFREQUENCYMEASURE(o)  --IfcRotationalFrequencyMeasure = REAL; 
	o.class_name = "IFCROTATIONALFREQUENCYMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.74
function IFCROTATIONALMASSMEASURE(o)  --IfcRotationalMassMeasure = REAL; 
	o.class_name = "IFCROTATIONALMASSMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.75
function IFCROTATIONALSTIFFNESSMEASURE(o)  --IfcRotationalStiffnessMeasure = REAL; 
	o.class_name = "IFCROTATIONALSTIFFNESSMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.76
function IFCSECTIONALAREAINTEGRALMEASURE(o)  --IfcSectionalAreaIntegralMeasure = REAL; 
	o.class_name = "IFCSECTIONALAREAINTEGRALMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.77
function IFCSECTIONMODULUSMEASURE(o)  --IfcSectionModulusMeasure = REAL; 
	o.class_name = "IFCSECTIONMODULUSMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.78
function IFCSHEARMODULUSMEASURE(o)  --IfcShearModulusMeasure = REAL; 
	o.class_name = "IFCSHEARMODULUSMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.79
function IFCSOLIDANGLEMEASURE(o)  --IfcSolidAngleMeasure = REAL; 
	o.class_name = "IFCSOLIDANGLEMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.80
function IFCSOUNDPOWERMEASURE(o)  --IfcSoundPowerMeasure = REAL; 
	o.class_name = "IFCSOUNDPOWERMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.81
function IFCSOUNDPRESSUREMEASURE(o)  --IfcSoundPressureMeasure = REAL; 
	o.class_name = "IFCSOUNDPRESSUREMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.82
function IFCSPECIFICHEATCAPACITYMEASURE(o)  --IfcSpecificHeatCapacityMeasure = REAL; 
	o.class_name = "IFCSPECIFICHEATCAPACITYMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.83
function IFCTEMPERATUREGRADIENTMEASURE(o)  --IfcTemperatureGradientMeasure = REAL; 
	o.class_name = "IFCTEMPERATUREGRADIENTMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.84
function IFCTEMPERATURERATEOFCHANGEMEASURE(o)  --IfcTemperatureRateOfChangeMeasure = REAL; 
	o.class_name = "IFCTEMPERATURERATEOFCHANGEMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.85
function IFCTEXT(o)  --IfcText = STRING; 
	o.class_name = "IFCTEXT"
	o.style = "STRING"
	return o
end

--R8.11.2.86
function IFCTHERMALADMITTANCEMEASURE(o)  --IfcThermalAdmittanceMeasure = REAL; 
	o.class_name = "IFCTHERMALADMITTANCEMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.87
function IFCTHERMALCONDUCTIVITYMEASURE(o)  --IfcThermalConductivityMeasure = REAL; 
	o.class_name = "IFCTHERMALCONDUCTIVITYMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.88
function IFCTHERMALEXPANSIONCOEFFICIENTMEASURE(o)  --IfcThermalExpansionCoefficientMeasure = REAL; 
	o.class_name = "IFCTHERMALEXPANSIONCOEFFICIENTMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.89
function IFCTHERMALRESISTANCEMEASURE(o)  --IfcThermalResistanceMeasure = REAL; 
	o.class_name = "IFCTHERMALRESISTANCEMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.90
function IFCTHERMALTRANSMITTANCEMEASURE(o)  --IfcThermalTransmittanceMeasure = REAL; 
	o.class_name = "IFCTHERMALTRANSMITTANCEMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.91
function IFCTHERMODYNAMICTEMPERATUREMEASURE(o)  --IfcThermodynamicTemperatureMeasure = REAL; 
	o.class_name = "IFCTHERMODYNAMICTEMPERATUREMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.92
function IFCTIMEMEASURE(o)  --IfcTimeMeasure = REAL; 
	o.class_name = "IFCTIMEMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.93
function IFCTORQUEMEASURE(o)  --IfcTorqueMeasure = REAL; 
	o.class_name = "IFCTORQUEMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.94
function IFCVAPORPERMEABILITYMEASURE(o)  --IfcVaporPermeabilityMeasure = REAL; 
	o.class_name = "IFCVAPORPERMEABILITYMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.95
function IFCVOLUMEMEASURE(o)  --IfcVolumeMeasure = REAL; 
	o.class_name = "IFCVOLUMEMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.96
function IFCVOLUMETRICFLOWRATEMEASURE(o)  --IfcVolumetricFlowRateMeasure = REAL; 
	o.class_name = "IFCVOLUMETRICFLOWRATEMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.97
function IFCWARPINGCONSTANTMEASURE(o)  --IfcWarpingConstantMeasure = REAL; 
	o.class_name = "IFCWARPINGCONSTANTMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.98
function IFCWARPINGMOMENTMEASURE(o)  --IfcWarpingMomentMeasure = REAL; 
	o.class_name = "IFCWARPINGMOMENTMEASURE"
	o.style = "REAL"
	return o
end

--R8.11.2.99
function IFCDERIVEDUNITENUM(o)  --IfcDerivedUnitEnum = ENUMERATION OF (; 
	o.class_name = "IFCDERIVEDUNITENUM"
	o.style = "ENUMERATION"
	return o
end
--[[IfcDerivedUnitEnum = ENUMERATION OF (  
 ANGULARVELOCITYUNIT, 
COMPOUNDPLANEANGLEUNIT, 
DYNAMICVISCOSITYUNIT, 
HEATFLUXDENSITYUNIT, 
INTEGERCOUNTRATEUNIT, 
ISOTHERMALMOISTURECAPACITYUNIT, 
KINEMATICVISCOSITYUNIT, 
LINEARVELOCITYUNIT, 
MASSDENSITYUNIT, 
MASSFLOWRATEUNIT, 
MOISTUREDIFFUSIVITYUNIT, 
MOLECULARWEIGHTUNIT, 
SPECIFICHEATCAPACITYUNIT, 
THERMALADMITTANCEUNIT, 
THERMALCONDUCTANCEUNIT, 
THERMALRESISTANCEUNIT, 
THERMALTRANSMITTANCEUNIT, 
VAPORPERMEABILITYUNIT, 
VOLUMETRICFLOWRATEUNIT, 
ROTATIONALFREQUENCYUNIT, 
TORQUEUNIT, 
MOMENTOFINERTIAUNIT, 
LINEARMOMENTUNIT, 
LINEARFORCEUNIT, 
PLANARFORCEUNIT, 
MODULUSOFELASTICITYUNIT, 
SHEARMODULUSUNIT, 
LINEARSTIFFNESSUNIT, 
ROTATIONALSTIFFNESSUNIT, 
MODULUSOFSUBGRADEREACTIONUNIT, 
ACCELERATIONUNIT, 
CURVATUREUNIT, 
HEATINGVALUEUNIT, 
IONCONCENTRATIONUNIT, 
LUMINOUSINTENSITYDISTRIBUTIONUNIT, 
MASSPERLENGTHUNIT, 
MODULUSOFLINEARSUBGRADEREACTIONUNIT, 
MODULUSOFROTATIONALSUBGRADEREACTIONUNIT, 
PHUNIT, 
ROTATIONALMASSUNIT, 
SECTIONAREAINTEGRALUNIT, 
SECTIONMODULUSUNIT, 
SOUNDPOWERUNIT, 
SOUNDPRESSUREUNIT, 
TEMPERATUREGRADIENTUNIT, 
TEMPERATURERATEOFCHANGE, 
THERMALEXPANSIONCOEFFICIENTUNIT, 
WARPINGCONSTANTUNIT, 
WARPINGMOMENTUNIT, 
USERDEFINED);  
END_TYPE;  
--]]

--R8.11.2.100
function IFCSIPREFIX(o)  --IfcSIPrefix = ENUMERATION OF (  
	o.class_name = "IFCSIPREFIX"
	o.style = "ENUMERATION"
	return o
end
--[[TYPE IfcSIPrefix = ENUMERATION OF (  
 EXA, 
PETA, 
TERA, 
GIGA, 
MEGA, 
KILO, 
HECTO, 
DECA, 
DECI, 
CENTI, 
MILLI, 
MICRO, 
NANO, 
PICO, 
FEMTO, 
ATTO);  
END_TYPE;  
--]]

--R8.11.2.101
function IFCSIUNITNAME(o)  --IfcSIUnitName = ENUMERATION OF (  
	o.class_name = "IFCSIUNITNAME"
	o.style = "ENUMERATION"
	return o
end
--[[TYPE IfcSIUnitName = ENUMERATION OF (  
 AMPERE, 
BECQUEREL, 
CANDELA, 
COULOMB, 
CUBIC_METRE, 
DEGREE_CELSIUS, 
FARAD, 
GRAM, 
GRAY, 
HENRY, 
HERTZ, 
JOULE, 
KELVIN, 
LUMEN, 
LUX, 
METRE, 
MOLE, 
NEWTON, 
OHM, 
PASCAL, 
RADIAN, 
SECOND, 
SIEMENS, 
SIEVERT, 
SQUARE_METRE, 
STERADIAN, 
TESLA, 
VOLT, 
WATT, 
WEBER);  
END_TYPE;  
--]]

--R8.11.2.102
function IFCUNITENUM(o)  --IfcUnitEnum = ENUMERATION OF (  
	o.class_name = "IFCUNITENUM"
	o.style = "ENUMERATION"
	return o
end
--[[TYPE IfcUnitEnum = ENUMERATION OF (  
 ABSORBEDDOSEUNIT, 
AMOUNTOFSUBSTANCEUNIT, 
AREAUNIT, 
DOSEEQUIVALENTUNIT, 
ELECTRICCAPACITANCEUNIT, 
ELECTRICCHARGEUNIT, 
ELECTRICCONDUCTANCEUNIT, 
ELECTRICCURRENTUNIT, 
ELECTRICRESISTANCEUNIT, 
ELECTRICVOLTAGEUNIT, 
ENERGYUNIT, 
FORCEUNIT, 
FREQUENCYUNIT, 
ILLUMINANCEUNIT, 
INDUCTANCEUNIT, 
LENGTHUNIT, 
LUMINOUSFLUXUNIT, 
LUMINOUSINTENSITYUNIT, 
MAGNETICFLUXDENSITYUNIT, 
MAGNETICFLUXUNIT, 
MASSUNIT, 
PLANEANGLEUNIT, 
POWERUNIT, 
PRESSUREUNIT, 
RADIOACTIVITYUNIT, 
SOLIDANGLEUNIT, 
THERMODYNAMICTEMPERATUREUNIT, 
TIMEUNIT, 
VOLUMEUNIT, 
USERDEFINED);  
END_TYPE;  
--]]

--R8.11.2.103
--[[TYPE IfcDerivedMeasureValue = SELECT (  
 IfcVolumetricFlowRateMeasure, 
IfcThermalTransmittanceMeasure, 
IfcThermalResistanceMeasure, 
IfcThermalAdmittanceMeasure, 
IfcPressureMeasure, 
IfcPowerMeasure, 
IfcMassFlowRateMeasure, 
IfcMassDensityMeasure, 
IfcLinearVelocityMeasure, 
IfcKinematicViscosityMeasure, 
IfcIntegerCountRateMeasure, 
IfcHeatFluxDensityMeasure, 
IfcFrequencyMeasure, 
IfcEnergyMeasure, 
IfcElectricVoltageMeasure, 
IfcDynamicViscosityMeasure, 
IfcCompoundPlaneAngleMeasure, 
IfcAngularVelocityMeasure, 
IfcThermalConductivityMeasure, 
IfcMolecularWeightMeasure, 
IfcVaporPermeabilityMeasure, 
IfcMoistureDiffusivityMeasure, 
IfcIsothermalMoistureCapacityMeasure, 
IfcSpecificHeatCapacityMeasure, 
IfcMonetaryMeasure, 
IfcMagneticFluxDensityMeasure, 
IfcMagneticFluxMeasure, 
IfcLuminousFluxMeasure, 
IfcForceMeasure, 
IfcInductanceMeasure, 
IfcIlluminanceMeasure, 
IfcElectricResistanceMeasure, 
IfcElectricConductanceMeasure, 
IfcElectricChargeMeasure, 
IfcDoseEquivalentMeasure, 
IfcElectricCapacitanceMeasure, 
IfcAbsorbedDoseMeasure, 
IfcRadioActivityMeasure, 
IfcRotationalFrequencyMeasure, 
IfcTorqueMeasure, 
IfcAccelerationMeasure, 
IfcLinearForceMeasure, 
IfcLinearStiffnessMeasure, 
IfcModulusOfSubgradeReactionMeasure, 
IfcModulusOfElasticityMeasure, 
IfcMomentOfInertiaMeasure, 
IfcPlanarForceMeasure, 
IfcRotationalStiffnessMeasure, 
IfcShearModulusMeasure, 
IfcLinearMomentMeasure, 
IfcLuminousIntensityDistributionMeasure, 
IfcCurvatureMeasure, 
IfcMassPerLengthMeasure, 
IfcModulusOfLinearSubgradeReactionMeasure, 
IfcModulusOfRotationalSubgradeReactionMeasure, 
IfcRotationalMassMeasure, 
IfcSectionalAreaIntegralMeasure, 
IfcSectionModulusMeasure, 
IfcTemperatureGradientMeasure, 
IfcThermalExpansionCoefficientMeasure, 
IfcWarpingConstantMeasure, 
IfcWarpingMomentMeasure, 
IfcSoundPowerMeasure, 
IfcSoundPressureMeasure, 
IfcHeatingValueMeasure, 
IfcPHMeasure, 
IfcIonConcentrationMeasure, 
IfcTemperatureRateOfChangeMeasure);  
END_TYPE;  
--]]

--R8.11.2.104
--[[TYPE IfcMeasureValue = SELECT (  
 IfcVolumeMeasure, 
IfcTimeMeasure, 
IfcThermodynamicTemperatureMeasure, 
IfcSolidAngleMeasure, 
IfcPositiveRatioMeasure, 
IfcRatioMeasure, 
IfcPositivePlaneAngleMeasure, 
IfcPlaneAngleMeasure, 
IfcParameterValue, 
IfcNumericMeasure, 
IfcMassMeasure, 
IfcPositiveLengthMeasure, 
IfcLengthMeasure, 
IfcElectricCurrentMeasure, 
IfcDescriptiveMeasure, 
IfcCountMeasure, 
IfcContextDependentMeasure, 
IfcAreaMeasure, 
IfcAmountOfSubstanceMeasure, 
IfcLuminousIntensityMeasure, 
IfcNormalisedRatioMeasure, 
IfcComplexNumber, 
IfcNonNegativeLengthMeasure);  
END_TYPE;  
--]]

--R8.11.2.105
--[[ TYPE IfcSimpleValue = SELECT (  
 IfcInteger, 
IfcReal, 
IfcBoolean, 
IfcIdentifier, 
IfcText, 
IfcLabel, 
IfcLogical, 
IfcDateTime, 
IfcDate, 
IfcTime, 
IfcDuration, 
IfcTimeStamp);  
END_TYPE;  
--]]

--R8.11.2.106
--[[TYPE IfcUnit = SELECT (  
 IfcDerivedUnit, 
IfcNamedUnit, 
IfcMonetaryUnit);  
END_TYPE;  
--]]

--R8.11.2.107
--[[TYPE IfcValue = SELECT (  
 IfcMeasureValue, 
IfcSimpleValue, 
IfcDerivedMeasureValue);  
END_TYPE;  
--]]

--8.11.3	Entities
--R8.11.3.1
IFCCONTEXTDEPENDENTUNIT = {param = 1, name = "IFCCONTEXTDEPENDENTUNIT"} 
--[[ENTITY IfcContextDependentUnit  
 SUBTYPE OF IfcNamedUnit;  
	Name :  IfcLabel; 
 INVERSE  
	HasExternalReference :  SET OF IfcExternalReferenceRelationship FOR RelatedResourceObjects; --]]

--R8.11.3.2
IFCCONVERSIONBASEDUNIT = {param = 2, name = "IFCCONVERSIONBASEDUNIT"} --IfcConversionBasedUnit = {}
--[[ENTITY IfcConversionBasedUnit  
 SUPERTYPE OF(IfcConversionBasedUnitWithOffset)  
 SUBTYPE OF IfcNamedUnit;  
	Name :  IfcLabel; 
	ConversionFactor :  IfcMeasureWithUnit; 
 INVERSE  
	HasExternalReference :  SET OF IfcExternalReferenceRelationship FOR RelatedResourceObjects; --]]
--#21=IFCCONVERSIONBASEDUNIT(#19,.PLANEANGLEUNIT.,'DEGREE',#20);
--#19=IFCDIMENSIONALEXPONENTS(0,0,0,0,0,0,0);
--#18=IFCSIUNIT(*,.PLANEANGLEUNIT.,$,.RADIAN.);
--#20=IFCMEASUREWITHUNIT(IFCRATIOMEASURE(0.01745329251994328),#18);
function IFCCONVERSIONBASEDUNIT:create_siunit(xing,unit_type,prefix,name)
	local siunit = ifcnew(ifc.IFCSIUNIT);
	siunit:set(xing,unit_type,prefix,name)
	return siunit
	
end

function IFCCONVERSIONBASEDUNIT:create_measure_with_unit()
	local dim_alex = ifcnew(ifc.IFCMEASUREWITHUNIT);
	local siunit = self:create_siunit("*",".PLANEANGLEUNIT.","$",".RADIAN.");
	dim_alex:set("IFCRATIOMEASURE(0.01745329251994328)",siunit)
	return dim_alex
	
end
function IFCCONVERSIONBASEDUNIT:set()
	IFCNAMEDUNIT:set(self);
	self[3] = "'DEGREE'";
	self[4] = self:create_measure_with_unit();
end
--R8.11.3.3
IFCCONVERSIONBASEDUNITWITHOFFSET = {param=1, name = "IFCCONVERSIONBASEDUNITWITHOFFSET"} 
--[[ENTITY IfcConversionBasedUnitWithOffset  
 SUBTYPE OF IfcConversionBasedUnit;  
	ConversionOffset :  IfcReal; --]]

--R8.11.3.4
IFCDERIVEDUNIT = {param = 3, name = "IFCDERIVEDUNIT"} --IfcDerivedUnit = {} 
--[[ENTITY IfcDerivedUnit;  
		Elements :  SET [1:?] OF IfcDerivedUnitElement; 
		UnitType :  IfcDerivedUnitEnum; 
		UserDefinedType :  OPTIONAL IfcLabel; 
	DERIVE  
		Dimensions :  IfcDimensionalExponents := IfcDeriveDimensionalExponents(Elements); 
 	WHERE  
		WR1 :  (SIZEOF (Elements) > 1) OR ((SIZEOF (Elements) = 1) AND (Elements[1].Exponent <> 1 )) 
		WR2 :  (UnitType <> IfcDerivedUnitEnum.USERDEFINED) OR ((UnitType = IfcDerivedUnitEnum.USERDEFINED) AND (EXISTS(SELF.UserDefinedType))) --]] 

--R8.11.3.5
IFCDERIVEDUNITELEMENT = {param = 2, name = "IFCDERIVEDUNITELEMENT"} --IfcDerivedUnitElement = {Unit = IfcNamedUnit, Exponent = INTEGER}
--[[	ENTITY IfcDerivedUnitElement;  
			Unit :  IfcNamedUnit; 
			Exponent :  INTEGER; 	--]]

--R8.11.3.6
IFCDIMENSIONALEXPONENTS = {param = 7, name = "IFCDIMENSIONALEXPONENTS"} --IfcDimensionalExponents = {} 
--[[	ENTITY IfcDimensionalExponents;  
			LengthExponent :  INTEGER; 
			MassExponent :  INTEGER; 
			TimeExponent :  INTEGER; 
			ElectricCurrentExponent :  INTEGER; 
			ThermodynamicTemperatureExponent :  INTEGER; 
			AmountOfSubstanceExponent :  INTEGER; 
			LuminousIntensityExponent :  INTEGER; --]]			 
function IFCDIMENSIONALEXPONENTS:set()
	self[1] = 0
	self[2] = 0
	self[3] = 0
	self[4] = 0
	self[5] = 0
	self[6] = 0
	self[7] = 0
end
--R8.11.3.7
IFCMEASUREWITHUNIT = {param = 2, name = "IFCMEASUREWITHUNIT"} --IfcMeasureWithUnit = {}
--[[ENTITY IfcMeasureWithUnit;  
	ValueComponent :  IfcValue; 
	UnitComponent :  IfcUnit; --]] 
function IFCMEASUREWITHUNIT:set(val,unit)
	self[1] = val;
	self[2] = unit;
end
--R8.11.3.8
IFCMONETARYUNIT = {param = 1, name = "IFCMONETARYUNIT"} --IfcMonetaryUnit = {Currency = IfcLabel}
--[[	ENTITY IfcMonetaryUnit;  
			Currency :  IfcLabel; 	==]]

--R8.11.3.9
IFCNAMEDUNIT = {param =2, name = "IFCNAMEDUNIT"} --IfcNamedUnit = {Dimensions = IfcDimensionalExponents, UnitType = IfcUnitEnum} 
--[[	ENTITY IfcNamedUnit  
		ABSTRACT SUPERTYPE OF(ONEOF(IfcContextDependentUnit, IfcConversionBasedUnit, IfcSIUnit));  
			Dimensions :  IfcDimensionalExponents; 
			UnitType :  IfcUnitEnum; 
		WHERE  
			WR1 :  IfcCorrectDimensions (SELF.UnitType, SELF.Dimensions)   --]]
--#21=IFCCONVERSIONBASEDUNIT(#19,.PLANEANGLEUNIT.,'DEGREE',#20);
--#19=IFCDIMENSIONALEXPONENTS(0,0,0,0,0,0,0);
function IFCNAMEDUNIT:create_dimension_alexponent()
	local dim_alex = ifcnew(ifc.IFCDIMENSIONALEXPONENTS);
	dim_alex:set()
	return dim_alex
	
end
function IFCNAMEDUNIT:set()
	self[1] = self:create_dimension_alexponent();
	self[2] = ".PLANEANGLEUNIT.";
end
--R8.11.3.10
IFCSIUNIT = {param =2, name = "IFCSIUNIT"} --IfcSIUnit = {Prefix = IfcSIPrefix, Name = IfcSIUnitName}
--[[	ENTITY IfcSIUnit  
		SUBTYPE OF IfcNamedUnit;  
			Prefix :  OPTIONAL IfcSIPrefix; 
			Name :  IfcSIUnitName; 
		DERIVE  
			SELF\IfcNamedUnit.Dimensions :  IfcDimensionalExponents := IfcDimensionsForSiUnit (SELF.Name); --]]  
function IFCSIUNIT:set(xing,unit_type,prefix,name)
	self[1] = xing
	self[2] = unit_type
	self[3] = prefix
	self[4] = name
end
--R8.11.3.11
IFCUNITASSIGNMENT = {param =1, name = "IFCUNITASSIGNMENT"} --IfcUnitAssignment = { Units = IfcUnit}	--SET [1:?] 
 --[[	ENTITY IfcUnitAssignment;  
			Units :  SET [1:?] OF IfcUnit; 
		WHERE  
			WR01 :  IfcCorrectUnitAssignment(Units) --]]
--[[			
#15=IFCSIUNIT(*,.LENGTHUNIT.,.MILLI.,.METRE.);
#16=IFCSIUNIT(*,.AREAUNIT.,.MILLI.,.SQUARE_METRE.);
#17=IFCSIUNIT(*,.VOLUMEUNIT.,.MILLI.,.CUBIC_METRE.);
#21=IFCCONVERSIONBASEDUNIT(#19,.PLANEANGLEUNIT.,'DEGREE',#20);
#22=IFCSIUNIT(*,.TIMEUNIT.,$,.SECOND.);
#23=IFCUNITASSIGNMENT((#15,#16,#17,#21,#22));

--]]
function IFCUNITASSIGNMENT:create_conversion_based_unit()
	local conversion = ifcnew(ifc.IFCCONVERSIONBASEDUNIT);
	conversion:set()
	return conversion
	
end
function IFCUNITASSIGNMENT:create_unit(xing,unit_type,prefix,name)
	local siunit = ifcnew(ifc.IFCSIUNIT);
	siunit:set(xing,unit_type,prefix,name)
	return siunit
	
end

function IFCUNITASSIGNMENT:create_list(list)
	local unit1 = self:create_unit("*",".LENGTHUNIT.",".MILLI.",".METRE.");
	table.insert(list,unit1);
	local unit2 = self:create_unit("*",".AREAUNIT.",".MILLI.",".SQUARE_METRE.");
	table.insert(list,unit2);
	local unit3 = self:create_unit("*",".VOLUMEUNIT.",".MILLI.",".CUBIC_METRE.");
	table.insert(list,unit3);
	local unit3 = self:create_conversion_based_unit();
	table.insert(list,unit3);
	local unit4 = self:create_unit("*",".VOLUMEUNIT.","$",".SECOND.");
	table.insert(list,unit4);
	
end
function IFCUNITASSIGNMENT:set()
	list = {}
	self:create_list(list);	
	self[1] = list
end
setparent(IFCNAMEDUNIT, IFCCONTEXTDEPENDENTUNIT)					--R8.11.3.01
setparent(IFCCONVERSIONBASEDUNIT, IFCCONVERSIONBASEDUNITWITHOFFSET)	--R8.11.3.03
setparent(IFCNAMEDUNIT, IFCCONVERSIONBASEDUNIT)						--R8.11.3.02
setparent(IFCNAMEDUNIT, IFCSIUNIT)									--R8.11.3.10
