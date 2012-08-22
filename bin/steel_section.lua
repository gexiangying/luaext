local tools_ = require "steel_tools"
local geo_ = require "steel_geometry"

module(...,package.seeall)

H = {};
function H:profile_size(szs)
	local sect = {
		type = H;
		a = szs[1];
		b = szs[2];
		tw = szs[3];
		tf = szs[4];
	};
	return sect;
end
function H:profile_points(sect)
	local outer = {};
	table.insert(outer,geo_.Point:new{-(sect.b)/2, 0});
	table.insert(outer,geo_.Point:new{-(sect.b)/2, -(sect.tf)});
	table.insert(outer,geo_.Point:new{-(sect.tw)/2, -(sect.tf)});
	table.insert(outer,geo_.Point:new{-(sect.tw)/2, (sect.tf)-(sect.a)});
	table.insert(outer,geo_.Point:new{-(sect.b)/2, (sect.tf)-(sect.a)});
	table.insert(outer,geo_.Point:new{-(sect.b)/2, -(sect.a)});
	table.insert(outer,geo_.Point:new{(sect.b)/2, -(sect.a)});
	table.insert(outer,geo_.Point:new{(sect.b)/2, (sect.tf)-(sect.a)});
	table.insert(outer,geo_.Point:new{(sect.tw)/2, (sect.tf)-(sect.a)});
	table.insert(outer,geo_.Point:new{(sect.tw)/2, -(sect.tf)});
	table.insert(outer,geo_.Point:new{(sect.b)/2, -(sect.tf)});
	table.insert(outer,geo_.Point:new{(sect.b)/2, 0});
	return outer;
end
-- HN = {};
-- function HN:profile_size(szs)
	-- return H:profile_size(szs);
-- end
-- function HN:profile_points(sect)
	-- H:profile_points(sect)
-- end


L = {};
function L:profile_size(szs)
	local sect = {
		type = L;
		a = szs[1];
		b = szs[2];
		t = szs[3];
	};
	return sect;
end
function L:profile_points(sect)
	local outer = {};
	table.insert(outer,geo_.Point:new{0, 0});
	table.insert(outer,geo_.Point:new{sect.b, 0});
	table.insert(outer,geo_.Point:new{sect.b, sect.t});
	table.insert(outer,geo_.Point:new{sect.t, sect.t});
	table.insert(outer,geo_.Point:new{sect.t, sect.a});
	table.insert(outer,geo_.Point:new{0, sect.a});
	return outer;
end

U = {};
function U:profile_size(szs)
	local sect = {
		type = U;
		a = szs[1];
		b = szs[2];
		t = szs[3];
	};
	return sect;
end
function U:profile_points(sect)
	local outer = {};
	table.insert(outer,geo_.Point:new{0, 0});
	table.insert(outer,geo_.Point:new{0, -sect.a});
	table.insert(outer,geo_.Point:new{sect.b, -sect.a});
	table.insert(outer,geo_.Point:new{sect.b, -sect.a+sect.t});
	table.insert(outer,geo_.Point:new{sect.t, -sect.a+sect.t});
	table.insert(outer,geo_.Point:new{sect.t, -sect.t});
	table.insert(outer,geo_.Point:new{sect.b, -sect.t});
	table.insert(outer,geo_.Point:new{sect.b, 0});
	return outer;
end

C = {};
function C:profile_size(szs)
	local sect = {
		type = C;
		a = szs[1];
		b = szs[2];
		tw = szs[3];
		t = szs[4];
	};
	return sect;
end
function C:profile_points(sect)
	local outer = {};
	table.insert(outer,geo_.Point:new{0, 0});
	table.insert(outer,geo_.Point:new{0, -sect.a});
	table.insert(outer,geo_.Point:new{sect.b, -sect.a});
	table.insert(outer,geo_.Point:new{sect.b, -sect.a+sect.tw});
	table.insert(outer,geo_.Point:new{sect.b-sect.t, -sect.a+sect.tw});
	table.insert(outer,geo_.Point:new{sect.b-sect.t, -sect.a+sect.t});
	table.insert(outer,geo_.Point:new{sect.t, -sect.a+sect.t});
	table.insert(outer,geo_.Point:new{sect.t, -sect.t});
	table.insert(outer,geo_.Point:new{sect.b-sect.t, -sect.t});
	table.insert(outer,geo_.Point:new{sect.b-sect.t, -sect.tw});
	table.insert(outer,geo_.Point:new{sect.b, -sect.tw});
	table.insert(outer,geo_.Point:new{sect.b, 0});
	return outer;
end

T = {};
function T:profile_size(szs)
	local sect = {
		type = T;
		a = szs[1];
		b = szs[2];
		tw = szs[3];
		tf = szs[4];
	};
	return sect;
end
function T:profile_points(sect)
	local outer = {};
	table.insert(outer,geo_.Point:new{-sect.b/2, 0});
	table.insert(outer,geo_.Point:new{-sect.b/2, -sect.tf});
	table.insert(outer,geo_.Point:new{-sect.tw/2, -sect.tf});
	table.insert(outer,geo_.Point:new{-sect.tw/2, -sect.a});
	table.insert(outer,geo_.Point:new{ sect.tw/2, -sect.a});
	table.insert(outer,geo_.Point:new{ sect.tw/2, -sect.tf});
	table.insert(outer,geo_.Point:new{ sect.b/2, -sect.tf});
	table.insert(outer,geo_.Point:new{ sect.b/2, 0});
	return outer;
end

S = {};
function S:profile_size(szs)
	local sect = {
		type = S;
		a = szs[1];
		b = szs[2];
		t = szs[3];
	};
	return sect;
end
function S:profile_points(sect)
	local outer = {};
	table.insert(outer,geo_.Point:new{-sect.b/2,  sect.a/2});
	table.insert(outer,geo_.Point:new{-sect.b/2, -sect.a/2});
	table.insert(outer,geo_.Point:new{ sect.b/2, -sect.a/2});
	table.insert(outer,geo_.Point:new{ sect.b/2,  sect.a/2});
	local inners = {{}};
	table.insert(inners[1],geo_.Point:new{-sect.b/2+sect.t,  sect.a/2-sect.t});
	table.insert(inners[1],geo_.Point:new{-sect.b/2+sect.t, -sect.a/2+sect.t});
	table.insert(inners[1],geo_.Point:new{ sect.b/2-sect.t, -sect.a/2+sect.t});
	table.insert(inners[1],geo_.Point:new{ sect.b/2-sect.t,  sect.a/2-sect.t});
	return outer,inners;
end
TUB = {};
function TUB:profile_size(szs)
	return S:profile_size(szs);
end
function TUB:profile_points(sect)
	return S:profile_points(sect)
end


local function circle_pts_by_r(r,segment)
	segment = type(segment)=="number" and segment>0 and segment or 100;
	local pts = {circle=true;};
	for i=0,segment do
		local angle,x,y=0,0,0;
		angle = 2*geo_.PI*i/segment;
		x = r * math.cos(angle);
		y = r * math.sin(angle);
		table.insert(pts,geo_.Point:new{x,y});
	end
	return pts;
end

P = {};
function P:profile_size(szs)
	local sect = {
		type = P;
		a = szs[1];
		t = szs[2];
	};
	return sect;
end
function P:profile_points(sect)
	local outer = circle_pts_by_r(sect.a/2,sect.segment);
	local inners = {circle_pts_by_r(sect.a/2-sect.t,sect.segment);};
	return outer,inners;
end

M = {};
function M:profile_size(szs)
	local sect = {
		type = M;
		a = szs[1];
	};
	return sect;
end
function M:profile_points(sect)
	local outer = circle_pts_by_r(sect.a,sect.segment);
	return outer;
end

----------------


--------main--------
--sect={type=H;a=;b=;tw=;tf=;};
function profile_points(sect)
--	if getmetatable(t.type)~=Type then error("section's type is wrong") end;
	return sect.type:profile_points(sect);
end

function profile_size(str)
	local type = string.match(str,"%a+");
	local szs = {};
	for sz in string.gfind(str, "[%d.]+") do
		table.insert(szs,sz);
	end
	if not steel_section[type] then 
		trace_out("undefine section type("..type..")\n");
		return M:profile_size{10};
	end;
	return steel_section[type]:profile_size(szs);
end

function profile(str)
	return profile_points(profile_size(str));
end
