module (...,package.seeall)


staad_section_db = { 
--[[
	["chinese"] = {
		["HW244X252"] = {
			["sec_no"] = "1",
			["name"] = "HW244X252",
			["staad_name"] = "HW244X252",
			["ax"] = "12",
		},
		["HW244X250"] = {
			["sec_no"] = "2",
			["name"] = "HW244X252",
			["staad_name"] = "HW244X252",
			["ax"] = "12",
		},
	},

--]]
};

local function stand_section_prefix(sect_name)
	local name  = sect_name;
	if (string.find(sect_name,"HW"))then
		name = string.gsub(sect_name,"HW","H");
	elseif (string.find(sect_name,"TUB"))then
		name = "S";
	end
	return name;
end

local function deal_quotation_marks(name)
	local n = string.gsub(name,"\"","");
	return n;
	
end
local function load_chinese_h_shape(file,chinese_db)
	local f = io.open(file,"r");
	local line = f:read("*line");
	while line do
		local p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14 = string.match(line,"([^ ]*)%s*([^ ]*)%s*([^ ]*)%s*([^ ]*)%s*([^ ]*)%s*([^ ]*)%s*([^ ]*)%s*([^ ]*)%s*([^ ]*)%s*([^ ]*)%s*([^ ]*)%s*([^ ]*)%s*([^ ]*)%s*([^ ]*)");
		local sect = {};
		sect.sec_no = p1;
		sect.name = deal_quotation_marks(p2);
		sect.staad_name = deal_quotation_marks(p3);
		sect.ax = p4;
		sect.d = p5;
		sect.bf = p6;
		sect.tf = p7;
		sect.tw = p8;
		sect.iz = p9;
		sect.ix = p10;
		sect.ct = p11;
		sect.iy = p12;
		sect.zx = p13;
		sect.zy = p14;		
		local prefix_name = stand_section_prefix(sect.name);
		sect.section = prefix_name .. "X" .. sect.tf  .. "X" .. sect.tw;		
		chinese_db[sect.name] = sect;
		line = f:read("*line");
	end
end
local function load_chinese_tube_shape(file,chinese_db)
	local f = io.open(file,"r");
	local line = f:read("*line");
	while line do
		local p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12 = string.match(line,"([^ ]*)%s*([^ ]*)%s*([^ ]*)%s*([^ ]*)%s*([^ ]*)%s*([^ ]*)%s*([^ ]*)%s*([^ ]*)%s*([^ ]*)%s*([^ ]*)%s*([^ ]*)%s*([^ ]*)");
		local sect = {};
		sect.sec_no = p1;
		sect.name = deal_quotation_marks(p2);
		sect.staad_name = deal_quotation_marks(p3);
		sect.ax = p4;
		sect.d = p5;
		sect.b = p6;
		sect.t = p7;
		sect.iz = p8;
		sect.iy = p9;
		sect.ix = p10;
		sect.zx = p11;
		sect.zy = p12;
		local prefix_name = stand_section_prefix(sect.name);
		sect.section = prefix_name .. "-" .. sect.d  .. "X" ..sect.b .. "X" ..sect.t;		
		chinese_db[sect.name] = sect;
		line = f:read("*line");
	end	
end
local function load_chinese_angle_shape(file,chinese_db)
	local f = io.open(file,"r");
	local line = f:read("*line");
	while line do
		local p1,p2,p3,p4,p5,p6,p7,p8 = string.match(line,"([^ ]*)%s*([^ ]*)%s*([^ ]*)%s*([^ ]*)%s*([^ ]*)%s*([^ ]*)%s*([^ ]*)%s*([^ ]*)");
		local sect = {};
		sect.sec_no = p1;
		sect.name = deal_quotation_marks(p2);
		sect.staad_name = deal_quotation_marks(p3);
		sect.d = p4;
		sect.b = p5;
		sect.t = p6;
		sect.ax = p7;
		sect.rz = p8;
		sect.section = sect.name;		
		chinese_db[sect.name] = sect;
		line = f:read("*line");
	end		
end


function create_staad_section_db()
	staad_section_db["chinese"] = staad_section_db["chinese"] or {};
	load_chinese_h_shape("Chinese_HShape.txt",staad_section_db["chinese"]);
	load_chinese_tube_shape("Chinese_Tube.txt",staad_section_db["chinese"]);
	load_chinese_angle_shape("Chinese_Angle.txt",staad_section_db["chinese"]);
	
end
function get_section(country,section_name)	
	local coun = staad_section_db[country];
	if(coun)then
		local sect = coun[section_name];
		if (sect)then
			return sect.section;	
		else		
			return "S-50*50*8";
		end
	else
		return "S-50*50*8";
	end
end















