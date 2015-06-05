-- fractional delay line 1
-- with lagrange interpolation


local function FLine (bufSize)
	local n,e = math.frexp(bufSize)
	bufSize = 2^e --nextpoweroftwo
	local buf = ffi.new("double[?]", bufSize)
	local mask = bufSize - 1
	local h = {[0]=0,0,0,0}
	local pos = 0 
	local ptL = 0
	local dc1, dc2 = 0, 0
	local lastdt = math.huge
	local function CalcCoeffs(delay)
		local intd =math.floor(delay);
		local Dm1 = delay - intd;
		intd = intd - 1.;
		local D = Dm1 + 1;
		local Dm2 = Dm1 - 1;
		local Dm3 = Dm1 - 2;
		local DxDm1 = D * Dm1;
		--//float Dm1xDm2 = Dm1 * Dm2;
		local Dm2xDm3 = Dm2 *Dm3;
		h[0] = (-1/6.)* Dm1 * Dm2xDm3;
		h[1] = 0.5 * D * Dm2xDm3;
		h[2] = -0.5 * DxDm1 * Dm3;
		h[3] = (1/6.) * DxDm1 * Dm2;
		return intd ;
	end
	return {
		goBack = function (dt)
			if (dt ~= lastdt) then
				ptL = CalcCoeffs(dt);
				lastdt = dt;
			end
			local sum = 0;
			for i=0,3 do
				sum = sum + buf[bit.band((pos + ptL + i), mask)]*h[i];
			end
			return sum;
		end;
		push = function (s)
			pos = pos - 1
			if pos < 0 then pos = mask end
			buf[pos] = s
		end;
		zero = function()
			for i=0,bufSize-1 do buf[i] = 0 end
		end;
		dc_remove = function(s)
			dc1 = dc1 + (s - dc2) * 0.000002
			dc2 = dc2 + dc1
			dc1 = dc1 * 0.96
			return s - dc2
		end
	}
end


return FLine 
