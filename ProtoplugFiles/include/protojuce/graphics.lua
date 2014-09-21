--- Graphics drawing target.
-- Is a pointer to a [JUCE Graphics](http://www.juce.com/api/classGraphics.html) object.
-- Received in @{gui.paint} as an argument.
-- @classmod juce.Graphics

local script = require "include/core/script"
local util = require"include/luautil"
util.requireCdef(script.protoplugDir.."/include/protojuce/cdef/graphics.h")
local Justification = require"include/protojuce/justification"
local RectanglePlacement = require"include/protojuce/rectangleplacement"
local AffineTransform = require"include/protojuce/affinetransform"
local Path = require"include/protojuce/path"

local Graphics = setmetatable({}, {
	--- Constuct from a @{juce.Image}.
	-- Use this constructor to draw directly onto an @{juce.Image} in memory.
	--
	-- A typical use is to can create a @{juce.Image} object and use it as a 
	-- backbuffer for pre-rendering graphics. 
	-- @tparam juce.Image imageToDrawOnto
	-- @within Constructors
	-- @constructor
	-- @function Graphics
	__call = function (self, imageToDrawOnto)
		return ffi.gc(
			protolib.Graphics_new(imageToDrawOnto), 
			protolib.Graphics_delete)
	end
})

local Graphics_mt = {
	-- methods
	__index = {

		--- Set working colour.
		-- Set the colour to be used for subsequent calls such as @{drawRect} and @{drawText}.
		-- @tparam juce.Colour newColour
		-- @function setColour
		setColour = function (self, newColour)
			protolib.Graphics_setColour(self, newColour)
		end;
			


		--- Set working opacity.
		-- Set the opacity to be used for subsequent calls.
		-- @param newOpacity
		-- @function setOpacity
		setOpacity = function (self, newOpacity)
			protolib.Graphics_setOpacity(self, newOpacity)
		end;



		--- Set working Gradient.
		-- Use a gradient as fill for subsequent calls such as @{fillRect}.
		-- @tparam juce.ColourGradient gradient
		-- @function setGradientFill
		setGradientFill = function (self, gradient)
			protolib.Graphics_setGradientFill(self, gradient)
		end;


		--- Set Tiled Image Fill.
		-- Use a tiled image as fill for subsequent calls such as @{fillRect}.
		-- @tparam juce.Image imageToUse
		-- @param anchorX
		-- @param anchorY
		-- @param opacity
		-- @function setTiledImageFill
		setTiledImageFill = function (self, imageToUse,
									anchorX, anchorY,
									opacity)
			protolib.Graphics_setTiledImageFill(self, imageToUse,
									anchorX, anchorY,
									opacity)
		end;


		--- Set Fill.
		-- @tparam juce.FillType newFill
		-- @function setFillType
		setFillType = function (self, newFill)
			protolib.Graphics_setFillType(self, newFill)
		end;


		--- Set Font.
		-- @tparam juce.Font newFont
		-- @function setFont

		--- Set Font.
		-- @tparam number newFontHeight
		-- @function setFont
		setFont = function (self, newFont)
			if type(newFont) == "number" then -- height
				protolib.Graphics_setFont2(self, newFont)
			else
				protolib.Graphics_setFont(self, newFont)
			end
		end;


		--- Get Current Font.
		-- treturn juce.Font the current font
		-- @function getCurrentFont
		getCurrentFont = function (self)
			local f = protolib.Graphics_getCurrentFont(self)
			f = ffi.gc(f, protolib.Font_delete)
			return f
		end;


		--- Draw single line of text.
		-- @tparam string text
		-- @param startX
		-- @param baselineY
		-- @tparam[opt=Justification.left] juce.Justification justification
		-- @function drawSingleLineText
		drawSingleLineText = function (self, text,
									 startX, baselineY,
									 justification)
			justification = justification or Justification.left
			protolib.Graphics_drawSingleLineText(self, text,
									 startX, baselineY,
									 justification)
		end;


		--- Draw multiline text.
		-- @tparam string text
		-- @param startX
		-- @param baselineY
		-- @param maximumLineWidth
		-- @function drawMultiLineText
		drawMultiLineText = function (self, text,
									startX, baselineY,
									maximumLineWidth)
			protolib.Graphics_drawMultiLineText(self, text,
									startX, baselineY,
									maximumLineWidth)
		end;


		--- Draw text.
		-- @param x
		-- @param y
		-- @param width
		-- @param height
		-- @tparam[opt=Justification.left] juce.Justification justification
		-- @param[opt=false] useEllipsesIfTooBig
		-- @function drawText

		--- Draw text.
		-- @tparam juce.Rectangle_int area
		-- @tparam[opt=Justification.left] juce.Justification justification
		-- @param[opt=false] useEllipsesIfTooBig
		-- @function drawText
		drawText = function (self, text, ...)
			if select('#',...) >= 4 then
				local x, y, width, height, justificationType, useEllipsesIfTooBig = ...
				justificationType = justificationType or Justification.left
				useEllipsesIfTooBig = useEllipsesIfTooBig or false
				protolib.Graphics_drawText(self, text,
							   x, y, width, height,
							   justificationType,
							   useEllipsesIfTooBig)
			else -- Rectangle_int
				local area, justificationType, useEllipsesIfTooBig = ...
				justificationType = justificationType or Justification.left
				useEllipsesIfTooBig = useEllipsesIfTooBig or false
				protolib.Graphics_drawText2(self, text,
							   area,
							   justificationType,
							   useEllipsesIfTooBig)
			end
		end;


		--- Draw fitted text.
		-- Awkwardly squishes the font (up to minimumHorizontalScale) if necessary.
		-- @param x
		-- @param y
		-- @param width
		-- @param height
		-- @tparam juce.Justification justification
		-- @param maximumNumberOfLines
		-- @param[opt=0.7] minimumHorizontalScale
		-- @function drawFittedText

		--- Draw fitted text.
		-- Awkwardly squishes the font (up to minimumHorizontalScale) if necessary.
		-- @tparam juce.Rectangle_int area
		-- @tparam juce.Justification justification
		-- @param maximumNumberOfLines
		-- @param[opt=0.7] minimumHorizontalScale
		-- @function drawFittedText
		drawFittedText = function (self, text, ...)
			if select('#',...) >= 6 then
				local x, y, width, height, justificationFlags, maximumNumberOfLines, minimumHorizontalScale = ...
				minimumHorizontalScale = minimumHorizontalScale or 0.7
				protolib.Graphics_drawFittedText(self, text,
									 x, y, width, height,
									 justificationFlags,
									 maximumNumberOfLines,
									 minimumHorizontalScale)
			else
				local area, justificationFlags, maximumNumberOfLines, minimumHorizontalScale = ...
				minimumHorizontalScale = minimumHorizontalScale or 0.7
				protolib.Graphics_drawFittedText2(self, text,
									 area,
									 justificationFlags,
									 maximumNumberOfLines,
									 minimumHorizontalScale)
			end
		end;
		

		--- Fill the entire graphics target.
		-- @tparam[opt] juce.Colour colourToUse
		-- @function fillAll
		fillAll = function (self, colourToUse)
			if colourToUse then 
				protolib.Graphics_fillAll2(self, colourToUse)
			else
				protolib.Graphics_fillAll(self)
			end
		end;


		--- Fill rectangle with current fill type.
		-- @param x
		-- @param y
		-- @param width
		-- @param height
		-- @function fillRect

		--- Fill rectangle with current fill type.
		-- @tparam juce.Rectangle_int area
		-- @function fillRect
		fillRect = function (self, ...)
			if select('#',...) == 4 then
				local x, y, width, height = ...
				protolib.Graphics_fillRect3(self, x, y, width, height)
			else
				local rectangle = ...
				if ffi.istype("Rectangle_int", rectangle) then
					protolib.Graphics_fillRect(self, rectangle)
				else
					protolib.Graphics_fillRect2(self, rectangle)
				end
			end
		end;


		fillRect_int = function (self, x, y, width, height)
			protolib.Graphics_fillRect3(self, x, y, width, height)
		end;


		--- Fill rectangle (sub-pixel accuracy).
		-- @param x
		-- @param y
		-- @param width
		-- @param height
		-- @function fillRect_float
		fillRect_float = function (self, x, y, width, height)
			protolib.Graphics_fillRect4(self, x, y, width, height)
		end;


		--- Fill rounded rectangle.
		-- @param x
		-- @param y
		-- @param width
		-- @param height
		-- @param cornerSize
		-- @function fillRoundedRectangle

		--- Fill rounded rectangle.
		-- @tparam juce.Rectangle_int area
		-- @param cornerSize
		-- @function fillRoundedRectangle
		fillRoundedRectangle = function (self, ...)
			if select('#',...) == 5 then
				local x, y, width, height, cornerSize = ...
				protolib.Graphics_fillRoundedRectangle(self, x, y, width, height,
										   cornerSize)
			else
				local rectangle, cornerSize = ...
				protolib.Graphics_fillRoundedRectangle2(self, rectangle,
										   cornerSize)
			end
		end;


		--- Fill *chequerboard*.
		-- (and i thought juce used British spelling)
		-- @tparam juce.Rectangle_int area
		-- @param checkWidth
		-- @param checkHeight
		-- @tparam juce.Colour colour1
		-- @tparam juce.Colour colour2
		-- @function fillCheckerBoard
		fillCheckerBoard = function (self, area,
								   checkWidth, checkHeight,
								   colour1, colour2)
			protolib.Graphics_fillCheckerBoard(self, area,
								   checkWidth, checkHeight,
								   colour1, colour2)
		end;


		--- Draw rectangle.
		-- @param x
		-- @param y
		-- @param width
		-- @param height
		-- @param[opt=1] lineThickness
		-- @function drawRect

		--- Draw rectangle.
		-- @tparam juce.Rectangle_int area
		-- @param[opt=1] lineThickness
		-- @function drawRect
		drawRect = function (self, ...)
			if select('#',...) >= 4 then
				local x, y, width, height, lineThickness = ...
				lineThickness = lineThickness or 1
				protolib.Graphics_drawRect(self, x, y, width, height, lineThickness)
			else
				local rectangle, lineThickness = ...
				lineThickness = lineThickness or 1
				protolib.Graphics_drawRect3(self, rectangle, lineThickness)
			end
		end;


		--- Draw rect (sub-pixel accuracy).
		-- @param x
		-- @param y
		-- @param width
		-- @param height
		-- @param[opt=1] lineThickness
		-- @function drawRect_float

		--- Draw rect (sub-pixel accuracy).
		-- @tparam juce.Rectangle_int area
		-- @param[opt=1] lineThickness
		-- @function drawRect_float
		drawRect_float = function (self, ...)
			if select('#',...) >= 4 then
				local x, y, width, height, lineThickness = ...
				lineThickness = lineThickness or 1
				protolib.Graphics_drawRect2(self, x, y, width, height, lineThickness)
			else
				local rectangle, lineThickness = ...
				lineThickness = lineThickness or 1
				protolib.Graphics_drawRect4(self, rectangle, lineThickness)
			end
		end;


		--- Draw rounded rectangle.
		-- @param x
		-- @param y
		-- @param width
		-- @param height
		-- @param cornerSize
		-- @param[opt=1] lineThickness
		-- @function drawRoundedRectangle

		--- Draw rounded rectangle.
		-- @tparam juce.Rectangle_int area
		-- @param cornerSize
		-- @param[opt=1] lineThickness
		-- @function drawRoundedRectangle
		drawRoundedRectangle = function (self, ...)
			if select('#',...) >= 5 then
				local x, y, width, height, cornerSize, lineThickness = ...
				lineThickness = lineThickness or 1
				protolib.Graphics_drawRoundedRectangle(self, x, y, width, height, cornerSize, lineThickness)
			else
				local rectangle, cornerSize, lineThickness = ...
				lineThickness = lineThickness or 1
				protolib.Graphics_drawRoundedRectangle2(self, rectangle, cornerSize, lineThickness)
			end
		end;


		--- Set pixel with current colour.
		-- @param x
		-- @param y
		-- @function setPixel
		setPixel = function (self, x, y)
			protolib.Graphics_setPixel(self, x, y)
		end;


		--- Fill ellipse with current fill.
		-- @param x
		-- @param y
		-- @param width
		-- @param height
		-- @function fillEllipse
		fillEllipse = function (self, ...)
			if select('#',...) == 4 then
				local x, y, width, height = ...
				protolib.Graphics_fillEllipse(self, x, y, width, height)
			else
				local area = ...
				protolib.Graphics_fillEllipse2(self, area)
			end
		end;


		--- Draw ellipse with current colour.
		-- @param x
		-- @param y
		-- @param width
		-- @param height
		-- @param[opt=1] lineThickness
		-- @function drawEllipse
		drawEllipse = function (self, x, y, width, height,
							  lineThickness)
			lineThickness = lineThickness or 1
			protolib.Graphics_drawEllipse(self, x, y, width, height,
							  lineThickness)
		end;


		--- Draw line.
		-- @param startX
		-- @param startY
		-- @param endX
		-- @param endY
		-- @param[opt=1] lineThickness
		-- @function drawLine

		--- Draw line.
		-- @tparam juce.Line line
		-- @param[opt=1] lineThickness
		-- @function drawLine
		drawLine = function (self, ...)
			if select('#',...) == 4 then
				local startX, startY, endX, endY = ...
				protolib.Graphics_drawLine(self, startX, startY, endX, endY)
			elseif select('#',...) == 5 then
				local startX, startY, endX, endY, lineThickness = ...
				protolib.Graphics_drawLine2(self, startX, startY, endX, endY, lineThickness)
			elseif select('#',...) == 1 then
				local line = ...
				protolib.Graphics_drawLine3(self, line)
			else
				local line, lineThickness = ...
				protolib.Graphics_drawLine4(self, line, lineThickness)
			end
		end;


		--- Draw dashed line.
		-- @tparam juce.Line line
		-- @param dashLengths (const float* ctype)
		-- @param numDashLengths
		-- @param[opt=1] lineThickness
		-- @param[opt=0] dashIndexToStartFrom
		-- @function drawDashedLine
		drawDashedLine = function (self, line,
								 dashLengths, numDashLengths,
								 lineThickness,
								 dashIndexToStartFrom)
			lineThickness = lineThickness or 1
			dashIndexToStartFrom = dashIndexToStartFrom or 0
			protolib.Graphics_drawDashedLine(self, line,
								 dashLengths, numDashLengths,
								 lineThickness,
								 dashIndexToStartFrom)
		end;


		--- Draw vertical line.
		-- @param x
		-- @param top
		-- @param bottom
		-- @function drawVerticalLine
		drawVerticalLine = function (self, x, top, bottom)
			protolib.Graphics_drawVerticalLine(self, x, top, bottom)
		end;


		--- Draw horizontal line.
		-- @param y
		-- @param left
		-- @param right
		-- @function drawHorizontalLine
		drawHorizontalLine = function (self, y, left, right)
			protolib.Graphics_drawHorizontalLine(self, y, left, right)
		end;


		--- Fill path.
		-- @tparam juce.Path path
		-- @tparam[opt=juce.AffineTransform.identity] juce.AffineTransform transform
		-- @function fillPath
		fillPath = function (self, path,
						   transform)
			transform = transform or AffineTransform.identity
			protolib.Graphics_fillPath(self, path,
						   transform)
		end;


		--- Stroke path.
		-- All named arguments are optional
		-- @tparam juce.Path path
		-- @param[opt] args
		-- @param args.thickness
		-- @tparam juce.Path.JointStyle args.jointStyle *default* : juce.Path.JointStyle.mitered
		-- @tparam juce.Path.EndCapStyle args.endCapStyle *default* : juce.Path.EndCapStyle.butt
		-- @tparam juce.AffineTransform args.transform *default* : juce.AffineTransform.identity
		-- @function strokePath
		strokePath = function (self, path, args)
			args = args or {}
			args.thickness = args.thickness or 1
			args.jointStyle = args.jointStyle or Path.JointStyle.mitered
			args.endCapStyle = args.endCapStyle or Path.EndCapStyle.butt
			args.transform = args.transform or AffineTransform.identity
			local strokeType = ffi.new("PathStrokeType", args.thickness, args.jointStyle, args.endCapStyle)
			protolib.Graphics_strokePath(self, path,
							 strokeType,
							 args.transform)
		end;


		--- Draw arrow.
		-- @tparam juce.Line line
		-- @param lineThickness
		-- @param arrowheadWidth
		-- @param arrowheadLength
		-- @function drawArrow
		drawArrow = function (self, line,
							lineThickness,
							arrowheadWidth,
							arrowheadLength)
			protolib.Graphics_drawArrow(self, line,
							lineThickness,
							arrowheadWidth,
							arrowheadLength)
		end;


		--- Set image resampling quality.
		-- @tparam juce.Graphics.ResamplingQuality newQuality
		-- @function setImageResamplingQuality
		setImageResamplingQuality = function (self, newQuality)
			protolib.Graphics_setImageResamplingQuality(self, newQuality)
		end;


		--- Draw unscaled image at location.
		-- @tparam juce.Image imageToDraw
		-- @param topLeftX
		-- @param topLeftY
		-- @param[opt=false] fillAlphaChannelWithCurrentBrush
		-- @function drawImageAt
		drawImageAt = function (self, imageToDraw, topLeftX, topLeftY,
							  fillAlphaChannelWithCurrentBrush)
			fillAlphaChannelWithCurrentBrush = fillAlphaChannelWithCurrentBrush or false
			protolib.Graphics_drawImageAt(self, imageToDraw, topLeftX, topLeftY,
							  fillAlphaChannelWithCurrentBrush)
		end;


		--- Draw a portion of an image, stretched into a target rectangle.
		-- @tparam juce.Image imageToDraw
		-- @param destX
		-- @param destY
		-- @param destWidth
		-- @param destHeight
		-- @param sourceX
		-- @param sourceY
		-- @param sourceWidth
		-- @param sourceHeight
		-- @param[opt=false] fillAlphaChannelWithCurrentBrush
		-- @function drawImage
		drawImage = function (self, imageToDraw,
							destX, destY, destWidth, destHeight,
							sourceX, sourceY, sourceWidth, sourceHeight,
							fillAlphaChannelWithCurrentBrush)
			fillAlphaChannelWithCurrentBrush = fillAlphaChannelWithCurrentBrush or false
			protolib.Graphics_drawImage(self, imageToDraw,
							destX, destY, destWidth, destHeight,
							sourceX, sourceY, sourceWidth, sourceHeight,
							fillAlphaChannelWithCurrentBrush)
		end;


		--- Draw transformed image.
		-- @tparam juce.Image imageToDraw
		-- @tparam juce.AffineTransform transform
		-- @param[opt=false] fillAlphaChannelWithCurrentBrush
		-- @function drawImageTransformed
		drawImageTransformed = function (self, imageToDraw,
									   transform,
									   fillAlphaChannelWithCurrentBrush)
			fillAlphaChannelWithCurrentBrush = fillAlphaChannelWithCurrentBrush or false
			protolib.Graphics_drawImageTransformed(self, imageToDraw,
									   transform,
									   fillAlphaChannelWithCurrentBrush)
		end;


		--- Draw image within.
		-- @tparam juce.Image imageToDraw
		-- @param destX
		-- @param destY
		-- @param destWidth
		-- @param destHeight
		-- @param[opt=juce.RectanglePlacement.centred] placementWithinTarget
		-- @param[opt=false] fillAlphaChannelWithCurrentBrush
		-- @function drawImageWithin
		drawImageWithin = function (self, imageToDraw,
								  destX, destY, destWidth, destHeight,
								  placementWithinTarget,
								  fillAlphaChannelWithCurrentBrush)
			fillAlphaChannelWithCurrentBrush = fillAlphaChannelWithCurrentBrush or false
			placementWithinTarget = placementWithinTarget or RectanglePlacement.centred
			protolib.Graphics_drawImageWithin(self, imageToDraw,
								  destX, destY, destWidth, destHeight,
								  placementWithinTarget,
								  fillAlphaChannelWithCurrentBrush)
		end;


		--- Get clip bounds.
		-- Get the portion of the graphics target that needs to be redrawn.
		-- @treturn juce.Rectangle_int Clipping area
		-- @function getClipBounds
		getClipBounds = function (self)
			return protolib.Graphics_getClipBounds(self)
		end;


		--- Clip region intersects.
		-- Check if a rectangle intersects with the redrawing region
		-- @treturn juce.Rectangle_int Clipping area
		-- @treturn boolean intersection check
		-- @function clipRegionIntersects
		clipRegionIntersects = function (self, area)
			return protolib.Graphics_clipRegionIntersects(self, area)
		end;


		reduceClipRegion = function (self, ...)
			local control = select(1, ...)
			if type(control)=="number" then
				local x, y, width, height = ...
				return protolib.Graphics_reduceClipRegion(self, x, y, width, height)
			elseif ffi.istype("Rectangle_int", control) then
				local area = ...
				return protolib.Graphics_reduceClipRegion2(self, area)
			elseif ffi.istype("pPath", control) then
				local path, transform = ...
				transform = transform or AffineTransform.identity
				return protolib.Graphics_reduceClipRegion4(self, path, transform)
			else -- pImage
				local image, transform = ...
				return protolib.Graphics_reduceClipRegion5(self, image, transform)
			end
		end;


		excludeClipRegion = function (self, rectangleToExclude)
			protolib.Graphics_excludeClipRegion(self, rectangleToExclude)
		end;


		--- Is clipping region empty.
		-- @treturn boolean whether the redrawing area is empty
		-- @function isClipEmpty
		isClipEmpty = function (self)
			return protolib.Graphics_isClipEmpty(self)
		end;


		--- Save state.
		-- Saves the current state of the graphics target on a stack. 
		-- This does not save the actual graphic's contents but its current 
		-- colour, transform, origin, etc.
		-- @function saveState
		saveState = function (self)
			protolib.Graphics_saveState(self)
		end;


		--- Restore state.
		-- Restores a state of the graphics target from the stack.
		-- Useful to cancel any previous uses 
		-- of @{addTransform}, @{setColour}, etc.
		-- @function restoreState
		restoreState = function (self)
			protolib.Graphics_restoreState(self)
		end;


		--- Begin transparency layer.
		-- Saves the current state and begins drawing on a temporary layer, 
		-- to be applied with the specified final transparency.
		-- @function beginTransparencyLayer
		beginTransparencyLayer = function (self, layerOpacity)
			protolib.Graphics_beginTransparencyLayer(self, layerOpacity)
		end;


		--- End transparency layer.
		-- Applies the transparency layer that was started with @{beginTransparencyLayer}.
		-- @function endTransparencyLayer
		endTransparencyLayer = function (self)
			protolib.Graphics_endTransparencyLayer(self)
		end;


		--no
		-- Set origin. tparam juce.Point newOrigin function setOrigin

		--- Set origin.
		-- @param newOriginX
		-- @param newOriginY
		-- @function setOrigin
		setOrigin = function (self, ...)
			if select("#", ...) == 1 then
				protolib.Graphics_setOrigin(self, ...)
			else
				protolib.Graphics_setOrigin2(self, ...)
			end
		end;


		--- Add a transformation matrix.
		-- The matrix will be chained onto the current one, and affect all 
		-- subsequent graphics operations. Use @{saveState} and @{restoreState} 
		-- to apply a temporary transform.
		-- @tparam juce.AffineTransform transform
		-- @function addTransform
		addTransform = function (self, transform)
			protolib.Graphics_addTransform(self, transform)
		end;


		--- Reset to default state.
		-- @function resetToDefaultState
		resetToDefaultState = function (self)
			protolib.Graphics_resetToDefaultState(self)
		end;


		--- Is vector device.
		-- @treturn boolean whether the target is a vector device.
		-- @function isVectorDevice
		isVectorDevice = function (self)
			return protolib.Graphics_isVectorDevice(self)
		end;
	}
}

--- Resampling qualities.
-- @table juce.Graphics.ResamplingQuality
Graphics.ResamplingQuality =  
{
	low     = 0;
	medium  = 1;
	high    = 2
};

ffi.metatype("pGraphics", Graphics_mt);

return Graphics