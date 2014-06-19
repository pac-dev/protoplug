--- Rectangle Placement.
-- Is converted to a [JUCE RectanglePlacement](http://www.juce.com/api/RectanglePlacement.html)
-- @classmod juce.RectanglePlacement

--- Rectangle Placement Constants.
-- @table juce.RectanglePlacement
local r = {
	xLeft                   = 1;
	xRight                  = 2;
	xMid                    = 4;
	yTop                    = 8;
	yBottom                 = 16;
	yMid                    = 32;
	stretchToFit            = 64;
	fillDestination         = 128;
	onlyReduceInSize        = 256;
	onlyIncreaseInSize      = 512;
	doNotResize             = 768;
	centred                 = 4 + 32
}

return  r