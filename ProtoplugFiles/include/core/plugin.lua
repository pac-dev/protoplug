--- Use `plugin` to define the AU/VST audio plugin's behaviour.
-- The `plugin` global is available to every protoplug script after including the 
-- main protoplug header :
-- 	require "include/protoplug"
-- @module plugin

ffi.cdef [[

// pasted from juce_AudioPlayHead.h
typedef struct CurrentPositionInfo
{
	double bpm;
	int timeSigNumerator;
	int timeSigDenominator;
	int64_t timeInSamples;
	double timeInSeconds;
	double editOriginTime;
	double ppqPosition;
	double ppqPositionOfLastBarStart;
	int frameRate;
	bool isPlaying;
	bool isRecording;
	double ppqLoopStart;
	double ppqLoopEnd;
	bool isLooping;
} CurrentPositionInfo;

typedef struct pAudioPlayHead
{ void *pointer; } pAudioPlayHead;

bool AudioPlayHead_getCurrentPosition(pAudioPlayHead self, CurrentPositionInfo& result);
]]

local script = require "include/core/script"

local plugin = {}

local sampleRate

script.addHandler("init", function ()
	--- Override functions.
	-- Define these functions and the host will call them.
	-- <br><br>
	-- @section overrides
	
	
	--- Process Audio Block.
	-- Override this function to input and output audio and MIDI data.
	--
	-- This override is handled automatically if @{stereoFx} or @{polyGen} are used. 
	-- Use this function to handle the raw data instead.
	-- @param samples a C float** pointing to two channels of samples, serving as input and output
	-- @param smax the maximum sample index (nSamples - 1)
	-- @tparam midi.Buffer midiBuf the MIDI data for this block, serving as input and output
	-- @usage function plugin.processBlock (samples, smax) -- let's ignore midi for this example
	--     for i = 0, smax do
	--         samples[0][i] = sin(myTime) -- left channel
	--         samples[1][i] = sin(myTime) -- right channel
	--         myTime = myTime + myDelta
	--     end
	-- end
	-- @function plugin.processBlock
	local dbged = false
	if type(plugin.processBlock) == "function" then
		local prepared = false
		function plugin_processBlock(nSamples, samples, midiBuf, playHead, _sampleRate)
			if not dbged then
				dbged=true
			end
			sampleRate = _sampleRate
			if not prepared then
				prepared = true
				if plugin.prepareToPlay then
					for _,v in ipairs(plugin.prepareToPlay) do
						v()
					end
				end
			end
			samples = ffi.typeof("float**")(samples)
			midiBuf = ffi.typeof("pMidiBuffer")(midiBuf)
			plugin.playHead = ffi.typeof("pAudioPlayHead")(playHead)
			plugin.processBlock(samples, nSamples-1, midiBuf)
			plugin.playHead = nil
		end
	end
	
	--- Return the name of a parameter.
	--
	-- This override is handled automatically if @{manageParams} is used.
	-- @param index parameter index (0-126)
	-- @treturn string the parameter's name
	-- @function plugin.getParameterName
	plugin_getParameterName = plugin.getParameterName
	
	--- Return the representation of a parameter's value.
	-- Override this function to choose how each parameter's value should 
	-- be displayed by the host. The parameter's current value can be obtained 
	-- using @{plugin.getParameter}
	--
	-- This override is handled automatically if @{manageParams} is used.
	-- @param index parameter index (0-126)
	-- @treturn string a string representation of the parameter's current value
	-- @function plugin.getParameterText
	plugin_getParameterText = plugin.getParameterText
	
	--- Handle parameter changes.
	-- Override this function to do something when a parameter changes
	-- The parameter's current value can be obtained using @{plugin.getParameter}
	--
	-- This override is handled automatically if @{manageParams} is used.
	-- @param index parameter index (0-126)
	-- @function plugin.paramChanged
	plugin_paramChanged = plugin.paramChanged
	
	-- todo
	plugin_parameterText2Double = plugin.parameterText2Double
	
	--- Return the tail length in seconds (effects only).
	-- Override this function to define the effect's audio tail length.
	-- @return the tail length in seconds
	-- @function plugin.getTailLengthSeconds
	plugin_getTailLengthSeconds = plugin.getTailLengthSeconds

end)
	
	
--- Callback functions.
-- Functions that your script can call.
-- <br><br>
-- @section callbacks

--- Automatically set up a list of parameters.
-- Call this function with a table containing parameter definitions as argument, and
-- it will perform the repetitive task of defining all the parameter-related overrides.
--
-- The format of the parameter list is demonstrated in @{classic-filter.lua}
-- @param paramList a table with parameter definitions (see example)
-- @function plugin.manageParams
plugin.manageParams = require "include/core/manageparams"

--- Set (automate) a parameter's value.
-- The value must be normalized to be between 0 and 1.
-- @param index parameter index (0-126)
-- @param value parameter value (0-1)
-- @function plugin.setParameter
plugin.setParameter = plugin_setParameter

--- Get a parameter's value.
-- The values are between 0 and 1, but different minimums and maximums can 
-- be easily simulated using @{plugin.manageParams}.
-- @param index parameter index (0-126)
function plugin.getParameter(index)
	return plugin_params[index]
end
plugin_params = ffi.typeof("const double *")(plugin_params)

--- Get host position info, if available.
-- Only call this from within @{processBlock}.
-- @treturn plugin.PositionInfo current position info, or `nil` depending on the host.
-- @function plugin.getCurrentPosition
plugin.getCurrentPosition = function ()
	if not plugin.playHead then return end
	local pos = ffi.new("CurrentPositionInfo")
	local res = protolib.AudioPlayHead_getCurrentPosition(plugin.playHead, pos)
	if res==true then
		return pos
	end
end

--- Get host samplerate.
-- The value is unknown until the plugin `prepareToPlay` event has been emitted.
-- The value is always known in @{processBlock}. An error is caused if an 
-- attempt is made to access the sample rate prematurely. 
-- @see plugin.addHandler
-- @return current samplerate.
-- @function plugin.getSampleRate
plugin.getSampleRate = function ()
	if sampleRate == nil then 
		error ("Trying to use sampleRate when it is not yet known. " ..
		"Use plugin.addHandler('prepareToPlay',...) to initialize and use the samplerate. ")
	end
	return sampleRate
end

--- Check if the samplerate is known.
-- @treturn boolean 
-- @function plugin.isSampleRateKnown
plugin.isSampleRateKnown = function ()
	return (sampleRate ~= nil)
end

--- Add a handler for a VST/AU event.
-- The following events are available :
--
-- - `"prepareToPlay"` - Emitted before the first call to @{processBlock}, when the samplerate is known.
-- @see script.addHandler
-- @see gui.addHandler
-- @tparam string event the event to handle
-- @tparam function handler a function to add the event's handlers
function plugin.addHandler(event, handler)
	if not plugin[event] then plugin[event] = {} end
	table.insert(plugin[event], handler)
end


--- Host position information.
-- A container type for host-related information as returned by @{plugin.getCurrentPosition}
--
-- Is a [JUCE AudioPlayHead::CurrentPositionInfo](http://www.juce.com/api/structAudioPlayHead_1_1CurrentPositionInfo.html)
-- <br><br>
--@type plugin.PositionInfo

--- Host tempo (beats per minute) 
-- @field PositionInfo.bpm


--- Time signature numerator ie. *3*/4
-- @field PositionInfo.timeSigNumerator


--- Time signature denominator ie. 3/*4*
-- @field PositionInfo.timeSigDenominator


--- Current position on the host's timeline (samples)
-- @field PositionInfo.timeInSamples


--- Current position on the host's timeline (seconds)
-- @field PositionInfo.timeInSeconds


--- Position of the start of the edit region on the host's timeline
-- @field PositionInfo.editOriginTime


--- Current position on the host's timeline (pulses-per-quarter-note)
-- @field PositionInfo.ppqPosition


--- Position of the last bar start (pulses-per-quarter-note).
-- (or zero if unavailable.)
-- @field PositionInfo.ppqPositionOfLastBarStart


--- Video frame rate
-- @field PositionInfo.frameRate


--- Is playing
-- @field PositionInfo.isPlaying


--- Is recording
-- @field PositionInfo.isRecording


--- Position of the loop start (pulses-per-quarter-note).
-- (or zero if unavailable.)
-- @field PositionInfo.ppqLoopStart


--- Position of the loop end (pulses-per-quarter-note).
-- (or zero if unavailable.)
-- @field PositionInfo.ppqLoopEnd


--- Is looping
-- @field PositionInfo.isLooping



return plugin
