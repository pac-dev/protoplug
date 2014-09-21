--- An integer (pixel-aligned) rectangle.
-- Is converted to a [JUCE Rectangle](http://www.juce.com/api/classRectangle.html)
-- @classmod juce.Rectangle_int

--- Constuctor with classical arguments.
-- @param x left position
-- @param y top position
-- @param w width
-- @param h height
-- @within Constructors
-- @constructor
-- @function Rectangle_int

--- Constuctor with named arguments.
-- Every field is optional.
-- @tparam table args
-- @param args.x left position
-- @param args.y top position
-- @param args.w width
-- @param args.h height
-- @within Constructors
-- @constructor
-- @function Rectangle_int

local Rectangle_int = ffi.typeof("Rectangle_int")

local Rectangle_float = {} -- circular dependency technique

local Rectangle_int_mt = {
	-- operator '=='
	__eq = function(self, rhs)
		return	self.x == rhs.x and 
				self.y == rhs.y and
				self.w == rhs.w and
				self.h == rhs.h
	end;
	-- methods
	__index = {
	
		--- To float.
		-- Convert to a sub-pixel rectangle
		-- @treturn juce.Rectangle_float
		-- @function toFloat
		toFloat = function (self)
			Rectangle_float = Rectangle_float or require"include/protojuce/rectangle_float"
			return Rectangle_float {
				self.x, self.y, self.w, self.h
			}
		end;
	
		--- Contains.
		-- @tparam juce.Point point
		-- @treturn boolean whether the rectangle contains the point
		-- @function contains
		contains = function (self, p)
			return 	p.x>=self.x and p.x<=(self.x+self.w) and 
					p.y>=self.y and p.y<=(self.y+self.h)
		end;
	
		--- Get right.
		-- @return the rectangle's right position on the X axis
		-- @function getR
		getR = function (self)
			return self.x + self.w
		end;
	
		--- Get bottom.
		-- @return the rectangle's bottom position on the Y axis
		-- @function getB
		getB = function (self)
			return self.y + self.h
		end;
	};
}
ffi.metatype(Rectangle_int, Rectangle_int_mt)

--- Left position
-- @simplefield x

--- Top position
-- @simplefield y

--- Width
-- @simplefield w

--- Height
-- @simplefield h

return Rectangle_int