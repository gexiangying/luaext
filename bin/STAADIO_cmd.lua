package.path="?;?.lua"
require "STAAD"


local tool = require "steel_tools"

--f = io.open ("D:\\out.s2k","w+")
--f:write("sline = ", sline, "\n")
--f:close()

--  ################## for definition and general utilities  #######################
unit_tab = {}
database = {}



--  ################## for input data and treatment  #######################
--read input file from std document (just read and stored without treatment)
function read_input_file(input_file_name)  --read from input_file_name return input_str 
	local f = io.open(input_file_name,"r")	
	local str = f:read("*all")   --read entire input file without any treatment
	io.close()
	return str
end

--store the input file to table with keys
function string_to_table(str)  --to find \n and change the string to table
	local i, j = 0, 0
	local new_id = true
	local mline, s = ""
	local tab = {}
	while true do
		if new_id then mline = "" end
		i = string.find(str, "\n", i+1)	-- find 'next' newline
		if i == nil then break end
		line = string.sub(str, j+1, i-1) 
print ("line =",line)
		j = i
--for treatment of multiple lines
		line = STAAD.string_trim (line)
		s = check_multi_line(line, "-")
		if s then
			mline = mline..s
			new_id = false
		else
			mline = mline..line
			new_id = true
		end
--for transfer one line data from str to tab except the empty lines
		if string.find(mline, "%w") and not s then 
			table.insert(tab, mline)		
		end
	end
	return tab
end

function combin_multi_line(t)
	local new_id = true
	local mline, s = "", ""
	local tab ={}
	for key, v in ipairs(t) do 
		if new_id then mline = "" end
		if t[key+1] then 
			s = t[key+1]
		else s = ""
		end
		mline = mline..v
		if string.sub(v,-1,-1) == ";" and string.sub(s,-1, -1) ==";" then
			new_id = false
		else 
			table.insert(tab, mline)
			new_id = true
		end
	end
	return tab
end

--for treatment of the multiple lines
function check_multi_line(line, marker)  --marker (string) = symbol of continue line
	local str = STAAD.string_trim (line)
	if string.sub(str, -1, -1) == marker then
		str = string.sub(str, 1, -2)
	else
		str = nil
	end
	return str
end

--  ############# separate Line Parameters and setup the STAAD Database############
function create_data_blk(input_tab)  --creat the data blok
	local tab = {}
	local t = {}
	local key, newkey, i, mkey
	table.insert(unit_tab, STAAD.set_unit_default())
	for k, line in ipairs(input_tab) do
--print (line)
		newkey = STAAD.find_key(line) -- find a new key and stroe in the table
	print (line, "  ", newkey)
		if newkey then
			key = newkey
			if key == "FINISH" then break end
			t = STAAD.command_description[key](line)
			if key ~= "UNIT" then
				mkey = key
				if tab[key] then
					i = 0
					while true do
						i = i + 1
						mkey = key..i
						if not tab[mkey] then break end
					end				
				end
				tab[mkey] = {}
				tab[mkey].key = key
				tab[mkey].param = {}
				tab[mkey].unit = unit_tab[#unit_tab]
				if t then tab[mkey].param = t end
			end
		elseif STAAD.check_key_end(line) then
			key = false
		elseif key then
			t = STAAD.pram_description[key](line)
			if t and key ~= "UNIT" then
				if key=="JOINT COORDINATES" or key=="MEMBER INCIDENCES" then
					for k, v in ipairs(t) do table.insert(tab[mkey].param, v) end
				else
					table.insert(tab[mkey].param, t)				
				end
			end
		end
	end
	return tab
end

--  ################## for input data and treatment  #######################
-- store input file to data_blk
function store_stad_input(input_file_name) 
	local input_str = read_input_file(input_file_name)--read entire input file only
	local input_tab = string_to_table(input_str)
--	local t = string_to_table(input_str)
--	local input_tab = combin_multi_line(t)
	--output_file(input_tab)
	local tab = create_data_blk(input_tab)  --store the data part
	return tab
end

function output_file(tab)
	f = io.open ("D:\\out.std","w+")
	for k, v in pairs (tab) do
		f:write("k ="..k.."  str ="..v.. "\n")				
	end
	f:close()
end

--f = io.open ("D:\\out.s2k","w+")
database = store_stad_input("D:\\sss.std");
local coords = database["JOINT COORDINATES"];
local mems = database["MEMBER INCIDENCES"];
local pls = database["ELEMENT INCIDENCES SHELL"];
local pros = database["ELEMENT PROPERTY"];

tool.otrace(pros,"pros = ");
print(tostring(coords));
print(tostring(mems));
print(tostring(pls));
print(tostring(pros));


--output_database(database)
--f:close()
print ("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee")

