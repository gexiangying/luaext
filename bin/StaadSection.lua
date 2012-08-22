local steel_tools_ = require "steel_tools";
local trace_obj_ = require "trace_obj";
local staad_section_db = require "Staad_Section_DB";

module (...,package.seeall)

--american-------------------------------------------------------------

local function get_sect_prefix(name)
	if (name == "TUBE") then
		return "S";	
	elseif(name == "H") then
		return "H";
	else
		return "H";
	end
end
local function deal_american_params(params,mems_property)
	local mem_prop = {};
	mem_prop.index = params.num[1];
	mem_prop.kind = "american";
	mem_prop.name = params.str[3];
	mem_prop.th = params.num[2];
	mem_prop.wt = params.num[3];
	mem_prop.dt = params.num[4];
	
	local prefix = get_sect_prefix(mem_prop.name);
	local sect = prefix .. "-" .. mem_prop.wt .."*".. mem_prop.wt.."*".. mem_prop.th;
	mem_prop.section = sect;
		
	mems_property[mem_prop.index] = mem_prop;
end
local function deal_american(props,mems_property)
	for k in pairs(props.param) do
		if (k ~= "command")then
			deal_american_params(props.param[k],mems_property);
		end
	end	
end
--chinese-------------------------------------------------------------
local function deal_chinese_params(params,mems_property)
	local mem_prop = {};
	mem_prop.index = params.num[1];
	mem_prop.kind = "chinese";
	mem_prop.name = params.str[3];
	
	mem_prop.section = staad_section_db.get_section("chinese",mem_prop.name);
		
	mems_property[mem_prop.index] = mem_prop;
end

local function deal_chinese(props,mems_property)
	for k in pairs(props.param) do
		if (k ~= "command")then
			deal_chinese_params(props.param[k],mems_property);
		end
	end	

end
local function deal_self_define(props,mems_property)

end



deal_countrys_g = {
	["AMERICAN"] = deal_american,
	["CHINESE"] = deal_chinese,
	[""] = deal_self_define,
};


local function deal_mems_property(props,mems_property)
	local country = props.param.command;
	local fun = deal_countrys_g[country];
	if (fun)then
		fun(props,mems_property);
	end
end

function get_mems_property_segment(std_db,mems_property)
	local props = std_db["MEMBER PROPERTY"];
	if props then
		deal_mems_property(props,mems_property);
	end
	local i=1;
	while props do
		local key = "MEMBER PROPERTY" .. i;
		props = std_db[key];
		if props then
			deal_mems_property(props,mems_property);
			i = i + 1;
		end
		
	end
	
end


function set_section_to_frames(mems,mems_property)
	for k in pairs(mems) do
		local index = mems[k].id;
		if(mems_property[index])then
			local section_name = mems_property[index].section; 
			if (section_name) then
				mems[k].section = section_name;
			else
				trace_obj_.warning("the mems'section isn't exist.please check it.");
			end
		else
			mems[k].section = "S-50*50*8";
			--trace_obj_.warning(mems[k] .. "  mems'section isn't exist.please check it.");
		end
	end

	
end

















