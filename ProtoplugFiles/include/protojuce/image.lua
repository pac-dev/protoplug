--- Image.
-- Images can be loaded from a file, or created as temporary graphics targets.
--
-- Is a pointer to a [JUCE Image](http://www.juce.com/api/classImage.html), 
-- and wraps some [JUCE ImageFileFormat](http://www.juce.com/api/classImageFileFormat.html)
-- functionality.
-- @classmod juce.Image

ffi.cdef [[
pImage Image_new();
pImage Image_new2(int pixelFormat, int imageWidth, int imageHeight, bool clearImage);
void Image_delete(pImage i);
bool Image_isValid(pImage i);

pImage ImageFileFormat_loadFrom2(const char *filename);
]]

local Image = setmetatable ({}, {

	--- Load an image from a file.
	-- The path can be absolute or relative to the protoplug directory.
	-- To check if the file was loaded successfully, use @{isValid}.
	-- @param filename
	-- @within Constructors
	-- @constructor
	-- @function Image

	--- Create a temporary in-memory image.
	-- @tparam juce.Image.PixelFormat pixelFormat
	-- @param imageWidth
	-- @param imageHeight
	-- @tparam boolean clearImage fill the image with black
	-- @within Constructors
	-- @constructor
	-- @function Image
	__call = function(self, ...)
		if select("#", ...)==4 then
			return ffi.gc(
				protolib.Image_new2(...), 
				protolib.Image_delete
			)
		else
			return ffi.gc(
				protolib.ImageFileFormat_loadFrom2(...), 
				protolib.Image_delete
			)
		end
	end;
})

local Image_mt = {
	-- methods
	__index = {

		--- Check Image validity.
		-- @treturn boolean whether the image is valid and can be used.
		-- @function isValid
		isValid = function (self)
			return protolib.Image_isValid(self)
		end;
	}
}
ffi.metatype("pImage", Image_mt);

--- Pixel formats.
-- @table juce.Image.PixelFormat
Image.PixelFormat = {
	UnknownFormat = 0;	-- 0
	RGB = 1;			-- 1
	ARGB = 2;			-- 2
	SingleChannel = 3	-- 3
}

return Image