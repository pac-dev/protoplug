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
		type 	= params.Type.getValue();
		f 		= params.Frequency.getValue()/2;
		gain 	= params.Gain.getValue();
		Q 		= params.Resonance.getValue();
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
	Type = {
		type = "list";
		values = {"hp"; "lp"; "bp"; "bs"; "ls"; "hs"; "ap"; "eq"};
		default = "hp";
		changed = function(val) updateFilters{type=val} end;
	};
	Frequency = {
		min = 10;
		max = 20000;
		default = 440;
		changed = function(val) updateFilters{f=val} end;
	};
	Gain = {
		min = -30;
		max = 30;
		default = 0;
		changed = function(val) updateFilters{gain=val} end;
	};
	Resonance = {
		min = 0.1;
		max = 30;
		default = 1;
		changed = function(val) updateFilters{Q=val} end;
	};
}

-- Reset the plugin parameters like this :
-- params.resetToDefaults()
