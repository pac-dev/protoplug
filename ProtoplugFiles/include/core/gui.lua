--- Use `gui` to define your script's custom graphical user interface.
-- Custom GUI example : @{sinemouse-demo.lua}
--
-- The `gui` global is available to every protoplug script after including the 
-- main protoplug header :
-- 	require "include/protoplug"
-- @module gui

local gui = {}

--- Focus change causes.
-- Values received by the `focusGained` and `focusLost` handlers.
-- @see gui.addHandler
-- @table FocusCause
gui.FocusCause =  
{
	focusChangedByMouseClick 	= 0; -- 0
	focusChangedByTabKey 		= 1; -- 1
	focusChangedDirectly 		= 2; -- 2
};

--- Keyboard and mouse modifiers.
-- Contained in every @{gui.MouseEvent} and received by the 
-- `modifierKeysChanged` handler.
-- @table ModifierKeys
gui.ModifierKeys = 
{
	noModifiers                             = 0; -- 0
	shiftModifier                           = 1; -- 1
	ctrlModifier                            = 2; -- 2
	altModifier                             = 4; -- 4
	leftButtonModifier                      = 16; -- 16
	rightButtonModifier                     = 32; -- 32
	middleButtonModifier                    = 64; -- 64
	commandModifier                         = 8; -- 8
	ctrlAltCommandModifiers                 = 14; -- 14
};

local script = require "include/core/script"

--[[--- Add a handler for a GUI event.

Here's a list of the events and their parameters, showing how they 
should be received :
	gui.addHandler("resized", 				function() ... end)
	gui.addHandler("focusGained", 			function(focusCause) ... end)
	gui.addHandler("focusLost", 			function(focusCause) ... end)
	gui.addHandler("modifierKeysChanged", 	function(modifierKeys) ... end)
	gui.addHandler("mouseMove", 			function(mouseEvent) ... end)
	gui.addHandler("mouseEnter", 			function(mouseEvent) ... end)
	gui.addHandler("mouseExit", 			function(mouseEvent) ... end)
	gui.addHandler("mouseDown", 			function(mouseEvent) ... end)
	gui.addHandler("mouseDrag", 			function(mouseEvent) ... end)
	gui.addHandler("mouseUp", 				function(mouseEvent) ... end)
	gui.addHandler("mouseDoubleClick", 		function(mouseEvent) ... end)
	gui.addHandler("mouseWheelMove", 		function(mouseEvent, mouseWheelDetails) ... end)
	gui.addHandler("keyPressed", 			function(keyPress, srcComponent) ... end)
	gui.addHandler("keyStateChanged", 		function(keyPress, srcComponent) ... end)
Parameters received by the event handlers are of 
type @{FocusCause}, @{ModifierKeys}, @{MouseEvent}, @{MouseWheelDetails}, 
and @{KeyPress}.

@see script.addHandler
@see plugin.addHandler
@tparam string event the event to handle
@tparam function handler a function to add the event's handlers
--]]
function gui.addHandler(event, handler)
	if not gui[event] then gui[event] = {} end
	table.insert(gui[event], handler)
end

-- assumes handler existence already checked
local function gui_emit(event, ...)
	for _,v in ipairs(gui[event]) do
		v(...)
	end
end

-- returns nil if no handler (prevents useless definitions)
local function gui_getEmitter(event)
	if not gui[event] then return end
	return function (...)
		gui_emit(event, ...)
	end
end

script.addHandler("init", function ()

	--- Override to paint a custom GUI.
	-- Define this function to paint something in the custom GUI space.
	-- @tparam juce.Graphics g a JUCE graphics target
	-- @function gui.paint
	if type(gui.paint) == "function" then
		function gui_paint(g)
			g = ffi.typeof("pGraphics")(g)
			gui.paint(g)
		end
	end
	
	gui_resized = gui_getEmitter("resized")
	gui_focusGained = gui_getEmitter("focusGained")
	gui_focusLost = gui_getEmitter("focusLost")
	gui_modifierKeysChanged = gui_getEmitter("modifierKeysChanged")
	
	
	-- event overrides with ffi conversion
	if gui.mouseMove then 
		function gui_mouseMove(event)
			event = ffi.typeof("MouseEvent*")(event)
			gui_emit("mouseMove",event)
		end
	end
	
	if gui.mouseEnter then 
		function gui_mouseEnter(event)
			event = ffi.typeof("MouseEvent*")(event)
			gui_emit("mouseEnter", event)
		end
	end
	
	if gui.mouseExit then 
		function gui_mouseExit(event)
			event = ffi.typeof("MouseEvent*")(event)
			gui_emit("mouseExit", event)
		end
	end
	
	if gui.mouseDown then 
		function gui_mouseDown(event)
			event = ffi.typeof("MouseEvent*")(event)
			gui_emit("mouseDown", event)
		end
	end
	
	if gui.mouseDrag then 
		function gui_mouseDrag(event)
			event = ffi.typeof("MouseEvent*")(event)
			gui_emit("mouseDrag", event)
		end
	end
	
	if gui.mouseUp then 
		function gui_mouseUp(event)
			event = ffi.typeof("MouseEvent*")(event)
			gui_emit("mouseUp", event)
		end
	end
	
	if gui.mouseDoubleClick then 
		function gui_mouseDoubleClick(event)
			event = ffi.typeof("MouseEvent*")(event)
			gui_emit("mouseDoubleClick", event)
		end
	end
	
	if gui.mouseWheelMove then 
		function gui_mouseWheelMove(event, wheel)
			event = ffi.typeof("MouseEvent*")(event)
			wheel = ffi.typeof("MouseWheelDetails*")(wheel)
			gui_emit("mouseWheelMove", event, wheel)
		end
	end
	
	if gui.keyPressed then 
		function gui_keyPressed(key, component)
			key = ffi.typeof("KeyPress*")(key)
			component = ffi.typeof("pComponent")(component)
			gui_emit("keyPressed", key, component)
			return true
		end
	end
	
	if gui.keyStateChanged then 
		function gui_keyStateChanged(isKeyDown, component)
			component = ffi.typeof("pComponent")(component)
			gui_emit("keyStateChanged", isKeyDown, component)
			return true
		end
	end
end)


gui.ppcomponent = ffi.typeof("pComponent*")(gui_component)

--- Get GUI Component.
-- @return the current GUI component, or `nil` if the GUI
-- has not been opened yet.
	
function gui.getComponent()
	if gui.ppcomponent[0].pointer~=nil then
		return gui.ppcomponent[0]
	end
end


--- Mouse Event.
-- A mouse event as received by GUI handlers (see @{gui.addHandler})
-- <br><br>
-- @type gui.MouseEvent

--- X.
-- @field MouseEvent.x

--- Y.
-- @field MouseEvent.y

--- Modifier keys.
-- Values defined in @{gui.ModifierKeys}
-- @field MouseEvent.mods

--- Event component.
-- @field MouseEvent.eventComponent

--- Original component.
-- @field MouseEvent.originalComponent

--- Time.
-- @field MouseEvent.eventTime

--- Mouse down time.
-- @field MouseEvent.mouseDownTime

--- Mouse down position.
-- @field MouseEvent.mouseDownPos

--- Number of clicks.
-- @field MouseEvent.numberOfClicks

--- Was moved since mouse down.
-- @field MouseEvent.wasMovedSinceMouseDown


--- Mouse Wheel Details.
-- As received by the `mouseWheelMove` handler (see @{gui.addHandler})
-- <br><br>
-- @type gui.MouseWheelDetails

--- X delta.
-- @field MouseWheelDetails.deltaX

--- Y delta.
-- @field MouseWheelDetails.deltaY

--- Is reversed.
-- @field MouseWheelDetails.isReversed

--- Is smooth.
-- @field MouseWheelDetails.isSmooth


--- Key Press.
-- As received by the `keyPressed` and `keyStateChanged` handlers (see @{gui.addHandler})
-- <br><br>
-- @type gui.KeyPress

--- Key code.
-- (undecipherable for now)
-- @field KeyPress.keyCode

--- Modifier Keys.
-- @field KeyPress.mods

--- Text character.
-- @field KeyPress.textCharacter


return gui