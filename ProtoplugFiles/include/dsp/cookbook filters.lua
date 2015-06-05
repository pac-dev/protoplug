-- Cookbook Filters Module
-- Based on Worp Filter.lua implementation by Ico Doornekamp. (https://github.com/zevv/worp)
-- Based on the Cookbook formulae by Robert Bristow-Johnson  <rbj@audioimagination.com>
-- osar.fr

--[[
example usage :
	local f = Filter {
		type = "lp" -- filter type, see below
		f = 440; 	-- frequency(Hz), (0-20000)
		gain = 0; 	-- filter gain(dB), (-60 to 60)
		Q = 1; 		-- resonance, (0.1-100)
	}
	for sample in eachSample()
		sample = f.process(sample)
	end

filter types :
	hp: High pass
	lp: Low pass
	bp: Band pass
	bs: Band stop (aka, Notch)
	ls: Low shelf
	hs: High shelf
	ap: All pass
	eq: Peaking EQ filter
--]]

local function Filter(params)
	local a0, a1, a2, b0, b1, b2
	local x0, x1, x2 = 0, 0, 0
	local y0, y1, y2 = 0, 0, 0
	local params = params or {type = "lp", f = 440, gain = 0, Q = 1}
	
	public = {
		update = function (args)
			args = args or {}
			for k,v in pairs(args) do
				params[k] = v
			end
			if params.f < 10 then params.f = 10 end
			if not plugin.isSampleRateKnown() then return end
			--print (
			--	"type "..params.type..
			--	", f "..params.f..
			--	", gain "..params.gain..
			--	", Q "..params.Q
			--)
			local w0 = 2 * math.pi * (params.f / plugin.getSampleRate())
			local alpha = math.sin(w0) / (2*params.Q)
			local cos_w0 = math.cos(w0)
			local A = math.pow(10, params.gain/40)
			if params.type == "hp" then
				b0, b1, b2 = (1 + cos_w0)/2, -(1 + cos_w0), (1 + cos_w0)/2
				a0, a1, a2 = 1 + alpha, -2*cos_w0, 1 - alpha

			elseif params.type == "lp" then
				b0, b1, b2 = (1 - cos_w0)/2, 1 - cos_w0, (1 - cos_w0)/2
				a0, a1, a2 = 1 + alpha, -2*cos_w0, 1 - alpha

			elseif params.type == "bp" then
				b0, b1, b2 = params.Q*alpha, 0, -params.Q*alpha
				a0, a1, a2 = 1 + alpha, -2*cos_w0, 1 - alpha

			elseif params.type == "bs" then
				b0, b1, b2 = 1, -2*cos_w0, 1
				a0, a1, a2 = 1 + alpha, -2*cos_w0, 1 - alpha

			elseif params.type == "ls" then
				local ap1, am1, tsAa = A+1, A-1, 2 * math.sqrt(A) * alpha
				local am1_cos_w0, ap1_cos_w0 = am1 * cos_w0, ap1 * cos_w0
				b0, b1, b2 = A*( ap1 - am1_cos_w0 + tsAa ), 2*A*( am1 - ap1_cos_w0 ), A*( ap1 - am1_cos_w0 - tsAa )
				a0, a1, a2 = ap1 + am1_cos_w0 + tsAa, -2*( am1 + ap1_cos_w0 ), ap1 + am1_cos_w0 - tsAa

			elseif params.type == "hs" then
				local ap1, am1, tsAa = A+1, A-1, 2 * math.sqrt(A) * alpha
				local am1_cos_w0, ap1_cos_w0 = am1 * cos_w0, ap1 * cos_w0
				b0, b1, b2 = A*( ap1 + am1_cos_w0 + tsAa ), -2*A*( am1 + ap1_cos_w0 ), A*( ap1 + am1_cos_w0 - tsAa )
				a0, a1, a2 = ap1 - am1_cos_w0 + tsAa, 2*( am1 - ap1_cos_w0 ), ap1 - am1_cos_w0 - tsAa

			elseif params.type == "eq" then
				b0, b1, b2 = 1 + alpha*A, -2*cos_w0, 1 - alpha*A
				a0, a1, a2 = 1 + alpha/A, -2*cos_w0, 1 - alpha/A

			elseif params.type == "ap" then
				b0, b1, b2 = 1 - alpha, -2*cos_w0, 1 + alpha
				a0, a1, a2 = 1 + alpha, -2*cos_w0, 1 - alpha

			else
				error("Unsupported filter type " .. params.type)
			end
		end;
		phaseDelay = function(frequency)
			local omegaT = 2 * math.pi * frequency / plugin.getSampleRate();
			local real, imag = 0.0, 0.0;
			for i,b in ipairs{b0,b1,b2} do
				real = real + b/a0 * math.cos( (i-1) * omegaT );
				imag = imag - b/a0 * math.sin( (i-1) * omegaT );
			end
			
			local phase = math.atan2( imag, real );
			
			real = 0.0; imag = 0.0;
			for i,a in ipairs{a0,a1,a2} do
				real = real + a/a0 * math.cos( (i-1) * omegaT );
				imag = imag - a/a0 * math.sin( (i-1) * omegaT );
			end
			
			phase = phase - math.atan2( imag, real );
			phase = math.fmod( -phase, 2 * math.pi );
			return phase / omegaT;
		end;
		process = function (x0)
			y2, y1 = y1, y0
			y0 = (b0 / a0) * x0 + (b1 / a0) * x1 + (b2 / a0) * x2 - (a1 / a0) * y1 - (a2 / a0) * y2
			x2, x1 = x1, x0
			return y0
		end;
	}
	
	-- initialize when the samplerate in known
	plugin.addHandler("prepareToPlay", public.update)
	
	return public
end

return Filter