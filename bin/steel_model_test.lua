module (...,package.seeall)

local stl_model_ = require "steel_model";
local section_ = require "steel_section";
local solid_ = require "steel_solid";
local tools_ = require "steel_tools";
local mgr_ = require "steel_mgr";

function add_nodes()
	stl_model_.add_node("node1", {x=0,y=0,z=0});
	stl_model_.add_node("node2", {x=1000,y=0,z=0});
	stl_model_.add_node("node3", {x=1000,y=0,z=500});
	stl_model_.add_node("node4", {x=0,y=0,z=500});
end

function add_mems()
	stl_model_.add_member{
		section = "H200*150*20*15";
		color = {r=1,g=0,b=0};
		start_node = "node1";
		end_node = "node2";
		beta = 0;
	};
end

function add_pls()
	stl_model_.add_plate{
		color = {r=1,g=0.5,b=0};
		nodes = {"node1";"node2";"node3";"node4"};
		thick = 10;
	};
end

function add_extend_line()
	local ent = {};
	ent.object = solid_.extrude{
		mode = solid_.Line;
		solid = {
			color = {r=1,g=0,b=0};
			length = 10000;
			direction = {0,0,1};
		};
		placement = {
			base = {0,5000,0};
		};
	};
	stl_model_.add_other(ent);
end

function add_extend_frame()
	local ent = {};
	ent.object = solid_.extrude{
		mode = solid_.Frame;
		solid = {
			color = {r=0,g=1,b=0};
			length = 5000;
			direction = {0,0,1};
			bottom = {
				outer = {{0,0,0};{500,0,0};{0,500,0};};
				inners = {{{100,100,0};{300,100,0};{100,300,0};};};
			};
			top = {
				outer = {{0,0,0};{1800,0,0};{0,1800,0};};
				inners = {{{100,100,0};{1500,100,0};{100,1500,0};};};
			};
		};
		placement = {
			base = {0,4000,0};
		};
	};
--	tools_.otrace(ent.object, "object");
	stl_model_.add_other(ent);
end

function add_extend_render()
	local ent = {};
	ent.object = solid_.extrude{
		mode = solid_.Render;
		solid = {
			color = {r=1,g=1,b=0};
			length = 500;
			direction = {0,0,1};
			bottom = {
				outer = {{0,0,0};{50,0,0};{50,50,0};{0,50,0};};
				inners = {{{20,20,0};{40,20,0};{40,40,0};{20,40,0};};};
			};
			top = {
				outer = {{0,0,0};{180,0,0};{180,180,0};{0,180,0};};
				inners = {{{10,10,0};{150,10,0};{150,150,0};{10,150,0};};};
			};
		};
		placement = {
			base = {0,3000,0};
		};
	};
--	tools_.otrace(ent.object, "object");
	stl_model_.add_other(ent);
end

function add_section_profile_size()
	local ent = {};
	local bouter,binners = section_.profile_points{type=section_.P,a=500,t=5.5;}
	local touter,tinners = section_.profile_points{type=section_.P,a=200,t=5.5;}
	ent.object = solid_.extrude{
		mode = solid_.Render;
		solid = {
			color = {r=1,g=0,b=1};
			length = 2000;
			direction = {0,0,1};
			bottom = {
				outer = bouter;
				inners = binners;
			};
			top = {
				outer = touter;
				inners = tinners;
			};
		};
		placement = {
			base = {0,2000,0};
		};
	};
--	tools_.otrace(ent.object, "object");
	stl_model_.add_other(ent);
end

function add_section_profile_text()
	local ent = {};
	local bouter,binners = section_.profile("H-800*100*20*5.5");
	local touter,tinners = section_.profile "H-300*100*20*5.5";
	ent.object = solid_.extrude{
		mode = solid_.Render;
		solid = {
			color = {r=1,g=0,b=0};
			length = 2000;
--			direction = {0,0,1};
			bottom = {
				outer = bouter;
				inners = binners;
			};
			top = {
				outer = touter;
				inners = tinners;
			};
		};
		placement = {
			base = {0,1000,0};
		};
	};
--	tools_.otrace(ent.object, "object");
	stl_model_.add_other(ent);
end

function add_revolve_line()
	local ent = {};
	ent.object = solid_.extrude{
		mode = solid_.Line;
		solid = {
			color = {r=0,g=1,b=0};
			length = 20000;
			direction = {0,0,1};
		};
	};
--	tools_.otrace(ent.object, "object");
	stl_model_.add_other(ent);
end

function add_member()
	local ent = {};
	ent.object = solid_.member{
		mode = solid_.Render;
		section="C-500*300*100*15";
		color={r=1,g=0.5,b=0.5};
		pt1={2000,2000};
		pt2={5000,2000}
	};
	stl_model_.add_other(ent);
end

function add()
	trace_out("test_.add()\n");
--	add_nodes();
--	add_mems();
--	add_pls();
	add_extend_line();
	add_extend_frame();
	add_extend_render();
	add_section_profile_size();
	add_section_profile_text();
	add_revolve_line();
	add_member();
end
