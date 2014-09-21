--- A simple colour class.
-- Is converted to a [JUCE Colour](http://www.juce.com/api/classColour.html)
-- @classmod juce.Colour

--- Constuctor with classical arguments.
-- @param r red
-- @param g green
-- @param b blue
-- @param[opt] a alpha
-- @within Constructors
-- @constructor
-- @function Colour

--- Constuctor with named arguments.
-- Every field is optional.
-- @tparam table args
-- @param args.r red
-- @param args.g green
-- @param args.b blue,
-- @param args.a alpha
-- @within Constructors
-- @constructor
-- @function Colour

local Colour = setmetatable({}, {
	__call = function (self, ...)
		local c = {}
		c.r, c.g, c.b, c.a = ...
		if type(c.r)=="table" then c = c.r end
		c.a = c.a or 0xff
		return ffi.new("Colour",c)
	end
})
local Colour_mt = {
	-- operator '=='
	__eq = function(self, rhs)
		return	self.argb == rhs.argb
	end;
}
ffi.metatype("Colour", Colour_mt);

Colour.black 	= Colour()
Colour.white 	= Colour(255,255,255)
Colour.red 		= Colour(255,0,0)
Colour.green 	= Colour(0,255,0)
Colour.blue 	= Colour(0,0,255)

--- Red (0-255)
-- @simplefield r

--- Green (0-255)
-- @simplefield g

--- Blue (0-255)
-- @simplefield b

--- Alpha (0-255)
-- @simplefield a

--- @predefined black

--- @predefined white

--- @predefined red

--- @predefined green

--- @predefined blue

return Colour