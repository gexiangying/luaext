package.cpath="?.dll"

local tools_ = require "steel_tools";
local geo_ = require "steel_geometry";

local error_count_ = 0;
local function out_cmp(tip, relust)
	if relust then tip=tip.."¡Ì"	else tip=tip.."¡Á" error_count_=error_count_+1 end;
	print(tip);
end
local function out_error()
	print("\t",error_count_,"error(s)");
end

function case1()
	local axis = geo_.Axis:new();
	axis:set_base(geo_.Point:new{100,200,300});
	axis:set_x_normal(geo_.Point:new{0,1,0});
	local src = geo_.Point:new{10,20,30};
	local std = geo_.Point:new{-180,90,-270};
	local dst = axis:g2l(src);
	out_cmp("case 1 ", dst==std);
end

function case2()
	local axis = geo_.Axis:new();
	axis:set_base(geo_.Point:new{100,200,300});
	axis:set_x_normal(geo_.Point:new{0,1,0});
	local src = geo_.Point:new{10,20,30};
	local std = geo_.Point:new{80,210,330};
	local dst = axis:l2g(src);
	out_cmp("case 2 ", dst==std);
end

function case3()
	local axis = geo_.Axis:new();
	axis:set_base(geo_.Point:new{100,200,300});
	axis:set_x_normal(geo_.Point:new{0,1,0});
	local src = geo_.Point:new{10,20,30};
	local std = geo_.Point:new{20,-10,30};
	local dst = axis:g2l_normal(src);
	out_cmp("case 3 ", dst==std);
end

function case4()
	local axis = geo_.Axis:new();
	axis:set_base(geo_.Point:new{100,200,300});
	axis:set_x_normal(geo_.Point:new{0,1,0});
	local src = geo_.Point:new{10,20,30};
	local std = geo_.Point:new{-20,10,30};
	local dst = axis:l2g_normal(src);
	out_cmp("case 4 ", dst==std);
end

function case5()
	local nor = geo_.Point:new{1,1,0};
	local len = 1;
	local src = geo_.Point:new{0,0,0}
	local std = geo_.Point:new{0.70710678,0.70710678,0};
	local dst = src:polarto(nor,len);
	out_cmp("case 5 ", dst==std);
end

function case6()
	local axis = geo_.Axis:new();
	axis:set_x_line{{100,200,300},{100,201,300}};
	local src = geo_.Point:new{10,20,30};
	local std = geo_.Point:new{-20,10,30};
	local dst = axis:l2g_normal(src);
	out_cmp("case 6 ", dst==std);
end

case1();	--g2l
case2();	--l2g
case3();	--g2l_normal
case4();	--l2g_normal
case5();	--polarto
case6();	--axis:set_x_line
out_error();