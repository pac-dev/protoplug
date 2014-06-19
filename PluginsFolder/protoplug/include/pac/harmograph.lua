-- harmograph
local J = require "include/protojuce"

function Harmograph(args)
	local bounds = args.bounds or J.Rectangle_int{15,0,480,330};
	local pageBack = args.pageBack or J.Colour.white;
	local pageFore = args.pageFore or J.Colour.black;
	local graphBack = args.graphBack or J.Colour.white;
	local graphFore = args.graphFore or J.Colour.black;
	local yMax = args.yMax or 500
	local pos = args.pos or 0
	
	local frame = J.Rectangle_int(4, 30, bounds.w-50, bounds.h-65)
	local outFrame = J.Rectangle_int(2, 28, frame.w+4, frame.h+4)
	local backBuffer = J.Image(J.Image.PixelFormat.RGB, bounds.w, bounds.h, true)
	-- initialize backbuffer
	do
		local g = J.Graphics(backBuffer)
		g:fillAll(pageBack)
		g:setColour(graphFore)
		g:drawRect(outFrame, 1)
		g:setColour(pageFore)
		-- draw the Y axis labels
		g:setFont(14)
		for pos, label in pairs{0=0; 0.5=50; 1=100} do
			local y = self.frame.y+((self.frame.h-10)*(1-pos))-6
			g:drawText(tostring(label), self.frame:getR()+3, y, 33, 20)
		end
	end
		
	local renderGraph = function()
		
	end
	
	renderGraph()
	
	local yfactor = 0.5*frame.h/yMax
	
	return {
		draw = function (g)
			g:setColour(J.Colour.black)
			for x=0,frame.w do
				if x==math.floor(pos*frame.w) then
					g:setColour(J.Colour.blue)
					g:drawLine(x+10, 10, x+10, 410)
				end
				local ls = makeLengths(x/graphW)
				g:setColour(J.Colour(64,64,64))
				for k,v in ipairs(ls) do
					g:setPixel(x+10, graphH-(v*3)*yfactor)
				end
				g:setColour(J.Colour(128,128,128))
				for k,v in ipairs(ls) do
					g:setPixel(x+10, graphH-(v*2)*yfactor)
				end
				g:setColour(J.Colour.black)
				for k,v in ipairs(ls) do
					g:setPixel(x+10, graphH-v*yfactor)
				end
			end
		end,
	}
end

return Harmograph