--- Use this module to create a stereo effect.
-- Example at @{classic-filter.lua}.
--
-- This module acts as a layer that conceals the @{plugin.processBlock} function, 
-- manages stereo channels, and exposes the `stereoFx.Channel` prototype for you 
-- define per-channel audio processing. Initialize it by calling `stereoFx.init`.
--
-- The `stereoFx` global is available to every protoplug script after including the 
-- main protoplug header :
-- 	require "include/protoplug"
-- @module stereoFx



--- Set up channels.
-- This function must be called by any script that wishes to use this module. 
-- @function stereoFx.init

--- Channel.
-- This class represents a channel (ie. left or right).
-- <br><br>
-- @type stereoFx.Channel


--- Override to process a channel's audio block.
-- Define the audio processing of a single channel in this function.
-- @param samples a C float* serving as input and output
-- @param smax the maximum sample index (nSamples - 1)
-- @function Channel:processBlock

--- Override to handle initialisation.
-- Override this method to perform initialisation tasks on each channel,
-- for example to create any per-channel fields.
-- @function Channel:init

local stereoFx = {}

local script = require "include/core/script"

local Channel = { }
function Channel:new (o)
	setmetatable(o, self)
	self.__index = self
	return o
end

local LChannel = Channel:new{  }
local RChannel = Channel:new{  }

function stereoFx.init()
	function plugin.processBlock (samples, smax)
		if Channel.processBlock==nil then return 0 end
		LChannel:processBlock(samples[0], smax)
		RChannel:processBlock(samples[1], smax)
	end

	script.addHandler("init", function ()
		if Channel.init~=nil then
			LChannel:init()
			RChannel:init()
		end
	end)
end

stereoFx.Channel = Channel
stereoFx.LChannel = LChannel
stereoFx.RChannel = RChannel

return stereoFx