--- Class to read audio files.
-- Example usage: @{soundfile-test.lua}.
--
-- Reads the formats that JUCE supports, namely: WAV, AIFF, Flac, Ogg-Vorbis, Windows Media codecs, 
-- CoreAudio codecs, MP3. 
--
-- Is a pointer to a [JUCE AudioFormatReader](http://www.juce.com/api/classAudioFormatReader.html), 
-- and wraps some [AudioFormatManager](http://www.juce.com/api/classAudioFormatManager.html)
-- functionality. 
-- @classmod juce.AudioFormatReader

local plugin = require"include/core/plugin"
local LagrangeInterpolator= require"include/protojuce/lagrangeinterpolator"

ffi.cdef [[
pAudioFormatReader AudioFormatReader_new(const char *filename);
bool AudioFormatReader_read (pAudioFormatReader a,
		int *const *  	destSamples,
		int  	numDestChannels,
		int64_t  	startSampleInSource,
		int  	numSamplesToRead,
		bool  	fillLeftoverChannelsWithCopies);
void AudioFormatReader_delete(pAudioFormatReader a);
]]

local AudioFormatReader = setmetatable ({}, {

	--- Load a sound file as an AudioFormatReader.
	-- The path can be absolute or relative to the protoplug directory.
	-- Returns `nil` if unsuccessful. The file will remain open until the 
	-- AudioFormatReader is unset or otherwise garbage-collected. 
	-- @param filename
	-- @within Constructors
	-- @constructor
	-- @function AudioFormatReader

	__call = function(self, filename)
		local afr = protolib.AudioFormatReader_new(filename)
		if afr.pointer == nil then return end
		
		return ffi.gc(afr, protolib.AudioFormatReader_delete)
	end;
})

local AudioFormatReader_mt = {
	-- methods
	__index = {

		--- Read samples. 
		-- Copies a number of samples from the file into the provided array. 
		-- @param destSamples a cdata array of pointers to buffers for each channel (`int * const *`)
		-- @param numDestChannels the number of elements in `destSamples`
		-- @param startSampleInSource
		-- @param numSamplesToRead
		-- @tparam[opt=true] boolean fillLeftoverChannelsWithCopies used if `destSamples` has more channels than the source.
		-- @treturn boolean success
		-- @function read
		read = function (self, destSamples, numDestChannels, startSampleInSource, numSamplesToRead, fillLeftoverChannelsWithCopies)
			if fillLeftoverChannelsWithCopies==nil then
				fillLeftoverChannelsWithCopies = true
			end
			return protolib.AudioFormatReader_read(self, destSamples, numDestChannels, startSampleInSource, numSamplesToRead, fillLeftoverChannelsWithCopies)
		end;

		--- Read entire wave to float array. 
		-- A simplified wrapper function for `read`
		-- @param[opt=2] nChannels number of channels to be returned
		-- @param[opt=true] resample whether to perform samplerate conversion to match the host's sample rate. 
		-- If `true`, the length of the returned array may not be the wave's original `lengthInSamples`. 
		-- It will be given by the second returned value.
		-- @return a two-dimensional cdata array of channels containing samples (`float [nChannels][nSamples]`)
		-- @return the number of samples in each channel of the returned array
		-- @function readToFloat
		readToFloat = function (self, nChannels, resample)
			nChannels = nChannels or 2
			resample = resample or true
			local floty  = ffi.new("float["..nChannels.."]["..tonumber(self.lengthInSamples).."]")
			local inty_arg = ffi.new("int*["..nChannels.."]")
			for ch=0,nChannels-1 do
				inty_arg[ch] = ffi.cast("int*", floty)+self.lengthInSamples*ch
			end
			local gotWave = self:read(inty_arg, nChannels, 0, tonumber(self.lengthInSamples))
			if not gotWave then error "can't read wave" end
			if not self.usesFloatingPointData then
				for i=0,tonumber(self.lengthInSamples)-1 do
					for ch=0,nChannels-1 do
						floty[ch][i] = inty_arg[ch][i]/0x80000000
					end
				end
			end
			if resample then 
				local plugSampleRate = plugin.getSampleRate()
				if self.sampleRate ~= plugSampleRate then
					local len2 = math.floor((plugSampleRate*tonumber(self.lengthInSamples))/self.sampleRate)
					local flot2 = ffi.new("float["..nChannels.."]["..len2.."]")
					local li = LagrangeInterpolator()
					for ch=0,nChannels-1 do
						li:process(self.sampleRate/plugSampleRate, floty[ch], flot2[ch], len2)
					end
					return flot2, len2
				end
			end
			return floty, self.lengthInSamples
		end;

		--- Read entire wave to double array. 
		-- This wraps `readToFloat` and returns an array containing `double`-precision numbers. 
		-- This takes twice as much space, but it may be faster to use, as this is the native Lua type. 
		-- @param[opt=2] nChannels number of channels to be returned
		-- @param[opt=true] resample whether to perform samplerate conversion to match the host's sample rate. 
		-- If `true`, the length of the returned array may not be the wave's original `lengthInSamples`. 
		-- It will be given by the second returned value.
		-- @return a two-dimensional cdata array of channels containing samples (`double [nChannels][nSamples]`)
		-- @return the number of samples in each channel of the returned array
		-- @function readToDouble
		readToDouble = function (self, nChannels, resample)
			nChannels = nChannels or 2
			resample = resample or true
			local floty, len = self:readToFloat(nChannels)
			local douby  = ffi.new("double["..nChannels.."]["..tonumber(len).."]")
			for i=0,tonumber(len)-1 do
				for ch=0,nChannels-1 do
					douby[ch][i] = floty[ch][i]
				end
			end
			return douby, len
		end;
	}
}
ffi.metatype("pAudioFormatReader", AudioFormatReader_mt);

--- Sample rate
-- @simplefield sampleRate

--- Bits per sample
-- @simplefield bitsPerSample

--- Length in samples
-- @simplefield lengthInSamples

--- Number of channels
-- @simplefield numChannels

--- Uses floating point data (boolean)
-- @simplefield usesFloatingPointData

return AudioFormatReader