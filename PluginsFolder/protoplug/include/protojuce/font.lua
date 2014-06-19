--- Font.
-- Is a pointer to a [JUCE Font](http://www.juce.com/api/classFont.html).
-- Can be used by @{juce.Graphics} for text operations.
-- @classmod juce.Font

ffi.cdef [[
pFont Font_new(const char *typefaceName, float fontHeight, int styleFlags, bool hinted);
void Font_delete(pFont f);
]]

--- Constuctor.
-- Caveat : on OSX and Linux, hinting only works for protoplug's
-- built-in hinted fonts (`DejaVu Sans Mono` and `Source Code Pro`). On 
-- Windows it's available for every font. Cross-platform hinting is on the be 
-- todo list.
-- @tparam string typefaceName
-- @tparam number fontHeight
-- @param[opt=0] styleFlags any combination of @{styles}
-- @tparam[opt=false] bool hinted
-- @within Constructors
-- @constructor
-- @function Font
local Font = setmetatable({}, {
	__call = function (self, typefaceName, fontHeight, styleFlags, hinted)
		styleFlags = styleFlags or 0
		hinted = hinted or false;
		return ffi.gc(
			protolib.Font_new(typefaceName, fontHeight, styleFlags, hinted), 
			protolib.Font_delete
		)
	end
})

--- Font styles.
-- @table juce.Font.styles
Font.styles = {
	plain       = 0, -- `0`
	bold        = 1, -- `1`
	italic      = 2, -- `2`
	underlined  = 4 -- `4`
}

return Font