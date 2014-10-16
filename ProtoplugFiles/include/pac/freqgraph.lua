-- pac freqgraph.lua
--[[
an interactive histogram-ish frequency graph 
used in "spectral filter" and "pitch distort"
usage : 
	local Freqgraph = require "include/pac/freqgraph"
	local fg = Freqgraph {
		-- required paramters :
			-- an array (Lua or C) containing the values to be read and modified by the interactive graph
			data = ;
			-- number of elements in the array
			dataSize = ;
		-- optional paramters :
			-- the position and size of the graph
			bounds = juce.Rectangle_int{15,0,480,330};
			title = "";
			yAxis = {
				name = "amplitude (%)";
				values = {
					[0] = "0";
					[0.5] = "50";
					[1] = "100";
				}
			}
		-- colours : pageBack, pageFore, graphBack, graphFore
	}
	-- public methods :
		-- paint the graph onto a pGraphics ctype
		fg:paint(g)
		-- change the graph's position
		fg:setPos(x, y)

--]]

local J = require "include/protojuce"

-- class
local M = {
	-- default values
	bounds = J.Rectangle_int{15,0,480,330};
	pageBack = J.Colour.black;
	pageFore = J.Colour.green;
	graphBack = J.Colour{r=0, g=0, b=160};
	graphFore = J.Colour.green;
	yAxis = {
		name = "amplitude (%)";
		values = {
			[0] = "0";
			[0.25] = "50";
			[0.5] = "100";
			[0.75] = "150";
			[1] = "200";
		}
	}
}
M.__index = M

setmetatable(M, {
	-- constructor
	__call = function (_, arg)
		local self = setmetatable(arg, M)
		self.frame = J.Rectangle_int(4, 30, self.bounds.w-50, self.bounds.h-65)
		self.outFrame = J.Rectangle_int(2, 28, self.frame.w+4, self.frame.h+4)
		self.yAmp = 1/self.frame.h
		-- display-coord quarters in data coordinates
		self.q1 = self:x2bar(self.frame.w/4)
		self.q2 = self:x2bar(self.frame.w/2)
		self.bgFill = J.FillType(self.pageBack)
		self.bgFill2 = J.FillType(self.graphBack)
		self.fgFill = J.FillType(self.graphFore)
		self:InitBackBuffer()
		self.dirtyLeft, self.dirtyRight = 0, self.dataSize-1
		gui.addHandler("mouseDrag", function (event)
			self:mouseDrag(event)
		end)
		gui.addHandler("mouseUp", function (event)
			self:mouseUp(event)
		end)
		plugin.addHandler("prepareToPlay", function ()
			self:InitBackBuffer()
		end)
		return self
	end;
})

-- Coordinate system conversion between displayed bars <-> data
-- cheap log-like scale made of 3 linear functions
function M:x2bar(x)
	if x<self.frame.w/4 then
		return math.floor(x*(self.dataSize/(4*self.frame.w)))
	elseif x<self.frame.w/2 then
		return math.floor(x*((3*self.dataSize)/(4*self.frame.w))-(self.dataSize/8))
	else
		return math.floor(x*((3*self.dataSize)/(2*self.frame.w))-(self.dataSize/2))
	end
end

function M:bar2x(s)
	if s<self.q1 then
		return math.floor((4*self.frame.w*s)/self.dataSize)
	elseif s<self.q2 then
		return math.floor((self.frame.w*(self.dataSize+8*s))/(6*self.dataSize))
	else
		return math.floor((self.frame.w*(self.dataSize+2*s))/(3*self.dataSize))
	end
end

function M:y2amp(y) return 1 - y*self.yAmp end
function M:amp2y(a) return math.floor(self.frame.h - a*self.frame.h) end

-- on mouse drag, interpolate the movement, update the data, and mark the dirty graph area
function M:mouseDrag(event)
	if not self.bounds:contains(event.mouseDownPos) then
		return
	end
	if self.bar ~= nil then
		self.oldbar = self.bar
		self.oldamp = self.amp
	end
	self.bar = self:x2bar(event.x-self.frame.x-self.bounds.x)
	self.amp   = self:y2amp(event.y-self.frame.y-self.bounds.y)
	
	-- limit to bounds
	if self.bar<0 then self.bar=0 end
	if self.bar>self.dataSize-1 then self.bar=self.dataSize-1 end
	if self.amp<0 then self.amp=0 end
	if self.amp>1 then self.amp=1 end
	
	-- interpolate and set
	local x1, x2, y1, y2 = self.oldbar,self.bar,self.oldamp,self.amp
	if x1 == nil or x1==x2 then
		x1,y1 = x2,y2
		self.data[x2] = y2
	else
		if x1>x2 then
			x1, x2, y1, y2 = x2, x1, y2, y1
		end
		for i=x1,x2 do
			local x = (x2-i)/(x2-x1)
			self.data[i] = y1*x + y2*(1-x)
		end
	end
	-- create or enlarge the currently dirty area (ie. needing a repaint)
	if self.dirtyLeft then
		if x1<self.dirtyLeft then self.dirtyLeft = x1 end
		if x2>self.dirtyRight then self.dirtyRight = x2 end
	else
		self.dirtyLeft, self.dirtyRight = x1, x2
	end
	event.originalComponent:repaint()
end

function M:mouseUp(event)
	self.bar = nil
	self.oldbar = nil
end

-- create the backbuffer and draw all permanent parts of the graph
function M:InitBackBuffer()
	self.backBuffer = J.Image(
		J.Image.PixelFormat.RGB, 
		self.bounds.w, 
		self.bounds.h, true)
	local g = J.Graphics(self.backBuffer)
	g:fillAll(self.pageBack)
	g:setColour(self.graphFore)
	g:drawRect(self.outFrame, 1)
	g:setColour(self.pageFore)
	if self.title then
		g:setFont(17)
		g:drawText("== "..self.title.." ==", self.frame.x, 5, self.frame.w, 20, J.Justification.centred)
	end
	
	-- draw the Y axis labels
	g:saveState()
	g:addTransform(J.AffineTransform(0, -1, self.bounds.w,     1, 0, self.frame.y))
	g:setFont(16)
	g:drawText(self.yAxis.name, 0, 0, self.frame.h, 20, J.Justification.centred)
	g:restoreState()
	g:setFont(14)
	for pos, label in pairs(self.yAxis.values) do
		local y = self.frame.y+((self.frame.h-10)*(1-pos))-6
		g:drawText(tostring(label), self.frame:getR()+3, y, 33, 20)
	end
	
	-- draw the X axis labels
	g:setFont(16)
	g:drawText("frequency (kHz)", self.frame.x, self.bounds.h-20, self.frame.w, 20, J.Justification.centred)
	g:setFillType(self.fgFill)
	local sr = 44100
	if plugin.isSampleRateKnown() then
		sr = plugin.getSampleRate()
	else
		-- if the samplerate is unknown, call this again when it becomes known
		plugin.addHandler('prepareToPlay', function() self:InitBackBuffer() end)
	end
	local f,fmax = 0, sr/2
	local function f2x(f)
		return self:bar2x(f/fmax*self.dataSize)+self.frame.x
	end
	g:setFont(14)
	while f<fmax do
		if f%10000==0 then
			g:fillRect(f2x(f), self.frame:getB(), 3, 8)
		elseif f%1000==0 then
			g:fillRect(f2x(f), self.frame:getB(), 2, 4)
		end
		f = f + 100
	end
	g:drawText("0", f2x(0)-2, self.frame:getB()+3, 20, 20)
	g:drawText("2", f2x(2000)-2, self.frame:getB()+3, 20, 20)
	g:drawText("10", f2x(10000)-2, self.frame:getB()+3, 20, 20)
	g:drawText("20", f2x(20000)-2, self.frame:getB()+3, 20, 20)
	g = nil
	
	-- draw the entire graph's contents
	self:DrawBars(0, self.dataSize-1)
end

-- update the graph between left and right
function M:DrawBars(leftBar, rightBar)
	local g = J.Graphics(self.backBuffer)
	g:setFillType(self.bgFill2)
	local leftX, rightX = self:bar2x(leftBar), self:bar2x(rightBar+1)
	g:fillRect(leftX+self.frame.x, self.frame.y, rightX-leftX, self.frame.h)
	g:setFillType(self.fgFill)
	local lastX = -1
	for i = leftBar, rightBar do
		local x = self:bar2x(i)
		if x~=lastX then
			local width = math.max(1,self:bar2x(i+1)-x)
			local y = self:amp2y(self.data[i])
			local height = self.frame.h-y
			g:fillRect(J.Rectangle_int(x+self.frame.x, y+self.frame.y, width, height))
		end
		lastX = x
	end
	
end

-- on paint, update the backbuffer where necessary, and blit it
function M:paint(g)
	if self.dirtyLeft then
		local l, r = self.dirtyLeft, self.dirtyRight
		self.dirtyLeft, self.dirtyRight = nil, nil
		self:DrawBars(l, r)
	end
	g:drawImageAt(self.backBuffer, self.bounds.x, self.bounds.y)
end

function M:setPos(x,y)
	self.bounds.x, self.bounds.y = x, y
	local guiComp = gui.getComponent()
	if guiComp ~= nil then
		guiComp:repaint()
	end
end

return M
