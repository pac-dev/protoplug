--- Lagrange Interpolator.
-- Is converted to a [JUCE LagrangeInterpolator](http://www.juce.com/api/classLagrangeInterpolator.html)
-- @classmod juce.LagrangeInterpolator

ffi.cdef [[
LagrangeInterpolator LagrangeInterpolator_create();
int LagrangeInterpolator_process(LagrangeInterpolator ex,
					double speedRatio,
					const float* inputSamples,
					float* outputSamples,
					int numOutputSamplesToProduce);
]]

--- Constuctor.
-- @within Constructors
-- @constructor
-- @function LagrangeInterpolator
local LagrangeInterpolator = setmetatable({}, {
	__call = function (self)
		return protolib.LagrangeInterpolator_create()
	end
})

local LagrangeInterpolator_mt = {
	-- methods
	__index = {
		--- Interpolate. 
		-- @param speedRatio number of input samples per output sample (input/output)
		-- @param inputSamples pointer to a cdata `float` array
		-- @param outputSamples pointer to a cdata `float` array
		-- @param numOutputSamplesToProduce
		-- @treturn number number of input samples that were processed
		-- @function process
		process = function (self, speedRatio, inputSamples, outputSamples, numOutputSamplesToProduce)
			return protolib.LagrangeInterpolator_process(self, speedRatio, inputSamples, outputSamples, numOutputSamplesToProduce)
		end;
	}
}
ffi.metatype("LagrangeInterpolator", LagrangeInterpolator_mt);

return LagrangeInterpolator