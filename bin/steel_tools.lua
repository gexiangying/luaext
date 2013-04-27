module (...,package.seeall)

trace_out = trace_out or print;

function deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end


function tostrtab(tab, tip)
	local str_ = "";
	local col_ = -1;
	local strtab_ = {};
	
	local function get_col()
		local str="";
		for i=1, col_ do
			str = str.."    ";
		end	
		return str;
	end
	
	local function get_tip(tip)
		if not tip then 
			tip = get_col().."";
			return tip;
		end;
		if type(tip)=="number" then
			tip = get_col().."["..tip.."] = ";
			return tip;
		end	
		tip = get_col()..tip.." = ";
		return tip
	end
	
	local function out_other(tab, tip)
		if type(tab)=="nil" then
			str_ = tip.."nil;\n";
			strtab_[#strtab_+1] = str_;
			return;	
		end
		if type(tab)=="boolean" then
			if tab then
				str_ = tip.."true;\n";
				strtab_[#strtab_+1] = str_;
			else
				str_ = tip.."false;\n";
				strtab_[#strtab_+1] = str_;
			end
			return;		
		end
		if type(tab)=="number" or type(tab)=="string" then
			str_ = tip..tab..";\n";
			strtab_[#strtab_+1] = str_;
			return;
		end
		if type(tab)=="function" then
			str_ = tip.."function;\n";
			strtab_[#strtab_+1] = str_;
			return;
		end
	end

	local function get_metname(tab)
		local metname = "";
		local met = getmetatable(tab);
		if met then
			metname = met.name or "MetNoName"
		end
		return metname;
	end

	local function out(tab, tip)
		col_ = col_+1;
		tip = get_tip(tip);
		if type(tab) == "table" then
			str_ = tip..get_metname(tab).."{\n";
			strtab_[#strtab_+1] = str_;
			for k, v in pairs(tab) do
				if v~=tab then
					out(v, k);
				end
			end
			str_ = get_col(col).."};\n"	
			strtab_[#strtab_+1] = str_;
		else
			out_other(tab, tip);
		end
		col_ = col_-1;
	end
	
	out(tab, tip);
	return strtab_;
end

function tostr(tab, tip)
	local str = "";
	local strtab = tostrtab(tab,tip);
	for i,v in ipairs(strtab) do
		str = str..v;
	end
	return str;
end

function ocmd(tab, tip)
	local str = tostr(tab, tip);
	print(str);
end

function ofile(tab, tip)
	local strtab = tostrtab(tab,tip);
	io.output("a.c");
	for i,v in ipairs(strtab) do
		io.write(v);
	end
end
function ofile_name(file_name,tab, tip)
	local strtab = tostrtab(tab,tip);
	io.output(file_name,"a");
	--local f = io.open(file_name,"a");
	for i,v in ipairs(strtab) do
		io.write(v);
	end
	io.close();
end

function otrace(tab, tip)
	local strtab = tostrtab(tab,tip);
	for i,v in ipairs(strtab) do
		trace_out(v);
	end
end



-- function serialize(tab, tip)
	-- local str = "";
	-- local col = -1;
	
	-- local function get_col(col)
		-- local str="";
		-- for i=1, col do
			-- str = str.."    ";
		-- end	
		-- return str;
	-- end
	
	-- local function get_tip(tip)
		-- if not tip then 
			-- tip = get_col(col).."";
			-- return tip;
		-- end;
		-- if type(tip)=="number" then
			-- tip = get_col(col).."["..tip.."] = ";
			-- return tip;
		-- end	
		-- tip = get_col(col)..tip.." = ";
		-- return tip
	-- end
	
	-- local function out_other(tab, tip)zz
		-- if type(tab)=="nil" then
			-- str = str..tip.."nil;\n";
			-- return;	
		-- end
		-- if type(tab)=="boolean" then
			-- if tab then
				-- str = str..tip.."true;\n";
			-- else
				-- str = str..tip.."false;\n";
			-- end
			-- return;		
		-- end
		-- if type(tab)=="number" or type(tab)=="string" then
			-- str = str..tip..tab..";\n";
			-- return;
		-- end
	-- end

	-- local function get_metname(tab)
		-- local metname = "";
		-- local met = getmetatable(tab);
		-- if met then
			-- metname = met.name or "MetNoName"
		-- end
		-- return metname;
	-- end

	-- local function out(tab, tip)
		-- col = col+1;
		-- tip = get_tip(tip);
		-- if type(tab) == "table" then
			-- str = str..tip..get_metname(tab).."{\n";
			-- for k, v in pairs(tab) do
				-- out(v, k);
			-- end
			-- str =str.. get_col(col).."};\n"	
		-- else
			-- out_other(tab, tip);
		-- end
		-- col = col-1;
	-- end
	
	-- out(tab, tip);
	-- return str;
-- end


function ismet(T,o)
	local m = o
	repeat
		m = getmetatable(m);
		if m==T then return true end;
	until not m;
	return false;
end
 
--[[
function serialize(t)
	local mark={}
	local assign={}
	
	local function ser_table(tbl,parent)
		mark[tbl]=parent
		local tmp={}
		for k,v in pairs(tbl) do
			local key= type(k)=="number" and "["..k.."]" or k
			if type(v)=="table" then
				local dotkey= parent..(type(k)=="number" and key or "."..key)
				if mark[v] then
					table.insert(assign,dotkey.."="..mark[v])
				else
					table.insert(tmp, key.."="..ser_table(v,dotkey))
				end
			else
				table.insert(tmp, key.."="..v)
			end
		end
		return "{"..table.concat(tmp,",").."}"
	end
 
--	return "do local ret="..ser_table(t,"ret")..table.concat(assign," ").." return ret end"
	return ser_table(t, "")
end
--]]

-------------------------------------

function met(Type, o)
	o = o or {}
	Type.__index = Type;
	setmetatable(o, Type);
	return o;
end

-- function new(o, Type)
	-- o = {};
	-- met(o, Type)
	-- return o;
-- end
