--[[
name: Classic Filter
description: >
  Straightforward application of RBJ's cookbook filters. Formulae by 
  Robert Bristow-Johnson, implementation from Worp by Ico Doornekamp. 
author: osar.fr
--]]

require "include/protoplug"
local cbFilter = require "include/pac/cookbook filters"
local filters = {}

stereoFx.init()

function stereoFx.Channel:init()
	-- create per-channel fields (filters)
	self.filter = cbFilter
	{
		-- initialize filters with current param values
		type 	= params[1].getValue();
		f 		= params[2].getValue()/2;
		gain 	= params[3].getValue();
		Q 		= params[4].getValue();
	}
	table.insert(filters, self.filter)
end

function stereoFx.Channel:processBlock(s, smax)
	for i = 0,smax do
		s[i] = self.filter.process(s[i])
	end
end

local function updateFilters(args)
	for _, f in pairs(filters) do
		f.update(args)
	end
end

params = plugin.manageParams {
	-- automatable VST/AU parameters
	-- note the new 1.3 way of declaring them
	{
		name = "Type";
		type = "list";
		values = {"hp"; "lp"; "bp"; "bs"; "ls"; "hs"; "ap"; "eq"};
		default = "hp";
		changed = function(val) updateFilters{type=val} end;
	};
	{
		name = "Frequency";
		min = 10;
		max = 20000;
		default = 440;
		changed = function(val) updateFilters{f=val} end;
	};
	{
		name = "Gain";
		min = -30;
		max = 30;
		default = 0;
		changed = function(val) updateFilters{gain=val} end;
	};
	{
		name = "Resonance";
		min = 0.1;
		max = 30;
		default = 1;
		changed = function(val) updateFilters{Q=val} end;
	};
}

-- Reset the plugin parameters like this :
-- params.resetToDefaults()
