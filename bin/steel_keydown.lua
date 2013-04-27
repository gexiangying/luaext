module (...,package.seeall)

local mgr_ = require "steel_mgr"
local my = steel_keydown;

local esc_ = 27;
local del_ = 46;
local a_ = 65;

local function select_all()
	if not is_ctr_down() then return nil end;
	mgr_.select_all();
	return true;
end

my[esc_] = mgr_.select_none;
my[del_] = mgr_.del;
my[a_] = select_all;

