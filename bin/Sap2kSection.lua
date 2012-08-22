local steel_tools_ = require "steel_tools";
local trace_obj_ = require "trace_obj";

module (...,package.seeall)

--H型钢
local function deal_h(params,frame_sections_db)
	local h_sect = {};
	h_sect.name = params[1];
	h_sect.material = params[2];
	h_sect.shape = params[3];
	h_sect.t3 = params[4];
	h_sect.t2 = params[5];
	h_sect.tf = params[6];
	h_sect.tw = params[7];
	h_sect.t2b = params[8];
	h_sect.tfb = params[9];
	h_sect.area = params[10];
	h_sect.tors_const = params[11];
	
	local len = tonumber(h_sect.t3);
	local width = tonumber(h_sect.t2);
	local tf = tonumber(h_sect.tf);
	local tw = tonumber(h_sect.tw);
	h_sect.section = "H-" ..len .."*" .. width .."*".. tf .."*" .. tw;
	
	frame_sections_db[h_sect.name] = h_sect;	
end

--S或TUB型钢
local function deal_s(params,frame_sections_db)
	local sect = {};
	sect.name = params[1];
	sect.material = params[2];
	sect.shape = params[3];
	sect.t3 = params[4];
	sect.t2 = params[5];
	sect.tf = params[6];
	sect.tw = params[7];
	sect.area = params[8];
	sect.tors_const = params[9];
	
	local len = tonumber(sect.t3);
	local width = tonumber(sect.t2);
	local tf = tonumber(sect.tf);
	local tw = tonumber(sect.tw);
	sect.section = "S-" ..len .."*" .. width .."*".. tf;
	
	frame_sections_db[sect.name] = sect;	
end
--C型钢
local function deal_c(params,frame_sections_db)
	print("C");
end

deal_sects_g = {
	["I/Wide Flange"] = deal_h,
	["Channel"] = deal_c,
	["Box/Tube"] = deal_s,
};

local function get_frames_sects(datas,fra_sects)
	for k in pairs(datas) do
		if(string.find(k,"FRAME SECTION PROPERTIES"))then
			fra_sects[k] = datas[k];
		end
	end
end

local function deal_section(params,frame_sections_db)
	local shape_kind = params[3];
	local kind = string.match(shape_kind,"%s*(.+)%s*");	
	if(string.find(shape_kind,"Wide Flange"))then
		kind = "I/Wide Flange";	
	elseif(string.find(shape_kind,"Tube"))then
		kind = "Box/Tube";	
	end
	local fun = deal_sects_g[kind];	
	if(fun)then
		fun(params,frame_sections_db);
	else
		trace_obj_.warning("the section type = " .. kind .. " can't read.")
	end
end


local function deal_section_one(sect,frame_sections_db)
	local shape = sect.speci[3];	
	if(shape == "Shape")then
		deal_section(sect.param,frame_sections_db);
	end
end
local function deal_sections(fra_sect,frame_sections_db)
	for k in pairs(fra_sect) do
		deal_section_one(fra_sect[k],frame_sections_db);
	end
end

function get_frame_section_db(datas,frame_sections_db)
	local fra_sects = {};
	get_frames_sects(datas,fra_sects);	
	for k in pairs(fra_sects) do
		deal_sections(fra_sects[k],frame_sections_db)	;
	end	
end

function get_frame_sect_assign_db(datas,frame_sect_assign_db)
	local assign_sects = datas["FRAME SECTION ASSIGNMENTS"];
	if not assign_sects then
		return;
	end
	for k in pairs(assign_sects) do
		local assign = {};
		assign.index = assign_sects[k].param[1];
		assign.section_type = assign_sects[k].param[2];
		assign.auto_select = assign_sects[k].param[3];
		assign.anal_sect = assign_sects[k].param[4];
		assign.design_sect = assign_sects[k].param[5];
		assign.mat_prop = assign_sects[k].param[6];
		frame_sect_assign_db[assign.index] = assign;
	end
	
	
	
end
	
function set_section_to_frames(frames,frame_sect_assign_db,frame_sections_db)
	for k in pairs(frames) do
		local index = frames[k].index;
		if(frame_sect_assign_db[index])then		
			local section_name = frame_sect_assign_db[index].anal_sect; --或者是design_sect需要什么情况用那个？
			local sect = frame_sections_db[section_name];
			if (sect) then
				frames[k].section = sect.section;
				frames[k].material = sect.material;
			else
				trace_obj_.warning("the frames'section isn't exist.please check it.");
			end
		else
			frames[k].section = "S-50*50*8";
			frames[k].material = "SS400";
			trace_obj_.warning("the frames'section isn't assign.please assign it.");
		end	
	end
	
end




