--- Use this module to create a polyphonic generator with virtual tracks.
-- Example at @{sine-organ.lua}.
--
-- This module facilitates the creation of polyphonic instruments. It acts 
-- as a layer that covers the @{plugin.processBlock} function, receives MIDI
-- notes and dispatches them to virtual tracks. The `polyGen.VTrack` prototype
-- is exposed for you to define audio processing in a simple, 
-- monophonic, per-note fashion. Initialize this module by calling `polyGen.initTracks`.
--
-- The `polyGen` global is available to every protoplug script after including the 
-- main protoplug header :
-- 	require "include/protoplug"
-- @module polyGen



--- Set up virtual tracks.
-- This function must be called by any script that wishes to use this module. 
-- @param[opt=8] n the number of virtual tracks to use (aka. voices or polyphony)
-- @function polyGen.initTracks

--- Virtual track.
-- Virtual track. A monophonic voice that defines the instrument's sound.
-- <br><br>
-- @type polyGen.VTrack


--- Override to additively process an audio block.
-- Define the output of a virtual track in this method. 
-- Use `self.noteIsOn`, `self.noteFreq`, or any fields you defined to 
-- determine current the state of the calling track.
--
-- This method is called successively on every track, 
-- which should *add* their output to `samples`.
-- @param samples a C `float**` pointing to two channels of samples to add to.
-- @param smax the maximum sample index (nSamples - 1)
-- @see sine-organ.lua
-- @function VTrack:addProcessBlock

--- Override to recieve note on.
-- Override this method to handle a note getting dispatched to a virtual track.
-- @param note the MIDI note number (0-127)
-- @param vel the MIDI velocity (0-127)
-- @function VTrack:noteOn

--- Override to recieve note off.
-- Override this method to handle a note off on a virtual track.
-- @param note a reminder of the MIDI note number
-- @function VTrack:noteOff

--- Override to allow initialisation.
-- Override this method to perform initialisation tasks on each track, 
-- for example to create any per-track fields.
-- @function VTrack:init
	
local polyGen = {}

local script = require "include/core/script"
	
local VTrack = {noteIsOn = false, noteFreq=0.01, notePeriod=100, age = 0, note = -1}
VTrack.__index = VTrack
VTrack.tracks = { }

function VTrack.new(i)
   local o = {}
   setmetatable(o,VTrack)
	o.i = i	--same
   return o
end

local function processMidiEvent(msg)
	if msg:isNoteOn() then 
		-- note on, choose the best track for a new note
		local oldestPlaying_age, oldestPlaying_i = -1, -1
		local oldestReleased_age, oldestReleased_i = -1, -1
		for i=1,VTrack.numTracks do
			vt = VTrack.tracks[i]
			vt.age = vt.age+1
			if vt.note ~= -1 then
				-- track note is on
				if vt.age>oldestPlaying_age then
					oldestPlaying_i = i
					oldestPlaying_age = vt.age
				end
			else
				-- track is free
				if vt.age>oldestReleased_age then
					oldestReleased_i = i
					oldestReleased_age = vt.age
				end
			end
		end
		local chosentrack = {}
		if oldestReleased_i ~= -1 then
			chosentrack = VTrack.tracks[oldestReleased_i]
		else
			chosentrack = VTrack.tracks[oldestPlaying_i]
		end
		chosentrack.age = 0
		chosentrack.note = msg:getNote()
		chosentrack.noteFreq = midi.noteToFreq(chosentrack.note)
		chosentrack.notePeriod = 1/chosentrack.noteFreq
		if VTrack.noteOn~=nil then
			chosentrack:noteOn(chosentrack.note, msg:getVel(), msg)
		end
		chosentrack.noteIsOn = true
	elseif msg:isNoteOff() then
		-- note off
		for i=1,VTrack.numTracks do
			vt = VTrack.tracks[i]
			if vt.note == msg:getNote() then
				vt.age = 0
				vt.note = -1
				if VTrack.noteOff~=nil then
					vt:noteOff(msg:getNote(), msg)
				end
				vt.noteIsOn = false
			end
		end
	end
end

function polyGen.initTracks(n)
	VTrack.numTracks = n or 8
	for i=1,VTrack.numTracks do
		VTrack.tracks[i] = VTrack.new(i)
	end

	function plugin.processBlock (samples, smax, midiBuf)
		for msg in midiBuf:eachEvent() do
			processMidiEvent(msg)
		end
		for i=0,smax do
			samples[0][i] = 0
			samples[1][i] = 0
		end
		for i=1,VTrack.numTracks do
			if VTrack.addProcessBlock~=nil then
				VTrack.tracks[i]:addProcessBlock(samples, smax)
			end
		end
	end

	script.addHandler("init", function ()
		if VTrack.init~=nil then
			for i = 1,VTrack.numTracks do
				VTrack.tracks[i]:init()
			end
		end
	end)
end

polyGen.VTrack = VTrack

--- Track number.
-- Use `self.i` to check which virtual track is being called.
-- @field VTrack.i

--- Current MIDI note.
-- The MIDI note number that is currently being played by this track, 
-- or `-1` if in note off state.
-- @field VTrack.note

--- Current note frequency.
-- The note frequency that is currently being played by this track.
-- @field VTrack.noteFreq

--- Current note period.
-- `1/noteFreq`
-- @field VTrack.notePeriod

--- Note is on.
-- Whether the track is playing a note (`boolean`).
-- @field VTrack.noteIsOn


return polyGen
