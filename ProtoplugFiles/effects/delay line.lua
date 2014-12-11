--[[
name: Delay Line
description: Simple delay line effect with DC removal
author: osar.fr
--]]

require "include/protoplug"

local length, feedback

stereoFx.init()

-- everything is per stereo channel
function stereoFx.Channel:init()
	self.buf = ffi.new("double[512]")
	self.it = 0 	-- iterator
	self.dc1, self.dc2 = 0,0
end

function stereoFx.Channel:goBack()
	local nit = self.it-length
	if nit<0 then nit = nit+512 end
	local o = self.buf[nit]
	nit = nit-1
	if nit<0 then nit = nit+512 end
	o = o+self.buf[nit]
	o = o*0.4992*feedback
	return o
end

function stereoFx.Channel:dcRemove(s)
	self.dc1 = self.dc1 + (s - self.dc2) * 0.000002
	self.dc2 = self.dc2 + self.dc1
	self.dc1 = self.dc1 * 0.96
	return s-self.dc2
end

function stereoFx.Channel:processBlock(samples, smax)
	for i = 0,smax do
		samples[i] = samples[i]+self:dcRemove(samples[i]+self:goBack())
		self.buf[self.it] = samples[i]
		self.it = self.it+1
		if self.it>=512 then self.it=0 end
	end
end

params = plugin.manageParams {
	{
		name = "Length";
		type = "int";
		max = 510;
		changed = function(val) length = val end;
	};
	{
		name = "Feedback";
		max = 1;
		changed = function(val) feedback = val end;
	};
}
