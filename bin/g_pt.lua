package.path = "?;?.lua;c:\windows\?"
local lua = require "lua_base"
local tools_ = require "steel_tools"

module (...,package.seeall)

Point = {x=0,y=0,z=0}
lua.new(Point)
function set_point(pt,x,y,z)
	pt.x = x
	pt.y = y
	pt.z = z
	return pt;
end	
function Point:set(x_1,y_1,z_1)
	self.x = x_1
	self.y = y_1
	self.z = z_1
	return self
end	

Point.__add = function (pt)
	self.x = self.x + pt.x
	self.y = self.y + pt.y
	self.z = self.z + pt.z
end	
Point.__sub = function (pt)

end
--functions tool
function pt_mirror_xy(pt)
	pt.z = -pt.z 
	return pt
end	
function pt_mirror_xz(pt)
	pt.y = -pt.y 
	return pt
end	
function pt_mirror_yz(pt)
	pt.x = -pt.x 
	return pt
end 	
function pt_rotate_x(pt,beta)
	local a = beta * 3.1415926/180.0
	local rt = {}
	rt.x = pt.x
	rt.y = pt.y * math.cos(a) - pt.z * math.sin(a)
	rt.z = pt.y * math.sin(a) + pt.z * math.cos(a)
	return rt
end	
--[[
g_pt pt_rotate_x(g_pt pt,double beta)
{
	double a = beta * PI/180.0;
	g_pt rt;
	rt.x = pt.x;
	rt.y = pt.y * cos(a) - pt.z * sin(a);
	rt.z = pt.y * sin(a) + pt.z * cos(a);
return rt;

--]]








function pt_rotate_y(pt,beta)
	local a = beta * math.pi/180.0
	local rt = lua.new(Point)
	rt.x = pt.x * math.cos(a) + pt.z * math.sin(a);
	rt.y = pt.y;
	rt.z = -pt.x * math.sin(a) + pt.z * math.cos(a);
	return rt
end	
function pt_rotate_z(pt,beta)
	local a = beta * math.pi/180.0
	local rt = lua.new(Point)
	rt.x = pt.x * math.cos(a) - pt.y * math.sin(a);
	rt.y = pt.x * math.sin(a) + pt.y * math.cos(a);
	rt.z = pt.z;
	return rt
end	
function pt_len(pt)
	local len = math.sqrt( pt.x * pt.x +  pt.y * pt.y +  pt.z * pt.z);
	return len;
end 	
function len_2_pt(pt)
	local len = math.sqrt( (rhs.x - lft.x)*(rhs.x - lft.x)
				+(rhs.y - lft.y)*(rhs.y - lft.y)
				+(rhs.z - lft.z)*(rhs.z - lft.z) )
	return len;
end 	

function pt_scale(pt,scale)
	local rt = lua.new(Point)
	rt.x = pt.x * scale
	rt.y = pt.y * scale
	rt.z = pt.z * scale
	return rt;
end 	
function pt_polar_norm(pt,len,norm)
	local rt = lua.new(Point)
	rt.x = pt.x + len * norm.x;
	rt.y = pt.y + len * norm.y;
	rt.z = pt.z + len * norm.z;
	return rt;
end 	
function pts_move(pts,len,norm)
	local rt = lua.new(Point)
	for i,pt in ipairs(pts) do
		pts[i] = pt_polar_norm(pt,len,norm);
	end		
	return pts;
end 	

function pt_multi(lft,rhs)
	local pt = lua.new(Point)
	pt.x = lft.y * rhs.z - rhs.y * lft.z;
	pt.y = lft.z * rhs.x - rhs.z * lft.x;
	pt.z = lft.x * rhs.y - rhs.x * lft.y;
	return pt;
end 	

function pt_dot(lft,rhs)
	local pt = 	( lft.x * rhs.x+ lft.y * rhs.y + lft.z * rhs.z );
	return pt;
end 	

function pt_add(lft,rhs)
	local pt = lua.new(Point)
	pt.x = lft.x + rhs.x;
	pt.y = lft.y + rhs.y;
	pt.z = lft.z + rhs.z;
	return pt;
end 	
local function check_pt(pt)
	if(not pt)then
		return false;	
	end
	if pt.x and   pt.y and  pt.z  then
		return true;
	else
		return false;
	end
end
function pt_minus(lft,rhs)
	local pt = lua.new(Point);
	if(not check_pt(lft))then
		trace_out("point value error.please check it");	
		return {x=0,y=0,z=0};
	end
	if(not check_pt(rhs))then
		trace_out("point value error.please check it");	
		return {x=0,y=0,z=0};
	end
	
	if(lft.y == "Yes")then
		trace_out("lft.y = " .. (lft.y) .. ",please check it.\n");
		lft.y = 1;	
			
	end
	if(rhs.y == "Yes")then
		trace_out("rhs.y = " .. rhs.y .. ",please check it.\n");
		rhs.y = 1;	
	end
	
	pt.x = lft.x - rhs.x;
	pt.y = lft.y - rhs.y;
	pt.z = lft.z - rhs.z;
	return pt;
end 	
function pt_normalize(pt)
	local rt = pt
	len = math.sqrt(pt_dot(pt,pt));
	if len > 0.0 then
		rt = pt_scale(pt,1/len);
	end	
	return rt;
end 	


function norm_x()
	local pt = lua.new(Point)
	pt.x = 1.0;
	pt.y = 0.0;
	pt.z = 0.0;
	return pt;
end 	
function norm_x1()
	local pt = lua.new(Point)
	pt.x = -1.0;
	pt.y = 0.0;
	pt.z = 0.0;
	return pt;
end 	

function norm_y()
	local pt = lua.new(Point)
	pt.x = 0.0;
	pt.y = 1.0;
	pt.z = 0.0;
	return pt;
end 	
function norm_y1()
	local pt = lua.new(Point)
	pt.x = 0.0;
	pt.y = -1.0;
	pt.z = 0.0;
	return pt;
end 	

function norm_z()
	local pt = lua.new(Point)
	pt.x = 0.0;
	pt.y = 0.0;
	pt.z = 1.0;
	return pt;
end 	
function norm_z1()
	local pt = lua.new(Point)
	pt.x = 0.0;
	pt.y = 0.0;
	pt.z = -1.0;
	return pt;
end 	


--axis---------------

g_axis = {base={},x={},y={},z={},beta=0}
lua.new(g_axis)

function norm_2_axis(pt,xnorm)
	local axis = lua.new(g_axis)
	axis.base = pt
	axis.x = xnorm;
	local y = lua.new(Point)
	if(xnorm.z == 1.0) then
		y.x = -1.0;
	elseif(xnorm.z == -1.0) then
		y.x = 1.0;
	else
		y.x = -xnorm.y;
		y.y = xnorm.x;
	
	end
			
	y = pt_normalize(y);
	z = pt_multi(xnorm,y);
	axis.y = y;
	axis.z = z;
	axis.beta  = 0.0;	
	return axis;
end 	

function init_axis(base,x,y,z)
	local axis = lua.new(g_axis)
	axis.base = base;
	axis.x = x;
	axis.y = y;
	axis.z = z;
	axis.beta = 0.0;
	return axis;
end 	

function g2l(pt,axis)
	local rt = lua.new(Point)
	local ptTemp = pt_minus(pt,axis.base);
	
	rt.x = ptTemp.x * axis.x.x + ptTemp.y * axis.x.y + ptTemp.z * axis.x.z;
	rt.y = ptTemp.x * axis.y.x + ptTemp.y * axis.y.y + ptTemp.z * axis.y.z;
	rt.z = ptTemp.x * axis.z.x + ptTemp.y * axis.z.y + ptTemp.z * axis.z.z;
	rt = pt_rotate_x(rt,-axis.beta);
	return rt;
end 	
function l2g(pt,axis)
	local rt = {}
	--local tt = pt_rotate_x(pt,axis.beta);	
	rt.x = pt.x * axis.x.x + pt.y * axis.y.x + pt.z * axis.z.x;
	rt.y = pt.x * axis.x.y + pt.y * axis.y.y + pt.z * axis.z.y;
	rt.z = pt.x * axis.x.z + pt.y * axis.y.z + pt.z * axis.z.z;
	
	rt = pt_add(rt,axis.base);	
	return rt;
end 	

function l2g_normal(normal, relto)
	local normal = l2g(normal,relto);
	local normal = pt_minus(normal, relto.base);
	return normal;
end

function g_axis:l2g(relto)
	if not relto then return end
	if not relto.base then relto.base = lua.new(Point,{0,0,0}) end
	if not self.base then self.base = lua.new(Point,{0,0,0}) end
	if not relto.x or not relto.y or not relto.z then return end		
	if not self.x or not self.y or not self.z then return end		
	self.base = l2g(self.base, relto);
	self.x = l2g_normal(self.x, relto);
	self.y = l2g_normal(self.y, relto);
	self.z = l2g_normal(self.z, relto);
end

g_clip = {pt={},m={},up=0,under=0}
lua.new(g_clip)
function init_g_clip()
	local clip = lua.new(g_clip)
	
	for i=1,4 do
		clip.m[i] = {}
		for j=1,4 do
			clip[i][j] = 0.0
		end	
	end

	clip.m[0][0] = 1.0;
	clip.m[3][3] = 1.0;
	clip.m[1][1] = 1.0;
	clip.m[2][2] = 1.0;
	clip.up = 1000.0;
	clip.under = 1000.0;
	clip.pt = lua.new(Point);
		
	return clip;
end 	

gldouble = {}
lua.new(gldouble)
function pt_perpendicular_plane(pt,eqution)
	local d = pt_len_plane(pt,eqution);
	if(d == 0.0) then return pt end

	local norm = lua.new(Point)
	
	norm.x = -eqution[0];
	norm.y = -eqution[1];
	norm.z = -eqution[2];

	return pt_polar_norm(pt,d,norm);
end 	
function pt_len_plane(pt,eqution)
	local d = eqution[0] * pt.x + eqution[1] * pt.y + eqution[2] * pt.z + eqution[3];
	return d;
end 	

function intersect_l_p(pt1,pt2,eqution,pt3)
	local pt = lua.new(Point)
	
	local d1 = pt_len_plane(pt1,eqution);
	local d2 = pt_len_plane(pt2,eqution); 
	if( d1 == d2) then return pt end;

	local len = len_2_pt( pt1, pt2);
	local l = d2 * len / ( d2 - d1);
	local t = pt_minus(pt1,pt2);
	t = pt_normalize(t);
	local pt = pt_polar_norm(pt2,l,t);
	return pt


end 	

function get_equation(clip,eqution)
	eqution[0] = clip.m[0][2];
	eqution[1] = clip.m[1][2];
	eqution[2] = clip.m[2][2];

	eqution[3] = -(eqution[0] * clip.pt.x + 
			eqution[1] * clip.pt.y +
			eqution[2] * clip.pt.z);
	return eqution
end 	
function clip_from_norm(clip,pt1,pt2)
	local normz = lua.new(Point)
	
	normz = pt_minus(pt1,pt2);
	normz = pt_normalize(normz);
	if(normz.y == 1.0 )  then
		normx.x = -1.0;
	elseif(normz.y == -1.0) then
		normx.x = 1.0;
	elseif(normz.x == 1.0) then
		normx.y = 1.0;
	elseif(normz.x == -1.0) then
		normx.y = -1.0;
	else 
		normx.x = normz.z;
		normx.z = -normz.x;	
	end
	
	normy = lua.new(Point)
	normy = pt_multi(normz,normx);
	clip.pt = pt2;

	clip.m[0][0] = normx.x;
	clip.m[1][0] = normx.y;
	clip.m[2][0] = normx.z;

	clip.m[0][1] = normy.x;
	clip.m[1][1] = normy.y;
	clip.m[2][1] = normy.z;

	clip.m[0][2] = normz.x;
	clip.m[1][2] = normz.y;
	clip.m[2][2] = normz.z;	
	
	return clip
end 	

function normal_from_pt3(pt1,pt2,pt3)
	local x = pt_minus(pt2,pt1);
	local y = pt_minus(pt3,pt2);
	local z = pt_multi(x,y);
	z = pt_normalize(z);
	return z;
end 	
--gldouble e
function eqution_from_pt3(e,pt1,pt2,pt3)
	local z = normal_from_pt3(pt1,pt2,pt3);
	e[0] = z.x;
	e[1] = z.y; 
	e[2] = z.z;
	if(z.x == 0.0 and z.y == 0.0 and z.z == 0.0) then return 0 end;
	e[3] = pt_dot(pt1,z);
	return 1 , e;
end 	

function pt_mid(pt1,pt2)
	local rs = pt_add(pt1,pt2);
	rs = pt_scale(rs,0.5);
	return rs;
end 	

--float equ !
--pt1, pt2
function set_gaxis_by_x(t)
	local axis = lua.new(g_axis);
	axis.base = t.pt1;
	axis.x = pt_minus(t.pt2, t.pt1);
	axis.x = pt_normalize(axis.x);
	if(axis.x.x==0 and axis.x.y==0) then
		axis.z = lua.new(Point,{x=0,y=1,z=0});
	else
		axis.z = lua.new(Point,{x=0,y=0,z=1});
	end
	axis.y = pt_multi(axis.z,axis.x);
	axis.y = pt_normalize(axis.y);
	axis.z = pt_multi(axis.x,axis.y);
	axis.z = pt_normalize(axis.z);
	--tools_.ocmd(axis,"axis111111111111");
	
	return axis;
end
