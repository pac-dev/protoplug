--- Path.
-- Is a pointer to a [JUCE Path](http://www.juce.com/api/classPath.html).
-- @classmod juce.Path

local script = require "include/core/script"
local Point = require"include/protojuce/point"
local AffineTransform = require"include/protojuce/affinetransform"
local util = require"include/luautil"
util.requireCdef(script.protoplugDir.."/include/protojuce/cdef/path.h")

--- Constuctor
-- @within Constructors
-- @constructor
-- @function Path

local Path_mt = {
	-- methods
	__index = {

		--- Get bounds.
		-- @treturn Rectangle_float rectangle containing the path
		-- @function getBounds
		getBounds = function (self)
			return protolib.Path_getBounds(self)
		end;

		--- Get bounds transformed.
		-- @tparam juce.AffineTransform transform
		-- @treturn Rectangle_float rectangle containing the transformed path
		-- @function getBoundsTransformed
		getBoundsTransformed = function (self, transform)
			return protolib.Path_getBoundsTransformed (self, transform)
		end;

		--- Contains.
		-- @param pointX
		-- @param pointY
		-- @param[opt=1] tolerance
		-- @treturn boolean whether the path contains the point
		-- @see closeSubPath
		-- @function contains

		--- Contains.
		-- @tparam juce.Point point
		-- @param[opt=1] tolerance
		-- @treturn boolean whether the path contains the point
		-- @see closeSubPath
		-- @function contains
		contains = function (self, ...)
			local control = ...
			tolerance = tolerance or 1
			if type(control)=="number" then
				return protolib.Path_contains (self, ...)
			else
				return protolib.Path_contains2 (self, ...)
			end
		end;

		--- Intersects line.
		-- @tparam juce.Line line
		-- @param[opt=1] tolerance
		-- @treturn boolean whether the path intersects the line
		-- @function intersectsLine
		intersectsLine = function (self, line, tolerance)
			tolerance = tolerance or 1
			return protolib.Path_intersectsLine (self, line, tolerance)
		end;

		--- Get clipped line.
		-- @tparam juce.Line line
		-- @tparam boolean keepSectionOutsidePath
		-- @treturn juce.Line_float the line clipped by the path 
		-- @function getClippedLine
		getClippedLine = function (self, line, keepSectionOutsidePath)
			return protolib.Path_getClippedLine (self, line, keepSectionOutsidePath)
		end;

		--- Get length.
		-- @tparam[opt=juce.AffineTransform.identity] juce.AffineTransform transform
		-- @return length of the path
		-- @function getLength
		getLength = function (self, transform)
			transform = transform or AffineTransform.identity
			return protolib.Path_getLength (self, transform)
		end;

		--- Get point along path.
		-- @param distanceFromStart
		-- @tparam[opt=juce.AffineTransform.identity] juce.AffineTransform transform
		-- @treturn Point_float the point on the path
		-- @function getPointAlongPath
		getPointAlongPath = function (self, distanceFromStart, transform)
			transform = transform or AffineTransform.identity
			return protolib.Path_getPointAlongPath (self, distanceFromStart, transform)
		end;

		--- Get nearest point.
		-- Get the nearest on-path point to an arbitrary point, and 
		-- the distance between the points
		-- @tparam juce.Point targetPoint
		-- @tparam[opt=juce.AffineTransform.identity] juce.AffineTransform transform
		-- @return distance
		-- @treturn juce.Point pointOnPath
		-- @function getNearestPoint
		getNearestPoint = function (self, targetPoint,
								   transform)
			transform = transform or AffineTransform.identity
			local pointOnPath = Point()
			local distance = protolib.Path_getNearestPoint (self, targetPoint,
								   pointOnPath,
								   transform)
			return distance, pointOnPath
		end;

		--- Clear.
		-- @function clear
		clear = function (self)
			protolib.Path_clear(self)
		end;

		--- Start new sub path.
		-- @param startX
		-- @param startY
		-- @function startNewSubPath

		--- Start new sub path.
		-- @tparam juce.Point start
		-- @function startNewSubPath
		startNewSubPath = function (self, ...)
			local control = ...
			if type(control)=="number" then
				protolib.Path_startNewSubPath (self, ...)
			else
				protolib.Path_startNewSubPath2 (self, ...)
			end
		end;

		--- Close sub path.
		-- @function closeSubPath
		closeSubPath = function (self)
			protolib.Path_closeSubPath(self)
		end;

		--- Line to.
		-- @param endX
		-- @param endY
		-- @function lineTo

		--- Line to.
		-- @tparam juce.Point endpoint
		-- @function lineTo
		lineTo = function (self, ...)
			local control = ...
			if type(control)=="number" then
				protolib.Path_lineTo (self, ...)
			else
				protolib.Path_lineTo2 (self, ...)
			end
		end;

		--- Quadratic to.
		-- @param controlPointX
		-- @param controlPointY
		-- @param endPointX
		-- @param endPointY
		-- @function quadraticTo

		--- Quadratic to2.
		-- @tparam juce.Point controlPoint
		-- @tparam juce.Point endPoint
		-- @function quadraticTo2
		quadraticTo = function (self, ...)
			local control = ...
			if type(control)=="number" then
				protolib.Path_quadraticTo (self, ...)
			else
				protolib.Path_quadraticTo2 (self, ...)
			end
		end;

		--- Cubic to.
		-- @param controlPoint1X
		-- @param controlPoint1Y
		-- @param controlPoint2X
		-- @param controlPoint2Y
		-- @param endPointX
		-- @param endPointY
		-- @function cubicTo

		--- Cubic to.
		-- @tparam juce.Point controlPoint1
		-- @tparam juce.Point controlPoint2
		-- @tparam juce.Point endPoint
		-- @function cubicTo
		cubicTo = function (self, ...)
			local control = ...
			if type(control)=="number" then
				protolib.Path_cubicTo (self, ...)
			else
				protolib.Path_cubicTo2 (self, ...)
			end
		end;

		--- Get current position.
		-- @treturn juce.Point the current path construction position
		-- @function getCurrentPosition
		getCurrentPosition = function (self)
			return protolib.Path_getCurrentPosition(self)
		end;

		--- Add rectangle.
		-- @param x
		-- @param y
		-- @param width
		-- @param height
		-- @function addRectangle

		--- Add rectangle.
		-- @tparam juce.Rectangle_float rectangle
		-- @function addRectangle
		addRectangle = function (self, ...)
			local control = ...
				if type(control)=="number" then
			protolib.Path_addRectangle (self, ...)
			else
				protolib.Path_addRectangle2 (self, ...)
			end
		end;

		--- Add rounded rectangle.
		-- @param x
		-- @param y
		-- @param width
		-- @param height
		-- @param cornerSize
		-- @function addRoundedRectangle

		--- Add rounded rectangle.
		-- @param x
		-- @param y
		-- @param width
		-- @param height
		-- @param cornerSizeX
		-- @param cornerSizeY
		-- @function addRoundedRectangle

		--- Add rounded rectangle.
		-- @param x
		-- @param y
		-- @param width
		-- @param height
		-- @param cornerSizeX
		-- @param cornerSizeY
		-- @tparam boolean curveTopLeft
		-- @tparam boolean curveTopRight
		-- @tparam boolean curveBottomLeft
		-- @tparam boolean curveBottomRight
		-- @function addRoundedRectangle

		--- Add rounded rectangle.
		-- @tparam juce.Rectangle_float rectangle
		-- @param cornerSizeX
		-- @param cornerSizeY
		-- @function addRoundedRectangle

		--- Add rounded rectangle.
		-- @tparam juce.Rectangle_float rectangle
		-- @param cornerSize
		-- @function addRoundedRectangle
		addRoundedRectangle = function (self, ...)
			if select('#',...) == 5 then
				protolib.Path_addRoundedRectangle2 (self, ...)
			elseif select('#',...) == 6 then
				protolib.Path_addRoundedRectangle3 (self, ...)
			elseif select('#',...) == 10 then
				protolib.Path_addRoundedRectangle4 (self, ...)
			elseif select('#',...) == 3 then
				protolib.Path_addRoundedRectangle5 (self, ...)
			elseif select('#',...) == 2 then
				protolib.Path_addRoundedRectangle6 (self, ...)
			end
		end;

		--- Add triangle.
		-- @param x1
		-- @param y1
		-- @param x2
		-- @param y2
		-- @param x3
		-- @param y3
		-- @function addTriangle
		addTriangle = function (self, x1, y1,
							  x2, y2,
							  x3, y3)
			protolib.Path_addTriangle (self, x1, y1,
							  x2, y2,
							  x3, y3)
		end;

		--- Add quadrilateral.
		-- @param x1
		-- @param y1
		-- @param x2
		-- @param y2
		-- @param x3
		-- @param y3
		-- @param x4
		-- @param y4
		-- @function addQuadrilateral
		addQuadrilateral = function (self, x1, y1,
								   x2, y2,
								   x3, y3,
								   x4, y4)
			protolib.Path_addQuadrilateral (self, x1, y1,
								   x2, y2,
								   x3, y3,
								   x4, y4)
		end;

		--- Add ellipse.
		-- @param x
		-- @param y
		-- @param width
		-- @param height
		-- @function addEllipse
		addEllipse = function (self, x, y, width, height)
			protolib.Path_addEllipse (self, x, y, width, height)
		end;

		--- Add arc.
		-- @param x
		-- @param y
		-- @param width
		-- @param height
		-- @param fromRadians the start angle, clockwise from the top
		-- @param toRadians the end angle
		-- @param[opt=false] startAsNewSubPath
		-- @function addArc
		addArc = function (self, x, y, width, height,
						 fromRadians,
						 toRadians, startAsNewSubPath)
			startAsNewSubPath = startAsNewSubPath or false
			protolib.Path_addArc (self, x, y, width, height,
						 fromRadians,
						 toRadians, startAsNewSubPath)
		end;

		--- Add centred arc.
		-- @param centreX
		-- @param centreY
		-- @param radiusX
		-- @param radiusY
		-- @param rotationOfEllipse the ellipse inclination
		-- @param fromRadians the start angle, clockwise from the top
		-- @param toRadians the end angle
		-- @param[opt=false] startAsNewSubPath
		-- @function addCentredArc
		addCentredArc = function (self, centreX, centreY,
								radiusX, radiusY,
								rotationOfEllipse,
								fromRadians,
								toRadians, startAsNewSubPath)
			startAsNewSubPath = startAsNewSubPath or false
			protolib.Path_addCentredArc (self, centreX, centreY,
								radiusX, radiusY,
								rotationOfEllipse,
								fromRadians,
								toRadians, startAsNewSubPath)
		end;

		--- Add pie segment.
		-- @param x
		-- @param y
		-- @param width
		-- @param height
		-- @param fromRadians the start angle, clockwise from the top
		-- @param toRadians the end angle
		-- @param[opt=0] innerCircleProportionalSize band proportion size, if specified
		-- @function addPieSegment
		addPieSegment = function (self, x, y,
								width, height,
								fromRadians,
								toRadians, innerCircleProportionalSize)
			innerCircleProportionalSize = innerCircleProportionalSize or 0
			protolib.Path_addPieSegment (self, x, y,
								width, height,
								fromRadians,
								toRadians, innerCircleProportionalSize)
		end;

		--- Add line segment.
		-- @tparam juce.Line line
		-- @param lineThickness
		-- @function addLineSegment
		addLineSegment = function (self, line, lineThickness)
			protolib.Path_addLineSegment (self, line, lineThickness)
		end;

		--- Add arrow.
		-- @tparam juce.Line line
		-- @param lineThickness
		-- @param arrowheadWidth
		-- @param arrowheadLength
		-- @function addArrow
		addArrow = function (self, line,
						   lineThickness,
						   arrowheadWidth, arrowheadLength)
			protolib.Path_addArrow (self, line,
						   lineThickness,
						   arrowheadWidth, arrowheadLength)
		end;

		--- Add polygon.
		-- @tparam juce.Point centre
		-- @param numberOfSides
		-- @param radius
		-- @param[opt=0] startAngle
		-- @function addPolygon
		addPolygon = function (self, centre,
							 numberOfSides,
							 radius, startAngle)
			startAngle = startAngle or 0
			protolib.Path_addPolygon (self, centre,
							 numberOfSides,
							 radius, startAngle)
		end;

		--- Add star.
		-- @tparam juce.Point centre
		-- @param numberOfPoints
		-- @param innerRadius
		-- @param outerRadius
		-- @param[opt=0] startAngle
		-- @function addStar
		addStar = function (self, centre,
						  numberOfPoints,
						  innerRadius,
						  outerRadius, startAngle)
			startAngle = startAngle or 0
			protolib.Path_addStar (self, centre,
						  numberOfPoints,
						  innerRadius,
						  outerRadius, startAngle)
		end;

		--- Add bubble.
		-- @param bodyArea
		-- @param maximumArea
		-- @param arrowTipPosition
		-- @param cornerSize
		-- @param arrowBaseWidth
		-- @function addBubble
		addBubble = function (self, bodyArea,
							maximumArea,
							arrowTipPosition,
							cornerSize, arrowBaseWidth)
			protolib.Path_addBubble (self, bodyArea,
							maximumArea,
							arrowTipPosition,
							cornerSize, arrowBaseWidth)
		end;

		--- Add path.
		-- @param pathToAppend
		-- @tparam[opt=juce.AffineTransform.identity] juce.AffineTransform transform
		-- @function addPath
		addPath = function (self, pathToAppend, transformToApply)
			if transformToApply then
				protolib.Path_addPath2 (self, pathToAppend, transformToApply)
			else
				protolib.Path_addPath (self, pathToAppend)
			end
		end;

		--- Apply transform.
		-- @tparam juce.AffineTransform transform
		-- @function applyTransform
		applyTransform = function (self, transform)
			protolib.Path_applyTransform (self, transform)
		end;

		--- Scale to fit.
		-- @param x
		-- @param y
		-- @param width
		-- @param height
		-- @param preserveProportions
		-- @function scaleToFit
		scaleToFit = function (self, x, y, width, height, preserveProportions)
			protolib.Path_scaleToFit (self, x, y, width, height, preserveProportions)
		end;

		--- Get transform to scale to fit.
		-- @param x
		-- @param y
		-- @param width
		-- @param height
		-- @tparam boolean preserveProportions
		-- @tparam[opt=Justification.centred] juce.Justification justification
		-- @treturn juce.AffineTransform the required transform
		-- @function getTransformToScaleToFit

		--- Get transform to scale to fit.
		-- @tparam juce.Rectangle_float area
		-- @tparam boolean preserveProportions
		-- @tparam[opt=Justification.centred] juce.Justification justification
		-- @treturn juce.AffineTransform the required transform
		-- @function getTransformToScaleToFit
		getTransformToScaleToFit = function (self, ...)
			local control = ...
			if type(control)=="number" then
				return protolib.Path_getTransformToScaleToFit (self, ...)
			else
				return protolib.Path_getTransformToScaleToFit2 (self, ...)
			end
		end;

		--- Create path with rounded corners.
		-- @param cornerRadius
		-- @treturn juce.Path the rounded path
		-- @function createPathWithRoundedCorners
		createPathWithRoundedCorners = function (self, cornerRadius)
			return protolib.Path_createPathWithRoundedCorners (self, cornerRadius)
		end;

		--- Set using non zero winding.
		-- @tparam boolean isNonZeroWinding
		-- @function setUsingNonZeroWinding
		setUsingNonZeroWinding = function (self, isNonZeroWinding)
			protolib.Path_setUsingNonZeroWinding (self, isNonZeroWinding)
		end;

		--- Is using non zero winding.
		-- @treturn boolean whether the path is using non-zero winding
		-- @function isUsingNonZeroWinding
		isUsingNonZeroWinding = function (self)
			return protolib.Path_isUsingNonZeroWinding(self)
		end;

		toString = function (self, dest, bufSize)
			protolib.Path_toString(self, dest, bufSize)
		end;

		restoreFromString = function (self, src)
			protolib.Path_restoreFromString (self, src)
		end;
	}
}

ffi.metatype("pPath", Path_mt)


local Line = ffi.typeof("Line_float")

local Path = {
	--- Joint styles.
	-- for use with @{juce.Graphics.strokePath}
	-- @table juce.Path.JointStyle
	JointStyle = 
	{
		mitered = 0;
		curved = 1;
		beveled = 2
	};
	--- End cap styles.
	-- for use with @{juce.Graphics.strokePath}
	-- @table juce.Path.EndCapStyle
	EndCapStyle = 
	{
		butt = 0;
		square = 1;
		rounded = 2
	}
};

Path = setmetatable(Path,{
	-- constructor
	__call = function ()
		return ffi.gc(
			protolib.Path_new(), 
			protolib.Path_delete
		)
	end;
})

return Path
