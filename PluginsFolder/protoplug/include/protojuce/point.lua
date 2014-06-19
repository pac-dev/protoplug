--- Point.
-- Is converted to a [JUCE Point](http://www.juce.com/api/classPoint.html)
-- @classmod juce.Point

--- Constuctor
-- @param x
-- @param y
-- @within Constructors
-- @constructor
-- @function Point

--- Constuctor
-- @param args
-- @param args.x
-- @param args.y
-- @within Constructors
-- @constructor
-- @function Point

local Point = ffi.typeof("Point_float")

local Point_mt = {
	-- operator '=='
	__eq = function(self, rhs)
		return	self.x == rhs.x and 
				self.y == rhs.y
	end;
}
ffi.metatype(Point, Point_mt)

--- Point X position
-- @simplefield x

--- Point Y position
-- @simplefield y

return Point