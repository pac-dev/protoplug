-- volume to velocity transformer
-- (c) Severak 2021

require "include/protoplug"

volume = 100

function plugin.processBlock(samples, smax, midiBuf)
	for ev in midiBuf:eachEvent() do
		if ev:isNoteOn() then
			ev:setVel(volume)
		elseif ev:isControl() and ev:getControlNumber()==7 then
		    volume = ev:getControlValue()
		end	
	end	
end
