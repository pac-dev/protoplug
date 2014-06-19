-- lua utils

local util = {}

-- include cdefs
function util.requireCdef(incpath)
	local incfile = io.open(incpath)
	if incfile==nil then
		error ("can't open include file : "..incpath)
	end
	local incstring = incfile:read "*a"
	incfile:close()
	ffi.cdef (incstring)
end

-- merge in modules or tables in general
function util.merge (src, dst)
	for k,v in pairs(src) do 
		dst[k] = v
	end
end

-- round x to n decimal places
function util.roundDecimal(x, n)
	local p = math.pow(10, n)
	return math.floor(x*p+0.5)/p
end

return util
