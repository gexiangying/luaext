setfenv(1,STAAD)
function error_message(code, function_name)		--print the error message
	local str = "Error Message -- Error Code <"..code.."> in Function ["..function_name.."]"
	print(str)
end

function new(tab, o)
	o = o or {}
	tab.__index = tab
	setmetatable(o, tab)
	return o
end

function string_trim (str)  --delet the space in both side of the lane
	return (string.gsub(str,"^%s*(.-)%s*$", "%1"))
end

--  ~=