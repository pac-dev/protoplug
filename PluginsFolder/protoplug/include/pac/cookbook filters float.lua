-- Cookbook Filters Module FLOAT TEST
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

local Float = ffi.typeof("float[1]")
--[[local function Float (n)
	return ffi.cast("float", n)
end--]]

local function Filter(params)
	local a0, a1, a2, b0, b1, b2
	local x0, x1, x2 = Float(0), Float(0), Float(0)
	local y0, y1, y2 = Float(0), Float(0), Float(0)
	local params = params or {type = "lp", f = 440, gain = 0, Q = 1}
	
	public = {
		update = function (args)
			for k,v in pairs(args) do
				params[k] = v
			end
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
			print(a0)
			a0, a1, a2, b0, b1, b2 = Float(a0), Float(a1), Float(a2), Float(b0), Float(b1), Float(b2)
			print(a0[0])
		end;
		
		process = function (x0)
			y2[0], y1[0] = y1[0], y0[0]
			y0[0] = (b0[0] / a0[0]) * x0[0] + (b1[0] / a0[0]) * x1[0] + (b2[0] / a0[0]) * x2[0] - (a1[0] / a0[0]) * y1[0] - (a2[0] / a0[0]) * y2[0]
			x2[0], x1[0] = x1[0], x0[0]
			return y0[0]
		end;
	}
	
	public.update(params)
	return public
end

return Filter