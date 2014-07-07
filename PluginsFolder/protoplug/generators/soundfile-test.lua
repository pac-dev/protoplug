--[[
name: soundfile test
description: A simple demo that plays an audio file. 
author: osar.fr
--]]

require "include/protoplug"

local path = "C:\\temp\\pluck44.wav"
local wave, len

plugin.addHandler('prepareToPlay', function()
	-- use 'prepareToPlay', because the host sample rate must be known for 
	-- automatic samplerate conversion (see juce.AudioFormatReader:readToFloat)
	local readr = juce.AudioFormatReader(path)
	if readr==nil then error ("can't open wave: "..path) end
	wave, len = readr:readToFloat(2) -- require 2 channels
end)

polyGen.initTracks(8)

function polyGen.VTrack:noteOn(note, vel, ev)
	self.playing = true
	self.wavepos = 0
end

function polyGen.VTrack:noteOff(note, ev)
	self.playing = false
end

function polyGen.VTrack:addProcessBlock(samples, smax)
	for i = 0,smax do
		if self.playing and self.wavepos < len then
			self.wavepos = self.wavepos + 1
			samples[0][i] = samples[0][i] + wave[0][self.wavepos] -- left
			samples[1][i] = samples[1][i] + wave[1][self.wavepos] -- right
		end
	end
end
