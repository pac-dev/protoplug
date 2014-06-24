--[[
name: midi chordify
description: MIDI processor VST/AU. Notes go in, chords come out.
author: osar.fr
--]]

require "include/protoplug"

-- what kind of chord ?
local chordStructure = {0, 3, 5, 7, 11}
local blockEvents = {}

function plugin.processBlock(samples, smax, midiBuf)
	blockEvents = {}
	-- analyse midi buffer and prepare a chord for each note
	for ev in midiBuf:eachEvent() do
		if ev:isNoteOn() then
			chordOn(ev)
		elseif ev:isNoteOff() then
			chordOff(ev)
		end	
	end
	-- fill midi buffer with prepared notes
	midiBuf:clear()
	if #blockEvents>0 then
		for _,e in ipairs(blockEvents) do
			midiBuf:addEvent(e)
		end
	end
end

function chordOn(root)
	for _, offset in ipairs(chordStructure) do
		local newEv = midi.Event.noteOn(
			root:getChannel(), 
			root:getNote()+offset, 
			root:getVel())
		table.insert(blockEvents, newEv)
	end
end

function chordOff(root)
	for _, offset in ipairs(chordStructure) do
		local newEv = midi.Event.noteOff(
			root:getChannel(), 
			root:getNote()+offset)
		table.insert(blockEvents, newEv)
	end
end
