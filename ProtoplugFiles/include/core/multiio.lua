--- This module allows handling of multiple audio channels (stereo or more).
-- For more info on multichannel handling, see this article:
-- http://osar.fr/articles/10/Handling_Stereo_and_Multichannel_in_Protoplug
--
-- Most effects and non-mono instruments should use `multiIO.Channel` for easy 
-- management of multiple channels. Define @{Channel:processBlock} 
-- instead of @{plugin.processBlock}, and processing will be applied to every 
-- channel.
--
-- The `multiIO` global is available to every protoplug script after including the 
-- main protoplug header :
-- 	require "include/protoplug"
-- @module multiIO

local script = require "include/core/script"
local multiIO = {}


--- Callback functions.
-- Functions that your script can call.
-- <br><br>
-- @section callbacks

--- Get the number of input channels.
-- Returns the total number of input channels (connected or not), as set by the plugin's
-- filename (eg. will return 4 if using `Lua Protoplug Fx 4in 8out.dll`).
-- @treturn number
-- @function multiIO.getNumInputs
multiIO.getNumInputs = plugin_getMaxInputChannels

--- Get the number of output channels.
-- Returns the total number of output channels (connected or not), as set by the plugin's
-- filename (eg. will return 8 if using `Lua Protoplug Fx 4in 8out.dll`).
-- @treturn number
-- @function multiIO.getNumOutputs
multiIO.getNumOutputs = plugin_getMaxOutputChannels

--- Get the number of currently connected input channels.
-- Returns number of input channels currently connected to another node in the host.
-- @treturn number
-- @function multiIO.getNumConnectedInputs
multiIO.getNumConnectedInputs = plugin_getNumConnectedInputChannels

--- Get the number of output channels.
-- Returns number of output channels currently connected to another node in the host.
-- @treturn number
-- @function multiIO.getNumConnectedOutputs
multiIO.getNumConnectedOutputs = plugin_getNumConnectedOutputChannels


--- Override functions.
-- Define these functions and the host will call them.
-- <br><br>
-- @section overrides

--- Receive MIDI before multichannel audio.
-- If you defined @{Channel:processBlock}, and you also want to 
-- process MIDI, define this function and it will get called on every block 
-- before any audio processing happens. 
-- 
-- @tparam midi.Buffer midiBuf the MIDI data for this block, serving as input and output
-- @function multiIO.processMIDI


--- Channel.
-- This class represents an Input/Output audio channel.
-- <br><br>
-- @type multiIO.Channel


--- Override to process a channel's audio block.
-- Define the audio processing of an I/O channel in this function. If this is 
-- defined, it will be called instead of @{plugin.processBlock}. 
-- @param samples a C float* serving as input and output
-- @param smax the maximum sample index (nSamples - 1)
-- @function Channel:processBlock

--- Override to handle initialisation.
-- Override this method to perform initialisation tasks on each channel,
-- for example to create any per-channel fields.
-- @function Channel:init

local Channel = { }
function Channel:new (o)
	setmetatable(o, self)
	self.__index = self
	return o
end

multiIO.channels = {}
local nChannels = math.max(multiIO.getNumInputs(), multiIO.getNumOutputs())
for i = 1, nChannels do
	multiIO.channels[i] = Channel:new{ index = i }
end

script.addHandler("init", function ()
	if Channel.processBlock==nil then return 0 end
	function plugin.processBlock (samples, smax, midiBuf)
		if multiIO.processMIDI then
			multiIO.processMIDI(midiBuf)
		end
		for _, c in pairs(multiIO.channels) do
			c:processBlock(samples[c.index-1], smax)
		end
	end
	if Channel.init~=nil then
		for _, c in pairs(multiIO.channels) do
			c:init()
		end
	end
end)
	

multiIO.Channel = Channel

return multiIO