--- Use `script` to handle script events, libraries and files.
-- The `script` global is available to every protoplug script after including the 
-- main protoplug header :
-- 	require "include/protoplug"
-- @module script

local script = {}

--- Add a handler for a script event.
-- The following events are available :
--
-- - `"init"` - Emitted after the script has been compiled and run.
-- - `"preClose"` - Emitted before the script state gets destroyed.
-- @see plugin.addHandler
-- @see gui.addHandler
-- @tparam string event the event to handle
-- @tparam function handler a function to add the event's handlers

function script.addHandler(event, handler)
	if not script[event] then script[event] = {} end
	table.insert(script[event], handler)
end
	
--- Save script data.
-- Override this function to save any custom data.
--
-- This gets called : 
-- - when the host saves the plugin's state (eg. when saving a project)
-- - right before the script is recompiled, to keep custom data across compilations.
-- @treturn string the data to be saved
-- @function script.saveData

--- Load script data.
-- Override this function to load any custom data.
-- Be warned that the data might originate from another script, so it's a good 
-- idea to start the data with a header confirming the format.
--
-- This gets called : 
-- - when the host loads the plugin's state (eg. when loading a project)
-- - right after the script is recompiled, to keep custom data across compilations.
-- @tparam string data the data to be loaded
-- @function script.loadData


--- Load shared libraries.
-- Protoplug scripts should use this wrapper function instead of LuaJIT's 
-- [ffi.load](http://luajit.org/ext_ffi_api.html#ffi_load). 
-- It has the same behaviour as `ffi.load`, but it adds `protoplug/lib` as a 
-- search path, and can accept multiple arguments to test for different 
-- library names. The names are tested from left to right until one load 
-- successfully. If none of them work, an error is raised.
-- 	sdl = script.ffiLoad("sdl")
-- This looks for `libsdl.so` or `sdl.dll` in protoplug's lib folder and 
-- in the system paths. 
--
-- 	fftw = script.ffiLoad("libfftw3.so.3", "libfftw3-3.dll")
-- This looks for the supplied names in the same locations as above. This is 
-- necessary for libs like FFTW, that have has platform-dependent names.
-- @tparam string libName
-- @tparam[opt] string ... alternate names for the same library
-- @return The library's ffi namespace
-- @function script.ffiLoad
local function file_exists(name)
	local f=io.open(name,"r")
	if f~=nil then io.close(f) return true else return false end
end
local function tryLoad(lib)
	if string.find(lib, "/") or string.find(lib, "\\") then
		return ffi.load(lib)
	end
	local libfile = lib
	if ffi.os=="Windows" then
		if not string.find(lib, "%.") then
			libfile = libfile..".dll"
		end
	else -- assuming posix
		if not string.find(lib,"%.") then
			libfile = libfile..".so"
		end
		if string.sub(lib, 1, 3) ~= "lib" then
			libfile = "lib"..libfile
		end
	end
	libfile = protoplug_dir.."/lib/"..libfile
	if file_exists(libfile) then
		return ffi.load(libfile)
	end
	local success, ret = pcall(ffi.load, lib)
	if success then return ret end
end
function script.ffiLoad(...)
	local args={...}
	local ret
	for _,lib in ipairs(args) do
		ret = tryLoad(lib)
		if ret then break end
	end
	return ret and ret or error("could not find library "..
		table.concat({...}, ", "))
end

--- Current protoplug directory.
-- The full path of the `protoplug` directory currently being used. It should 
-- be alongside the protoplug fx and gen dynamic libraries. 
-- @predefined protoplugDir
script.protoplugDir = protoplug_dir

-- Wrap the raw global override called by protoplug
function script_init()
	if script.preClose then
		function script_preClose()
			for _,v in ipairs(script.preClose) do
				v()
			end
		end
	end
	
	if script.init then
		for _,v in ipairs(script.init) do
			v()
		end
	end
	script_saveData = script.saveData
	script_loadData = script.loadData
end

-- add handler to repaint gui after recompiling
script.addHandler("init", function ()
	local gui = require "include/core/gui"
	local guiComp = gui.getComponent()
	if guiComp ~= nil then
		guiComp:repaint()
	end
end)

return script
