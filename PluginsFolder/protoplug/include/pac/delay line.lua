-- delay line 1
-- with dc filter and shitty linear interpolation

-- todo test full float version
-- and possibly pointer arithmetic version

local function blend(a,b,p) return (a*p + b*(1-p)) end

function Line (bufSize)
	local buf = ffi.new("double[?]", bufSize)
	local pos = 0 -- todo int
	local dc1, dc2 = 0, 0
	return {
		goBack = function (dt)
			-- todo assert dt<bufSize
			local fpos = pos - dt
			local ipos1 = math.floor(fpos)
			local ipos2 = ipos1 + 1
			local frac = fpos - ipos1
			if ipos1 < 0 then ipos1 = ipos1 + bufSize end
			if ipos2 < 0 then ipos2 = ipos2 + bufSize end
						if (ipos1)>=bufSize or (ipos1)<0 then error("accessed buf "..(ipos1)) end -- DEBUG
						if (ipos2)>=bufSize or (ipos2)<0 then error("accessed buf "..(ipos2)) end -- DEBUG
			return blend(buf[ipos2], buf[ipos1], frac)
		end;
		push = function (s)
			pos = pos + 1
			if pos >= bufSize then pos = 0 end
			dc1 = dc1 + (s - dc2) * 0.000002
			dc2 = dc2 + dc1
			dc1 = dc1 * 0.96
						if (pos)>=bufSize or (pos)<0 then error("accessed buf "..(pos)) end -- DEBUG
			buf[pos] = s - dc2
		end;
	}
end

return Line
