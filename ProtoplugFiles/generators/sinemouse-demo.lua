--[[
name: sinemouse demo
description: >
  Custom GUI demonstration : Drag your mouse around in the
  frame to control the sine wave's amplitude and frequency.
author: osar.fr
--]]

require "include/protoplug"

local freq,amp = 440, 0
local delta, phase = 0.06, 0

function plugin.processBlock(samples, smax)
	for i=0,smax do
		local s = math.sin(phase)*amp
		samples[0][i] = s -- left
		samples[1][i] = s -- right
		phase = phase + delta
	end
end

local J = juce
local frame = J.Rectangle_int(20,20,400,300)
local sideways = J.AffineTransform():rotated(math.pi*0.5)

function gui.paint(g)
	g:fillAll()
	g:setColour(J.Colour.green)
	g:drawRect(frame)
	g:drawText("Frequency", 20, 320, 400, 20, J.Justification.centred)
	g:addTransform(sideways)
	g:drawText("amplitude", 20, -440, 300, 20, J.Justification.centred)
end

local function mouseHandler(event)
	if not frame:contains(J.Point(event.x,event.y)) then
		return
	end
	freq = event.x + 80
	amp = (320-event.y)/300
	local sr = plugin.isSampleRateKnown() and plugin.getSampleRate() or 44100
	delta = 2*math.pi*freq/sr
end

gui.addHandler("mouseDrag", mouseHandler)
gui.addHandler("mouseDown", mouseHandler)
