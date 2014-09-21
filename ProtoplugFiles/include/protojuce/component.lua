--- JUCE Component.
-- Is a pointer to a [JUCE Component](http://www.juce.com/api/classComponent.html)
--
-- As of now, components can't be created by protoplug scripts. This is mainly 
-- for accessing the custom GUI component using @{gui.getComponent}.
-- @classmod juce.Component

ffi.cdef [[
void Component_repaint(pComponent self);
void Component_repaint2(pComponent self, int x, int y, int width, int height);
void Component_repaint3(pComponent self, Rectangle_int area);
pImage Component_createComponentSnapshot (pComponent self, 
												Rectangle_int areaToGrab,
												bool clipImageToComponentBounds,
												float scaleFactor);
]]

local Component_mt = {
	-- methods
	__index = {

		--- Request total repaint.
		-- Tell the operating system that the component is "dirty" and needs to be redrawn.
		-- The component's paint method will be called asynchronously (@{gui.paint})
		-- @function repaint

		--- Request partial repaint.
		-- Tell the operating system that a portion of the component is "dirty" and needs to be redrawn.
		-- The component's paint method will be called asynchronously (@{gui.paint}). The dirty region will be accessible
		-- with Graphics.getClipBounds().
		-- @tparam juce.Rectangle_int area the region needing the be redrawn
		-- @function repaint

		--- Request partial repaint.
		-- Tell the operating system that a portion of the component is "dirty" and needs to be redrawn.
		-- The component's paint method will be called asynchronously (@{gui.paint}). The dirty region will be accessible
		-- with Graphics.getClipBounds().
		-- @param x the region needing the be redrawn
		-- @param y the region needing the be redrawn
		-- @param width the region needing the be redrawn
		-- @param height the region needing the be redrawn
		-- @function repaint
		
		repaint = function (self, ...)
			if select("#", ...) == 4 then
				protolib.Component_repaint2(self, ...)
			elseif select("#", ...) == 1 then
				protolib.Component_repaint3(self, ...)
			else
				protolib.Component_repaint(self)
			end
		end;

		--- Create component snapshot.
		-- Paint the component into a virtual buffer and return it as an image.
		-- @tparam juce.Rectangle_int areaToGrab the region to the be drawn
		-- @param[opt=true] clipImageToComponentBounds
		-- @param[opt=1] scaleFactor
		-- @treturn juce.Image
		-- @function createComponentSnapshot
		
		createComponentSnapshot = function (self, areaToGrab, clipImageToComponentBounds, scaleFactor)
			clipImageToComponentBounds = clipImageToComponentBounds or true
			scaleFactor = scaleFactor or 1
			local i = protolib.Component_createComponentSnapshot(self, areaToGrab, clipImageToComponentBounds, scaleFactor)
			i = ffi.gc(i, protolib.Image_delete)
			return i
		end
	}
}
ffi.metatype("pComponent", Component_mt)

return {}