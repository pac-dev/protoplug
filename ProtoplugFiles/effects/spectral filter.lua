--[[
name: Spectral Filter
description: graphical spectral filter using fftw
author: osar.fr
--]]

require "include/protoplug"
require "include/Pickle"

stereoFx.init()

-- settings (change these here)
local fftSize = 512
local xPixels = 400
local yPixels = 300

-- open FFTW and define the stuff we need
fftlib = script.ffiLoad("libfftw3.so.3", "libfftw3-3")

ffi.cdef[[
typedef double fftw_complex[2];
void *fftw_plan_dft_r2c_1d(int n, double *in, fftw_complex *out, unsigned int flags);
void *fftw_plan_dft_c2r_1d(int n, fftw_complex *in, double *out, unsigned int flags);
void fftw_execute(void *plan);
]]

-- useful constants
local stepSize = math.floor(fftSize/2)
local cplxSize = stepSize+1
local rescale = 1/fftSize-- no /2 because we use 200% as max

-- global buffers : actual filter and Hann window
local graph = ffi.new ("double[?]", cplxSize)
for i = 0,cplxSize-2 do graph[i] = 0.5 end
graph[cplxSize-1] = 0 -- no one wants DC
local hw  = ffi.new("double[?]", fftSize)
for i = 0,fftSize-1 do
	hw[i] = (1 - math.cos(2*math.pi*i/(fftSize-1)))*rescale
end

local function applyFilter (spectrum)
	for i=0,cplxSize-1 do
		spectrum[i][0] = spectrum[i][0]*graph[i] -- real
		spectrum[i][1] = spectrum[i][1]*graph[i] -- imaginary
		-- do more interesting stuff here :)
	end
end

local function applyWindow (samples)
	for i = 0,fftSize-1 do
		samples[i] = samples[i] * hw[i]
	end
end

-- global working buffers and their fftw plans
local samples = ffi.new("double[?]", fftSize)
local spectrum = ffi.new("fftw_complex[?]", cplxSize)
local r2c = fftlib.fftw_plan_dft_r2c_1d(fftSize, samples, spectrum, 64)
local c2r = fftlib.fftw_plan_dft_c2r_1d(fftSize, spectrum, samples, 64)

-- per-channel buffers
function stereoFx.Channel:init()
	self.inbuf = ffi.new("double[?]", fftSize)
	self.outbuf = ffi.new("double[?]", fftSize)
	self.bufi = 0
end

local function wrap (i)
	return (i>fftSize-1) and i-fftSize or i
end

function stereoFx.Channel:processBlock(s, smax)
	for i = 0,smax do
		self.inbuf[self.bufi] = s[i]
		s[i] = self.outbuf[self.bufi]
		self.outbuf[self.bufi] = 0
		if self.bufi%stepSize==0 then
			for j=0,fftSize-1 do
				samples[j] = self.inbuf[wrap(self.bufi+j)]
			end
			-- revive cdata (inexplicably required, todo narrow down the cause):
			tostring(samples); tostring(spectrum)
			fftlib.fftw_execute(r2c)
			applyFilter (spectrum)
			fftlib.fftw_execute(c2r)
			applyWindow(samples)
			for j=0,fftSize-1 do
				self.outbuf[wrap(self.bufi+j)] =
				 self.outbuf[wrap(self.bufi+j)] + samples[j]
			end
		end
		self.bufi = wrap(self.bufi+1)
	end
end


--			Graphics		 --
local Freqgraph = require "include/gui-extras/freqgraph"
local J = require "include/protojuce"

local fg = Freqgraph {
	title = "Spectral Filter";
	data = graph;
	dataSize = cplxSize-1; -- don't touch the last partial (DC)
}

function gui.paint(g)
	g:fillAll()
	fg:paint(g)
end


--			Save & load		  --
local header = "pac spectral filter 1"

function script.loadData(data)
	-- check data begins with our header
	if string.sub(data, 1, string.len(header)) ~= header then return end
	data = unpickle(string.sub(data, string.len(header)+1, -1))
	-- check string was turned into a table without errors
	if data==nil then return end
	for i=0,cplxSize-1 do
		if data[i] ~= nil then
			graph[i] = data[i]
		end
	end
end

function script.saveData()
	local picktable = {}
	for i=0,cplxSize-1 do
		picktable[i] = graph[i]
	end
	return header..pickle(picktable)
end