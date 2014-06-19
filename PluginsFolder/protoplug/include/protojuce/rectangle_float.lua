--- A floating-point (sub-pixel) rectangle.
-- Is converted to a [JUCE Rectangle](http://www.juce.com/api/classRectangle.html)
-- @classmod juce.Rectangle_float

--- Constuctor with classical arguments.
-- @param x left position
-- @param y top position
-- @param w width
-- @param h height
-- @within Constructors
-- @constructor
-- @function Rectangle_float

--- Constuctor with named arguments.
-- Every field is optional.
-- @tparam table args
-- @param args.x left position
-- @param args.y top position
-- @param args.w width
-- @param args.h height
-- @within Constructors
-- @constructor
-- @function Rectangle_float

local Rectangle_float = ffi.typeof("Rectangle_float")

local Rectangle_int = {} -- circular dependency technique

local Rectangle_float_mt = {
	-- operator '=='
	__eq = function(self, rhs)
		return	self.x == rhs.x and 
				self.y == rhs.y and
				self.w == rhs.w and
				self.h == rhs.h
	end;
	-- methods
	__index = {
	
		--- To int.
		-- Convert to a pixel-aligned rectangle
		-- @treturn juce.Rectangle_int
		-- @function toInt
		toInt = function (self)
			Rectangle_int = Rectangle_float or require"include/protojuce/rectangle_int"
			return Rectangle_int {
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
ffi.metatype(Rectangle_float, Rectangle_float_mt)

--- Left position
-- @simplefield x

--- Top position
-- @simplefield y

--- Width
-- @simplefield w

--- Height
-- @simplefield h

return Rectangle_float