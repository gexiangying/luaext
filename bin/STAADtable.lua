package.path="?;?.lua;?.dll"
setfenv(1,STAAD)
--f = io.open ("D:\\out.s2k","w+")
--f:write("sline = ", sline, "\n")
--f:close()

UNIT_TABLE_LENGTH = {INCHES = true, FEET = true, METER = true, CM = true, MMS = true, DME = true, KM = true}
UNIT_TABLE_FORCE = {KIP = true, POUND = true, KG  = true, MTON = true, NEWTON = true,    	KNS = true, KN = true, MNS = true, DNS = true }
UNIT_TABLE_TIME = {HOUR = true, MINUTE = true, SECOND  = true }
UNIT_TABLE_ANGLE = { DEGREE = true, RADIAN = true }
UNIT_TABLE_FREQUENCY = {HZ = true, KHZ = true, MHZ  = true }

function find_key(line)
	local key
	if string.sub(line,1,5) == "STAAD" then
		key = "STAAD"
	elseif string.sub(line,1,4) == "UNIT" then
		key = "UNIT"
	elseif string.sub(line,1,21) == "START JOB INFORMATION" then
		key = "START JOB INFORMATION"
	elseif string.sub(line,1,17) == "JOINT COORDINATES" then
		key = "JOINT COORDINATES"
	elseif string.sub(line,1,17) == "MEMBER INCIDENCES" then
		key = "MEMBER INCIDENCES"
	elseif string.sub(line,1,24) == "ELEMENT INCIDENCES SHELL" then
		key = "ELEMENT INCIDENCES SHELL"
	elseif string.sub(line,1,24) == "ELEMENT INCIDENCES SOLID" then
		key = "ELEMENT INCIDENCES SOLID"
	elseif string.sub(line,1,21) == "DEFINE MATERIAL START" then
		key = "DEFINE MATERIAL START"
	elseif string.sub(line,1,15) == "MEMBER PROPERTY" then
		key = "MEMBER PROPERTY"
	elseif string.sub(line,1,9) == "CONSTANTS" then
		key = "CONSTANTS"
	elseif string.sub(line,1,8) == "SUPPORTS" then
		key = "SUPPORTS"
	elseif string.sub(line,1,14) == "MEMBER RELEASE" then
		key = "MEMBER RELEASE"
	elseif string.sub(line,1,4) == "LOAD" then
		key = "LOAD"
	elseif string.sub(line,1,16) == "PERFORM ANALYSIS" then
		key = "PERFORM ANALYSIS"
	elseif string.sub(line,1,6) == "FINISH" then
		key = "FINISH"
	elseif string.sub(line,1,16) == "ELEMENT PROPERTY" then
		key = "ELEMENT PROPERTY"
--	elseif string.sub(line,1,5) == "STAAD" then
--		key = "STAAD"
--	elseif string.sub(line,1,5) == "STAAD" then
--		key = "STAAD"
	end
	return key
end

command_description = {}
	command_description["STAAD"] = function(val)	
		local s, i = "", 0
		local tab = treat_command(val, 2)
		return tab
	end
	command_description["UNIT"] = function(val)
		local tab = new(unit_tab[#unit_tab])
		for str in string.gmatch(val,"([^ ]+)") do 
			if UNIT_TABLE_LENGTH[str] then 
				tab.length = str
			elseif UNIT_TABLE_FORCE[str] then
				tab.force = str 
			elseif UNIT_TABLE_TIME[str] then 
				tab.time = str
			elseif UNIT_TABLE_ANGLE[str] then
				tab.angle = str
			elseif UNIT_TABLE_FREQUENCY[str] then
				tab.frequency = str
			end
		end 
		table.insert(unit_tab, tab)	
		return tab
	end	
	command_description["START JOB INFORMATION"] = function(val) 	
		return {tostring(val)} end
	command_description["JOINT COORDINATES"] = function(val) 	
		end
	command_description["MEMBER INCIDENCES"] = function(val) 	
		end
	command_description["ELEMENT INCIDENCES SHELL"] = function(val) 	
		end
	command_description["ELEMENT INCIDENCES SOLID"] = function(val) 	
		end
	command_description["DEFINE MATERIAL START"] = function(val) 	
		end
	command_description["MEMBER PROPERTY"] = function(val) 	
		local tab = treat_command(val, 3)
		return tab 
		end
	command_description["CONSTANTS"] = function(val) 	
		end	
	command_description["SUPPORTS"] = function(val) 	
		end	
	command_description["MEMBER RELEASE"] = function(val) 	
		end	
	command_description["LOAD"] = function(val) 	
		local s, i = "", 0
		local tab = treat_command(val, 2)
		return tab
	end
	command_description["PERFORM ANALYSIS"] = function(val) 	
		end	
	command_description["FINISH"] = function(val) 	
		end	
	command_description["ELEMENT PROPERTY"] = function(val) 	
		end	
--	command_description["CONSTANTS"] = function(val) 	
--		end	
--	command_description["CONSTANTS"] = function(val) 	
--		end	
	
pram_description = {}
	pram_description["STAAD"] = function(val)	
		end
	pram_description["UNIT"] = function(val)
		end
	pram_description["START JOB INFORMATION"] = function(val) 	
		return tostring(val) end
	pram_description["JOINT COORDINATES"] = function(val) 	
		return data_to_data(val) end
	pram_description["MEMBER INCIDENCES"] = function(val) 	
		return data_to_data(val) end
	pram_description["ELEMENT INCIDENCES SHELL"] = function(val) 	
		return data_to_data(val) end
	pram_description["ELEMENT INCIDENCES SOLID"] = function(val) 	
		return data_to_data(val) end
	pram_description["DEFINE MATERIAL START"] = function(val) 	
		return tostring(val) end
	pram_description["MEMBER PROPERTY"] = function(val) 	
		return treat_incontinuity_list(val) end
	pram_description["CONSTANTS"] = function(val) 	
		return tostring(val) end
	pram_description["SUPPORTS"] = function(val) 	
		return tostring(val) end
	pram_description["MEMBER RELEASE"] = function(val) 	
		return treat_incontinuity_list(val) end
	pram_description["LOAD"] = function(val) 	
		return tostring(val) end
	pram_description["PERFORM ANALYSIS"] = function(val) 	
		return tostring(val) end
	pram_description["FINISH"] = function(val) 	
		return tostring(val) end
	pram_description["ELEMENT PROPERTY"] = function(val) 	
		return treat_incontinuity_list(val) end
--	pram_description["CONSTANTS"] = function(val) 	
--		return tostring(val) end
--	pram_description["CONSTANTS"] = function(val) 	
--		return tostring(val) end

--treat the param in command line (val), numTH word will be considered as command following part will be considered as note
function treat_command(val, num) 
	local s, i = "", 0
	local tab = {}
	for str in string.gmatch(val,"([^ ]+)") do 
		i = i + 1
		if i == num then
			tab.command = str
		elseif i > num then
			s = s..str.." "
		end
		if i > num then tab.note = s end
	end		
	return tab
end

function find_param(line)
	local i=0; local j=0
	if not string.find(line, "%w") then return nil end  -- for empty line
	for k, v in ipairs(line) do
		i = string.find(str, "\n", i+1)	-- find 'next' newline
		if i == nil then break end
		line = string.sub(str, j+1, i-1) 
		j = i
	end
end

function data_to_data(val)
	local tab = {}
	local t = {}
	for str in string.gmatch(val,"([^ ]+)") do 
		if string.sub(str, -1) == ";" then
			table.insert(t, tonumber(string.sub(str,1,-2)))
			table.insert(tab, t)
			t = {}
		else
			table.insert(t, tonumber(str))
		end
	end
	return tab
end

function set_unit_default()
	local tab = {}
	tab = {}
	tab.length = "METER"
	tab.force  = "KNS"
	tab.time  = "SECOND"
	tab.angle  = "DEGREE"
	tab.frequency  = "HZ"
	return tab
end

-- to stop the current key input by the end command in order to avoid the continue input by wrong input file
function check_key_end(line)  
	local s = false
	if string.sub(line,1,19) == "END JOB INFORMATION" then
		s = true
	elseif string.sub(line,1,19) == "END DEFINE MATERIAL" then
		s = true
	end
	return s
end

function treat_incontinuity_list(line)  --checked
	local tab = {}
	local s
	local i = 1
	tab.num = {}
	tab.str = {}
	for ps, b, e, pe in string.gmatch(line,"()(%d*)%s*TO%s*(%d*)()") do 
		if b then 
			b = tonumber(b) 
		else
			error_message("201", "treat_incontinuity_list")
		end
		if e then 
			e = tonumber(e) 
		else
			error_message("202", "treat_incontinuity_list")
		end
		s = string.sub(line, i, ps-1)
		for str in string.gmatch(s,"([^ ]+)") do	
			table.insert(tab.num, tonumber(str))
		end
		for j = b, e do 
			table.insert(tab.num, j)
		end
		i = pe+1
	end
	if not i then i = 1 end
	s = string.sub(line, i, -1)
	for str in string.gmatch(s,"([^ ]+)") do
		if str then
			if string.find(str, "%a") then
				table.insert(tab.str, tostring(str))
			else
				table.insert(tab.num, tonumber(str))
			end
		end	
	end 
	return tab
end

--  ~=