--[[
name: karplus synth
description: A simple karplus-string VST/AU. 
author: victor bombi
--]]

require "include/protoplug"

local Fdelay = require "include/vic/fdelay_line"
local Filter = require "include/vic/cookbook_filters"
local Env = require "include/vic/Env"
local att_secs = 0
local rel_secs = 0.3
local maxbuff = 2048 --44100/20

polyGen.initTracks(8)

function polyGen.VTrack:init()
	-- create per-track fields here
	self.filter = Filter{type = "hs", f = 15000, gain = -3, Q = 0.1}
    self.filter_excit = Filter{type = "hs", f = 6000, gain = -6, Q = 1}
    self.env = Env.EnvLinear:new{}
    self.envT = Env.EnvTri:new{}
    self.delay = Fdelay(maxbuff)
end

function polyGen.VTrack:addProcessBlock(samples, smax)
	local envamp = 1
    local tick_len = 1/plugin.getSampleRate()
    local dt = self.notePeriod - self.filter.phaseDelay(self.noteFreq*plugin.getSampleRate())
	for i = 0,smax do
		if self.env.ended then break end
        envamp = self.env:get_amp(tick_len)
        local envampT = self.envT:get_amp(tick_len)
        local loops = self.delay.goBack(dt)
		local trackSample = self.filter_excit.process(2*math.random()-1)*envampT*self.amp + loops
        trackSample = self.delay.dc_remove(trackSample)
        trackSample = self.filter.process(trackSample)
        self.delay.push(trackSample*0.999)
        trackSample = trackSample *envamp*0.1
		samples[0][i] = samples[0][i] + trackSample -- left
		samples[1][i] = samples[1][i] + trackSample -- right
	end
end

function polyGen.VTrack:noteOff(note, ev)
	self.env:release()
end
function linearmap(v,s,e,ds,de)
	return ((de-ds)*(v-s)/(e-s)) + ds
end
function polyGen.VTrack:noteOn(note, vel, ev)
    self.env:init(att_secs, rel_secs)
    self.envT:init(0, 0.05)
    self.delay.zero()
	local amp = vel/127
	self.amp = amp * amp
    self.filter_excit.update{f=linearmap(self.amp,0,1,500,6000)}
end

params = plugin.manageParams {
	{
		name = "Attack";
		max = 1;
		changed = function(val) att_secs = val end;
	};
	{
		name = "Release";
		max = 1;
		changed = function(val) rel_secs = val end;
	};
}