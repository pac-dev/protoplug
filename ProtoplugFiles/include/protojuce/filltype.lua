--- Fill Type.
-- Is a pointer to a [JUCE FillType](http://www.juce.com/api/classFillType.html).
-- Can be used by @{juce.Graphics} for fill operations.
-- @classmod juce.FillType

local Colour = require"include/protojuce/colour"

ffi.cdef [[
pFillType FillType_new(Colour c);
pFillType FillType_new2(pColourGradient c);
void FillType_delete(pFillType f);
void FillType_setOpacity (pFillType f, float newOpacity);
]]


--- Constuct from a @{juce.Colour}.
-- @tparam juce.Colour Colour
-- @within Constructors
-- @constructor
-- @function FillType

--- Constuct from a @{juce.ColourGradient}.
-- @tparam juce.ColourGradient Gradient
-- @within Constructors
-- @constructor
-- @function FillType

local FillType = setmetatable({}, {
	__call = function (self, a)
		if ffi.istype("Colour", a) then
			return ffi.gc(
				protolib.FillType_new(a), 
				protolib.FillType_delete
			)
		else -- gradient
			return ffi.gc(
				protolib.FillType_new2(a), 
				protolib.FillType_delete
			)
		end
	end
})
local FillType_mt = {
	-- methods
	__index = {
	
		--- Set Overall Opacity.
		-- @param newOpacity
		-- @function setOpacity
		setOpacity = function (self, newOpacity)
			protolib.FillType_setOpacity(self, newOpacity)
		end;
	}
}
ffi.metatype("pFillType", FillType_mt)

FillType.black 	= FillType(Colour.black)
FillType.white 	= FillType(Colour.white)
FillType.red 	= FillType(Colour.red)
FillType.green 	= FillType(Colour.green)
FillType.blue 	= FillType(Colour.blue)


--- @predefined black

--- @predefined white

--- @predefined red

--- @predefined green

--- @predefined blue

return FillType