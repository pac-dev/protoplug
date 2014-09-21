-- protojuce.lua
-- a GUI module for protoplug that wraps some JUCE features

local util = require"include/luautil"
local script = require "include/core/script"

-- module
local J = {}

-- todo relative, wat ?
util.requireCdef(script.protoplugDir.."/include/protojuce/cdef/typedefs.h")

J.AudioFormatReader	= require"include/protojuce/audioformatreader"
J.LagrangeInterpolator= require"include/protojuce/lagrangeinterpolator"
J.Colour 			= require"include/protojuce/colour"
J.Path 				= require"include/protojuce/path"
J.Graphics 			= require"include/protojuce/graphics"
J.ColourGradient 	= require"include/protojuce/colourgradient"
J.FillType 			= require"include/protojuce/filltype"
J.Font 				= require"include/protojuce/font"
J.Component 		= require"include/protojuce/component"
J.AffineTransform 	= require"include/protojuce/affinetransform"
J.Rectangle_int 	= require"include/protojuce/rectangle_int"
J.Rectangle_float 	= require"include/protojuce/rectangle_float"
J.RectanglePlacement= require"include/protojuce/rectangleplacement"
J.Image 			= require"include/protojuce/image"
J.Justification		= require"include/protojuce/justification"
J.Point		 		= require"include/protojuce/point"
J.Line		 		= require"include/protojuce/line"

return J
