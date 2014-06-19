--- A geometric transformation.
-- Is converted to a [JUCE AffineTransform](http://www.juce.com/api/classAffineTransform.html).
--
-- The default constructor makes an `identity` transform, so all kinds of 
-- transformations can be created as follows :
-- 	rot180 = juce.AffineTransform():rotated(math.pi)
-- 	chainey = juce.AffineTransform():scaled(2.5):translated(140,140)
-- @classmod juce.AffineTransform

--- Constuctor.
-- parameters thusly define a transformation matrix :
--
-- 	(mat00 mat01 mat02)
-- 	(mat10 mat11 mat12)
-- 	(0     0     1) 
-- @param mat00
-- @param mat01
-- @param mat02
-- @param mat10
-- @param mat11
-- @param mat12
-- @within Constructors
-- @constructor
-- @function AffineTransform

local AffineTransform = setmetatable({}, {
	__call = function(self, ...)
		if select("#", ...)==0 then
			return ffi.new("AffineTransform", 1,0,0,  0,1,0)
		end
		return ffi.new("AffineTransform", ...)
	end;
})

local AffineTransform_mt = {
	-- methods
	__index = {

		--- Translated.
		-- @param dx the horizontal offset
		-- @param dy the vertical offset
		-- @return a translated version of this transform
		-- @function translated
		translated = function (self, dx, dy)
			return AffineTransform(
				self.mat00, self.mat01, self.mat02 + dx,
				self.mat10, self.mat11, self.mat12 + dy)
		end;

		--- Rotated.
		-- @param rad the degree of rotation in radians
		-- @return a rotated version of this transform
		-- @function rotated
		rotated = function (self, rad)
			local cosRad = math.cos (rad)
			local sinRad = math.sin (rad)
			return AffineTransform(
				cosRad * self.mat00 + -sinRad * self.mat10,
				cosRad * self.mat01 + -sinRad * self.mat11,
				cosRad * self.mat02 + -sinRad * self.mat12,
				sinRad * self.mat00 + cosRad * self.mat10,
				sinRad * self.mat01 + cosRad * self.mat11,
				sinRad * self.mat02 + cosRad * self.mat12)
		end;

		--- Scaled.
		-- @param scaleX
		-- @param[opt=scaleX] scaleY
		-- @return a scaled version of this transform
		-- @function scaled
		scaled = function (self, scaleX, scaleY)
			scaleY = scaleY or scaleX
			return AffineTransform(
				scaleX * self.mat00, scaleX * self.mat01, scaleX * self.mat02,
				scaleY * self.mat10, scaleY * self.mat11, scaleY * self.mat12)
		end;

		--- Followed by.
		-- @param other
		-- @return a version of this transform followed by another
		-- @function followedBy
		followedBy = function (self, other)
			return AffineTransform(
				other.mat00 * self.mat00 + other.mat01 * self.mat10,
				other.mat00 * self.mat01 + other.mat01 * self.mat11,
				other.mat00 * self.mat02 + other.mat01 * self.mat12 + other.mat02,
				other.mat10 * self.mat00 + other.mat11 * self.mat10,
				other.mat10 * self.mat01 + other.mat11 * self.mat11,
				other.mat10 * self.mat02 + other.mat11 * self.mat12 + other.mat12)
		end;
	};
}

ffi.metatype("AffineTransform", AffineTransform_mt)

--- Matrix [0] [0]
-- @simplefield mat00

--- Matrix [0] [1]
-- @simplefield mat01

--- Matrix [0] [2]
-- @simplefield mat02

--- Matrix [1] [0]
-- @simplefield mat10

--- Matrix [1] [1]
-- @simplefield mat11

--- Matrix [1] [2]
-- @simplefield mat12

--- Identity.
-- The non-transform.
-- @predefined juce.AffineTransform.identity

AffineTransform.identity = AffineTransform(1,0,0,  0,1,0)

return AffineTransform