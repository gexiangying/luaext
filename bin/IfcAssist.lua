require "ifc"

local gpt_ = require "g_pt";

setfenv(1,ifc)
function create_local_placement()
	local placement =  get_ent_by_name("IFCLOCALPLACEMENT"); 
	if (placement)then
		return placement;
	else	
		local local_placement = ifcnew(ifc.IFCLOCALPLACEMENT);
		local gaxis = new(gpt_.g_axis,{
			base = new(gpt_.g_pt,{x=0,y=0,z=0});
			x = new(gpt_.g_pt,{x=1,y=0,z=0});
			y = new(gpt_.g_pt,{x=0,y=1,z=0});
			z = new(gpt_.g_pt,{x=0,y=0,z=1});
		});

		local_placement:set_gaxis(gaxis);
		return local_placement
	end
	
	
end

function create_project()
	local project = ifcnew(ifc.IFCPROJECT);
	local info = {root_name = "'Project Number'"}
	project:set(info);	
	return project
end
local function create_pro()
	local pro = get_ent_by_name("IFCPROJECT");
	if(pro)then
		return pro;
	else
		return create_project();
	end
end
function create_site()
	local site = get_ent_by_name("IFCSITE"); 
	if(site)then
		return site;
	else	
		local site = ifcnew(ifc.IFCSITE);
		local info = {root_name = "'\X\C4\X\AC\X\C8\X\CF'"}
		site:set(info)
		return site;
	end
end
function create_sites(sites)
	local site = ifcnew(ifc.IFCSITE);
	local info = {root_name = "'\X\C4\X\AC\X\C8\X\CF'"}
	site:set(info)
	table.insert(sites,site);
end


local function create_agg_project()
	local agg = ifcnew(ifc.IFCRELAGGREGATES);
	local obj_ing = create_pro()
	local objs_ed = {};
	create_sites(objs_ed);
	agg:set(obj_ing,objs_ed);
end
local function create_building()
	local building = get_ent_by_name("IFCBUILDING"); 
	if(building)then
		return building;
	else	
		local building = ifcnew(ifc.IFCBUILDING);
		local info = {root_name = "$"}
		building:set(info);
		return building;
	end

end
local function create_building_history()
	local building_history = get_ent_by_name("IFCBUILDINGSTOREY"); 
	if(building_history)then
		return building_history;
	else	
		local building_history = ifcnew(ifc.IFCBUILDINGSTOREY);
		local info = {root_name = "'\\X\\B1\\X\\EA\\X\\B8\\X\\DF 1'"}
		building_history:set(info);
		return building_history;
	end

end

local function create_agg_site()
	local agg = ifcnew(ifc.IFCRELAGGREGATES);
	local obj_ing = create_site()
	local objs_ed = {create_building()};
	agg:set(obj_ing,objs_ed);
end
local function create_agg_building()
	local agg = ifcnew(ifc.IFCRELAGGREGATES);
	local obj_ing = create_building();
	local objs_ed = {create_building_history()};
	agg:set(obj_ing,objs_ed);
	
end

function create_rel_aggregates()
	create_agg_project();
	create_agg_site();
	create_agg_building();
end

function create_postal_address()
	local address = get_ent_by_name("IFCPOSTALADDRESS"); 
	if(address)then
		return address;
	else	
		local address = ifcnew(ifc.IFCPOSTALADDRESS);
		address:set()
		return address;
	end
	
end
function create_geometric_represent_context(context)
	local geo = ifcnew(ifc.IFCGEOMETRICREPRESENTATIONCONTEXT);
	geo:set(context,get_db())
	return geo;

end
--create_geo_rep_context("'Model'")
--查找有没有相等的Ifc geometri crepresentati oncontext
function create_geo_rep_context(para_2)
	local geo = get_ent_by_para("IFCGEOMETRICREPRESENTATIONCONTEXT",para_2,2); 
	if(geo)then
		return geo;
	else	
		return create_geometric_represent_context("'Model'");
	end
end

function create_axis2_placement2d(pt,dircet)
	local axis2 = ifcnew(IFCAXIS2PLACEMENT2D);
	axis2:set(pt,dircet)
	return axis2;
	
end

function create_cartesian_point(pt)
	local p = ifcnew(IFCCARTESIANPOINT);
	p:set(pt)
	return p;	
end
function create_dircet(direct)
	local dir = ifcnew(IFCDIRECTION);
	dir:set_pt(direct)
	return dir;
	
end











