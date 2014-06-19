--- Colour Gradient.
-- Is a pointer to a [JUCE ColourGradient](http://www.juce.com/api/classColourGradient.html)
-- @classmod juce.ColourGradient

ffi.cdef [[
pColourGradient ColourGradient_new (Colour c1, float x1, float y1, Colour c2, float x2, float y2, bool isRadial);
void ColourGradient_delete (pColourGradient c);

int ColourGradient_addColour (pColourGradient self, double proportionAlongGradient,
                   Colour colour);
void ColourGradient_removeColour (pColourGradient self, int index);
void ColourGradient_multiplyOpacity (pColourGradient self, float multiplier);
int ColourGradient_getNumColours(pColourGradient self);
Colour ColourGradient_getColour (pColourGradient self, int index);
void ColourGradient_setColour (pColourGradient self, int index, Colour newColour);
Colour ColourGradient_getColourAtPosition (pColourGradient self, double position);
]]

--- Constuctor.
-- @tparam juce.Colour colour1 colour at the beginning of the gradient
-- @param x1 coordinates of colour1
-- @param y1 coordinates of colour1
-- @tparam juce.Colour colour2 colour at the end of the gradient
-- @param x2 coordinates of colour2
-- @param y2 coordinates of colour2
-- @tparam boolean isRadial whether the gradient should be linear or radial
-- @within Constructors
-- @constructor
-- @function Colour

local function ColourGradient(colour1, x1, y1, colour2, x2, y2, isRadial)
	return ffi.gc(
		protolib.ColourGradient_new(colour1, x1, y1, colour2, x2, y2, isRadial), 
		protolib.ColourGradient_delete
	)
end

local ColourGradient_mt = {
	-- methods
	__index = {

		--- Add colour.
		-- Any number of colours can be added between the start and end of the gradient.
		-- @param proportionAlongGradient
		-- @tparam juce.Colour colour
		-- @return the new colour's index
		-- @function addColour
		addColour = function (self, proportionAlongGradient, colour)
			return protolib.ColourGradient_addColour (self, proportionAlongGradient, colour)
		end;

		--- Remove colour.
		-- @param index colour index between 0 and getNumColours() - 1
		-- @function removeColour
		removeColour = function (self, index)
			protolib.ColourGradient_removeColour (self, index)
		end;

		--- Multiply opacity.
		-- @param multiplier factor to multiply the alpha values by
		-- @function multiplyOpacity
		multiplyOpacity = function (self, multiplier)
			protolib.ColourGradient_multiplyOpacity (self, multiplier)
		end;

		--- Get number colour.
		-- @return the number of colours
		-- @function getNumColours
		getNumColours = function (self)
			return protolib.ColourGradient_getNumColours(self)
		end;

		--- Get colour.
		-- @param index colour index between 0 and getNumColours() - 1
		-- @treturn juce.Colour the coulour at the specified index
		-- @function getColour
		getColour = function (self, index)
			return protolib.ColourGradient_getColour (self, index)
		end;

		--- Get colour.
		-- @param index colour index between 0 and getNumColours() - 1
		-- @tparam juce.Colour newColour
		-- @function setColour
		setColour = function (self, index, newColour)
			protolib.ColourGradient_setColour (self, index, newColour)
		end;

		--- Get interpolated colour
		-- @param position the position between 0 and 1
		-- @treturn juce.Colour the interpolated colour at the specified position
		-- @function getColourAtPosition
		getColourAtPosition = function (self, position)
			return protolib.ColourGradient_getColourAtPosition (self, position)
		end;
	};
}

ffi.metatype("pColourGradient", ColourGradient_mt)

return ColourGradient