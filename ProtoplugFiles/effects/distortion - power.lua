--[[
name: Badass Distortion
description: The one from the website
author: osar.fr
--]]
require "include/protoplug"
local cbFilter = require "include/pac/cookbook filters"

local power

local function dist (x)
    if x<0 then return -1*math.pow (-1*x,power) end
    return math.pow (x,power)
end

stereoFx.init ()
function stereoFx.Channel:init ()
    -- create per-channel fields (filters)
    self.low = cbFilter {type = "lp"; f = 100; gain = 0; Q = 0.3}
    self.high = cbFilter {type = "hp"; f = 50; gain = 0; Q = 0.3}
end

function stereoFx.Channel:processBlock (samples, smax)
    for i = 0, smax do
        local s = dist (self.high.process (samples[i]))
        samples[i] = s + self.low.process (samples[i])*2
    end
end

params = plugin.manageParams {
    {
		name = "Power";
        min = 1;
        max = 0.01;
        changed = function (val) power = val end;
    };
}
