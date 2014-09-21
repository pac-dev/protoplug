--- `midi` contains MIDI-related classes and functions.
-- Example of receiving MIDI input : @{sine-organ.lua}.
--
-- Example of producing MIDI output : @{midi-chordify.lua}.
--
-- The `midi` global is available to every protoplug script after including the 
-- main protoplug header :
-- 	require "include/protoplug"
-- @module midi

-- Bitte ein BitOp
local bnot = bit.bnot
local band, bor, bxor = bit.band, bit.bor, bit.bxor
local lshift, rshift, rol = bit.lshift, bit.rshift, bit.rol

ffi.cdef [[

typedef struct pMidiBuffer
{ void *pointer; } pMidiBuffer;

uint8_t *MidiBuffer_getDataPointer(pMidiBuffer mb);
int MidiBuffer_getDataSize(pMidiBuffer mb);
void MidiBuffer_resizeData(pMidiBuffer mb, int size);

// artist's rendition of the juce::MidiBuffer internal format
// ("don't write code that relies on it!"  -Jules)
typedef struct MidiEvent
{
	int32_t time;
	const uint16_t dataSize;
	uint8_t data[?];
} MidiEvent;
]]

local midi = {}

--- Convert a MIDI note number to frequency.
-- Call this function to get a note's frequency.
-- @param note the MIDI note (0-127)
-- @return the frequency in samples^-1
-- @function midi.noteToFreq
function midi.noteToFreq(n)
	return 2^((n-69)/12)*440/plugin.getSampleRate()
end


--- Midi Event List.
-- A buffer containing midi events, as received by @{plugin.processBlock}
-- <br><br>
-- @type midi.Buffer
midi.Buffer = ffi.typeof("pMidiBuffer")

local locks = {}

local Buffer_mt = {
	-- methods
	__index = {
	
		--- Iterate over each @{midi.Event} in the buffer.
		-- @usage for ev in myBuffer:eachEvent() do print(ev:getNote()) end
		-- @function Buffer:eachEvent
		eachEvent = function (self)
			-- COROUTINE ITERATOR IS EVIL ITERATOR
			return coroutine.wrap(function ()
				local dataStart = protolib.MidiBuffer_getDataPointer(self)
				local msg = dataStart
				local nBytes = protolib.MidiBuffer_getDataSize(self)
				self:lock()
				while msg < dataStart + nBytes do
					ret = ffi.cast("MidiEvent*",msg)
					coroutine.yield(ret)
					msg = msg + 
						ffi.sizeof"int32_t" + 
						ffi.sizeof"uint16_t" +  
						ffi.sizeof"uint8_t" * ret.dataSize
				end
				self:unlock()
			end)
		end;
	
		--- Remove all MIDI events from the buffer.
		-- @function Buffer:clear
		clear = function (self)
			self:checkLock()
			protolib.MidiBuffer_resizeData(self, 0)
		end;
	
		--- Add a MIDI event.
		-- @tparam midi.Event event
		-- @function Buffer:addEvent
		addEvent = function (self, event)
			self:checkLock()
			local nBytes = protolib.MidiBuffer_getDataSize(self)
			protolib.MidiBuffer_resizeData(self, nBytes + event.dataSize+ffi.sizeof("int32_t")+ffi.sizeof("uint16_t"))
			local dataStart = protolib.MidiBuffer_getDataPointer(self)
			ffi.copy(dataStart + nBytes, event, event.dataSize+ffi.sizeof("int32_t")+ffi.sizeof("uint16_t"))
		end;
		
		-- internal
		lock = function (self)
			local addr = tonumber(ffi.cast("int", protolib.MidiBuffer_getDataPointer(self)))
			locks[addr] = locks[addr] and locks[addr] + 1 or 1
		end;
		
		unlock = function (self)
			local addr = tonumber(ffi.cast("int", protolib.MidiBuffer_getDataPointer(self)))
			if not locks[addr] then return end
			locks[addr] = locks[addr] - 1
			if locks[addr] < 1 then locks[addr] = nil end
		end;
		
		checkLock = function (self)
			local addr = tonumber(ffi.cast("int", protolib.MidiBuffer_getDataPointer(self)))
			if locks[addr] then
				error "Cannot modify a midi.Buffer while iterating through it."
			end
		end;
		
		debug = function (self)
			self:checkLock()
			local o = ""
			local max = protolib.MidiBuffer_getDataSize(self)
			local addr = protolib.MidiBuffer_getDataPointer(self)
			for i = 0,max-1 do
				addr = addr + 1
				o = o..bit.tohex(addr[0],4).." "
			end
			print (o)
		end;
		
	};
}
ffi.metatype(midi.Buffer, Buffer_mt)

--- Midi Event.
-- A single midi event as returned by @{Buffer:eachEvent}
-- <br><br>
-- @type midi.Event

midi.Event = setmetatable ({}, {
	--- Constructor : copy another event.
	-- @tparam midi.Event other
	-- @display midi.Event
	-- @function Event

	--- Constructor : create a custom event.
	-- Create an event from given bytes (or zeros if not supplied)
	-- @usage myEv = midi.Event(0, 3, {0x90, 0x30, 0x7f}) -- note on
	-- @param time
	-- @param dataSize
	-- @param[opt] data
	-- @display midi.Event
	-- @function midi.Event
	__call = function(self, ...)
		if select("#", ...)==1 then
			local o = ...
			local n = ffi.new("MidiEvent", o.dataSize, o.time, o.dataSize)
			ffi.copy(n.data, o.data, o.dataSize)
			return n
		elseif select("#", ...)==2 then
			local time, dataSize, data = ...
			local n = ffi.new("MidiEvent", dataSize, time, dataSize)
			if data then 
				for k,v in ipairs(data) do n.data[k-1] = v end
			else
				ffi.fill(n.data, dataSize)
			end
			return n
		end
	end;
})
	
--- Constructor : note on.
-- @param channel (1-16)
-- @param note (0-127)
-- @param vel (1-127)
-- @param[opt=0] pos sample offset
-- @treturn midi.Event
-- @function Event.noteOn
midi.Event.noteOn = function (channel, note, vel, pos)
	pos = pos or 0
	local n = midi.Event(pos, 3)
	n.data[0] = bor(0x90, channel-1)
	n.data[1] = band(note, 127)
	n.data[2] = band(vel, 127)
	return n
end
	
--- Constructor : note off.
-- @param channel (1-16)
-- @param note (0-127)
-- @param[opt=0] vel (0-127)
-- @param[opt=0] pos sample offset
-- @treturn midi.Event
-- @function Event.noteOff
midi.Event.noteOff = function (channel, note, vel, pos)
	pos = pos or 0
	vel = vel or 0
	local n = midi.Event(pos, 3)
	n.data[0] = bor(0x80, channel-1)
	n.data[1] = band(note, 127)
	n.data[2] = band(vel, 127)
	return n
end
	
--- Constructor : pitch bend.
-- @param channel (1-16)
-- @param pitch bend value (0-16383)
-- @param[opt=0] pos sample offset
-- @treturn midi.Event
-- @function Event.pitchBend
midi.Event.pitchBend = function (channel, val, pos)
	pos = pos or 0
	local n = midi.Event(pos, 3)
	n.data[0] = bor(0xe0, channel-1)
	n.data[1] = band(val, 127)
	n.data[2] = band(rshift(val,7), 127)
	return n
end
	
--- Constructor : Control change.
-- @param channel (1-16)
-- @param number control number (0-247)
-- @param value control value (0-127)
-- @param[opt=0] pos sample offset
-- @treturn midi.Event
-- @function Event.control
midi.Event.control = function (channel, num, val, pos)
	pos = pos or 0
	local n = midi.Event(pos, 3)
	n.data[0] = bor(0xb0, channel-1)
	n.data[1] = band(num, 127)
	n.data[2] = band(val, 127)
	return n
end

local MidiEvent_mt = {
	-- todo precalculate ?
	-- status = 	band(self.data[0], 0xf0)
	-- note 	= 	band(self.data[1], 0x7f)
	-- vel = 	band(self.data[2], 0x7f)
	-- also sanity check ? if msg.dataSize>=3 then
	
	-- methods
	__index = {
		
		--- Get channel.
		-- @return the MIDI channel (1-16)
		-- @function Event:getChannel
		getChannel = function (self)
			if band(self.data[0], 0xf0) ~= 0xf0 then
				return band(self.data[0], 0xf) + 1
			end
		end;
	
		--- Set channel.
		-- @param channel the MIDI channel (1-16)
		-- @function Event:setChannel
		setChannel = function (self, channel)
			if band(self.data[0], 0xf0) ~= 0xf0 then
				self.data[0] = 
					bor(
						band(self.data[0], 0xf0),
						channel-1
					)
			end
		end;
	
		--- Is a note on event.
		-- @treturn boolean whether event is a note on.
		-- @function Event:isNoteOn
		isNoteOn = function (self)
			return (band(self.data[0], 0xf0)==0x90 and band(self.data[2], 0x7f)~=0)
		end;
	
		--- Is a note off event.
		-- @treturn boolean whether event is a note off.
		-- @function Event:isNoteOff
		isNoteOff = function (self)
			return (band(self.data[0], 0xf0)==0x80 or (band(self.data[0], 0xf0)==0x90 and band(self.data[2], 0x7f)==0))
		end;
	
		--- Get note.
		-- @return the MIDI note number (0-127)
		-- @function Event:getNote
		getNote = function (self)
			return band(self.data[1], 0x7f)
		end;
	
		--- Set note.
		-- @param note the MIDI note number (0-127)
		-- @function Event:setNote
		setNote = function (self, note)
			if self:isNoteOn() or self:isNoteOff() then
				self.data[1] = band(note, 127)
			end
		end;
	
		--- Get velocity.
		-- @return the MIDI velocity (1-127)
		-- @function Event:getVel
		getVel = function (self)
			return band(self.data[2], 0x7f)
		end;
	
		--- Set velocity.
		-- @param vel the MIDI velocity (1-127)
		-- @function Event:setVel
		setVel = function (self, vel)
			if self:isNoteOn() or self:isNoteOff() then
				self.data[2] = vel
			end
		end;
	
		--- Is a pitch bend event.
		-- @treturn boolean whether event is a pitch bend on.
		-- @function Event:isPitchBend
		isPitchBend = function (self)
			return band(self.data[0], 0xf0)==0xe0
		end;
	
		--- Get pitch bend value.
		-- @return pitch bend value (0-16383).
		-- @function Event:getPitchBendValue
		getPitchBendValue = function (self)
			if not self:isPitchBend() then error "not a pitch bend event" end
			return bor(self.data[1], lshift(self.data[2], 7))
		end;
	
		--- Is a Control Change event.
		-- @treturn boolean whether event is a control change.
		-- @function Event:isControl
		isControl = function (self)
			return band(self.data[0], 0xf0)==0xb0
		end;
	
		--- Get control number.
		-- @return control number (0-247).
		-- @function Event:getControlNumber
		getControlNumber = function (self)
			if not self:isControl() then error "not a control event" end
			return self.data[1]
		end;
	
		--- Get control value.
		-- @return control value (0-127).
		-- @function Event:getControlValue
		getControlValue = function (self)
			if not self:isControl() then error "not a control event" end
			return self.data[2]
		end;
		
		debug = function (self)
			print (tonumber(self.time).." "..
				tonumber(self.dataSize).." "..
				bit.tohex(self.data[0],4).." ".. 
				bit.tohex(self.data[1],4).." ".. 
				bit.tohex(self.data[2],4))
		end;
	};
}

--- Sample position relatively to the start of the block.
-- This value is often 0 because most hosts call @{plugin.processBlock} at the 
-- beginning of beats and beat divisions. It is never higher than the 
-- current @{plugin.processBlock}'s `smax` and any events created by the script 
-- should respect this rule.
-- @field Event.time

--- Size of the MIDI message in bytes
-- @field Event.dataSize

--- The raw MIDI message
-- (`const uint8_t*` cdata)
-- @field Event.data

ffi.metatype("MidiEvent", MidiEvent_mt)

return midi
