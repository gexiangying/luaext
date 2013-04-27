
package.path = "?.lua; ?;" 

require "ifc"


local function create_tabs(tabs)
	local tab = {
				no = "#95",
				classname = "IFCOWNERHISTORY",
				data = "#95,#94,$,.NOCHANGE.,0,$,$,11223344",
				data_t = { 
					
				},
	
	}
	tabs["#95"] = tab

	tab = {
				no = "#94",
				classname = "IFCOWNERHISTORY",
				data = "#95,#94,$,.NOCHANGE.,0,$,$,11223344",
				data_t = {  
				
				}
	
	}
	tabs["#94"] = tab

	tab = {
				no = "#93",
				classname = "IFCOWNERHISTORY",
				data = "#95,#94,$,.NOCHANGE.,0,$,$,11223344",
				data_t = {  
					p1=tabs["#95"].data_t,
					p2=tabs["#94"].data_t,
					p3="$",
					p4=".NOCHANGE.",
					p5="0",
					p6="$",
					p7="$",
					p8="11223344"
				}
	
	}
	tabs["#93"] = tab
	tabs["#40"] = tab
	tab = {
				no = "#35",
				classname = "IFCBUILDING",
				data = "'3yyiyKxKL6Su8Ke68KujLP',#93,'Default Building',$,$,#40,$,$,.ELEMENT.,0.,0.,$",
				data_t = {  
					p1 = "'3yyiyKxKL6Su8Ke68KujLP'",
					p2 = tabs["#93"].data_t,
					p3 = "'Default Building'",
					p4 = "$",
					p5 = "$",
					
					p6 = tabs["#40"].data_t,
					p7 = "$",
					p8 = "$",
					p9 = ".ELEMENT.",
					p10 = "0.",
					p12 = "$",
				}
	
	}
	tabs["#35"] = tab
	
	tab = {
				no = "#10",
				classname = "IFCBEAM",
				data = "'1JFNwbAPj6YAtaJ4pnAqbH',#93,'Building Container',$,#35,(#33,#34)",
				data_t = {  
					p1="'1JFNwbAPj6YAtaJ4pnAqbH'",
					p2=tabs["#93"].data_t,
					p3="'Building Container'",
					p4="$",
					p5=tabs["#35"].data_t,						
					p6={
						p1 = {
						},
						p2 = {
						},
					},
				}
	}
	tabs["#10"] = tab	
	
		
	
	

end

local function create_class(class_name)
	if(class_name == "IFCBEAM" ) then 
		return ifc.new(ifc.IFCBEAM)
	elseif (class_name == "IFCOWNERHISTORY" ) then 
		
	
	end
	--]]
end
local function ifc_format(temp)
	for k,v in pairs(temp) do
		local ifc_new = create_class(v.classname)
		if( ifc_new) then 
			ifc_new:set(v.data_t) 
			v.ifc_t = ifc_new
		end
	end


end


function load_ifc(filename)
	local tabs = {}  -- { "#?" = { no= ; classname = ; data = ; data_t = { p1 = ; p2 = ; } ; ifc_t = {} }}
	
	create_tabs(tabs)
	ifc_format(tabs)
	
	

end

load_ifc("")