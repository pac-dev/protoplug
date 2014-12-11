-- outputs a stream of semi-chaotic notes on MIDI channel 1

require "include/protoplug"

--Welcome to Lua Protoplug generator (version 1.0.0)
x=0
function plugin.processBlock(samples, smax, midiBuf)
	newEvents = {}
	if not interval then updateInterval() end
	if not i then i = interval + 1 end
	for s=0,smax do
		if i>=interval then
			local f1,v1 = magic(x)
			local f2 = magic(x-5)
			if f1 then noteOn(f1, v1) end
			if f1 then noteOn(f1-5, v1) end
			if f2 then noteOff(f2) end
			if f2 then noteOff(f2-5) end
			i = 0
			x = x + 1
		end
		i = i + 1
	end
	midiBuf:clear()
	if #newEvents>0 then
		for _,e in ipairs(newEvents) do
			midiBuf:addEvent(e)
		end
	end
end

function noteOn(n,v)
	if n>100 then return end
	table.insert(newEvents, midi.Event.noteOn(1, n, v))
end
function noteOff(n)
	table.insert(newEvents, midi.Event.noteOff(1, n, 0))
end

function magic(x)
	if ((x%19)%11)%4==0 then
		return 40+x%((x/6)%8+2)*8, 20+((x/6)%8+2)*8
	end
end

function updateInterval()
	local int = params[1].getValue()
	bpm = plugin.getCurrentPosition().bpm
	interval = math.floor((plugin.getSampleRate()*int)/(bpm))
end

params = plugin.manageParams {
	{
		name = "Interval";
		type = "int";
		min = 3;
		max = 30;
		default = 60;
		changed = function(val) interval = nil end;
	};
}