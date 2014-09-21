--- Line.
-- Is converted to a [JUCE Line](http://www.juce.com/api/classLine.html)
-- @classmod juce.Line

--- Constuctor
-- @param x1
-- @param y1
-- @param x2
-- @param y2
-- @within Constructors
-- @constructor
-- @function Line

--- Constuctor
-- @param args
-- @param args.x1
-- @param args.y1
-- @param args.x2
-- @param args.y2
-- @within Constructors
-- @constructor
-- @function Line

local Line = ffi.typeof("Line_float")

local Line_mt = {
	-- operator '=='
	__eq = function(self, rhs)
		return	self.x1 == rhs.x1 and 
				self.y1 == rhs.y1 and
				self.x2 == rhs.x2 and
				self.y2 == rhs.y2
	end;
}
ffi.metatype(Line, Line_mt)


--- Point 1 X position
-- @simplefield x1

--- Point 1 Y position
-- @simplefield y1

--- Point 2 X position
-- @simplefield x2

--- Point 2 Y position
-- @simplefield y2

return Line