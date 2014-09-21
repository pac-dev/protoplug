--[[
name: sine organ
description: A simple organ-like sinewave VST/AU. 
author: osar.fr
--]]

require "include/protoplug"

local release = 10000
local decayRate = 1/release

polyGen.initTracks(8)

function polyGen.VTrack:init()
	-- create per-track fields here
	self.phase = 0
	self.releasePos = release
end

function polyGen.VTrack:addProcessBlock(samples, smax)
	local amp = 1
	for i = 0,smax do
		if not self.noteIsOn then
			-- release is finished : idle track
			if self.releasePos>=release then break end
			-- release is under way
			amp = 1-self.releasePos*decayRate
			self.releasePos = self.releasePos+1
		end
		self.phase = self.phase + (self.noteFreq*math.pi*2)
		-- math.sin is slow but once per sample is no tragedy
		local trackSample = math.sin(self.phase)*amp*0.3
		samples[0][i] = samples[0][i] + trackSample -- left
		samples[1][i] = samples[1][i] + trackSample -- right
	end
end

function polyGen.VTrack:noteOff(note, ev)
	self.releasePos = 0
end

function polyGen.VTrack:noteOn(note, vel, ev)
	-- start the sinewave at 0 for a clickless attack
	self.phase = 0
end